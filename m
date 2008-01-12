Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbYALWjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbYALWjY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbYALWjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:39:16 -0500
Received: from ambient.dashsystems.com ([216.27.85.7]:44548 "EHLO
	kettle.ambient-hosting.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758853AbYALWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:39:15 -0500
From: Andy Wingo <wingo@pobox.com>
To: debian-powerpc <debian-powerpc@lists.debian.org>,
       nouveau@lists.freedesktop.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: backlight module for nvidia cards -- control backlight even with offb
Date: Sat, 12 Jan 2008 23:37:18 +0100
Message-ID: <87r6gmy8kh.fsf@pobox.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi all,

I have a 12" powerbook, one of the last G4's, and have long been
irritated that I couldn't use offb because it has no backlight control.
This is more irritating now that the nouveau project's X drivers are
starting to work for me on PPC, but are incompatible with the nvidiafb
frame buffer.

I decided to rip out the backlight code from the nvidia frame buffer
into a separate module that can be loaded even when using offb as the
frame buffer. I am attaching the source, but you may find a tarball with
a makefile here:

  http://wingolog.org/pub/nvbacklight-0.1.tar.bz2

I do not know what the correct solution is. Ideally offb would export a
backlight device. I tried getting open firmware to give me the needed
information, but the "reg" entry for the backlight seems short, given
that the mac-io@17 #address-cells == 1 and #size-cells == 1:

  $ hd /proc/device-tree/pci@f2000000/mac-io@17/backlight@f300/reg 
  00000000  00 00 f3 00                                       |....|
  00000004

For that reason I'm copying Ben Herrenschmidt to see if he knows
something about a proper solution. For now I'll just add nvbacklight to
my /etc/modules. Ideas about a "proper solution" are appreciated.

Regards,

Andy


--=-=-=
Content-Disposition: inline; filename=nvbacklight.c
Content-Description: module implementing backlight controller for nvidia
 cards

/*
 * nvbacklight.c: Backlight driver for nVidia graphics cards
 *
 * Copyright 2008 Andy Wingo <wingo@pobox.com>
 * Copyright 2004 Antonino Daplas <adaplas@pol.net>
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file COPYING in the main directory of this archive
 * for more details.
 *
 */


#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/slab.h>
#include <linux/vmalloc.h>
#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/fb.h>
#include <linux/init.h>
#include <linux/ioport.h>
#include <linux/pci.h>
#include <linux/backlight.h>

#ifdef CONFIG_PMAC_BACKLIGHT
#include <asm/backlight.h>
#endif


struct nvbacklight_par {
	struct pci_dev *pci_dev;
	struct fb_info *info;
	struct backlight_device *bd;

	volatile u32 __iomem *REGS;
	volatile u32 __iomem *PCRTC0;
	volatile u32 __iomem *PCRTC;
	volatile u32 __iomem *PRAMDAC0;
	volatile u32 __iomem *PFB;
	volatile u32 __iomem *PFIFO;
	volatile u32 __iomem *PGRAPH;
	volatile u32 __iomem *PEXTDEV;
	volatile u32 __iomem *PTIMER;
	volatile u32 __iomem *PMC;
	volatile u32 __iomem *PRAMIN;
	volatile u32 __iomem *FIFO;
	volatile u32 __iomem *CURSOR;
	volatile u8 __iomem *PCIO0;
	volatile u8 __iomem *PCIO;
	volatile u8 __iomem *PVIO;
	volatile u8 __iomem *PDIO0;
	volatile u8 __iomem *PDIO;
	volatile u32 __iomem *PRAMDAC;

	u32 fpSyncs;
};


/* We do not have any information about which values are allowed, thus
 * we used safe values.
 */
#define MIN_LEVEL 0x158
#define MAX_LEVEL 0x534
#define LEVEL_STEP ((MAX_LEVEL - MIN_LEVEL) / FB_BACKLIGHT_MAX)

#define NV_WR32(p,i,d)  (__raw_writel((d), (void __iomem *)(p) + (i)))
#define NV_RD32(p,i)    (__raw_readl((void __iomem *)(p) + (i)))


static int nvidia_bl_get_level_brightness(struct fb_info *info, int level)
{
	int nlevel;

	/* Get and convert the value */
	/* No locking of bl_curve since we read a single value */
	nlevel = MIN_LEVEL + info->bl_curve[level] * LEVEL_STEP;

	if (nlevel < 0)
		nlevel = 0;
	else if (nlevel < MIN_LEVEL)
		nlevel = MIN_LEVEL;
	else if (nlevel > MAX_LEVEL)
		nlevel = MAX_LEVEL;

	return nlevel;
}

static int nvidia_bl_update_status(struct backlight_device *bd)
{
	struct nvbacklight_par *par = bl_get_data(bd);
	u32 tmp_pcrt, tmp_pmc, fpcontrol;
	int level;

	if (bd->props.power != FB_BLANK_UNBLANK ||
	    bd->props.fb_blank != FB_BLANK_UNBLANK)
		level = 0;
	else
		level = bd->props.brightness;

	tmp_pmc = NV_RD32(par->PMC, 0x10F0) & 0x0000FFFF;
	tmp_pcrt = NV_RD32(par->PCRTC0, 0x081C) & 0xFFFFFFFC;
	fpcontrol = NV_RD32(par->PRAMDAC, 0x0848) & 0xCFFFFFCC;

	if (level > 0) {
		tmp_pcrt |= 0x1;
		tmp_pmc |= (1 << 31); /* backlight bit */
		tmp_pmc |= nvidia_bl_get_level_brightness(par->info, level) << 16;
		fpcontrol |= par->fpSyncs;
	} else
		fpcontrol |= 0x20000022;

	NV_WR32(par->PCRTC0, 0x081C, tmp_pcrt);
	NV_WR32(par->PMC, 0x10F0, tmp_pmc);
	NV_WR32(par->PRAMDAC, 0x848, fpcontrol);

	return 0;
}

static int nvidia_bl_get_brightness(struct backlight_device *bd)
{
	return bd->props.brightness;
}

static struct backlight_ops nvidia_bl_ops = {
	.get_brightness = nvidia_bl_get_brightness,
	.update_status	= nvidia_bl_update_status,
};

static struct fb_info *nvbacklight_attach(struct pci_dev *pd)
{
	struct nvbacklight_par *par;
	struct fb_info *info;
	struct backlight_device *bd;

        info = framebuffer_alloc(sizeof(struct nvbacklight_par),
				 &pd->dev);
        if (!info)
            goto framebuffer_alloc_failed;

        par = info->par;
	par->pci_dev = pd;
	par->info = info;

	par->REGS = ioremap(pci_resource_start(pd, 0),
                            pci_resource_len(pd, 0));

	if (!par->REGS) {
		printk(KERN_ERR "nvbacklight: cannot ioremap MMIO base\n");
		goto regs_map_failed;
	}

	par->PRAMIN = par->REGS + (0x00710000 / 4);
	par->PCRTC0 = par->REGS + (0x00600000 / 4);
	par->PRAMDAC0 = par->REGS + (0x00680000 / 4);
	par->PFB = par->REGS + (0x00100000 / 4);
	par->PFIFO = par->REGS + (0x00002000 / 4);
	par->PGRAPH = par->REGS + (0x00400000 / 4);
	par->PEXTDEV = par->REGS + (0x00101000 / 4);
	par->PTIMER = par->REGS + (0x00009000 / 4);
	par->PMC = par->REGS + (0x00000000 / 4);
	par->FIFO = par->REGS + (0x00800000 / 4);

	/* 8 bit registers */
	par->PCIO0 = (u8 __iomem *) par->REGS + 0x00601000;
	par->PDIO0 = (u8 __iomem *) par->REGS + 0x00681000;
	par->PVIO = (u8 __iomem *) par->REGS + 0x000C0000;

	/* see nv_setup.c:NVSelectHeadRegisters */
	par->PCIO = par->PCIO0;
	par->PCRTC = par->PCRTC0;
	par->PRAMDAC = par->PRAMDAC0;
	par->PDIO = par->PDIO0;

	par->fpSyncs = NV_RD32(par->PRAMDAC, 0x0848) & 0x30000033;

	bd = backlight_device_register("nvbacklight", &pd->dev, par,
				       &nvidia_bl_ops);
	if (IS_ERR(bd)) {
		printk(KERN_WARNING "nvbacklight: registration failed\n");
		goto bl_device_register_failed;
	}

	par->bd = bd;
	fb_bl_default_curve(info, 0,
			    0x158 * FB_BACKLIGHT_MAX / MAX_LEVEL,
			    0x534 * FB_BACKLIGHT_MAX / MAX_LEVEL);

	bd->props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
	bd->props.brightness = bd->props.max_brightness;
	bd->props.power = FB_BLANK_UNBLANK;
	backlight_update_status(bd);

	printk("nvbacklight: initialized\n");

	return info;

bl_device_register_failed:
	iounmap(par->REGS);
regs_map_failed:
	framebuffer_release (info);
framebuffer_alloc_failed:
	return NULL;
}

static void __devexit nvbacklight_detach(struct fb_info *info)
{
	struct nvbacklight_par *par = info->par;

	backlight_device_unregister(par->bd);
	iounmap(par->REGS);
	pci_dev_put(par->pci_dev);
	framebuffer_release(info);
	printk("nvbacklight: Backlight unloaded\n");
}

static struct fb_info *bl_fb_info;

static int __init nvbacklight_init(void)
{
	struct pci_dev *pd = NULL;

	pd = pci_get_device (PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, pd);
	if (pd)
		bl_fb_info = nvbacklight_attach(pd);

	return 0;
}

static void __exit
nvbacklight_exit(void)
{
	if (bl_fb_info) {
		nvbacklight_detach (bl_fb_info);
		bl_fb_info = NULL;
	}
}

module_init(nvbacklight_init);
module_exit(nvbacklight_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Andy Wingo");
MODULE_DESCRIPTION("Backlight control for nVidia graphics chipset");

--=-=-=--
