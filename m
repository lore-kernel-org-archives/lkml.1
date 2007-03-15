Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXCOW0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXCOW0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbXCOWXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:23:23 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33706 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 33] IB/ipath - add ability to set and clear IB local
	loopback
X-Mercurial-Node: b1d05f3486f8bba1dd3c5cbca39f06a5e1b3d6fb
Message-Id: <b1d05f3486f8bba1dd3c.1173995085@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:45 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bos@pathscale.com>
# Date 1173994464 25200
# Node ID b1d05f3486f8bba1dd3c5cbca39f06a5e1b3d6fb
# Parent  0d37971d4ab0c8b6f7a8f6e8222112321982498f
IB/ipath - add ability to set and clear IB local loopback

This is a sticky state.  It is useful for diagnosing problems with boards
versus cable/switch problems.

Signed-off-by: Dave Olson <dave.olson@qlogic.com>
Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 0d37971d4ab0 -r b1d05f3486f8 drivers/infiniband/hw/ipath/ipath_common.h
--- a/drivers/infiniband/hw/ipath/ipath_common.h	Wed Mar 14 17:53:43 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_common.h	Thu Mar 15 14:34:24 2007 -0700
@@ -78,6 +78,8 @@
 #define IPATH_IB_LINKINIT		3
 #define IPATH_IB_LINKDOWN_SLEEP		4
 #define IPATH_IB_LINKDOWN_DISABLE	5
+#define IPATH_IB_LINK_LOOPBACK	6 /* enable local loopback */
+#define IPATH_IB_LINK_EXTERNAL	7 /* normal, disable local loopback */
 
 /*
  * stats maintained by the driver.  For now, at least, this is global
diff -r 0d37971d4ab0 -r b1d05f3486f8 drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Wed Mar 14 17:53:43 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:24 2007 -0700
@@ -1662,6 +1662,22 @@ int ipath_set_linkstate(struct ipath_dev
 		lstate = IPATH_LINKACTIVE;
 		break;
 
+	case IPATH_IB_LINK_LOOPBACK:
+		dev_info(&dd->pcidev->dev, "Enabling IB local loopback\n");
+		dd->ipath_ibcctrl |= INFINIPATH_IBCC_LOOPBACK;
+		ipath_write_kreg(dd, dd->ipath_kregs->kr_ibcctrl,
+				 dd->ipath_ibcctrl);
+		ret = 0;
+		goto bail; // no state change to wait for
+
+	case IPATH_IB_LINK_EXTERNAL:
+		dev_info(&dd->pcidev->dev, "Disabling IB local loopback (normal)\n");
+		dd->ipath_ibcctrl &= ~INFINIPATH_IBCC_LOOPBACK;
+		ipath_write_kreg(dd, dd->ipath_kregs->kr_ibcctrl,
+				 dd->ipath_ibcctrl);
+		ret = 0;
+		goto bail; // no state change to wait for
+
 	default:
 		ipath_dbg("Invalid linkstate 0x%x requested\n", newstate);
 		ret = -EINVAL;
