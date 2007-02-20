Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXBTWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXBTWa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030514AbXBTWa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:30:58 -0500
Received: from lx1.pxnet.com ([195.227.45.3]:55935 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030510AbXBTWaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:30:55 -0500
Date: Tue, 20 Feb 2007 23:29:37 +0100
Message-Id: <200702202229.l1KMTbhd003559@lx1.pxnet.com>
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH] drivers/isdn/gigaset: build asyncdata.o into the gigaset module (v2)
To: Andrew Morton <akpm@osdl.org>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>, Adrian Bunk <bunk@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a) Fix link error from double inclusion of asyncdata.o when building both
M10x drivers into the kernel, by moving it into the common part.

b) Correct the rule for building the common part into the kernel when
some or all hardware specific parts are built as modules.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>

---

This patch is based on 2.6.20-git14. Please replace patch
drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module.patch
in the -mm tree by this.

 Makefile    |   13 +++++++------
 asyncdata.c |    7 ++-----
 2 files changed, 9 insertions(+), 11 deletions(-)

diff -up linux-2.6.20-work/drivers/isdn/gigaset/asyncdata.c local/drivers/isdn/gigaset/asyncdata.c
--- linux-2.6.20-work/drivers/isdn/gigaset/asyncdata.c	2007-02-07 23:10:32.000000000 +0100
+++ local/drivers/isdn/gigaset/asyncdata.c	2007-02-18 15:47:24.000000000 +0100
@@ -13,11 +13,6 @@
  * =====================================================================
  */
 
-/* not set by Kbuild when building both ser_gigaset and usb_gigaset */
-#ifndef KBUILD_MODNAME
-#define KBUILD_MODNAME "asy_gigaset"
-#endif
-
 #include "gigaset.h"
 #include <linux/crc-ccitt.h>
 #include <linux/bitrev.h>
@@ -444,6 +439,7 @@ nextbyte:
 		atomic_set(&inbuf->head, head);
 	}
 }
+EXPORT_SYMBOL_GPL(gigaset_m10x_input);
 
 
 /* == data output ========================================================== */
@@ -591,3 +587,4 @@ int gigaset_m10x_send_skb(struct bc_stat
 
 	return len;	/* ok so far */
 }
+EXPORT_SYMBOL_GPL(gigaset_m10x_send_skb);
diff -up linux-2.6.20-work/drivers/isdn/gigaset/Makefile local/drivers/isdn/gigaset/Makefile
--- linux-2.6.20-work/drivers/isdn/gigaset/Makefile	2007-02-05 19:03:36.000000000 +0100
+++ local/drivers/isdn/gigaset/Makefile	2007-02-18 15:50:39.000000000 +0100
@@ -1,8 +1,9 @@
-gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o
-usb_gigaset-y := usb-gigaset.o asyncdata.o
+gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o asyncdata.o
+usb_gigaset-y := usb-gigaset.o
+ser_gigaset-y := ser-gigaset.o
 bas_gigaset-y := bas-gigaset.o isocdata.o
-ser_gigaset-y := ser-gigaset.o asyncdata.o
 
-obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o
+obj-$(CONFIG_ISDN_DRV_GIGASET) += gigaset.o
+obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o
+obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o
+obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o

-- 
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- In theory, there is no difference between theory and practice.
  In practice, there is.
