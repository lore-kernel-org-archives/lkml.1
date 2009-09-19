Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbZISVh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbZISVh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZISVh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:37:57 -0400
Received: from kroah.org ([198.145.64.141]:50890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbZISVhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:37:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/79] tty-ldisc: make /proc/tty/ldiscs use ldisc_ops instead of ldiscs
Date: Sat, 19 Sep 2009 14:36:09 -0700
Message-Id: <1253396244-7885-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

The /proc/tty/ldiscs file is totally and utterly un-interested in the
"struct tty_ldisc" structures, and only cares about the underlying ldisc
operations.

So don't make it create a dummy 'struct ldisc' only to get a pointer to
the operations, and then destroy it.  Instead, we split up the function
'tty_ldisc_try_get()', and create a 'get_ldops()' helper that just looks
up the ldisc operations based on the ldisc number.

That makes the code simpler to read (smaller and more well-defined
helper functions), and allows the /proc functions to avoid creating that
useless dummy only to immediately free it again.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ldisc.c |   65 +++++++++++++++++++++++++++------------------
 1 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index e48af9f..cbfacc0 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -145,6 +145,34 @@ int tty_unregister_ldisc(int disc)
 }
 EXPORT_SYMBOL(tty_unregister_ldisc);
 
+static struct tty_ldisc_ops *get_ldops(int disc)
+{
+	unsigned long flags;
+	struct tty_ldisc_ops *ldops, *ret;
+
+	spin_lock_irqsave(&tty_ldisc_lock, flags);
+	ret = ERR_PTR(-EINVAL);
+	ldops = tty_ldiscs[disc];
+	if (ldops) {
+		ret = ERR_PTR(-EAGAIN);
+		if (try_module_get(ldops->owner)) {
+			ldops->refcount++;
+			ret = ldops;
+		}
+	}
+	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	return ret;
+}
+
+static void put_ldops(struct tty_ldisc_ops *ldops)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty_ldisc_lock, flags);
+	ldops->refcount--;
+	module_put(ldops->owner);
+	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+}
 
 /**
  *	tty_ldisc_try_get	-	try and reference an ldisc
@@ -156,36 +184,21 @@ EXPORT_SYMBOL(tty_unregister_ldisc);
 
 static struct tty_ldisc *tty_ldisc_try_get(int disc)
 {
-	unsigned long flags;
 	struct tty_ldisc *ld;
 	struct tty_ldisc_ops *ldops;
-	int err = -EINVAL;
 
 	ld = kmalloc(sizeof(struct tty_ldisc), GFP_KERNEL);
 	if (ld == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_irqsave(&tty_ldisc_lock, flags);
-	ld->ops = NULL;
-	ldops = tty_ldiscs[disc];
-	/* Check the entry is defined */
-	if (ldops) {
-		/* If the module is being unloaded we can't use it */
-		if (!try_module_get(ldops->owner))
-			err = -EAGAIN;
-		else {
-			/* lock it */
-			ldops->refcount++;
-			ld->ops = ldops;
-			atomic_set(&ld->users, 1);
-			err = 0;
-		}
-	}
-	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	if (err) {
+	ldops = get_ldops(disc);
+	if (IS_ERR(ldops)) {
 		kfree(ld);
-		return ERR_PTR(err);
+		return ERR_CAST(ldops);
 	}
+
+	ld->ops = ldops;
+	atomic_set(&ld->users, 1);
 	return ld;
 }
 
@@ -234,13 +247,13 @@ static void tty_ldiscs_seq_stop(struct seq_file *m, void *v)
 static int tty_ldiscs_seq_show(struct seq_file *m, void *v)
 {
 	int i = *(loff_t *)v;
-	struct tty_ldisc *ld;
+	struct tty_ldisc_ops *ldops;
 
-	ld = tty_ldisc_try_get(i);
-	if (IS_ERR(ld))
+	ldops = get_ldops(i);
+	if (IS_ERR(ldops))
 		return 0;
-	seq_printf(m, "%-10s %2d\n", ld->ops->name ? ld->ops->name : "???", i);
-	put_ldisc(ld);
+	seq_printf(m, "%-10s %2d\n", ldops->name ? ldops->name : "???", i);
+	put_ldops(ldops);
 	return 0;
 }
 
-- 
1.6.4.2

