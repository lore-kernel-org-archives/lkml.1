Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbYDVXU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbYDVXU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYDVXUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:20:19 -0400
Received: from syd-iport-1.cisco.com ([64.104.193.196]:25926 "EHLO
	syd-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYDVXUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:20:17 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: [bisected] Latest git not seeing HD with sata_nv
X-Message-Flag: Warning: May contain useful information
Date: Tue, 22 Apr 2008 16:20:12 -0700
Message-ID: <adazlrlcw9f.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Apr 2008 23:20:13.0379 (UTC) FILETIME=[6A9B0930:01C8A4CF]
Authentication-Results: syd-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/syddkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that commit 305d2a1a ("libata: unify mechanism to request
follow-up SRST") causes sata_nv not to see the HD on a system I have
here; with current git (80750147), I get this in my bootlog:

[    2.425108] Driver 'sd' needs updating - please use bus_type methods
[    2.435751] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    2.441508] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[    2.452929] sata_nv 0000:00:05.0: Using SWNCQ mode
[    2.457892] scsi0 : sata_nv
[    2.461813] scsi1 : sata_nv
[    2.465891] ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 23
[    2.473034] ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 23
[    2.565962] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.003517] ata2: SATA link down (SStatus 0 SControl 300)
[    3.137171] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    3.142926] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 22 (level, low) -> IRQ 22
[    3.151675] sata_nv 0000:00:05.1: Using SWNCQ mode
[    3.156582] scsi2 : sata_nv
[    3.160553] scsi3 : sata_nv

ie no HD is found, even thought he ata1 link comes up, which of course
leads to:

[    4.763274] VFS: Cannot open root device "sda1" or unknown-block(0,0)
[    4.769724] Please append a correct "root=" boot option; here are the available partitions:

and the system is dead.

I did a bisection and came up with 305d2a1a as the culprit.  Then I
applied the revert patch below by hand (since 305d2a1a doesn't revert
entirely cleanly), and things worked again:

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b0b00af..e0321ce 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3683,6 +3683,7 @@ int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 
 	/* do hardreset */
 	rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
+	*class = ATA_DEV_NONE;
 	return online ? -EAGAIN : rc;
 }
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index d94359a..667d0e6 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2053,10 +2053,20 @@ static int ata_do_reset(struct ata_link *link, ata_reset_fn_t reset,
 
 	rc = reset(link, classes, deadline);
 
-	/* convert all ATA_DEV_UNKNOWN to ATA_DEV_NONE */
+	/* If any class isn't ATA_DEV_UNKNOWN, consider classification
+	 * is complete and convert all ATA_DEV_UNKNOWN to
+	 * ATA_DEV_NONE.
+	 */
 	ata_link_for_each_dev(dev, link)
-		if (classes[dev->devno] == ATA_DEV_UNKNOWN)
-			classes[dev->devno] = ATA_DEV_NONE;
+		if (classes[dev->devno] != ATA_DEV_UNKNOWN)
+			break;
+
+	if (dev) {
+		ata_link_for_each_dev(dev, link) {
+			if (classes[dev->devno] == ATA_DEV_UNKNOWN)
+				classes[dev->devno] = ATA_DEV_NONE;
+		}
+	}
 
 	return rc;
 }
@@ -2067,15 +2077,16 @@ static int ata_eh_followup_srst_needed(struct ata_link *link,
 {
 	if ((link->flags & ATA_LFLAG_NO_SRST) || ata_link_offline(link))
 		return 0;
-	if (rc == -EAGAIN) {
-		if (classify)
-			return 1;
-		rc = 0;
-	}
+	if (rc == -EAGAIN)
+		return 1;
 	if (rc != 0)
 		return 0;
 	if (sata_pmp_supported(link->ap) && ata_is_host_link(link))
 		return 1;
+	if (classify && !(link->flags & ATA_LFLAG_ASSUME_CLASS) &&
+	    classes[0] == ATA_DEV_UNKNOWN)
+		return 1;
+
 	return 0;
 }
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 1549952..11b2adc 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1943,6 +1943,7 @@ int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 
 	rc = sata_link_hardreset(link, timing, deadline, &online,
 				 ata_sff_check_ready);
+	*class = ATA_DEV_NONE;
 	if (online)
 		*class = ata_sff_dev_classify(link->device, 1, NULL);
 


And here's the bootlog with current git with my revert patch applied:

[    2.417741] Driver 'sd' needs updating - please use bus_type methods
[    2.424142] sata_nv 0000:00:05.0: version 3.5
[    2.428387] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    2.434134] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> IRQ 23
[    2.445558] sata_nv 0000:00:05.0: Using SWNCQ mode
[    2.450390] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    2.450526] scsi0 : sata_nv
[    2.454445] scsi1 : sata_nv
[    2.458523] ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 23
[    2.465664] ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 23
[    2.923281] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.966595] ata1.00: ATA-7: WDC WD3200YS-01PGB0, 21.00M21, max UDMA/133
[    2.977218] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 1)
[    3.008489] ata1.00: configured for UDMA/133
[    3.289737] ata2: SATA link down (SStatus 0 SControl 300)
[    3.341584] isa bounce pool size: 16 pages
[    3.349571] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200YS-01P 21.0 PQ: 0 ANSI: 5
[    3.357780] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    3.364921] sd 0:0:0:0: [sda] Write Protect is off
[    3.369717] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.369732] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.378822] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[    3.385964] sd 0:0:0:0: [sda] Write Protect is off
[    3.390761] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.390776] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.399816]  sda: sda1 sda2 < sda5 sda6 >
[    3.445543] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.450580] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 22
[    3.457951] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 22 (level, low) -> IRQ 22
[    3.466708] sata_nv 0000:00:05.1: Using SWNCQ mode
[    3.471529] PCI: Setting latency timer of device 0000:00:05.1 to 64
