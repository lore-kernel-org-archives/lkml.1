Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZG2Vqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZG2Vqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZG2Vqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:46:38 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:35176 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754138AbZG2Vqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:46:37 -0400
Date: Wed, 29 Jul 2009 22:44:46 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/7] spi: Add support for device table matching
Message-ID: <20090729214446.GB1728@fluff.org.uk>
References: <20090729170345.GA26787@oksana.dev.rtsoft.ru> <20090729170457.GA4803@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729170457.GA4803@oksana.dev.rtsoft.ru>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 09:04:57PM +0400, Anton Vorontsov wrote:
> With this patch spi drivers can use standard spi_driver.id_table and
> MODULE_DEVICE_TABLE() mechanisms to bind against the devices. Just
> like we do with I2C drivers.
> 
> This is useful when a single driver supports several variants of
> devices but it is not possible to detect them in run-time (like
> non-JEDEC chips probing in drivers/mtd/devices/m25p80.c), and
> when platform_data usage is overkill.
> 
> This patch also makes life a lot easier on OpenFirmware platforms,
> since with OF we extensively use proper device IDs in modaliases.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/spi/spi.c               |   26 +++++++++++++++++++++++++-
>  include/linux/mod_devicetable.h |   13 +++++++++++++
>  include/linux/spi/spi.h         |   10 ++++++++--
>  scripts/mod/file2alias.c        |   13 +++++++++++++
>  4 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 70845cc..1431bf2 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -59,9 +59,24 @@ static struct device_attribute spi_dev_attrs[] = {
>   * and the sysfs version makes coldplug work too.
>   */
>  
> +static const struct spi_device_id *spi_match_id(const struct spi_device_id *id,
> +						const struct spi_device *sdev)
> +{
> +	while (id->name[0]) {
> +		if (!strcmp(sdev->modalias, id->name))
> +			return id;
> +		id++;
> +	}
> +	return NULL;
> +}
> +
>  static int spi_match_device(struct device *dev, struct device_driver *drv)
>  {
>  	const struct spi_device	*spi = to_spi_device(dev);
> +	const struct spi_driver	*sdrv = to_spi_driver(drv);
> +
> +	if (sdrv->id_table)
> +		return !!spi_match_id(sdrv->id_table, spi);
>  
>  	return strcmp(spi->modalias, drv->name) == 0;
>  }
> @@ -121,6 +136,13 @@ struct bus_type spi_bus_type = {
>  };
>  EXPORT_SYMBOL_GPL(spi_bus_type);
>  
> +static int spi_drv_probe_id(struct device *dev)
> +{
> +	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
> +	struct spi_device		*sdev = to_spi_device(dev);
> +
> +	return sdrv->probe_id(sdev, spi_match_id(sdrv->id_table, sdev));
> +}
>  
>  static int spi_drv_probe(struct device *dev)
>  {
> @@ -151,7 +173,9 @@ static void spi_drv_shutdown(struct device *dev)
>  int spi_register_driver(struct spi_driver *sdrv)
>  {
>  	sdrv->driver.bus = &spi_bus_type;
> -	if (sdrv->probe)
> +	if (sdrv->probe_id)
> +		sdrv->driver.probe = spi_drv_probe_id;
> +	else if (sdrv->probe)
>  		sdrv->driver.probe = spi_drv_probe;
>  	if (sdrv->remove)
>  		sdrv->driver.remove = spi_drv_remove;
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 1bf5900..9660dca 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -399,6 +399,19 @@ struct i2c_device_id {
>  			__attribute__((aligned(sizeof(kernel_ulong_t))));
>  };
>  
> +/* spi */
> +
> +#define SPI_NAME_SIZE	20
> +
> +struct spi_device_id {
> +	char name[SPI_NAME_SIZE];
> +#ifdef __KERNEL__
> +	void *data;
> +#else
> +	kernel_ulong_t data;
> +#endif
> +};
> +
>  /* dmi */
>  enum dmi_field {
>  	DMI_NONE,
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index c47c4b4..c8d92a1 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -20,6 +20,7 @@
>  #define __LINUX_SPI_H
>  
>  #include <linux/device.h>
> +#include <linux/mod_devicetable.h>
>  
>  /*
>   * INTERFACES between SPI master-side drivers and SPI infrastructure.
> @@ -86,7 +87,7 @@ struct spi_device {
>  	int			irq;
>  	void			*controller_state;
>  	void			*controller_data;
> -	char			modalias[32];
> +	char			modalias[SPI_NAME_SIZE];
>  
>  	/*
>  	 * likely need more hooks for more protocol options affecting how
> @@ -145,6 +146,8 @@ struct spi_message;
>  
>  /**
>   * struct spi_driver - Host side "protocol" driver
> + * @id_table: List of SPI devices supported by this driver
> + * @probe_id: Binds this driver to the spi device via id_table matching.
>   * @probe: Binds this driver to the spi device.  Drivers can verify
>   *	that the device is actually present, and may need to configure
>   *	characteristics (such as bits_per_word) which weren't needed for
> @@ -170,6 +173,9 @@ struct spi_message;
>   * MMC, RTC, filesystem character device nodes, and hardware monitoring.
>   */
>  struct spi_driver {
> +	const struct spi_device_id *id_table;
> +	int			(*probe_id)(struct spi_device *spi,
> +					    const struct spi_device_id *id);

how about leaving it at just probe and have either a call or a field
in the device that you can look at to see if this was a new style of
call?

>  	int			(*probe)(struct spi_device *spi);
>  	int			(*remove)(struct spi_device *spi);
>  	void			(*shutdown)(struct spi_device *spi);
> @@ -732,7 +738,7 @@ struct spi_board_info {
>  	 * controller_data goes to spi_device.controller_data,
>  	 * irq is copied too
>  	 */
> -	char		modalias[32];
> +	char		modalias[SPI_NAME_SIZE];
>  	const void	*platform_data;
>  	void		*controller_data;
>  	int		irq;
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 40e0045..9d446e3 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -657,6 +657,15 @@ static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
>  	return 1;
>  }
>  
> +/* Looks like: S */
> +static int do_spi_entry(const char *filename, struct spi_device_id *id,
> +			char *alias)
> +{
> +	sprintf(alias, "%s", id->name);
> +
> +	return 1;
> +}
> +
>  static const struct dmifield {
>  	const char *prefix;
>  	int field;
> @@ -853,6 +862,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
>  		do_table(symval, sym->st_size,
>  			 sizeof(struct i2c_device_id), "i2c",
>  			 do_i2c_entry, mod);
> +	else if (sym_is(symname, "__mod_spi_device_table"))
> +		do_table(symval, sym->st_size,
> +			 sizeof(struct spi_device_id), "spi",
> +			 do_spi_entry, mod);
>  	else if (sym_is(symname, "__mod_dmi_device_table"))
>  		do_table(symval, sym->st_size,
>  			 sizeof(struct dmi_system_id), "dmi",
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
