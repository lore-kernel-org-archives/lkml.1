Return-Path: <linux-kernel-owner+w=401wt.eu-S932307AbZLNRtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbZLNRtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:49:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932265AbZLNRtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:49:11 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:33358 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbZLNRtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:49:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] au1xxx-ide.c: ioremap() returns a void __iomem *
Date: Mon, 14 Dec 2009 12:49:01 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200E9BC@mi8nycmail19.Mi8.com>
In-Reply-To: <20091213.205212.212692978.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] au1xxx-ide.c: ioremap() returns a void __iomem *
Thread-Index: Acp8eTMHPJGGY6wBSTKbOns8bMhuMgAa8r6A
References: <BD79186B4FD85F4B8E60E381CAEE190901FB10C2@mi8nycmail19.Mi8.com><4B241F10.7050706@ru.mvista.com> <20091213.205212.212692978.davem@davemloft.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Miller" <davem@davemloft.net>, <sshtylyov@ru.mvista.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 14 Dec 2009 17:49:02.0840 (UTC) FILETIME=[B91B2780:01CA7CE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioremap return value is an __iomem *, not an integer.  Update the
private structure to reflect this.  While here, remove the typedef
for _auide_hwif and just use struct auide_hwif instead as recommended
by Documentation/CodingStyle.

auide_setup_ports() still needs to cast the regbase back to an integer
to correctly setup the io_ports_array.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: David Miller <davem@davemloft.net>

---

Based on top of commit 4b7c7237c0826417059d2e60ffe6ed43202dc087
David, please let me know if it still does not apply.

V2 - fix spelling of contains in the documentation as pointed out by
     Sergei Shtylyov

diff --git a/Documentation/mips/AU1xxx_IDE.README b/Documentation/mips/AU1xxx_IDE.README
index 8ace35e..af092f8 100644
--- a/Documentation/mips/AU1xxx_IDE.README
+++ b/Documentation/mips/AU1xxx_IDE.README
@@ -45,9 +45,9 @@ FILES, CONFIGS AND COMPATABILITY
 Two files are introduced:
 
   a) 'arch/mips/include/asm/mach-au1x00/au1xxx_ide.h'
-     containes : struct _auide_hwif
-                 timing parameters for PIO mode 0/1/2/3/4
-                 timing parameters for MWDMA 0/1/2
+     contains : struct auide_hwif
+                timing parameters for PIO mode 0/1/2/3/4
+                timing parameters for MWDMA 0/1/2
 
   b) 'drivers/ide/mips/au1xxx-ide.c'
      contains the functionality of the AU1XXX IDE driver
diff --git a/arch/mips/include/asm/mach-au1x00/au1xxx_ide.h b/arch/mips/include/asm/mach-au1x00/au1xxx_ide.h
index 5656c72..f44b8bc 100644
--- a/arch/mips/include/asm/mach-au1x00/au1xxx_ide.h
+++ b/arch/mips/include/asm/mach-au1x00/au1xxx_ide.h
@@ -46,7 +46,7 @@
 #define CONFIG_BLK_DEV_IDE_AU1XXX_BURSTABLE_ON	0
 #endif
 
-typedef struct {
+struct auide_hwif {
 	u32			tx_dev_id, rx_dev_id, target_dev_id;
 	u32			tx_chan, rx_chan;
 	void			*tx_desc_head, *rx_desc_head;
@@ -57,8 +57,8 @@ typedef struct {
 	dma_addr_t		dma_table_dma;
 #endif
 	int			irq;
-	u32			regbase;
-} _auide_hwif;
+	void __iomem		*regbase;
+};
 
 /******************************************************************************/
 /* PIO Mode timing calculation :					      */
diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 87cef0c..65abf57 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -46,13 +46,13 @@
 /* enable the burstmode in the dbdma */
 #define IDE_AU1XXX_BURSTMODE	1
 
-static _auide_hwif auide_hwif;
+static struct auide_hwif auide_hwif;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA)
 
 static inline void auide_insw(unsigned long port, void *addr, u32 count)
 {
-	_auide_hwif *ahwif = &auide_hwif;
+	struct auide_hwif *ahwif = &auide_hwif;
 	chan_tab_t *ctp;
 	au1x_ddma_desc_t *dp;
 
@@ -70,7 +70,7 @@ static inline void auide_insw(unsigned long port, void *addr, u32 count)
 
 static inline void auide_outsw(unsigned long port, void *addr, u32 count)
 {
-	_auide_hwif *ahwif = &auide_hwif;
+	struct auide_hwif *ahwif = &auide_hwif;
 	chan_tab_t *ctp;
 	au1x_ddma_desc_t *dp;
 
@@ -212,7 +212,7 @@ static void auide_set_dma_mode(ide_drive_t *drive, const u8 speed)
 static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	_auide_hwif *ahwif = &auide_hwif;
+	struct auide_hwif *ahwif = &auide_hwif;
 	struct scatterlist *sg;
 	int i = cmd->sg_nents, count = 0;
 	int iswrite = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
@@ -344,7 +344,7 @@ static const struct ide_dma_ops au1xxx_dma_ops = {
 
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-	_auide_hwif *auide = &auide_hwif;
+	struct auide_hwif *auide = &auide_hwif;
 	dbdev_tab_t source_dev_tab, target_dev_tab;
 	u32 dev_id, tsize, devwidth, flags;
 
@@ -404,7 +404,7 @@ static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 #else
 static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-	_auide_hwif *auide = &auide_hwif;
+	struct auide_hwif *auide = &auide_hwif;
 	dbdev_tab_t source_dev_tab;
 	int flags;
 
@@ -449,17 +449,18 @@ static int auide_ddma_init(ide_hwif_t *hwif, const struct ide_port_info *d)
 }
 #endif
 
-static void auide_setup_ports(struct ide_hw *hw, _auide_hwif *ahwif)
+static void auide_setup_ports(struct ide_hw *hw, struct auide_hwif *ahwif)
 {
-	int i;
 	unsigned long *ata_regs = hw->io_ports_array;
+	unsigned long regbase = (unsigned long)ahwif->regbase;
+	int i;
 
 	/* FIXME? */
 	for (i = 0; i < 8; i++)
-		*ata_regs++ = ahwif->regbase + (i << IDE_REG_SHIFT);
+		*ata_regs++ = regbase + (i << IDE_REG_SHIFT);
 
 	/* set the Alternative Status register */
-	*ata_regs = ahwif->regbase + (14 << IDE_REG_SHIFT);
+	*ata_regs = regbase + (14 << IDE_REG_SHIFT);
 }
 
 #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_PIO_DBDMA
@@ -504,7 +505,7 @@ static const struct ide_port_info au1xxx_port_info = {
 
 static int au_ide_probe(struct platform_device *dev)
 {
-	_auide_hwif *ahwif = &auide_hwif;
+	struct auide_hwif *ahwif = &auide_hwif;
 	struct resource *res;
 	struct ide_host *host;
 	int ret = 0;
@@ -516,7 +517,7 @@ static int au_ide_probe(struct platform_device *dev)
 	char *mode = "PIO+DDMA(offload)";
 #endif
 
-	memset(&auide_hwif, 0, sizeof(_auide_hwif));
+	memset(&auide_hwif, 0, sizeof(struct auide_hwif));
 	ahwif->irq = platform_get_irq(dev, 0);
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
@@ -538,7 +539,7 @@ static int au_ide_probe(struct platform_device *dev)
 		goto out;
 	}
 
-	ahwif->regbase = (u32)ioremap(res->start, resource_size(res));
+	ahwif->regbase = ioremap(res->start, resource_size(res));
 	if (ahwif->regbase == 0) {
 		ret = -ENOMEM;
 		goto out;
@@ -567,11 +568,11 @@ static int au_ide_remove(struct platform_device *dev)
 {
 	struct resource *res;
 	struct ide_host *host = platform_get_drvdata(dev);
-	_auide_hwif *ahwif = &auide_hwif;
+	struct auide_hwif *ahwif = &auide_hwif;
 
 	ide_host_remove(host);
 
-	iounmap((void *)ahwif->regbase);
+	iounmap(ahwif->regbase);
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res)); 
