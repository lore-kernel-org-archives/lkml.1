Return-Path: <linux-kernel-owner+w=401wt.eu-S1761123AbXIXQ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123AbXIXQ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbXIXQZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:25:37 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47297 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760251AbXIXQZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:25:33 -0400
Date: Mon, 24 Sep 2007 09:20:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Adam Radford <linuxraid@amcc.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [12/50] 3w-9xxx: Fix dma mask setting
Message-ID: <20070924162027.GM13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="3w-9xxx-fix-dma-mask-setting.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Radford <linuxraid@amcc.com>

[SCSI] 3w-9xxx: Fix dma mask setting

Extracted from commit 0e78d158b67fba3977f577f293c323359d80dd0e

The attached patch updates the 3ware 9000 driver:

- Fix dma mask setting to fallback to 32-bit if 64-bit fails.

Signed-off-by: Adam Radford <linuxraid@amcc.com>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/3w-9xxx.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -4,7 +4,7 @@
    Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Tom Couch <linuxraid@amcc.com>
 
-   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2007 Applied Micro Circuits Corporation.
 
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -69,6 +69,7 @@
    2.26.02.008 - Free irq handler in __twa_shutdown().
                  Serialize reset code.
                  Add support for 9650SE controllers.
+   2.26.02.009 - Fix dma mask setting to fallback to 32-bit if 64-bit fails.
 */
 
 #include <linux/module.h>
@@ -92,7 +93,7 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.008"
+#define TW_DRIVER_VERSION "2.26.02.009"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -2063,11 +2064,14 @@ static int __devinit twa_probe(struct pc
 
 	pci_set_master(pdev);
 
-	retval = pci_set_dma_mask(pdev, sizeof(dma_addr_t) > 4 ? DMA_64BIT_MASK : DMA_32BIT_MASK);
-	if (retval) {
-		TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
-		goto out_disable_device;
-	}
+	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
+	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
+		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+			TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
+			retval = -ENODEV;
+			goto out_disable_device;
+		}
 
 	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
 	if (!host) {

-- 
