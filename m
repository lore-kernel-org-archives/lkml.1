Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYHCHiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYHCHiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 03:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYHCHiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 03:38:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:39213 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYHCHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 03:38:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=Fuml9AUBMJEUutBVjduHQ3VsHU+IB4/KRcGLT/YJJrIVT/7FpQ0UKh3BJ1QmXyLpK4
         O/FYvaHygKSfAXJx5KN6b54XdfVfNSNjSrTPYFsyTuOgI+A51jLyPZyLygv5FQx4/y3q
         GW7w/DMFoDOUfItV7ebjSXhMAF+oRiDD0Vsew=
Date: Sun, 3 Aug 2008 09:37:56 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 1/2] pata_legacy: export functionality to ide
Message-ID: <20080803073756.GA8762@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, alan@redhat.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200808021902.12191.bzolnier@gmail.com> <20080802183253.GA2239@gollum.tnic> <200808022046.16990.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808022046.16990.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here's a definitely better solution:

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 3 Aug 2008 08:31:20 +0200
Subject: [PATCH 1/2] pata_legacy: export functionality to ide

export the legacy iobases checking code to other
users (ide) by pushing it up into the header.

CC: Alan Cox <alan@redhat.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ata/pata_legacy.c |   63 +-----------------------------------------
 include/linux/ata.h       |   67 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 62 deletions(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index bc037ff..14d187e 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -50,7 +50,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -1040,47 +1039,6 @@ fail:
 	return ret;
 }
 
-/**
- *	legacy_check_special_cases	-	ATA special cases
- *	@p: PCI device to check
- *	@master: set this if we find an ATA master
- *	@master: set this if we find an ATA secondary
- *
- *	A small number of vendors implemented early PCI ATA interfaces
- *	on bridge logic without the ATA interface being PCI visible.
- *	Where we have a matching PCI driver we must skip the relevant
- *	device here. If we don't know about it then the legacy driver
- *	is the right driver anyway.
- */
-
-static void __init legacy_check_special_cases(struct pci_dev *p, int *primary,
-								int *secondary)
-{
-	/* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
-	if (p->vendor == 0x1078 && p->device == 0x0000) {
-		*primary = *secondary = 1;
-		return;
-	}
-	/* Cyrix CS5520 pre SFF MWDMA ATA on the bridge */
-	if (p->vendor == 0x1078 && p->device == 0x0002) {
-		*primary = *secondary = 1;
-		return;
-	}
-	/* Intel MPIIX - PIO ATA on non PCI side of bridge */
-	if (p->vendor == 0x8086 && p->device == 0x1234) {
-		u16 r;
-		pci_read_config_word(p, 0x6C, &r);
-		if (r & 0x8000) {
-			/* ATA port enabled */
-			if (r & 0x4000)
-				*secondary = 1;
-			else
-				*primary = 1;
-		}
-		return;
-	}
-}
-
 static __init void probe_opti_vlb(void)
 {
 	/* If an OPTI 82C46X is present find out where the channels are */
@@ -1210,26 +1168,7 @@ static __init int legacy_init(void)
 	struct legacy_probe *pl = &probe_list[0];
 	int slot = 0;
 
-	struct pci_dev *p = NULL;
-
-	for_each_pci_dev(p) {
-		int r;
-		/* Check for any overlap of the system ATA mappings. Native
-		   mode controllers stuck on these addresses or some devices
-		   in 'raid' mode won't be found by the storage class test */
-		for (r = 0; r < 6; r++) {
-			if (pci_resource_start(p, r) == 0x1f0)
-				primary = 1;
-			if (pci_resource_start(p, r) == 0x170)
-				secondary = 1;
-		}
-		/* Check for special cases */
-		legacy_check_special_cases(p, &primary, &secondary);
-
-		/* If PCI bus is present then don't probe for tertiary
-		   legacy ports */
-		pci_present = 1;
-	}
+	ata_legacy_check_iobases(&primary, &secondary, &pci_present);
 
 	if (winbond == 1)
 		winbond = 0x130;	/* Default port, alt is 1B0 */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 11de32c..0470562 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -30,6 +30,7 @@
 #define __LINUX_ATA_H__
 
 #include <linux/types.h>
+#include <linux/pci.h>
 
 /* defines only for the constants which don't work well as enums */
 #define ATA_DMA_BOUNDARY	0xffffUL
@@ -776,4 +777,70 @@ static inline int lba_48_ok(u64 block, u32 n_block)
 #define sata_pmp_gscr_rev(gscr)		(((gscr)[SATA_PMP_GSCR_REV] >> 8) & 0xff)
 #define sata_pmp_gscr_ports(gscr)	((gscr)[SATA_PMP_GSCR_PORT_INFO] & 0xf)
 
+/**
+ *	legacy_check_special_cases	-	ATA special cases
+ *	@p: PCI device to check
+ *	@master: set this if we find an ATA master
+ *	@master: set this if we find an ATA secondary
+ *
+ *	A small number of vendors implemented early PCI ATA interfaces
+ *	on bridge logic without the ATA interface being PCI visible.
+ *	Where we have a matching PCI driver we must skip the relevant
+ *	device here. If we don't know about it then the legacy driver
+ *	is the right driver anyway.
+ */
+static inline void __init ata_legacy_check_special_cases(struct pci_dev *p,
+							 int *primary,
+							 int *secondary)
+{
+	/* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
+	if (p->vendor == 0x1078 && p->device == 0x0000) {
+		*primary = *secondary = 1;
+		return;
+	}
+	/* Cyrix CS5520 pre SFF MWDMA ATA on the bridge */
+	if (p->vendor == 0x1078 && p->device == 0x0002) {
+		*primary = *secondary = 1;
+		return;
+	}
+	/* Intel MPIIX - PIO ATA on non PCI side of bridge */
+	if (p->vendor == 0x8086 && p->device == 0x1234) {
+		u16 r;
+		pci_read_config_word(p, 0x6C, &r);
+		if (r & 0x8000) {
+			/* ATA port enabled */
+			if (r & 0x4000)
+				*secondary = 1;
+			else
+				*primary = 1;
+		}
+		return;
+	}
+}
+
+static inline void __init ata_legacy_check_iobases(int *primary, int *secondary,
+						   int *pci_present)
+{
+	struct pci_dev *p = NULL;
+
+	for_each_pci_dev(p) {
+		int r;
+		/* Check for any overlap of the system ATA mappings. Native
+		   mode controllers stuck on these addresses or some devices
+		   in 'raid' mode won't be found by the storage class test */
+		for (r = 0; r < 6; r++) {
+			if (pci_resource_start(p, r) == 0x1f0)
+				*primary = 1;
+			if (pci_resource_start(p, r) == 0x170)
+				*secondary = 1;
+		}
+		/* Check for special cases */
+		ata_legacy_check_special_cases(p, primary, secondary);
+
+		/* If PCI bus is present then don't probe for tertiary
+		   legacy ports */
+		*pci_present = 1;
+	}
+}
+
 #endif /* __LINUX_ATA_H__ */
-- 
1.5.5.4

-- 
Regards/Gruss,
    Boris.
