Return-Path: <linux-kernel-owner+w=401wt.eu-S1422832AbXCOWVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422832AbXCOWVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933930AbXCOWTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:19:31 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33718 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 27 of 33] IB/ipath - cleaner shutdown at driver unload,
	disable IB link earlier
X-Mercurial-Node: fddf5d03720ca586054b66d250d84233bdb3bf86
Message-Id: <fddf5d03720ca586054b.1173995111@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:11 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994465 25200
# Node ID fddf5d03720ca586054b66d250d84233bdb3bf86
# Parent  284c34f2adddd16f7cb4fe48a2f6fbe9ad4beea5
IB/ipath - cleaner shutdown at driver unload, disable IB link earlier

Moved the code that shuts down the IB link earlier in the unload process, to
be sure no new packets can arrive while we are unloading.

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 284c34f2addd -r fddf5d03720c drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
@@ -536,8 +536,6 @@ static void __devexit cleanup_device(str
 {
 	int port;
 
-	ipath_shutdown_device(dd);
-
 	if (*dd->ipath_statusp & IPATH_STATUS_CHIP_PRESENT) {
 		/* can't do anything more with chip; needs re-init */
 		*dd->ipath_statusp &= ~IPATH_STATUS_CHIP_PRESENT;
@@ -633,6 +631,12 @@ static void __devexit ipath_remove_one(s
 	struct ipath_devdata *dd = pci_get_drvdata(pdev);
 
 	ipath_cdbg(VERBOSE, "removing, pdev=%p, dd=%p\n", pdev, dd);
+
+	/*
+	 * disable the IB link early, to be sure no new packets arrive, which 
+	 * complicates the shutdown process
+	 */
+	ipath_shutdown_device(dd);
 
 	if (dd->verbs_dev)
 		ipath_unregister_ib_device(dd->verbs_dev);
