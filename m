Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZHCXAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZHCXAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZHCXAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:00:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbZHCXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:00:35 -0400
Date: Mon, 3 Aug 2009 16:00:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/2] tty-ldisc: make /proc/tty/ldiscs use ldisc_ops instead
 of ldiscs
In-Reply-To: <alpine.LFD.2.01.0908031555230.3270@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908031558240.3270@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by> <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain> <20090802190514.GA3278@localdomain.by> <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain> <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain> <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain> <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain> <20090803181811.GA15848@kroah.com>
 <20090803221651.GA3122@localdomain.by> <alpine.LFD.2.01.0908031521300.3208@localhost.localdomain> <alpine.LFD.2.01.0908031555230.3270@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Aug 2009 15:11:29 -0700
Subject: [PATCH 4/2] tty-ldisc: make /proc/tty/ldiscs use ldisc_ops instead of ldiscs

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
---

Pure cleanup. This adds a bit more lines than it removes, but that's 
just due to comments and just the new function declarations from splitting 
things up. It doesn't really add any code.

And the next patch will actually remove code, and relies on this cleanup.

 drivers/char/tty_ldisc.c |   65 +++++++++++++++++++++++++++------------------
 1 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 1733d34..8106514 100644
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
1.6.4.21.g73b866

