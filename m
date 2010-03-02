Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab0CBXrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:47:51 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:56631 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020Ab0CBXrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:47:48 -0500
Message-ID: <24ab70ff629c48b6d10ce0cf6dc5d64b.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <45a44e481003021523h4a05a9bfu9691f2c0f2f053c7@mail.gmail.com>
References: <201003021848.o22ImLSS004394@mustang.cs.nmsu.edu>
    <45a44e481003021523h4a05a9bfu9691f2c0f2f053c7@mail.gmail.com>
Date: Tue, 2 Mar 2010 16:46:45 -0700
Subject: Re: [PATCH] hid Logitech G13 Driver 0.0.5
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, pavel@ucw.cz,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       npavel@ituner.com, tomi.valkeinen@nokia.com, tony@atomide.com,
       florianschandinat@gmx.de, krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-fbdev@vger.kernel.org, jkosina@suse.cz, bonbons@linux-vserver.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jaya Kumar wrote:
> On Wed, Mar 3, 2010 at 2:48 AM, Rick L. Vinyard Jr.
> <rvinyard@cs.nmsu.edu> wrote:
>> [PATCH] hid Logitech G13 Driver 0.0.5
>
> Hi Rick,
>
> Thanks for posting this. It has improved a lot.
>
>>
>> This driver relies on two patches:
>>  1. Bruno Prémont's [PATCH 2/3] hid: add suspend/resume hooks for hid
>> drivers
>>  2. [PATCH] Add sysfs support for fbdefio delay
>
> Please help me understand in what way does this patch have to have the
> global userspace exposure of defio delay in sysfs support. If that
> sysfs patch was not accepted, I don't see this patch affected
> negatively.
>

It's in the deferred I/O struct definition with members delay_min and
delay_max.

static struct fb_deferred_io g13_fb_defio = {
	.delay = HZ / G13FB_UPDATE_RATE_DEFAULT,
	.delay_min = HZ / 20,
	.delay_max = HZ * 3,
	.deferred_io = g13_fb_deferred_io,
};


>> However, the driver does use the HID feature reports extensively to
>> control the backlight, LEDs, et. al.
>
> Ok.
>
>> - Removed the update rate sysfs attribute as it is in the second patch
>> above.
>
> Why? There is no consensus that exposing defio delay for _all_ fb
> drivers is a good idea. I would rather you left that in here for now.
>

If the consensus is that defio delay will be exposed on a driver by driver
basis I can paste that back in here and modify the userspace g13 library
accordingly.

>> +/*
>> + * This is a default logo to be loaded upon driver initialization
>> + * replacing the default Logitech G13 image loaded on device
>> + * initialization. This is to provide the user a cue that the
>> + * Linux driver is loaded and ready.
>> + *
>> + * This logo contains the text G13 in the center with two penguins
>> + * on each side of the text. The penguins are a 33x40 rendition of
>> + * the default framebuffer 80x80 monochrome image scaled down and
>> + * cleaned up to retain something that looks a little better than
>> + * a simple scaling.
>> + *
>> + * This logo is a simple xbm image created in GIMP and exported.
>> + * To view the image copy the following two #defines plus the
>> + * g13_lcd_bits to an ASCII text file and save with extension
>> + * .xbm, then open with GIMP or any other graphical editor
>> + * such as eog that recognizes the .xbm format.
>> + */
> ...
>> +static unsigned char g13_lcd_bits[] = {
>> + 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> 0x00,
>
> I think you'll agree above is not an elegant solution.
>

I could make it a config option.

>> +
>> +static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
>
> Reading above code, it looks like this new userspace sysfs attribute
> is for backlight control. Could that be better exposed using the
> existing backlight class?
>

I looked at the backlight class and it didn't seem to be a very good fit.

/* This structure defines all the properties of a backlight */
struct backlight_properties {
	/* Current User requested brightness (0 - max_brightness) */
	int brightness;
	/* Maximal value for brightness (read-only) */
	int max_brightness;
	/* Current FB Power mode (0: full on, 1..3: power saving
	   modes; 4: full off), see FB_BLANK_XXX */
	int power;
	/* FB Blanking active? (values as for power) */
	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
	int fb_blank;
	/* Flags used to signal drivers of state changes */
	/* Upper 4 bits are reserved for driver internal use */
	unsigned int state;
};

The g13's backlight doesn't support any of these properties. All you can
set is an rgb value on the g13; no power modes, no brightness, etc. I
could add a brightness attribute by scaling the rgb values, but I would
prefer to do that from userspace rather than the driver since it's not
supported in the device itself.

And, we'd still have to have the rgb attribute since the backlight class
doesn't have color.

-- 

Rick

