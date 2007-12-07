Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbXLGRve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbXLGRve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbXLGRuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:50:16 -0500
Received: from www2.coile-labs.com ([65.14.39.133]:21117 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756137AbXLGRuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:50:13 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 05/13] eliminate goto and improve readability
Date: Fri,  7 Dec 2007 12:48:03 -0500
Message-Id: <1197049691-27462-5-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
References: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Richter suggested eliminating this goto.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |   69 +++++++++++++++++++++----------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 1a5c4b5..4a3889d 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -194,52 +194,51 @@ aoechr_read(struct file *filp, char __user *buf, size_t cnt, loff_t *off)
 	ulong flags;
 
 	n = (unsigned long) filp->private_data;
-	switch (n) {
-	case MINOR_ERR:
-		spin_lock_irqsave(&emsgs_lock, flags);
-loop:
-		em = emsgs + emsgs_head_idx;
-		if ((em->flags & EMFL_VALID) == 0) {
-			if (filp->f_flags & O_NDELAY) {
-				spin_unlock_irqrestore(&emsgs_lock, flags);
-				return -EAGAIN;
-			}
-			nblocked_emsgs_readers++;
+	if (n != MINOR_ERR)
+		return -EFAULT;
+
+	spin_lock_irqsave(&emsgs_lock, flags);
 
+	for (;;) {
+		em = emsgs + emsgs_head_idx;
+		if ((em->flags & EMFL_VALID) != 0)
+			break;
+		if (filp->f_flags & O_NDELAY) {
 			spin_unlock_irqrestore(&emsgs_lock, flags);
+			return -EAGAIN;
+		}
+		nblocked_emsgs_readers++;
+
+		spin_unlock_irqrestore(&emsgs_lock, flags);
 
-			n = down_interruptible(&emsgs_sema);
+		n = down_interruptible(&emsgs_sema);
 
-			spin_lock_irqsave(&emsgs_lock, flags);
+		spin_lock_irqsave(&emsgs_lock, flags);
 
-			nblocked_emsgs_readers--;
+		nblocked_emsgs_readers--;
 
-			if (n) {
-				spin_unlock_irqrestore(&emsgs_lock, flags);
-				return -ERESTARTSYS;
-			}
-			goto loop;
-		}
-		if (em->len > cnt) {
+		if (n) {
 			spin_unlock_irqrestore(&emsgs_lock, flags);
-			return -EAGAIN;
+			return -ERESTARTSYS;
 		}
-		mp = em->msg;
-		len = em->len;
-		em->msg = NULL;
-		em->flags &= ~EMFL_VALID;
+	}
+	if (em->len > cnt) {
+		spin_unlock_irqrestore(&emsgs_lock, flags);
+		return -EAGAIN;
+	}
+	mp = em->msg;
+	len = em->len;
+	em->msg = NULL;
+	em->flags &= ~EMFL_VALID;
 
-		emsgs_head_idx++;
-		emsgs_head_idx %= ARRAY_SIZE(emsgs);
+	emsgs_head_idx++;
+	emsgs_head_idx %= ARRAY_SIZE(emsgs);
 
-		spin_unlock_irqrestore(&emsgs_lock, flags);
+	spin_unlock_irqrestore(&emsgs_lock, flags);
 
-		n = copy_to_user(buf, mp, len);
-		kfree(mp);
-		return n == 0 ? len : -EFAULT;
-	default:
-		return -EFAULT;
-	}
+	n = copy_to_user(buf, mp, len);
+	kfree(mp);
+	return n == 0 ? len : -EFAULT;
 }
 
 static const struct file_operations aoe_fops = {
-- 
1.5.3.4

