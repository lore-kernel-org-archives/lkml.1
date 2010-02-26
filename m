Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935382Ab0BZLr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935178Ab0BZLr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:47:56 -0500
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] hvc_console: Fix a race between hvc_close and hvc_remove
Date: Fri, 26 Feb 2010 17:16:26 +0530
Message-Id: <1267184786-4377-1-git-send-email-amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan pointed out a race in the code where hvc_remove is invoked. The
recent virtio_console work is the first user of hvc_remove().

Alan describes it thus:

The hvc_console assumes that a close and remove call can't occur at the
same time.

In addition tty_hangup(tty) is problematic as tty_hangup is asynchronous
itself....

So this can happen

        hvc_close                               hvc_remove
        hung up ? - no
                                                lock
                                                tty = hp->tty
                                                unlock
        lock
	hp->tty = NULL
        unlock
	notify del
        kref_put the hvc struct
        close completes
        tty is destroyed
                                                tty_hangup dead tty
                                                tty->ops will be NULL
                                                NULL->...

This patch adds some tty krefs and also converts to using tty_vhangup()
before putting the tty kref.

Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linuxppc-dev@ozlabs.org
CC: Rusty Russell <rusty@rustcorp.com.au>
---

I can't be sure if this is all that's needed. tty people, please take
a look!

 drivers/char/hvc_console.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index d8dac58..3983e32 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -106,6 +106,7 @@ static struct hvc_struct *hvc_get_by_index(int index)
 		spin_lock_irqsave(&hp->lock, flags);
 		if (hp->index == index) {
 			kref_get(&hp->kref);
+			tty_kref_get(hp->tty);
 			spin_unlock_irqrestore(&hp->lock, flags);
 			spin_unlock(&hvc_structs_lock);
 			return hp;
@@ -390,6 +391,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 	}
 
 	kref_put(&hp->kref, destroy_hvc_struct);
+	tty_kref_put(tty);
 }
 
 static void hvc_hangup(struct tty_struct *tty)
@@ -806,6 +808,7 @@ int hvc_remove(struct hvc_struct *hp)
 	unsigned long flags;
 	struct tty_struct *tty;
 
+	tty_kref_get(hp->tty);
 	spin_lock_irqsave(&hp->lock, flags);
 	tty = hp->tty;
 
@@ -830,7 +833,9 @@ int hvc_remove(struct hvc_struct *hp)
 	 * cleaned up the hvc_struct.
 	 */
 	if (tty)
-		tty_hangup(tty);
+		tty_vhangup(tty);
+
+	tty_kref_put(hp->tty);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hvc_remove);
-- 
1.6.2.5

