Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYLRW6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYLRW6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYLRW6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:58:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40750 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLRW6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:58:39 -0500
Date: Thu, 18 Dec 2008 23:58:34 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ
	drivers
Message-ID: <20081218225834.GJ20756@pengutronix.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange> <Pine.LNX.4.64.0812181414280.5510@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812181414280.5510@axis700.grange>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 18:21:07 up 4 days, 21:48, 26 users,  load average: 0.00, 0.02,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Thu, Dec 18, 2008 at 02:26:19PM +0100, Guennadi Liakhovetski wrote:
> From: Guennadi Liakhovetski <lg@denx.de>
> 
> i.MX3x SoCs contain an Image Processing Unit, consisting of a Control
> Module (CM), Display Interface (DI), Synchronous Display Controller (SDC),
> Asynchronous Display Controller (ADC), Image Converter (IC), Post-Filter
> (PF), Camera Sensor Interface (CSI), and an Image DMA Controller (IDMAC).
> CM contains, among other blocks, an Interrupt Generator (IG) and a Clock
> and Reset Control Unit (CRCU). This driver serves IDMAC and IG. They are
> supported over dmaengine and irq-chip APIs respectively.
> 
> IDMAC is a specialised DMA controller, its DMA channels cannot be used for
> general-purpose operations, even though it might be possible to configure
> a memory-to-memory channel for memcpy operation. This driver will not work
> with generic dmaengine clients, clients, wishing to use it must use
> respective wrapper structures, they also must specify which channels they
> require, as channels are hard-wired to specific IPU functions.

As a place for this driver /me votes for drivers/dma/ Though it does not
seem like a perfect place for it, it still uses the API provided there.

A general note: Can we get rid of the function names starting with an
underscore?

More comments inline

Regards,
  Sascha

> 
> Based on original driver from Freescale, Copyright preserved.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
> 

<snip>

> diff --git a/drivers/mfd/ipu/ipu_idmac.c b/drivers/mfd/ipu/ipu_idmac.c
> new file mode 100644
> index 0000000..85319f8
> --- /dev/null
> +++ b/drivers/mfd/ipu/ipu_idmac.c
> @@ -0,0 +1,1662 @@
> +/*
> + * Copyright (C) 2008
> + * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
> + *
> + * Copyright (C) 2005-2007 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/err.h>
> +#include <linux/spinlock.h>
> +#include <linux/delay.h>
> +#include <linux/list.h>
> +#include <linux/clk.h>
> +#include <linux/vmalloc.h>
> +#include <linux/string.h>
> +#include <linux/interrupt.h>
> +
> +#include <mach/ipu.h>
> +
> +#include <asm/io.h>

s/asm/linux

> +
> +#include "ipu_intern.h"
> +
> +#define FS_VF_IN_VALID	0x00000002
> +#define FS_ENC_IN_VALID	0x00000001
> +
> +/*
> + * There can be only one, we could allocate it dynamically, but then we'd have
> + * to add an extra parameter to some functions, and use something as ugly as
> + *	struct ipu *ipu = to_ipu(to_idmac(ichan->dma_chan.device));

still you use it in one place

> + * in the ISR
> + */
> +static struct ipu ipu_data;
> +
> +#define to_ipu(id) container_of(id, struct ipu, idmac)
> +
> +static u32 __idmac_read_icreg(struct ipu *ipu, unsigned long reg)
> +{
> +	return __raw_readl(ipu->reg_ic + reg);
> +}
> +
> +#define idmac_read_icreg(ipu, reg) __idmac_read_icreg(ipu, reg - IC_CONF)
> +
> +static void __idmac_write_icreg(struct ipu *ipu, u32 value, unsigned long reg)
> +{
> +	__raw_writel(value, ipu->reg_ic + reg);
> +}
> +
> +#define idmac_write_icreg(ipu, v, reg) __idmac_write_icreg(ipu, v, reg - IC_CONF)
> +
> +static u32 idmac_read_ipureg(struct ipu *ipu, unsigned long reg)
> +{
> +	return __raw_readl(ipu->reg_ipu + reg);
> +}
> +
> +static void idmac_write_ipureg(struct ipu *ipu, u32 value, unsigned long reg)
> +{
> +	__raw_writel(value, ipu->reg_ipu + reg);
> +}
> +
> +/*****************************************************************************
> + * IPU / IC common functions
> + */
> +static void dump_idmac_reg(struct ipu *ipu)
> +{
> +	dev_dbg(ipu->dev, "IDMAC_CONF 0x%x, IC_CONF 0x%x, IDMAC_CHA_EN 0x%x, "
> +		"IDMAC_CHA_PRI 0x%x, IDMAC_CHA_BUSY 0x%x\n",
> +		idmac_read_icreg(ipu, IDMAC_CONF),
> +		idmac_read_icreg(ipu, IC_CONF),
> +		idmac_read_icreg(ipu, IDMAC_CHA_EN),
> +		idmac_read_icreg(ipu, IDMAC_CHA_PRI),
> +		idmac_read_icreg(ipu, IDMAC_CHA_BUSY));
> +	dev_dbg(ipu->dev, "BUF0_RDY 0x%x, BUF1_RDY 0x%x, CUR_BUF 0x%x, "
> +		"DB_MODE 0x%x, TASKS_STAT 0x%x\n",
> +		idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY),
> +		idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY),
> +		idmac_read_ipureg(ipu, IPU_CHA_CUR_BUF),
> +		idmac_read_ipureg(ipu, IPU_CHA_DB_MODE_SEL),
> +		idmac_read_ipureg(ipu, IPU_TASKS_STAT));
> +}
> +
> +static uint32_t bytes_per_pixel(enum pixel_fmt fmt)
> +{
> +	switch (fmt) {
> +	case IPU_PIX_FMT_GENERIC:	/* generic data */
> +	case IPU_PIX_FMT_RGB332:
> +	case IPU_PIX_FMT_YUV420P:
> +	case IPU_PIX_FMT_YUV422P:
> +	default:
> +		return 1;
> +	case IPU_PIX_FMT_RGB565:
> +	case IPU_PIX_FMT_YUYV:
> +	case IPU_PIX_FMT_UYVY:
> +		return 2;
> +	case IPU_PIX_FMT_BGR24:
> +	case IPU_PIX_FMT_RGB24:
> +		return 3;
> +	case IPU_PIX_FMT_GENERIC_32:	/* generic data */
> +	case IPU_PIX_FMT_BGR32:
> +	case IPU_PIX_FMT_RGB32:
> +	case IPU_PIX_FMT_ABGR32:
> +		return 4;
> +	}
> +}
> +
> +/* Enable / disable direct write to memory by the Camera Sensor Interface */
> +static void _ipu_ic_enable_task(struct ipu *ipu, enum ipu_channel channel)
> +{
> +	uint32_t ic_conf, mask;
> +
> +	switch (channel) {
> +	case IDMAC_IC_0:
> +		mask = IC_CONF_PRPENC_EN;
> +		break;
> +	case IDMAC_IC_7:
> +		mask = IC_CONF_RWS_EN | IC_CONF_PRPENC_EN;
> +		break;
> +	default:
> +		return;
> +	}
> +	ic_conf = idmac_read_icreg(ipu, IC_CONF) | mask;
> +	idmac_write_icreg(ipu, ic_conf, IC_CONF);
> +}
> +
> +static void _ipu_ic_disable_task(struct ipu *ipu, enum ipu_channel channel)
> +{
> +	uint32_t ic_conf, mask;
> +
> +	switch (channel) {
> +	case IDMAC_IC_0:
> +		mask = IC_CONF_PRPENC_EN;
> +		break;
> +	case IDMAC_IC_7:
> +		mask = IC_CONF_RWS_EN | IC_CONF_PRPENC_EN;
> +		break;
> +	default:
> +		return;
> +	}
> +	ic_conf = idmac_read_icreg(ipu, IC_CONF) & ~mask;
> +	idmac_write_icreg(ipu, ic_conf, IC_CONF);
> +}
> +
> +static uint32_t _ipu_channel_status(struct ipu *ipu, enum ipu_channel channel)
> +{
> +	uint32_t stat = TASK_STAT_IDLE;
> +	uint32_t task_stat_reg = idmac_read_ipureg(ipu, IPU_TASKS_STAT);
> +
> +	switch (channel) {
> +	case IDMAC_IC_7:
> +		stat = (task_stat_reg & TSTAT_CSI2MEM_MASK) >>
> +			TSTAT_CSI2MEM_OFFSET;
> +		break;
> +	case IDMAC_IC_0:
> +	case IDMAC_SDC_0:
> +	case IDMAC_SDC_1:
> +	default:
> +		break;
> +	}
> +	return stat;
> +}
> +
> +static void _ipu_ch_param_set_size(uint32_t *params,
> +				   uint32_t pixel_fmt, uint16_t width,
> +				   uint16_t height, uint16_t stride)
> +{
> +	uint32_t u_offset = 0;
> +	uint32_t v_offset = 0;
> +
> +	params[3] = (uint32_t)((width - 1) << 12) |
> +		((uint32_t)(height - 1) << 24);
> +	params[4] = (uint32_t)(height - 1) >> 8;
> +	params[7] = (uint32_t)(stride - 1) << 3;
> +
> +	switch (pixel_fmt) {
> +	case IPU_PIX_FMT_GENERIC:
> +		/*Represents 8-bit Generic data */
> +		params[7] |= 3 | (7UL << (81 - 64)) | (31L << (89 - 64));	/* BPP & PFS */
> +		params[8] = 2;				/* SAT = use 32-bit access */
> +		break;
> +	case IPU_PIX_FMT_GENERIC_32:
> +		/*Represents 32-bit Generic data */
> +		params[7] |= (7UL << (81 - 64)) | (7L << (89 - 64));		/* BPP & PFS */
> +		params[8] = 2;				/* SAT = use 32-bit access */
> +		break;
> +	case IPU_PIX_FMT_RGB565:
> +		params[7] |= 2L | (4UL << (81 - 64)) | (7L << (89 - 64));	/* BPP & PFS */
> +		params[8] = 2 |				/* SAT = 32-bit access */
> +		    (0UL << (99 - 96)) |		/* Red bit offset */
> +		    (5UL << (104 - 96)) |		/* Green bit offset */
> +		    (11UL << (109 - 96)) |		/* Blue bit offset */
> +		    (16UL << (114 - 96)) |		/* Alpha bit offset */
> +		    (4UL << (119 - 96)) |		/* Red bit width - 1 */
> +		    (5UL << (122 - 96)) |		/* Green bit width - 1 */
> +		    (4UL << (125 - 96));		/* Blue bit width - 1 */
> +		break;
> +	case IPU_PIX_FMT_BGR24:
> +		params[7] |= 1 | (4UL << (81 - 64)) | (7L << (89 - 64));	/* 24 BPP & RGB PFS */
> +		params[8] = 2 |				/* SAT = 32-bit access */
> +		    (8UL << (104 - 96)) |		/* Green bit offset */
> +		    (16UL << (109 - 96)) |		/* Blue bit offset */
> +		    (24UL << (114 - 96)) |		/* Alpha bit offset */
> +		    (7UL << (119 - 96)) |		/* Red bit width - 1 */
> +		    (7UL << (122 - 96)) |		/* Green bit width - 1 */
> +		    (uint32_t) (7UL << (125 - 96));	/* Blue bit width - 1 */
> +		break;
> +	case IPU_PIX_FMT_RGB24:
> +		params[7] |= 1 | (4UL << (81 - 64)) | (7L << (89 - 64));	/* 24 BPP & RGB PFS */
> +		params[8] = 2 |				/* SAT = 32-bit access */
> +		    (16UL << (99 - 96)) |		/* Red bit offset */
> +		    (8UL << (104 - 96)) |		/* Green bit offset */
> +		    (0UL << (109 - 96)) |		/* Blue bit offset */
> +		    (24UL << (114 - 96)) |		/* Alpha bit offset */
> +		    (7UL << (119 - 96)) |		/* Red bit width - 1 */
> +		    (7UL << (122 - 96)) |		/* Green bit width - 1 */
> +		    (uint32_t) (7UL << (125 - 96));	/* Blue bit width - 1 */
> +		break;
> +	case IPU_PIX_FMT_BGRA32:
> +	case IPU_PIX_FMT_BGR32:
> +		params[7] |= 0 | (4UL << (81 - 64)) | (7 << (89 - 64));		/* BPP & PFS */
> +		params[8] = 2 |				/* SAT = 32-bit access */
> +		    (8UL << (99 - 96)) |		/* Red bit offset */
> +		    (16UL << (104 - 96)) |		/* Green bit offset */
> +		    (24UL << (109 - 96)) |		/* Blue bit offset */
> +		    (0UL << (114 - 96)) |		/* Alpha bit offset */
> +		    (7UL << (119 - 96)) |		/* Red bit width - 1 */
> +		    (7UL << (122 - 96)) |		/* Green bit width - 1 */
> +		    (uint32_t) (7UL << (125 - 96));	/* Blue bit width - 1 */
> +		params[9] = 7;				/* Alpha bit width - 1 */
> +		break;
> +	case IPU_PIX_FMT_RGBA32:
> +	case IPU_PIX_FMT_RGB32:
> +		params[7] |= 0 | (4UL << (81 - 64)) | (7 << (89 - 64));
> +		params[8] = 2 |				/* SAT = 32-bit access */
> +		    (24UL << (99 - 96)) |		/* Red bit offset */
> +		    (16UL << (104 - 96)) |		/* Green bit offset     */
> +		    (8UL << (109 - 96)) |		/* Blue bit offset */
> +		    (0UL << (114 - 96)) |		/* Alpha bit offset     */
> +		    (7UL << (119 - 96)) |		/* Red bit width - 1 */
> +		    (7UL << (122 - 96)) |		/* Green bit width - 1 */
> +		    (uint32_t) (7UL << (125 - 96));	/* Blue bit width - 1 */
> +		params[9] = 7;				/* Alpha bit width - 1 */
> +		break;
> +	case IPU_PIX_FMT_ABGR32:
> +		params[7] |= 0 | (4UL << (81 - 64)) | (7 << (89 - 64));
> +		params[8] = 2 |				/* SAT = 32-bit access */
> +		    (0UL << (99 - 96)) |		/* Alpha bit offset */
> +		    (8UL << (104 - 96)) |		/* Blue bit offset */
> +		    (16UL << (109 - 96)) |		/* Green bit offset */
> +		    (24UL << (114 - 96)) |		/* Red bit offset */
> +		    (7UL << (119 - 96)) |		/* Alpha bit width - 1 */
> +		    (7UL << (122 - 96)) |		/* Blue bit width - 1 */
> +		    (uint32_t) (7UL << (125 - 96));	/* Green bit width - 1 */
> +		params[9] = 7;				/* Red bit width - 1 */
> +		break;
> +	case IPU_PIX_FMT_UYVY:
> +		params[7] |= 2 | (6UL << 17) | (7 << (89 - 64));
> +		params[8] = 2;				/* SAT = 32-bit access */
> +		break;
> +	case IPU_PIX_FMT_YUV420P2:
> +	case IPU_PIX_FMT_YUV420P:
> +		params[7] |= 3 | (3UL << 17) | (7 << (89 - 64));
> +		params[8] = 2;				/* SAT = 32-bit access */
> +		u_offset = stride * height;
> +		v_offset = u_offset + u_offset / 4;
> +		break;
> +	case IPU_PIX_FMT_YVU422P:
> +		params[7] |= 3 | (2UL << 17) | (7 << (89 - 64));
> +		params[8] = 2;				/* SAT = 32-bit access */
> +		v_offset = stride * height;
> +		u_offset = v_offset + v_offset / 2;
> +		break;
> +	case IPU_PIX_FMT_YUV422P:
> +		params[7] |= 3 | (2UL << 17) | (7 << (89 - 64));
> +		params[8] = 2;				/* SAT = 32-bit access */
> +		u_offset = stride * height;
> +		v_offset = u_offset + u_offset / 2;
> +		break;
> +	default:
> +		dev_err(ipu_data.dev, "mxc ipu: unimplemented pixel format\n");
> +		break;
> +	}
> +
> +	params[1] = (1UL << (46 - 32)) | (u_offset << (53 - 32));
> +	params[2] = u_offset >> (64 - 53);
> +	params[2] |= v_offset << (79 - 64);
> +	params[3] |= v_offset >> (96 - 79);
> +}

This is so unreadable. Why not use a struct type for the params, like
this:

struct ipu_params {
	u32	xv:10;
	u32	yv:10;
	u32	xb:12;
	u32	yb:12;
	u32	res:2;
	u32	nsb:1;
	u32	lnpb:6;
	[...]
} __attribute__ ((__packed__));



> +
> +static void _ipu_ch_param_set_burst_size(uint32_t *params,
> +					 uint16_t burst_pixels)
> +{
> +	params[7] &= ~(0x3FL << (89 - 64));
> +	params[7] |= (uint32_t)(burst_pixels - 1) << (89 - 64);
> +};
> +
> +static void _ipu_ch_param_set_buffer(uint32_t *params,
> +				     dma_addr_t buf0, dma_addr_t buf1)
> +{
> +	params[5] = buf0;
> +	params[6] = buf1;
> +};
> +
> +static void _ipu_ch_param_set_rotation(uint32_t *params,
> +				       enum ipu_rotate_mode rot)
> +{
> +	params[7] |= (uint32_t)rot << (84 - 64);
> +};
> +
> +static void _ipu_write_param_mem(uint32_t addr, uint32_t *data,
> +				 uint32_t numWords)
> +{
> +	for (; numWords > 0; numWords--) {

num_words

> +		dev_dbg(ipu_data.dev,
> +			"write param mem - addr = 0x%08X, data = 0x%08X\n",
> +			addr, *data);
> +		idmac_write_ipureg(&ipu_data, addr, IPU_IMA_ADDR);
> +		idmac_write_ipureg(&ipu_data, *data++, IPU_IMA_DATA);
> +		addr++;
> +		if ((addr & 0x7) == 5) {
> +			addr &= ~0x7;	/* set to word 0 */
> +			addr += 8;	/* increment to next row */
> +		}
> +	}
> +}
> +
> +static bool _calc_resize_coeffs(uint32_t in_size, uint32_t out_size,
> +				uint32_t *resize_coeff,
> +				uint32_t *downsize_coeff)
> +{
> +	uint32_t temp_size;
> +	uint32_t temp_downsize;
> +
> +	/* Cannot downsize more than 8:1 */
> +	if ((out_size << 3) < in_size)
> +		return false;

We normally use 0 for success, but the return value isn't checked
anyway...

> +
> +	/* compute downsizing coefficient */
> +	temp_downsize = 0;
> +	temp_size = in_size;
> +	while ((temp_size >= out_size * 2) && (temp_downsize < 2)) {
> +		temp_size >>= 1;
> +		temp_downsize++;
> +	}
> +	*downsize_coeff = temp_downsize;
> +
> +	/*
> +	 * compute resizing coefficient using the following formula:
> +	 * resize_coeff = M*(SI -1)/(SO - 1)
> +	 * where M = 2^13, SI - input size, SO - output size
> +	 */
> +	*resize_coeff = (8192L * (temp_size - 1)) / (out_size - 1);
> +	if (*resize_coeff >= 16384L) {
> +		dev_err(ipu_data.dev, "Warning! Overflow on resize coeff.\n");
> +		*resize_coeff = 0x3FFF;
> +	}
> +
> +	dev_dbg(ipu_data.dev, "resizing from %u -> %u pixels, "
> +		"downsize=%u, resize=%u.%lu (reg=%u)\n", in_size, out_size,
> +		*downsize_coeff, *resize_coeff >= 8192L ? 1 : 0,
> +		((*resize_coeff & 0x1FFF) * 10000L) / 8192L, *resize_coeff);
> +
> +	return true;
> +}
> +
> +static enum ipu_color_space format_to_colorspace(enum pixel_fmt fmt)
> +{
> +	switch (fmt) {
> +	case IPU_PIX_FMT_RGB565:
> +	case IPU_PIX_FMT_BGR24:
> +	case IPU_PIX_FMT_RGB24:
> +	case IPU_PIX_FMT_BGR32:
> +	case IPU_PIX_FMT_RGB32:
> +		return IPU_COLORSPACE_RGB;
> +	default:
> +		return IPU_COLORSPACE_YCBCR;
> +	}
> +}
> +
> +static int _ipu_ic_init_prpenc(struct ipu *ipu,
> +			       union ipu_channel_param *params, bool src_is_csi)
> +{
> +	uint32_t reg, ic_conf;
> +	uint32_t downsize_coeff, resize_coeff;
> +	enum ipu_color_space in_fmt, out_fmt;
> +
> +	/* Setup vertical resizing */
> +	_calc_resize_coeffs(params->video.in_height,
> +			    params->video.out_height,
> +			    &resize_coeff, &downsize_coeff);
> +	reg = (downsize_coeff << 30) | (resize_coeff << 16);
> +
> +	/* Setup horizontal resizing */
> +	_calc_resize_coeffs(params->video.in_width,
> +			    params->video.out_width,
> +			    &resize_coeff, &downsize_coeff);
> +	reg |= (downsize_coeff << 14) | resize_coeff;
> +
> +	/* Setup color space conversion */
> +	in_fmt = format_to_colorspace(params->video.in_pixel_fmt);
> +	out_fmt = format_to_colorspace(params->video.out_pixel_fmt);
> +
> +	/*
> +	 * Colourspace conversion unsupported yet - see _init_csc() in
> +	 * Freescale sources
> +	 */
> +	if (in_fmt != out_fmt) {
> +		dev_err(ipu->dev, "Colourspace conversion unsupported!\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	idmac_write_icreg(ipu, reg, IC_PRP_ENC_RSC);
> +
> +	ic_conf = idmac_read_icreg(ipu, IC_CONF);
> +
> +	if (src_is_csi)
> +		ic_conf &= ~IC_CONF_RWS_EN;
> +	else
> +		ic_conf |= IC_CONF_RWS_EN;
> +
> +	idmac_write_icreg(ipu, ic_conf, IC_CONF);
> +
> +	return 0;
> +}
> +
> +static uint32_t dma_param_addr(uint32_t dma_ch)
> +{
> +	/* Channel Parameter Memory */
> +	return 0x10000 | (dma_ch << 4);
> +};
> +
> +static void _ipu_channel_set_priority(struct ipu *ipu, enum ipu_channel channel, bool prio)
> +{
> +	u32 reg = idmac_read_icreg(ipu, IDMAC_CHA_PRI);
> +
> +	if (prio)
> +		reg |= 1UL << channel;
> +	else
> +		reg &= ~(1UL << channel);
> +
> +	idmac_write_icreg(ipu, reg, IDMAC_CHA_PRI);
> +
> +	dump_idmac_reg(ipu);
> +}
> +
> +static uint32_t _ipu_channel_conf_check(struct ipu *ipu, enum ipu_channel channel)
> +{
> +	uint32_t ipu_conf;
> +
> +	ipu_conf = idmac_read_ipureg(ipu, IPU_CONF);
> +	if (WARN(!ipu_conf, "Uninitialized IPU_CONF!\n"))
> +		/* Should not happen. Error out here. */
> +		clk_enable(ipu->ipu_clk);

Erroring out by enabling the clock? This looks strange.

> +
> +	if (ipu->channel_init_mask & (1L << channel))
> +		dev_err(ipu->dev, "Warning: channel already initialized %d\n",
> +			channel);
> +
> +	return ipu_conf;
> +}

This function is called only once and it basically reads a register and prints
warnings if something is wrong. No need to make it an extra function.

> +
> +static uint32_t _ipu_channel_conf_mask(enum ipu_channel channel)
> +{
> +	uint32_t mask;
> +
> +	switch (channel) {
> +	case IDMAC_IC_0:
> +		mask = IPU_CONF_CSI_EN | IPU_CONF_IC_EN;
> +		break;
> +	case IDMAC_IC_7:
> +		mask = IPU_CONF_CSI_EN | IPU_CONF_IC_EN;
> +		break;

These two cases can be joined.

> +	case IDMAC_SDC_0:
> +		mask = IPU_CONF_SDC_EN | IPU_CONF_DI_EN;
> +		break;
> +	case IDMAC_SDC_1:
> +		mask = IPU_CONF_SDC_EN | IPU_CONF_DI_EN;
> +		break;

dito

> +	default:
> +		mask = 0;
> +		break;
> +	}
> +
> +	return mask;
> +}
> +
> +/**
> + * Enable an IPU channel.
> + *
> + * @param       channel         Input parameter for the logical channel ID.
> + *
> + * @return      Returns 0 on success or negative error code on failure.
> + */
> +static int ipu_enable_channel(struct idmac *idmac, struct idmac_channel *ichan)
> +{
> +	struct ipu *ipu = to_ipu(idmac);
> +	enum ipu_channel channel = ichan->dma_chan.chan_id;
> +	uint32_t reg;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ipu->lock, flags);
> +
> +	/* Reset to buffer 0 */
> +	idmac_write_ipureg(ipu, 1UL << channel, IPU_CHA_CUR_BUF);
> +	ichan->active_buffer = 0;
> +	ichan->status = IPU_CHANNEL_ENABLED;
> +
> +	switch (channel) {
> +	case IDMAC_SDC_0:
> +	case IDMAC_SDC_1:
> +	case IDMAC_IC_7:
> +		_ipu_channel_set_priority(ipu, channel, true);
> +	default:
> +		break;
> +	}
> +
> +	reg = idmac_read_icreg(ipu, IDMAC_CHA_EN);
> +
> +	idmac_write_icreg(ipu, reg | (1UL << channel), IDMAC_CHA_EN);
> +
> +	_ipu_ic_enable_task(ipu, channel);
> +
> +	spin_unlock_irqrestore(&ipu->lock, flags);
> +	return 0;
> +}
> +
> +/**
> + * Initialize a buffer for logical IPU channel.
> + *
> + * @param       channel         Input parameter for the logical channel ID.
> + *
> + * @param       pixel_fmt       Input parameter for pixel format of buffer. Pixel
> + *                              format is a FOURCC ASCII code.
> + *
> + * @param       width           Input parameter for width of buffer in pixels.
> + *
> + * @param       height          Input parameter for height of buffer in pixels.
> + *
> + * @param       stride          Input parameter for stride length of buffer
> + *                              in pixels.
> + *
> + * @param       rot_mode        Input parameter for rotation setting of buffer.
> + *                              A rotation setting other than \b IPU_ROTATE_VERT_FLIP
> + *                              should only be used for input buffers of rotation
> + *                              channels.
> + *
> + * @param       phyaddr_0       Input parameter buffer 0 physical address.
> + *
> + * @param       phyaddr_1       Input parameter buffer 1 physical address.
> + *                              Setting this to a value other than NULL enables
> + *                              double buffering mode.
> + *
> + * @return      Returns 0 on success or negative error code on failure.
> + */
> +static int ipu_init_channel_buffer(struct idmac_channel *ichan,
> +				   enum pixel_fmt pixel_fmt,
> +				   uint16_t width, uint16_t height,
> +				   uint32_t stride,
> +				   enum ipu_rotate_mode rot_mode,
> +				   dma_addr_t phyaddr_0, dma_addr_t phyaddr_1)
> +{
> +	enum ipu_channel channel = ichan->dma_chan.chan_id;
> +	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
> +	struct ipu *ipu = to_ipu(idmac);
> +	uint32_t params[10] = {0};
> +	unsigned long flags;
> +	uint32_t reg;
> +	uint32_t stride_bytes;
> +
> +	stride_bytes = stride * bytes_per_pixel(pixel_fmt);
> +
> +	if (stride_bytes % 4) {
> +		dev_err(ipu->dev,
> +			"Stride length must be 32-bit aligned, stride = %d, bytes = %d\n",
> +			stride, stride_bytes);
> +		return -EINVAL;
> +	}
> +	/* IC channel's stride must be a multiple of 8 pixels */
> +	if ((channel <= 13) && (stride % 8)) {
> +		dev_err(ipu->dev, "Stride must be 8 pixel multiple\n");
> +		return -EINVAL;
> +	}
> +	/* Build parameter memory data for DMA channel */
> +	_ipu_ch_param_set_size(params, pixel_fmt, width, height, stride_bytes);
> +	_ipu_ch_param_set_buffer(params, phyaddr_0, phyaddr_1);
> +	_ipu_ch_param_set_rotation(params, rot_mode);
> +	/* Some channels (rotation) have restriction on burst length */
> +	switch (channel) {
> +	case IDMAC_IC_7:	/* Hangs with burst 8, 16, other values
> +				   invalid - Table 44-30 */
> +/*
> +		_ipu_ch_param_set_burst_size(params, 8);
> + */
> +		break;
> +	case IDMAC_SDC_0:
> +	case IDMAC_SDC_1:
> +		/* In original code only IPU_PIX_FMT_RGB565 was setting burst */
> +		_ipu_ch_param_set_burst_size(params, 16);
> +		break;
> +	case IDMAC_IC_0:
> +	default:
> +		break;
> +	}
> +
> +	/* In fact, channel is not running yet, so, don't have to protect */
> +	spin_lock_irqsave(&ipu->lock, flags);

Please remove either the locking or the comment, but this doesn't help
anyone.

> +
> +	_ipu_write_param_mem(dma_param_addr(channel), params, 10);
> +
> +	reg = idmac_read_ipureg(ipu, IPU_CHA_DB_MODE_SEL);
> +
> +	if (phyaddr_1)
> +		reg |= 1UL << channel;
> +	else
> +		reg &= ~(1UL << channel);
> +
> +	idmac_write_ipureg(ipu, reg, IPU_CHA_DB_MODE_SEL);
> +
> +	ichan->status = IPU_CHANNEL_READY;
> +
> +	spin_unlock_irqrestore(ipu->lock, flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * Set a channel's buffer as ready.
> + *
> + * @param       channel         Input parameter for the logical channel ID.
> + *
> + * @param       type            Input parameter which buffer to initialize.
> + *
> + * @param       bufNum          Input parameter for which buffer number set to

buffer_n

> + *                              ready state.
> + *
> + * @return      Returns 0 on success or negative error code on failure.
> + */
> +static void ipu_select_buffer(enum ipu_channel channel, int buffer_n)
> +{
> +	/* No locking - this is a write-one-to-set register, cleared by IPU */

It's a write-only operation, not a read-modify-write operation, so no
locking is required anyway.

> +	if (buffer_n == 0)
> +		/* Mark buffer 0 as ready. */
> +		idmac_write_ipureg(&ipu_data, 1UL << channel, IPU_CHA_BUF0_RDY);
> +	else
> +		/* Mark buffer 1 as ready. */
> +		idmac_write_ipureg(&ipu_data, 1UL << channel, IPU_CHA_BUF1_RDY);
> +}
> +
> +/**
> + * Update the physical address of a buffer for a logical IPU channel.
> + *
> + * @param       channel         Input parameter for the logical channel ID.
> + *
> + * @param       type            Input parameter which buffer to initialize.
> + *
> + * @param       bufNum          Input parameter for which buffer number to update.
> + *                              0 or 1 are the only valid values.

buffer_n

> + *
> + * @param       phyaddr         Input parameter buffer physical address.
> + *
> + * @return      Returns 0 on success or negative error code on failure. This
> + *              function will fail if the buffer is set to ready.
> + */
> +/* Called under spin_lock(_irqsave)(&ichan->lock) */
> +static int ipu_update_channel_buffer(enum ipu_channel channel,
> +				     int buffer_n, dma_addr_t phyaddr)
> +{
> +	uint32_t reg;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ipu_data.lock, flags);
> +
> +	if (buffer_n == 0) {
> +		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY);
> +		if (reg & (1UL << channel)) {
> +			spin_unlock_irqrestore(&ipu_data.lock, flags);
> +			return -EACCES;
> +		}
> +
> +		/* 44.3.3.1.9 - Row Number 1 (WORD1, offset 0) */
> +		idmac_write_ipureg(&ipu_data, dma_param_addr(channel) +
> +				   0x0008UL, IPU_IMA_ADDR);
> +		idmac_write_ipureg(&ipu_data, phyaddr, IPU_IMA_DATA);
> +	} else {
> +		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY);
> +		if (reg & (1UL << channel)) {
> +			spin_unlock_irqrestore(&ipu_data.lock, flags);
> +			return -EACCES;
> +		}
> +
> +		/* Check if double-buffering is already enabled */
> +		reg = idmac_read_ipureg(&ipu_data, IPU_CHA_DB_MODE_SEL);
> +
> +		if (!(reg & (1UL << channel)))
> +			idmac_write_ipureg(&ipu_data, reg | (1UL << channel),
> +					   IPU_CHA_DB_MODE_SEL);
> +
> +		/* 44.3.3.1.9 - Row Number 1 (WORD1, offset 1) */
> +		idmac_write_ipureg(&ipu_data, dma_param_addr(channel) +
> +				   0x0009UL, IPU_IMA_ADDR);
> +		idmac_write_ipureg(&ipu_data, phyaddr, IPU_IMA_DATA);
> +	}
> +
> +	spin_unlock_irqrestore(&ipu_data.lock, flags);
> +
> +	return 0;
> +}
> +
> +/* Called under spin_lock_irqsave(&ichan->lock) */
> +static int ipu_submit_channel_buffers(struct idmac_channel *ichan,
> +				      struct idmac_tx_desc *desc)
> +{
> +	struct scatterlist *sg;
> +	int i, ret;
> +
> +	for (i = 0, sg = desc->sg; i < 2 && sg; i++) {
> +		if (!ichan->sg[i]) {
> +			ichan->sg[i] = sg;
> +
> +			/*
> +			 * On first invocation this shouldn't be necessary, the
> +			 * call to ipu_init_channel_buffer() above will set
> +			 * addresses for us, so we could make it conditional
> +			 * on status >= IPU_CHANNEL_ENABLED, but doing it again
> +			 * shouldn't hurt either.
> +			 */
> +			ret = ipu_update_channel_buffer(ichan->dma_chan.chan_id, i,
> +							sg_dma_address(sg));
> +			if (ret < 0)
> +				return ret;
> +
> +			ipu_select_buffer(ichan->dma_chan.chan_id, i);
> +
> +			sg = sg_next(sg);
> +		}
> +	}
> +
> +	return ret;
> +}

I wonder why the compiler does not warn about ret being used unitialized
here.
The return value of this function should be checked.

> +
> +static dma_cookie_t idmac_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +	struct idmac_tx_desc *desc = to_tx_desc(tx);
> +	struct idmac_channel *ichan = to_idmac_chan(tx->chan);
> +	struct idmac *idmac = to_idmac(tx->chan->device);
> +	struct ipu *ipu = to_ipu(idmac);
> +	dma_cookie_t cookie;
> +	unsigned long flags;
> +
> +	/* Sanity check */
> +	if (!list_empty(&desc->list)) {
> +		/* The descriptor doesn't belong to client */
> +		dev_err(&ichan->dma_chan.dev->device,
> +			"Descriptor %p not prepared!\n", tx);
> +		return -EBUSY;
> +	}
> +
> +	mutex_lock(&ichan->chan_mutex);
> +
> +	if (ichan->status < IPU_CHANNEL_READY) {
> +		struct idmac_video_param *video = &ichan->params.video;
> +		/*
> +		 * Initial buffer assignment - the first two sg-entries from
> +		 * the descriptor will end up in the IDMAC buffers
> +		 */
> +		dma_addr_t dma_1 = sg_is_last(desc->sg) ? 0 :
> +			sg_dma_address(&desc->sg[1]);
> +
> +		WARN_ON(ichan->sg[0] || ichan->sg[1]);
> +
> +		cookie = ipu_init_channel_buffer(ichan,
> +						 video->out_pixel_fmt,
> +						 video->out_width,
> +						 video->out_height,
> +						 video->out_stride,
> +						 IPU_ROTATE_NONE,
> +						 sg_dma_address(&desc->sg[0]),
> +						 dma_1);
> +		if (cookie < 0)
> +			goto out;
> +	}
> +
> +	/* ipu->lock can be taken under ichan->lock, but not v.v. */
> +	spin_lock_irqsave(&ichan->lock, flags);
> +
> +	/* submit_buffers() atomically verifies and fills empty sg slots */
> +	ipu_submit_channel_buffers(ichan, desc);
> +
> +	spin_unlock_irqrestore(&ichan->lock, flags);
> +
> +	cookie = ichan->dma_chan.cookie;
> +
> +	if (++cookie < 0)
> +		cookie = 1;
> +
> +	/* from dmaengine.h: "last cookie value returned to client" */
> +	ichan->dma_chan.cookie = cookie;
> +	tx->cookie = cookie;
> +	spin_lock_irqsave(&ichan->lock, flags);
> +	list_add_tail(&desc->list, &ichan->queue);
> +	spin_unlock_irqrestore(&ichan->lock, flags);
> +
> +	if (ichan->status < IPU_CHANNEL_ENABLED) {
> +		int ret = ipu_enable_channel(idmac, ichan);
> +		if (ret < 0) {
> +			cookie = ret;
> +			spin_lock_irqsave(&ichan->lock, flags);
> +			list_del_init(&desc->list);
> +			spin_unlock_irqrestore(&ichan->lock, flags);
> +			tx->cookie = cookie;
> +			ichan->dma_chan.cookie = cookie;
> +		}
> +	}
> +
> +	dump_idmac_reg(ipu);
> +
> +out:
> +	mutex_unlock(&ichan->chan_mutex);
> +
> +	return cookie;
> +}
> +
> +/* Called with ichan->chan_mutex held */
> +static int idmac_desc_alloc(struct idmac_channel *ichan, int n)
> +{
> +	struct idmac_tx_desc *desc = vmalloc(n * sizeof(struct idmac_tx_desc));
> +	struct idmac *idmac = to_idmac(ichan->dma_chan.device);
> +
> +	if (!desc)
> +		return -ENOMEM;
> +
> +	/* No interrupts, just disable the tasklet for a moment */
> +	tasklet_disable(&to_ipu(idmac)->tasklet);
> +
> +	ichan->n_tx_desc = n;
> +	ichan->desc = desc;
> +	INIT_LIST_HEAD(&ichan->queue);
> +	INIT_LIST_HEAD(&ichan->free_list);
> +
> +	while (n--) {
> +		struct dma_async_tx_descriptor *txd = &desc->txd;
> +
> +		memset(txd, 0, sizeof(*txd));
> +		dma_async_tx_descriptor_init(txd, &ichan->dma_chan);
> +		txd->tx_submit		= idmac_tx_submit;
> +		txd->chan		= &ichan->dma_chan;
> +		INIT_LIST_HEAD(&txd->tx_list);
> +
> +		list_add(&desc->list, &ichan->free_list);
> +
> +		desc++;
> +	}
> +
> +	tasklet_enable(&to_ipu(idmac)->tasklet);
> +
> +	return 0;
> +}
> +
> +/**
> + * This function is called to initialize a logical IPU channel.
> + *
> + * @param       channel Input parameter for the logical channel ID to initalize.
> + *
> + * @param       params  Input parameter containing union of channel initialization
> + *                      parameters.
> + *
> + * @return      This function returns 0 on success or negative error code on fail
> + */
> +static int ipu_init_channel(struct idmac *idmac, struct idmac_channel *ichan)
> +{
> +	union ipu_channel_param *params = &ichan->params;
> +	uint32_t ipu_conf;
> +	enum ipu_channel channel = ichan->dma_chan.chan_id;
> +	unsigned long flags;
> +	uint32_t reg;
> +	struct ipu *ipu = to_ipu(idmac);
> +	int ret = 0, n_desc = 0;
> +
> +	dev_dbg(ipu->dev, "init channel = %d\n", channel);
> +
> +	if (channel != IDMAC_SDC_0 && channel != IDMAC_SDC_1 &&
> +	    channel != IDMAC_IC_7)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&ipu->lock, flags);
> +
> +	ipu_conf = _ipu_channel_conf_check(ipu, channel);
> +
> +	switch (channel) {
> +	case IDMAC_IC_7:
> +		n_desc = 16;
> +		reg = idmac_read_icreg(ipu, IC_CONF);
> +		idmac_write_icreg(ipu, reg & ~IC_CONF_CSI_MEM_WR_EN, IC_CONF);
> +		break;
> +	case IDMAC_IC_0:
> +		n_desc = 16;
> +		reg = idmac_read_ipureg(ipu, IPU_FS_PROC_FLOW);
> +		idmac_write_ipureg(ipu, reg & ~FS_ENC_IN_VALID, IPU_FS_PROC_FLOW);
> +		ret = _ipu_ic_init_prpenc(ipu, params, true);
> +		break;
> +	case IDMAC_SDC_0:
> +	case IDMAC_SDC_1:
> +		n_desc = 4;
> +	default:
> +		break;
> +	}
> +
> +	ipu->channel_init_mask |= 1L << channel;
> +
> +	/* Enable IPU sub module */
> +	ipu_conf |= _ipu_channel_conf_mask(channel);
> +	idmac_write_ipureg(ipu, ipu_conf, IPU_CONF);
> +
> +	spin_unlock_irqrestore(&ipu->lock, flags);
> +
> +	if (n_desc && !ichan->desc)
> +		ret = idmac_desc_alloc(ichan, n_desc);
> +
> +	dump_idmac_reg(ipu);
> +
> +	return ret;
> +}
> +
> +/**
> + * This function is called to uninitialize a logical IPU channel.
> + *
> + * @param       channel Input parameter for the logical channel ID to uninitalize.
> + */
> +static void ipu_uninit_channel(struct idmac *idmac, struct idmac_channel *ichan)
> +{
> +	enum ipu_channel channel = ichan->dma_chan.chan_id;
> +	unsigned long flags;
> +	uint32_t reg;
> +	uint32_t mask = 0;
> +	uint32_t ipu_conf;
> +	struct ipu *ipu = to_ipu(idmac);
> +
> +	spin_lock_irqsave(&ipu->lock, flags);
> +
> +	if (!(ipu->channel_init_mask & (1L << channel))) {
> +		dev_err(ipu->dev, "Channel already uninitialized %d\n",
> +			channel);
> +		spin_unlock_irqrestore(&ipu->lock, flags);
> +		return;
> +	}
> +
> +	/* Make sure channel is disabled */
> +	if (mask & idmac_read_icreg(ipu, IDMAC_CHA_EN)) {
> +		dev_err(ipu->dev,
> +			"Channel %d is not disabled, disable first\n", channel);
> +		spin_unlock_irqrestore(&ipu->lock, flags);
> +		return;
> +	}

The channel *is* disabled since this function is called from
idmac_free_chan_resources() which calls __idmac_terminate_all()
beforehand which in turn calls ipu_disable_channel().

> +
> +	/* Reset the double buffer */
> +	reg = idmac_read_ipureg(ipu, IPU_CHA_DB_MODE_SEL);
> +	idmac_write_ipureg(ipu, reg & ~mask, IPU_CHA_DB_MODE_SEL);
> +
> +	ichan->sec_chan_en = false;
> +
> +	switch (channel) {
> +	case IDMAC_IC_7:
> +		reg = idmac_read_icreg(ipu, IC_CONF);
> +		idmac_write_icreg(ipu, reg & ~(IC_CONF_RWS_EN | IC_CONF_PRPENC_EN),
> +			     IC_CONF);
> +		break;
> +	case IDMAC_IC_0:
> +		reg = idmac_read_icreg(ipu, IC_CONF);
> +		idmac_write_icreg(ipu, reg & ~(IC_CONF_PRPENC_EN | IC_CONF_PRPENC_CSC1),
> +				  IC_CONF);
> +		break;
> +	case IDMAC_SDC_0:
> +	case IDMAC_SDC_1:
> +	default:
> +		break;
> +	}
> +
> +	ipu->channel_init_mask &= ~(1L << channel);
> +
> +	ipu_conf = idmac_read_ipureg(ipu, IPU_CONF);
> +	ipu_conf &= ~_ipu_channel_conf_mask(channel);
> +	idmac_write_ipureg(ipu, ipu_conf, IPU_CONF);
> +	if (!ipu_conf)
> +		clk_disable(ipu->ipu_clk);
> +
> +	spin_unlock_irqrestore(&ipu->lock, flags);
> +
> +	ichan->n_tx_desc = 0;
> +	vfree(ichan->desc);
> +	ichan->desc = NULL;
> +}
> +
> +/**
> + * This function disables a logical channel.
> + *
> + * @param       channel         Input parameter for the logical channel ID.
> + *
> + * @param       wait_for_stop   Flag to set whether to wait for channel end
> + *                              of frame or return immediately.
> + *
> + * @return      This function returns 0 on success or negative error code on
> + *              fail.
> + */
> +static int ipu_disable_channel(struct idmac *idmac, enum ipu_channel channel,
> +			       bool wait_for_stop)
> +{
> +	struct ipu *ipu = to_ipu(idmac);
> +	uint32_t reg;
> +	unsigned long flags;
> +	uint32_t chan_mask = 1UL << channel;
> +	uint32_t timeout;
> +	uint32_t eof_intr;
> +
> +	if (wait_for_stop && channel != IDMAC_SDC_1 && channel != IDMAC_SDC_0) {
> +		timeout = 40;
> +		/* This waiting always fails. Related to spurious irq problem */
> +		while ((idmac_read_icreg(ipu, IDMAC_CHA_BUSY) & chan_mask) ||
> +		       (_ipu_channel_status(ipu, channel) == TASK_STAT_ACTIVE)) {
> +			timeout--;
> +			msleep(10);
> +
> +			if (!timeout) {
> +				dev_dbg(ipu->dev,
> +					"Warning: timeout waiting for channel %u to "
> +					"stop: buf0_rdy = 0x%08X, buf1_rdy = 0x%08X, "
> +					"busy = 0x%08X, tstat = 0x%08X\n", channel,
> +					idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY),
> +					idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY),
> +					idmac_read_icreg(ipu, IDMAC_CHA_BUSY),
> +					idmac_read_ipureg(ipu, IPU_TASKS_STAT));
> +				break;
> +			}
> +		}
> +		dev_dbg(ipu->dev, "timeout = %d * 10ms\n", 40 - timeout);
> +	}
> +	/* SDC BG and FG must be disabled before DMA is disabled */
> +	if (wait_for_stop && (channel == IDMAC_SDC_0 ||
> +			      channel == IDMAC_SDC_1)) {
> +		if (channel == IDMAC_SDC_0)
> +			eof_intr = IPU_IRQ_SDC_BG_EOF;
> +		else
> +			eof_intr = IPU_IRQ_SDC_FG_EOF;
> +
> +		for (timeout = 5;
> +		     timeout && !ipu_irq_status(eof_intr); timeout--)
> +			msleep(5);
> +	}
> +
> +	spin_lock_irqsave(&ipu->lock, flags);
> +
> +	/* Disable IC task */
> +	_ipu_ic_disable_task(ipu, channel);
> +
> +	/* Disable DMA channel(s) */
> +	reg = idmac_read_icreg(ipu, IDMAC_CHA_EN);
> +	idmac_write_icreg(ipu, reg & ~chan_mask, IDMAC_CHA_EN);
> +
> +	/*
> +	 * Problem (observed with channel DMAIC_7): after enabling the channel
> +	 * and initialising buffers, there comes an interrupt with current still
> +	 * pointing at buffer 0, whereas it should use buffer 0 first and only
> +	 * generate an interrupt when it is done, then current should already
> +	 * point to buffer 1. This spurious interrupt also comes on channel
> +	 * DMASDC_0. With DMAIC_7 normally, is we just leave the ISR after the
> +	 * first interrupt, there comes the second with current correctly
> +	 * pointing to buffer 1 this time. But sometimes this second interrupt
> +	 * doesn't come and the channel hangs. Clearing BUFx_RDY when disabling
> +	 * the channel seems to prevent the channel from hanging, but it doesn't
> +	 * prevent the spurious interrupt. This might also be unsafe. Think
> +	 * about the IDMAC controller trying to switch to a buffer, when we
> +	 * clear the ready bit, and re-enable it a moment later.
> +	 */
> +	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY);
> +	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF0_RDY);
> +	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF0_RDY);
> +
> +	reg = idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY);
> +	idmac_write_ipureg(ipu, 0, IPU_CHA_BUF1_RDY);
> +	idmac_write_ipureg(ipu, reg & ~(1UL << channel), IPU_CHA_BUF1_RDY);
> +
> +	spin_unlock_irqrestore(&ipu->lock, flags);
> +
> +	return 0;
> +}
> +
> +/*
> + * We have several possibilities here:
> + * current BUF		next BUF
> + *
> + * not last sg		next not last sg
> + * not last sg		next last sg
> + * last sg		first sg from next descriptor
> + * last sg		NULL
> + *
> + * Besides, the descriptor queue might be empty or not. We process all these
> + * cases carefully.
> + */
> +static irqreturn_t idmac_interrupt(int irq, void *dev_id)
> +{
> +	struct idmac_channel *ichan = dev_id;
> +	unsigned int chan_id = ichan->dma_chan.chan_id;
> +	struct scatterlist **sg, *sgnext, *sgnew = NULL;
> +	/* Next transfer descriptor */
> +	struct idmac_tx_desc *desc = NULL, *descnew;
> +	dma_async_tx_callback callback;
> +	void *callback_param;
> +	bool done = false;
> +	u32	ready0 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF0_RDY),
> +		ready1 = idmac_read_ipureg(&ipu_data, IPU_CHA_BUF1_RDY),
> +		curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
> +
> +	/* IDMAC has cleared the respective BUFx_RDY bit, we manage the buffer */
> +
> +	pr_debug("IDMAC irq %d\n", irq);
> +	/* Other interrupts do not interfere with this channel */
> +	spin_lock(&ichan->lock);
> +
> +	if (unlikely(chan_id != IDMAC_SDC_0 && chan_id != IDMAC_SDC_1 &&
> +		     ((curbuf >> chan_id) & 1) == ichan->active_buffer)) {
> +		int i = 100;
> +
> +		/* This doesn't help. See comment in ipu_disable_channel() */
> +		while (--i) {
> +			curbuf = idmac_read_ipureg(&ipu_data, IPU_CHA_CUR_BUF);
> +			if (((curbuf >> chan_id) & 1) != ichan->active_buffer)
> +				break;
> +			cpu_relax();
> +		}
> +
> +		if (!i) {
> +			spin_unlock(&ichan->lock);
> +			dev_err(ichan->dma_chan.device->dev,
> +				"IRQ on active buffer on channel %x, active "
> +				"%d, ready %x, %x, current %x!\n", chan_id,
> +				ichan->active_buffer, ready0, ready1, curbuf);
> +			return IRQ_NONE;
> +		}
> +	}
> +
> +	if (unlikely((ichan->active_buffer && (ready1 >> chan_id) & 1) ||
> +		     (!ichan->active_buffer && (ready0 >> chan_id) & 1)
> +		     )) {
> +		spin_unlock(&ichan->lock);
> +		dev_dbg(ichan->dma_chan.device->dev,
> +			"IRQ with active buffer still ready on channel %x, "
> +			"active %d, ready %x, %x!\n", chan_id,
> +			ichan->active_buffer, ready0, ready1);
> +		return IRQ_NONE;
> +	}
> +
> +	if (unlikely(list_empty(&ichan->queue))) {
> +		spin_unlock(&ichan->lock);
> +		dev_err(ichan->dma_chan.device->dev,
> +			"IRQ without queued buffers on channel %x, active %d, "
> +			"ready %x, %x!\n", chan_id,
> +			ichan->active_buffer, ready0, ready1);
> +		return IRQ_NONE;
> +	}
> +
> +	/*
> +	 * active_buffer is a software flag, it shows which buffer we are
> +	 * currently expecting back from the hardware, IDMAC should be
> +	 * processing the other buffer already
> +	 */
> +	sg = &ichan->sg[ichan->active_buffer];
> +	sgnext = ichan->sg[!ichan->active_buffer];
> +
> +	/*
> +	 * if sgnext == NULL sg must be the last element in a scatterlist and
> +	 * queue must be empty
> +	 */
> +	if (unlikely(!sgnext)) {
> +		if (unlikely(sg_next(*sg))) {
> +			dev_err(ichan->dma_chan.device->dev,
> +				"Broken buffer-update locking on channel %x!\n",
> +				chan_id);
> +			/* We'll let the user catch up */
> +		} else {
> +			/* Underrun */
> +			_ipu_ic_disable_task(&ipu_data, chan_id);
> +			dev_dbg(ichan->dma_chan.device->dev,
> +				"Underrun on channel %x\n", chan_id);
> +			ichan->status = IPU_CHANNEL_READY;
> +			/* Continue to check for complete descriptor */
> +		}
> +	}
> +
> +	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
> +
> +	/* First calculate and submit the next sg element */
> +	if (likely(sgnext))
> +		sgnew = sg_next(sgnext);
> +
> +	if (unlikely(!sgnew)) {
> +		/* Start a new scatterlist, if any queued */
> +		if (likely(desc->list.next != &ichan->queue)) {
> +			descnew = list_entry(desc->list.next,
> +					     struct idmac_tx_desc, list);
> +			sgnew = &descnew->sg[0];
> +		}
> +	}
> +
> +	if (unlikely(!sg_next(*sg)) || !sgnext) {
> +		/*
> +		 * Last element in scatterlist done, remove from the queue,
> +		 * _init for debugging
> +		 */
> +		list_del_init(&desc->list);
> +		done = true;
> +	}
> +
> +	*sg = sgnew;
> +
> +	if (likely(sgnew)) {
> +		int ret;
> +
> +		ret = ipu_update_channel_buffer(chan_id, ichan->active_buffer,
> +						sg_dma_address(*sg));
> +		if (ret < 0)
> +			dev_err(ichan->dma_chan.device->dev,
> +				"Failed to update buffer on channel %x buffer %d!\n",
> +				chan_id, ichan->active_buffer);
> +		else
> +			ipu_select_buffer(chan_id, ichan->active_buffer);
> +	}
> +
> +	/* Flip the active buffer - even if update above failed */
> +	ichan->active_buffer = !ichan->active_buffer;
> +	if (done)
> +		ichan->completed = desc->txd.cookie;
> +
> +	callback = desc->txd.callback;
> +	callback_param = desc->txd.callback_param;
> +
> +	spin_unlock(&ichan->lock);
> +
> +	if (done && (desc->txd.flags & DMA_PREP_INTERRUPT) && callback)
> +		callback(callback_param);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void ipu_gc_tasklet(unsigned long arg)
> +{
> +	struct ipu *ipu = (struct ipu *)arg;
> +	int i;
> +
> +	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
> +		struct idmac_channel *ichan = ipu->channel + i;
> +		struct idmac_tx_desc *desc;
> +		unsigned long flags;
> +		int j;
> +
> +		for (j = 0; j < ichan->n_tx_desc; j++) {
> +			desc = ichan->desc + j;
> +			spin_lock_irqsave(&ichan->lock, flags);
> +			if (async_tx_test_ack(&desc->txd)) {
> +				list_move(&desc->list, &ichan->free_list);
> +				async_tx_clear_ack(&desc->txd);
> +			}
> +			spin_unlock_irqrestore(&ichan->lock, flags);
> +		}
> +	}
> +}
> +
> +/*
> + * At the time .device_alloc_chan_resources() method is called, we cannot know,
> + * whether the client will accept the channel. Thus we must only check, if we
> + * can satisfy client's request but the only real criterion to verify, whether
> + * the client has accepted our offer is the client_count. That's why we have to
> + * perform the rest of our allocation tasks on the first call to this function.
> + */
> +static struct dma_async_tx_descriptor *idmac_prep_slave_sg(struct dma_chan *chan,
> +		struct scatterlist *sgl, unsigned int sg_len,
> +		enum dma_data_direction direction, unsigned long tx_flags)
> +{
> +	struct idmac_channel *ichan = to_idmac_chan(chan);
> +	struct idmac_tx_desc *desc = NULL;
> +	struct dma_async_tx_descriptor *txd = NULL;
> +	unsigned long flags;
> +
> +	/* We only can handle these three channels so far */
> +	if (ichan->dma_chan.chan_id != IDMAC_SDC_0 && ichan->dma_chan.chan_id != IDMAC_SDC_1 &&
> +	    ichan->dma_chan.chan_id != IDMAC_IC_7)
> +		return NULL;
> +
> +	if (direction != DMA_FROM_DEVICE && direction != DMA_TO_DEVICE) {
> +		dev_err(chan->device->dev, "Invalid DMA direction %d!\n", direction);
> +		return NULL;
> +	}
> +
> +	mutex_lock(&ichan->chan_mutex);
> +
> +	spin_lock_irqsave(&ichan->lock, flags);
> +	if (!list_empty(&ichan->free_list)) {
> +		desc = list_entry(ichan->free_list.next,
> +				  struct idmac_tx_desc, list);
> +
> +		list_del_init(&desc->list);
> +
> +		desc->sg_len	= sg_len;
> +		desc->sg	= sgl;
> +		txd		= &desc->txd;
> +		txd->flags	= tx_flags;
> +	}
> +	spin_unlock_irqrestore(&ichan->lock, flags);
> +
> +	mutex_unlock(&ichan->chan_mutex);
> +
> +	tasklet_schedule(&to_ipu(to_idmac(chan->device))->tasklet);
> +
> +	return txd;
> +}
> +
> +/* Re-select the current buffer and re-activate the channel */
> +static void idmac_issue_pending(struct dma_chan *chan)
> +{
> +	struct idmac_channel *ichan = to_idmac_chan(chan);
> +	struct idmac *idmac = to_idmac(chan->device);
> +	struct ipu *ipu = to_ipu(idmac);
> +	unsigned long flags;
> +
> +	/* This is not always needed, but doesn't hurt either */
> +	spin_lock_irqsave(&ipu->lock, flags);
> +	ipu_select_buffer(ichan->dma_chan.chan_id, ichan->active_buffer);
> +	spin_unlock_irqrestore(&ipu->lock, flags);
> +
> +	/*
> +	 * Might need to perform some parts of initialisation from
> +	 * ipu_enable_channel(), but not all, we do not want to reset to buffer
> +	 * 0, don't need to set priority again either, but re-enabling the task
> +	 * and the channel might be a good idea.
> +	 */
> +}
> +
> +static void __idmac_terminate_all(struct dma_chan *chan)
> +{
> +	struct idmac_channel *ichan = to_idmac_chan(chan);
> +	struct idmac *idmac = to_idmac(chan->device);
> +	unsigned long flags;
> +	int i;
> +
> +	ipu_disable_channel(idmac, chan->chan_id,
> +			    ichan->status >= IPU_CHANNEL_ENABLED);
> +
> +	/* ichan->queue is modified in ISR, have to spinlock */
> +	tasklet_disable(&to_ipu(idmac)->tasklet);
> +
> +	spin_lock_irqsave(&ichan->lock, flags);
> +	list_splice_init(&ichan->queue, &ichan->free_list);
> +
> +	if (ichan->desc)
> +		for (i = 0; i < ichan->n_tx_desc; i++) {
> +			struct idmac_tx_desc *desc = ichan->desc + i;
> +			if (list_empty(&desc->list))
> +				/* Descriptor was prepared, but not submitted */
> +				list_add(&desc->list,
> +					 &ichan->free_list);
> +
> +			async_tx_clear_ack(&desc->txd);
> +		}
> +
> +	ichan->sg[0] = NULL;
> +	ichan->sg[1] = NULL;
> +	spin_unlock_irqrestore(&ichan->lock, flags);
> +
> +	tasklet_enable(&to_ipu(idmac)->tasklet);
> +
> +	ichan->status = IPU_CHANNEL_INITIALIZED;
> +}
> +
> +static void idmac_terminate_all(struct dma_chan *chan)
> +{
> +	struct idmac_channel *ichan = to_idmac_chan(chan);
> +
> +	mutex_lock(&ichan->chan_mutex);
> +
> +	__idmac_terminate_all(chan);
> +
> +	mutex_unlock(&ichan->chan_mutex);
> +}
> +
> +static int idmac_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct idmac_channel *ichan = to_idmac_chan(chan);
> +	struct idmac *idmac = to_idmac(chan->device);
> +	int ret;
> +
> +	/* dmaengine.c now guarantees to only offer free channels */
> +	BUG_ON(chan->client_count > 1);
> +	WARN_ON(ichan->status != IPU_CHANNEL_FREE);
> +
> +	/* The channel is free yet, no need to protect? */
> +	mutex_lock(&ichan->chan_mutex);

No, this is called under a mutex from dmaengine.c, so you won't get
called twice + ipu_init_channel grabs a spinlock.

> +
> +	chan->cookie		= 1;
> +	ichan->completed	= -ENXIO;
> +
> +	ret = request_irq(ichan->eof_irq, idmac_interrupt, 0,
> +			  "idmac", ichan);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = ipu_init_channel(idmac, ichan);
> +	if (ret < 0) {
> +		free_irq(ichan->eof_irq, ichan);
> +		goto out;
> +	}
> +
> +	ichan->status = IPU_CHANNEL_INITIALIZED;
> +
> +out:
> +	mutex_unlock(&ichan->chan_mutex);
> +
> +	dev_dbg(&ichan->dma_chan.dev->device, "Found channel 0x%x, irq %d\n",
> +		ichan->dma_chan.chan_id, ichan->eof_irq);

As this is also the error path, 'Found channel' seems wrong.

> +
> +	return 0;

Always return 0?

> +}
> +
> +static void idmac_free_chan_resources(struct dma_chan *chan)
> +{
> +	struct idmac_channel *ichan = to_idmac_chan(chan);
> +	struct idmac *idmac = to_idmac(chan->device);
> +
> +	mutex_lock(&ichan->chan_mutex);
> +
> +	__idmac_terminate_all(chan);
> +
> +	if (ichan->status > IPU_CHANNEL_FREE)
> +		free_irq(ichan->eof_irq, ichan);
> +
> +	ichan->status = IPU_CHANNEL_FREE;
> +
> +	/*
> +	 * The channel should be uninitialized by now already, but the original
> +	 * Freescale driver did it again, and it shouldn't hurt
> +	 */

I doubt that since this is the only place where you call
ipu_uninit_channel().

> +	ipu_uninit_channel(idmac, ichan);
> +
> +	mutex_unlock(&ichan->chan_mutex);
> +
> +	tasklet_schedule(&to_ipu(idmac)->tasklet);
> +}
> +
> +static enum dma_status idmac_is_tx_complete(struct dma_chan *chan,
> +		dma_cookie_t cookie, dma_cookie_t *done, dma_cookie_t *used)
> +{
> +	struct idmac_channel *ichan = to_idmac_chan(chan);
> +
> +	if (done)
> +		*done = ichan->completed;
> +	if (used)
> +		*used = chan->cookie;
> +	if (cookie != chan->cookie)
> +		return DMA_ERROR;
> +	return DMA_SUCCESS;
> +}
> +
> +static int __init ipu_idmac_init(struct ipu *ipu)
> +{
> +	struct idmac *idmac = &ipu->idmac;
> +	struct dma_device *dma = &idmac->dma;
> +	int i;
> +
> +	dma_cap_set(DMA_SLAVE, dma->cap_mask);
> +	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
> +
> +	/* Compulsory common fields */
> +	dma->dev				= ipu->dev;
> +	dma->device_alloc_chan_resources	= idmac_alloc_chan_resources;
> +	dma->device_free_chan_resources		= idmac_free_chan_resources;
> +	dma->device_is_tx_complete		= idmac_is_tx_complete;
> +	dma->device_issue_pending		= idmac_issue_pending;
> +
> +	/* Compulsory for DMA_SLAVE fields */
> +	dma->device_prep_slave_sg		= idmac_prep_slave_sg;
> +	dma->device_terminate_all		= idmac_terminate_all;
> +
> +	INIT_LIST_HEAD(&dma->channels);
> +	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
> +		struct idmac_channel *ichan = ipu->channel + i;
> +		struct dma_chan *dma_chan = &ichan->dma_chan;
> +
> +		spin_lock_init(&ichan->lock);
> +		mutex_init(&ichan->chan_mutex);

Having two locking methods for one dma channel looks like a recipe for
trouble.

> +
> +		ichan->eof_irq		= MXC_IPU_INT_BASE + i;
> +		ichan->status		= IPU_CHANNEL_FREE;
> +		ichan->sec_chan_en	= false;
> +		ichan->completed	= -ENXIO;
> +
> +		dma_chan->device	= &idmac->dma;
> +		dma_chan->cookie	= 1;
> +		dma_chan->chan_id	= i;
> +		list_add_tail(&ichan->dma_chan.device_node, &dma->channels);
> +	}
> +
> +	idmac_write_icreg(ipu, 0x00000070, IDMAC_CONF);
> +
> +	return dma_async_device_register(&idmac->dma);
> +}
> +
> +static void ipu_idmac_exit(struct ipu *ipu)
> +{
> +	int i;
> +	struct idmac *idmac = &ipu->idmac;
> +
> +	for (i = 0; i < IPU_CHANNELS_NUM; i++) {
> +		struct idmac_channel *ichan = ipu->channel + i;
> +
> +		idmac_terminate_all(&ichan->dma_chan);
> +		idmac_prep_slave_sg(&ichan->dma_chan, NULL, 0, DMA_NONE, 0);
> +	}
> +
> +	dma_async_device_unregister(&idmac->dma);
> +}
> +
> +/*****************************************************************************
> + * IPU common probe / remove
> + */
> +
> +static int ipu_probe(struct platform_device *pdev)
> +{
> +	struct ipu_platform_data *pdata = pdev->dev.platform_data;
> +	struct resource *mem_ipu, *mem_ic;
> +	int ret;
> +
> +	spin_lock_init(&ipu_data.lock);
> +
> +	mem_ipu	= platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	mem_ic	= platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!pdata || !mem_ipu || !mem_ic)
> +		return -EINVAL;
> +
> +	ipu_data.dev = &pdev->dev;
> +
> +	platform_set_drvdata(pdev, &ipu_data);
> +
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0)
> +		goto err_noirq;
> +
> +	ipu_data.irq_fn = ret;
> +	ret = platform_get_irq(pdev, 1);
> +	if (ret < 0)
> +		goto err_noirq;
> +
> +	ipu_data.irq_err = ret;
> +	ipu_data.irq_base = pdata->irq_base;
> +
> +	dev_dbg(&pdev->dev, "fn irq %u, err irq %u, irq-base %u\n",
> +		ipu_data.irq_fn, ipu_data.irq_err, ipu_data.irq_base);
> +
> +	/* Remap IPU common registers */
> +	ipu_data.reg_ipu = ioremap(mem_ipu->start,
> +				   mem_ipu->end - mem_ipu->start + 1);
> +	if (!ipu_data.reg_ipu) {
> +		ret = -ENOMEM;
> +		goto err_ioremap_ipu;
> +	}
> +
> +	/* Remap Image Converter and Image DMA Controller registers */
> +	ipu_data.reg_ic = ioremap(mem_ic->start,
> +				  mem_ic->end - mem_ic->start + 1);
> +	if (!ipu_data.reg_ic) {
> +		ret = -ENOMEM;
> +		goto err_ioremap_ic;
> +	}
> +
> +	/* Get IPU clock */
> +	ipu_data.ipu_clk = clk_get(&pdev->dev, "ipu_clk");
> +	if (IS_ERR(ipu_data.ipu_clk)) {
> +		ret = PTR_ERR(ipu_data.ipu_clk);
> +		goto err_clk_get;
> +	}
> +
> +	/* Make sure IPU HSP clock is running */
> +	clk_enable(ipu_data.ipu_clk);

You start the clock in the probe function unconditionally and disable
it again when all channels are disabled. I suppose you can't access the
IPU registers when the clock is disabled, right? If this is the case
then _ipu_channel_conf_check() above should not warn when the clock has
to be (re-)enabled, because that's the case everytime all channels are
freed and then a new one gets registered.

> +
> +	/* Disable all interrupts */
> +	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_1);
> +	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_2);
> +	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_3);
> +	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_4);
> +	idmac_write_ipureg(&ipu_data, 0, IPU_INT_CTRL_5);
> +
> +	dev_dbg(&pdev->dev, "%s @ 0x%08lx, fn irq %u, err irq %u\n", pdev->name,
> +		(unsigned long)mem_ipu->start, ipu_data.irq_fn, ipu_data.irq_err);
> +
> +	ret = ipu_irq_attach_irq(&ipu_data, pdev);
> +	if (ret < 0)
> +		goto err_attach_irq;
> +
> +	/* Initialize DMA engine */
> +	ret = ipu_idmac_init(&ipu_data);
> +	if (ret < 0)
> +		goto err_idmac_init;
> +
> +	tasklet_init(&ipu_data.tasklet, ipu_gc_tasklet, (unsigned long)&ipu_data);
> +
> +	ipu_data.dev = &pdev->dev;
> +
> +	dev_dbg(ipu_data.dev, "IPU initialized\n");
> +
> +	return 0;
> +
> +err_idmac_init:
> +err_attach_irq:
> +	ipu_irq_detach_irq(&ipu_data, pdev);
> +	clk_put(ipu_data.ipu_clk);
> +err_clk_get:
> +	iounmap(ipu_data.reg_ic);
> +err_ioremap_ic:
> +	iounmap(ipu_data.reg_ipu);
> +err_ioremap_ipu:
> +err_noirq:
> +	dev_err(&pdev->dev, "Failed to probe IPU: %d\n", ret);
> +	return ret;
> +}
> +
> +static int ipu_remove(struct platform_device *pdev)
> +{
> +	struct ipu *ipu = platform_get_drvdata(pdev);
> +
> +	ipu_idmac_exit(ipu);
> +	ipu_irq_detach_irq(ipu, pdev);
> +	clk_put(ipu->ipu_clk);
> +	iounmap(ipu->reg_ic);
> +	iounmap(ipu->reg_ipu);
> +	tasklet_kill(&ipu->tasklet);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +/*
> + * We need two MEM resources - with IPU-common and Image Converter registers,
> + * including PF_CONF and IDMAC_* registers, and two IRQs - function and error
> + */
> +static struct platform_driver ipu_platform_driver = {
> +	.driver = {
> +		.name	= "ipu-core",
> +		.owner	= THIS_MODULE,
> +	},
> +	.remove		= ipu_remove,
> +};
> +
> +static int __init ipu_init(void)
> +{
> +	return platform_driver_probe(&ipu_platform_driver, ipu_probe);
> +}
> +subsys_initcall(ipu_init);
> +
> +MODULE_DESCRIPTION("IPU core driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
> +MODULE_ALIAS("platform:ipu-core");

<snip>

> +
> +#endif
> diff --git a/drivers/mfd/ipu/ipu_irq.c b/drivers/mfd/ipu/ipu_irq.c
> new file mode 100644
> index 0000000..3239d6b
> --- /dev/null
> +++ b/drivers/mfd/ipu/ipu_irq.c
> @@ -0,0 +1,277 @@
> +/*
> + * Copyright (C) 2008
> + * Guennadi Liakhovetski, DENX Software Engineering, <lg@denx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/spinlock.h>
> +#include <linux/delay.h>
> +#include <linux/clk.h>
> +#include <linux/irq.h>
> +
> +#include <asm/io.h>

s/asm/linux

> +
> +#include <mach/ipu.h>
> +
> +#include "ipu_intern.h"
> +
> +/*
> + * Register read / write - shall be inlined by the compiler
> + */
> +static u32 ipu_read_reg(struct ipu *ipu, unsigned long reg)
> +{
> +	return __raw_readl(ipu->reg_ipu + reg);
> +}
> +
> +static void ipu_write_reg(struct ipu *ipu, u32 value, unsigned long reg)
> +{
> +	__raw_writel(value, ipu->reg_ipu + reg);
> +}
> +
> +
> +/*
> + * IPU IRQ chip driver
> + */
> +
> +#define IPU_IRQ_NR_FN_BANKS 3
> +#define IPU_IRQ_NR_ERR_BANKS 2
> +
> +struct ipu_irq_bank {
> +	int		nr_irqs;
> +	unsigned int	control;
> +	unsigned int	status;
> +	unsigned int	irq_base;
> +	spinlock_t	lock;
> +	struct ipu	*ipu;
> +};
> +
> +static struct ipu_irq_bank irq_bank_fn[IPU_IRQ_NR_FN_BANKS] = {
> +	/* 3 groups of functional interrupts */
> +	{
> +		.nr_irqs	= 32,
> +		.control	= IPU_INT_CTRL_1,
> +		.status		= IPU_INT_STAT_1,
> +	}, {
> +		.nr_irqs	= 32,
> +		.control	= IPU_INT_CTRL_2,
> +		.status		= IPU_INT_STAT_2,
> +	}, {
> +		.nr_irqs	= 24,
> +		.control	= IPU_INT_CTRL_3,
> +		.status		= IPU_INT_STAT_3,
> +	},
> +};
> +
> +static struct ipu_irq_bank irq_bank_err[IPU_IRQ_NR_ERR_BANKS] = {
> +	/* 2 groups of error interrupts */
> +	{
> +		.nr_irqs	= 32,
> +		.control	= IPU_INT_CTRL_4,
> +		.status		= IPU_INT_STAT_4,
> +	}, {
> +		.nr_irqs	= 17,
> +		.control	= IPU_INT_CTRL_5,
> +		.status		= IPU_INT_STAT_5,
> +	},
> +};
> +
> +#define IPU_IRQ_NR_FN_IRQS (32 + 32 + 24)
> +#define IPU_IRQ_NR_ERR_IRQS (32 + 17)
> +#define IPU_IRQ_NR_IRQS (IPU_IRQ_NR_ERR_IRQS + IPU_IRQ_NR_FN_IRQS)

Do we really need an interrupt handler behind each status bit the ipu
has to offer? This looks quite expensive

> +
> +static void ipu_irq_unmask(unsigned int irq)
> +{
> +	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
> +	uint32_t reg;
> +	unsigned long lock_flags;
> +
> +	spin_lock_irqsave(&bank->lock, lock_flags);
> +
> +	reg = ipu_read_reg(bank->ipu, bank->control);
> +	reg |= (1UL << (irq - bank->irq_base));
> +	ipu_write_reg(bank->ipu, reg, bank->control);
> +
> +	spin_unlock_irqrestore(&bank->lock, lock_flags);
> +}
> +
> +static void ipu_irq_mask(unsigned int irq)
> +{
> +	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
> +	uint32_t reg;
> +	unsigned long lock_flags;
> +
> +	spin_lock_irqsave(&bank->lock, lock_flags);
> +
> +	reg = ipu_read_reg(bank->ipu, bank->control);
> +	reg &= ~(1UL << (irq - bank->irq_base));
> +	ipu_write_reg(bank->ipu, reg, bank->control);
> +
> +	spin_unlock_irqrestore(&bank->lock, lock_flags);
> +}
> +
> +static void ipu_irq_ack(unsigned int irq)
> +{
> +	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
> +
> +	ipu_write_reg(bank->ipu, 1UL << (irq - bank->irq_base), bank->status);
> +}
> +
> +/**
> + * Returns the current interrupt status for the specified IRQ.
> + *
> + * @param       irq             Interrupt line to get status for.
> + *
> + * @return      Returns true if the interrupt is pending/asserted or false if
> + *              the interrupt is not pending.
> + */
> +bool ipu_irq_status(uint32_t irq)
> +{
> +	struct ipu_irq_bank *bank = get_irq_chip_data(irq);
> +
> +	if (ipu_read_reg(bank->ipu, bank->status) &
> +	    (1UL << (irq - bank->irq_base)))
> +		return true;
> +	else
> +		return false;
> +}
> +
> +/* Chained IRQ handler for IPU error interrupt */
> +static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct ipu *ipu = get_irq_data(irq);
> +	u32 status;
> +	int i, line;
> +
> +	for (i = 0; i < IPU_IRQ_NR_ERR_BANKS; i++) {
> +		status = ipu_read_reg(ipu, irq_bank_err[i].status);
> +		/*
> +		 * Don't think we have to clear all interrupts here, thy will
> +		 * be acked by ->handle_irq() (handle_level_irq). However, we
> +		 * might want to clear unhandled interrupts after the loop...
> +		 */
> +		status &= ipu_read_reg(ipu, irq_bank_err[i].control);
> +		while ((line = ffs(status))) {
> +			status &= ~(1UL << (line - 1));
> +			generic_handle_irq(irq_bank_err[i].irq_base + line - 1);
> +		}
> +	}
> +}
> +
> +/* Chained IRQ handler for IPU function interrupt */
> +static void ipu_irq_fn(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct ipu *ipu = get_irq_data(irq);
> +	u32 status;
> +	int i, line;
> +
> +	for (i = 0; i < IPU_IRQ_NR_FN_BANKS; i++) {
> +		status = ipu_read_reg(ipu, irq_bank_fn[i].status);
> +		/* Not clearing all interrupts, see above */
> +		status &= ipu_read_reg(ipu, irq_bank_fn[i].control);
> +		while ((line = ffs(status))) {
> +			status &= ~(1UL << (line - 1));
> +			generic_handle_irq(irq_bank_fn[i].irq_base + line - 1);
> +		}
> +	}
> +}
> +
> +static struct irq_chip ipu_irq_chip = {
> +	.name	= "ipu_irq",
> +	.ack	= ipu_irq_ack,
> +	.mask	= ipu_irq_mask,
> +	.unmask	= ipu_irq_unmask,
> +};
> +
> +/* Install the IRQ handler */
> +int ipu_irq_attach_irq(struct ipu *ipu, struct platform_device *dev)
> +{
> +	struct ipu_platform_data *pdata = dev->dev.platform_data;
> +	unsigned int irq, irq_base, i;
> +
> +	irq_base = pdata->irq_base;
> +
> +	for (i = 0; i < IPU_IRQ_NR_FN_BANKS; i++) {
> +		irq_bank_fn[i].ipu		= ipu;
> +		irq_bank_fn[i].irq_base		= irq_base;
> +		spin_lock_init(&irq_bank_fn[i].lock);
> +
> +		dev_dbg(&dev->dev, "IPU-IRQ: Setting up %d function irqs bank "
> +			"%d at %u\n", irq_bank_fn[i].nr_irqs, i, irq_base);
> +
> +		for (irq = irq_base; irq < irq_base + irq_bank_fn[i].nr_irqs;
> +		     irq++) {
> +			int ret = set_irq_chip(irq, &ipu_irq_chip);
> +			if (ret < 0)
> +				return ret;
> +			ret = set_irq_chip_data(irq, irq_bank_fn + i);
> +			if (ret < 0)
> +				return ret;
> +			set_irq_handler(irq, handle_level_irq);
> +#ifdef CONFIG_ARM
> +			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
> +#endif
> +		}
> +		spin_lock_init(&irq_bank_fn[i].lock);
> +		irq_base += irq_bank_fn[i].nr_irqs;
> +	}
> +
> +	for (i = 0; i < IPU_IRQ_NR_ERR_BANKS; i++) {
> +		irq_bank_err[i].ipu		= ipu;
> +		irq_bank_err[i].irq_base	= irq_base;
> +		spin_lock_init(&irq_bank_fn[i].lock);
> +
> +		dev_dbg(&dev->dev, "IPU-IRQ: Setting up %d error irqs bank "
> +			"%d at %u\n", irq_bank_err[i].nr_irqs, i, irq_base);
> +
> +		for (irq = irq_base; irq < irq_base + irq_bank_err[i].nr_irqs;
> +		     irq++) {
> +			int ret = set_irq_chip(irq, &ipu_irq_chip);
> +			if (ret < 0)
> +				return ret;
> +			ret = set_irq_chip_data(irq, irq_bank_err + i);
> +			if (ret < 0)
> +				return ret;
> +			set_irq_handler(irq, handle_level_irq);
> +#ifdef CONFIG_ARM
> +			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
> +#endif
> +		}
> +		spin_lock_init(&irq_bank_err[i].lock);
> +		irq_base += irq_bank_err[i].nr_irqs;
> +	}
> +
> +	set_irq_data(ipu->irq_fn, ipu);
> +	set_irq_chained_handler(ipu->irq_fn, ipu_irq_fn);
> +
> +	set_irq_data(ipu->irq_err, ipu);
> +	set_irq_chained_handler(ipu->irq_err, ipu_irq_err);
> +
> +	return 0;
> +}
> +
> +void ipu_irq_detach_irq(struct ipu *ipu, struct platform_device *dev)
> +{
> +	struct ipu_platform_data *pdata = dev->dev.platform_data;
> +	unsigned int irq, irq_base;
> +
> +	irq_base = pdata->irq_base;
> +
> +	set_irq_chained_handler(ipu->irq_fn, NULL);
> +	set_irq_data(ipu->irq_fn, NULL);
> +
> +	set_irq_chained_handler(ipu->irq_err, NULL);
> +	set_irq_data(ipu->irq_err, NULL);
> +
> +	for (irq = irq_base; irq < irq_base + IPU_IRQ_NR_IRQS; irq++) {
> +#ifdef CONFIG_ARM
> +		set_irq_flags(irq, 0);
> +#endif
> +		set_irq_chip(irq, NULL);
> +		set_irq_chip_data(irq, NULL);
> +	}
> +}
> -- 
> 1.5.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
