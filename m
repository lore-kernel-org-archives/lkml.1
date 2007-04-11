Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXDKMsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXDKMsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 08:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXDKMs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 08:48:29 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:44927 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752463AbXDKMs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 08:48:29 -0400
Message-ID: <461CD8EA.4080700@boichat.ch>
Date: Wed, 11 Apr 2007 20:47:38 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, linux-kernel@hansmi.ch, rlove@rlove.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [RFC][PATCH] Apple SMC driver (hardware monitoring
 and control)
References: <45F7C083.7090504@boichat.ch> <20070411142556.16cd1e44@hyperion.delvare>
In-Reply-To: <20070411142556.16cd1e44@hyperion.delvare>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.232.72 (nusnet-232-72.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your comments.

Jean Delvare wrote:
> Hi Nicolas,
> 
> Sorry for the delay.
> 
> On Wed, 14 Mar 2007 17:29:39 +0800, Nicolas Boichat wrote:
>> I developed, a while ago, a driver the Apple System Management
>> Controller, which provides an accelerometer (Apple Sudden Motion
>> Sensor), light sensors, temperature sensors, keyboard backlight control
>> and fan control on Intel-based Apple's computers (MacBook Pro, MacBook,
>> MacMini).
>>
>> This patch has been tested successfully since kernel 2.6.18 (i.e. 3-4
>> months ago) by various users on different systems on the mactel-linux lists.
>>
>> However, I'm not really satisfied with the way sysfs files are created:
>> I use a lot of preprocessor macros to avoid repetition of code.
>> The files created with these macros in /sys/devices/platform/applesmc are
>> the following (on a Macbook Pro):
>> fan0_actual_speed
>> fan0_manual
>> fan0_maximum_speed
>> fan0_minimum_speed
>> fan0_safe_speed
>> fan0_target_speed
>> fan1_actual_speed
>> fan1_manual
>> fan1_maximum_speed
>> fan1_minimum_speed
>> fan1_safe_speed
>> fan1_target_speed
>> temperature_0
>> temperature_1
>> temperature_2
>> temperature_3
>> temperature_4
>> temperature_5
>> temperature_6
> 
> First of all, please read Documentation/hwmon/sysfs-documentation, and
> rename the entries to match the standard names whenever possible. Also
> make sure that you use the standard units. If you use the standard
> names and units and if you register your device with the hwmon class,
> standard monitoring application will be able to support your driver.

Ok I'll have a look at this.

>> (i.e. temperature_* is created by one macro, fan*_actual_speed by
>> another, ...)
>> Is it acceptable programming practice? Is there a way to create these
>> files in a more elegant manner?
> 
> Some old hardware monitoring drivers are still doing this, but this is
> strongly discouraged for new drivers. It is possible (and easy) to
> avoid using such macros, by sharing callback functions between various
> sysfs files.
> 
> This is done by using SENSOR_DEVICE_ATTR instead of DEVICE_ATTR to
> declare the sysfs attributes. It takes an extra parameter, which is the
> entry number/index. You retrieve that index in the callback function:
> 
> static ssize_t show_temp(struct device *dev, struct device_attribute *devattr,
> 			 char *buf)
> {
> 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
> 	int nr = attr->index;
> 	(...)
> }
> 
> Take a look at the hwmon/f71805f.c driver for examples.

Yes I'm using something like this in the version that is in the -mm tree
now.

>> Also, I never call any sysfs_remove_* function, as the files are
>> deleted when the module is unloaded. Is it safe to do so? Doesn't it
>> cause any memory leak?
> 
> This is considered a bad practice, as in theory you driver shouldn't
> create the device by itself, and the files are associated to the device,
> not the driver. All hardware monitoring drivers have been fixed now, so
> please add the file removal calls in your driver too. You might find it
> easier to use file groups rather than individual files. Again, see for
> example the f71805f driver, and in particular the f71805f_attributes
> array and f71805f_group structure, and the sysfs_create_group() and
> sysfs_remove_group() calls.

Ok I'll fix this.

> I'm sorry but I really don't have the time for a complete review of
> your driver.

Your comments are already very valuable, thanks.

Best regards,

Nicolas
