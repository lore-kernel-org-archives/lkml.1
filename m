Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZDWVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZDWVGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZDWVGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:06:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39854 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZDWVGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=iCKh1O/1ZcvZtMkJmynu/JLj+mzENUA4dKXi2ztOBdLMifn4lvFiIQ0rjSA9LgbILi
         qWcmOTVzGisXGnKqmTkuEy5ix1hiGEn/rS2RvcI0iotX45vQppxx7dPbdOlMsnR2iNZt
         j+Acfsu8jW//+at9bMCGFI7FZjNJNfxOjR/Nc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes (updated)
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 23 Apr 2009 23:08:58 +0200
Message-Id: <200904232308.58473.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The pull request from yesterday updated with more palm_bk3710 bug fixes
from David Brownell and a little CodingStyle fixup (noticed by Joe Perches).

I also updated MAINTAINERS file to reflect conversion of the IDE tree
from quilt to git (done based on a popular demand :).

Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 MAINTAINERS                  |    2 +-
 drivers/ide/ide-cd.c         |    2 +-
 drivers/ide/ide-gd.c         |   17 +++++++-
 drivers/ide/palm_bk3710.c    |   93 +++++++++++++----------------------------
 drivers/macintosh/mediabay.c |    1 -
 5 files changed, 48 insertions(+), 67 deletions(-)


Bartlomiej Zolnierkiewicz (3):
      mediabay: fix build for CONFIG_BLOCK=n
      palm_bk3710: palm_bk3710_udmatimings[] CodingStyle fixup
      MAINTAINERS: update IDE entry

Bruno Prémont (1):
      ide: Stop disks on reboot for laptop which cuts power

David Brownell (2):
      palm_bk3710: UDMA performance fix
      palm_bk3710: those registers/bitfields don't exist

Helge Deller (1):
      ide-cd: fix kernel crash on hppa regression


diff --git a/MAINTAINERS b/MAINTAINERS
index 0beac8a..2431b05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2743,7 +2743,7 @@ IDE SUBSYSTEM
 P:	Bartlomiej Zolnierkiewicz
 M:	bzolnier@gmail.com
 L:	linux-ide@vger.kernel.org
-T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
 S:	Maintained
 F:	Documentation/ide/
 F:	drivers/ide/
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3aec19d..3d4e099 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -609,7 +609,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, thislen, uptodate = 0;
-	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0, nsectors;
 	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 1aebdf1..4b6b71e 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -7,6 +7,7 @@
 #include <linux/mutex.h>
 #include <linux/ide.h>
 #include <linux/hdreg.h>
+#include <linux/dmi.h>
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define IDE_DISK_MINORS		(1 << PARTN_BITS)
@@ -99,6 +100,19 @@ static void ide_gd_resume(ide_drive_t *drive)
 		(void)drive->disk_ops->get_capacity(drive);
 }
 
+static const struct dmi_system_id ide_coldreboot_table[] = {
+	{
+		/* Acer TravelMate 66x cuts power during reboot */
+		.ident   = "Acer TravelMate 660",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+		},
+	},
+
+	{ }	/* terminate list */
+};
+
 static void ide_gd_shutdown(ide_drive_t *drive)
 {
 #ifdef	CONFIG_ALPHA
@@ -115,7 +129,8 @@ static void ide_gd_shutdown(ide_drive_t *drive)
 	   the disk to expire its write cache. */
 	if (system_state != SYSTEM_POWER_OFF) {
 #else
-	if (system_state == SYSTEM_RESTART) {
+	if (system_state == SYSTEM_RESTART &&
+		!dmi_check_system(ide_coldreboot_table)) {
 #endif
 		drive->disk_ops->flush(drive);
 		return;
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index c7acca0..09d813d 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -39,27 +39,12 @@
 /* Primary Control Offset */
 #define IDE_PALM_ATA_PRI_CTL_OFFSET 0x3F6
 
-/*
- * PalmChip 3710 IDE Controller UDMA timing structure Definition
- */
-struct palm_bk3710_udmatiming {
-	unsigned int rptime;	/* Ready to pause time  */
-	unsigned int cycletime;	/* Cycle Time           */
-};
-
 #define BK3710_BMICP		0x00
 #define BK3710_BMISP		0x02
 #define BK3710_BMIDTP		0x04
-#define BK3710_BMICS		0x08
-#define BK3710_BMISS		0x0A
-#define BK3710_BMIDTS		0x0C
 #define BK3710_IDETIMP		0x40
-#define BK3710_IDETIMS		0x42
-#define BK3710_SIDETIM		0x44
-#define BK3710_SLEWCTL		0x45
 #define BK3710_IDESTATUS	0x47
 #define BK3710_UDMACTL		0x48
-#define BK3710_UDMATIM		0x4A
 #define BK3710_MISCCTL		0x50
 #define BK3710_REGSTB		0x54
 #define BK3710_REGRCVR		0x58
@@ -71,17 +56,22 @@ struct palm_bk3710_udmatiming {
 #define BK3710_UDMATRP		0x70
 #define BK3710_UDMAENV		0x74
 #define BK3710_IORDYTMP		0x78
-#define BK3710_IORDYTMS		0x7C
 
 static unsigned ideclk_period; /* in nanoseconds */
 
+struct palm_bk3710_udmatiming {
+	unsigned int rptime;	/* tRP -- Ready to pause time (nsec) */
+	unsigned int cycletime;	/* tCYCTYP2/2 -- avg Cycle Time (nsec) */
+				/* tENV is always a minimum of 20 nsec */
+};
+
 static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
-	{160, 240},		/* UDMA Mode 0 */
-	{125, 160},		/* UDMA Mode 1 */
-	{100, 120},		/* UDMA Mode 2 */
-	{100, 90},		/* UDMA Mode 3 */
-	{100, 60},		/* UDMA Mode 4 */
-	{85,  40},		/* UDMA Mode 5 */
+	{ 160, 240 / 2 },	/* UDMA Mode 0 */
+	{ 125, 160 / 2 },	/* UDMA Mode 1 */
+	{ 100, 120 / 2 },	/* UDMA Mode 2 */
+	{ 100,  90 / 2 },	/* UDMA Mode 3 */
+	{ 100,  60 / 2 },	/* UDMA Mode 4 */
+	{  85,  40 / 2 },	/* UDMA Mode 5 */
 };
 
 static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
@@ -98,11 +88,6 @@ static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
 	trp = DIV_ROUND_UP(palm_bk3710_udmatimings[mode].rptime,
 			   ideclk_period) - 1;
 
-	/* udmatim Register */
-	val16 = readw(base + BK3710_UDMATIM) & (dev ? 0xFF0F : 0xFFF0);
-	val16 |= (mode << (dev ? 4 : 0));
-	writew(val16, base + BK3710_UDMATIM);
-
 	/* udmastb Ultra DMA Access Strobe Width */
 	val32 = readl(base + BK3710_UDMASTB) & (0xFF << (dev ? 0 : 8));
 	val32 |= (t0 << (dev ? 8 : 0));
@@ -163,10 +148,11 @@ static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
 	u32 val32;
 	struct ide_timing *t;
 
+	t = ide_timing_find_mode(XFER_PIO_0 + mode);
+
 	/* PIO Data Setup */
 	t0 = DIV_ROUND_UP(cycletime, ideclk_period);
-	t2 = DIV_ROUND_UP(ide_timing_find_mode(XFER_PIO_0 + mode)->active,
-			  ideclk_period);
+	t2 = DIV_ROUND_UP(t->active, ideclk_period);
 
 	t2i = t0 - t2 - 1;
 	t2 -= 1;
@@ -187,7 +173,6 @@ static void palm_bk3710_setpiomode(void __iomem *base, ide_drive_t *mate,
 	}
 
 	/* TASKFILE Setup */
-	t = ide_timing_find_mode(XFER_PIO_0 + mode);
 	t0 = DIV_ROUND_UP(t->cyc8b, ideclk_period);
 	t2 = DIV_ROUND_UP(t->act8b, ideclk_period);
 
@@ -236,42 +221,23 @@ static void palm_bk3710_set_pio_mode(ide_drive_t *drive, u8 pio)
 static void __devinit palm_bk3710_chipinit(void __iomem *base)
 {
 	/*
-	 * enable the reset_en of ATA controller so that when ata signals
-	 * are brought out, by writing into device config. at that
-	 * time por_n signal should not be 'Z' and have a stable value.
+	 * REVISIT:  the ATA reset signal needs to be managed through a
+	 * GPIO, which means it should come from platform_data.  Until
+	 * we get and use such information, we have to trust that things
+	 * have been reset before we get here.
 	 */
-	writel(0x0300, base + BK3710_MISCCTL);
-
-	/* wait for some time and deassert the reset of ATA Device. */
-	mdelay(100);
-
-	/* Deassert the Reset */
-	writel(0x0200, base + BK3710_MISCCTL);
 
 	/*
 	 * Program the IDETIMP Register Value based on the following assumptions
 	 *
 	 * (ATA_IDETIMP_IDEEN		, ENABLE ) |
-	 * (ATA_IDETIMP_SLVTIMEN	, DISABLE) |
-	 * (ATA_IDETIMP_RDYSMPL		, 70NS)    |
-	 * (ATA_IDETIMP_RDYRCVRY	, 50NS)    |
-	 * (ATA_IDETIMP_DMAFTIM1	, PIOCOMP) |
 	 * (ATA_IDETIMP_PREPOST1	, DISABLE) |
-	 * (ATA_IDETIMP_RDYSEN1		, DISABLE) |
-	 * (ATA_IDETIMP_PIOFTIM1	, DISABLE) |
-	 * (ATA_IDETIMP_DMAFTIM0	, PIOCOMP) |
 	 * (ATA_IDETIMP_PREPOST0	, DISABLE) |
-	 * (ATA_IDETIMP_RDYSEN0		, DISABLE) |
-	 * (ATA_IDETIMP_PIOFTIM0	, DISABLE)
-	 */
-	writew(0xB388, base + BK3710_IDETIMP);
-
-	/*
-	 * Configure  SIDETIM  Register
-	 * (ATA_SIDETIM_RDYSMPS1	,120NS ) |
-	 * (ATA_SIDETIM_RDYRCYS1	,120NS )
+	 *
+	 * DM6446 silicon rev 2.1 and earlier have no observed net benefit
+	 * from enabling prefetch/postwrite.
 	 */
-	writeb(0, base + BK3710_SIDETIM);
+	writew(BIT(15), base + BK3710_IDETIMP);
 
 	/*
 	 * UDMACTL Ultra-ATA DMA Control
@@ -283,11 +249,11 @@ static void __devinit palm_bk3710_chipinit(void __iomem *base)
 
 	/*
 	 * MISCCTL Miscellaneous Conrol Register
-	 * (ATA_MISCCTL_RSTMODEP	, 1) |
-	 * (ATA_MISCCTL_RESETP		, 0) |
+	 * (ATA_MISCCTL_HWNHLD1P	, 1 cycle)
+	 * (ATA_MISCCTL_HWNHLD0P	, 1 cycle)
 	 * (ATA_MISCCTL_TIMORIDE	, 1)
 	 */
-	writel(0x201, base + BK3710_MISCCTL);
+	writel(0x001, base + BK3710_MISCCTL);
 
 	/*
 	 * IORDYTMP IORDY Timer for Primary Register
@@ -357,10 +323,9 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 
 	clk_enable(clk);
 	rate = clk_get_rate(clk);
-	ideclk_period = 1000000000UL / rate;
 
-	/* Register the IDE interface with Linux ATA Interface */
-	memset(&hw, 0, sizeof(hw));
+	/* NOTE:  round *down* to meet minimum timings; we count in clocks */
+	ideclk_period = 1000000000UL / rate;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (mem == NULL) {
@@ -390,6 +355,7 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 	/* Configure the Palm Chip controller */
 	palm_bk3710_chipinit(base);
 
+	memset(&hw, 0, sizeof(hw));
 	for (i = 0; i < IDE_NR_PORTS - 2; i++)
 		hw.io_ports_array[i] = (unsigned long)
 				(base + IDE_PALM_ATA_PRI_REG_OFFSET + i);
@@ -402,6 +368,7 @@ static int __init palm_bk3710_probe(struct platform_device *pdev)
 	palm_bk3710_port_info.udma_mask = rate < 100000000 ? ATA_UDMA4 :
 							     ATA_UDMA5;
 
+	/* Register the IDE interface with Linux */
 	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
 	if (rc)
 		goto out;
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index d7e46d3..eca55ef 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -18,7 +18,6 @@
 #include <linux/timer.h>
 #include <linux/stddef.h>
 #include <linux/init.h>
-#include <linux/ide.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <asm/prom.h>
