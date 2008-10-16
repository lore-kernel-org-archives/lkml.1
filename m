Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYJPRWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYJPRWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYJPRO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:29 -0400
Received: from kroah.org ([198.145.64.141]:46968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755310AbYJPRO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/46] usb gadget: link fixes for printer gadget
Date: Thu, 16 Oct 2008 10:10:20 -0700
Message-Id: <1224177047-11859-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Change how the printer gadget driver builds:  don't use
separate compilation, since it works poorly when key parts
are library code (with init sections etc).  Instead be as
close as we can to "gcc --combine ...".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/Makefile  |    3 +--
 drivers/usb/gadget/printer.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index c47204f..99956b7 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -31,8 +31,7 @@ g_midi-objs			:= gmidi.o
 gadgetfs-objs			:= inode.o
 g_file_storage-objs		:= file_storage.o usbstring.o config.o \
 					epautoconf.o
-g_printer-objs			:= printer.o usbstring.o config.o \
-					epautoconf.o
+g_printer-objs			:= printer.o
 g_cdc-objs			:= cdc2.o u_ether.o f_ecm.o \
 					u_serial.o f_acm.o $(C_UTILS)
 
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 7a8d4a1..2b3b9e1 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -53,6 +53,20 @@
 
 #include "gadget_chips.h"
 
+
+/*
+ * Kbuild is not very cooperative with respect to linking separately
+ * compiled library objects into one module.  So for now we won't use
+ * separate compilation ... ensuring init/exit sections work to shrink
+ * the runtime footprint, and giving us at least some parts of what
+ * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
+ */
+#include "usbstring.c"
+#include "config.c"
+#include "epautoconf.c"
+
+/*-------------------------------------------------------------------------*/
+
 #define DRIVER_DESC		"Printer Gadget"
 #define DRIVER_VERSION		"2007 OCT 06"
 
-- 
1.6.0.2

