Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYJPRV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYJPRV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYJPRO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:28 -0400
Received: from kroah.org ([198.145.64.141]:46965 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756144AbYJPROZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/46] usb gadget: link fixes for MIDI gadget
Date: Thu, 16 Oct 2008 10:10:19 -0700
Message-Id: <1224177047-11859-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Change how the MIDI gadget driver builds:  don't use separate
compilation, since it works poorly when key parts are library
code (with init sections etc).  Instead be as close as we can
to "gcc --combine ...".

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/gadget/Makefile |    2 +-
 drivers/usb/gadget/gmidi.c  |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 55f5891..c47204f 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -27,7 +27,7 @@ C_UTILS =	composite.o usbstring.o config.o epautoconf.o
 g_zero-objs			:= zero.o
 g_ether-objs			:= ether.o u_ether.o f_subset.o f_ecm.o $(C_UTILS)
 g_serial-objs			:= serial.o
-g_midi-objs			:= gmidi.o usbstring.o config.o epautoconf.o
+g_midi-objs			:= gmidi.o
 gadgetfs-objs			:= inode.o
 g_file_storage-objs		:= file_storage.o usbstring.o config.o \
 					epautoconf.o
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index ea8651e..6eee760 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -35,6 +35,21 @@
 
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
+
 MODULE_AUTHOR("Ben Williamson");
 MODULE_LICENSE("GPL v2");
 
-- 
1.6.0.2

