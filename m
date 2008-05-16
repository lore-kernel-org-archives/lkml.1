Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbYEPTLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbYEPTLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763165AbYEPTLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:11:42 -0400
Received: from mx1.riseup.net ([204.13.164.18]:45759 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763914AbYEPTLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:11:41 -0400
Date: Fri, 16 May 2008 21:11:33 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: ecashin@coraid.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] ATA over Ethernet: Convert emsgs_sema in a completion
Message-ID: <20080516191133.GI24569@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	ecashin@coraid.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATA over Ethernet: The semaphore emsgs_sema is used for signaling an
event, convert it in a completion.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index e8e60e7..d0ffe63 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -6,6 +6,7 @@
 
 #include <linux/hdreg.h>
 #include <linux/blkdev.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include "aoe.h"
 
@@ -35,7 +36,7 @@ struct ErrMsg {
 
 static struct ErrMsg emsgs[NMSG];
 static int emsgs_head_idx, emsgs_tail_idx;
-static struct semaphore emsgs_sema;
+static struct completion emsgs_comp;
 static spinlock_t emsgs_lock;
 static int nblocked_emsgs_readers;
 static struct class *aoe_class;
@@ -140,7 +141,7 @@ bail:		spin_unlock_irqrestore(&emsgs_lock, flags);
 	spin_unlock_irqrestore(&emsgs_lock, flags);
 
 	if (nblocked_emsgs_readers)
-		up(&emsgs_sema);
+		complete(&emsgs_comp);
 }
 
 static ssize_t
@@ -216,7 +217,7 @@ aoechr_read(struct file *filp, char __user *buf, size_t cnt, loff_t *off)
 
 		spin_unlock_irqrestore(&emsgs_lock, flags);
 
-		n = down_interruptible(&emsgs_sema);
+		n = wait_for_completion_interruptible(&emsgs_comp);
 
 		spin_lock_irqsave(&emsgs_lock, flags);
 
@@ -264,7 +265,7 @@ aoechr_init(void)
 		printk(KERN_ERR "aoe: can't register char device\n");
 		return n;
 	}
-	sema_init(&emsgs_sema, 0);
+	init_completion(&emsgs_comp);
 	spin_lock_init(&emsgs_lock);
 	aoe_class = class_create(THIS_MODULE, "aoe");
 	if (IS_ERR(aoe_class)) {

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

             You must have a plan. If you don't have a plan,
               you'll become part of somebody else's plan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
