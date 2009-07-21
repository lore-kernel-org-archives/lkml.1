Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZGUGPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZGUGPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZGUGPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:15:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbZGUGPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:15:32 -0400
Date: Mon, 20 Jul 2009 23:14:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add low_power support for adm1021 driver.
Message-Id: <20090720231407.676717e4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0907061725170.11795@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0907061725170.11795@venus.araneidae.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 17:26:32 +0100 (BST) Michael Abbott <michael@araneidae.co.uk> wrote:

> Resending this patch previously sent some months again.
> 
> Occasionally it is helpful to be able to turn a temperature sensor off
> (for example if it's making unwanted electrical noise).  This patch
> adds a sysfs node to put any adm1021 compatible device into low power mode.
> 
> Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> ---
>  drivers/hwmon/adm1021.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
> index de84398..39434e1 100644
> --- a/drivers/hwmon/adm1021.c
> +++ b/drivers/hwmon/adm1021.c
> @@ -83,6 +83,7 @@ struct adm1021_data {
>  
>  	struct mutex update_lock;
>  	char valid;		/* !=0 if following fields are valid */
> +	char low_power;		/* !=0 if device in low power mode */
>  	unsigned long last_updated;	/* In jiffies */
>  
>  	int temp_max[2];		/* Register values */
> @@ -213,6 +214,35 @@ static ssize_t set_temp_min(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t show_low_power(
> +	struct device *dev, struct device_attribute *devattr, char *buf)

This is atypical layout.  Please use something like

static ssize_t show_low_power(struct device *dev,
				struct device_attribute *devattr, char *buf)

as is used in the rest of this driver, and much kernel code.

> +{
> +	struct adm1021_data *data = adm1021_update_device(dev);
> +	return sprintf(buf, "%d\n", data->low_power);
> +}
> +
> +static ssize_t set_low_power(
> +	struct device *dev, struct device_attribute *devattr,
> +	const char *buf, size_t count)

ditto

> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct adm1021_data *data = i2c_get_clientdata(client);
> +	int low_power = simple_strtol(buf, NULL, 10) != 0;
> +	mutex_lock(&data->update_lock);

And a blank line between end-of-locals and start-of-code.

Please use scripts/checkpatch.pl.  It would have informed you that
strict_strtoul() is preferred here.  Otherwise we will treat userspace
input of the form "0blob" and a valid decimal number, which it isn't.


> +	if (low_power != data->low_power) {
> +		int config = i2c_smbus_read_byte_data(
> +			client, ADM1021_REG_CONFIG_R);
> +		data->low_power = low_power;
> +		i2c_smbus_write_byte_data(client, ADM1021_REG_CONFIG_W,
> +			(config & 0xBF) | (low_power << 6));
> +	}
> +	mutex_unlock(&data->update_lock);
> +
> +	return count;
> +}
> +
> +
>  static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);
>  static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
>  			  set_temp_max, 0);
> @@ -230,6 +260,8 @@ static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_alarm, NULL, 3);
>  static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
>  
>  static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
> +static DEVICE_ATTR(
> +	low_power, S_IWUSR | S_IRUGO, show_low_power, set_low_power);

Again, please use standard layout.

>  static struct attribute *adm1021_attributes[] = {
>  	&sensor_dev_attr_temp1_max.dev_attr.attr,
> @@ -244,6 +276,7 @@ static struct attribute *adm1021_attributes[] = {
>  	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
>  	&sensor_dev_attr_temp2_fault.dev_attr.attr,
>  	&dev_attr_alarms.attr,
> +	&dev_attr_low_power.attr,
>  	NULL
>  };

I'll merge this patch as-is anyway so it doesn't get forgotten about.  I'll
mark it as needing-an-update.

Thanks.
