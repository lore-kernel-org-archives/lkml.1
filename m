Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYJPRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYJPRV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYJPROZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:25 -0400
Received: from kroah.org ([198.145.64.141]:46957 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756141AbYJPROW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/46] usb gadget: link fixes for serial gadget
Date: Thu, 16 Oct 2008 10:10:17 -0700
Message-Id: <1224177047-11859-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Change how the serial gadget driver builds:  don't use
separate compilation, since it works poorly when key parts
are library code (with init sections etc).  Instead be as
close as we can to "gcc --combine ...".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/Makefile |    2 +-
 drivers/usb/gadget/serial.c |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index fcb5cb9..853dd02 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -26,7 +26,7 @@ C_UTILS =	composite.o usbstring.o config.o epautoconf.o
 
 g_zero-objs			:= zero.o f_sourcesink.o f_loopback.o $(C_UTILS)
 g_ether-objs			:= ether.o u_ether.o f_subset.o f_ecm.o $(C_UTILS)
-g_serial-objs			:= serial.o u_serial.o f_acm.o f_serial.o $(C_UTILS)
+g_serial-objs			:= serial.o
 g_midi-objs			:= gmidi.o usbstring.o config.o epautoconf.o
 gadgetfs-objs			:= inode.o
 g_file_storage-objs		:= file_storage.o usbstring.o config.o \
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index b3699af..3faa7a7 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -30,6 +30,24 @@
 
 /*-------------------------------------------------------------------------*/
 
+/*
+ * Kbuild is not very cooperative with respect to linking separately
+ * compiled library objects into one module.  So for now we won't use
+ * separate compilation ... ensuring init/exit sections work to shrink
+ * the runtime footprint, and giving us at least some parts of what
+ * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
+ */
+#include "composite.c"
+#include "usbstring.c"
+#include "config.c"
+#include "epautoconf.c"
+
+#include "f_acm.c"
+#include "f_serial.c"
+#include "u_serial.c"
+
+/*-------------------------------------------------------------------------*/
+
 /* Thanks to NetChip Technologies for donating this product ID.
 *
 * DO NOT REUSE THESE IDs with a protocol-incompatible driver!!  Ever!!
-- 
1.6.0.2

