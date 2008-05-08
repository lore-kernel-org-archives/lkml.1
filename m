Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbYEHAwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbYEHAwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYEHAvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:51:52 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:63534 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYEHAvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:51:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend
Date: Thu, 8 May 2008 08:51:37 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F6783B@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080507184333.7d0f1bf4.krzysztof.h1@poczta.fm>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend
Thread-Index: AciwZSusCYD84PDrQxGgk11WQ8NIKQAP2cdQ
From: <JosephChan@via.com.tw>
To: <krzysztof.h1@poczta.fm>
Cc: <akpm@linux-foundation.org>, <geert@linux-m68k.org>,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2008 00:51:47.0320 (UTC) FILETIME=[B1722780:01C8B0A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Thanks for your reviewing.
I will ask our engineers to check what you mentioned and suggested.
In addition, the original vt8623fb (CLE266) wasn't developed by VIA. So it might depend on the decision of kernel community.

BRs,
Joseph Chan 

-----Original Message-----
From: Krzysztof Helt [mailto:krzysztof.h1@poczta.fm] 
Sent: Thursday, May 08, 2008 12:44 AM
To: Joseph Chan
Cc: akpm@linux-foundation.org; geert@linux-m68k.org; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver - Resend

Hi Joseph,

You have sent tremendous amount of work. 

I am trying to point some mistakes or improvements, but I won't cover the whole code at the moment. Look at them and check if the rest of the code can be improved as well.

A general comment is that you use to many global variables. You should move some of them into the viafb_par structure.
Does any of supported devices support multi-head? If so you may prefer to have allocated fb_info and viafb_par structure to hold data required for each display separated (e.g. for different types of displays connected to both heads).

See below for problems I have spotted (in quick look over).

Regards,
Krzysztof

PS. I assume that your driver will replace the existing vt8623fb (CLE266?) driver when ready. Am I right?

On Wed, 7 May 2008 19:06:48 +0800
<JosephChan@via.com.tw> wrote:

(...)
> diff -Nur a/drivers/video/via/accel.c b/drivers/video/via/accel.c
> --- a/drivers/video/via/accel.c	1969-12-31 19:00:00.000000000 -0500
> +++ b/drivers/video/via/accel.c	2008-04-29 02:51:13.000000000 -0400
> @@ -0,0 +1,245 @@
> +/*
> + * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
> + * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
> +
> + * This program is free software; you can redistribute it and/or 
> + modify
> + * it under  the terms of the GNU General Public License as published
> + * by the Free Software Foundation; either version 2, or (at your
> + option)

Somehow this line got wrapped against your intention, I suppose.

> +#include "global.h"
> +
> +void init_accel(void)
> +{
> +	parinfo.cursor_start = parinfo.fbmem_free - CURSOR_SIZE;
> +	parinfo.fbmem_free -= CURSOR_SIZE;

You can swap these two lines to get shorter code:
parinfo.fbmem_free -= CURSOR_SIZE;
parinfo.cursor_start = parinfo.fbmem_free;

> +
> +	/* Reverse 8*1024 memory space for cursor image of the XServer */
> +	parinfo.VQ_start = parinfo.fbmem_free - CURSOR_SIZE - VQ_SIZE;
> +	parinfo.VQ_end = parinfo.VQ_start + VQ_SIZE - 1;
> +	parinfo.fbmem_free -= (CURSOR_SIZE + VQ_SIZE);
> +	parinfo.fbmem_used += (CURSOR_SIZE + VQ_SIZE); }
> +

Again, swap the third and the first line.

> +	if (parinfo.VQ_start != 0) {
> +		/* Enable VQ */
> +		dwVQStartAddr = parinfo.VQ_start;
> +		dwVQEndAddr = parinfo.VQ_end;
> +		switch (chip_info.gfx_chip_name) {
> +		case UNICHROME_K8M890:
> +		case UNICHROME_P4M900:
> +			dwVQStartL = 0x70000000 | (dwVQStartAddr & 0xFFFFFF);
> +			dwVQEndL = 0x71000000 | (dwVQEndAddr & 0xFFFFFF);
> +			dwVQStartEndH =
> +			    0x72000000 | ((dwVQStartAddr & 0xFF000000) >>
> +					  24) | ((dwVQEndAddr & 0xFF000000)
> +						 >> 16);
> +			dwVQLen = 0x73000000 | (VQ_SIZE >> 3);
> +			break;
> +		default:
> +			dwVQStartL = 0x50000000 | (dwVQStartAddr & 0xFFFFFF);
> +			dwVQEndL = 0x51000000 | (dwVQEndAddr & 0xFFFFFF);
> +			dwVQStartEndH =
> +			    0x52000000 | ((dwVQStartAddr & 0xFF000000) >>
> +					  24) | ((dwVQEndAddr & 0xFF000000)
> +						 >> 16);
> +			dwVQLen = 0x53000000 | (VQ_SIZE >> 3);

You can move the default case before switch the only or the 0x20000000 bit in case of the K8M890 or P4M900 chipsets. It will show that you set actually the same values (except one bit) for both.

> +
> +int wait_engine_idle(void)
> +{
> +	int loop = 0;
> +
> +	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY)
> +	       && (loop++ < MAXLOOP)) ;
> +
> +	while ((MMIO_IN32(VIA_REG_STATUS) &
> +		(VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
> +	       (loop++ < MAXLOOP)) ;
> +

You can add cpu_relax() call into these waiting loops.

> diff -Nur a/drivers/video/via/accel.h b/drivers/video/via/accel.h
> --- a/drivers/video/via/accel.h	1969-12-31 19:00:00.000000000 -0500
> +++ b/drivers/video/via/accel.h	2008-04-29 02:51:14.000000000 -0400
> @@ -0,0 +1,190 @@
> +/*
> + * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
> + * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
> +
> + * This program is free software; you can redistribute it and/or 
> + modify
> + * it under  the terms of the GNU General Public License as published
> + * by the Free Software Foundation; either version 2, or (at your
> + option)

Again, wrapped.

> + * any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
> + * the implied warranty of MERCHANTABILITY or FITNESS FOR
> + * A PARTICULAR PURPOSE.See the GNU General Public License
> + * for more details.
> +
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc.,
> + * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +#ifndef __ACCEL_H__
> +#define __ACCEL_H__
> +
> +#ifndef FB_ACCEL_VIA_UNICHROME
> +#define FB_ACCEL_VIA_UNICHROME  50
> +#endif

This is the only place you define FB_ACCEL_VIA_UNICHROME. If so you don't need to do #ifndef.

> +
> +#ifndef VIA_MMIO
> +#define VIA_MMIO 1
> +#endif
> +

The same as the above.

> +#if VIA_MMIO
> +#define MMIO_OUT8(reg, val)  writeb(val, parinfo.io_virt + reg) 
> +#define MMIO_OUT16(reg, val) writew(val, parinfo.io_virt + reg) 
> +#define MMIO_OUT32(reg, val) writel(val, parinfo.io_virt + reg)

These lines get wrapped badly.

> +#define MMIO_IN8(reg)       readb(parinfo.io_virt + reg)
> +#define MMIO_IN16(reg)      readw(parinfo.io_virt + reg)
> +#define MMIO_IN32(reg)      readl(parinfo.io_virt + reg)
> +
> +#else
> +#define MMIO_OUT8(reg, val)  outb(val, reg) #define MMIO_OUT16(reg,
> +val) outw(val, reg) #define MMIO_OUT32(reg, val) outl(val, reg)
> +#define MMIO_IN8(reg)       inb(reg)
> +#define MMIO_IN16(reg)      inw(reg)
> +#define MMIO_IN32(reg)      inl(reg)
> +#endif
> +

Your devices seem to be 32-bit only because 8 and 16-bit accesses are never used. You can remove these macros.

> diff -Nur a/drivers/video/via/chip.h b/drivers/video/via/chip.h
> --- a/drivers/video/via/chip.h	1969-12-31 19:00:00.000000000 -0500
> +++ b/drivers/video/via/chip.h	2008-04-29 02:51:15.000000000 -0400
> @@ -0,0 +1,189 @@
> +/*
> + * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
> + * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
> +
> + * This program is free software; you can redistribute it and/or 
> + modify
> + * it under  the terms of the GNU General Public License as published
> + * by the Free Software Foundation; either version 2, or (at your
> + option)

Wrapped. Check all other files for this.

> diff -Nur a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
> --- a/drivers/video/via/dvi.c	1969-12-31 19:00:00.000000000 -0500
> +++ b/drivers/video/via/dvi.c	2008-05-04 07:28:49.000000000 -0400
> @@ -0,0 +1,721 @@
(...)
> +
> +/* Sense DVI Connector */
> +int dvi_sense(void)
> +{
> +	u8 RegSR1E = 0, RegSR3E = 0, RegCR6B = 0, RegCR91 = 0, RegCR93 =
> +	    0, RegCR9B = 0, data;

There is no need to initialize these variables. They are set before use (and if not a compiler will generate warning).

(...)
> +	/* Restore status */
> +	if (chip_info.gfx_chip_name == UNICHROME_CLE266) {
> +		write_reg(SR1E, VIASR, RegSR1E);
> +		write_reg(CR6B, VIACR, RegCR6B);
> +		write_reg(CR91, VIACR, RegCR91);
> +		write_reg(CR93, VIACR, RegCR93);
> +	} else {
> +		write_reg(SR1E, VIASR, RegSR1E);
> +		write_reg(SR3E, VIASR, RegSR3E);
> +		write_reg(CR91, VIACR, RegCR91);
> +		write_reg(CR9B, VIACR, RegCR9B);
> +	}
> +

You can  put at least the first line before the if. Make common code just single instance (the third line can be moved if sequence is not important).

> +int dvi_get_panel_size_from_DDCv1(void)
> +{
> +	int i, max_h = 0, max_v = 0, tmp, restore;
> +	unsigned char rData;
> +	unsigned char EDID_DATA[18];
> +
> +	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv1 \n");
> +
> +	restore = chip_info.tmds_chip_info.tmds_chip_slave_addr;
> +	chip_info.tmds_chip_info.tmds_chip_slave_addr = 0xA0;
> +
> +	for (i = 0x23; i < 0x6D; i++) {
> +		switch (i) {
> +		case 0x23:
> +			rData = tmds_register_read(0x23);
> +			if (rData & 0x3C)
> +				max_h = 640;
> +			if (rData & 0xC0)
> +				max_h = 720;
> +			if (rData & 0x03)
> +				max_h = 800;
> +			break;
> +		case 0x24:
> +			rData = tmds_register_read(0x24);
> +			if (rData & 0xC0)
> +				max_h = 800;
> +			if (rData & 0x1E)
> +				max_h = 1024;
> +			if (rData & 0x01)
> +				max_h = 1280;
> +			break;

You can move these two cases before the loop and change loop's range.

(...)
> +			if (via_bus_width == 24) {
> +				if (device_lcd_dualedge == 1)
> +					i2cWriteByte(chip_info.
> +						     tmds_chip_info.
> +						     tmds_chip_slave_addr,
> +						     0x08, 0x3F);
> +				else
> +					i2cWriteByte(chip_info.
> +						     tmds_chip_info.
> +						     tmds_chip_slave_addr,
> +						     0x08, 0x37);

These to branches differs only by the set value. It is shorter to set value inside if-else the call i2cWriteByte after.


----------------------------------------------------------------------
Sprawdz, czy jestes prawdziwym internauta!
Kliknij http://link.interia.pl/f1d6e

