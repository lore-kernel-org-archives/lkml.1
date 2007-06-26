Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbXFZTFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbXFZTFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbXFZTFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:30 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25144 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757506AbXFZTF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:29 -0400
Message-Id: <9f3cb6efbd46aab51f3db7ab219fdbf3286698bd.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:11 -0400
Subject: [PATCH 05/12] eliminate goto and improve readability
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Richter suggested eliminating this goto.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoechr.c |   69 +++++++++++++++++++++----------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 9026c44..511f995 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -191,52 +191,51 @@ aoechr_read(struct file *filp, char __user *buf, size_t cnt, loff_t *off)
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
1.5.2.1

