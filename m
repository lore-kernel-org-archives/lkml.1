Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZCEPab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZCEPab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZCEPaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:30:16 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:65101 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbZCEPaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=GaYsKCCkXUIwEuhUeooZvnIG6PFqxAZoKmUSLL5c2Ci61CQF6+L+/MSLiEWSc7PhNB
         I3Emb14627nKfRh1BEn56Cx9lSjh/IdkD2eOPlRYmJ7fZmxLM5ovMNDfquU2dbVJAGE1
         1JU7WpWuqc7bAXdrFAY+HY/a8MeXPig42my6Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 5 Mar 2009 16:30:32 +0100
Message-Id: <200903051630.32792.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Two bug fixes (for odd-length ATAPI PIO transfers from Sergei Shtylyov
and for insanely long DMA timeouts from Roel Kluin), some sparse fixes
(from Hannes Eder) and a new driver for AT91 Static Memory Controller
with Compact Flash True IDE Mode logic (from Stanislaw Gruszka, arch
specific part has been acked by a platform maintainer).

Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/arm/mach-at91/at91sam9263_devices.c |  105 +++++++
 arch/arm/mach-at91/include/mach/board.h  |    3 +
 drivers/ide/Kconfig                      |    5 +
 drivers/ide/Makefile                     |    1 +
 drivers/ide/at91_ide.c                   |  467 ++++++++++++++++++++++++++++++
 drivers/ide/ide-disk_proc.c              |    2 +-
 drivers/ide/ide-floppy_proc.c            |    2 +-
 drivers/ide/ide-io.c                     |    3 +-
 drivers/ide/ide-iops.c                   |    2 +
 drivers/ide/ide-probe.c                  |    7 +-
 drivers/ide/ide-proc.c                   |    2 +-
 drivers/ide/ide-tape.c                   |    2 +-
 include/linux/hdreg.h                    |    1 -
 include/linux/ide.h                      |    1 +
 14 files changed, 596 insertions(+), 7 deletions(-)
 create mode 100644 drivers/ide/at91_ide.c


Bartlomiej Zolnierkiewicz (1):
      remove stale comment from <linux/hdreg.h>

Hannes Eder (1):
      ide: NULL noise: drivers/ide/ide-*.c

Roel Kluin (1):
      ide: expiry() returns int, negative expiry() return values won't be noticed

Sergei Shtylyov (1):
      ide-iops: fix odd-length ATAPI PIO transfers

Stanislaw Gruszka (3):
      ide: allow to wrap interrupt handler
      ide: add at91_ide driver
      AT91: initialize Compact Flash on AT91SAM9263 cpu


diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 134af97..b7f2332 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -347,6 +347,111 @@ void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data)
 void __init at91_add_device_mmc(short mmc_id, struct at91_mmc_data *data) {}
 #endif
 
+/* --------------------------------------------------------------------
+ *  Compact Flash (PCMCIA or IDE)
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_AT91_CF) || defined(CONFIG_AT91_CF_MODULE) || \
+    defined(CONFIG_BLK_DEV_IDE_AT91) || defined(CONFIG_BLK_DEV_IDE_AT91_MODULE)
+
+static struct at91_cf_data cf0_data;
+
+static struct resource cf0_resources[] = {
+	[0] = {
+		.start	= AT91_CHIPSELECT_4,
+		.end	= AT91_CHIPSELECT_4 + SZ_256M - 1,
+		.flags	= IORESOURCE_MEM | IORESOURCE_MEM_8AND16BIT,
+	}
+};
+
+static struct platform_device cf0_device = {
+	.id		= 0,
+	.dev		= {
+				.platform_data	= &cf0_data,
+	},
+	.resource	= cf0_resources,
+	.num_resources	= ARRAY_SIZE(cf0_resources),
+};
+
+static struct at91_cf_data cf1_data;
+
+static struct resource cf1_resources[] = {
+	[0] = {
+		.start	= AT91_CHIPSELECT_5,
+		.end	= AT91_CHIPSELECT_5 + SZ_256M - 1,
+		.flags	= IORESOURCE_MEM | IORESOURCE_MEM_8AND16BIT,
+	}
+};
+
+static struct platform_device cf1_device = {
+	.id		= 1,
+	.dev		= {
+				.platform_data	= &cf1_data,
+	},
+	.resource	= cf1_resources,
+	.num_resources	= ARRAY_SIZE(cf1_resources),
+};
+
+void __init at91_add_device_cf(struct at91_cf_data *data)
+{
+	unsigned long ebi0_csa;
+	struct platform_device *pdev;
+
+	if (!data)
+		return;
+
+	/*
+	 * assign CS4 or CS5 to SMC with Compact Flash logic support,
+	 * we assume SMC timings are configured by board code,
+	 * except True IDE where timings are controlled by driver
+	 */
+	ebi0_csa = at91_sys_read(AT91_MATRIX_EBI0CSA);
+	switch (data->chipselect) {
+	case 4:
+		at91_set_A_periph(AT91_PIN_PD6, 0);  /* EBI0_NCS4/CFCS0 */
+		ebi0_csa |= AT91_MATRIX_EBI0_CS4A_SMC_CF1;
+		cf0_data = *data;
+		pdev = &cf0_device;
+		break;
+	case 5:
+		at91_set_A_periph(AT91_PIN_PD7, 0);  /* EBI0_NCS5/CFCS1 */
+		ebi0_csa |= AT91_MATRIX_EBI0_CS5A_SMC_CF2;
+		cf1_data = *data;
+		pdev = &cf1_device;
+		break;
+	default:
+		printk(KERN_ERR "AT91 CF: bad chip-select requested (%u)\n",
+		       data->chipselect);
+		return;
+	}
+	at91_sys_write(AT91_MATRIX_EBI0CSA, ebi0_csa);
+
+	if (data->det_pin) {
+		at91_set_gpio_input(data->det_pin, 1);
+		at91_set_deglitch(data->det_pin, 1);
+	}
+
+	if (data->irq_pin) {
+		at91_set_gpio_input(data->irq_pin, 1);
+		at91_set_deglitch(data->irq_pin, 1);
+	}
+
+	if (data->vcc_pin)
+		/* initially off */
+		at91_set_gpio_output(data->vcc_pin, 0);
+
+	/* enable EBI controlled pins */
+	at91_set_A_periph(AT91_PIN_PD5, 1);  /* NWAIT */
+	at91_set_A_periph(AT91_PIN_PD8, 0);  /* CFCE1 */
+	at91_set_A_periph(AT91_PIN_PD9, 0);  /* CFCE2 */
+	at91_set_A_periph(AT91_PIN_PD14, 0); /* CFNRW */
+
+	pdev->name = (data->flags & AT91_CF_TRUE_IDE) ? "at91_ide" : "at91_cf";
+	platform_device_register(pdev);
+}
+#else
+void __init at91_add_device_cf(struct at91_cf_data *data) {}
+#endif
 
 /* --------------------------------------------------------------------
  *  NAND / SmartMedia
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 0b3ae21..793fe7b 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -56,6 +56,9 @@ struct at91_cf_data {
 	u8	vcc_pin;		/* power switching */
 	u8	rst_pin;		/* card reset */
 	u8	chipselect;		/* EBI Chip Select number */
+	u8	flags;
+#define AT91_CF_TRUE_IDE	0x01
+#define AT91_IDE_SWAP_A0_A2	0x02
 };
 extern void __init at91_add_device_cf(struct at91_cf_data *data);
 
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index e072903..5ea3bfa 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -721,6 +721,11 @@ config BLK_DEV_IDE_TX4939
 	depends on SOC_TX4939
 	select BLK_DEV_IDEDMA_SFF
 
+config BLK_DEV_IDE_AT91
+	tristate "Atmel AT91 (SAM9, CAP9, AT572D940HF) IDE support"
+	depends on ARM && ARCH_AT91 && !ARCH_AT91RM9200 && !ARCH_AT91X40
+	select IDE_TIMINGS
+
 config IDE_ARM
 	tristate "ARM IDE support"
 	depends on ARM && (ARCH_RPC || ARCH_SHARK)
diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index d0e3d7d..1c326d9 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -116,3 +116,4 @@ obj-$(CONFIG_BLK_DEV_IDE_AU1XXX)	+= au1xxx-ide.o
 
 obj-$(CONFIG_BLK_DEV_IDE_TX4938)	+= tx4938ide.o
 obj-$(CONFIG_BLK_DEV_IDE_TX4939)	+= tx4939ide.o
+obj-$(CONFIG_BLK_DEV_IDE_AT91)		+= at91_ide.o
diff --git a/drivers/ide/at91_ide.c b/drivers/ide/at91_ide.c
new file mode 100644
index 0000000..1bb50f4
--- /dev/null
+++ b/drivers/ide/at91_ide.c
@@ -0,0 +1,467 @@
+/*
+ * IDE host driver for AT91 (SAM9, CAP9, AT572D940HF) Static Memory Controller
+ * with Compact Flash True IDE logic
+ *
+ * Copyright (c) 2008, 2009 Kelvatek Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/ide.h>
+#include <linux/platform_device.h>
+
+#include <mach/board.h>
+#include <mach/gpio.h>
+#include <mach/at91sam9263.h>
+#include <mach/at91sam9_smc.h>
+#include <mach/at91sam9263_matrix.h>
+
+#define DRV_NAME "at91_ide"
+
+#define perr(fmt, args...) pr_err(DRV_NAME ": " fmt, ##args)
+#define pdbg(fmt, args...) pr_debug("%s " fmt, __func__, ##args)
+
+/*
+ * Access to IDE device is possible through EBI Static Memory Controller
+ * with Compact Flash logic. For details see EBI and SMC datasheet sections
+ * of any microcontroller from AT91SAM9 family.
+ *
+ * Within SMC chip select address space, lines A[23:21] distinguish Compact
+ * Flash modes (I/O, common memory, attribute memory, True IDE). IDE modes are:
+ *   0x00c0000 - True IDE
+ *   0x00e0000 - Alternate True IDE (Alt Status Register)
+ *
+ * On True IDE mode Task File and Data Register are mapped at the same address.
+ * To distinguish access between these two different bus data width is used:
+ * 8Bit for Task File, 16Bit for Data I/O.
+ *
+ * After initialization we do 8/16 bit flipping (changes in SMC MODE register)
+ * only inside IDE callback routines which are serialized by IDE layer,
+ * so no additional locking needed.
+ */
+
+#define TASK_FILE	0x00c00000
+#define ALT_MODE	0x00e00000
+#define REGS_SIZE	8
+
+#define enter_16bit(cs, mode) do {					\
+	mode = at91_sys_read(AT91_SMC_MODE(cs));			\
+	at91_sys_write(AT91_SMC_MODE(cs), mode | AT91_SMC_DBW_16);	\
+} while (0)
+
+#define leave_16bit(cs, mode) at91_sys_write(AT91_SMC_MODE(cs), mode);
+
+static void set_smc_timings(const u8 chipselect, const u16 cycle,
+			    const u16 setup, const u16 pulse,
+			    const u16 data_float, int use_iordy)
+{
+	unsigned long mode = AT91_SMC_READMODE | AT91_SMC_WRITEMODE |
+			     AT91_SMC_BAT_SELECT;
+
+	/* disable or enable waiting for IORDY signal */
+	if (use_iordy)
+		mode |= AT91_SMC_EXNWMODE_READY;
+
+	/* add data float cycles if needed */
+	if (data_float)
+		mode |= AT91_SMC_TDF_(data_float);
+
+	at91_sys_write(AT91_SMC_MODE(chipselect), mode);
+
+	/* setup timings in SMC */
+	at91_sys_write(AT91_SMC_SETUP(chipselect), AT91_SMC_NWESETUP_(setup) |
+						   AT91_SMC_NCS_WRSETUP_(0) |
+						   AT91_SMC_NRDSETUP_(setup) |
+						   AT91_SMC_NCS_RDSETUP_(0));
+	at91_sys_write(AT91_SMC_PULSE(chipselect), AT91_SMC_NWEPULSE_(pulse) |
+						   AT91_SMC_NCS_WRPULSE_(cycle) |
+						   AT91_SMC_NRDPULSE_(pulse) |
+						   AT91_SMC_NCS_RDPULSE_(cycle));
+	at91_sys_write(AT91_SMC_CYCLE(chipselect), AT91_SMC_NWECYCLE_(cycle) |
+						   AT91_SMC_NRDCYCLE_(cycle));
+}
+
+static unsigned int calc_mck_cycles(unsigned int ns, unsigned int mck_hz)
+{
+	u64 tmp = ns;
+
+	tmp *= mck_hz;
+	tmp += 1000*1000*1000 - 1; /* round up */
+	do_div(tmp, 1000*1000*1000);
+	return (unsigned int) tmp;
+}
+
+static void apply_timings(const u8 chipselect, const u8 pio,
+			  const struct ide_timing *timing, int use_iordy)
+{
+	unsigned int t0, t1, t2, t6z;
+	unsigned int cycle, setup, pulse, data_float;
+	unsigned int mck_hz;
+	struct clk *mck;
+
+	/* see table 22 of Compact Flash standard 4.1 for the meaning,
+	 * we do not stretch active (t2) time, so setup (t1) + hold time (th)
+	 * assure at least minimal recovery (t2i) time */
+	t0 = timing->cyc8b;
+	t1 = timing->setup;
+	t2 = timing->act8b;
+	t6z = (pio < 5) ? 30 : 20;
+
+	pdbg("t0=%u t1=%u t2=%u t6z=%u\n", t0, t1, t2, t6z);
+
+	mck = clk_get(NULL, "mck");
+	BUG_ON(IS_ERR(mck));
+	mck_hz = clk_get_rate(mck);
+	pdbg("mck_hz=%u\n", mck_hz);
+
+	cycle = calc_mck_cycles(t0, mck_hz);
+	setup = calc_mck_cycles(t1, mck_hz);
+	pulse = calc_mck_cycles(t2, mck_hz);
+	data_float = calc_mck_cycles(t6z, mck_hz);
+
+	pdbg("cycle=%u setup=%u pulse=%u data_float=%u\n",
+	     cycle, setup, pulse, data_float);
+
+	set_smc_timings(chipselect, cycle, setup, pulse, data_float, use_iordy);
+}
+
+static void at91_ide_input_data(ide_drive_t *drive, struct request *rq,
+				void *buf, unsigned int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	u8 chipselect = hwif->select_data;
+	unsigned long mode;
+
+	pdbg("cs %u buf %p len %d\n", chipselect, buf, len);
+
+	len++;
+
+	enter_16bit(chipselect, mode);
+	__ide_mm_insw((void __iomem *) io_ports->data_addr, buf, len / 2);
+	leave_16bit(chipselect, mode);
+}
+
+static void at91_ide_output_data(ide_drive_t *drive, struct request *rq,
+				 void *buf, unsigned int len)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	u8 chipselect = hwif->select_data;
+	unsigned long mode;
+
+	pdbg("cs %u buf %p len %d\n", chipselect,  buf, len);
+
+	enter_16bit(chipselect, mode);
+	__ide_mm_outsw((void __iomem *) io_ports->data_addr, buf, len / 2);
+	leave_16bit(chipselect, mode);
+}
+
+static u8 ide_mm_inb(unsigned long port)
+{
+	return readb((void __iomem *) port);
+}
+
+static void ide_mm_outb(u8 value, unsigned long port)
+{
+	writeb(value, (void __iomem *) port);
+}
+
+static void at91_ide_tf_load(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
+
+	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+		HIHI = 0xFF;
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DATA) {
+		u16 data = (tf->hob_data << 8) | tf->data;
+
+		at91_ide_output_data(drive, NULL, &data, 2);
+	}
+
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_FEATURE)
+		ide_mm_outb(tf->hob_feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_NSECT)
+		ide_mm_outb(tf->hob_nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAL)
+		ide_mm_outb(tf->hob_lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAM)
+		ide_mm_outb(tf->hob_lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_HOB_LBAH)
+		ide_mm_outb(tf->hob_lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_FEATURE)
+		ide_mm_outb(tf->feature, io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_NSECT)
+		ide_mm_outb(tf->nsect, io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAL)
+		ide_mm_outb(tf->lbal, io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAM)
+		ide_mm_outb(tf->lbam, io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_OUT_LBAH)
+		ide_mm_outb(tf->lbah, io_ports->lbah_addr);
+
+	if (task->tf_flags & IDE_TFLAG_OUT_DEVICE)
+		ide_mm_outb((tf->device & HIHI) | drive->select, io_ports->device_addr);
+}
+
+static void at91_ide_tf_read(ide_drive_t *drive, ide_task_t *task)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	struct ide_io_ports *io_ports = &hwif->io_ports;
+	struct ide_taskfile *tf = &task->tf;
+
+	if (task->tf_flags & IDE_TFLAG_IN_DATA) {
+		u16 data;
+
+		at91_ide_input_data(drive, NULL, &data, 2);
+		tf->data = data & 0xff;
+		tf->hob_data = (data >> 8) & 0xff;
+	}
+
+	/* be sure we're looking at the low order bits */
+	ide_mm_outb(ATA_DEVCTL_OBS & ~0x80, io_ports->ctl_addr);
+
+	if (task->tf_flags & IDE_TFLAG_IN_FEATURE)
+		tf->feature = ide_mm_inb(io_ports->feature_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_NSECT)
+		tf->nsect  = ide_mm_inb(io_ports->nsect_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAL)
+		tf->lbal   = ide_mm_inb(io_ports->lbal_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAM)
+		tf->lbam   = ide_mm_inb(io_ports->lbam_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_LBAH)
+		tf->lbah   = ide_mm_inb(io_ports->lbah_addr);
+	if (task->tf_flags & IDE_TFLAG_IN_DEVICE)
+		tf->device = ide_mm_inb(io_ports->device_addr);
+
+	if (task->tf_flags & IDE_TFLAG_LBA48) {
+		ide_mm_outb(ATA_DEVCTL_OBS | 0x80, io_ports->ctl_addr);
+
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_FEATURE)
+			tf->hob_feature = ide_mm_inb(io_ports->feature_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_NSECT)
+			tf->hob_nsect   = ide_mm_inb(io_ports->nsect_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAL)
+			tf->hob_lbal    = ide_mm_inb(io_ports->lbal_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAM)
+			tf->hob_lbam    = ide_mm_inb(io_ports->lbam_addr);
+		if (task->tf_flags & IDE_TFLAG_IN_HOB_LBAH)
+			tf->hob_lbah    = ide_mm_inb(io_ports->lbah_addr);
+	}
+}
+
+static void at91_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
+{
+	struct ide_timing *timing;
+	u8 chipselect = drive->hwif->select_data;
+	int use_iordy = 0;
+
+	pdbg("chipselect %u pio %u\n", chipselect, pio);
+
+	timing = ide_timing_find_mode(XFER_PIO_0 + pio);
+	BUG_ON(!timing);
+
+	if ((pio > 2 || ata_id_has_iordy(drive->id)) &&
+	    !(ata_id_is_cfa(drive->id) && pio > 4))
+		use_iordy = 1;
+
+	apply_timings(chipselect, pio, timing, use_iordy);
+}
+
+static const struct ide_tp_ops at91_ide_tp_ops = {
+	.exec_command	= ide_exec_command,
+	.read_status	= ide_read_status,
+	.read_altstatus	= ide_read_altstatus,
+	.set_irq	= ide_set_irq,
+
+	.tf_load	= at91_ide_tf_load,
+	.tf_read	= at91_ide_tf_read,
+
+	.input_data	= at91_ide_input_data,
+	.output_data	= at91_ide_output_data,
+};
+
+static const struct ide_port_ops at91_ide_port_ops = {
+	.set_pio_mode	= at91_ide_set_pio_mode,
+};
+
+static const struct ide_port_info at91_ide_port_info __initdata = {
+	.port_ops	= &at91_ide_port_ops,
+	.tp_ops		= &at91_ide_tp_ops,
+	.host_flags 	= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA | IDE_HFLAG_SINGLE |
+			  IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_UNMASK_IRQS,
+	.pio_mask 	= ATA_PIO5,
+};
+
+/*
+ * If interrupt is delivered through GPIO, IRQ are triggered on falling
+ * and rising edge of signal. Whereas IDE device request interrupt on high
+ * level (rising edge in our case). This mean we have fake interrupts, so
+ * we need to check interrupt pin and exit instantly from ISR when line
+ * is on low level.
+ */
+
+irqreturn_t at91_irq_handler(int irq, void *dev_id)
+{
+	int ntries = 8;
+	int pin_val1, pin_val2;
+
+	/* additional deglitch, line can be noisy in badly designed PCB */
+	do {
+		pin_val1 = at91_get_gpio_value(irq);
+		pin_val2 = at91_get_gpio_value(irq);
+	} while (pin_val1 != pin_val2 && --ntries > 0);
+
+	if (pin_val1 == 0 || ntries <= 0)
+		return IRQ_HANDLED;
+
+	return ide_intr(irq, dev_id);
+}
+
+static int __init at91_ide_probe(struct platform_device *pdev)
+{
+	int ret;
+	hw_regs_t hw;
+	hw_regs_t *hws[] = { &hw, NULL, NULL, NULL };
+	struct ide_host *host;
+	struct resource *res;
+	unsigned long tf_base = 0, ctl_base = 0;
+	struct at91_cf_data *board = pdev->dev.platform_data;
+
+	if (!board)
+		return -ENODEV;
+
+	if (board->det_pin && at91_get_gpio_value(board->det_pin) != 0) {
+		perr("no device detected\n");
+		return -ENODEV;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		perr("can't get memory resource\n");
+		return -ENODEV;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, res->start + TASK_FILE,
+				     REGS_SIZE, "ide") ||
+	    !devm_request_mem_region(&pdev->dev, res->start + ALT_MODE,
+				     REGS_SIZE, "alt")) {
+		perr("memory resources in use\n");
+		return -EBUSY;
+	}
+
+	pdbg("chipselect %u irq %u res %08lx\n", board->chipselect,
+	     board->irq_pin, (unsigned long) res->start);
+
+	tf_base = (unsigned long) devm_ioremap(&pdev->dev, res->start + TASK_FILE,
+					       REGS_SIZE);
+	ctl_base = (unsigned long) devm_ioremap(&pdev->dev, res->start + ALT_MODE,
+						REGS_SIZE);
+	if (!tf_base || !ctl_base) {
+		perr("can't map memory regions\n");
+		return -EBUSY;
+	}
+
+	memset(&hw, 0, sizeof(hw));
+
+	if (board->flags & AT91_IDE_SWAP_A0_A2) {
+		/* workaround for stupid hardware bug */
+		hw.io_ports.data_addr	= tf_base + 0;
+		hw.io_ports.error_addr	= tf_base + 4;
+		hw.io_ports.nsect_addr	= tf_base + 2;
+		hw.io_ports.lbal_addr	= tf_base + 6;
+		hw.io_ports.lbam_addr	= tf_base + 1;
+		hw.io_ports.lbah_addr	= tf_base + 5;
+		hw.io_ports.device_addr = tf_base + 3;
+		hw.io_ports.command_addr = tf_base + 7;
+		hw.io_ports.ctl_addr	= ctl_base + 3;
+	} else
+		ide_std_init_ports(&hw, tf_base, ctl_base + 6);
+
+	hw.irq = board->irq_pin;
+	hw.chipset = ide_generic;
+	hw.dev = &pdev->dev;
+
+	host = ide_host_alloc(&at91_ide_port_info, hws);
+	if (!host) {
+		perr("failed to allocate ide host\n");
+		return -ENOMEM;
+	}
+
+	/* setup Static Memory Controller - PIO 0 as default */
+	apply_timings(board->chipselect, 0, ide_timing_find_mode(XFER_PIO_0), 0);
+
+	/* with GPIO interrupt we have to do quirks in handler */
+	if (board->irq_pin >= PIN_BASE)
+		host->irq_handler = at91_irq_handler;
+
+	host->ports[0]->select_data = board->chipselect;
+
+	ret = ide_host_register(host, &at91_ide_port_info, hws);
+	if (ret) {
+		perr("failed to register ide host\n");
+		goto err_free_host;
+	}
+	platform_set_drvdata(pdev, host);
+	return 0;
+
+err_free_host:
+	ide_host_free(host);
+	return ret;
+}
+
+static int __exit at91_ide_remove(struct platform_device *pdev)
+{
+	struct ide_host *host = platform_get_drvdata(pdev);
+
+	ide_host_remove(host);
+	return 0;
+}
+
+static struct platform_driver at91_ide_driver = {
+	.driver	= {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.remove	= __exit_p(at91_ide_remove),
+};
+
+static int __init at91_ide_init(void)
+{
+	return platform_driver_probe(&at91_ide_driver, at91_ide_probe);
+}
+
+static void __exit at91_ide_exit(void)
+{
+	platform_driver_unregister(&at91_ide_driver);
+}
+
+module_init(at91_ide_init);
+module_exit(at91_ide_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Stanislaw Gruszka <stf_xl@wp.pl>");
+
diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
index 1146f42..1f86dcb 100644
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -125,5 +125,5 @@ const struct ide_proc_devset ide_disk_settings[] = {
 	IDE_PROC_DEVSET(multcount,	0,    16),
 	IDE_PROC_DEVSET(nowerr,		0,     1),
 	IDE_PROC_DEVSET(wcache,		0,     1),
-	{ 0 },
+	{ NULL },
 };
diff --git a/drivers/ide/ide-floppy_proc.c b/drivers/ide/ide-floppy_proc.c
index 3ec762c..fcd4d81 100644
--- a/drivers/ide/ide-floppy_proc.c
+++ b/drivers/ide/ide-floppy_proc.c
@@ -29,5 +29,5 @@ const struct ide_proc_devset ide_floppy_settings[] = {
 	IDE_PROC_DEVSET(bios_head, 0,  255),
 	IDE_PROC_DEVSET(bios_sect, 0,   63),
 	IDE_PROC_DEVSET(ticks,	   0,  255),
-	{ 0 },
+	{ NULL },
 };
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 9ee51ad..a9a6c20 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -908,7 +908,7 @@ void ide_timer_expiry (unsigned long data)
 	ide_drive_t	*uninitialized_var(drive);
 	ide_handler_t	*handler;
 	unsigned long	flags;
-	unsigned long	wait = -1;
+	int		wait = -1;
 	int		plug_device = 0;
 
 	spin_lock_irqsave(&hwif->lock, flags);
@@ -1162,6 +1162,7 @@ out_early:
 
 	return irq_ret;
 }
+EXPORT_SYMBOL_GPL(ide_intr);
 
 /**
  *	ide_do_drive_cmd	-	issue IDE special command
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 753b92e..b1892bd 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -315,6 +315,8 @@ void ide_output_data(ide_drive_t *drive, struct request *rq, void *buf,
 	u8 io_32bit = drive->io_32bit;
 	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
 
+	len++;
+
 	if (io_32bit) {
 		unsigned long uninitialized_var(flags);
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ce0818a..ee8e3e7 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -950,6 +950,7 @@ static int ide_port_setup_devices(ide_hwif_t *hwif)
 static int init_irq (ide_hwif_t *hwif)
 {
 	struct ide_io_ports *io_ports = &hwif->io_ports;
+	irq_handler_t irq_handler;
 	int sa = 0;
 
 	mutex_lock(&ide_cfg_mtx);
@@ -959,6 +960,10 @@ static int init_irq (ide_hwif_t *hwif)
 	hwif->timer.function = &ide_timer_expiry;
 	hwif->timer.data = (unsigned long)hwif;
 
+	irq_handler = hwif->host->irq_handler;
+	if (irq_handler == NULL)
+		irq_handler = ide_intr;
+
 #if defined(__mc68000__)
 	sa = IRQF_SHARED;
 #endif /* __mc68000__ */
@@ -969,7 +974,7 @@ static int init_irq (ide_hwif_t *hwif)
 	if (io_ports->ctl_addr)
 		hwif->tp_ops->set_irq(hwif, 1);
 
-	if (request_irq(hwif->irq, &ide_intr, sa, hwif->name, hwif))
+	if (request_irq(hwif->irq, irq_handler, sa, hwif->name, hwif))
 		goto out_up;
 
 	if (!hwif->rqsize) {
diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 1d8978b..a7b9287 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -231,7 +231,7 @@ static const struct ide_proc_devset ide_generic_settings[] = {
 	IDE_PROC_DEVSET(pio_mode, 0, 255),
 	IDE_PROC_DEVSET(unmaskirq, 0, 1),
 	IDE_PROC_DEVSET(using_dma, 0, 1),
-	{ 0 },
+	{ NULL },
 };
 
 static void proc_ide_settings_warn(void)
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index bb450a7..4e6181c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2166,7 +2166,7 @@ static const struct ide_proc_devset idetape_settings[] = {
 	__IDE_PROC_DEVSET(speed,	0, 0xffff, NULL, NULL),
 	__IDE_PROC_DEVSET(tdsc,		IDETAPE_DSC_RW_MIN, IDETAPE_DSC_RW_MAX,
 					mulf_tdsc, divf_tdsc),
-	{ 0 },
+	{ NULL },
 };
 #endif
 
diff --git a/include/linux/hdreg.h b/include/linux/hdreg.h
index c37e924..ed21bd3 100644
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -511,7 +511,6 @@ struct hd_driveid {
 	unsigned short	words69_70[2];	/* reserved words 69-70
 					 * future command overlap and queuing
 					 */
-	/* HDIO_GET_IDENTITY currently returns only words 0 through 70 */
 	unsigned short	words71_74[4];	/* reserved words 71-74
 					 * for IDENTIFY PACKET DEVICE command
 					 */
diff --git a/include/linux/ide.h b/include/linux/ide.h
index fe235b6..e0cedfe 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -866,6 +866,7 @@ struct ide_host {
 	unsigned int	n_ports;
 	struct device	*dev[2];
 	unsigned int	(*init_chipset)(struct pci_dev *);
+	irq_handler_t	irq_handler;
 	unsigned long	host_flags;
 	void		*host_priv;
 	ide_hwif_t	*cur_port;	/* for hosts requiring serialization */
