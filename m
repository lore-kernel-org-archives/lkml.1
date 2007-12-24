Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbXLXRsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbXLXRsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 12:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXLXRrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 12:47:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbXLXRru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 12:47:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-embedded@ozlabs.org
Subject: Re: [PATCHv2] powerpc: DBox2 Board Support
Date: Mon, 24 Dec 2007 13:18:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jochen Friedrich <jochen@scram.de>, linuxppc-dev@ozlabs.org,
       Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org
References: <476E9930.6000205@scram.de>
In-Reply-To: <476E9930.6000205@scram.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712241318.02299.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+8VLeikuIU/ibE1YpdSI3Ar9yr1WB8wgjK1EO
 KMnYvyQAMlTsEsknVbI4n649gQg9OtZKeL7U+ss/ogbua/4rTb
 ufidXJh/EKfl6kjYho41g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 December 2007, Jochen Friedrich wrote:
> This patch adds device tree source, default config and setup code for
> DBox2 devices.

Cool stuff. I used to have one of these boxes myself, maybe I should
get one again when it's hitting mainline.

Is this already a complete port, or do you also need some device
drivers or boot wrapper code to go along with it?

> +	memory {
> +		device_type = "memory";
> +		reg = <0 2000000>;
> +	};

I thought there are both models with 32MB and 16MB available.
If that's true, shouldn't this be filled out by the boot loader?

> +#
> +# Frame buffer hardware drivers
> +#
> +# CONFIG_FB_OF is not set
> +# CONFIG_FB_VGA16 is not set
> +# CONFIG_FB_S1D13XXX is not set
> +# CONFIG_FB_IBM_GXT4500 is not set
> +# CONFIG_FB_VIRTUAL is not set
> +# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

No hardware framebuffer driver? Can't you use
the FB_OF driver by default? I'd guess that a
set-top box without output is rather pointless ;-)

> +# DOS/FAT/NT Filesystems
> +#
> +CONFIG_FAT_FS=y
> +CONFIG_MSDOS_FS=y
> +CONFIG_VFAT_FS=y
> +CONFIG_FAT_DEFAULT_CODEPAGE=437
> +CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> +# CONFIG_NTFS_FS is not set

What media can you connect that use the FAT file system?

I'd guess that if you can get rid of these, you can also
disable the entire block layer, which should free up
some kernel memory.

> @@ -0,0 +1,30 @@
> +/*
> + * A collection of structures, addresses, and values associated with
> + * the DBox2.
> + *
> + * Author: (c) 2007 Jochen Friedrich
> + *
> + * This file is licensed under the
> + * terms of the GNU General Public License version 2.  This program is licensed
> + * "as is" without any warranty of any kind, whether express or implied.
> + */
> +
> +#ifdef __KERNEL__
> +#ifndef __ASM_DBOX2_H__
> +#define __ASM_DBOX2_H__

You don't need the #ifdef __KERNEL__ any more if you don't have
any user-visible parts in the header. Just leave it out of the
list of exported header files (as you already do).

> +
> +/* Vendor information in BR Bootloader
> + */
> +
> +#define DBOX2_VENDOR_OFFSET	(0x1ffe0)
> +
> +enum dbox2_mid {
> +	DBOX2_MID_NOKIA       = 1,
> +	DBOX2_MID_PHILIPS     = 2,
> +	DBOX2_MID_SAGEM       = 3,
> +};
> +
> +enum dbox2_mid dbox2_get_mid(void);

Can you move this functionality from the kernel to the boot wrapper?
It looks like this is something that really belongs into the device
tree.

> +static void __init dbox2_setup_arch(void)
> +{
> +	struct device_node *np;
> +	static u8 __iomem *config;
> +
> +	cpm_reset();
> +	init_ioports();
> +
> +	/* Enable external IRQs for AVIA chips */
> +	clrbits32(&mpc8xx_immr->im_siu_conf.sc_siumcr, 0x00000c00);

This smells like a hack. What are AVIA chips, and shouldn't
their driver enable the IRQs?

> +	if (dbox2_manuf_id == DBOX2_MID_NOKIA)
> +		np = of_find_node_by_path("/localbus@8000000/enx@0");
> +	else
> +		np = of_find_node_by_path("/localbus@8000000/gtx@0");
> +
> +	if (np) {
> +		of_detach_node(np);
> +		of_node_put(np);
> +	}
> +
> +	if (dbox2_manuf_id == DBOX2_MID_PHILIPS)
> +		np = of_find_node_by_path("/localbus@8000000/cam@4000000");
> +	else
> +		np = of_find_node_by_path("/localbus@8000000/cam@4040000");
> +
> +	if (np) {
> +		of_detach_node(np);
> +		of_node_put(np);
> +	}
> +}

What is this code for? Why do you want to detach nodes from the device
tree that have been put in there by the boot loader?

> +static struct of_device_id __initdata of_bus_ids[] = {
> +	{ .name = "soc", },
> +	{ .name = "cpm", },
> +	{ .name = "localbus", },
> +	{},
> +};

Shouldn't this check for 'compatible' properties instead of 'name'?

> +static int __init declare_of_platform_devices(void)
> +{
> +	/* Publish the QE devices */
> +	if (machine_is(dbox2))
> +		of_platform_bus_probe(NULL, of_bus_ids, NULL);
> +
> +	return 0;
> +}
> +device_initcall(declare_of_platform_devices);

This is a candidate for the new platform_initcall stuff.

I also once did a patch that let you have a default 'of_bus_ids'
member in the ppc_md. I never got around to submitting that, but
if there is interest, I can dig it out again.

> --- a/include/asm-powerpc/mpc8xx.h
> +++ b/include/asm-powerpc/mpc8xx.h
> @@ -23,6 +23,10 @@
>  #include <platforms/8xx/mpc885ads.h>
>  #endif
>  
> +#if defined(CONFIG_DBOX2)
> +#include <platforms/8xx/dbox2.h>
> +#endif
> +

Don't hide #includes or platform specific #defines in #ifdef.

	Arnd <><
