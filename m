Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbZGaAk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbZGaAk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZGaAk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:40:59 -0400
Received: from ru.mvista.com ([213.79.90.228]:33263 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750745AbZGaAk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:40:58 -0400
Date: Fri, 31 Jul 2009 04:40:58 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 1/6] spi: Add support for device table matching
Message-ID: <20090731004058.GA8371@oksana.dev.rtsoft.ru>
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch spi drivers can use standard spi_driver.id_table and
MODULE_DEVICE_TABLE() mechanisms to bind against the devices. Just
like we do with I2C drivers.

This is useful when a single driver supports several variants of
devices but it is not possible to detect them in run-time (like
non-JEDEC chips probing in drivers/mtd/devices/m25p80.c), and
when platform_data usage is overkill.

This patch also makes life a lot easier on OpenFirmware platforms,
since with OF we extensively use proper device IDs in modaliases.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/spi/spi.c               |   23 +++++++++++++++++++++++
 include/linux/mod_devicetable.h |   10 ++++++++++
 include/linux/spi/spi.h         |   10 ++++++++--
 scripts/mod/file2alias.c        |   13 +++++++++++++
 4 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 70845cc..8518a6e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -59,9 +59,32 @@ static struct device_attribute spi_dev_attrs[] = {
  * and the sysfs version makes coldplug work too.
  */
 
+static const struct spi_device_id *spi_match_id(const struct spi_device_id *id,
+						const struct spi_device *sdev)
+{
+	while (id->name[0]) {
+		if (!strcmp(sdev->modalias, id->name))
+			return id;
+		id++;
+	}
+	return NULL;
+}
+
+const struct spi_device_id *spi_get_device_id(const struct spi_device *sdev)
+{
+	const struct spi_driver *sdrv = to_spi_driver(sdev->dev.driver);
+
+	return spi_match_id(sdrv->id_table, sdev);
+}
+EXPORT_SYMBOL_GPL(spi_get_device_id);
+
 static int spi_match_device(struct device *dev, struct device_driver *drv)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
+	const struct spi_driver	*sdrv = to_spi_driver(drv);
+
+	if (sdrv->id_table)
+		return !!spi_match_id(sdrv->id_table, spi);
 
 	return strcmp(spi->modalias, drv->name) == 0;
 }
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 1bf5900..b34f1ef 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -399,6 +399,16 @@ struct i2c_device_id {
 			__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
+/* spi */
+
+#define SPI_NAME_SIZE	32
+
+struct spi_device_id {
+	char name[SPI_NAME_SIZE];
+	kernel_ulong_t driver_data	/* Data private to the driver */
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
+
 /* dmi */
 enum dmi_field {
 	DMI_NONE,
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index c47c4b4..2b444df 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -20,6 +20,7 @@
 #define __LINUX_SPI_H
 
 #include <linux/device.h>
+#include <linux/mod_devicetable.h>
 
 /*
  * INTERFACES between SPI master-side drivers and SPI infrastructure.
@@ -86,7 +87,7 @@ struct spi_device {
 	int			irq;
 	void			*controller_state;
 	void			*controller_data;
-	char			modalias[32];
+	char			modalias[SPI_NAME_SIZE];
 
 	/*
 	 * likely need more hooks for more protocol options affecting how
@@ -145,6 +146,7 @@ struct spi_message;
 
 /**
  * struct spi_driver - Host side "protocol" driver
+ * @id_table: List of SPI devices supported by this driver
  * @probe: Binds this driver to the spi device.  Drivers can verify
  *	that the device is actually present, and may need to configure
  *	characteristics (such as bits_per_word) which weren't needed for
@@ -170,6 +172,7 @@ struct spi_message;
  * MMC, RTC, filesystem character device nodes, and hardware monitoring.
  */
 struct spi_driver {
+	const struct spi_device_id *id_table;
 	int			(*probe)(struct spi_device *spi);
 	int			(*remove)(struct spi_device *spi);
 	void			(*shutdown)(struct spi_device *spi);
@@ -732,7 +735,7 @@ struct spi_board_info {
 	 * controller_data goes to spi_device.controller_data,
 	 * irq is copied too
 	 */
-	char		modalias[32];
+	char		modalias[SPI_NAME_SIZE];
 	const void	*platform_data;
 	void		*controller_data;
 	int		irq;
@@ -800,4 +803,7 @@ spi_unregister_device(struct spi_device *spi)
 		device_unregister(&spi->dev);
 }
 
+extern const struct spi_device_id *
+spi_get_device_id(const struct spi_device *sdev);
+
 #endif /* __LINUX_SPI_H */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 40e0045..9d446e3 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -657,6 +657,15 @@ static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
 	return 1;
 }
 
+/* Looks like: S */
+static int do_spi_entry(const char *filename, struct spi_device_id *id,
+			char *alias)
+{
+	sprintf(alias, "%s", id->name);
+
+	return 1;
+}
+
 static const struct dmifield {
 	const char *prefix;
 	int field;
@@ -853,6 +862,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct i2c_device_id), "i2c",
 			 do_i2c_entry, mod);
+	else if (sym_is(symname, "__mod_spi_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct spi_device_id), "spi",
+			 do_spi_entry, mod);
 	else if (sym_is(symname, "__mod_dmi_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct dmi_system_id), "dmi",
-- 
1.6.3.3

