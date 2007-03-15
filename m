Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXCOWYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXCOWYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbXCOWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:23:31 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33701 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbXCOWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 20 of 33] IB/ipath - call free_irq on chip specific
	initialization failure
X-Mercurial-Node: 8a013b707785accfd71589334bbf8e4029ffa892
Message-Id: <8a013b707785accfd715.1173995104@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:04 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Arthur Jones <arthur.jones@qlogic.com>
# Date 1173994465 25200
# Node ID 8a013b707785accfd71589334bbf8e4029ffa892
# Parent  c96d13efde155eb60dc0eca0bd56e81ecd36281b
IB/ipath - call free_irq on chip specific initialization failure

In initialization, if we bailed at chip specific initialization, we
forgot to clean up the irq we had requested.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r c96d13efde15 -r 8a013b707785 drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:25 2007 -0700
@@ -486,7 +486,7 @@ static int __devinit ipath_init_one(stru
 
 	ret = ipath_init_chip(dd, 0);	/* do the chip-specific init */
 	if (ret)
-		goto bail_iounmap;
+		goto bail_irqsetup;
 
 	ret = ipath_enable_wc(dd);
 
@@ -504,6 +504,9 @@ static int __devinit ipath_init_one(stru
 	ipath_register_ib_device(dd);
 
 	goto bail;
+
+bail_irqsetup:
+	if (pdev->irq) free_irq(pdev->irq, dd);
 
 bail_iounmap:
 	iounmap((volatile void __iomem *) dd->ipath_kregbase);
