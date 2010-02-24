Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0BXPi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:38:27 -0500
Received: from mail2.tundra.com ([142.46.200.162]:44324 "EHLO mx2.tundra.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755674Ab0BXPi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:38:26 -0500
X-ASG-Debug-ID: 1267025903-555c01050000-xx1T2L
X-Barracuda-URL: http://142.46.200.162:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: alexb@tundra.com
Date: Wed, 24 Feb 2010 10:37:51 -0500
From: Alexandre Bounine <alexb@tundra.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       thomas.moll@sysgo.com, thomas.moll.ext@nsn.com, abounine@idt.com
X-ASG-Orig-Subj: [PATCH 7/7] powerpc/85xx: Fix the RapidIO maintenance access functions
Subject: [PATCH 7/7] powerpc/85xx: Fix the RapidIO maintenance access functions
Message-ID: <20100224153751.GG13661@kaneng01.tundra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Barracuda-Connect: UNKNOWN[142.46.200.189]
X-Barracuda-Start-Time: 1267025903
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at tundra.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Moll <thomas.moll@sysgo.com>

Fix the maintenance access functions to farend RapidIO devices.
1. Fixed shift of the given offset, to open the maintenance window
2. Mask offset to limit access to the opened maintenance window
3. Added extended destid part to rowtear register, required for 16bit mode

For easier handling of the access routines, the access was limited to aligned
memory regions. This should be no problem because all registers are 32bit
wide.

Signed-off-by: Thomas Moll <thomas.moll@sysgo.com>
---

 fsl_rio.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff -purN linux-base/arch/powerpc/sysdev/fsl_rio.c linux-new/arch/powerpc/sysdev/fsl_rio.c
--- linux-base/arch/powerpc/sysdev/fsl_rio.c	2010-02-24 08:37:05.000000000 +0100
+++ linux-new/arch/powerpc/sysdev/fsl_rio.c	2010-02-24 08:45:27.000000000 +0100
@@ -1,6 +1,10 @@
 /*
  * Freescale MPC85xx/MPC86xx RapidIO support
  *
+ * Copyright 2009 Sysgo AG
+ * Thomas Moll <thomas.moll@sysgo.com>
+ * - fixed maintenance access routines, check for aligned access
+ *
  * Copyright 2009 Integrated Device Technology, Inc.
  * Alex Bounine <alexandre.bounine@idt.com>
  * - Added Port-Write message handling
@@ -370,10 +374,17 @@ fsl_rio_config_read(struct rio_mport *mp
 	pr_debug
 	    ("fsl_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
 	     index, destid, hopcount, offset, len);
+
+	/* 16MB maintenance window possible */
+	/* allow only aligned access to maintenance registers */
+	if (offset > (0x1000000 - len) || !IS_ALIGNED(offset, len))
+		return -EINVAL;
+
 	out_be32(&priv->maint_atmu_regs->rowtar,
-		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
+		 (destid << 22) | (hopcount << 12) | (offset >> 12));
+	out_be32(&priv->maint_atmu_regs->rowtear,  (destid >> 10));
 
-	data = (u8 *) priv->maint_win + offset;
+	data = (u8 *) priv->maint_win + (offset & 0x3FFFFF);
 	switch (len) {
 	case 1:
 		__fsl_read_rio_config(rval, data, err, "lbz");
@@ -381,9 +392,11 @@ fsl_rio_config_read(struct rio_mport *mp
 	case 2:
 		__fsl_read_rio_config(rval, data, err, "lhz");
 		break;
-	default:
+	case 4:
 		__fsl_read_rio_config(rval, data, err, "lwz");
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (err) {
@@ -418,10 +431,17 @@ fsl_rio_config_write(struct rio_mport *m
 	pr_debug
 	    ("fsl_rio_config_write: index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
 	     index, destid, hopcount, offset, len, val);
+
+	/* 16MB maintenance windows possible */
+	/* allow only aligned access to maintenance registers */
+	if (offset > (0x1000000 - len) || !IS_ALIGNED(offset, len))
+		return -EINVAL;
+
 	out_be32(&priv->maint_atmu_regs->rowtar,
-		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
+		 (destid << 22) | (hopcount << 12) | (offset >> 12));
+	out_be32(&priv->maint_atmu_regs->rowtear,  (destid >> 10));
 
-	data = (u8 *) priv->maint_win + offset;
+	data = (u8 *) priv->maint_win + (offset & 0x3FFFFF);
 	switch (len) {
 	case 1:
 		out_8((u8 *) data, val);
@@ -429,9 +449,11 @@ fsl_rio_config_write(struct rio_mport *m
 	case 2:
 		out_be16((u16 *) data, val);
 		break;
-	default:
+	case 4:
 		out_be32((u32 *) data, val);
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;

---

Important Notice: This message is intended for the use of the individual to whom it is addressed and may contain information which is privileged, confidential and/or exempt from disclosure under applicable law. If the reader of this message is not the intended recipient, or is not the employee or agent responsible for delivering the message to the intended recipient, you are hereby notified that any dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this communication in error, please notify the sender immediately by telephone or return e-mail and delete the original message from your systems. Thank you. 

