Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbYAKTU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbYAKTU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbYAKTUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:20:19 -0500
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:1273 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757441AbYAKTUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:20:18 -0500
Date: Fri, 11 Jan 2008 20:20:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH 1/5] Implement module aliasing for i2c to
 translate  from device tree names
Message-ID: <20080111202015.65c3c160@hyperion.delvare>
In-Reply-To: <20071220044138.20091.31417.stgit@terra.home>
References: <20071220044136.20091.70984.stgit@terra.home>
 <20071220044138.20091.31417.stgit@terra.home>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Wed, 19 Dec 2007 23:41:38 -0500, Jon Smirl wrote:
> This patch allows new style i2c chip drivers to have alias names using
> the official kernel aliasing system and MODULE_DEVICE_TABLE(). I've
> tested it on PowerPC and x86. This change is required for PowerPC
> device tree support.

Your patch adds compilation warnings on several i2c drivers:

drivers/hwmon/f75375s.c:135: warning: initialization from incompatible pointer type
drivers/i2c/chips/ds1682.c:241: warning: initialization from incompatible pointer type
drivers/i2c/chips/tps65010.c:590: warning: initialization from incompatible pointer type
drivers/i2c/chips/tsl2550.c:461: warning: initialization from incompatible pointer type
drivers/rtc/rtc-ds1307.c:538: warning: initialization from incompatible pointer type
drivers/rtc/rtc-ds1374.c:430: warning: initialization from incompatible pointer type
drivers/rtc/rtc-m41t80.c:897: warning: initialization from incompatible pointer type
drivers/rtc/rtc-rs5c372.c:652: warning: initialization from incompatible pointer type

And there may be more drivers affected that just happen to not build on
x86_64 so I did not spot them. Please check this and fix them all.

I see that 4 of these warnings are fixed in the next patch of this
series, but that's not sufficient: each patch must be correct by
itself, so that bisections can be performed safely.

> 
> Signed-off-by: Jon Smirl <jonsmirl@gmail.com>
> ---
> 
>  drivers/i2c/i2c-core.c          |   32 ++++++++++++++++++++++++++------
>  include/linux/i2c.h             |    9 ++++-----
>  include/linux/mod_devicetable.h |   20 ++++++++++++++++++++
>  scripts/mod/file2alias.c        |   19 +++++++++++++++++++
>  4 files changed, 69 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index b5e13e4..fce06fd 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -47,10 +47,25 @@ static DEFINE_IDR(i2c_adapter_idr);
>  
>  /* ------------------------------------------------------------------------- */
>  
> -static int i2c_device_match(struct device *dev, struct device_driver *drv)
> +static const struct i2c_device_id *i2c_device_match(const struct i2c_device_id *id, struct i2c_client *client)

Line too long, please fold.

Following the pci and usb examples, this function would be named
i2c_match_id.

> +{
> +	/* only powerpc drivers implement the id_table,
> +	 * it is empty on other platforms */
> +	if (id) {
> +		while (id->name[0]) {
> +			if (strcmp(client->driver_name, id->name) == 0)

This doesn't look right to me. You should be comparing client->name,
not client->driver_name, with id->name. Where id_table is implemented,
client->driver_name might not even be set. I see that the next patch in
the series makes use of client->driver_name as well, so your code
"works"... but this ain't correct still.

> +				return id;
> +			id++;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static int i2c_bus_match(struct device *dev, struct device_driver *drv)

And this function would be named i2c_device_match (i.e. don't change
the name.)

>  {
>  	struct i2c_client	*client = to_i2c_client(dev);
>  	struct i2c_driver	*driver = to_i2c_driver(drv);
> +	const struct i2c_device_id *found_id;
>  
>  	/* make legacy i2c drivers bypass driver model probing entirely;
>  	 * such drivers scan each i2c adapter/bus themselves.
> @@ -58,9 +73,11 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
>  	if (!is_newstyle_driver(driver))
>  		return 0;
>  
> -	/* new style drivers use the same kind of driver matching policy
> -	 * as platform devices or SPI:  compare device and driver IDs.
> -	 */

This comment still applies to the last part of the function.

> +	/* match on an id table if there is one */
> +	found_id = i2c_device_match(driver->id_table, client);
> +	if (found_id)
> +		return 1;

If the driver has an id_table but the device doesn't match any entry,
you fallback to the string comparison below. Is this really what you
want? Why not return 0 right away instead? Again, client->driver_name
might not even be set.

> +
>  	return strcmp(client->driver_name, drv->name) == 0;
>  }
>  
> @@ -89,12 +106,15 @@ static int i2c_device_probe(struct device *dev)
>  {
>  	struct i2c_client	*client = to_i2c_client(dev);
>  	struct i2c_driver	*driver = to_i2c_driver(dev->driver);
> +	const struct i2c_device_id *id;
>  
>  	if (!driver->probe)
>  		return -ENODEV;
>  	client->driver = driver;
>  	dev_dbg(dev, "probe\n");
> -	return driver->probe(client);
> +
> +	id = i2c_device_match(driver->id_table, client);
> +	return driver->probe(client, id);
>  }
>  
>  static int i2c_device_remove(struct device *dev)
> @@ -189,7 +209,7 @@ static struct device_attribute i2c_dev_attrs[] = {
>  static struct bus_type i2c_bus_type = {
>  	.name		= "i2c",
>  	.dev_attrs	= i2c_dev_attrs,
> -	.match		= i2c_device_match,
> +	.match		= i2c_bus_match,
>  	.uevent		= i2c_device_uevent,
>  	.probe		= i2c_device_probe,
>  	.remove		= i2c_device_remove,
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index a100c9f..49fc682 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -126,7 +126,7 @@ struct i2c_driver {
>  	 * With the driver model, device enumeration is NEVER done by drivers;
>  	 * it's done by infrastructure.  (NEW STYLE DRIVERS ONLY)
>  	 */
> -	int (*probe)(struct i2c_client *);
> +	int (*probe)(struct i2c_client *, const struct i2c_device_id *id);
>  	int (*remove)(struct i2c_client *);
>  
>  	/* driver model interfaces that don't relate to enumeration  */
> @@ -141,11 +141,10 @@ struct i2c_driver {
>  
>  	struct device_driver driver;
>  	struct list_head list;
> +	struct i2c_device_id *id_table;
>  };
>  #define to_i2c_driver(d) container_of(d, struct i2c_driver, driver)
>  
> -#define I2C_NAME_SIZE	20
> -
>  /**
>   * struct i2c_client - represent an I2C slave device
>   * @flags: I2C_CLIENT_TEN indicates the device uses a ten bit chip address;
> @@ -179,7 +178,7 @@ struct i2c_client {
>  					/* to the client		*/
>  	struct device dev;		/* the device structure		*/
>  	int irq;			/* irq issued by device (or -1) */
> -	char driver_name[KOBJ_NAME_LEN];
> +	char driver_name[I2C_NAME_SIZE];

Rationale please? I can't see why this change would be needed.

>  	struct list_head list;
>  	struct completion released;
>  };
> @@ -223,7 +222,7 @@ static inline void i2c_set_clientdata (struct i2c_client *dev, void *data)
>   * with the adapter already known.
>   */
>  struct i2c_board_info {
> -	char		driver_name[KOBJ_NAME_LEN];
> +	char		driver_name[I2C_NAME_SIZE];

Ditto.

>  	char		type[I2C_NAME_SIZE];
>  	unsigned short	flags;
>  	unsigned short	addr;
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index e9fddb4..d66038a 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -367,4 +367,24 @@ struct virtio_device_id {
>  };
>  #define VIRTIO_DEV_ANY_ID	0xffffffff
>  
> +/* i2c */
> +
> +/* These defines are used to separate PowerPC open firmware
> + * drivers into their own namespace */
> +#define I2C_NAME_SIZE	(16*3)

Rationale for this value? 48 bytes seems quite large, the longest
string you handle in the next patch is only 15-bytes long. 32 would
seem to be a more reasonable compromise (but see also my other reply to
this thread for why you probably shouldn't change I2C_NAME_SIZE at all.)

> +#define I2C_MODULE_PREFIX "i2c:N"

This "N" shouldn't be part of the prefix... if it should be there at
all. It makes the aliases harder to read and I don't see what it is
good for.

> +#ifdef CONFIG_OF
> +#define OF_I2C_PREFIX "OF,"
> +#define I2C_OF_MODULE_PREFIX I2C_MODULE_PREFIX OF_I2C_PREFIX

This one isn't used anywhere?

> +#define OF_I2C_ID(s,d) {OF_I2C_PREFIX s, (d) },

Coding style: space afte opening curly brace.

> +#else
> +#define OF_I2C_ID(s,d)
> +#endif
> +
> +struct i2c_device_id {
> +	char name[I2C_NAME_SIZE];
> +	kernel_ulong_t driver_data;	/* Data private to the driver */
> +};
> +
> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index d802b5a..da43742 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -539,6 +539,21 @@ static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
>  	return 1;
>  }
>  
> +/* Looks like: i2c:Ns */
> +static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
> +			   char *alias)
> +{
> +    char *tmp;
> +    sprintf (alias, I2C_MODULE_PREFIX "%s", id->name);

Coding style: no space before opening parenthesis. Also please use tabs
for indentation.

> +
> +    /* Replace all whitespace with underscores */
> +    for (tmp = alias; tmp && *tmp; tmp++)
> +        if (isspace (*tmp))
> +            *tmp = '_';

Is this needed? Are there really OF (or other) device names that contain
whitespaces? None of the examples in this patch series do, and I can't
think of any.

> +
> +    return 1;
> +}
> +
>  /* Ignore any prefix, eg. v850 prepends _ */
>  static inline int sym_is(const char *symbol, const char *name)
>  {
> @@ -669,6 +684,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
>  		do_table(symval, sym->st_size,
>  			 sizeof(struct virtio_device_id), "virtio",
>  			 do_virtio_entry, mod);
> +	else if (sym_is(symname, "__mod_i2c_device_table"))
> +		do_table(symval, sym->st_size,
> +			 sizeof(struct i2c_device_id), "i2c",
> +			 do_i2c_entry, mod);
>  	free(zeros);
>  }

-- 
Jean Delvare
