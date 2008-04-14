Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbYDNOV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbYDNOV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbYDNOSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:18:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760672AbYDNOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:18:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] Add DIU platform code for MPC8610HPCD
Date: Mon, 14 Apr 2008 16:18:34 +0200
User-Agent: KMail/1.9.9
Cc: York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org
References: <12053582234100-git-send-email-yorksun@freescale.com> <12053582231281-git-send-email-yorksun@freescale.com> <12053582232536-git-send-email-yorksun@freescale.com>
In-Reply-To: <12053582232536-git-send-email-yorksun@freescale.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141618.34641.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18dp98wNNXDmV2IXXLm0BEVotcp/OKwzg4DkR7
 rtHe6FWSPlAB5h/QcBE63lYZlASuFob2Oa2LNGoKs+nz0dPolY
 0QafQa1uK0JVV6rkIb98A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, York Sun wrote:

> +#include <linux/bootmem.h>
> +#include <asm/rheap.h>
> +
> +#undef DEBUG
> +#ifdef DEBUG
> +#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__, ## args)
> +#else
> +#define DPRINTK(fmt, args...)
> +#endif

Please don't define your own debug macros, but rather use pr_debug and related
helpers from linux/kernel.h.

> +static unsigned char *pixis_bdcfg0, *pixis_arch;
> +

These need to be __iomem, as far as I can see. Please run 'make C=1'
to have this kind of problem checked by 'sparse' and clean up its
findings.

> @@ -161,12 +173,251 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL, 0x5229, quirk_uli5229);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AL, 0x5288, final_uli5288);
>  #endif /* CONFIG_PCI */
>  
> +static u32 get_busfreq(void)
> +{
> +	struct device_node *node;
> +
> +	u32 fs_busfreq = 0;
> +	node = of_find_node_by_type(NULL, "cpu");
> +	if (node) {
> +		unsigned int size;
> +		const unsigned int *prop =
> +			of_get_property(node, "bus-frequency", &size);
> +		if (prop)
> +			fs_busfreq = *prop;
> +		of_node_put(node);
> +	};
> +	return fs_busfreq;
> +}

I guess this breaks for frequencies larger than 2^32 Ghz, right?
IIRC, there is a method for encoding higher frequencies in the device
tree, and you should probably support that, or even better, refer
to some other function that is already interpreting it.

> +#ifdef CONFIG_FB_FSL_DIU
> +
> +static rh_block_t diu_rh_block[16];
> +static rh_info_t diu_rh_info;
> +static unsigned long diu_size = 1280 * 1024 * 4; /* One 1280x1024 buffer */
> +static void *diu_mem;

diu_mem is probably __iomem as well, right?

Also, it would be cleaner to have the variables in a data structure
pointed to by your device->driver_data. It would only be strictly
necessary if you expect to see a system with multiple DIU instances,
which I think is unlikely, but still it is the way that people
expect to see the code when they read it.

> +unsigned int platform_get_pixel_format
> +	(unsigned int bits_per_pixel, int monitor_port)
> +{
> +	static const unsigned long pixelformat[][3] = {
> +		{0x88882317, 0x88083218, 0x65052119},
> +		{0x88883316, 0x88082219, 0x65053118},
> +	};
> +	unsigned int pix_fmt, arch_monitor;
> +
> +	arch_monitor = ((*pixis_arch == 0x01) && (monitor_port == 0))? 0 : 1;
> +		/* DVI port for board version 0x01 */
> +
> +	if (bits_per_pixel == 32)
> +		pix_fmt = pixelformat[arch_monitor][0];
> +	else if (bits_per_pixel == 24)
> +		pix_fmt = pixelformat[arch_monitor][1];
> +	else if (bits_per_pixel == 16)
> +		pix_fmt = pixelformat[arch_monitor][2];
> +	else
> +		pix_fmt = pixelformat[1][0];
> +
> +	return pix_fmt;
> +}
> +EXPORT_SYMBOL(platform_get_pixel_format);

Generally, when you create new functions that are going to be used
just by your own code, they should be EXPORT_SYMBOL_GPL. It's your
choice though, as you are the author.

> +void platform_set_pixel_clock(unsigned int pixclock)
> +{
> +	u32 __iomem *clkdvdr;
> +	u32 temp;
> +	/* variables for pixel clock calcs */
> +	ulong  bestval, bestfreq, speed_ccb, minpixclock, maxpixclock;
> +	ulong pixval;
> +	long err;
> +	int i;
> +
> +	clkdvdr = ioremap(get_immrbase() + 0xe0800, sizeof(u32));

Please don't use get_immrbase in new code. Instead, register an
of_platform_driver for the device in the device tree, then 
use of_iomap to map its register from the driver probe() callback.

> +void *fsl_diu_alloc(unsigned long size, unsigned long *phys)
> +{
> +	 void *virt;
> +
> +	 DPRINTK("size=%lu\n", size);
> +
> +	 virt = dma_alloc_coherent(0, size, phys, GFP_DMA | GFP_KERNEL);
> +
> +	 if (virt) {
> +		DPRINTK("dma virt=%p phys=%lx\n", virt, *phys);
> +		return virt;
> +	 }
> +
> +	 if (!diu_mem) {
> +		printk(KERN_INFO "%s: no diu_mem\n", __func__);
> +		return NULL;
> +	 }
> +
> +	 virt = rh_alloc(&diu_rh_info, size, "DIU");
> +	 if (virt)
> +		*phys = virt_to_bus(virt);
> +
> +	 DPRINTK("rh virt=%p phys=%x\n", virt, *phys);
> +
> +	 return virt;
> +}
> +EXPORT_SYMBOL(fsl_diu_alloc);

Don't use virt_to_bus in new code, it does not work with the DMA
mapping API. Instead, use dma_map_single() to convert the kernel address
into something that can be addressed by hardware.

You probably don't need the dma_alloc_coherent path in that case,
but always use dma_map_single on a newly allocated piece of kernel
memory.

	Arnd <><
