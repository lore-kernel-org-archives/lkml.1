Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZFXWNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZFXWNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbZFXWNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:13:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:1171 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZFXWNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:13:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,285,1243839600"; 
   d="scan'208";a="158183499"
Date: Wed, 24 Jun 2009 15:13:35 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "terry@beam.ltd.uk" <terry@beam.ltd.uk>, alan@lxorguk.ukuu.org.uk,
       linux-acpi@vger.kernel.org
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP
 id WEC1022)
Message-ID: <20090624151335.0f73907c@jbarnes-g45>
In-Reply-To: <20090624213645.GA18843@hardeman.nu>
References: <20090624213645.GA18843@hardeman.nu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 14:36:45 -0700
David Härdeman <david@hardeman.nu> wrote:

> I've written a driver for the Consumer IR (CIR) functionality of the
> Winbond WPCD376I chipset (found on e.g. Intel DG45FC motherboards)
> using documentation helpfully provided by Jesse Barnes at Intel.

Yay, glad I could get these released for you.  I just did a quick scan
of the driver (notes below), I'm sure others will have comments too.
I'd guess Andrew would be the one to pick this up and send it to Linus
(probably sooner rather than later, no reason to block a small and
reasonable looking driver from going upstream quickly).

> The driver currently supports receiving IR commands (only tested RC6
> using a "Vista" remote so far) and wake from sleep/power-off (haven't
> tested sleep yet, can't get the DG45FC to suspend/resume properly).
> 
> I'd appreciate having the driver reviewed...and in addition I have
> some questions for the list:
> 
>    1) SuperI/O concurrency
> 
> Lots of drivers support one or more logical devices provided by
> different SuperI/O chips, but there seems to be no synchronisation
> between the different drivers? Since my driver gets all info from
> ACPI, it's no real problem here, but I'm curious...shouldn't there be
> some kind of synchronisation between SuperI/O drivers which might all
> be changing global registers, such as the logical device select
> register?

Yeah, often multifunction devices like this have higher level "bus
drivers" that take care of managing the global parts, and drivers that
attach to it to manage individual functions.  If you were feeling
really ambitious you could do that for the superio chip and port any
sub-drivers... :)

>    2) Location of driver
> 
> Where should this driver go in the tree? drivers/platform/x86/?

drivers/char is probably fine.

>    3) ACPI resource order
> 
> Using ACPI I can get the three I/O memory ranges and the IRQ used by
> the device, but how do I actually know for sure that the order that my
> board/BIOS returns those resources will be the same as all other
> motherboard/BIOS combinations? It seems kind of weird that ACPI
> provides all this info without any tags to tell the driver which of
> the resources is to be used for what (I'm assuming this is an ACPI
> limitation?).

Not sure, I'd have to check the ACPI docs about this.  Len or someone
on the ACPI mailing list would probably know though.

>    4) Input layer changes, 32 bit scancodes
> 
> In order to support RC6 (as well as RC5 and NEC), the driver currently
> relies on 32 bit scancodes using a sparse keymap. I'm not sure if this
> is a good approach or not. The input syscalls all seem to use an int
> for the scancode (which will be at least 32 bits on any platform
> which has the hardware - i.e. x86 and amd64), but I'm worried if this
> is an "ok" use of the input layer?
> 
> Might it be a good idea to add IR specific ioctls to the input
> subsystem (similar to the force feedback ones) which allows different
> IR codes to be specified in a clearer manner? (this is also relevant
> to e.g. drivers/media/dvb/ttpci/budget-ci.c where I've meddled in the
> IR functionality, that driver is currently artificially limited to
> supporting one RC5 address only due to input limitations).

Question for Dmitry and the input guys I guess.

>    6) Reclaiming the serial port
> 
> The serial port which the WPCD376I uses for IR TX/RX is only useful
> for Consumer IR, but it looks enough like a "normal" uart for the
> serial driver to claim the port. I currently have to boot with
> "8250.nr_uarts=1" to stop the serial driver from using the IR uart
> (there is one "real" serial port in the chip). However, that's not a
> very elegant or user-friendly option. Is there a way to blacklist the
> port in the serial driver and/or to reclaim the port from the serial
> driver when the CIR driver is loaded?

Alan should know the answer to this question.

>    7) kmalloc and spinlocks
> 
> In wbcir_setkeycode the driver might need to kmalloc memory for a new
> keytable entry, but kmalloc isn't allowed with rwlocks held so I've
> currently written the driver to do a kmalloc before taking the rwlock
> and then to kfree it later if it wasn't necessary, which feels quite
> inelegant to me. Any suggestions on a better approach?

You could use a GFP_ATOMIC allocation... but it's best if you can avoid
that.


> #define dprintk(fmt, arg...)                                    \
> do {                                                            \
>         if (debug)                                              \
>                 printk(KERN_DEBUG DRVNAME fmt , ## arg);        \
> } while (0)

Maybe you could use the generic debug functions instead (pr_debug iirc)?

> static u8
> wbcir_to_rc6cells(u8 val)
> {
>         u8 coded = 0x00;
>         int i;
> 
>         val &= 0x0F;
>         for (i = 0; i < 4; i++) {
>                 if (val & 0x01)
>                         coded |= 0x02 << (i * 2);
>                 else
>                         coded |= 0x01 << (i * 2);
>                 val >>= 1;
>         }
> 
>         return coded;
> }

There are a few magic numbers above here you could possibly make into
#defines just to make things more readable.

> static void
> wbcir_keyup(unsigned long cookie)
> {
>         struct wbcir_data *data = (struct wbcir_data *)cookie;
>         unsigned long flags;
> 
>         /*
>          * data->keyup_jiffies is used to prevent a race condition if
> a
>          * hardware interrupt occurs at this point and the keyup timer
>          * event is moved further into the future as a result.
>          */
> 
>         spin_lock_irqsave(&wbcir_lock, flags);
> 
>         if (time_is_after_eq_jiffies(data->keyup_jiffies) &&
> data->keypressed) { data->keypressed = 0;
>                 led_trigger_event(data->rxtrigger, LED_OFF);
>                 input_report_key(data->input_dev, data->last_keycode,
> 0); input_sync(data->input_dev);
>         }
> 
>         spin_unlock_irqrestore(&wbcir_lock, flags);
> }
> 
> static void
> wbcir_keydown(struct wbcir_data *data, u32 scancode, u8 toggle)
> {
>         unsigned int keycode;
> 
>         /* Repeat? */
>         if (data->last_scancode == scancode &&
>             data->last_toggle == toggle &&
>             data->keypressed)
>                 goto set_timer;
>         data->last_scancode = scancode;
> 
>         /* Do we need to release an old keypress? */
>         if (data->keypressed) {
>                 input_report_key(data->input_dev, data->last_keycode,
> 0); input_sync(data->input_dev);
>                 data->keypressed = 0;
>         }
> 
>         /* Do we know this scancode? */
>         keycode = wbcir_do_getkeycode(data, scancode);
>         if (keycode == KEY_RESERVED)
>                 goto set_timer;
> 
>         /* Register a keypress */
>         input_report_key(data->input_dev, keycode, 1);
>         input_sync(data->input_dev);
>         data->keypressed = 1;
>         data->last_keycode = keycode;
>         data->last_toggle = toggle;
> 
> set_timer:
>         led_trigger_event(data->rxtrigger,
>                           data->keypressed ? LED_FULL : LED_OFF);
>         data->keyup_jiffies = jiffies +
> msecs_to_jiffies(IR_KEYPRESS_TIMEOUT); mod_timer(&data->timer_keyup,
> data->keyup_jiffies); }

The key up/down timeout handling seems like a pretty general problem,
maybe the input layer has some helpers for it?  Dunno.

> static ssize_t
> wbcir_show_last_scancode(struct device *dev,
>                             struct device_attribute *attr, char *buf)
> {
>         struct acpi_device *device = container_of(dev, struct
> acpi_device, dev); struct wbcir_data *data = acpi_driver_data(device);
>         return sprintf(buf, "0x%08X\n", data->last_scancode);
> }
> 
> static struct device_attribute dev_attr_last_scancode = {
>         .attr = {
>                 .name = "last_scancode",
>                 .mode = 0444,
>         },
>         .show = wbcir_show_last_scancode,
>         .store = NULL,
> 
> };
> 
> static struct attribute *wbcir_attributes[] = {
>         &dev_attr_last_scancode.attr,
>         NULL,
> };
> 
> static struct attribute_group wbcir_attribute_group = {
>         .attrs = wbcir_attributes,
> };

Are these just for debugging?  If so, you could put them in debugfs
instead...

-- 
Jesse Barnes, Intel Open Source Technology Center
