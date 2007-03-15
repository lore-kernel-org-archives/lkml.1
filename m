Return-Path: <linux-kernel-owner+w=401wt.eu-S1422982AbXCOWXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422982AbXCOWXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422977AbXCOWT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:29 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33717 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 25 of 33] IB/ipath - On unrecoverable errors, force link dow,
	LEDs off
X-Mercurial-Node: e9895e2ad504a2590b0943c037d1fa5f9568fda3
Message-Id: <e9895e2ad504a2590b09.1173995109@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:09 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID e9895e2ad504a2590b0943c037d1fa5f9568fda3
# Parent  3e81a6b18b42bbe6dffab382fb26d754dfdf83a1
IB/ipath - On unrecoverable errors, force link dow, LEDs off

If the chip is no longer usable, LEDs should be turned off so system
can be found easily in the cluster.

Also some minor reorganizing so both chips print hardware error message
at same point and only if there were unrecovered errors

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 3e81a6b18b42 -r e9895e2ad504 drivers/infiniband/hw/ipath/ipath_iba6110.c
--- a/drivers/infiniband/hw/ipath/ipath_iba6110.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_iba6110.c	Thu Mar 15 14:34:25 2007 -0700
@@ -42,6 +42,9 @@
 
 #include "ipath_kernel.h"
 #include "ipath_registers.h"
+
+static void ipath_setup_ht_setextled(struct ipath_devdata *, u64, u64);
+
 
 /*
  * This lists the InfiniPath registers, in the actual chip layout.
@@ -572,9 +575,14 @@ static void ipath_ht_handle_hwerrors(str
 		 * make the complaint once, in case it's stuck
 		 * or recurring, and we get here multiple
 		 * times.
+		 * force link down, so switch knows, and
+		 * LEDs are turned off
 		 */
-		ipath_dev_err(dd, "%s hardware error\n", msg);
 		if (dd->ipath_flags & IPATH_INITTED) {
+			ipath_set_linkstate(dd, IPATH_IB_LINKDOWN);
+			ipath_setup_ht_setextled(dd, 
+				INFINIPATH_IBCS_L_STATE_DOWN,
+				INFINIPATH_IBCS_LT_STATE_DISABLED);
 			ipath_dev_err(dd, "Fatal Hardware Error (freeze "
 					  "mode), no longer usable, SN %.16s\n",
 					  dd->ipath_serial);
@@ -592,6 +600,8 @@ static void ipath_ht_handle_hwerrors(str
 	}
 	else
 		*msg = 0; /* recovered from all of them */
+	if (*msg)
+		ipath_dev_err(dd, "%s hardware error\n", msg);
 	if (isfatal && !ipath_diag_inuse && dd->ipath_freezemsg)
 		/*
 		 * for status file; if no trailing brace is copied,
diff -r 3e81a6b18b42 -r e9895e2ad504 drivers/infiniband/hw/ipath/ipath_iba6120.c
--- a/drivers/infiniband/hw/ipath/ipath_iba6120.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_iba6120.c	Thu Mar 15 14:34:25 2007 -0700
@@ -42,6 +42,8 @@
 
 #include "ipath_kernel.h"
 #include "ipath_registers.h"
+
+static void ipath_setup_pe_setextled(struct ipath_devdata *, u64, u64);
 
 /*
  * This file contains all the chip-specific register information and
@@ -407,8 +409,14 @@ static void ipath_pe_handle_hwerrors(str
 			 * if any set that we aren't ignoring only make the
 			 * complaint once, in case it's stuck or recurring,
 			 * and we get here multiple times
+			 * Force link down, so switch knows, and
+			 * LEDs are turned off
 			 */
 			if (dd->ipath_flags & IPATH_INITTED) {
+				ipath_set_linkstate(dd, IPATH_IB_LINKDOWN);
+				ipath_setup_pe_setextled(dd, 
+					INFINIPATH_IBCS_L_STATE_DOWN,
+					INFINIPATH_IBCS_LT_STATE_DISABLED);
 				ipath_dev_err(dd, "Fatal Hardware Error (freeze "
 					      "mode), no longer usable, SN %.16s\n",
 						  dd->ipath_serial);
@@ -482,7 +490,8 @@ static void ipath_pe_handle_hwerrors(str
 				 dd->ipath_hwerrmask);
 	}
 
-	ipath_dev_err(dd, "%s hardware error\n", msg);
+	if (*msg)
+		ipath_dev_err(dd, "%s hardware error\n", msg);
 	if (isfatal && !ipath_diag_inuse && dd->ipath_freezemsg) {
 		/*
 		 * for /sys status file ; if no trailing } is copied, we'll
