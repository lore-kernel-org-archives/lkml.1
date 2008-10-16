Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYJPRWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYJPRWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYJPRO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:29 -0400
Received: from kroah.org ([198.145.64.141]:46971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756147AbYJPRO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/46] usb gadget: link fixes for storage gadget
Date: Thu, 16 Oct 2008 10:10:21 -0700
Message-Id: <1224177047-11859-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Change how the file storage gadget driver builds:  don't
use separate compilation, since it works poorly when key
parts are library code (with init sections etc).  Instead
be as close as we can to "gcc --combine ...".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/Makefile       |    3 +--
 drivers/usb/gadget/file_storage.c |   12 ++++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 99956b7..736d58f 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -29,8 +29,7 @@ g_ether-objs			:= ether.o u_ether.o f_subset.o f_ecm.o $(C_UTILS)
 g_serial-objs			:= serial.o
 g_midi-objs			:= gmidi.o
 gadgetfs-objs			:= inode.o
-g_file_storage-objs		:= file_storage.o usbstring.o config.o \
-					epautoconf.o
+g_file_storage-objs		:= file_storage.o
 g_printer-objs			:= printer.o
 g_cdc-objs			:= cdc2.o u_ether.o f_ecm.o \
 					u_serial.o f_acm.o $(C_UTILS)
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index ea2c31d..0c632d2 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -245,6 +245,18 @@
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
 /*-------------------------------------------------------------------------*/
 
 #define DRIVER_DESC		"File-backed Storage Gadget"
-- 
1.6.0.2

