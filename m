Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYKBCoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYKBCoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 22:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYKBCoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 22:44:11 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:16720 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYKBCoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 22:44:08 -0400
Subject: Re: mtd: struct device - replace bus_id with dev_name(),
	dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <1225385998.21973.25.camel@nga.site>
References: <1225385998.21973.25.camel@nga.site>
Content-Type: text/plain
Date: Sun, 02 Nov 2008 03:44:07 +0100
Message-Id: <1225593847.2142.7.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 17:59 +0100, Kay Sievers wrote:
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".
> 
> To set and read the device name dev_name(dev) and dev_set_name(dev)
> must be used. If your code uses static kobjects, which it shouldn't
> do, "const char *init_name" can be used to statically provide the
> name the registered device should have. At registration time, the
> init_name field is cleared, to enforce the use of dev_name(dev) to
> access the device name at a later time.
> 
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.
> 
> We want to submit a patch to -next, which will remove bus_id from
> "struct device", to find the remaining pieces to convert, and finally
> switch over to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.

Updated patch, including the files I can not test compile. Please have
a look and let me know, if something is wrong with the conversion.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: mtd: struct device - replace bus_id with dev_name(), dev_set_name()

CC: David Woodhouse <dwmw2@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mtd/devices/m25p80.c        |   16 ++++++++--------
 drivers/mtd/devices/mtd_dataflash.c |   30 +++++++++++++++---------------
 drivers/mtd/maps/integrator-flash.c |    2 +-
 drivers/mtd/maps/ixp2000.c          |    4 ++--
 drivers/mtd/maps/ixp4xx.c           |    2 +-
 drivers/mtd/maps/omap_nor.c         |    2 +-
 drivers/mtd/maps/physmap.c          |    6 +++---
 drivers/mtd/maps/physmap_of.c       |    4 ++--
 drivers/mtd/mtdconcat.c             |    2 +-
 drivers/mtd/nand/fsl_upm.c          |    2 +-
 drivers/mtd/nand/plat_nand.c        |    2 +-
 drivers/mtd/nand/tmio_nand.c        |    2 +-
 drivers/mtd/onenand/generic.c       |    2 +-
 drivers/mtd/onenand/omap2.c         |    2 +-
 drivers/mtd/ubi/build.c             |    2 +-
 drivers/mtd/ubi/vmt.c               |    4 ++--
 include/linux/mtd/concat.h          |    2 +-
 17 files changed, 43 insertions(+), 43 deletions(-)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -170,7 +170,7 @@ static int wait_till_ready(struct m25p *
 static int erase_block(struct m25p *flash)
 {
 	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %dKiB\n",
-			flash->spi->dev.bus_id, __func__,
+			dev_name(&flash->spi->dev), __func__,
 			flash->mtd.size / 1024);
 
 	/* Wait until finished previous write command. */
@@ -197,7 +197,7 @@ static int erase_block(struct m25p *flas
 static int erase_sector(struct m25p *flash, u32 offset)
 {
 	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %dKiB at 0x%08x\n",
-			flash->spi->dev.bus_id, __func__,
+			dev_name(&flash->spi->dev), __func__,
 			flash->mtd.erasesize / 1024, offset);
 
 	/* Wait until finished previous write command. */
@@ -234,7 +234,7 @@ static int m25p80_erase(struct mtd_info
 	u32 addr,len;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %d\n",
-			flash->spi->dev.bus_id, __func__, "at",
+			dev_name(&flash->spi->dev), __func__, "at",
 			(u32)instr->addr, instr->len);
 
 	/* sanity checks */
@@ -292,7 +292,7 @@ static int m25p80_read(struct mtd_info *
 	struct spi_message m;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
-			flash->spi->dev.bus_id, __func__, "from",
+			dev_name(&flash->spi->dev), __func__, "from",
 			(u32)from, len);
 
 	/* sanity checks */
@@ -364,7 +364,7 @@ static int m25p80_write(struct mtd_info
 	struct spi_message m;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
-			flash->spi->dev.bus_id, __func__, "to",
+			dev_name(&flash->spi->dev), __func__, "to",
 			(u32)to, len);
 
 	if (retlen)
@@ -560,7 +560,7 @@ static struct flash_info *__devinit jede
 	tmp = spi_write_then_read(spi, &code, 1, id, 5);
 	if (tmp < 0) {
 		DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
-			spi->dev.bus_id, tmp);
+			dev_name(&spi->dev), tmp);
 		return NULL;
 	}
 	jedec = id[0];
@@ -613,7 +613,7 @@ static int __devinit m25p_probe(struct s
 		/* unrecognized chip? */
 		if (i == ARRAY_SIZE(m25p_data)) {
 			DEBUG(MTD_DEBUG_LEVEL0, "%s: unrecognized id %s\n",
-					spi->dev.bus_id, data->type);
+					dev_name(&spi->dev), data->type);
 			info = NULL;
 
 		/* recognized; is that chip really what's there? */
@@ -654,7 +654,7 @@ static int __devinit m25p_probe(struct s
 	if (data && data->name)
 		flash->mtd.name = data->name;
 	else
-		flash->mtd.name = spi->dev.bus_id;
+		flash->mtd.name = dev_name(&spi->dev);
 
 	flash->mtd.type = MTD_NORFLASH;
 	flash->mtd.writesize = 1;
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -128,7 +128,7 @@ static int dataflash_waitready(struct sp
 		status = dataflash_status(spi);
 		if (status < 0) {
 			DEBUG(MTD_DEBUG_LEVEL1, "%s: status %d?\n",
-					spi->dev.bus_id, status);
+					dev_name(&spi->dev), status);
 			status = 0;
 		}
 
@@ -154,7 +154,7 @@ static int dataflash_erase(struct mtd_in
 	uint8_t			*command;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: erase addr=0x%x len 0x%x\n",
-			spi->dev.bus_id,
+			dev_name(&spi->dev),
 			instr->addr, instr->len);
 
 	/* Sanity checks */
@@ -197,7 +197,7 @@ static int dataflash_erase(struct mtd_in
 
 		if (status < 0) {
 			printk(KERN_ERR "%s: erase %x, err %d\n",
-				spi->dev.bus_id, pageaddr, status);
+				dev_name(&spi->dev), pageaddr, status);
 			/* REVISIT:  can retry instr->retries times; or
 			 * giveup and instr->fail_addr = instr->addr;
 			 */
@@ -239,7 +239,7 @@ static int dataflash_read(struct mtd_inf
 	int			status;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: read 0x%x..0x%x\n",
-		priv->spi->dev.bus_id, (unsigned)from, (unsigned)(from + len));
+		dev_name(&priv->spi->dev), (unsigned)from, (unsigned)(from + len));
 
 	*retlen = 0;
 
@@ -288,7 +288,7 @@ static int dataflash_read(struct mtd_inf
 		status = 0;
 	} else
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: read %x..%x --> %d\n",
-			priv->spi->dev.bus_id,
+			dev_name(&priv->spi->dev),
 			(unsigned)from, (unsigned)(from + len),
 			status);
 	return status;
@@ -315,7 +315,7 @@ static int dataflash_write(struct mtd_in
 	uint8_t			*command;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: write 0x%x..0x%x\n",
-		spi->dev.bus_id, (unsigned)to, (unsigned)(to + len));
+		dev_name(&spi->dev), (unsigned)to, (unsigned)(to + len));
 
 	*retlen = 0;
 
@@ -374,7 +374,7 @@ static int dataflash_write(struct mtd_in
 			status = spi_sync(spi, &msg);
 			if (status < 0)
 				DEBUG(MTD_DEBUG_LEVEL1, "%s: xfer %u -> %d \n",
-					spi->dev.bus_id, addr, status);
+					dev_name(&spi->dev), addr, status);
 
 			(void) dataflash_waitready(priv->spi);
 		}
@@ -396,7 +396,7 @@ static int dataflash_write(struct mtd_in
 		spi_transfer_del(x + 1);
 		if (status < 0)
 			DEBUG(MTD_DEBUG_LEVEL1, "%s: pgm %u/%u -> %d \n",
-				spi->dev.bus_id, addr, writelen, status);
+				dev_name(&spi->dev), addr, writelen, status);
 
 		(void) dataflash_waitready(priv->spi);
 
@@ -416,14 +416,14 @@ static int dataflash_write(struct mtd_in
 		status = spi_sync(spi, &msg);
 		if (status < 0)
 			DEBUG(MTD_DEBUG_LEVEL1, "%s: compare %u -> %d \n",
-				spi->dev.bus_id, addr, status);
+				dev_name(&spi->dev), addr, status);
 
 		status = dataflash_waitready(priv->spi);
 
 		/* Check result of the compare operation */
 		if (status & (1 << 6)) {
 			printk(KERN_ERR "%s: compare page %u, err %d\n",
-				spi->dev.bus_id, pageaddr, status);
+				dev_name(&spi->dev), pageaddr, status);
 			remaining = 0;
 			status = -EIO;
 			break;
@@ -779,7 +779,7 @@ static struct flash_info *__devinit jede
 	tmp = spi_write_then_read(spi, &code, 1, id, 3);
 	if (tmp < 0) {
 		DEBUG(MTD_DEBUG_LEVEL0, "%s: error %d reading JEDEC ID\n",
-			spi->dev.bus_id, tmp);
+			dev_name(&spi->dev), tmp);
 		return ERR_PTR(tmp);
 	}
 	if (id[0] != 0x1f)
@@ -869,7 +869,7 @@ static int __devinit dataflash_probe(str
 	status = dataflash_status(spi);
 	if (status <= 0 || status == 0xff) {
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: status error %d\n",
-				spi->dev.bus_id, status);
+				dev_name(&spi->dev), status);
 		if (status == 0 || status == 0xff)
 			status = -ENODEV;
 		return status;
@@ -905,13 +905,13 @@ static int __devinit dataflash_probe(str
 	/* obsolete AT45DB1282 not (yet?) supported */
 	default:
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: unsupported device (%x)\n",
-				spi->dev.bus_id, status & 0x3c);
+				dev_name(&spi->dev), status & 0x3c);
 		status = -ENODEV;
 	}
 
 	if (status < 0)
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: add_dataflash --> %d\n",
-				spi->dev.bus_id, status);
+				dev_name(&spi->dev), status);
 
 	return status;
 }
@@ -921,7 +921,7 @@ static int __devexit dataflash_remove(st
 	struct dataflash	*flash = dev_get_drvdata(&spi->dev);
 	int			status;
 
-	DEBUG(MTD_DEBUG_LEVEL1, "%s: remove\n", spi->dev.bus_id);
+	DEBUG(MTD_DEBUG_LEVEL1, "%s: remove\n", dev_name(&spi->dev));
 
 	if (mtd_has_partitions() && flash->partitioned)
 		status = del_mtd_partitions(&flash->mtd);
--- a/drivers/mtd/maps/integrator-flash.c
+++ b/drivers/mtd/maps/integrator-flash.c
@@ -105,7 +105,7 @@ static int armflash_probe(struct platfor
 	info->map.bankwidth	= plat->width;
 	info->map.phys		= res->start;
 	info->map.virt		= base;
-	info->map.name		= dev->dev.bus_id;
+	info->map.name		= dev_name(&dev->dev);
 	info->map.set_vpp	= armflash_set_vpp;
 
 	simple_map_init(&info->map);
--- a/drivers/mtd/maps/ixp2000.c
+++ b/drivers/mtd/maps/ixp2000.c
@@ -188,7 +188,7 @@ static int ixp2000_flash_probe(struct pl
  	 */
 	info->map.map_priv_2 = (unsigned long) ixp_data->bank_setup;
 
-	info->map.name = dev->dev.bus_id;
+	info->map.name = dev_name(&dev->dev);
 	info->map.read = ixp2000_flash_read8;
 	info->map.write = ixp2000_flash_write8;
 	info->map.copy_from = ixp2000_flash_copy_from;
@@ -196,7 +196,7 @@ static int ixp2000_flash_probe(struct pl
 
 	info->res = request_mem_region(dev->resource->start,
 			dev->resource->end - dev->resource->start + 1,
-			dev->dev.bus_id);
+			dev_name(&dev->dev));
 	if (!info->res) {
 		dev_err(&dev->dev, "Could not reserve memory region\n");
 		err = -ENOMEM;
--- a/drivers/mtd/maps/ixp4xx.c
+++ b/drivers/mtd/maps/ixp4xx.c
@@ -218,7 +218,7 @@ static int ixp4xx_flash_probe(struct pla
 	 * handle that.
 	 */
 	info->map.bankwidth = 2;
-	info->map.name = dev->dev.bus_id;
+	info->map.name = dev_name(&dev->dev);
 	info->map.read = ixp4xx_read16,
 	info->map.write = ixp4xx_probe_write16,
 	info->map.copy_from = ixp4xx_copy_from,
--- a/drivers/mtd/maps/omap_nor.c
+++ b/drivers/mtd/maps/omap_nor.c
@@ -101,7 +101,7 @@ static int __init omapflash_probe(struct
 		err = -ENOMEM;
 		goto out_release_mem_region;
 	}
-	info->map.name		= pdev->dev.bus_id;
+	info->map.name		= dev_name(&pdev->dev);
 	info->map.phys		= res->start;
 	info->map.size		= size;
 	info->map.bankwidth	= pdata->width;
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -116,14 +116,14 @@ static int physmap_flash_probe(struct pl
 
 		info->res = request_mem_region(dev->resource[i].start,
 					       dev->resource[i].end - dev->resource[i].start + 1,
-					       dev->dev.bus_id);
+					       dev_name(&dev->dev));
 		if (info->res == NULL) {
 			dev_err(&dev->dev, "Could not reserve memory region\n");
 			err = -ENOMEM;
 			goto err_out;
 		}
 
-		info->map[i].name = dev->dev.bus_id;
+		info->map[i].name = dev_name(&dev->dev);
 		info->map[i].phys = dev->resource[i].start;
 		info->map[i].size = dev->resource[i].end - dev->resource[i].start + 1;
 		info->map[i].bankwidth = physmap_data->width;
@@ -158,7 +158,7 @@ static int physmap_flash_probe(struct pl
 		 * We detected multiple devices. Concatenate them together.
 		 */
 #ifdef CONFIG_MTD_CONCAT
-		info->cmtd = mtd_concat_create(info->mtd, devices_found, dev->dev.bus_id);
+		info->cmtd = mtd_concat_create(info->mtd, devices_found, dev_name(&dev->dev));
 		if (info->cmtd == NULL)
 			err = -ENXIO;
 #else
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -183,7 +183,7 @@ static int __devinit of_flash_probe(stru
 
 	err = -EBUSY;
 	info->res = request_mem_region(res.start, res.end - res.start + 1,
-				       dev->dev.bus_id);
+				       dev_name(&dev->dev));
 	if (!info->res)
 		goto err_out;
 
@@ -194,7 +194,7 @@ static int __devinit of_flash_probe(stru
 		goto err_out;
 	}
 
-	info->map.name = dev->dev.bus_id;
+	info->map.name = dev_name(&dev->dev);
 	info->map.phys = res.start;
 	info->map.size = res.end - res.start + 1;
 	info->map.bankwidth = *width;
--- a/drivers/mtd/mtdconcat.c
+++ b/drivers/mtd/mtdconcat.c
@@ -691,7 +691,7 @@ static int concat_block_markbad(struct m
  */
 struct mtd_info *mtd_concat_create(struct mtd_info *subdev[],	/* subdevices to concatenate */
 				   int num_devs,	/* number of subdevices      */
-				   char *name)
+				   const char *name)
 {				/* name for the new device   */
 	int i;
 	size_t size;
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -220,7 +220,7 @@ static int __devinit fun_probe(struct of
 
 	fun->rnb_gpio = of_get_gpio(ofdev->node, 0);
 	if (fun->rnb_gpio >= 0) {
-		ret = gpio_request(fun->rnb_gpio, ofdev->dev.bus_id);
+		ret = gpio_request(fun->rnb_gpio, dev_name(&ofdev->dev));
 		if (ret) {
 			dev_err(&ofdev->dev, "can't request RNB gpio\n");
 			goto err2;
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -54,7 +54,7 @@ static int __init plat_nand_probe(struct
 	data->chip.priv = &data;
 	data->mtd.priv = &data->chip;
 	data->mtd.owner = THIS_MODULE;
-	data->mtd.name = pdev->dev.bus_id;
+	data->mtd.name = dev_name(&pdev->dev);
 
 	data->chip.IO_ADDR_R = data->io_base;
 	data->chip.IO_ADDR_W = data->io_base;
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -433,7 +433,7 @@ static int tmio_probe(struct platform_de
 	nand_chip->chip_delay = 15;
 
 	retval = request_irq(irq, &tmio_irq,
-				IRQF_DISABLED, dev->dev.bus_id, tmio);
+				IRQF_DISABLED, dev_name(&dev->dev), tmio);
 	if (retval) {
 		dev_err(&dev->dev, "request_irq error %d\n", retval);
 		goto err_irq;
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -63,7 +63,7 @@ static int __devinit generic_onenand_pro
 	info->onenand.mmcontrol = pdata->mmcontrol;
 	info->onenand.irq = platform_get_irq(pdev, 0);
 
-	info->mtd.name = pdev->dev.bus_id;
+	info->mtd.name = dev_name(&pdev->dev);
 	info->mtd.priv = &info->onenand;
 	info->mtd.owner = THIS_MODULE;
 
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -670,7 +670,7 @@ static int __devinit omap2_onenand_probe
 		 c->onenand.base);
 
 	c->pdev = pdev;
-	c->mtd.name = pdev->dev.bus_id;
+	c->mtd.name = dev_name(&pdev->dev);
 	c->mtd.priv = &c->onenand;
 	c->mtd.owner = THIS_MODULE;
 
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -280,7 +280,7 @@ static int ubi_sysfs_init(struct ubi_dev
 	ubi->dev.release = dev_release;
 	ubi->dev.devt = ubi->cdev.dev;
 	ubi->dev.class = ubi_class;
-	sprintf(&ubi->dev.bus_id[0], UBI_NAME_STR"%d", ubi->ubi_num);
+	dev_set_name(&ubi->dev, UBI_NAME_STR"%d", ubi->ubi_num);
 	err = device_register(&ubi->dev);
 	if (err)
 		return err;
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -329,7 +329,7 @@ int ubi_create_volume(struct ubi_device
 	vol->dev.devt = dev;
 	vol->dev.class = ubi_class;
 
-	sprintf(&vol->dev.bus_id[0], "%s_%d", ubi->ubi_name, vol->vol_id);
+	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
 	err = device_register(&vol->dev);
 	if (err) {
 		ubi_err("cannot register device");
@@ -678,7 +678,7 @@ int ubi_add_volume(struct ubi_device *ub
 	vol->dev.parent = &ubi->dev;
 	vol->dev.devt = dev;
 	vol->dev.class = ubi_class;
-	sprintf(&vol->dev.bus_id[0], "%s_%d", ubi->ubi_name, vol->vol_id);
+	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
 	err = device_register(&vol->dev);
 	if (err)
 		goto out_gluebi;
--- a/include/linux/mtd/concat.h
+++ b/include/linux/mtd/concat.h
@@ -13,7 +13,7 @@
 struct mtd_info *mtd_concat_create(
     struct mtd_info *subdev[],  /* subdevices to concatenate */
     int num_devs,               /* number of subdevices      */
-    char *name);                /* name for the new device   */
+    const char *name);          /* name for the new device   */
 
 void mtd_concat_destroy(struct mtd_info *mtd);
 

