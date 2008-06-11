Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYFKU2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYFKU2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYFKU0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:26:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:60929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYFKU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=LI3wtqWl8cnTbRHbf39Oy85a+lPcJxbqGfDfw8dt5le0yRi9bjCihYwSI0mhaFUjpd
         Dl3wXnoUoIxKBUg7jONKHdFNVfFWG5e7LB/Xb0SnaRvxlmsqqzRWLZ1r2qGp38Pao5Ch
         v0KWPlZfU3gaG879O1mvS3+91Gr5M94GI6nIU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/6] opti621: use pre-calculated PIO timings
Date: Wed, 11 Jun 2008 22:00:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Juergen Kosel <juergen.kosel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806112200.44988.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use pre-calculated PIO timings in ->set_pio_mode.

* Remove no longer needed compute_clocks(), cmpt_clk(), struct pio_clocks_s,
  PIO_* defines and OPTI621_DEBUG define.

There should be no functional changes caused by this patch.

Based on a bugreport from Juergen Kosel & inspired by pata_opti.c code.

Tested-by: Juergen Kosel <juergen.kosel@gmx.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/opti621.c |   92 +++++++---------------------------------------
 1 file changed, 15 insertions(+), 77 deletions(-)

Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -81,8 +81,6 @@
  * 0.5 doesn't work.
  */
 
-#define OPTI621_DEBUG		/* define for debug messages */
-
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -110,23 +108,8 @@
 
 static int reg_base;
 
-#define PIO_NOT_EXIST 254
-#define PIO_DONT_KNOW 255
-
 static DEFINE_SPINLOCK(opti621_lock);
 
-static int cmpt_clk(int time, int bus_speed)
-/* Returns (rounded up) time in clocks for time in ns,
- * with bus_speed in MHz.
- * Example: bus_speed = 40 MHz, time = 80 ns
- * 1000/40 = 25 ns (clk value),
- * 80/25 = 3.2, rounded up to 4 (I hope ;-)).
- * Use idebus=xx to select right frequency.
- */
-{
-	return ((time*bus_speed+999)/1000);
-}
-
 /* Write value to register reg, base of register
  * is at reg_base (0x1f0 primary, 0x170 secondary,
  * if not changed by PCI configuration).
@@ -159,51 +142,22 @@ static u8 read_reg(int reg)
 	return ret;
 }
 
-typedef struct pio_clocks_s {
-	int	address_time;	/* Address setup (clocks) */
-	int	data_time;	/* Active/data pulse (clocks) */
-	int	recovery_time;	/* Recovery time (clocks) */
-} pio_clocks_t;
-
-static void compute_clocks(int pio, pio_clocks_t *clks, int bus_speed)
-{
-	if (pio != PIO_NOT_EXIST) {
-		int adr_setup, data_pls;
-
-		adr_setup = ide_pio_timings[pio].setup_time;
-		data_pls = ide_pio_timings[pio].active_time;
-		clks->address_time = cmpt_clk(adr_setup, bus_speed);
-		clks->data_time = cmpt_clk(data_pls, bus_speed);
-		clks->recovery_time = cmpt_clk(ide_pio_timings[pio].cycle_time
-			- adr_setup-data_pls, bus_speed);
-		if (clks->address_time < 1)
-			clks->address_time = 1;
-		if (clks->address_time > 4)
-			clks->address_time = 4;
-		if (clks->data_time < 1)
-			clks->data_time = 1;
-		if (clks->data_time > 16)
-			clks->data_time = 16;
-		if (clks->recovery_time < 2)
-			clks->recovery_time = 2;
-		if (clks->recovery_time > 17)
-			clks->recovery_time = 17;
-	} else {
-		clks->address_time = 1;
-		clks->data_time = 1;
-		clks->recovery_time = 2;
-		/* minimal values */
-	}
-}
-
 static void opti621_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	ide_drive_t *pair = ide_get_paired_drive(drive);
 	unsigned long flags;
-	pio_clocks_t first, second;
-	int ax, drdy;
-	u8 cycle1, misc, clk, addr_pio = pio;
+	u8 tim, misc, addr_pio = pio, clk;
+
+	/* DRDY is default 2 (by OPTi Databook) */
+	static const u8 addr_timings[2][4] = {
+		{ 0x20, 0x10, 0x00, 0x00 },	/* 33 MHz */
+		{ 0x10, 0x10, 0x00, 0x00 },	/* 25 MHz */
+	};
+	static const u8 data_rec_timings[2][4] = {
+		{ 0x5b, 0x45, 0x32, 0x21 },	/* 33 MHz */
+		{ 0x48, 0x34, 0x21, 0x10 }	/* 25 MHz */
+	};
 
 	drive->drive_data = XFER_PIO_0 + pio;
 
@@ -230,31 +184,15 @@ static void opti621_set_pio_mode(ide_dri
 
 	printk(KERN_INFO "%s: CLK = %d MHz\n", hwif->name, clk ? 25 : 33);
 
-	compute_clocks(pio, &first, clk ? 25 : 33);
-	compute_clocks(addr_pio, &second, clk ? 25 : 33);
-
-	/* ax = max(a1,a2) */
-	ax = (first.address_time < second.address_time) ? second.address_time : first.address_time;
-
-	drdy = 2; /* DRDY is default 2 (by OPTi Databook) */
-
-	cycle1 = ((first.data_time-1)<<4)  | (first.recovery_time-2);
-
-	misc = ((ax - 1) << 4) | ((drdy - 2) << 1);
-
-#ifdef OPTI621_DEBUG
-	printk("%s: address: %d, data: %d, "
-		"recovery: %d, drdy: %d [clk]\n",
-		drive->name, ax, first.data_time,
-		first.recovery_time, drdy);
-#endif
+	tim  = data_rec_timings[clk][pio];
+	misc = addr_timings[clk][addr_pio];
 
 	/* select Index-0/1 for Register-A/B */
 	write_reg(drive->select.b.unit, MISC_REG);
 	/* set read cycle timings */
-	write_reg(cycle1, READ_REG);
+	write_reg(tim, READ_REG);
 	/* set write cycle timings */
-	write_reg(cycle1, WRITE_REG);
+	write_reg(tim, WRITE_REG);
 
 	/* use Register-A for drive 0 */
 	/* use Register-B for drive 1 */
