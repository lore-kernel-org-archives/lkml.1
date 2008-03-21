Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbYCUWzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbYCUWzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762559AbYCUWuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:06 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59116 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763659AbYCUWuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:01 -0400
Message-Id: <20080321224411.944787944@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 42/76] pata_hpt*, pata_serverworks: fix UDMA masking
Content-Disposition: inline; filename=pata_hpt-pata_serverworks-fix-udma-masking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

[upstream commit: 6ddd6861]

When masking, mask out the modes that are unsupported not the ones
that are supported.  This makes life happier.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ata/pata_hpt366.c      |    6 +++---
 drivers/ata/pata_hpt37x.c      |    6 +++---
 drivers/ata/pata_serverworks.c |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -27,7 +27,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.1"
+#define DRV_VERSION	"0.6.2"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -180,9 +180,9 @@ static unsigned long hpt366_filter(struc
 		if (hpt_dma_blacklisted(adev, "UDMA",  bad_ata33))
 			mask &= ~ATA_MASK_UDMA;
 		if (hpt_dma_blacklisted(adev, "UDMA3", bad_ata66_3))
-			mask &= ~(0x07 << ATA_SHIFT_UDMA);
+			mask &= ~(0xF8 << ATA_SHIFT_UDMA);
 		if (hpt_dma_blacklisted(adev, "UDMA4", bad_ata66_4))
-			mask &= ~(0x0F << ATA_SHIFT_UDMA);
+			mask &= ~(0xF0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.9"
+#define DRV_VERSION	"0.6.11"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -281,7 +281,7 @@ static unsigned long hpt370_filter(struc
 		if (hpt_dma_blacklisted(adev, "UDMA", bad_ata33))
 			mask &= ~ATA_MASK_UDMA;
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
-			mask &= ~(0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
@@ -297,7 +297,7 @@ static unsigned long hpt370a_filter(stru
 {
 	if (adev->class == ATA_DEV_ATA) {
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
-			mask &= ~ (0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -226,7 +226,7 @@ static unsigned long serverworks_csb_fil
 
 	for (i = 0; (p = csb_bad_ata100[i]) != NULL; i++) {
 		if (!strcmp(p, model_num))
-			mask &= ~(0x1F << ATA_SHIFT_UDMA);
+			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
 	return ata_pci_default_filter(adev, mask);
 }

-- 
