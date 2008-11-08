Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYKHGTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYKHGTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 01:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYKHGS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 01:18:58 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1332 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYKHGS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 01:18:57 -0500
Message-ID: <49152F4E.5040003@shikadi.net>
Date: Sat, 08 Nov 2008 16:18:54 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: hid class and sysfs/hwmon (was: led and hid class - hid_device vs
 led_classdev)
References: <490FFF1B.6050300@shikadi.net> <4910C32F.9060204@gmail.com>
In-Reply-To: <4910C32F.9060204@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> static void my_led_set(struct led_classdev *led_cdev,
>>   enum led_brightness value)
>> {
>>   /* How do I get my_data back? */
>> }
>>
> 
> my_led should by part of my_data, then you do
> my_data = container_of(led_cdev, /*typeof(my_data)*/, my_led);

That did the trick, thanks!  I hadn't realised what container_of() was 
meant to be for - that's quite a useful little macro!

I got that working (can switch the LED on and off via the led device) 
but now I'm stuck trying to implement a hwmon interface for the device's 
sensors.

As far as I can tell I'm doing everything fine, but for some reason the 
hwmon interface gets created but with no files inside it (apart from a 
few defaults.)  It's supposed to have files like "temp1_input" to report 
temperatures, but these files never appear.

The only thing that I'm unsure of is the first parameter to 
sysfs_create_group().  All the other drivers use something like 
i2c_client.dev.kobj or platform_device.dev.kobj, but I'm using 
hid_device.dev.kobj.  I'm guessing that should work just as well, but I 
can't figure out why else the sysfs files never appear in the new hwmon 
folder in /sys/class/hwmon/

Here is the code so far, if it's useful: (I've omitted all the error 
checking code for clarity, all the functions called here return success)

--------------------------------------------
static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);

static struct attribute *odin_attributes[] = {
   &sensor_dev_attr_temp1_input.dev_attr.attr,
   NULL
};

static const struct attribute_group odin_attr_group = {
   .attrs = odin_attributes,
};

static int odin_probe(struct hid_device *hdev,
   const struct hid_device_id *id)
{
   hid_parse(hdev);
   hid_hw_start(hdev, HID_CONNECT_DEFAULT);

   odin_psu = kzalloc(sizeof(struct odin_psu_device), GFP_KERNEL);
   odin_psu->hdev = hdev;

   hid_set_drvdata(hdev, odin_psu);

   sysfs_create_group(&hdev->dev.kobj, &odin_attr_group);
   odin_psu->hwmon_dev = hwmon_device_register(&hdev->dev);

   return 0;
}
--------------------------------------------
$ ls /sys/class/hwmon/hwmon5/
total 0
drwxr-xr-x 3 root root    0 2008-11-08 14:50 .
drwxr-xr-x 8 root root    0 2008-11-08 14:50 ..
lrwxrwxrwx 1 root root    0 2008-11-08 14:50 device -> 
../../../devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1:1.0/0003:1044:4001.0001
drwxr-xr-x 2 root root    0 2008-11-08 14:50 power
lrwxrwxrwx 1 root root    0 2008-11-08 14:50 subsystem -> ../../hwmon
-rw-r--r-- 1 root root 4.0K 2008-11-08 14:50 uevent
--------------------------------------------

If anyone can see why this might result in no sysfs files, please let me 
know!  I previously had most of this code working with a platform_device 
instead of the hid_device, which is what makes me wonder about 
hdev->dev.kobj.  (Not sure how to test if that variable is accurate, 
either.)  Or perhaps it has already been used elsewhere and it can only 
be used once?

Thanks,
Adam.
