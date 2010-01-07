Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172Ab0AGQAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0AGQAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125Ab0AGQAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:00:07 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:49948 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab0AGQAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:00:05 -0500
Message-ID: <635ab1237a6a988656a2bf28e488f656.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <45a44e481001041557t1f87f8d4i959abbbee0c4346@mail.gmail.com>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
    <45a44e481001041557t1f87f8d4i959abbbee0c4346@mail.gmail.com>
Date: Thu, 7 Jan 2010 08:59:53 -0700
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz,
       linux-fbdev@vger.kernel.org
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
> On Tue, Dec 15, 2009 at 5:22 AM, Rick L. Vinyard Jr.
> <rvinyard@cs.nmsu.edu> wrote:
>> Additionally, this device contains a 160x43 monochrome LCD display.
>> A registered framebuffer device manages this display. The design
>> of this portion of the driver was based on the design of the
>> hecubafb driver with deferred framebuffer I/O since there is
>> no real memory to map.
>
> Hi Rick,
>
> Interesting work. I recommend CCing linux-fbdev@vger.kernel.org too
> since it contains a fbdev interface.
>

Thanks. Added.

>> +config LOGITECH_G13
>> +       tristate "Logitech G13 gameboard support"
>> +       depends on HID_LOGITECH
>> +       depends on FB
>> +       select FB_SYS_FILLRECT
>> +       select FB_SYS_COPYAREA
>> +       select FB_SYS_IMAGEBLIT
>> +       select FB_SYS_FOPS
>
> Does this need to select FB_DEFERRED_IO?
>

Added.

>> --- /dev/null
>> +++ b/drivers/hid/hid-g13-logo.xbm
>> @@ -0,0 +1,75 @@
>> +#define g13_lcd_width 160
>> +#define g13_lcd_height 43
>> +static unsigned char g13_lcd_bits[] = {
>> +   0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>> 0x00,
>
> Was there a reason for having a new logo file? If so, you might want
> to put it in the comments and also put it together with the standard
> kernel logo.
>

There really isn't a need for a separate file since it's pretty small. I
only separated it out to make it more visible.

I moved it inline, and resized, cleaned up, and inverted the default
penguin monochrome logo down to 40x40 from 80x80.

If anyone would like to add the 40x40 version of tux I made I'd be happy
to provide it.

>> +/* 160*43 rounded to nearest whole byte which is 160*48 since bytes are
>> +   vertical the y component must be a multiple of 8 */
>> +#define G13FB_SIZE (160*48/8)
>
> Minor nit, I think there is a macro for this, DIV_ROUND_UP, or maybe
> this could be better done in the function that uses this value.
>

It's used in several places so I'd prefer to keep the #define as I think
it makes the code more readable. As it turned out, this was a minor bug
left from an earlier iteration of the driver (before I added the
framebuffer code). The actual size need for the framebuffer is simply the
line length (160/8) * height (43).

The vbitmap of vertical bits actually transmitted still needs the rounding
plus a 32 byte offset at the beginning, resulting in a buffer of size 992.
I hard coded this into the #define and put the calculation in a comment.

>> +static ssize_t g13_set_mled(struct hid_device *hdev, unsigned mled);
>
> Does this need to be here or can the code be reordered?
>

Reordered.

>> +static struct fb_var_screeninfo g13fb_var = {
>> +       .xres = G13FB_WIDTH,
>> +       .yres = G13FB_HEIGHT,
>> +       .xres_virtual = G13FB_WIDTH,
>> +       .yres_virtual = G13FB_HEIGHT,
>> +       .bits_per_pixel = 1,
>> +       .nonstd = 1,
>> +};
>
> I think the nonstd is a bug. Yes, hecubafb and metronomefb seem to
> have the same bug as well. nonstd is used if you want something like
> FB_NONSTD_HAM or FB_NONSTD_REV_PIX_IN_B, which I don't think is what
> you want.
>

Removed.

> Hope this helps.
>
> Best regards,
> jaya
>

It definitely did. Thanks.

---

Rick


