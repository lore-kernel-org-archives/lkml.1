Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbZLKVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbZLKVEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbZLKVEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:04:39 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:36269 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756746AbZLKVEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:04:38 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] au1xxx-ide.c: ioremap() returns a void __iomem *
Date: Fri, 11 Dec 2009 16:04:38 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB10C2@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] au1xxx-ide.c: ioremap() returns a void __iomem *
Thread-Index: Acp6pYy295Xcs/GqTgG+X+vjFtsZug==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <linux-ide@vger.kernel.org>, "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 11 Dec 2009 21:04:39.0517 (UTC) FILETIME=[8D78B0D0:01CA7AA5]
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
Cc: David Miller <davem@davemloft.net>

---

diff --git a/Documentation/mips/AU1xxx_IDE.README b/Documentation/mips/AU1xxx_IDE.README
index 8ace35e..37c6c34 100644
--- a/Documentation/mips/AU1xxx_IDE.README
+++ b/Documentation/mips/AU1xxx_IDE.README
@@ -45,7 +45,7 @@ FILES, CONFIGS AND COMPATABILITY
 Two files are introduced:
 
   a) 'arch/mips/include/asm/mach-au1x00/au1xxx_ide.h'
-     containes : struct _auide_hwif
+     containes : struct auide_hwif
                  timing parameters for PIO mode 0/1/2/3/4
                  timing parameters for MWDMA 0/1/2
 
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
