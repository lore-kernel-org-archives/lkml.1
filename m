Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573Ab0AQUao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0AQUao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 15:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284Ab0AQUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 15:30:43 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:43808 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0AQUam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 15:30:42 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-scsi@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: allow SCSI_WAIT_SCAN to be disabled in embedded systems
Date: Sun, 17 Jan 2010 18:27:53 -0200
Message-Id: <1263760073-7018-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know scsi_wait_scan is too little and is always built as a module,
but:

* This allows it to be disabled in cases that modules are enabled but
all configuration is built-in. It will not surprise users that a module
has been built.

* It still does not surprise users that have disabled it by accident,
because they only have a choice if they've picked up EMBEDDED.

* This change allows it to be built-in. It uses late_initcall, which
will put it ahead of other (SCSI) drivers.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/scsi/Kconfig |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9191d1e..2c56857 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -258,21 +258,21 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate  # No prompt here, this is an invisible symbol.
+	tristate "Waits for all SCSI async bus scans to complete" if EMBEDDED
 	default m
 	depends on SCSI
 	depends on MODULES
-# scsi_wait_scan is a loadable module which waits until all the async scans are
-# complete.  The idea is to use it in initrd/ initramfs scripts.  You modprobe
-# it after all the modprobes of the root SCSI drivers and it will wait until
-# they have all finished scanning their buses before allowing the boot to
-# proceed.  (This method is not applicable if targets boot independently in
-# parallel with the initiator, or with transports with non-deterministic target
-# discovery schemes, or if a transport driver does not support scsi_wait_scan.)
-#
-# This symbol is not exposed as a prompt because little is to be gained by
-# disabling it, whereas people who accidentally switch it off may wonder why
-# their mkinitrd gets into trouble.
+	help
+
+	   scsi_wait_scan is a loadable module which waits until all the async
+	   scans are complete.  The idea is to use it in initrd/ initramfs
+	   scripts.  You modprobe it after all the modprobes of the root SCSI
+	   drivers and it will wait until they have all finished scanning their
+	   buses before allowing the boot to proceed.  (This method is not
+	   applicable if targets boot independently in parallel with the
+	   initiator, or with transports with non-deterministic target
+	   discovery schemes, or if a transport driver does not support
+	   scsi_wait_scan.)
 
 menu "SCSI Transports"
 	depends on SCSI
-- 
1.6.6

