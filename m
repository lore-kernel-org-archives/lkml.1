Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0BEUlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:41:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab0BEUlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:41:15 -0500
Date: Fri, 5 Feb 2010 12:40:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Chris Verges" <chrisv@cyberswitching.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Rob Owings" <rowings@thermistor.com>
Subject: Re: [PATCH] linux-2.6.32-directemp
Message-Id: <20100205124038.4f1e83ac.akpm@linux-foundation.org>
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 20:47:05 -0800
"Chris Verges" <chrisv@cyberswitching.com> wrote:

> Hi Linux gurus,
> 
> Attached is a patch for the QTI DirecTEMP USB thermometer &
> thermometer/hygrometer sensors.  This patch is based on linux-2.6.32.
> Functionality has been verified against both hardware variants listed in
> the driver (0x0002 and 0x0006), as both monolithic and modular.
> 
> When the QTI DirecTEMP sensor is connected to a system, the directemp
> driver adds appropriate sysfs entries for the sensor type(s) supported.
> Examples:
> 
>    # PID 0x0002 (temp only)
>    /sys/bus/usb/devices/.../temp
> 
>    # PID 0x0006 (temp + relative humidity)
>    /sys/bus/usb/devices/.../temp
>    /sys/bus/usb/devices/.../rh
> 
> Using a standard "cat" will display the value.

Seems a bit strange that a device driver's only interface is via sysfs.
Once upon a time people used /dev.  Ho hum.

It would be useful if the changelog were to describe what the contents
of the sysfs files look like.  That's an important part of the user
interface and the user interface is the most important part of the
driver, because we can't change that.

afacit the `temp' file displays something like "44 C", yes?  If so,
that's a bit awkward for software parsing.  It'd be clearer to rename
`temp' to `temperature_in_centigrade" or simply "centigrade" and then
display "44", and remove the units from the output.

Ditto the "rh" file, which presently contains "42%".

> An additional "raw" sysfs entry has been added to aid in debugging.  If
> used, an "echo" will send the data specified in the string to the USB
> device, and print back the results.  It is not recommended for customer
> use except by expert users.
> 
> And with that description out of the way, I look forward to your review
> of the driver.  Please provide any feedback that you may have.
> 

Have a review-by-patch:


- `pid' is a well-understood term for a process ID.  Rename it.

- clean up some memsets

- Change the `raw' file's permissions to S_IWUSR.  We shouldn't permit
  unprivileged users to cause a printk spew into the logs.

--- a/drivers/usb/misc/directemp.c~usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix
+++ a/drivers/usb/misc/directemp.c
@@ -40,7 +40,7 @@
 struct usb_directemp {
 	struct usb_device	*udev;
 	struct usb_interface	*interface;
-	uint16_t		pid;
+	uint16_t		product_id;
 
 	uint8_t			read_temp;
 };
@@ -114,7 +114,7 @@ static ssize_t show_temp(struct device *
 
 	/* Read twice due to a buffer issue on the DirecTEMP */
 	for (i = 0; i < DIRECTEMP_MAX_RETRIES; i++) {
-		memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+		memset(data, 0, sizeof(data));
 		data[0] = directemp->read_temp;
 		err = show_helper(dev, attr, data, data, DIRECTEMP_MSG_SIZE);
 		if (err < 0)
@@ -156,7 +156,7 @@ static ssize_t show_rh(struct device *de
 
 	/* Read twice due to a buffer issue on the DirecTEMP */
 	for (i = 0; i < DIRECTEMP_MAX_RETRIES; i++) {
-		memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+		memset(data, 0, sizeof(data));
 		data[0] = DIRECTEMP_HUMIDITY;
 		err = show_helper(dev, attr, data, data, DIRECTEMP_MSG_SIZE);
 		if (err < 0)
@@ -199,7 +199,7 @@ static ssize_t set_raw(struct device *de
 	if (count > DIRECTEMP_MSG_SIZE)
 		count = DIRECTEMP_MSG_SIZE;
 
-	memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+	memset(data, 0, sizeof(data));
 	memcpy(data, buf, count);
 
 	printk("Request:\n");
@@ -219,7 +219,7 @@ static ssize_t set_raw(struct device *de
 	return 0;
 }
 
-static DEVICE_ATTR(raw, S_IWUGO, NULL, set_raw);
+static DEVICE_ATTR(raw, S_IWUSR, NULL, set_raw);
 
 static int directemp_probe(struct usb_interface *interface,
 			 const struct usb_device_id *id)
@@ -234,10 +234,10 @@ static int directemp_probe(struct usb_in
 
 	dev->udev = usb_get_dev(udev);
 	usb_set_intfdata(interface, dev);
-	dev->pid = id->idProduct;
+	dev->product_id = id->idProduct;
 
 	dev_dbg(&interface->dev, "Product:       %s (ID 0x%04X)\n",
-			udev->product, dev->pid);
+			udev->product, dev->product_id);
 	dev_dbg(&interface->dev, "Manufacturer:  %s\n",
 			udev->manufacturer);
 	dev_dbg(&interface->dev, "Serial Number: %s\n",
@@ -253,7 +253,7 @@ static int directemp_probe(struct usb_in
 	if (err)
 		goto exit_free_sysfs;
 
-	switch (dev->pid) {
+	switch (dev->product_id) {
 	case 0x0002:
 		dev->read_temp = '2';
 		break;
_

