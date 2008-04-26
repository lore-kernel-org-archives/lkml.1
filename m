Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbYDZUi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbYDZUi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 16:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762401AbYDZUid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 16:38:33 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38170 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761229AbYDZUic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 16:38:32 -0400
Date: Sat, 26 Apr 2008 22:38:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: Re: [PATCH1/7] i2c: Add support for device alias names
Message-ID: <20080426223815.16e38a85@hyperion.delvare>
In-Reply-To: <47FF70A7.5070002@scram.de>
References: <47FF70A7.5070002@scram.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jochen,

On Fri, 11 Apr 2008 16:07:35 +0200, Jochen Friedrich wrote:
> Based on earlier work by Jon Smirl and Jean Delvare.
> 
> This patch allows new-style i2c chip drivers to have alias names using
> the official kernel aliasing system and MODULE_DEVICE_TABLE(). At this
> point, the old i2c driver binding scheme (driver_name/type) is still
> supported.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Jon Smirl <jonsmirl@gmail.com>
> ---
>  drivers/hwmon/f75375s.c                    |   21 ++++++++----
>  drivers/i2c/chips/ds1682.c                 |    3 +-
>  drivers/i2c/chips/menelaus.c               |    3 +-
>  drivers/i2c/chips/tps65010.c               |    3 +-
>  drivers/i2c/chips/tsl2550.c                |    3 +-
>  drivers/i2c/i2c-core.c                     |   51 +++++++++++++++++++++++-----
>  drivers/media/video/cs5345.c               |    3 +-
>  drivers/media/video/cs53l32a.c             |    3 +-
>  drivers/media/video/cx25840/cx25840-core.c |    3 +-
>  drivers/media/video/ivtv/ivtv-i2c.c        |    2 +-
>  drivers/media/video/m52790.c               |    3 +-
>  drivers/media/video/msp3400-driver.c       |    3 +-
>  drivers/media/video/saa7115.c              |    3 +-
>  drivers/media/video/saa7127.c              |    3 +-
>  drivers/media/video/tlv320aic23b.c         |    3 +-
>  drivers/media/video/tuner-core.c           |    3 +-
>  drivers/media/video/tvaudio.c              |    3 +-
>  drivers/media/video/upd64031a.c            |    3 +-
>  drivers/media/video/upd64083.c             |    3 +-
>  drivers/media/video/v4l2-common.c          |    5 ++-
>  drivers/media/video/vp27smpx.c             |    3 +-
>  drivers/media/video/wm8739.c               |    3 +-
>  drivers/media/video/wm8775.c               |    3 +-
>  drivers/rtc/rtc-ds1307.c                   |    3 +-
>  drivers/rtc/rtc-ds1374.c                   |    3 +-
>  drivers/rtc/rtc-m41t80.c                   |    3 +-
>  drivers/rtc/rtc-rs5c372.c                  |    3 +-
>  include/linux/i2c.h                        |    5 +--
>  include/linux/mod_devicetable.h            |   13 +++++++
>  include/media/v4l2-common.h                |    4 ++-
>  include/media/v4l2-i2c-drv-legacy.h        |    2 +-
>  include/media/v4l2-i2c-drv.h               |    2 +-
>  scripts/mod/file2alias.c                   |   13 +++++++
>  33 files changed, 139 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
> index 1464338..3ec9123 100644
> --- a/drivers/hwmon/f75375s.c
> +++ b/drivers/hwmon/f75375s.c
> @@ -117,7 +117,8 @@ struct f75375_data {
>  static int f75375_attach_adapter(struct i2c_adapter *adapter);
>  static int f75375_detect(struct i2c_adapter *adapter, int address, int kind);
>  static int f75375_detach_client(struct i2c_client *client);
> -static int f75375_probe(struct i2c_client *client);
> +static int f75375_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id);
>  static int f75375_remove(struct i2c_client *client);
>  
>  static struct i2c_driver f75375_legacy_driver = {
> @@ -628,7 +629,8 @@ static void f75375_init(struct i2c_client *client, struct f75375_data *data,
>  
>  }
>  
> -static int f75375_probe(struct i2c_client *client)
> +static int f75375_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
>  {
>  	struct f75375_data *data = i2c_get_clientdata(client);
>  	struct f75375s_platform_data *f75375s_pdata = client->dev.platform_data;
> @@ -637,7 +639,8 @@ static int f75375_probe(struct i2c_client *client)
>  	if (!i2c_check_functionality(client->adapter,
>  				I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -EIO;
> -	if (!(data = kzalloc(sizeof(struct f75375_data), GFP_KERNEL)))
> +	data = kzalloc(sizeof(struct f75375_data), GFP_KERNEL);
> +	if (!data)
>  		return -ENOMEM;
>  
>  	i2c_set_clientdata(client, data);
> @@ -653,7 +656,8 @@ static int f75375_probe(struct i2c_client *client)
>  		return -ENODEV;
>  	}
>  
> -	if ((err = sysfs_create_group(&client->dev.kobj, &f75375_group)))
> +	err = sysfs_create_group(&client->dev.kobj, &f75375_group);
> +	if (err)
>  		goto exit_free;
>  
>  	if (data->kind == f75375) {
> @@ -713,7 +717,8 @@ static int f75375_detect(struct i2c_adapter *adapter, int address, int kind)
>  	int err = 0;
>  	const char *name = "";
>  
> -	if (!(client = kzalloc(sizeof(*client), GFP_KERNEL))) {
> +	client = kzalloc(sizeof(*client), GFP_KERNEL);
> +	if (!client) {
>  		err = -ENOMEM;
>  		goto exit;
>  	}
> @@ -745,10 +750,12 @@ static int f75375_detect(struct i2c_adapter *adapter, int address, int kind)
>  	dev_info(&adapter->dev, "found %s version: %02X\n", name, version);
>  	strlcpy(client->name, name, I2C_NAME_SIZE);
>  
> -	if ((err = i2c_attach_client(client)))
> +	err = i2c_attach_client(client);
> +	if (err)
>  		goto exit_free;
>  
> -	if ((err = f75375_probe(client)) < 0)
> +	err = f75375_probe(client, NULL);
> +	if (err < 0)
>  		goto exit_detach;
>  
>  	return 0;

These coding style cleanups don't belong to this patch (if they belong
anywhere - I don't much see the point)

> (...)
> diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
> index fa5ab1e..37b0fd6 100644
> --- a/drivers/media/video/ivtv/ivtv-i2c.c
> +++ b/drivers/media/video/ivtv/ivtv-i2c.c
> @@ -167,7 +167,7 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
>  		return -1;
>  	id = hw_driverids[idx];
>  	memset(&info, 0, sizeof(info));
> -	strcpy(info.driver_name, hw_drivernames[idx]);
> +	strcpy(info.type, hw_drivernames[idx]);
>  	info.addr = hw_addrs[idx];
>  	for (i = 0; itv->i2c_clients[i] && i < I2C_CLIENTS_MAX; i++) {}
>  

This change should not be included in this patch. At this point, the old
binding model is still available, and I believe that the change above
will break ivtv, because all the device drivers it needs are still
using the old binding model (they don't define i2c device IDs yet.)

For the rest, there are a number of drivers which are missing:

drivers/gpio/pca953x.c
drivers/gpio/pcf857x.c
drivers/media/video/mt9m001.c
drivers/media/video/mt9v022.c
drivers/media/video/saa717x.c
drivers/media/video/tcm825x.c
drivers/rtc/rtc-s35390a.c

Either you missed them, or they were added after you updated the patch.
Either way, they need to be added. I hope I didn't miss any, it's hard
to make sure as some of them won't build on my development system
(x86-64).

Oh, and Documentation/i2c/writing-clients needs to be updated, too.

I'll add the missing chunks tomorrow, then I'll post an updated patch,
after I'm done with checking the 2nd patch of the set. I might leave
ivtv alone for the time being, as it's a complex one and I don't want
to break it for rc1.

-- 
Jean Delvare
