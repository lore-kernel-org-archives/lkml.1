Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZJLOTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZJLOTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbZJLOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:19:35 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:55901 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbZJLOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:19:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AD33ADB.4000500@cam.ac.uk>
Date: Mon, 12 Oct 2009 15:19:07 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
References: <4ACF4AC6.7070802@cam.ac.uk> <20091010185200.671846c5@hyperion.delvare>
In-Reply-To: <20091010185200.671846c5@hyperion.delvare>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those not following this driver, Jean does raise the issue
of device naming again and I think we really need to settle
this one before progressing with ALS in general.

> 
> "2.0"?
True, that would be consistent.
> 
>>  
>>  /*
>>   * Defines
>> @@ -44,8 +47,10 @@
>>   */
>>  
>>  struct tsl2550_data {
>> +	struct device *classdev;
>>  	struct i2c_client *client;
>>  	struct mutex update_lock;
>> +	unsigned int id;
>>  
>>  	unsigned int power_state : 1;
>>  	unsigned int operating_mode : 1;
>> @@ -60,9 +65,41 @@ static const u8 TSL2550_MODE_RANGE[2] = {
>>  };
>>  
>>  /*
>> + * IDR to assign each registered device a unique id
>> + */
>> +static DEFINE_IDR(tsl2550_idr);
>> +static DEFINE_SPINLOCK(tsl2550_idr_lock);
>> +#define TSL2550_DEV_MAX 9
> 
> Such an arbitrary limit is simply not acceptable.
Fair enough, but it is based on restricting the size
of the char array needed for the name when registering
with als.  Hence single digit decimal maximum.
Do you suggest leaving it unrestricted (which makes code
a little fiddly given variable size of max idr) or some other
limit?
 
>> +
>> +/*
>>   * Management functions
>>   */
>>  
>> +static int tsl2550_get_id(void)
>> +{
>> +	int ret, val;
>> +
>> +idr_again:
>> +	if (unlikely(idr_pre_get(&tsl2550_idr, GFP_KERNEL) == 0))
>> +		return -ENOMEM;
>> +	spin_lock(&tsl2550_idr_lock);
>> +	ret = idr_get_new(&tsl2550_idr, NULL, &val);
>> +	if (unlikely(ret == -EAGAIN))
>> +		goto idr_again;
>> +	else if (unlikely(ret))
>> +		return ret;
>> +	if (val > TSL2550_DEV_MAX)
>> +		return -ENOMEM;
>> +	return val;
>> +}
>> +
>> +static void tsl2550_free_id(int val)
>> +{
>> +	spin_lock(&tsl2550_idr_lock);
>> +	idr_remove(&tsl2550_idr, val);
>> +	spin_unlock(&tsl2550_idr_lock);
>> +}
> 
> Having to implement this in _every_ ALS driver sounds wrong and
> painful. If uniqueness of any kind must be provided, it should be
> handled by the ALS core and not by individual drivers, otherwise you
> can be certain that at least one driver will get it wrong someday.
I agree. The reason this originally occurred is that the acpi layer
apparently doesn't allow for simultaneous probing of multiple drivers
and hence can get away with a simple counter and no locking.
> 
> I'd imaging that als-class devices are simply named als%u. Just like
> hwmon devices are named hwmon%u, input devices are names input%u and
> event%u, etc. I don't know of any class pushing the naming down to its
> drivers, do you? The only example I can remember are i2c drivers back
> in year 1999, when they were part of lm-sensors.I have personally put
> an end to this years ago.
This debate started in the als thread. Personally I couldn't care less
either way but it does need to be put to bed before that subsystem merges.
To my mind either approach is trivially handled in a userspace library
so it doesn't matter.  I don't suppose you can remember what the original
reasons for squashing this naming approach were?
> 
>> +
>>  static int tsl2550_set_operating_mode(struct i2c_client *client, int mode)
>>  {
>>  	struct tsl2550_data *data = i2c_get_clientdata(client);
>> @@ -296,13 +333,13 @@ static ssize_t tsl2550_show_lux1_input(struct device *dev,
>>  	return ret;
>>  }
>>  
>> -static DEVICE_ATTR(lux1_input, S_IRUGO,
>> +static DEVICE_ATTR(illuminance, S_IRUGO,
>>  		   tsl2550_show_lux1_input, NULL);
> 
> Question: if I have a light sensing chip with two sensors, how are we
> going to handle it? Will we register 2 als class devices? The initial
> naming convention had the advantage that you could have more than one
> sensor per device, but I don't know if it is desirable in practice.
This only becomes and issue if we have two sensors measuring illuminance
(or approximation of it).  The only two sensor chips I know of have one
broadband and one in the infrared tsl2561 and I think the isl chip with
a driver currently in misc.  The combination of these two are needed to
calculate illuminance.  Some of the original discussion went into how
to support separate access to the individual sensors.  Decision was to
leave that question until it becomes relevant.  Basically we would put
the current drivers in just supporting illuminance and see if anyone asked
for furthers support.  One tricky aspect is what the units should be for
particular frequency ranges. At least illuminance is cleanly defined
(even if chips are only fairly coarsely approximating it. 
> 
>>  
>>  static struct attribute *tsl2550_attributes[] = {
>>  	&dev_attr_power_state.attr,
>>  	&dev_attr_operating_mode.attr,
>> -	&dev_attr_lux1_input.attr,
>> +	&dev_attr_illuminance.attr,
>>  	NULL
>>  };
>>  
>> @@ -350,6 +387,7 @@ static int __devinit tsl2550_probe(struct i2c_client *client,
>>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>>  	struct tsl2550_data *data;
>>  	int *opmode, err = 0;
>> +	char name[9];
>>  
>>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WRITE_BYTE
>>  					    | I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
>> @@ -387,15 +425,31 @@ static int __devinit tsl2550_probe(struct i2c_client *client,
>>  	if (err)
>>  		goto exit_kfree;
>>  
>> +	data->id = tsl2550_get_id();
>> +	if (data->id < 0) {
>> +		err = data->id;
>> +		goto exit_kfree;
>> +	}
>> +	sprintf(name, "tsl2550%d", data->id);
> 
> Please no. For one thing you should always use snprintf and not sprintf
> when writing to such small buffers. It's way too easy to get things
> wrong otherwise. And you really want a separator between the chip name
> and the id, because "tsl25500" will be confusing as hell.
The length is fine with the restriction above, but I agree we need a separation
(hadn't really thought this through!).
> 
> Not that these comments of mine really matter, as I don't think the
> above code should stay at all.
That's fair enough and I'm inclined to agree.
> 
>>  	/* Register sysfs hooks */
>> -	err = sysfs_create_group(&client->dev.kobj, &tsl2550_attr_group);
>> +	data->classdev = als_device_register(&client->dev, name);
>> +	if (IS_ERR(data->classdev)) {
>> +		err = PTR_ERR(data->classdev);
>> +		goto exit_free_id;
>> +	}
>> +
>> +	err = sysfs_create_group(&data->classdev->kobj, &tsl2550_attr_group);
>>  	if (err)
>> -		goto exit_kfree;
>> +		goto exit_unreg;
>>  
>>  	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
>>  
>>  	return 0;
>>  
>> +exit_unreg:
>> +	als_device_unregister(data->classdev);
>> +exit_free_id:
>> +	tsl2550_free_id(data->id);
>>  exit_kfree:
>>  	kfree(data);
>>  exit:
>> @@ -404,12 +458,17 @@ exit:
>>  
>>  static int __devexit tsl2550_remove(struct i2c_client *client)
>>  {
>> -	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
>> +	struct tsl2550_data *data = i2c_get_clientdata(client);
>> +
>> +	sysfs_remove_group(&data->classdev->kobj, &tsl2550_attr_group);
>> +	als_device_unregister(data->classdev);
>>  
>>  	/* Power down the device */
>>  	tsl2550_set_power_state(client, 0);
>>  
>> -	kfree(i2c_get_clientdata(client));
>> +	tsl2550_free_id(data->id);
>> +
>> +	kfree(data);
>>  
>>  	return 0;
>>  }
> 
> 

