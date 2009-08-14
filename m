Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZHNLMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZHNLMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZHNLMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:12:00 -0400
Received: from araneidae.co.uk ([62.3.233.233]:2931 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZHNLL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:11:59 -0400
X-Greylist: delayed 2631 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 07:11:58 EDT
Date: Fri, 14 Aug 2009 11:27:55 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
cc: lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add low_power support for adm1021 driver.
In-Reply-To: <20090720231407.676717e4.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0908141100310.785@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0907061725170.11795@venus.araneidae.co.uk>
 <20090720231407.676717e4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I've taken a while to respond.

On Mon, 20 Jul 2009, Andrew Morton wrote:
> On Mon, 6 Jul 2009 17:26:32 +0100 (BST) Michael Abbott <michael@araneidae.co.uk> wrote:
> > Resending this patch previously sent some months again.
> > 
> > Occasionally it is helpful to be able to turn a temperature sensor off
> > (for example if it's making unwanted electrical noise).  This patch
> > adds a sysfs node to put any adm1021 compatible device into low power mode.
> > 
> > Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> > ---
> >  drivers/hwmon/adm1021.c |   33 +++++++++++++++++++++++++++++++++
> >  1 files changed, 33 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
> > index de84398..39434e1 100644
> > --- a/drivers/hwmon/adm1021.c
> > +++ b/drivers/hwmon/adm1021.c
> > @@ -83,6 +83,7 @@ struct adm1021_data {
> >  
> >  	struct mutex update_lock;
> >  	char valid;		/* !=0 if following fields are valid */
> > +	char low_power;		/* !=0 if device in low power mode */
> >  	unsigned long last_updated;	/* In jiffies */
> >  
> >  	int temp_max[2];		/* Register values */
> > @@ -213,6 +214,35 @@ static ssize_t set_temp_min(struct device *dev,
> >  	return count;
> >  }
> >  
> > +static ssize_t show_low_power(
> > +	struct device *dev, struct device_attribute *devattr, char *buf)
> 
> This is atypical layout.  Please use something like
> 
> static ssize_t show_low_power(struct device *dev,
> 				struct device_attribute *devattr, char *buf)
> 
> as is used in the rest of this driver, and much kernel code.

Huh.  Ok; layout patch attached.

> > +{
> > +	struct adm1021_data *data = adm1021_update_device(dev);
> > +	return sprintf(buf, "%d\n", data->low_power);
> > +}
> > +
> > +static ssize_t set_low_power(
> > +	struct device *dev, struct device_attribute *devattr,
> > +	const char *buf, size_t count)
> 
> ditto
> 
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct adm1021_data *data = i2c_get_clientdata(client);
> > +	int low_power = simple_strtol(buf, NULL, 10) != 0;
> > +	mutex_lock(&data->update_lock);
> 
> And a blank line between end-of-locals and start-of-code.
> 
> Please use scripts/checkpatch.pl.  It would have informed you that
> strict_strtoul() is preferred here.  Otherwise we will treat userspace
> input of the form "0blob" and a valid decimal number, which it isn't.

There a handful of problems here:

1. Using strict_strtoul would be inconsistent with all the rest of the 
code in this file and, frankly, much of the code in the rest of this 
directory.

2. Using strict_strtoul noticably complicates the code (the error code 
has to be propogated back up to the caller) to no sigificant effect (we 
don't actually care if the user accidentially gives us 0blob, it's really 
not actually a problem to us or, particularly, to the user).  We certainly 
have to propagage the error up, as otherwise the user has no clue why 
things aren't working!

There is a case to be made for converting all the simple_strtol calls to 
strict_strtoul, in both this file and elsewhere; however, there is also a 
case against it: it doesn't actually matter, and the extra error cases add 
pointless complexity, and I don't feel qualified to engage with such an 
argument on this list.

3. I'm also reluctant to complicate what is a rather trivial patch with 
extra code paths which aren't exercised anywhere else in the file (this 
is really point 1 again) ... and with which I'm completely unfamiliar.


> > +	if (low_power != data->low_power) {
> > +		int config = i2c_smbus_read_byte_data(
> > +			client, ADM1021_REG_CONFIG_R);
> > +		data->low_power = low_power;
> > +		i2c_smbus_write_byte_data(client, ADM1021_REG_CONFIG_W,
> > +			(config & 0xBF) | (low_power << 6));
> > +	}
> > +	mutex_unlock(&data->update_lock);
> > +
> > +	return count;
> > +}
> > +
> > +
> >  static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);
> >  static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
> >  			  set_temp_max, 0);
> > @@ -230,6 +260,8 @@ static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_alarm, NULL, 3);
> >  static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
> >  
> >  static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
> > +static DEVICE_ATTR(
> > +	low_power, S_IWUSR | S_IRUGO, show_low_power, set_low_power);
> 
> Again, please use standard layout.
> 
> >  static struct attribute *adm1021_attributes[] = {
> >  	&sensor_dev_attr_temp1_max.dev_attr.attr,
> > @@ -244,6 +276,7 @@ static struct attribute *adm1021_attributes[] = {
> >  	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
> >  	&sensor_dev_attr_temp2_fault.dev_attr.attr,
> >  	&dev_attr_alarms.attr,
> > +	&dev_attr_low_power.attr,
> >  	NULL
> >  };
> 
> I'll merge this patch as-is anyway so it doesn't get forgotten about.  I'll
> mark it as needing-an-update.


commit 671d6c7013f00d3cbc1436e55f1a0ff805199e52
Author: Michael Abbott <michael.abbott@diamond.ac.uk>
Date:   Fri Aug 14 11:19:17 2009 +0100

    Layout patch to fix earlier adm1021.c patch
    
    Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>

diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 39434e1..afc5943 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -214,22 +214,22 @@ static ssize_t set_temp_min(struct device *dev,
 	return count;
 }
 
-static ssize_t show_low_power(
-	struct device *dev, struct device_attribute *devattr, char *buf)
+static ssize_t show_low_power(struct device *dev,
+			      struct device_attribute *devattr, char *buf)
 {
 	struct adm1021_data *data = adm1021_update_device(dev);
 	return sprintf(buf, "%d\n", data->low_power);
 }
 
-static ssize_t set_low_power(
-	struct device *dev, struct device_attribute *devattr,
-	const char *buf, size_t count)
+static ssize_t set_low_power(struct device *dev,
+			     struct device_attribute *devattr,
+			     const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1021_data *data = i2c_get_clientdata(client);
 	int low_power = simple_strtol(buf, NULL, 10) != 0;
-	mutex_lock(&data->update_lock);
 
+	mutex_lock(&data->update_lock);
 	if (low_power != data->low_power) {
 		int config = i2c_smbus_read_byte_data(
 			client, ADM1021_REG_CONFIG_R);
@@ -260,8 +260,7 @@ static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_alarm, NULL, 3);
 static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
 
 static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
-static DEVICE_ATTR(
-	low_power, S_IWUSR | S_IRUGO, show_low_power, set_low_power);
+static DEVICE_ATTR(low_power, S_IWUSR | S_IRUGO, show_low_power, set_low_power);
 
 static struct attribute *adm1021_attributes[] = {
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
