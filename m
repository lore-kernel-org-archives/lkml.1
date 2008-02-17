Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYBQUN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYBQUN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYBQUMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:12:50 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:22831 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625AbYBQUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:12:48 -0500
Date: Sun, 17 Feb 2008 15:02:50 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] adt7473: New driver for Analog Devices
	ADT7473 sensor chip
Message-ID: <20080217200250.GD2916@jupiter.solarsys.private>
References: <20071219034116.GM6870@tree.beaverton.ibm.com> <20071219154759.7be5025c@hyperion.delvare> <20071219231437.GR6870@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219231437.GR6870@tree.beaverton.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick:

Sorry this took forever for me to review.  Just a few little things...

* Darrick J. Wong <djwong@us.ibm.com> [2007-12-19 15:14:38 -0800]:
> This driver also had that funny alarm1/alarm2 thing; here's a revision
> of yesterday's patch with that straightened out.
> ---
> This driver reports voltage, temperature and fan sensor readings
> on an ADT7473 chip.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/Kconfig   |   10 
>  drivers/hwmon/Makefile  |    1 
>  drivers/hwmon/adt7473.c | 1161 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1172 insertions(+), 0 deletions(-)
> 

Documentation/hwmon/adt7473 would be nice.

> new file mode 100644
> index 0000000..5528d5c
> --- /dev/null
> +++ b/drivers/hwmon/adt7473.c
> @@ -0,0 +1,1161 @@

(snip)

> +/*
> + * On this chip, voltages are given as a count of steps between a minimum
> + * and maximum voltage, not a direct voltage.
> + */
> +static int volt_convert_table[][2] = {
> +	{2997, 3},
> +	{4395, 4},
> +};

That should be const.

(snip)

> +static ssize_t show_pwm_auto_temp(struct device *dev,
> +				  struct device_attribute *devattr,
> +				  char *buf)
> +{
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> +	struct adt7473_data *data = adt7473_update_device(dev);
> +	int bhvr = data->pwm_behavior[attr->index] >> ADT7473_PWM_BHVR_SHIFT;
> +
> +	switch (bhvr) {
> +	case 3:
> +	case 4:
> +	case 7:
> +		return sprintf(buf, "0\n");
> +	case 0:
> +	case 1:
> +	case 5:
> +	case 6:
> +		return sprintf(buf, "%d\n", bhvr + 1);
> +	case 2:
> +		return sprintf(buf, "4\n");
> +	}
> +	BUG();

Given ADT7473_PWM_BHVR_SHIFT is 5, this BUG() is obviously impossible.
But I guess it's not obvious to GCC.

(snip)

> +static int adt7473_attach_adapter(struct i2c_adapter *adapter)
> +{
> +	/*
> +	 * Some NVIDIA cards have an adt7473 attached to the on-board
> +	 * i2c controller, but the i2c adapter driver in the binary
> +	 * nvidia superblob driver sets class to 0.
> +	 */
> +	if (!(adapter->class & I2C_CLASS_HWMON) && adapter->class)
> +		return 0;

NACK on that comment and associated code:  Jean Delvare submitted a
patch to NVIDIA over two years ago to fix their bug.  Apparently some
distros even carry his patch.  So, I don't want to encourage such a
hack to persist.  Please just do the standard check here.

> +	return i2c_probe(adapter, &addr_data, adt7473_detect);
> +}

(snip)

Thanks & regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

