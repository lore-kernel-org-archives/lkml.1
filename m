Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYCKVNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYCKVNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbYCKVMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:12:08 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:64588 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbYCKVME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BrLRnUvQRXYhHR/MRVWMHrhHKRfTJmT8/UmTuxqpw2/j4kRjYy/Ol7EWg9FmECNxSwBjKSWFakdtCvPyKIy2GhKDpdVO9uBowN/w9kXSB0Ckwpqwp6HkZuzLmkLU4Ncupee8AK2OZ24lN7LJgB4FrwpwCz/kQv5yVEE708bV+K8=
Subject: [PATCH 3/6] ata: use clamp_val macro instead of FIT macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-ide <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 14:12:00 -0700
Message-Id: <1205269920.22317.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the kernel-provided clamp_val macro rather than an ata-specific
FIT macro.  FIT() was always called with constant range arguments
which makes this safe.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
All but the pata_ali.c section is direct replacement.  The masking
is not necessary if the upper limit is lowered by one in the pata_ali.c
section.
 drivers/ata/pata_ali.c     |   10 ++++----
 drivers/ata/pata_amd.c     |   14 ++++++------
 drivers/ata/pata_cypress.c |    8 +++---
 drivers/ata/pata_legacy.c  |   50 ++++++++++++++++++++++----------------------
 drivers/ata/pata_ns87410.c |    6 ++--
 drivers/ata/pata_ns87415.c |    4 +-
 drivers/ata/pata_qdi.c     |   16 +++++++-------
 drivers/ata/pata_via.c     |   14 ++++++------
 drivers/ata/pata_winbond.c |    6 ++--
 include/linux/libata.h     |    2 -
 10 files changed, 64 insertions(+), 66 deletions(-)

diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 7e68edf..92fe998 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -173,11 +173,11 @@ static void ali_program_modes(struct ata_port *ap, struct ata_device *adev, stru
 	u8 udma;
 
 	if (t != NULL) {
-		t->setup = FIT(t->setup, 1, 8) & 7;
-		t->act8b = FIT(t->act8b, 1, 8) & 7;
-		t->rec8b = FIT(t->rec8b, 1, 16) & 15;
-		t->active = FIT(t->active, 1, 8) & 7;
-		t->recover = FIT(t->recover, 1, 16) & 15;
+		t->setup = clamp_val(t->setup, 1, 7);
+		t->act8b = clamp_val(t->act8b, 1, 7);
+		t->rec8b = clamp_val(t->rec8b, 1, 15);
+		t->active = clamp_val(t->active, 1, 7);
+		t->recover = clamp_val(t->recover, 1, 15);
 
 		pci_write_config_byte(pdev, cas, t->setup);
 		pci_write_config_byte(pdev, cbt, (t->act8b << 4) | t->rec8b);
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 4b8d9b5..c8145a6 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -82,32 +82,32 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 
 	/* Configure the address set up timing */
 	pci_read_config_byte(pdev, offset + 0x0C, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((FIT(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
+	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
 	pci_write_config_byte(pdev, offset + 0x0C , t);
 
 	/* Configure the 8bit I/O timing */
 	pci_write_config_byte(pdev, offset + 0x0E + (1 - (dn >> 1)),
-		((FIT(at.act8b, 1, 16) - 1) << 4) | (FIT(at.rec8b, 1, 16) - 1));
+		((clamp_val(at.act8b, 1, 16) - 1) << 4) | (clamp_val(at.rec8b, 1, 16) - 1));
 
 	/* Drive timing */
 	pci_write_config_byte(pdev, offset + 0x08 + (3 - dn),
-		((FIT(at.active, 1, 16) - 1) << 4) | (FIT(at.recover, 1, 16) - 1));
+		((clamp_val(at.active, 1, 16) - 1) << 4) | (clamp_val(at.recover, 1, 16) - 1));
 
 	switch (clock) {
 		case 1:
-		t = at.udma ? (0xc0 | (FIT(at.udma, 2, 5) - 2)) : 0x03;
+		t = at.udma ? (0xc0 | (clamp_val(at.udma, 2, 5) - 2)) : 0x03;
 		break;
 
 		case 2:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 2, 10)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 2, 10)]) : 0x03;
 		break;
 
 		case 3:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 1, 10)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 10)]) : 0x03;
 		break;
 
 		case 4:
-		t = at.udma ? (0xc0 | amd_cyc2udma[FIT(at.udma, 1, 15)]) : 0x03;
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 15)]) : 0x03;
 		break;
 
 		default:
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index fc5f9c4..94998eb 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -62,14 +62,14 @@ static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		return;
 	}
 
-	time_16 = FIT(t.recover, 0, 15) | (FIT(t.active, 0, 15) << 4);
-	time_8 = FIT(t.act8b, 0, 15) | (FIT(t.rec8b, 0, 15) << 4);
+	time_16 = clamp_val(t.recover, 0, 15) | (clamp_val(t.active, 0, 15) << 4);
+	time_8 = clamp_val(t.act8b, 0, 15) | (clamp_val(t.rec8b, 0, 15) << 4);
 
 	if (adev->devno == 0) {
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0x0F;	/* Mask bits */
-		addr |= FIT(t.setup, 0, 15);
+		addr |= clamp_val(t.setup, 0, 15);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOR, time_16);
@@ -79,7 +79,7 @@ static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0xF0;	/* Mask bits */
-		addr |= (FIT(t.setup, 0, 15) << 4);
+		addr |= (clamp_val(t.setup, 0, 15) << 4);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOR, time_16);
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 50fe08e..e62d491 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -414,8 +414,8 @@ static void ht6560a_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 4, 15);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 4, 15);
 
 	inb(0x3E6);
 	inb(0x3E6);
@@ -470,8 +470,8 @@ static void ht6560b_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	/* Get the timing data in cycles. For now play safe at 50Mhz */
 	ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
 
-	active = FIT(t.active, 2, 15);
-	recover = FIT(t.recover, 2, 16);
+	active = clamp_val(t.active, 2, 15);
+	recover = clamp_val(t.recover, 2, 16);
 	recover &= 0x15;
 
 	inb(0x3E6);
@@ -577,9 +577,9 @@ static void opti82c611a_set_piomode(struct ata_port *ap,
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
-	active = FIT(t.active, 2, 17) - 2;
-	recover = FIT(t.recover, 1, 16) - 1;
-	setup = FIT(t.setup, 1, 4) - 1;
+	active = clamp_val(t.active, 2, 17) - 2;
+	recover = clamp_val(t.recover, 1, 16) - 1;
+	setup = clamp_val(t.setup, 1, 4) - 1;
 
 	/* Select the right timing bank for write timing */
 	rc = ioread8(ap->ioaddr.lbal_addr);
@@ -678,9 +678,9 @@ static void opti82c46x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
 	}
 
-	active = FIT(t.active, 2, 17) - 2;
-	recover = FIT(t.recover, 1, 16) - 1;
-	setup = FIT(t.setup, 1, 4) - 1;
+	active = clamp_val(t.active, 2, 17) - 2;
+	recover = clamp_val(t.recover, 1, 16) - 1;
+	setup = clamp_val(t.setup, 1, 4) - 1;
 
 	/* Select the right timing bank for write timing */
 	rc = ioread8(ap->ioaddr.lbal_addr);
@@ -782,11 +782,11 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -816,11 +816,11 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -853,11 +853,11 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (ld_qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 	ld_qdi->clock[adev->devno] = timing;
@@ -1050,8 +1050,8 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	else
 		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
 	winbond_writecfg(ld_winbond->timing, timing, reg);
 
@@ -1062,7 +1062,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		reg |= 0x08;	/* FIFO off */
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
-	reg |= (FIT(t.setup, 0, 3) << 6);
+	reg |= (clamp_val(t.setup, 0, 3) << 6);
 	winbond_writecfg(ld_winbond->timing, timing + 1, reg);
 }
 
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 9fe66fd..2e57957 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -105,9 +105,9 @@ static void ns87410_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		return;
 	}
 
-	at.active = FIT(at.active, 2, 16) - 2;
-	at.setup = FIT(at.setup, 1, 4) - 1;
-	at.recover = FIT(at.recover, 1, 12) - 1;
+	at.active = clamp_val(at.active, 2, 16) - 2;
+	at.setup = clamp_val(at.setup, 1, 4) - 1;
+	at.recover = clamp_val(at.recover, 1, 12) - 1;
 
 	idetcr = (at.setup << 6) | (recoverbits[at.recover] << 3) | activebits[at.active];
 
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index d0e2e50..e26ff5c 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -66,8 +66,8 @@ static void ns87415_set_mode(struct ata_port *ap, struct ata_device *adev, u8 mo
 
 	ata_timing_compute(adev, adev->pio_mode, &t, T, 0);
 
-	clocking = 17 - FIT(t.active, 2, 17);
-	clocking |= (16 - FIT(t.recover, 1, 16)) << 4;
+	clocking = 17 - clamp_val(t.active, 2, 17);
+	clocking |= (16 - clamp_val(t.recover, 1, 16)) << 4;
  	/* Use the same timing for read and write bytes */
 	clocking |= (clocking << 8);
 	pci_write_config_word(dev, timing, clocking);
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 9f308ed..9e84930 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -60,11 +60,11 @@ static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
@@ -84,11 +84,11 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
 	if (qdi->fast) {
-		active = 8 - FIT(t.active, 1, 8);
-		recovery = 18 - FIT(t.recover, 3, 18);
+		active = 8 - clamp_val(t.active, 1, 8);
+		recovery = 18 - clamp_val(t.recover, 3, 18);
 	} else {
-		active = 9 - FIT(t.active, 2, 9);
-		recovery = 15 - FIT(t.recover, 0, 15);
+		active = 9 - clamp_val(t.active, 2, 9);
+		recovery = 15 - clamp_val(t.recover, 0, 15);
 	}
 	timing = (recovery << 4) | active | 0x08;
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index d119a68..febced6 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -271,15 +271,15 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 
 		pci_read_config_byte(pdev, 0x4C, &setup);
 		setup &= ~(3 << shift);
-		setup |= FIT(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
+		setup |= clamp_val(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
 		pci_write_config_byte(pdev, 0x4C, setup);
 	}
 
 	/* Load the PIO mode bits */
 	pci_write_config_byte(pdev, 0x4F - ap->port_no,
-		((FIT(t.act8b, 1, 16) - 1) << 4) | (FIT(t.rec8b, 1, 16) - 1));
+		((clamp_val(t.act8b, 1, 16) - 1) << 4) | (clamp_val(t.rec8b, 1, 16) - 1));
 	pci_write_config_byte(pdev, 0x48 + offset,
-		((FIT(t.active, 1, 16) - 1) << 4) | (FIT(t.recover, 1, 16) - 1));
+		((clamp_val(t.active, 1, 16) - 1) << 4) | (clamp_val(t.recover, 1, 16) - 1));
 
 	/* Load the UDMA bits according to type */
 	switch(udma_type) {
@@ -287,16 +287,16 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 			/* BUG() ? */
 			/* fall through */
 		case 33:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 5) - 2)) : 0x03;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
 			break;
 		case 66:
-			ut = t.udma ? (0xe8 | (FIT(t.udma, 2, 9) - 2)) : 0x0f;
+			ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
 			break;
 		case 100:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 		case 133:
-			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
+			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 	}
 
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 99c92ed..41ffead 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -75,8 +75,8 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	else
 		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
 
-	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
 	timing = (active << 4) | recovery;
 	winbond_writecfg(winbond->config, timing, reg);
 
@@ -87,7 +87,7 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		reg |= 0x08;	/* FIFO off */
 	if (!ata_pio_need_iordy(adev))
 		reg |= 0x02;	/* IORDY off */
-	reg |= (FIT(t.setup, 0, 3) << 6);
+	reg |= (clamp_val(t.setup, 0, 3) << 6);
 	winbond_writecfg(winbond->config, timing + 1, reg);
 }
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a05f600..d3153d7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -755,8 +755,6 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
-
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
 extern const unsigned long sata_deb_timing_long[];
-- 
1.5.4.4.592.g32d4c


