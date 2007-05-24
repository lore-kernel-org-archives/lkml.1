Return-Path: <linux-kernel-owner+w=401wt.eu-S1751012AbXEXOZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbXEXOZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbXEXOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:25:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:62508 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbXEXOY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A6Dvzexq7AloTCwnvKAFmaMZ7Oa/VRZt+lbdQrOHC284oAs+TTpbwQ6AO6TpUS+dOAQQv+CT5A7LD7IFyoB8Yo2dJP24cbOaPq13Kid5oSkcCbFXHrgkMjzw2g2w8hNBAN38U1Y+sSd+ZDxXeulWvJDEgTVB522YmLffzhSoYLU=
Message-ID: <d9def9db0705240724p59a48160l8a2338f4d44b0ef6@mail.gmail.com>
Date: Thu, 24 May 2007 16:24:55 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] V4L: stk11xx, add a new webcam driver
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com
In-Reply-To: <2172422218943432279@wsc.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2172422218943432279@wsc.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 5/24/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Well, no objections on v4l list, try to merge it. Any further comments will
> be
> appreciated.
>
> --
>
> stk11xx, add a new webcam driver
>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>
> ---
> commit 1f023432798b6e6fd52ad81af0eab250e1a71449
> tree 4045ace3523a78ae2b5bff194ed9c10945b27171
> parent 119ce83eb190c70d50ed7558c7b67b400ea00ec7
> author Jiri Slaby <jirislaby@gmail.com> Thu, 24 May 2007 15:56:41 +0200
> committer Jiri Slaby <jirislaby@gmail.com> Thu, 24 May 2007 15:56:41 +0200
>
>  drivers/media/video/Kconfig   |    8
>  drivers/media/video/Makefile  |    2
>  drivers/media/video/stk11xx.c | 3608
> +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 3618 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 070f4b1..cbab1ed 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -792,6 +792,14 @@ config USB_ZR364XX
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called zr364xx.
>
> +config USB_STK11XX
> +	tristate "STK11XX based webcams"
> +	depends on VIDEO_V4L2
> +	---help---
> +	  This will add support for Syntek webcams such as dc1125 and stk1135.
> +
> +	  If you choose to build it as module, it will be called stk11xx.
> +
>  endif # V4L_USB_DRIVERS
>
>  endif # VIDEO_CAPTURE_DRIVERS
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 3202e87..409125d 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -106,6 +106,8 @@ obj-$(CONFIG_USB_STV680)        += stv680.o
>  obj-$(CONFIG_USB_W9968CF)       += w9968cf.o
>  obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
>
> +obj-$(CONFIG_USB_STK11XX)	+= stk11xx.o
> +
>  obj-$(CONFIG_USB_SN9C102)       += sn9c102/
>  obj-$(CONFIG_USB_ET61X251)      += et61x251/
>  obj-$(CONFIG_USB_PWC)           += pwc/
> diff --git a/drivers/media/video/stk11xx.c b/drivers/media/video/stk11xx.c
> new file mode 100644
> index 0000000..53c36cb
> --- /dev/null
> +++ b/drivers/media/video/stk11xx.c
> @@ -0,0 +1,3608 @@
> +/*
> + * Driver for Syntek USB video camera
> + *
> + * Copyright (C) Nicolas VIVIEN
> + * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
> + *
> + * Licences
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
> +#include <linux/usb.h>
> +#include <media/v4l2-common.h>
> +
> +#define DRIVER_DESC			"Syntek USB Video Camera"
> +#define DRIVER_VERSION			"v0.0.1"
> +#define DRIVER_VERSION_NUM		0x000001
> +
> +#define USB_SYNTEK1_VENDOR_ID		0x174F
> +#define USB_SYNTEK2_VENDOR_ID		0x05E1
> +
> +#define USB_STK1125_PRODUCT_ID		0xa311
> +#define USB_STK1135_PRODUCT_ID		0xa821
> +#define USB_DC1125_PRODUCT_ID		0x0501
> +
> +typedef enum {
> +	SYNTEK_DC1125 = 1,
> +	SYNTEK_STK1135 = 2
> +} T_SYNTEK_DEVICE;
> +
> +/**
> + * @def MAX_ISO_BUFS
> + *   Number maximal of ISOC buffers
> + *
> + * @def ISO_FRAMES_PER_DESC
> + *   Number frames per ISOC descriptor
> + *
> + * @def ISO_MAX_FRAME_SIZE
> + *   Maximale size of frame
> + *
> + * @def ISO_BUFFER_SIZE
> + *   Maximal size of buffer
> + */
> +#define MAX_ISO_BUFS			16 /* 2 */
> +#define ISO_FRAMES_PER_DESC		10
> +#define ISO_MAX_FRAME_SIZE		3 * 1024
> +#define ISO_BUFFER_SIZE			(ISO_FRAMES_PER_DESC * ISO_MAX_FRAME_SIZE)
> +
> +/**
> + * @def STK11XX_MAX_IMAGES
> + *   Absolute maximum number of buffers available for mmap()
> + *
> + * @def STK11XX_FRAME_SIZE
> + *   Maximum size after decompression
> + */
> +#define STK11XX_MAX_IMAGES		10
> +#define STK11XX_FRAME_SIZE		(1280 * 1024 * 3)
> +
> +#ifndef CONFIG_STK11XX_DEBUG_STREAM
> +#define CONFIG_STK11XX_DEBUG_STREAM	0
> +#endif
> +
> +#if CONFIG_STK11XX_DEBUG_STREAM
> +#define STK_STREAM(str, args...)	printk(KERN_DEBUG "stk11xx: " str, \
> +									##args)
> +#else
> +#define STK_STREAM(str, args...)	do { } while(0)
> +#endif
> +
> +enum {
> +	STK11XX_80x60,
> +	STK11XX_160x120,
> +	STK11XX_320x240,
> +	STK11XX_640x480,
> +	STK11XX_800x600,
> +	STK11XX_1024x758,
> +	STK11XX_1280x1024,
> +	STK11XX_NBR_SIZES
> +};
> +
> +struct stk11xx_iso_buf {
> +	void *data;
> +	int length;
> +	int read;
> +	struct urb *urb;
> +};
> +
> +struct stk11xx_frame_buf {
> +	void *data;
> +	volatile int filled;
> +	struct stk11xx_frame_buf *next;
> +};
> +
> +struct stk11xx_image_buf {
> +	unsigned long offset;
> +	int vma_use_count;
> +};
> +
> +struct stk11xx_coord {
> +	int x;
> +	int y;
> +};
> +
> +struct stk11xx_video {
> +	int fps;
> +	int brightness;
> +	int contrast;
> +	int whiteness;
> +	u32 pixformat;
> +};
> +
> +struct stk11xx {
> +	struct video_device *vdev;
> +	struct usb_device *udev;
> +
> +	int webcam_model;
> +
> +	unsigned char *int_in_buffer;	/**< Interrupt IN buffer */
> +	size_t int_in_size;		/**< Interrupt IN buffer size */
> +	u8 int_in_endpointAddr;		/**< Interrupt IN endpoint address */
> +
> +	size_t isoc_in_size;		/**< Isochrone IN size */
> +	u8 isoc_in_endpointAddr;	/**< Isochrone IN endpoint address */
> +
> +	int watchdog;		/**< Counter for the software watchdog */
> +
> +	struct stk11xx_video vsettings;		/**< Video settings (brightness,
> whiteness...) */
> +
> +	int error_status;
> +
> +	struct mutex open_lock;
> +	unsigned int vopen;
> +	int visoc_errors;
> +	int vframes_error;
> +	int vlast_packet_size;
> +	char vsync;
> +
> +	spinlock_t spinlock;
> +	wait_queue_head_t wait_frame;
> +
> +	/* 1: isoc */
> +	char isoc_init_ok;
> +	struct stk11xx_iso_buf isobuf[MAX_ISO_BUFS];
> +
> +	/* 2: frame */
> +	int frame_size;
> +	struct stk11xx_frame_buf *framebuf;
> +	struct stk11xx_frame_buf *empty_frames, *empty_frames_tail;
> +	struct stk11xx_frame_buf *full_frames, *full_frames_tail;
> +	struct stk11xx_frame_buf *fill_frame;
> +	struct stk11xx_frame_buf *read_frame;
> +
> +	/* 3: decompression */
> +	void *decompress_data;
> +	
> +	/* 4: image */
> +	int image_size;
> +	void *image_data;
> +	struct stk11xx_image_buf images[STK11XX_MAX_IMAGES];
> +	u32 image_f[STK11XX_MAX_IMAGES];
> +	unsigned int nbuffers;
> +	unsigned int len_per_image;
> +	int image_read_pos;
> +	int fill_image;
> +	int resolution;
> +	struct stk11xx_coord view;
> +	struct stk11xx_coord image;
> +};
> +
> +static const struct stk11xx_coord stk11xx_image_sizes[STK11XX_NBR_SIZES] =
> {
> +	{   80,   60 },
> +	{  160,  120 },
> +	{  320,  240 },
> +	{  640,  480 },
> +	{  800,  600 },
> +	{ 1024,  758 },
> +	{ 1280, 1024 }
> +};
> +
> +static int default_nbrframebuf = 3;	/* Number of frame buffer by default */
> +static int default_fps = 10;
> +
> +static int fps;
> +module_param(fps, int, 0444);
> +MODULE_PARM_DESC(fps, "Frames per second [5-30]");
> +
> +static int stk11xx_read_registry(struct stk11xx *dev, u16 index, int
> *value)
> +{
> +	struct usb_device *udev = dev->udev;
> +	int result;
> +
> +	*value = 0;
> +
> +	result = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00,
> +			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE, 0x00,
> +			index, (u8 *)value, sizeof(u8), 500);
> +
> +	if (result < 0)
> +		dev_err(&udev->dev, "Read registry fails %02X\n", index);
> +
> +	return result;
> +}
> +
> +static int stk11xx_write_registry(struct stk11xx *dev, u16 index,
> +			       u16 value)
> +{
> +	struct usb_device *udev = dev->udev;
> +	int result;
> +
> +	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x01,
> +			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE, value,
> +			index, NULL, 0, 500);
> +
> +	if (result < 0)
> +		dev_err(&udev->dev, "Write registry fails %02X = %02X\n", index,
> +				value);
> +
> +	return result;
> +}
> +
> +static int stk11xx_set_feature(struct stk11xx *dev, int index)
> +{
> +	struct usb_device *udev = dev->udev;
> +	int result;
> +
> +	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> +				 USB_REQ_SET_FEATURE,
> +				 USB_TYPE_STANDARD | USB_DIR_OUT |
> +				 USB_RECIP_DEVICE, USB_DEVICE_REMOTE_WAKEUP,
> +				 index, NULL, 0, 500);
> +
> +	if (result < 0)
> +		dev_err(&udev->dev, "SET FEATURE fail !\n");
> +
> +	return result;
> +}
> +
> +/*
> + * Bayer conversion
> + */
> +
> +#define STK11XX_AVG2(x,y) (u8)(((int)x + (int)y) / 2)
> +#define STK11XX_AVG4(a,b,c,d) (u8)(((int)a + (int)b + (int)c + (int)d) / 4)
> +
> +static void stk11xx_bayer_to_rgb(u8 *rgb, const u8 *bayer,
> +			  const int width, const int height)

hmm.. this is probably to support xawtv/tvtime?
It would be better to do that in userspace, but the argument which
seems to be against it is that userspace applications often don't
support bayer.

> +{
> +	unsigned int i, j, x, y;
> +	int rpos, wpos, ltpos, lbpos;
> +	int runlength = width > height ? width : height;
> +	int lastrow = ((height - 1) * width) * 3;
> +	int lastcolumn = (width - 1) * 3;
> +
> +	/* blit out initial data */
> +	for (j = 0, y = 0; y < height; y++) {
> +		for (i = 0, x = 0; x < width; x++) {
> +			if (y & 1) {
> +				/* GBGBGB line */
> +				if (x & 1) {	/* blue */
> +					rgb[j * width * 3 + i * 3 + 2] =
> +					    bayer[(height - y) * width + x];
> +				} else {	/* green */
> +					rgb[j * width * 3 + i * 3 + 1] =
> +					    bayer[(height - y) * width + x];
> +				}
> +			} else {
> +				/* RGRGRG line */
> +				if (x & 1) {	/* green */
> +					rgb[j * width * 3 + i * 3 + 1] =
> +					    bayer[(height - y) * width + x];
> +				} else {	/* red */
> +					rgb[j * width * 3 + i * 3 + 0] =
> +					    bayer[(height - y) * width + x];
> +				}
> +			}
> +
> +			i++;
> +		}
> +
> +		j++;
> +	}
> +
> +	/* blit in everything but the borders */
> +	for (y = 1; y < (height - 1); y++) {
> +		if (y & 1) {
> +			/* GBGBGB line */
> +			for (x = 1; x < (width - 1); x++) {
> +				rpos = (height - y) * width + x;
> +				wpos = y * width + x;
> +				ltpos = rpos - width;
> +				lbpos = rpos + width;
> +
> +				if (x & 1) {	/* blue is known */
> +					/* calculate red */
> +					rgb[(wpos) * 3 + 0] = STK11XX_AVG4(
> +						/*Rtl */ bayer[ltpos - 1],
> +						/*Rtr */ bayer[ltpos + 1],
> +						/*Rbl */ bayer[lbpos - 1],
> +						/*Rbr */ bayer[lbpos + 1]);
> +					/* calculate green */
> +					rgb[(wpos) * 3 + 1] = STK11XX_AVG4(
> +						/*Gt */ bayer[ltpos],
> +						/*Gl */ bayer[rpos - 1],
> +						/*Gb */ bayer[lbpos],
> +						/*Gr */ bayer[rpos + 1]);
> +				} else {	/* green is known */
> +					/* calculate red */
> +					rgb[(wpos) * 3 + 0] = STK11XX_AVG2(
> +						/*Rt */ bayer[ltpos],
> +						/*Rb */ bayer[lbpos]);
> +					/* calculate blue */
> +					rgb[(wpos) * 3 + 2] = STK11XX_AVG2(
> +						/*Bl */ bayer[rpos - 1],
> +						/*Br */ bayer[rpos + 1]);
> +				}
> +			}
> +		} else {
> +			/* RGRG line */
> +			for (x = 1; x < (width - 1); x++) {
> +				rpos = (height - y) * width + x;
> +				wpos = y * width + x;
> +				ltpos = rpos - width;
> +				lbpos = rpos + width;
> +
> +				if (x & 1) {	/* green is known */
> +					/* calculate red */
> +					rgb[(wpos) * 3 + 0] = STK11XX_AVG2(
> +						/*Rl */ bayer[rpos - 1],
> +						/*Rr */ bayer[rpos + 1]);
> +					/* calculate blue */
> +					rgb[(wpos) * 3 + 2] = STK11XX_AVG2(
> +						/*Bt */ bayer[ltpos],
> +						/*Bb */ bayer[lbpos]);
> +
> +				} else {	/* red is known */
> +					/* calculate blue */
> +					rgb[(wpos) * 3 + 2] = STK11XX_AVG4(
> +						/*Btl */ bayer[ltpos - 1],
> +						/*Btr */ bayer[ltpos + 1],
> +						/*Bbl */ bayer[lbpos - 1],
> +						/*Bbr */ bayer[lbpos + 1]);
> +					/* calculate green */
> +					rgb[(wpos) * 3 + 1] = STK11XX_AVG4(
> +						/*Gt */ bayer[ltpos],
> +						/*Gl */ bayer[rpos - 1],
> +						/*Gb */ bayer[lbpos],
> +						/*Gr */ bayer[rpos + 1]);
> +				}
> +			}
> +		}
> +	}
> +
> +	for (i = 0; i < runlength; i++) {
> +		if (i < width) {
> +			/* top border: we have certain red and green pixels */
> +			if ((i & 1) == 1) {
> +				/* red, we use avg4(bot, bot, l-bot, l) */
> +				rgb[i * 3] = STK11XX_AVG4(
> +					rgb[(i + width) * 3],
> +					rgb[(i + width) * 3],
> +					rgb[(i + width - 1) * 3],
> +					rgb[(i - 1) * 3]);
> +			} else {
> +				/* green, we use avg4(bot, bot, r-bot, r) */
> +				rgb[i * 3 + 1] = STK11XX_AVG4(
> +					rgb[(i + width) * 3 + 1],
> +					rgb[(i + width) * 3 + 1],
> +					rgb[(i + width + 1) * 3 + 1],
> +					rgb[(i + 1) * 3 + 1]);
> +			}
> +			/* blue has to be calculated for every pixel, we'll
> +			   use bottom and one more bottom */
> +			rgb[i * 3 + 2] = STK11XX_AVG2(rgb[(i + width) * 3 + 2],
> +					rgb[(i + width * 2) * 3 + 2]);
> +
> +			/* bottom border: we have green and blue pixels for
> +			   sure */
> +			if ((i & 1) == 1) {
> +				/* green, we use avg4(top, top, l-top, l) */
> +				rgb[lastrow + i * 3 + 1] = STK11XX_AVG4(
> +					rgb[lastrow + (i - width) * 3 + 1],
> +					rgb[lastrow + (i - width) * 3 + 1],
> +					rgb[lastrow + (i - width - 1) * 3 + 1],
> +					rgb[lastrow + (i - 1) * 3 + 1]);
> +			} else {
> +				/* blue, we use avg4(top, top, r-top, r) */
> +				rgb[lastrow + i * 3 + 2] = STK11XX_AVG4(
> +					rgb[lastrow + (i - width) * 3 + 2],
> +					rgb[lastrow + (i - width) * 3 + 2],
> +					rgb[lastrow + (i - width + 1) * 3 + 2],
> +					rgb[lastrow + (i + 1) * 3 + 2]);
> +			}
> +			/* red has to be calculated for every pixel, we'll use
> +			   top and another top */
> +			rgb[lastrow + i * 3] = STK11XX_AVG2(
> +					rgb[lastrow + (i - width) * 3],
> +					rgb[lastrow + (i - width * 2) * 3]);
> +
> +		}
> +		if (i < height) {	/* the left and right borders */
> +			/* left border */
> +			if ((i & 1) == 0) {
> +				/* calc green, just avg right and bottom */
> +				rgb[(i * width) * 3 + 1] = STK11XX_AVG2(
> +					rgb[(i * width + 1) * 3 + 1],
> +					rgb[((i + 1) * width) * 3 + 1]);
> +				/* calc blue, avg right and right bottom */
> +				rgb[(i * width) * 3 + 2] = STK11XX_AVG2(
> +					rgb[(i * width + 1) * 3 + 2],
> +					rgb[((i + 1) * width + 1) * 3 + 2]);
> +			} else {
> +				/* calc red, 2x top , 1xtopright, 1xright */
> +				rgb[(i * width) * 3] = STK11XX_AVG4(
> +					rgb[((i - 1) * width) * 3],
> +					rgb[((i - 1) * width) * 3],
> +					rgb[((i - 1) * width + 1) * 3],
> +					rgb[(i * width + 1) * 3]);
> +				/* calc blue, avg top and right */
> +				rgb[(i * width) * 3 + 2] = STK11XX_AVG2(
> +					rgb[((i - 1) * width) * 3 + 2],
> +					rgb[(i * width + 1) * 3 + 2]);
> +			}
> +			/* right border */
> +			if ((i & 1) == 0) {
> +				/* calc red, take left and bottom left */
> +				rgb[lastcolumn + (i * width) * 3] =STK11XX_AVG2(
> +					rgb[lastcolumn + (i * width - 1) * 3],
> +					rgb[lastcolumn + ((i+1)*width-1) * 3]);
> +				/* calc blue, left and bottom */
> +				rgb[lastcolumn + (i * width) * 3 + 2] =
> +				    STK11XX_AVG2(
> +					rgb[lastcolumn + (i*width - 1) * 3 + 2],
> +					rgb[lastcolumn + ((i+1)*width)*3 + 2]);
> +			} else {	/* i&1 == 1 */
> +				/* calc red, top and left */
> +				rgb[lastcolumn + (i * width) * 3] =STK11XX_AVG2(
> +					rgb[lastcolumn +((i-1)*width - 1) * 3],
> +					rgb[lastcolumn + (i * width - 1) * 3]);
> +				/* calc green, 2xtop, topleft, left */
> +				rgb[lastcolumn + (i * width) * 3 + 1] =
> +				    STK11XX_AVG4(
> +					rgb[lastcolumn + ((i-1)*width) * 3 + 1],
> +					rgb[lastcolumn + ((i-1)*width) * 3 + 1],
> +					rgb[lastcolumn + ((i-1)*width-1)*3 + 1],
> +					rgb[lastcolumn + (i*width-1) * 3 + 1]);
> +			}
> +
> +		}
> +
> +	}
> +
> +}
> +
> +static void stk11xx_resize_image(u8 *out, const u8 *in,
> +		unsigned int width, unsigned int height, unsigned int factor)

scaling in kernelspace? is there anything which is against doing that
in userspace (where it should be done)?
When using Xvideo this might be done in hardware too without burning
any CPU cycles for scaling.

> +{
> +	unsigned int x, y, nwidth, nheight;
> +
> +	nheight = height / factor;
> +	nwidth = width / factor;
> +
> +	for (y = 0; y < nheight; y++) {
> +		for (x = 0; x < nwidth; x++) {
> +			/* R */
> +			out[y * nwidth * 3 + x * 3 + 0] =
> +			    in[y * factor * width * 3 + x * factor * 3 + 0];
> +			/* G */
> +			out[y * nwidth * 3 + x * 3 + 1] =
> +			    in[y * factor * width * 3 + x * factor * 3 + 1];
> +			/* B */
> +			out[y * nwidth * 3 + x * 3 + 2] =
> +			    in[y * factor * width * 3 + x * factor * 3 + 2];
> +		}
> +	}
> +}
> +
> +static void stk11xx_correct_brightness(u8 *rgb, unsigned int width,
> +				unsigned int height, int brightness)
> +{

same here, why do you want to have that in kernelspace?

> +	unsigned int i;
> +
> +	for (i = 0; i < width * height; i++) {
> +		brightness = min_t(int, brightness, min(255 - rgb[i],
> +			min(255 - rgb[i + 1], 255 - rgb[i + 2])));
> +		brightness = max(brightness, -min_t(int, rgb[i],
> +			min(rgb[i + 1], rgb[i + 2])));
> +
> +		rgb[i] = rgb[i] + brightness;
> +		rgb[i + 1] = rgb[i + 1] + brightness;
> +		rgb[i + 2] = rgb[i + 2] + brightness;
> +	}
> +}
> +
> +static int stk11xx_decompress(struct stk11xx *dev)
> +{
> +	struct stk11xx_frame_buf *framebuf = dev->read_frame;
> +	void *data, *image = dev->image_data;
> +	void *decompress = dev->decompress_data;
> +	unsigned int width, height, factor;
> +
> +	if (framebuf == NULL)
> +		return -EFAULT;
> +
> +	image += dev->images[dev->fill_image].offset;
> +
> +	data = framebuf->data;
> +
> +	switch (dev->resolution) {
> +	case STK11XX_80x60:
> +		factor = 8;
> +		width = stk11xx_image_sizes[STK11XX_640x480].x;
> +		height = stk11xx_image_sizes[STK11XX_640x480].y;
> +		break;
> +
> +	case STK11XX_160x120:
> +		factor = 4;
> +		width = stk11xx_image_sizes[STK11XX_640x480].x;
> +		height = stk11xx_image_sizes[STK11XX_640x480].y;
> +		break;
> +
> +	case STK11XX_320x240:
> +		factor = 2;
> +		width = stk11xx_image_sizes[STK11XX_640x480].x;
> +		height = stk11xx_image_sizes[STK11XX_640x480].y;
> +		break;
> +
> +	case STK11XX_640x480:
> +		factor = 1;
> +		width = stk11xx_image_sizes[STK11XX_640x480].x;
> +		height = stk11xx_image_sizes[STK11XX_640x480].y;
> +		break;
> +
> +	case STK11XX_800x600:
> +		factor = 1;
> +		width = stk11xx_image_sizes[STK11XX_1280x1024].x;
> +		height = stk11xx_image_sizes[STK11XX_1280x1024].y;
> +		break;
> +
> +	case STK11XX_1024x758:
> +		factor = 1;
> +		width = stk11xx_image_sizes[STK11XX_1280x1024].x;
> +		height = stk11xx_image_sizes[STK11XX_1280x1024].y;
> +		break;
> +
> +	case STK11XX_1280x1024:
> +		factor = 1;
> +		width = stk11xx_image_sizes[STK11XX_1280x1024].x;
> +		height = stk11xx_image_sizes[STK11XX_1280x1024].y;
> +		break;
> +
> +	default:
> +		return -EFAULT;
> +	}
> +
> +	stk11xx_bayer_to_rgb(decompress, data, width, height);
> +
> +	stk11xx_resize_image(image, decompress, width, height, factor);
> +
> +	stk11xx_correct_brightness(image, width / factor, height / factor,
> +				   dev->vsettings.brightness - 200);
> +
> +	return 0;
> +}
> +
> +/*
> + * Device
> + */
> +
> +static int stk11xx_setting_camera(struct stk11xx *dev);
> +
> +/*
> + * called when a frame is ready to prepare the next frame
> + */
> +static int stk11xx_next_frame(struct stk11xx *dev)
> +{
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	STK_STREAM("Select next frame\n");
> +
> +	spin_lock_irqsave(&dev->spinlock, flags);
> +
> +	if (dev->fill_frame != NULL) {
> +		if (dev->full_frames == NULL) {
> +			dev->full_frames = dev->fill_frame;
> +			dev->full_frames_tail = dev->full_frames;
> +		} else {
> +			dev->full_frames_tail->next = dev->fill_frame;
> +			dev->full_frames_tail = dev->fill_frame;
> +		}
> +	}
> +
> +	if (dev->empty_frames != NULL) {
> +		dev->fill_frame = dev->empty_frames;
> +		dev->empty_frames = dev->empty_frames->next;
> +	} else {
> +		if (dev->full_frames == NULL) {
> +			dev_err(&dev->udev->dev, "neither empty or full frames "
> +					"available!\n");
> +			spin_unlock_irqrestore(&dev->spinlock, flags);
> +			return -EINVAL;
> +		}
> +
> +		dev->fill_frame = dev->full_frames;
> +		dev->full_frames = dev->full_frames->next;
> +
> +		ret = 1;
> +	}
> +
> +	dev->fill_frame->next = NULL;
> +
> +	spin_unlock_irqrestore(&dev->spinlock, flags);
> +
> +	return ret;
> +}
> +
> +/*
> + * This function is called as an URB transfert is complete (Isochronous
> pipe).
> + * So, the traitement is done in interrupt time, so it has be fast, not
> crash,
> + * ans not stall. Neat.
> + */
> +static void stk11xx_isoc_handler(struct urb *urb)

there was an API change, to be compatible with <kernel 2.6.19 you need
to add another argument here (the v4l-dvb tree is supposed to be
downward compatible)

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
static void stk11xx_isoc_handler(struct urb *urb, struct pt_regs *regs)
#else
static void stk11xx_isoc_handler(struct urb *urb)
#endif

(it's just for compatibility if someone wants to upgrade a 2.6.16
kernel with the latest v4l-dvb tree, it will get parsed out for
upstream)

> +{
> +	struct stk11xx *dev = urb->context;
> +	struct stk11xx_frame_buf *framebuf;
> +	unsigned char *fill = NULL, *iso_buf = NULL;
> +	unsigned int i;
> +	int ret, skip, awake = 0, framestatus, framelen;
> +
> +	STK_STREAM("Isoc handler\n");
> +
> +	if (dev == NULL) {
> +		dev_err(&dev->udev->dev, "isoc_handler called with NULL "
> +				"device\n");
> +		return;
> +	}
> +
> +	if (urb->status == -ENOENT || urb->status == -ECONNRESET) {
> +		dev_dbg(&dev->udev->dev, "URB unlinked synchronuously\n");
> +		return;
> +	}
> +
> +	if (urb->status != -EINPROGRESS && urb->status != 0) {
> +		dev_err(&dev->udev->dev, "isoc_handler called with status %d\n",
> +				urb->status);
> +
> +		wake_up_interruptible(&dev->wait_frame);
> +
> +		urb->dev = dev->udev;
> +		ret = usb_submit_urb(urb, GFP_ATOMIC);
> +		if (ret != 0)
> +			dev_err(&dev->udev->dev, "error (%d) re-submitting urb "
> +				"in isoc_handler\n", ret);
> +
> +		return;
> +	}
> +
> +	framebuf = dev->fill_frame;
> +	if (framebuf == NULL) {
> +		dev_err(&dev->udev->dev, "isoc_handler without valid fill "
> +				"frame\n");
> +
> +		wake_up_interruptible(&dev->wait_frame);
> +
> +		urb->dev = dev->udev;
> +		ret = usb_submit_urb(urb, GFP_ATOMIC);
> +
> +		if (ret != 0)
> +			dev_err(&dev->udev->dev, "error (%d) re-submitting urb "
> +					"in isoc_handler\n", ret);
> +
> +		return;
> +	} else
> +		fill = framebuf->data + framebuf->filled;
> +
> +	/* Reset ISOC error counter */
> +	dev->visoc_errors = 0;
> +
> +	/* Compact data */
> +	for (i = 0; i < urb->number_of_packets; i++) {
> +		framestatus = urb->iso_frame_desc[i].status;
> +		framelen = urb->iso_frame_desc[i].actual_length;
> +		iso_buf = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
> +
> +		if (framestatus == 0) {
> +			skip = 4;
> +
> +			if (framelen > 4) {
> +	/* we found something informational from there */
> +	/* the isoc frames have two type of headers */
> +	/* type1: 00 xx 00 00 or 20 xx 00 00 */
> +	/* type2: 80 xx 00 00 00 00 00 00 or a0 xx 00 00 00 00 00 00 */
> +	/* xx is a sequencer which has never been seen over 0x3f */
> +
> +	/* imho data written down looks like bayer, i see similarities after */
> +				/* every 640 bytes */
> +				if (*iso_buf & 0x80) {
> +					skip = 8;
> +				}
> +
> +				if (framelen - skip + framebuf->filled >
> +						dev->frame_size) {
> +					dev_err(&dev->udev->dev, "frame buffer "
> +							"overflow\n");
> +				} else {
> +					memcpy(fill, iso_buf + skip,
> +					       framelen - skip);
> +					fill += framelen - skip;
> +				}
> +
> +				framebuf->filled += framelen - skip;
> +			}
> +
> +			STK_STREAM("URB : Length = %d - Skip = %d - Buffer "
> +					"size = %d\n", framelen, skip,
> +					framebuf->filled);
> +
> +			if (framelen == 4) {
> +				if (framebuf->filled > 0) {
> +					stk11xx_next_frame(dev);
> +
> +					awake = 1;
> +					framebuf = dev->fill_frame;
> +					framebuf->filled = 0;
> +					fill = framebuf->data;
> +				}
> +			}
> +		} else
> +			dev_err(&dev->udev->dev, "iso frame %d has error %d\n",
> +					i, framestatus);
> +	}
> +
> +	if (awake == 1)
> +		wake_up_interruptible(&dev->wait_frame);
> +
> +	urb->dev = dev->udev;
> +
> +	ret = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (ret != 0)
> +		dev_err(&dev->udev->dev, "error (%d) re-submitting urb in "
> +				"isoc_handler.\n", ret);
> +}
> +
> +static void stk11xx_isoc_cleanup(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +
> +	dev_dbg(&dev->udev->dev, "isoc cleanup\n");
> +
> +	if (dev->isoc_init_ok == 0)
> +		return;
> +
> +	/* Unlinking ISOC buffers */
> +	for (i = 0; i < MAX_ISO_BUFS; i++) {
> +		struct urb *urb;
> +
> +		urb = dev->isobuf[i].urb;
> +
> +		if (urb != 0) {
> +			if (dev->isoc_init_ok)
> +				usb_kill_urb(urb);
> +
> +			usb_free_urb(urb);
> +			dev->isobuf[i].urb = NULL;
> +		}
> +	}
> +
> +	/* All is done */
> +	dev->isoc_init_ok = 0;
> +}
> +
> +static int stk11xx_isoc_init(struct stk11xx *dev)
> +{
> +	struct usb_device *udev;
> +	struct urb *urb;
> +	unsigned int i, j;
> +	int ret = 0;
> +
> +	if (dev->isoc_init_ok)
> +		return 0;
> +
> +	udev = dev->udev;
> +
> +	dev_dbg(&udev->dev, "%s\n", __FUNCTION__);
> +
> +	/* Allocate URB structure */
> +	for (i = 0; i < MAX_ISO_BUFS; i++) {
> +		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
> +
> +		if (urb == NULL) {
> +			dev_err(&udev->dev, "failed to allocate URB %d\n", i);
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		dev->isobuf[i].urb = urb;
> +	}
> +
> +	if (ret) {
> +		while (i >= 0) {
> +			if (dev->isobuf[i].urb != NULL)
> +				usb_free_urb(dev->isobuf[i].urb);
> +
> +			dev->isobuf[i].urb = NULL;
> +			i--;
> +		}
> +
> +		return ret;
> +	}
> +	/* Init URB structure */
> +	for (i = 0; i < MAX_ISO_BUFS; i++) {
> +		urb = dev->isobuf[i].urb;
> +
> +		urb->interval = 1;
> +		urb->dev = udev;
> +		urb->pipe = usb_rcvisocpipe(udev, dev->isoc_in_endpointAddr);
> +		urb->transfer_flags = URB_ISO_ASAP;
> +		urb->transfer_buffer = dev->isobuf[i].data;
> +		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
> +		urb->complete = stk11xx_isoc_handler;
> +		urb->context = dev;
> +		urb->start_frame = 0;
> +		urb->number_of_packets = ISO_FRAMES_PER_DESC;
> +
> +		for (j = 0; j < ISO_FRAMES_PER_DESC; j++) {
> +			urb->iso_frame_desc[j].offset = j * ISO_MAX_FRAME_SIZE;
> +			urb->iso_frame_desc[j].length = ISO_MAX_FRAME_SIZE;
> +		}
> +	}
> +
> +	dev_dbg(&dev->udev->dev, "isoc_in_size = %zx, "
> +			"isoc_in_endpointAddr = %x\n",
> +			dev->isoc_in_size, dev->isoc_in_endpointAddr);
> +
> +	/* Link */
> +	for (i = 0; i < MAX_ISO_BUFS; i++) {
> +		ret = usb_submit_urb(dev->isobuf[i].urb, GFP_KERNEL);
> +
> +		if (ret)
> +			dev_err(&dev->udev->dev, "isoc_init submit_urb %d "
> +					"failed with error %d\n", i, ret);
> +		else
> +			dev_dbg(&dev->udev->dev, "URB 0x%p submitted\n",
> +					dev->isobuf[i].urb);
> +	}
> +
> +	/* All is done */
> +	dev->isoc_init_ok = 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * When we configure the stk11xx, this function is used to check the device
> + * status.
> + *   - If the read value is 0x00, then the device isn't ready.
> + *   - If the read value is 0x04, then the device is ready.
> + *   - If the read value is other, then the device is misconfigured.
> + */
> +static int stk11xx_check_device(struct stk11xx *dev, int nbr)
> +{
> +	unsigned int i;
> +	int value;
> +
> +	for (i = 0; i < nbr; i++) {
> +		stk11xx_read_registry(dev, 0x201, &value);
> +
> +		switch (value) {
> +		case 0x00:
> +			break;
> +		case 0x01:
> +		case 0x04:
> +			return 1;
> +		default:
> +			dev_err(&dev->udev->dev, "check device return error "
> +					"(0x201 = %02X)\n", value);
> +			return -1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int stk11xx_camera_off(struct stk11xx *dev)
> +{
> +	struct usb_device *udev = dev->udev;
> +	int ret;
> +
> +	ret = usb_set_interface(udev, 0, 0);
> +
> +	if (ret < 0)
> +		dev_err(&udev->dev, "usb_set_interface failed\n");
> +
> +	return 0;
> +}
> +
> +/*
> + * STK-1125 API
> + */
> +
> +static int stk1125_load_microcode(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +	const u8 *values_204, *values_205;
> +	int retok, value;
> +
> +	/* From 80x60 to 640x480 */
> +	const u8 values_1_204[] = {
> +		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
> +		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,
> +		0x18, 0x32, 0x19, 0x1a, 0x03, 0x1b, 0x16, 0x33, 0x34, 0x41,
> +		0x96, 0x3d, 0x69, 0x3a, 0x8e, 0x3c, 0x8f, 0x8b, 0x8c, 0x94,
> +		0x95, 0x40, 0x29, 0x0f, 0xa5, 0x1e, 0xa9, 0xaa, 0xab, 0x90,
> +		0x91, 0x9f, 0xa0, 0x24, 0x25, 0x26, 0x14, 0x2a, 0x2b
> +	};
> +	const u8 values_1_205[] = {
> +		0x45, 0x80, 0x01, 0x7d, 0x80, 0x00, 0x00, 0x80, 0x80, 0x80,
> +		0x50, 0x93, 0x00, 0x81, 0x20, 0x45, 0x00, 0x00, 0x00, 0x24,
> +		0xc4, 0xb6, 0x00, 0x3c, 0x36, 0x00, 0x07, 0xe2, 0xbf, 0x00,
> +		0x04, 0x19, 0x40, 0x0d, 0x00, 0x73, 0xdf, 0x06, 0x20, 0x88,
> +		0x88, 0xc1, 0x3f, 0x42, 0x80, 0x04, 0xb8, 0x92, 0x0a, 0x00,
> +		0x00, 0x00, 0x00, 0x68, 0x5c, 0xc3, 0x2e, 0x00, 0x00
> +	};
> +
> +	/* From 800x600 to 1280x1024 */
> +	const u8 values_2_204[] = {
> +		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
> +		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,
> +		0x18, 0x32, 0x19, 0x1a, 0x03, 0x1b, 0x16, 0x33, 0x34, 0x41,
> +		0x96, 0x3d, 0x69, 0x3a, 0x8e, 0x3c, 0x8f, 0x8b, 0x8c, 0x94,
> +		0x95, 0x40, 0x29, 0x0f, 0xa5, 0x1e, 0xa9, 0xaa, 0xab, 0x90,
> +		0x91, 0x9f, 0xa0, 0x24, 0x25, 0x26, 0x14, 0x2a, 0x2b
> +	};
> +	const u8 values_2_205[] = {
> +		0x05, 0x80, 0x01, 0x7d, 0x80, 0x00, 0x00, 0x80, 0x80, 0x80,
> +		0x50, 0x93, 0x00, 0x81, 0x20, 0x05, 0x00, 0x00, 0x00, 0x1b,
> +		0xbb, 0xa4, 0x01, 0x81, 0x12, 0x00, 0x07, 0xe2, 0xbf, 0x00,
> +		0x04, 0x19, 0x40, 0x0d, 0x00, 0x73, 0xdf, 0x06, 0x20, 0x88,
> +		0x88, 0xc1, 0x3f, 0x42, 0x80, 0x04, 0xb8, 0x92, 0x0a, 0x00,
> +		0x00, 0x00, 0x00, 0x68, 0x5c, 0xc3, 0x2e, 0x00, 0x00
> +	};
> +
> +	/* From the resolution */
> +	switch (dev->resolution) {
> +	case STK11XX_1280x1024:
> +	case STK11XX_1024x758:
> +	case STK11XX_800x600:
> +		values_204 = values_2_204;
> +		values_205 = values_2_205;
> +		break;
> +
> +	case STK11XX_640x480:
> +	case STK11XX_320x240:
> +	case STK11XX_160x120:
> +	case STK11XX_80x60:
> +	default:
> +		values_204 = values_1_204;
> +		values_205 = values_1_205;
> +		break;
> +	}
> +
> +	for (i = 0; i < 59; i++) {
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +		stk11xx_write_registry(dev, 0x0204, values_204[i]);
> +		stk11xx_write_registry(dev, 0x0205, values_205[i]);
> +		stk11xx_write_registry(dev, 0x0200, 0x0001);
> +
> +		retok = stk11xx_check_device(dev, 500);
> +		if (retok != 1) {
> +			dev_err(&dev->udev->dev, "load microcode fail\n");
> +			return -1;
> +		}
> +
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	}
> +
> +	stk11xx_check_device(dev, 500);
> +
> +	return 0;
> +}
> +
> +/*
> + * The configuration of device is composed of 11 steps.
> + * This function is called by the initialization process.
> + *
> + * We don't know the meaning of these steps! We only replay the USB log.
> + *
> + * The steps 0 to 9 are called during the initialization.
> + * Then, the driver choose the last step :
> + *   10 : for a resolution from 80x60 to 640x480
> + *   11 : for a resolution from 800x600 to 1280x1024
> + */
> +static int stk1125_configure_device(struct stk11xx *dev, int step)
> +{
> +	int value;
> +
> +	/*      0,    1,    2,    3,    4,    5,    6,    7,    8,    9,
> +		    10,   11 */
> +
> +	const u8 values_001B[] = {
> +		0x0E, 0x03, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E,
> +		    0x0E, 0x0E
> +	};
> +	const u8 values_001C[] = {
> +		0x06, 0x02, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46,
> +		    0x46, 0x0E
> +	};
> +	const u8 values_0202[] = {
> +		0x1E, 0x0A, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E,
> +		    0x1E, 0x1E
> +	};
> +	const u8 values_0110[] = {
> +		0x07, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x3E, 0x00, 0x00, 0x00,
> +		    0x00, 0x00
> +	};
> +	const u8 values_0112[] = {
> +		0x07, 0x00, 0x00, 0x00, 0x00, 0x09, 0x09, 0x00, 0x00, 0x00,
> +		    0x00, 0x00
> +	};
> +	const u8 values_0114[] = {
> +		0x87, 0x80, 0x80, 0x80, 0x80, 0xBE, 0xBE, 0x80, 0x80, 0x80,
> +		    0x80, 0x00
> +	};
> +	const u8 values_0115[] = {
> +		0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
> +		    0x02, 0x05
> +	};
> +	const u8 values_0116[] = {
> +		0xE7, 0xE0, 0xE0, 0xE0, 0xE0, 0xE9, 0xE9, 0xE0, 0xE0, 0xE0,
> +		    0xE0, 0x00
> +	};
> +	const u8 values_0117[] = {
> +		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +		    0x01, 0x04
> +	};
> +	const u8 values_0100[] = {
> +		0x20, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21,
> +		    0x21, 0x21
> +	};
> +
> +	dev_dbg(&dev->udev->dev, "stk1125_configure_device: %d\n", step);
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0003, 0x0080);
> +	stk11xx_write_registry(dev, 0x0005, 0x0000);
> +
> +	stk11xx_write_registry(dev, 0x0007, 0x0003);
> +	stk11xx_write_registry(dev, 0x000d, 0x0000);
> +	stk11xx_write_registry(dev, 0x000f, 0x0002);
> +	stk11xx_write_registry(dev, 0x0300, 0x0012);
> +	stk11xx_write_registry(dev, 0x0350, 0x0041);
> +
> +	stk11xx_write_registry(dev, 0x0351, 0x0000);
> +	stk11xx_write_registry(dev, 0x0352, 0x0000);
> +	stk11xx_write_registry(dev, 0x0353, 0x0000);
> +	stk11xx_write_registry(dev, 0x0018, 0x0010);
> +	stk11xx_write_registry(dev, 0x0019, 0x0000);
> +
> +	stk11xx_write_registry(dev, 0x001b, values_001B[step]);
> +	stk11xx_write_registry(dev, 0x001c, values_001C[step]);
> +	stk11xx_write_registry(dev, 0x0300, 0x0080);
> +	stk11xx_write_registry(dev, 0x001a, 0x0004);
> +	stk11xx_write_registry(dev, 0x0202, values_0202[step]);
> +
> +	stk11xx_write_registry(dev, 0x0110, values_0110[step]);
> +	stk11xx_write_registry(dev, 0x0111, 0x0000);
> +	stk11xx_write_registry(dev, 0x0112, values_0112[step]);
> +	stk11xx_write_registry(dev, 0x0113, 0x0000);
> +	stk11xx_write_registry(dev, 0x0114, values_0114[step]);
> +
> +	stk11xx_write_registry(dev, 0x0115, values_0115[step]);
> +	stk11xx_write_registry(dev, 0x0116, values_0116[step]);
> +	stk11xx_write_registry(dev, 0x0117, values_0117[step]);
> +
> +	stk11xx_read_registry(dev, 0x0100, &value);
> +	stk11xx_write_registry(dev, 0x0100, values_0100[step]);
> +
> +	stk11xx_write_registry(dev, 0x0200, 0x0080);
> +	stk11xx_write_registry(dev, 0x0200, 0x0000);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +	switch (step) {
> +	case 0:
> +		stk11xx_write_registry(dev, 0x0203, 0x0040);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0041);
> +		stk11xx_write_registry(dev, 0x0205, 0x0001);
> +		stk11xx_write_registry(dev, 0x0204, 0x001C);
> +		stk11xx_write_registry(dev, 0x0205, 0x0002);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 1:
> +		stk11xx_write_registry(dev, 0x0203, 0x0022);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0027);
> +		stk11xx_write_registry(dev, 0x0205, 0x00A5);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 2:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00BF);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 3:
> +		stk11xx_write_registry(dev, 0x0203, 0x0042);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0024);
> +		stk11xx_write_registry(dev, 0x0205, 0x00A5);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 4:
> +		stk11xx_write_registry(dev, 0x0203, 0x0042);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00E0);
> +		stk11xx_write_registry(dev, 0x0204, 0x0024);
> +		stk11xx_write_registry(dev, 0x0205, 0x00A5);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 5:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00FF);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 6:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00FF);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 7:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00B7);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 8:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk1125_load_microcode(dev);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0080);
> +		stk11xx_write_registry(dev, 0x0200, 0x0000);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0001);
> +		stk11xx_write_registry(dev, 0x0203, 0x00A0);
> +
> +		break;
> +
> +	case 9:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk1125_load_microcode(dev);
> +
> +		stk11xx_write_registry(dev, 0x0104, 0x0000);
> +		stk11xx_write_registry(dev, 0x0105, 0x0000);
> +		stk11xx_write_registry(dev, 0x0106, 0x0000);
> +
> +		break;
> +
> +	case 10:
> +	case 11:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk1125_load_microcode(dev);
> +
> +		stk11xx_write_registry(dev, 0x0106, 0x0000);
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_write_registry(dev, 0x0204, 0x002A);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +		stk11xx_write_registry(dev, 0x0200, 0x0001);
> +		stk11xx_check_device(dev, 500);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_write_registry(dev, 0x0204, 0x002B);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +		stk11xx_write_registry(dev, 0x0200, 0x0001);
> +		stk11xx_check_device(dev, 500);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int stk1125_camera_asleep(struct stk11xx *dev)
> +{
> +	int value;
> +
> +	stk11xx_read_registry(dev, 0x0104, &value);
> +	stk11xx_read_registry(dev, 0x0105, &value);
> +	stk11xx_read_registry(dev, 0x0106, &value);
> +

why do you read these values (this is also something in the ongoing
code I see, the read value just gets overwritten all the time)?

> +	stk11xx_write_registry(dev, 0x0100, 0x0021);
> +	stk11xx_write_registry(dev, 0x0116, 0x0000);
> +	stk11xx_write_registry(dev, 0x0117, 0x0000);
> +	stk11xx_write_registry(dev, 0x0018, 0x0000);
> +
> +	stk11xx_read_registry(dev, 0x0000, &value);
> +	stk11xx_write_registry(dev, 0x0000, 0x004C);
> +
> +	return 0;
> +}
> +
> +/*
> + * This functions permits to modify the settings :
> + *   - brightness
> + *   - contrast
> + *   - white balance
> + *   - ...
> + *
> + * 0x204 = 0xA1 : unknown (by default 0x00)
> + * 0x204 = 0x10 : contrast (by default 0x7c)
> + * 0x204 = 0x04 : Mode (unknown) (by default 0x00) (=> already looked 0x01
> and 0x02)
> + * 0x204 = 0x00 : brightness / white balance (by default 0x00)
> + * 0x204 = 0x2E : Fps MSB (by default 0x01)
> + * 0x204 = 0x2D : Fps LSB (by default 0x00)
> + *
> + * 0x2E | 0x2D | Nbr fps
> + * -----+------+--------
> + * 0x00 | 0x00 |  30
> + * 0x01 | 0x00 |  20
> + * 0x02 | 0x00 |  15
> + * 0x03 | 0x00 |  12
> + * 0x04 | 0x00 |  10
> + */
> +static int stk1125_setting_camera(struct stk11xx *dev)
> +{
> +	int ret;
> +
> +	stk11xx_write_registry(dev, 0x0200, 0x0000);
> +
> +	/* Unknown register */
> +	stk11xx_write_registry(dev, 0x0204, 0x00A1);
> +	stk11xx_write_registry(dev, 0x0205, 0x0000);
> +
> +	/* Contrast register */
> +	stk11xx_write_registry(dev, 0x0204, 0x0010);
> +	stk11xx_write_registry(dev, 0x0205, dev->vsettings.contrast);
> +
> +	/* Unknown register */
> +	stk11xx_write_registry(dev, 0x0204, 0x0004);
> +	stk11xx_write_registry(dev, 0x0205, 0x0000);
> +
> +	/* Whiteness register */
> +	stk11xx_write_registry(dev, 0x0204, 0x0000);
> +	stk11xx_write_registry(dev, 0x0205, dev->vsettings.whiteness);
> +
> +	/* FPS register */
> +	switch (dev->vsettings.fps) {
> +	case 10:
> +		stk11xx_write_registry(dev, 0x0204, 0x002E);
> +		stk11xx_write_registry(dev, 0x0205, 0x0004);
> +		stk11xx_write_registry(dev, 0x0204, 0x002D);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +		break;
> +
> +	case 15:
> +		stk11xx_write_registry(dev, 0x0204, 0x002E);
> +		stk11xx_write_registry(dev, 0x0205, 0x0002);
> +		stk11xx_write_registry(dev, 0x0204, 0x002D);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +		break;
> +
> +	case 20:
> +		stk11xx_write_registry(dev, 0x0204, 0x002E);
> +		stk11xx_write_registry(dev, 0x0205, 0x0001);
> +		stk11xx_write_registry(dev, 0x0204, 0x002D);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +		break;
> +
> +	case 30:
> +		stk11xx_write_registry(dev, 0x0204, 0x002E);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +		stk11xx_write_registry(dev, 0x0204, 0x002D);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +		break;
> +
> +	default:
> +		stk11xx_write_registry(dev, 0x0204, 0x002E);
> +		stk11xx_write_registry(dev, 0x0205, 0x0001);
> +		stk11xx_write_registry(dev, 0x0204, 0x002D);
> +		stk11xx_write_registry(dev, 0x0205, 0x0000);
> +	}
> +
> +	stk11xx_write_registry(dev, 0x0200, 0x0006);
> +
> +	dev_dbg(&dev->udev->dev, "set contrast: %d, whiteness: %d, "
> +			"brightness: %d\n", dev->vsettings.contrast,
> +			dev->vsettings.whiteness, dev->vsettings.brightness);
> +
> +	ret = stk11xx_check_device(dev, 500);
> +	if (!ret)
> +		dev_dbg(&dev->udev->dev, "find not 0x4 ... seems OK\n");
> +
> +	return 0;
> +}
> +
> +static int stk1125_init_camera(struct stk11xx *dev)
> +{
> +	int value;
> +
> +	stk1125_camera_asleep(dev);
> +
> +	stk11xx_set_feature(dev, 0);
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x00E0);
> +	stk11xx_write_registry(dev, 0x0002, 0x00E8);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk1125_configure_device(dev, 9);
> +
> +	stk11xx_camera_off(dev);
> +
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0204, 0x002a);
> +	stk11xx_write_registry(dev, 0x0205, 0x0000);
> +	stk11xx_write_registry(dev, 0x0200, 0x0001);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0204, 0x002B);
> +	stk11xx_write_registry(dev, 0x0205, 0x0000);
> +	stk11xx_write_registry(dev, 0x0200, 0x0001);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +	stk1125_setting_camera(dev);
> +
> +	return 0;
> +}
> +
> +static int stk1125_start_stream(struct stk11xx *dev)
> +{
> +	int value, value_116, value_117;
> +
> +	stk11xx_read_registry(dev, 0x0116, &value_116);
> +	stk11xx_read_registry(dev, 0x0117, &value_117);
> +
> +	stk11xx_write_registry(dev, 0x0116, 0x0000);
> +	stk11xx_write_registry(dev, 0x0117, 0x0000);
> +
> +	stk11xx_read_registry(dev, 0x0100, &value);	/* read 0x21 */
> +	stk11xx_write_registry(dev, 0x0100, 0x00A1);
> +
> +	stk11xx_write_registry(dev, 0x0116, value_116);
> +	stk11xx_write_registry(dev, 0x0117, value_117);
> +
> +	return 0;
> +}
> +
> +static int stk1125_reconf_camera(struct stk11xx *dev)
> +{
> +	int step;
> +
> +	switch (dev->resolution) {
> +	case STK11XX_1280x1024:
> +	case STK11XX_1024x758:
> +	case STK11XX_800x600:
> +		step = 11;
> +		break;
> +
> +	case STK11XX_640x480:
> +	case STK11XX_320x240:
> +	case STK11XX_160x120:
> +	case STK11XX_80x60:
> +	default:
> +		step = 10;
> +		break;
> +	}
> +
> +	stk1125_configure_device(dev, step);
> +
> +	stk11xx_setting_camera(dev);
> +
> +	return 0;
> +}
> +
> +static int stk1125_stop_stream(struct stk11xx *dev)
> +{
> +	int value;
> +
> +	stk11xx_read_registry(dev, 0x0100, &value);
> +	stk11xx_write_registry(dev, 0x0100, 0x0021);
> +
> +	return 0;
> +}
> +
> +/*
> + * STK-1135 API
> + */
> +
> +static int stk1135_load_microcode(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +	int retok, value;
> +
> +	const u8 values_204[] = {
> +		0x17, 0x19, 0xb4, 0xa6, 0x12, 0x13, 0x1e, 0x21, 0x24, 0x32,
> +		0x36, 0x39, 0x4d, 0x53, 0x5d, 0x5f, 0x60, 0x61, 0x62, 0x63,
> +		0x64, 0x65, 0x66, 0x82, 0x83, 0x85, 0x86, 0x89, 0x97, 0x98,
> +		0xad, 0xae, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbf, 0x48, 0xd8,
> +		0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f,
> +		0x80, 0x81, 0xd8, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c,
> +		0x7d, 0x7e, 0x7f, 0x80, 0x81, 0xd8, 0x76, 0x77, 0x78, 0x79,
> +		0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0x80, 0x81, 0x5c, 0xc0,
> +		0x59, 0x5a, 0x5b, 0xd4, 0x8e, 0x8f, 0x90, 0x91, 0x92, 0x93,
> +		0x94, 0x95, 0x96, 0xb3, 0x73, 0x06, 0x07, 0x0b, 0x15, 0x20,
> +		0x4e, 0x4f, 0x49, 0x4a, 0x4b, 0x4c, 0x46, 0x06, 0x07, 0xb9,
> +		0xba, 0xbb, 0xbc, 0x61, 0x62, 0x65, 0x66
> +	};
> +	const u8 values_205[] = {
> +		0x41, 0x41, 0x03, 0x06, 0x06, 0x08, 0x06, 0x00, 0x02, 0x69,
> +		0x35, 0x60, 0xfe, 0x1c, 0x04, 0x08, 0x08, 0x08, 0x08, 0x00,
> +		0x00, 0x10, 0x14, 0x01, 0x80, 0x0c, 0xb6, 0x00, 0x25, 0x25,
> +		0x3f, 0x24, 0x10, 0x07, 0xcc, 0x1f, 0x30, 0x02, 0x9c, 0x80,
> +		0x00, 0x0d, 0x18, 0x22, 0x2c, 0x3e, 0x4f, 0x6f, 0x8e, 0xac,
> +		0xc8, 0xe5, 0xa0, 0x00, 0x0d, 0x18, 0x22, 0x2c, 0x3e, 0x4f,
> +		0x6f, 0x8e, 0xac, 0xc8, 0xe5, 0xc0, 0x00, 0x0d, 0x18, 0x22,
> +		0x2c, 0x3e, 0x4f, 0x6f, 0x8e, 0xac, 0xc8, 0xe5, 0x70, 0x18,
> +		0x09, 0x07, 0x07, 0x3c, 0x3d, 0x95, 0x88, 0x89, 0x47, 0x9c,
> +		0x81, 0x9c, 0x3d, 0x76, 0x76, 0x01, 0xf3, 0x05, 0x00, 0x44,
> +		0x06, 0x0a, 0x96, 0x00, 0x7d, 0x00, 0x20, 0x01, 0xf3, 0x04,
> +		0xe4, 0x09, 0xc8, 0x08, 0x08, 0x10, 0x14
> +	};
> +
> +	for (i = 0; i < 59; i++) {
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +		stk11xx_write_registry(dev, 0x0204, values_204[i]);
> +		stk11xx_write_registry(dev, 0x0205, values_205[i]);
> +		stk11xx_write_registry(dev, 0x0200, 0x0001);
> +
> +		retok = stk11xx_check_device(dev, 500);
> +		if (retok != 1) {
> +			dev_err(&dev->udev->dev, "load microcode failed\n");
> +			return -1;
> +		}
> +
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	}
> +
> +	stk11xx_check_device(dev, 500);
> +
> +	return 0;
> +}
> +
> +/*
> + * The configuration of device is composed of 12 steps.
> + * This function is called by the initialization process.
> + *
> + * We don't know the meaning of these steps! We only replay the USB log.
> + */
> +static int stk1135_configure_device(struct stk11xx *dev, int step)
> +{
> +	int value;
> +
> +	/*      0,    1,    2,    3,    4,    5,    6,    7,    8,    9,
> +		    10,   11,   12,   13 */
> +
> +	const u8 values_001B[] = {
> +		0x0E, 0x03, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x07,
> +		    0x07, 0x07, 0x07, 0x07
> +	};
> +	const u8 values_001C[] = {
> +		0x06, 0x02, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x06, 0x06,
> +		    0x06, 0x06, 0x06, 0x07
> +	};
> +	const u8 values_0202[] = {
> +		0x1E, 0x0A, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E,
> +		    0x1E, 0x1E, 0x1E, 0x1E
> +	};
> +	const u8 values_0110[] = {
> +		0x07, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x3E, 0x00, 0x04, 0x00,
> +		    0x00, 0x00, 0x00, 0x00
> +	};
> +	const u8 values_0112[] = {
> +		0x07, 0x00, 0x00, 0x00, 0x00, 0x09, 0x09, 0x00, 0x04, 0x00,
> +		    0x00, 0x00, 0x00, 0x00
> +	};
> +	const u8 values_0114[] = {
> +		0x87, 0x80, 0x80, 0x80, 0x80, 0xBE, 0xBE, 0x80, 0x84, 0x80,
> +		    0x80, 0x80, 0x80, 0x80
> +	};
> +	const u8 values_0116[] = {
> +		0xE7, 0xE0, 0xE0, 0xE0, 0xE0, 0xE9, 0xE9, 0xE0, 0xE4, 0xE0,
> +		    0xE0, 0xE0, 0xE0, 0xE0
> +	};
> +	const u8 values_0100[] = {
> +		0x20, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x23, 0x20,
> +		    0x20, 0x20, 0x20, 0x20
> +	};
> +
> +	dev_dbg(&dev->udev->dev, "stk1135_configure_device: %d\n", step);
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0003, 0x0080);
> +	stk11xx_write_registry(dev, 0x0005, 0x0000);
> +
> +	stk11xx_write_registry(dev, 0x0007, 0x0003);
> +	stk11xx_write_registry(dev, 0x000d, 0x0000);
> +	stk11xx_write_registry(dev, 0x000f, 0x0002);
> +	stk11xx_write_registry(dev, 0x0300, 0x0012);
> +	stk11xx_write_registry(dev, 0x0350, 0x0041);
> +
> +	stk11xx_write_registry(dev, 0x0351, 0x0000);
> +	stk11xx_write_registry(dev, 0x0352, 0x0000);
> +	stk11xx_write_registry(dev, 0x0353, 0x0000);
> +	stk11xx_write_registry(dev, 0x0018, 0x0010);
> +	stk11xx_write_registry(dev, 0x0019, 0x0000);
> +
> +	stk11xx_write_registry(dev, 0x001b, values_001B[step]);
> +	stk11xx_write_registry(dev, 0x001c, values_001C[step]);
> +	stk11xx_write_registry(dev, 0x0300, 0x0080);
> +	stk11xx_write_registry(dev, 0x001a, 0x0004);
> +	stk11xx_write_registry(dev, 0x0202, values_0202[step]);
> +
> +	stk11xx_write_registry(dev, 0x0110, values_0110[step]);
> +	stk11xx_write_registry(dev, 0x0111, 0x0000);
> +	stk11xx_write_registry(dev, 0x0112, values_0112[step]);
> +	stk11xx_write_registry(dev, 0x0113, 0x0000);
> +	stk11xx_write_registry(dev, 0x0114, values_0114[step]);
> +

if possible some error checking would be nice here, if you unplug the
device you'll rely on the underlying subsystem to handle your errors I
don't think that's a good way to go.
Did you test unplugging your device while it's in use with mplayer/xawtv/..?

cheers,
Markus

> +	stk11xx_write_registry(dev, 0x0115, 0x0002);
> +	stk11xx_write_registry(dev, 0x0116, values_0116[step]);
> +	stk11xx_write_registry(dev, 0x0117, 0x0001);
> +
> +	stk11xx_read_registry(dev, 0x0100, &value);
> +	stk11xx_write_registry(dev, 0x0100, values_0100[step]);
> +
> +	stk11xx_write_registry(dev, 0x0200, 0x0080);
> +	stk11xx_write_registry(dev, 0x0200, 0x0000);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +	switch (step) {
> +	case 0:
> +		stk11xx_write_registry(dev, 0x0203, 0x0040);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0041);
> +		stk11xx_write_registry(dev, 0x0205, 0x0001);
> +		stk11xx_write_registry(dev, 0x0204, 0x001C);
> +		stk11xx_write_registry(dev, 0x0205, 0x0002);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 1:
> +		stk11xx_write_registry(dev, 0x0203, 0x0022);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0027);
> +		stk11xx_write_registry(dev, 0x0205, 0x00A5);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 2:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00BF);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 3:
> +		stk11xx_write_registry(dev, 0x0203, 0x0042);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0024);
> +		stk11xx_write_registry(dev, 0x0205, 0x00A5);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 4:
> +		stk11xx_write_registry(dev, 0x0203, 0x0042);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00E0);
> +		stk11xx_write_registry(dev, 0x0204, 0x0024);
> +		stk11xx_write_registry(dev, 0x0205, 0x00A5);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 5:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00FF);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 6:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00FF);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 7:
> +		stk11xx_write_registry(dev, 0x0203, 0x0060);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x0013);
> +		stk11xx_write_registry(dev, 0x0205, 0x00B7);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 8:
> +		stk11xx_write_registry(dev, 0x0203, 0x0080);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0012);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +		stk11xx_write_registry(dev, 0x0204, 0x000A);
> +		stk11xx_write_registry(dev, 0x0205, 0x00FF);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		break;
> +
> +	case 9:
> +		stk11xx_write_registry(dev, 0x0203, 0x00DC);
> +
> +		stk11xx_write_registry(dev, 0x0204, 0x0015);
> +		stk11xx_write_registry(dev, 0x0205, 0x0080);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0005);
> +
> +		stk11xx_check_device(dev, 500);
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_write_registry(dev, 0x0208, 0x0000);
> +		stk11xx_write_registry(dev, 0x0200, 0x0020);
> +		stk11xx_check_device(dev, 500);
> +		stk11xx_read_registry(dev, 0x0209, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_write_registry(dev, 0x0208, 0x0001);
> +		stk11xx_write_registry(dev, 0x0200, 0x0020);
> +		stk11xx_check_device(dev, 500);
> +		stk11xx_read_registry(dev, 0x0209, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_write_registry(dev, 0x0208, 0x0002);
> +		stk11xx_write_registry(dev, 0x0200, 0x0020);
> +		stk11xx_check_device(dev, 500);
> +		stk11xx_read_registry(dev, 0x0209, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +		stk11xx_write_registry(dev, 0x0002, 0x006F);
> +
> +		break;
> +
> +	case 10:
> +		stk11xx_write_registry(dev, 0x0203, 0x00DC);
> +
> +		stk1135_load_microcode(dev);
> +
> +		break;
> +
> +	case 11:
> +		stk11xx_write_registry(dev, 0x0203, 0x00DC);
> +
> +		stk1135_load_microcode(dev);
> +
> +		stk11xx_write_registry(dev, 0x0104, 0x0000);
> +		stk11xx_write_registry(dev, 0x0105, 0x0000);
> +		stk11xx_write_registry(dev, 0x0106, 0x0000);
> +
> +		break;
> +
> +	case 12:
> +		stk11xx_write_registry(dev, 0x0203, 0x00DC);
> +
> +		stk1135_load_microcode(dev);
> +
> +		stk11xx_write_registry(dev, 0x0104, 0x0000);
> +		stk11xx_write_registry(dev, 0x0105, 0x0000);
> +		stk11xx_write_registry(dev, 0x0106, 0x0000);
> +
> +		break;
> +
> +	case 13:
> +		stk11xx_write_registry(dev, 0x0203, 0x00DC);
> +
> +		stk1135_load_microcode(dev);
> +	}
> +
> +	return 0;
> +}
> +
> +static int stk1135_camera_asleep(struct stk11xx *dev)
> +{
> +	int value;
> +
> +	stk11xx_read_registry(dev, 0x0104, &value);
> +	stk11xx_read_registry(dev, 0x0105, &value);
> +	stk11xx_read_registry(dev, 0x0106, &value);
> +
> +	stk11xx_write_registry(dev, 0x0100, 0x0021);
> +	stk11xx_write_registry(dev, 0x0116, 0x0000);
> +	stk11xx_write_registry(dev, 0x0117, 0x0000);
> +	stk11xx_write_registry(dev, 0x0018, 0x0000);
> +
> +	stk11xx_read_registry(dev, 0x0000, &value);
> +	stk11xx_write_registry(dev, 0x0000, 0x0049);
> +
> +	return 0;
> +}
> +
> +static int stk1135_setting_camera(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +	int ret, value;
> +
> +	const u8 values_204[] = {
> +		0x46, 0x06, 0x07, 0xb9, 0xba, 0xbb, 0xbc, 0x61, 0x62, 0x65, 0x66
> +	};
> +	const u8 values_205[] = {
> +		0x20, 0x01, 0xf3, 0x04, 0xe4, 0x09, 0xc8, 0x08, 0x08, 0x10, 0x14
> +	};
> +
> +	for (i = 0; i < 11; i++) {
> +		stk11xx_read_registry(dev, 0x02FF, &value);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +		stk11xx_write_registry(dev, 0x0204, values_204[i]);
> +		stk11xx_write_registry(dev, 0x0205, values_205[i]);
> +
> +		stk11xx_write_registry(dev, 0x0200, 0x0001);
> +		ret = stk11xx_check_device(dev, 500);
> +		stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	}
> +
> +	return 0;
> +}
> +
> +static int stk1135_init_camera(struct stk11xx *dev)
> +{
> +	stk1135_camera_asleep(dev);
> +
> +	stk11xx_set_feature(dev, 0);
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x00E0);
> +	stk11xx_write_registry(dev, 0x0002, 0x00E8);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk1135_configure_device(dev, 11);
> +
> +	stk11xx_camera_off(dev);
> +
> +	stk1135_setting_camera(dev);
> +
> +	stk1135_camera_asleep(dev);
> +
> +	stk11xx_set_feature(dev, 0);
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x00E0);
> +	stk11xx_write_registry(dev, 0x0002, 0x00E8);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk1135_configure_device(dev, 12);
> +
> +	stk11xx_camera_off(dev);
> +
> +	stk1135_setting_camera(dev);
> +
> +	return 0;
> +}
> +
> +static int stk1135_start_stream(struct stk11xx *dev)
> +{
> +	int value, value_116, value_117;
> +
> +	stk11xx_read_registry(dev, 0x0116, &value_116);
> +	stk11xx_read_registry(dev, 0x0117, &value_117);
> +
> +	stk11xx_write_registry(dev, 0x0116, 0x0000);
> +	stk11xx_write_registry(dev, 0x0117, 0x0000);
> +
> +	stk11xx_read_registry(dev, 0x0100, &value);	/* read 0x21 */
> +	stk11xx_write_registry(dev, 0x0100, 0x00A0);
> +
> +	stk11xx_write_registry(dev, 0x0116, value_116);
> +	stk11xx_write_registry(dev, 0x0117, value_117);
> +
> +	return 0;
> +}
> +
> +static int stk1135_reconf_camera(struct stk11xx *dev)
> +{
> +	stk1135_configure_device(dev, 13);
> +
> +	return 0;
> +}
> +
> +static int stk1135_stop_stream(struct stk11xx *dev)
> +{
> +	int value;
> +
> +	stk11xx_read_registry(dev, 0x0100, &value);
> +	stk11xx_write_registry(dev, 0x0100, 0x0020);
> +
> +	return 0;
> +}
> +
> +static int stk11xx_setting_camera(struct stk11xx *dev)
> +{
> +	int ret = -1;
> +
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		ret = stk1125_setting_camera(dev);
> +		break;
> +	case SYNTEK_STK1135:
> +		ret = stk1135_setting_camera(dev);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * It's the start. This function has to be called at first, before
> + * enabling the video stream.
> + */
> +static int stk11xx_init_camera(struct stk11xx *dev)
> +{
> +	int ret = -1;
> +
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		ret = stk1125_init_camera(dev);
> +		break;
> +	case SYNTEK_STK1135:
> +		ret = stk1135_init_camera(dev);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int stk11xx_camera_on(struct stk11xx *dev)
> +{
> +	struct usb_device *udev = dev->udev;
> +	int ret;
> +
> +	ret = usb_set_interface(udev, 0, 5);
> +
> +	if (ret < 0)
> +		dev_err(&udev->dev, "usb_set_interface failed\n");
> +
> +	return ret;
> +}
> +
> +/* Wake-up the camera */
> +static int stk11xx_camera_asleep(struct stk11xx *dev)
> +{
> +	int ret = -1;
> +
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		ret = stk1125_camera_asleep(dev);
> +		break;
> +	case SYNTEK_STK1135:
> +		ret = stk1135_camera_asleep(dev);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * After the initialization of the device and the initialization of the
> video
> + * stream, this function enables the stream.
> + */
> +static int stk11xx_start_stream(struct stk11xx *dev)
> +{
> +	int ret = -1;
> +
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		ret = stk1125_start_stream(dev);
> +		break;
> +	case SYNTEK_STK1135:
> +		ret = stk1135_start_stream(dev);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +/* before enabling the video stream, you have to reconfigure the device */
> +static int stk11xx_reconf_camera(struct stk11xx *dev)
> +{
> +	int ret = -1;
> +
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		ret = stk1125_reconf_camera(dev);
> +		break;
> +	case SYNTEK_STK1135:
> +		ret = stk1135_reconf_camera(dev);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int stk11xx_stop_stream(struct stk11xx *dev)
> +{
> +	int ret = -1;
> +
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		ret = stk1125_stop_stream(dev);
> +		break;
> +	case SYNTEK_STK1135:
> +		ret = stk1135_stop_stream(dev);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static void *stk11xx_rvmalloc(unsigned long size)
> +{
> +	void *mem;
> +	unsigned long addr;
> +
> +	mem = vmalloc_user(size);
> +
> +	if (!mem)
> +		return NULL;
> +
> +	memset(mem, 0, size);
> +
> +	addr = (unsigned long)mem;
> +
> +	while (size > 0) {
> +		SetPageReserved(vmalloc_to_page((void *)addr));
> +		addr += PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +	}
> +
> +	return mem;
> +}
> +
> +static int stk11xx_free_buffers(struct stk11xx *dev);
> +
> +static int stk11xx_allocate_buffers(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +
> +	dev_dbg(&dev->udev->dev, "%s\n", __FUNCTION__);
> +
> +	/* Allocate isochronous pipe buffers */
> +	for (i = 0; i < MAX_ISO_BUFS; i++)
> +		if (dev->isobuf[i].data == NULL) {
> +			dev->isobuf[i].data = kzalloc(ISO_BUFFER_SIZE,
> +					GFP_KERNEL);
> +			if (dev->isobuf[i].data == NULL) {
> +				dev_err(&dev->udev->dev, "failed to allocate "
> +					"iso buffer %d\n", i);
> +				goto err;
> +			}
> +		}
> +
> +	/* Allocate frame buffer structure */
> +	if (dev->framebuf == NULL) {
> +		dev->framebuf = kzalloc(default_nbrframebuf *
> +			    sizeof(struct stk11xx_frame_buf), GFP_KERNEL);
> +		if (dev->framebuf == NULL) {
> +			dev_err(&dev->udev->dev, "failed to allocate frame "
> +					"buffer structure\n");
> +			goto err;
> +		}
> +	}
> +	/* Create frame buffers and make circular ring */
> +	for (i = 0; i < default_nbrframebuf; i++)
> +		if (dev->framebuf[i].data == NULL) {
> +			dev->framebuf[i].data = vmalloc(STK11XX_FRAME_SIZE);
> +			if (dev->framebuf[i].data == NULL) {
> +				dev_err(&dev->udev->dev, "failed to allocate "
> +						"frame buffer %d\n", i);
> +				goto err;
> +			}
> +			memset(dev->framebuf[i].data, 0, STK11XX_FRAME_SIZE);
> +		}
> +
> +	/* Allocate decompressor table space */
> +	dev->decompress_data = stk11xx_rvmalloc(dev->len_per_image);
> +	if (dev->decompress_data == NULL) {
> +		dev_err(&dev->udev->dev, "failed to allocate decompress "
> +				"buffer(s). needed (%d)\n", dev->len_per_image);
> +		goto err;
> +	}
> +
> +	/* Allocate image buffer; double buffer for mmap() */
> +	dev->image_data = stk11xx_rvmalloc(dev->nbuffers * dev->len_per_image);
> +	if (dev->image_data == NULL) {
> +		dev_err(&dev->udev->dev, "failed to allocate image buffer(s). "
> +			"needed (%d)\n", dev->nbuffers * dev->len_per_image);
> +		goto err;
> +	}
> +
> +	for (i = 0; i < dev->nbuffers; i++) {
> +		dev->images[i].offset = i * dev->len_per_image;
> +		dev->images[i].vma_use_count = 0;
> +	}
> +
> +	for (; i < STK11XX_MAX_IMAGES; i++)
> +		dev->images[i].offset = 0;
> +
> +	return 0;
> +err:
> +	stk11xx_free_buffers(dev);
> +	return -ENOMEM;
> +}
> +
> +static void stk11xx_rvfree(void *mem, unsigned long size)
> +{
> +	unsigned long addr;
> +
> +	if (!mem)
> +		return;
> +
> +	addr = (unsigned long)mem;
> +
> +	while ((long)size > 0) {
> +		ClearPageReserved(vmalloc_to_page((void *)addr));
> +		addr += PAGE_SIZE;
> +		size -= PAGE_SIZE;
> +	}
> +
> +	vfree(mem);
> +}
> +
> +static int stk11xx_free_buffers(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +
> +	dev_dbg(&dev->udev->dev, "%s\n", __FUNCTION__);
> +
> +	if (dev == NULL)
> +		return -1;
> +
> +	/* Release iso pipe buffers */
> +	for (i = 0; i < MAX_ISO_BUFS; i++)
> +		if (dev->isobuf[i].data != NULL) {
> +			kfree(dev->isobuf[i].data);
> +			dev->isobuf[i].data = NULL;
> +		}
> +
> +	/* Release frame buffers */
> +	if (dev->framebuf != NULL) {
> +		for (i = 0; i < default_nbrframebuf; i++)
> +			if (dev->framebuf[i].data != NULL) {
> +				vfree(dev->framebuf[i].data);
> +				dev->framebuf[i].data = NULL;
> +			}
> +
> +		kfree(dev->framebuf);
> +	}
> +	/* Release decompression buffers */
> +	if (dev->decompress_data != NULL)
> +		stk11xx_rvfree(dev->decompress_data, dev->len_per_image);
> +
> +	/* Release image buffers */
> +	if (dev->image_data != NULL)
> +		stk11xx_rvfree(dev->image_data,
> +			       dev->nbuffers * dev->len_per_image);
> +
> +	dev->decompress_data = dev->framebuf = dev->image_data = NULL;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_reset_buffers(struct stk11xx *dev)
> +{
> +	unsigned long flags;
> +	unsigned int i;
> +
> +	dev_dbg(&dev->udev->dev, "%s\n", __FUNCTION__);
> +
> +	spin_lock_irqsave(&dev->spinlock, flags);
> +
> +	dev->full_frames = NULL;
> +	dev->full_frames_tail = NULL;
> +
> +	for (i = 0; i < dev->nbuffers; i++) {
> +		dev->framebuf[i].filled = 0;
> +
> +		if (i > 0)
> +			dev->framebuf[i].next = &dev->framebuf[i - 1];
> +		else
> +			dev->framebuf->next = NULL;
> +	}
> +
> +	dev->empty_frames = &dev->framebuf[dev->nbuffers - 1];
> +	dev->empty_frames_tail = dev->framebuf;
> +	dev->read_frame = NULL;
> +	dev->fill_frame = dev->empty_frames;
> +	dev->empty_frames = dev->empty_frames->next;
> +
> +	dev->image_read_pos = 0;
> +	dev->fill_image = 0;
> +
> +	spin_unlock_irqrestore(&dev->spinlock, flags);
> +
> +	for (i = 0; i < dev->nbuffers; i++)
> +		dev->image_f[i] = 0;
> +
> +	return 0;
> +}
> +
> +/* called when an image is ready to prepare the next image */
> +static void stk11xx_next_image(struct stk11xx *dev)
> +{
> +	STK_STREAM("Select next image\n");
> +
> +	dev->image_f[dev->fill_image] = 0;
> +	dev->fill_image = (dev->fill_image + 1) % dev->nbuffers;
> +}
> +
> +/*
> + * This function reads periodically the value of register 0x0001.
> + * We don't know the purpose. I assume that it seems to a software
> watchdog.
> + */
> +static int stk11xx_watchdog_camera(struct stk11xx *dev)
> +{
> +	int value;
> +
> +	stk11xx_read_registry(dev, 0x0001, &value);
> +
> +	if (value != 0x03)
> +		dev_err(&dev->udev->dev, "Error: Register 0x0001 = %02X\n",
> +				value);
> +
> +	return value;
> +}
> +
> +/*
> + * This function gets called for the isochronous pipe. This function is
> only
> + * called when a frame is ready. So we have to be fast to decompress the
> data.
> + */
> +static int stk11xx_handle_frame(struct stk11xx *dev)
> +{
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	STK_STREAM("Sync Handle Frame\n");
> +
> +	spin_lock_irqsave(&dev->spinlock, flags);
> +
> +	if (dev->read_frame != NULL) {
> +		spin_unlock_irqrestore(&dev->spinlock, flags);
> +		return ret;
> +	}
> +
> +	if (dev->full_frames != NULL) {
> +		dev->read_frame = dev->full_frames;
> +		dev->full_frames = dev->full_frames->next;
> +		dev->read_frame->next = NULL;
> +	}
> +
> +	if (dev->read_frame != NULL) {
> +		spin_unlock_irqrestore(&dev->spinlock, flags);
> +		ret = stk11xx_decompress(dev);
> +		spin_lock_irqsave(&dev->spinlock, flags);
> +
> +		if (dev->empty_frames == NULL) {
> +			dev->empty_frames = dev->read_frame;
> +			dev->empty_frames_tail = dev->empty_frames;
> +		} else {
> +			dev->empty_frames_tail->next = dev->read_frame;
> +			dev->empty_frames_tail = dev->read_frame;
> +		}
> +
> +		dev->read_frame = NULL;
> +	}
> +
> +	spin_unlock_irqrestore(&dev->spinlock, flags);
> +
> +	stk11xx_watchdog_camera(dev);
> +
> +	return ret;
> +}
> +
> +static int stk11xx_select_video_mode(struct stk11xx *dev, int width,
> +				  int height)
> +{
> +	unsigned int i, find;
> +
> +	/* Check width and height */
> +	/* Driver can't build an image more little than the minimal resolution !
> */
> +	if ((width < stk11xx_image_sizes[0].x) ||
> +			(height < stk11xx_image_sizes[0].y))
> +		return -1;
> +
> +	/* Seek the best resolution */
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		for (i = 0, find = 0; i < STK11XX_NBR_SIZES; i++) {
> +			if (stk11xx_image_sizes[i].x <= width &&
> +					stk11xx_image_sizes[i].y <= height)
> +				find = i;
> +		}
> +		break;
> +
> +	case SYNTEK_STK1135:
> +		for (i = 0, find = 0; i < STK11XX_NBR_SIZES - 3; i++) {
> +			if (stk11xx_image_sizes[i].x <= width &&
> +					stk11xx_image_sizes[i].y <= height)
> +				find = i;
> +		}
> +		break;
> +
> +	default:
> +		return -1;
> +	}
> +
> +	/* Save the new resolution */
> +	dev->resolution = find;
> +
> +	dev_dbg(&dev->udev->dev, "set mode %d [%dx%d]\n", dev->resolution,
> +			stk11xx_image_sizes[dev->resolution].x,
> +			stk11xx_image_sizes[dev->resolution].y);
> +
> +	/* Save the new size */
> +	dev->view.x = width;
> +	dev->view.y = height;
> +
> +	/* Calculate the frame size */
> +	switch (dev->resolution) {
> +	case STK11XX_80x60:
> +	case STK11XX_160x120:
> +	case STK11XX_320x240:
> +	case STK11XX_640x480:
> +		dev->frame_size = stk11xx_image_sizes[STK11XX_640x480].x *
> +				stk11xx_image_sizes[STK11XX_640x480].y;
> +		dev->image_size = 3 * dev->frame_size;
> +		break;
> +
> +	case STK11XX_800x600:
> +	case STK11XX_1024x758:
> +	case STK11XX_1280x1024:
> +		dev->frame_size = stk11xx_image_sizes[STK11XX_1280x1024].x *
> +				stk11xx_image_sizes[STK11XX_1280x1024].y;
> +		dev->image_size = 3 * dev->frame_size;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int stk11xx_open(struct inode *inode, struct file *fp)
> +{
> +	struct video_device *vdev = video_devdata(fp);
> +	struct stk11xx *dev = video_get_drvdata(vdev);
> +	int retval;
> +
> +	BUG_ON(dev == NULL);
> +
> +	nonseekable_open(inode, fp);
> +
> +	if (mutex_lock_interruptible(&dev->open_lock))
> +		return -ERESTARTSYS;
> +
> +	if (dev->vopen) {
> +		retval = -EBUSY;
> +		goto end;
> +	}
> +
> +	retval = stk11xx_allocate_buffers(dev);
> +	if (retval < 0) {
> +		dev_err(&dev->udev->dev, "failed to allocate buffer memory\n");
> +		goto end;
> +	}
> +
> +	stk11xx_reset_buffers(dev);
> +
> +	stk11xx_select_video_mode(dev, 640, 480);
> +
> +	stk11xx_init_camera(dev);
> +	stk11xx_camera_on(dev);
> +	stk11xx_reconf_camera(dev);
> +
> +	dev->error_status = 0;
> +	dev->vsettings.brightness = 200;
> +	dev->vsettings.contrast = 0x7c;
> +	dev->vsettings.whiteness = 0x80;
> +	dev->vsettings.pixformat = V4L2_PIX_FMT_BGR24;
> +
> +	retval = stk11xx_isoc_init(dev);
> +	if (retval) {
> +		dev_err(&dev->udev->dev, "failed to init ISOC stuff\n");
> +		stk11xx_isoc_cleanup(dev);
> +		stk11xx_free_buffers(dev);
> +		goto end;
> +	}
> +
> +	stk11xx_start_stream(dev);
> +
> +	dev->vopen++;
> +	fp->private_data = dev;
> +	retval = 0;
> +end:
> +	mutex_unlock(&dev->open_lock);
> +
> +	return retval;
> +}
> +
> +static int stk11xx_release(struct inode *inode, struct file *fp)
> +{
> +	struct stk11xx *dev = fp->private_data;
> +
> +	mutex_lock(&dev->open_lock);
> +	if (dev->vopen == 0)
> +		dev_warn(&dev->udev->dev, "v4l_release called on closed "
> +				"device\n");
> +
> +	stk11xx_stop_stream(dev);
> +	stk11xx_isoc_cleanup(dev);
> +	stk11xx_free_buffers(dev);
> +	stk11xx_camera_off(dev);
> +	stk11xx_camera_asleep(dev);
> +
> +	dev->vopen--;
> +	mutex_unlock(&dev->open_lock);
> +
> +	return 0;
> +}
> +
> +static ssize_t stk11xx_read(struct file *fp, char __user *buf, size_t
> count,
> +		loff_t *f_pos)
> +{
> +	struct stk11xx *dev = fp->private_data;
> +	void *image_buffer_addr;
> +	int bytes_to_read, retval;
> +
> +	STK_STREAM("Read vdev=0x%p, buf=0x%p, count=%zd\n", vdev, buf, count);
> +
> +	if (dev->image_read_pos == 0) {
> +		if ((fp->f_flags & O_NONBLOCK) && dev->full_frames == NULL)
> +			return -EWOULDBLOCK;
> +
> +		retval = wait_event_interruptible(dev->wait_frame,
> +			dev->full_frames != NULL || dev->error_status);
> +
> +		if (retval)
> +			return retval;
> +		if (dev->error_status)
> +			return -dev->error_status;
> +
> +		if (stk11xx_handle_frame(dev))
> +			return -EFAULT;
> +	}
> +
> +	bytes_to_read = dev->image_size;
> +
> +	if (count + dev->image_read_pos > bytes_to_read)
> +		count = bytes_to_read - dev->image_read_pos;
> +
> +	image_buffer_addr = dev->image_data;
> +	image_buffer_addr += dev->images[dev->fill_image].offset;
> +	image_buffer_addr += dev->image_read_pos;
> +
> +	if (copy_to_user(buf, image_buffer_addr, count))
> +		return -EFAULT;
> +
> +	dev->image_read_pos += count;
> +
> +	if (dev->image_read_pos >= bytes_to_read) {
> +		dev->image_read_pos = 0;
> +		stk11xx_next_image(dev);
> +	}
> +
> +	return count;
> +}
> +
> +static unsigned int stk11xx_poll(struct file *fp, poll_table * wait)
> +{
> +	struct stk11xx *dev = fp->private_data;
> +
> +	STK_STREAM("Poll\n");
> +
> +	poll_wait(fp, &dev->wait_frame, wait);
> +
> +	if (dev->error_status)
> +		return POLLERR;
> +
> +	if (dev->full_frames != NULL)
> +		return (POLLIN | POLLRDNORM);
> +
> +	return 0;
> +}
> +
> +static int stk11xx_mmap(struct file *fp, struct vm_area_struct *vma)
> +{
> +	struct stk11xx *dev = fp->private_data;
> +	unsigned long pos, size = vma->vm_end - vma->vm_start;
> +	unsigned int i;
> +
> +	/* Find the buffer for this mapping... */
> +	for (i = 0; i < dev->nbuffers; i++) {
> +		pos = dev->images[i].offset;
> +
> +		if ((pos >> PAGE_SHIFT) == vma->vm_pgoff)
> +			break;
> +	}
> +
> +	if (i >= STK11XX_MAX_IMAGES) {
> +		dev_err(&dev->udev->dev, "mmap no buffer found\n");
> +		return -EINVAL;
> +	}
> +
> +	/* map either whole space or only one buffer! */
> +	if (size > dev->len_per_image && (i > 0 ||
> +			(i == 0 && size != dev->nbuffers * dev->len_per_image)))
> +		return -EINVAL;
> +
> +	vma->vm_flags |= VM_IO;
> +
> +	return remap_vmalloc_range(vma, dev->image_data, vma->vm_pgoff);
> +}
> +
> +static struct v4l2_queryctrl stk11xx_controls[] = {
> +	{
> +		.id      = V4L2_CID_BRIGHTNESS,
> +		.type    = V4L2_CTRL_TYPE_INTEGER,
> +		.name    = "Brightness",
> +		.minimum = 0,
> +		.maximum = 400,
> +		.step    = 1,
> +		.default_value = 200,
> +	},
> +	{
> +		.id      = V4L2_CID_CONTRAST,
> +		.type    = V4L2_CTRL_TYPE_INTEGER,
> +		.name    = "Contrast",
> +		.minimum = 0,
> +		.maximum = 0xff,
> +		.step    = 1,
> +		.default_value = 0x7c,
> +	},
> +	{
> +		.id      = V4L2_CID_WHITENESS,
> +		.type    = V4L2_CTRL_TYPE_INTEGER,
> +		.name    = "Whiteness",
> +		.minimum = 0,
> +		.maximum = 0xff,
> +		.step    = 1,
> +		.default_value = 0x80,
> +	},
> +};
> +
> +static int stk11xx_querycap(struct file *file, void *fh,
> +		struct v4l2_capability *cap)
> +{
> +	struct stk11xx *dev = fh;
> +
> +	strlcpy(cap->driver, "stk11xx", sizeof(cap->driver));
> +
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
> +			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
> +	cap->version = (u32)DRIVER_VERSION_NUM;
> +	strlcpy(cap->card, dev->vdev->name, sizeof(cap->card));
> +
> +	if (usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info)) < 0)
> +		strlcpy(cap->bus_info, dev->vdev->name, sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +static int stk11xx_enum_input(struct file *file, void *fh, struct
> v4l2_input *i)
> +{
> +	if (i->index)
> +		return -EINVAL;
> +
> +	strlcpy(i->name, "USB", sizeof(i->name));
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_g_input(struct file *file, void *fh, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int stk11xx_s_input(struct file *file, void *fh, unsigned int i)
> +{
> +	return i ? -EINVAL : 0;
> +}
> +
> +static int stk11xx_queryctrl(struct file *file, void *fh,
> +		struct v4l2_queryctrl *c)
> +{
> +	unsigned int i;
> +
> +	pr_debug("VIDIOC_QUERYCTRL id = %d\n", c->id);
> +
> +	for (i = 0; i < ARRAY_SIZE(stk11xx_controls); i++)
> +		if (stk11xx_controls[i].id == c->id) {
> +			pr_debug("VIDIOC_QUERYCTRL found\n");
> +			memcpy(c, &stk11xx_controls[i], sizeof(*c));
> +			break;
> +		}
> +
> +	if (i >= ARRAY_SIZE(stk11xx_controls))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_g_ctrl(struct file *file, void *fh, struct v4l2_control
> *c)
> +{
> +	struct stk11xx *dev = fh;
> +
> +	dev_dbg(&dev->udev->dev, "GET CTRL id=%d\n", c->id);
> +
> +	switch (c->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		c->value = dev->vsettings.brightness;
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		c->value = dev->vsettings.contrast;
> +		break;
> +	case V4L2_CID_WHITENESS:
> +		c->value = dev->vsettings.whiteness;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int stk11xx_s_ctrl(struct file *file, void *fh, struct v4l2_control
> *c)
> +{
> +	struct stk11xx *dev = fh;
> +
> +	dev_dbg(&dev->udev->dev, "SET CTRL id=%d\n", c->id);
> +
> +	switch (c->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		dev->vsettings.brightness = c->value;
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		dev->vsettings.contrast = c->value;
> +		break;
> +	case V4L2_CID_WHITENESS:
> +		dev->vsettings.whiteness = c->value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return stk11xx_setting_camera(dev) ? -EIO : 0;
> +}
> +
> +static int stk11xx_enum_fmt_cap(struct file *file, void *fh,
> +		struct v4l2_fmtdesc *fmtd)
> +{
> +	u32 index = fmtd->index;
> +
> +	pr_debug("VIDIOC_ENUM_FMT %d\n", index);
> +
> +	if (index)
> +		return -EINVAL;
> +
> +	fmtd->pixelformat = V4L2_PIX_FMT_BGR24;
> +	strcpy(fmtd->description, "rgb24");
> +
> +	return 0;
> +}
> +
> +static int stk11xx_g_fmt_cap(struct file *file, void *fh,
> +	   	struct v4l2_format *fmtd)
> +{
> +	struct stk11xx *dev = fh;
> +	struct v4l2_pix_format *pix = &fmtd->fmt.pix;
> +
> +	pix->width = dev->view.x;
> +	pix->height = dev->view.y;
> +	pix->pixelformat = V4L2_PIX_FMT_BGR24;
> +	pix->field = V4L2_FIELD_NONE;
> +	pix->bytesperline = 3 * pix->width;
> +	pix->sizeimage = pix->width * pix->height * 3;
> +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> +	pix->priv = 0;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_s_fmt_cap(struct file *file, void *fh,
> +	   	struct v4l2_format *fmtd)
> +{
> +	struct stk11xx *dev = fh;
> +	struct v4l2_pix_format *pix = &fmtd->fmt.pix;
> +	unsigned int a;
> +
> +	dev_dbg(&dev->udev->dev, "set width=%d, height=%d\n", pix->width,
> +			pix->height);
> +
> +	if (pix->pixelformat && pix->pixelformat != V4L2_PIX_FMT_BGR24)
> +		return -EINVAL;
> +
> +	for (a = 0; a < ARRAY_SIZE(stk11xx_image_sizes); a++)
> +		if (pix->width == stk11xx_image_sizes[a].x &&
> +				pix->height == stk11xx_image_sizes[a].y)
> +			break;
> +	if (a >= ARRAY_SIZE(stk11xx_image_sizes))
> +		return -EINVAL;
> +
> +	stk11xx_stop_stream(dev);
> +	stk11xx_isoc_cleanup(dev);
> +	stk11xx_camera_off(dev);
> +	stk11xx_camera_asleep(dev);
> +
> +	/* Reset buffers and parameters */
> +	/*stk11xx_reset_buffers(dev); */
> +
> +	if (stk11xx_select_video_mode(dev, pix->width, pix->height)) {
> +		dev_err(&dev->udev->dev, "Select video mode failed\n");
> +		return -EINVAL;
> +	}
> +
> +	stk11xx_init_camera(dev);
> +	stk11xx_camera_on(dev);
> +	stk11xx_reconf_camera(dev);
> +	stk11xx_isoc_init(dev);
> +	stk11xx_start_stream(dev);
> +
> +	return 0;
> +}
> +
> +static int stk11xx_try_fmt_cap(struct file *file, void *fh,
> +	   	struct v4l2_format *fmtd)
> +{
> +	struct v4l2_pix_format *pix = &fmtd->fmt.pix;
> +
> +	if (pix->pixelformat != V4L2_PIX_FMT_BGR24)
> +		return -EINVAL;
> +
> +	if (pix->width > stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].x)
> +		pix->width = stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].x;
> +	else if (pix->width < stk11xx_image_sizes[0].x)
> +		pix->width = stk11xx_image_sizes[0].x;
> +
> +	if (pix->height > stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].y)
> +		pix->height = stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].y;
> +	else if (pix->height < stk11xx_image_sizes[0].y)
> +		pix->height = stk11xx_image_sizes[0].y;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_querystd(struct file *file, void *fh, v4l2_std_id *a)
> +{
> +	*a = V4L2_STD_UNKNOWN;
> +	return 0;
> +}
> +
> +static int stk11xx_s_std(struct file *file, void *fh, v4l2_std_id *a)
> +{
> +	return *a == V4L2_STD_UNKNOWN ? 0 : -EINVAL;
> +}
> +
> +static int stk11xx_reqbufs(struct file *file, void *fh,
> +		struct v4l2_requestbuffers *rb)
> +{
> +	struct stk11xx *dev = fh;
> +	u32 nbuffers = rb->count;
> +
> +	if (rb->memory != V4L2_MEMORY_MMAP)
> +		return -EINVAL;
> +
> +	if (nbuffers < 2)
> +		nbuffers = 2;
> +	else if (nbuffers > dev->nbuffers)
> +		nbuffers = dev->nbuffers;
> +
> +	rb->count = dev->nbuffers;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_querybuf(struct file *file, void *fh,
> +		struct v4l2_buffer *buf)
> +{
> +	struct stk11xx *dev = fh;
> +	u32 index = buf->index;
> +
> +	dev_dbg(&dev->udev->dev, "QUERY BUFFERS %d %d\n", buf->index,
> +		  dev->nbuffers);
> +
> +	if (index >= dev->nbuffers)
> +		return -EINVAL;
> +
> +	memset(buf, 0, sizeof(struct v4l2_buffer));
> +
> +	buf->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	buf->index = index;
> +	buf->memory = V4L2_MEMORY_MMAP;
> +	buf->m.offset = index * dev->len_per_image;
> +	buf->bytesused = dev->image_size;
> +	buf->field = V4L2_FIELD_NONE;
> +	buf->length = dev->len_per_image;
> +	buf->flags = V4L2_BUF_FLAG_MAPPED | dev->image_f[index];
> +	if (dev->full_frames != NULL)
> +		buf->flags |= V4L2_BUF_FLAG_DONE;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_qbuf(struct file *file, void *fh, struct v4l2_buffer
> *buf)
> +{
> +	struct stk11xx *dev = fh;
> +
> +	dev_dbg(&dev->udev->dev, "VIDIOC_QBUF\n");
> +
> +	if (buf->memory != V4L2_MEMORY_MMAP)
> +		return -EINVAL;
> +
> +	if (buf->index >= dev->nbuffers)
> +		return -EINVAL;
> +
> +	if (dev->image_f[buf->index] & V4L2_BUF_FLAG_QUEUED)
> +		return -EBUSY;
> +
> +	dev->image_f[buf->index] |= V4L2_BUF_FLAG_QUEUED;
> +	buf->flags |= V4L2_BUF_FLAG_QUEUED;
> +	buf->flags &= ~V4L2_BUF_FLAG_DONE;
> +
> +	return 0;
> +}
> +
> +static int stk11xx_dqbuf(struct file *file, void *fh, struct v4l2_buffer
> *buf)
> +{
> +	struct stk11xx *dev = fh;
> +	int retval;
> +
> +	dev_dbg(&dev->udev->dev, "VIDIOC_DQBUF\n");
> +
> +	if (dev->full_frames == NULL && (file->f_flags & O_NONBLOCK))
> +		return -EAGAIN;
> +
> +	retval = wait_event_interruptible(dev->wait_frame,
> +			dev->full_frames != NULL || dev->error_status);
> +
> +	if (retval)
> +		return retval;
> +	if (dev->error_status)
> +		return -dev->error_status;
> +
> +	dev_dbg(&dev->udev->dev, "VIDIOC_DQBUF: frame ready\n");
> +
> +	retval = stk11xx_handle_frame(dev);
> +
> +	if (retval)
> +		return -EFAULT;
> +
> +	buf->index = dev->fill_image;
> +	buf->bytesused = dev->image_size;
> +	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE;
> +	buf->field = V4L2_FIELD_NONE;
> +	do_gettimeofday(&buf->timestamp);
> +	buf->sequence = 0;
> +	buf->memory = V4L2_MEMORY_MMAP;
> +	buf->m.offset = dev->fill_image * dev->len_per_image;
> +	buf->length = buf->bytesused;
> +
> +	stk11xx_next_image(dev);
> +
> +	return 0;
> +}
> +
> +static int stk11xx_streamon(struct file *file, void *fh, enum v4l2_buf_type
> i)
> +{
> +	return i == V4L2_BUF_TYPE_VIDEO_CAPTURE ? stk11xx_isoc_init(fh):-EINVAL;
> +}
> +
> +static int stk11xx_streamoff(struct file *file, void *fh, enum
> v4l2_buf_type i)
> +{
> +	return i == V4L2_BUF_TYPE_VIDEO_CAPTURE ?
> +		stk11xx_isoc_cleanup(fh), 0 : -EINVAL;
> +}
> +
> +static int stk11xx_g_parm(struct file *file, void *fh,
> +		struct v4l2_streamparm *sp)
> +{
> +	pr_debug("GET PARM %d\n", sp->type);
> +
> +	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	sp->parm.capture.capability = 0;
> +	sp->parm.capture.capturemode = 0;
> +	sp->parm.capture.timeperframe.numerator = 1;
> +	sp->parm.capture.timeperframe.denominator = 30;
> +	sp->parm.capture.readbuffers = 2;
> +	sp->parm.capture.extendedmode = 0;
> +
> +	return 0;
> +}
> +/*
> +static int vidioc_cropcap(struct file *file, void *fh, struct v4l2_cropcap
> *cc)
> +{
> +	cc->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	cc->pixelaspect.numerator = 1;
> +	cc->pixelaspect.denominator = 1;
> +	cc->bounds.top = 0;
> +	cc->bounds.left = 0;
> +	cc->bounds.width = 640;
> +	cc->bounds.height = 480;
> +	cc->defrect.top = 0;
> +	cc->defrect.left = 0;
> +	cc->defrect.width = 640;
> +	cc->defrect.height = 480;
> +
> +	return 0;
> +}
> +*/
> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
> +static int stk11xx_gmbuf(struct file *file, void *fh, struct video_mbuf
> *vm)
> +{
> +	struct stk11xx *dev = fh;
> +	unsigned int i;
> +
> +	dev_dbg(&dev->udev->dev, "VIDIOCGMBUF\n");
> +
> +	vm->size = dev->nbuffers * dev->len_per_image;
> +	vm->frames = dev->nbuffers;
> +
> +	for (i = 0; i < dev->nbuffers; i++)
> +		vm->offsets[i] = i * dev->len_per_image;
> +
> +	return 0;
> +}
> +#else
> +#define stk11xx_gmbuf NULL
> +#endif
> +
> +static struct file_operations stk11xx_fops = {
> +	.owner = THIS_MODULE,
> +	.open = stk11xx_open,
> +	.release = stk11xx_release,
> +	.read = stk11xx_read,
> +	.poll = stk11xx_poll,
> +	.mmap = stk11xx_mmap,
> +	.ioctl = video_ioctl2
> +};
> +
> +static const struct video_device stk11xx_vdev_template = {
> +	.name = DRIVER_DESC,
> +
> +	.type2 = VID_TYPE_CAPTURE,
> +	.tvnorms = V4L2_STD_UNKNOWN,
> +	.current_norm = V4L2_STD_UNKNOWN,
> +	.fops = &stk11xx_fops,
> +	.release = video_device_release,
> +	.minor = -1,
> +
> +	.vidioc_querycap = stk11xx_querycap,
> +	.vidioc_enum_input = stk11xx_enum_input,
> +	.vidioc_g_input = stk11xx_g_input,
> +	.vidioc_s_input = stk11xx_s_input,
> +	.vidioc_queryctrl = stk11xx_queryctrl,
> +	.vidioc_g_ctrl = stk11xx_g_ctrl,
> +	.vidioc_s_ctrl = stk11xx_s_ctrl,
> +	.vidioc_enum_fmt_cap = stk11xx_enum_fmt_cap,
> +	.vidioc_g_fmt_cap = stk11xx_g_fmt_cap,
> +	.vidioc_s_fmt_cap = stk11xx_s_fmt_cap,
> +	.vidioc_try_fmt_cap = stk11xx_try_fmt_cap,
> +	.vidioc_querystd = stk11xx_querystd,
> +	.vidioc_s_std = stk11xx_s_std,
> +	.vidioc_reqbufs = stk11xx_reqbufs,
> +	.vidioc_querybuf = stk11xx_querybuf,
> +	.vidioc_qbuf = stk11xx_qbuf,
> +	.vidioc_dqbuf = stk11xx_dqbuf,
> +	.vidioc_streamon = stk11xx_streamon,
> +	.vidioc_streamoff = stk11xx_streamoff,
> +	.vidioc_g_parm = stk11xx_g_parm,
> +
> +	.vidiocgmbuf = stk11xx_gmbuf,
> +};
> +
> +/*
> + * sysfs stuff
> + */
> +
> +static ssize_t show_brightness(struct class_device *class, char *buf)
> +{
> +	struct stk11xx *dev = video_get_drvdata(to_video_device(class));
> +
> +	return sprintf(buf, "%X\n", dev->vsettings.brightness);
> +}
> +
> +static ssize_t show_contrast(struct class_device *class, char *buf)
> +{
> +	struct stk11xx *dev = video_get_drvdata(to_video_device(class));
> +
> +	return sprintf(buf, "%X\n", dev->vsettings.contrast);
> +}
> +
> +static ssize_t show_whitebalance(struct class_device *class, char *buf)
> +{
> +	struct stk11xx *dev = video_get_drvdata(to_video_device(class));
> +
> +	return sprintf(buf, "%X\n", dev->vsettings.whiteness);
> +}
> +
> +static CLASS_DEVICE_ATTR(brightness, S_IRUGO, show_brightness, NULL);
> +static CLASS_DEVICE_ATTR(contrast, S_IRUGO, show_contrast, NULL);
> +static CLASS_DEVICE_ATTR(whitebalance, S_IRUGO, show_whitebalance, NULL);
> +
> +static inline int stk11xx_create_sysfs_file(const struct stk11xx *dev,
> +		const struct class_device_attribute *cda)
> +{
> +	int ret;
> +
> +	ret = class_device_create_file(&dev->vdev->class_dev, cda);
> +	if (ret)
> +		dev_err(&dev->udev->dev, "can't create sysfs file %s: %d\n",
> +				attr_name(*cda), ret);
> +
> +	return ret;
> +}
> +
> +/*
> + * USB
> + */
> +
> +/* this function is written from the USB log */
> +static int stk1125_initialize_device(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +	int value;
> +
> +	const u8 values_1[] = {
> +		0x24, 0x24, 0x26, 0x27, 0x26, 0x26, 0x27, 0x26, 0x24, 0x25,
> +		0x24, 0x26, 0x27, 0x26, 0x24, 0x25, 0x24, 0x26, 0x27, 0x26,
> +		0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25
> +	};
> +	const u8 values_2[] = {
> +		0x24, 0x24, 0x26, 0x27, 0x26, 0x26, 0x27, 0x26, 0x24, 0x25,
> +		0x24, 0x24, 0x25, 0x24, 0x24, 0x25, 0x24, 0x26, 0x27, 0x26,
> +		0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25, 0x24, 0x26,
> +		0x27, 0x26, 0x24, 0x25
> +	};
> +	const u8 values_3[] = {
> +		0x24, 0x24, 0x26, 0x27, 0x26, 0x26, 0x27, 0x26, 0x24, 0x25,
> +		0x24, 0x24, 0x25, 0x24, 0x24, 0x25, 0x24, 0x24, 0x25, 0x24,
> +		0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25, 0x24, 0x26,
> +		0x27, 0x26, 0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25
> +	};
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0003, 0x0080);
> +
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	for (i = 0; i < ARRAY_SIZE(values_1); i++)
> +		stk11xx_write_registry(dev, 0x0000, values_1[i]);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_registry(dev, 0x0000, 0x0025);
> +		stk11xx_write_registry(dev, 0x0000, 0x0024);
> +		stk11xx_read_registry(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 1: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	for (i = 0; i < ARRAY_SIZE(values_2); i++)
> +		stk11xx_write_registry(dev, 0x0000, values_2[i]);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_registry(dev, 0x0000, 0x0025);
> +		stk11xx_write_registry(dev, 0x0000, 0x0024);
> +		stk11xx_read_registry(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 2: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	for (i = 0; i < ARRAY_SIZE(values_3); i++)
> +		stk11xx_write_registry(dev, 0x0000, values_3[i]);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_registry(dev, 0x0000, 0x0025);
> +		stk11xx_write_registry(dev, 0x0000, 0x0024);
> +		stk11xx_read_registry(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 3: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk11xx_write_registry(dev, 0x0117, 0x0000);
> +	stk11xx_read_registry(dev, 0x0103, &value);
> +	stk11xx_write_registry(dev, 0x0103, 0x0001);
> +	stk11xx_read_registry(dev, 0x0103, &value);
> +	stk11xx_write_registry(dev, 0x0103, 0x0000);
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x00E0);
> +	stk11xx_write_registry(dev, 0x0002, 0x00E8);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk1125_configure_device(dev, 0);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1125_configure_device(dev, 1);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1125_configure_device(dev, 2);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x0013);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000A);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000B);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +	stk1125_configure_device(dev, 3);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1125_configure_device(dev, 4);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1125_configure_device(dev, 5);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x0013);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000A);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000B);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +	stk1125_configure_device(dev, 6);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x0013);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000A);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000B);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +	stk1125_configure_device(dev, 7);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x0013);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000A);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_read_registry(dev, 0x02FF, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +	stk11xx_write_registry(dev, 0x0208, 0x000B);
> +	stk11xx_write_registry(dev, 0x0200, 0x0020);
> +	stk11xx_check_device(dev, 500);
> +	stk11xx_read_registry(dev, 0x0209, &value);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0000);
> +
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk1125_configure_device(dev, 8);
> +
> +	stk1125_camera_asleep(dev);
> +
> +	stk11xx_set_feature(dev, 0);
> +
> +	dev_info(&dev->udev->dev, "syntek USB2.0 Camera is ready\n");
> +
> +	return 0;
> +}
> +
> +/* this function is written from the USB log */
> +static int stk1135_initialize_device(struct stk11xx *dev)
> +{
> +	unsigned int i;
> +	int value;
> +
> +	const u8 values_1[] = {
> +		0x24, 0x24, 0x26, 0x27, 0x26, 0x26, 0x27, 0x26, 0x24, 0x25,
> +		0x24, 0x26, 0x27, 0x26, 0x24, 0x25, 0x24, 0x26, 0x27, 0x26,
> +		0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25
> +	};
> +	const u8 values_2[] = {
> +		0x24, 0x24, 0x26, 0x27, 0x26, 0x26, 0x27, 0x26, 0x24, 0x25,
> +		0x24, 0x24, 0x25, 0x24, 0x24, 0x25, 0x24, 0x26, 0x27, 0x26,
> +		0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25, 0x24, 0x26,
> +		0x27, 0x26, 0x24, 0x25
> +	};
> +	const u8 values_3[] = {
> +		0x24, 0x24, 0x26, 0x27, 0x26, 0x26, 0x27, 0x26, 0x24, 0x25,
> +		0x24, 0x24, 0x25, 0x24, 0x24, 0x25, 0x24, 0x24, 0x25, 0x24,
> +		0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25, 0x24, 0x26,
> +		0x27, 0x26, 0x24, 0x25, 0x24, 0x26, 0x27, 0x26, 0x24, 0x25
> +	};
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0003, 0x0080);
> +
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	for (i = 0; i < ARRAY_SIZE(values_1); i++)
> +		stk11xx_write_registry(dev, 0x0000, values_1[i]);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_registry(dev, 0x0000, 0x0025);
> +		stk11xx_write_registry(dev, 0x0000, 0x0024);
> +		stk11xx_read_registry(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 1: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	for (i = 0; i < ARRAY_SIZE(values_2); i++)
> +		stk11xx_write_registry(dev, 0x0000, values_2[i]);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_registry(dev, 0x0000, 0x0025);
> +		stk11xx_write_registry(dev, 0x0000, 0x0024);
> +		stk11xx_read_registry(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 2: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	for (i = 0; i < ARRAY_SIZE(values_3); i++)
> +		stk11xx_write_registry(dev, 0x0000, values_3[i]);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +
> +	for (i = 0; i < 16; i++) {
> +		stk11xx_write_registry(dev, 0x0000, 0x0025);
> +		stk11xx_write_registry(dev, 0x0000, 0x0024);
> +		stk11xx_read_registry(dev, 0x0000, &value);
> +
> +		dev_dbg(&dev->udev->dev, "Loop 3: Read 0x0000 = %02x\n", value);
> +	}
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +	stk11xx_write_registry(dev, 0x0002, 0x006F);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk11xx_write_registry(dev, 0x0117, 0x0000);
> +	stk11xx_read_registry(dev, 0x0103, &value);
> +	stk11xx_write_registry(dev, 0x0103, 0x0001);
> +	stk11xx_read_registry(dev, 0x0103, &value);
> +	stk11xx_write_registry(dev, 0x0103, 0x0000);
> +
> +	stk11xx_write_registry(dev, 0x0000, 0x00E0);
> +	stk11xx_write_registry(dev, 0x0002, 0x00E8);
> +	stk11xx_write_registry(dev, 0x0002, 0x0068);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk1135_configure_device(dev, 0);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 1);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 2);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 3);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 4);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 5);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 6);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 7);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 8);
> +	stk11xx_check_device(dev, 65);
> +	stk11xx_write_registry(dev, 0x0200, 0x0008);
> +
> +	stk1135_configure_device(dev, 9);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0002, 0x006D);
> +	stk11xx_write_registry(dev, 0x0000, 0x0024);
> +	stk11xx_write_registry(dev, 0x0000, 0x0025);
> +	stk11xx_write_registry(dev, 0x0000, 0x0020);
> +
> +	stk1135_configure_device(dev, 10);
> +	stk11xx_write_registry(dev, 0x0200, 0x0080);
> +	stk11xx_write_registry(dev, 0x0200, 0x0000);
> +	stk11xx_write_registry(dev, 0x02FF, 0x0001);
> +	stk11xx_write_registry(dev, 0x0203, 0x00A0);
> +
> +	stk1135_camera_asleep(dev);
> +
> +	stk11xx_set_feature(dev, 0);
> +
> +	dev_info(&dev->udev->dev, "syntek USB2.0 Camera is ready\n");
> +
> +	return 0;
> +}
> +
> +/*
> + * This function must be called at first. It's the start of the
> + * initialization process. After this process, the device is
> + * completly initalized and it's ready.
> + */
> +static int stk11xx_initialize_device(struct stk11xx *dev)
> +{
> +	int ret = -1;
> +
> +	switch (dev->webcam_model) {
> +	case SYNTEK_DC1125:
> +		ret = stk1125_initialize_device(dev);
> +		break;
> +	case SYNTEK_STK1135:
> +		ret = stk1135_initialize_device(dev);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int stk11xx_usb_probe(struct usb_interface *interface,
> +			     const struct usb_device_id *id)
> +{
> +	struct stk11xx *dev = NULL;
> +	struct usb_device *udev = interface_to_usbdev(interface);
> +	struct usb_host_interface *iface_desc;
> +	struct usb_endpoint_descriptor *endpoint;
> +	size_t buffer_size;
> +	unsigned int i;
> +	int retval;
> +
> +	/* The interface are probed one by one. */
> +	/* We are interested in the video interface (always the interface '0')*/
> +	/* The interfaces '1' or '2' (if presents) are the audio control. */
> +	if (interface->cur_altsetting->desc.bInterfaceNumber > 0) {
> +		retval = -ENODEV;
> +		goto err;
> +	}
> +
> +	dev_info(&udev->dev, "Syntek USB2.0 - STK-%.4u based webcam found\n",
> +		id->driver_info == SYNTEK_DC1125 ? 1125 : 1135);
> +
> +	dev = kzalloc(sizeof(struct stk11xx), GFP_KERNEL);
> +	if (dev == NULL) {
> +		dev_err(&udev->dev, "can't alloc device info!\n");
> +		retval = -ENOMEM;
> +		goto err;
> +	}
> +
> +	mutex_init(&dev->open_lock);
> +	spin_lock_init(&dev->spinlock);
> +	init_waitqueue_head(&dev->wait_frame);
> +
> +	dev->webcam_model = id->driver_info;
> +	dev->udev = udev;
> +
> +	dev->vsettings.fps = default_fps;
> +	dev->nbuffers = 2;
> +	dev->len_per_image = PAGE_ALIGN((1280 * 1024 * 3));
> +
> +/* TODO: check why is no driver that we can see claiming the interfaces ?
> */
> +/* the apis say it should be done, none of the video usb drivers are doing
> it */
> +/* NICKLAS: Claiming the interface is usefull when the driver want manage
> severals interfaces. */
> +/*          For us, we have only one interface (the video) */
> +
> +	stk11xx_camera_on(dev);
> +
> +	/* Set up the endpoint information */
> +	/* use only the first int-in and isoc-in endpoints */
> +	/* for the current alternate setting */
> +	iface_desc = interface->cur_altsetting;
> +
> +	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> +		endpoint = &iface_desc->endpoint[i].desc;
> +
> +		if (!dev->int_in_endpointAddr && ((endpoint->bEndpointAddress &
> +					USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) &&
> +				((endpoint->bmAttributes &
> +					USB_ENDPOINT_XFERTYPE_MASK) ==
> +				USB_ENDPOINT_XFER_INT)) {
> +			/* we've found an interrupt in endpoint */
> +			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
> +
> +			dev->int_in_size = buffer_size;
> +			dev->int_in_endpointAddr =
> +					(endpoint->bEndpointAddress & 0xF);
> +		}
> +
> +		if (!dev->isoc_in_endpointAddr && ((endpoint->bEndpointAddress &
> +					USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) &&
> +				((endpoint->bmAttributes &
> +					USB_ENDPOINT_XFERTYPE_MASK) ==
> +				USB_ENDPOINT_XFER_ISOC)) {
> +			/* we've found an isoc in endpoint */
> +			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
> +
> +			dev->isoc_in_size = buffer_size;
> +			dev->isoc_in_endpointAddr =
> +					(endpoint->bEndpointAddress & 0xF);
> +		}
> +	}
> +
> +	if (!(dev->int_in_endpointAddr && dev->isoc_in_endpointAddr)) {
> +		dev_err(&udev->dev, "can't find both int-in and isoc-in "
> +				"endpoints\n");
> +		retval = -ENODEV;
> +		goto err_free;
> +	}
> +
> +	stk11xx_camera_off(dev);
> +
> +	dev->vdev = video_device_alloc();
> +	if (dev->vdev == NULL) {
> +		dev_err(&udev->dev, "can't allocate videodevice\n");
> +		retval = -ENOMEM;
> +		goto err_free;
> +	}
> +
> +	retval = stk11xx_initialize_device(dev);
> +	if (retval)
> +		goto err_vfree;
> +
> +	memcpy(dev->vdev, &stk11xx_vdev_template, sizeof(*dev->vdev));
> +
> +	video_set_drvdata(dev->vdev, dev);
> +
> +	retval = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
> +	if (retval) {
> +		dev_err(&udev->dev, "can't register video device\n");
> +		goto err_vfree;
> +	}
> +
> +	stk11xx_create_sysfs_file(dev, &class_device_attr_brightness);
> +	stk11xx_create_sysfs_file(dev, &class_device_attr_contrast);
> +	stk11xx_create_sysfs_file(dev, &class_device_attr_whitebalance);
> +	usb_set_intfdata(interface, dev);
> +
> +	return 0;
> +err_vfree:
> +	video_device_release(dev->vdev);
> +err_free:
> +	kfree(dev);
> +err:
> +	return retval;
> +}
> +
> +static void stk11xx_usb_disconnect(struct usb_interface *interface)
> +{
> +	struct stk11xx *dev = usb_get_intfdata(interface);
> +
> +	class_device_remove_file(&dev->vdev->class_dev,
> +					&class_device_attr_brightness);
> +	class_device_remove_file(&dev->vdev->class_dev,
> +					&class_device_attr_contrast);
> +	class_device_remove_file(&dev->vdev->class_dev,
> +					&class_device_attr_whitebalance);
> +	video_unregister_device(dev->vdev);
> +	kfree(dev);
> +}
> +
> +static struct usb_device_id stk11xx_usb_ids[] = {
> +	{ USB_DEVICE(USB_SYNTEK1_VENDOR_ID, USB_STK1125_PRODUCT_ID),
> +		.driver_info = SYNTEK_DC1125 },
> +	{ USB_DEVICE(USB_SYNTEK1_VENDOR_ID, USB_STK1135_PRODUCT_ID),
> +		.driver_info = SYNTEK_STK1135 },
> +	{ USB_DEVICE(USB_SYNTEK2_VENDOR_ID, USB_DC1125_PRODUCT_ID),
> +		.driver_info = SYNTEK_DC1125 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(usb, stk11xx_usb_ids);
> +
> +static struct usb_driver stk11xx_usb_driver = {
> +	.name = "usb_stk11xx_driver",
> +	.probe = stk11xx_usb_probe,
> +	.disconnect = stk11xx_usb_disconnect,
> +	.id_table = stk11xx_usb_ids,
> +};
> +
> +static int __init stk11xx_init(void)
> +{
> +	int result;
> +
> +	if (fps) {
> +		if (fps < 5 || fps > 30) {
> +			printk(KERN_ERR "stk11xx: framerate out of bounds "
> +					"[5-30]\n");
> +			return -EINVAL;
> +		}
> +
> +		default_fps = fps;
> +	}
> +
> +	result = usb_register(&stk11xx_usb_driver);
> +	if (result)
> +		printk(KERN_ERR "stk11xx: usb_register failed!\n");
> +
> +	return result;
> +}
> +
> +static void __exit stk11xx_exit(void)
> +{
> +	usb_deregister(&stk11xx_usb_driver);
> +}
> +
> +module_init(stk11xx_init);
> +module_exit(stk11xx_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Nicolas VIVIEN");
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_SUPPORTED_DEVICE("Syntek USB Camera: DC1125, STK1135");
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
