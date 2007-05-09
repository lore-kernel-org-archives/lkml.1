Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXEIPAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXEIPAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbXEIO76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:59:58 -0400
Received: from mail.atmel.fr ([81.80.104.162]:54459 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbXEIO7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:59:54 -0400
Message-ID: <4641E1E9.5060800@rfo.atmel.com>
Date: Wed, 09 May 2007 16:59:53 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: linux-fbdev-devel@lists.sourceforge.net,
       Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] atmel_lcdfb: AT91/AT32 LCDController framebuffer driver
References: <463F3388.7020102@rfo.atmel.com> <1178574017.4674.30.camel@daplas>
In-Reply-To: <1178574017.4674.30.camel@daplas>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas :
> On Mon, 2007-05-07 at 16:11 +0200, Nicolas Ferre wrote:
>> From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>

>> +
>> +static struct fb_fix_screeninfo atmel_lcdfb_fix __initdata = {
>> +	.type		= FB_TYPE_PACKED_PIXELS,
>> +	.visual		= FB_VISUAL_TRUECOLOR,
>> +	.xpanstep	= 0,
>> +	.ypanstep	= 0,
>> +	.ywrapstep	= 0,
>> +	.accel		= FB_ACCEL_NONE,
>> +};
>> +
> 
> This driver has fb_pan_display() which I assume works. However, you also
> need to set ypanstep and/or xpanstep and/or ywrapstep to a nonzero
> value, depending on the hardware/drive capability.

True, this function is here because one of our products can do pan display.
The technique is not used for the moment but will be in a future version
of this driver.

>> +static u32 pseudo_palette[16] = {
>> +	0x000000,
>> +	0xaa0000,
>> +	0x00aa00,
>> +	0xaa5500,
>> +	0x0000aa,
>> +	0xaa00aa,
>> +	0x00aaaa,
>> +	0xaaaaaa,
>> +	0x555555,
>> +	0xff5555,
>> +	0x55ff55,
>> +	0xffff55,
>> +	0x5555ff,
>> +	0xff55ff,
>> +	0x55ffff,
>> +	0xffffff
>> +};
>> +
> 
> Do you really need to pre-fill pseudo_palette[]? The contents are going
> to be overwritten by the console anyway (The pseudo_palette is for
> fbcon's use only).

Ok, I have tested it with fbcon and no pre-fill : colors seem ok.

> You can also include pseudo_palette[] as part of struct
> atmel_lcdfb_info, then in your probe routine:
> 
> info->pseudo_palette = par->pseudo_palette;
> 
> to reduce the size of the kernel image. 

Done.

>> +static inline u_int chan_to_field(u_int chan, const struct fb_bitfield *bf)
> 
> Might as well change u_int to u32 or unsigned int, for consistency.

Ok, changed to unsigned int.

>> +static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
>> +{
>> +	struct fb_info *info = sinfo->info;
>> +	int ret = 0;
>> +
>> +	memset(info->screen_base, 0, info->fix.smem_len);
> 
> memset_io?

ok, modified.


>> +	if (dev->platform_data) {
>> +		pdata_sinfo = (struct atmel_lcdfb_info *)dev->platform_data;
>> +		sinfo->default_bpp = pdata_sinfo->default_bpp;
>> +		sinfo->default_dmacon = pdata_sinfo->default_dmacon;
>> +		sinfo->default_lcdcon2 = pdata_sinfo->default_lcdcon2;
>> +		sinfo->default_monspecs = pdata_sinfo->default_monspecs;
>> +		sinfo->atmel_lcdfb_power_control = pdata_sinfo->atmel_lcdfb_power_control;
>> +		sinfo->guard_time = pdata_sinfo->guard_time;
>> +	} else {
>> +		dev_err(dev, "cannot get default configuration\n");
>> +		goto out;
> 
> Wrong goto? Should be goto free_info?

Right. modified to "goto free_info".
 
>> +release_intmem:
>> +	if (map) {
>> +		release_mem_region(info->fix.smem_start, info->fix.smem_len);
>> +	}
> 
> Unnecessary curly braces

I like curly braces... Anyway, removed.

Thanks you for your comments.

I resend a modified driver now in the following email.

Regards,
-- 
Nicolas Ferre


