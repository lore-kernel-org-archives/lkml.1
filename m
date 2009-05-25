Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZEYVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZEYVse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZEYVsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:48:11 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:49834 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZEYVsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=FQObKYZTZLKts3CBTOmdZgv6OBvP49V6fThzj6P15QhjWIZeb0jNoCLSlqQqmOVkFC
         nQWOmN/deFnHXxE6r/Kc1Qe06YWRjKpM/Hm70MHiV6PIGfMFHcKdYH6F/w7SxYPX0+XY
         L3uuhx/MGO7yiB1o1Yss4kn7RsSZwcHb3UU7I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: preserve HPA by default
Date: Mon, 25 May 2009 23:44:57 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252344.57797.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_IDE_PRESERVE_HPA config option (enabled by default)
to streamline the transition.

The config option help text is heavily based on Alan's
feedback about the issue.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/kernel-parameters.txt |    4 ++--
 drivers/ide/Kconfig                 |   22 ++++++++++++++++++++++
 drivers/ide/ide.c                   |    4 ++++
 3 files changed, 28 insertions(+), 2 deletions(-)

Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -843,8 +843,8 @@ and is between 256 and 4096 characters. 
 			[HW] (E)IDE subsystem
 			Ignore HPA limit
 			Format: { "0" | "1" }
-			0 -- keep BIOS limits
-			1 -- ignore limits, using full disk (default)
+			0 -- keep BIOS limits (default)
+			1 -- ignore limits, using full disk
 
 	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
 			Claim all unknown PCI IDE storage controllers.
Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -91,6 +91,28 @@ config BLK_DEV_IDE_SATA
 
 	  If unsure, say N.
 
+config IDE_PRESERVE_HPA
+	bool "Preserve Host Protected Area (please read help)"
+	default y
+	help
+	  From the majority of modern users perspectives ignoring the HPA
+	  breaks vendor RAID formats, GPT partitions or risks corrupting
+	  firmware.
+
+	  Unfortunately the original (kernel versions < 2.6.30) behavior
+	  (ignoring HPA, using full disk capacity) was introduced at the
+	  time when the main HPA use was with the jumper (or software)
+	  to make the drive look small enough for the BIOS to allow boot
+	  with big drives.
+
+	  To allow the maximum compatibility with the existing setups
+	  (using HPA and partitioned with HPA disabled) the default HPA
+	  behavior can be also later adjusted using "ignore_hpa" module
+	  parameter (i.e. "ide_core.ignore_hpa=1").
+
+	  Say Y unless you have such setup and for some reason cannot
+	  use "ignore_hpa" module parameter.
+
 config IDE_GD
 	tristate "generic ATA/ATAPI disk support"
 	default y
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -166,7 +166,11 @@ struct bus_type ide_bus_type = {
 
 EXPORT_SYMBOL_GPL(ide_bus_type);
 
+#ifdef CONFIG_IDE_PRESERVE_HPA
+int ide_ignore_hpa = 0;
+#else
 int ide_ignore_hpa = 1;
+#endif
 EXPORT_SYMBOL_GPL(ide_ignore_hpa);
 
 module_param_named(ignore_hpa, ide_ignore_hpa, int, 0);
