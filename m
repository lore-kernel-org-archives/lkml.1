Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZFYLqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZFYLqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZFYLqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:46:00 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48912 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZFYLp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:45:59 -0400
Message-ID: <461dbc08f8573008440a03b9618bce94.squirrel@www.hardeman.nu>
In-Reply-To: <20090624151335.0f73907c@jbarnes-g45>
References: <20090624213645.GA18843@hardeman.nu>
    <20090624151335.0f73907c@jbarnes-g45>
Date: Thu, 25 Jun 2009 13:46:01 +0200 (CEST)
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP 
     id WEC1022)
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       alan@lxorguk.ukuu.org.uk, linux-acpi@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, June 25, 2009 00:13, Jesse Barnes wrote:
> On Wed, 24 Jun 2009 14:36:45 -0700
> David Härdeman <david@hardeman.nu> wrote:
>
>> I've written a driver for the
...
>> Winbond WPCD376I chipset
>
> Yay, glad I could get these released for you.  I just did a quick scan
> of the driver (notes below)

Two more things that Intel could provide:

a) Publish the datasheet (I know you mentioned doing this but
   I can't find it on the Intel website)

b) Make the hardware needed to actually use the CIR functionality
   available for purchase. http://www.easy-cir.com seems to be more
   or less dead (which is curious since an ad for the website
   seems to be included with every CIR-enabled Intel motherboard).
   I had to solder my own IR receiver in order to write the driver.

>> I'd appreciate having the driver reviewed...and in addition I have
>> some questions for the list:
>>
>>    1) SuperI/O concurrency
>> ...
>
> Yeah, often multifunction devices like this have higher level "bus
> drivers" that take care of managing the global parts, and drivers that
> attach to it to manage individual functions.  If you were feeling
> really ambitious you could do that for the superio chip and port any
> sub-drivers... :)

My ambitions are more directed towards some kind of IR-subsystem into the
kernel at the moment :) Besides, the Intel mainboards doesn't actually
seem to use any of the other logical devices (which are mostly supported
by existing drivers anyway).

>> Where should this driver go in the tree? drivers/platform/x86/?
>
> drivers/char is probably fine.

I'm leaning towards drivers/input/misc now...

>> #define dprintk(fmt, arg...)                                    \
>> do {                                                            \
>>         if (debug)                                              \
>>                 printk(KERN_DEBUG DRVNAME fmt , ## arg);        \
>> } while (0)
>
> Maybe you could use the generic debug functions instead (pr_debug iirc)?

Yes

> ...
> There are a few magic numbers above here you could possibly make into
> #defines just to make things more readable.

I'll try

> The key up/down timeout handling seems like a pretty general problem,
> maybe the input layer has some helpers for it?  Dunno.

drivers/media/common/ir-functions.c is the closest thing I could find
while writing the driver. The functions there aren't usable because they
do not properly implement the toggle/repeat handling and it forces the use
of a small, fixed-size keymap. The same problem existed when I improved
the IR functionality in drivers/media/dvb/ttpci/budget-ci.c by the way, so
a generic version could probably be added to ir-functions in the future.

>> static ssize_t
>> wbcir_show_last_scancode(struct device *dev,
>>                             struct device_attribute *attr, char *buf)
>> {
>>         struct acpi_device *device = container_of(dev, struct
>> acpi_device, dev); struct wbcir_data *data = acpi_driver_data(device);
>>         return sprintf(buf, "0x%08X\n", data->last_scancode);
>> }
>>
>> static struct device_attribute dev_attr_last_scancode = {
>>         .attr = {
>>                 .name = "last_scancode",
>>                 .mode = 0444,
>>         },
>>         .show = wbcir_show_last_scancode,
>>         .store = NULL,
>>
>> };
>>
>> static struct attribute *wbcir_attributes[] = {
>>         &dev_attr_last_scancode.attr,
>>         NULL,
>> };
>>
>> static struct attribute_group wbcir_attribute_group = {
>>         .attrs = wbcir_attributes,
>> };
>
> Are these just for debugging?  If so, you could put them in debugfs
> instead...

No, they are there to help the user when generating a keymap for an
unknown remote. Press key on remote, read value from
/sys/.../last_scancode, add line saying "0x12345678 = KEY_EXPLODE" to
keymap file, repeat...there aren't any user-friendly tools for this yet
though.

(Dropped Terry from the CC, I just saw that he had requested a driver for
this chip earlier but I'm not sure he's that interested in the rest of the
discussion)

-- 
David Härdeman

