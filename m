Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYBLOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYBLOid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760157AbYBLOiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:38:23 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:37113 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761943AbYBLOiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:38:22 -0500
To: Gregor Radtke <mail@g-radtke.name>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, Tim Kunschke <beatmeistah@web.de>
Subject: [PATCH] pata_cs5536 Fix secondary port configuration
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1202158828.6229.22.camel@desktop.ein-elch.local>
	<yq163x47wsy.fsf@sermon.lab.mkp.net>
	<1202662829.6418.8.camel@desktop.ein-elch.local>
Date: Tue, 12 Feb 2008 09:37:25 -0500
In-Reply-To: <1202662829.6418.8.camel@desktop.ein-elch.local> (Gregor Radtke's message of "Sun\, 10 Feb 2008 18\:00\:29 +0100")
Message-ID: <yq1myq6p7fe.fsf_-_@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gregor" == Gregor Radtke <mail@g-radtke.name> writes:

>> Try booting your pata_cs5536 kernel with libata.dma=0

Gregor> hmm.. boots perfectly, of course somewhat slow.  dmesg output:

Brown paper bag time.  My devel board has a 16MB 1st generation
compact flash on the secondary so I never noticed this was hosed.
Please try the following patch...

-- 
Martin K. Petersen	Oracle Linux Engineering


Fix speed negotiation for slave device.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 9f5ca67cc28f drivers/ata/pata_cs5536.c
--- a/drivers/ata/pata_cs5536.c	Mon Feb 11 20:52:01 2008 -0800
+++ b/drivers/ata/pata_cs5536.c	Tue Feb 12 08:52:43 2008 -0500
@@ -40,7 +40,7 @@
 #include <asm/msr.h>
 
 #define DRV_NAME	"pata_cs5536"
-#define DRV_VERSION	"0.0.6"
+#define DRV_VERSION	"0.0.7"
 
 enum {
 	CFG			= 0,
@@ -153,8 +153,8 @@ static void cs5536_set_piomode(struct at
 	struct ata_device *pair = ata_dev_pair(adev);
 	int mode = adev->pio_mode - XFER_PIO_0;
 	int cmdmode = mode;
-	int dshift = ap->port_no ? IDE_D1_SHIFT : IDE_D0_SHIFT;
-	int cshift = ap->port_no ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
+	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
 	u32 dtc, cast, etc;
 
 	if (pair)
@@ -201,7 +201,7 @@ static void cs5536_set_dmamode(struct at
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 dtc, etc;
 	int mode = adev->dma_mode;
-	int dshift = ap->port_no ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 
 	if (mode >= XFER_UDMA_0) {
 		cs5536_read(pdev, ETC, &etc);


