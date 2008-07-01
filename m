Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbYGABL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbYGABL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYGABLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:11:18 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:22274 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbYGABLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:11:17 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 12/13] viafb: via_i2c.c, via_i2c.h, viamode.c, viamode.c
Date: Tue, 1 Jul 2008 09:11:13 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7CE4@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080630154348.GF21835@fluff.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 12/13] viafb: via_i2c.c, via_i2c.h, viamode.c, viamode.c
Thread-Index: Acjay7VQ+NQQ6TIgTdmXJ1g+OZwkawAS4TmQ
From: <JosephChan@via.com.tw>
To: <ben-linux@fluff.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 01 Jul 2008 01:11:15.0621 (UTC) FILETIME=[5C1D3D50:01C8DB17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m611BVfq006938

Ben,

Thanks for your comments. I will inform our engineers to check those items you mentioned.

BRs,
Joseph Chan 
-----Original Message-----
From: Ben Dooks [mailto:ben-linux@fluff.org] 
Sent: Monday, June 30, 2008 11:44 PM
To: Joseph Chan
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; geert@linux-m68k.org
Subject: Re: [PATCH 12/13] viafb: via_i2c.c, via_i2c.h, viamode.c, viamode.c

On Mon, Jun 30, 2008 at 03:51:19PM +0800, JosephChan@via.com.tw wrote:
> via_i2c.c, via_i2c.h: Implement i2c specification.
> viamode.c, viamode.c: all support modes information.
> 
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
> --- a/drivers/video/via/via_i2c.c	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/via_i2c.c	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,377 @@
> +/*
> + * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
> + * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
> +
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation;
> + * either version 2, or (at your option) any later version.
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
> +#include "global.h"
> +
> +/* i2c delay for microsecond*/
> +void viafb_delays(int count)
> +{
> +	u8 data;
> +	while (count--) {
> +		/* delay 1 us */
> +		data = inb(DELAYPORT);
> +		data = inb(DELAYPORT);
> +		data = inb(DELAYPORT);
> +		data = inb(DELAYPORT);
> +		data = inb(DELAYPORT);
> +	}
> +
> +}
> +
> +/*  Write I2C BUS SDA And SCL*/
> +static void i2cWriteSdaScl(u8 sda, u8 scl) {
> +	u8 data;
> +	u16 port_addr;
> +
> +	if (viaparinfo->chip_info->chip_on_slot == PORT_ON_AMR) {
> +
> +		data = ((scl << 1) | sda) << 4;
> +		/* enable I2C port */
> +		data = data | BIT0;
> +
> +		port_addr = I2CPORT;
> +		/* Write Register Value */
> +		viafb_write_reg(I2CPORTINDEX, port_addr, data);
> +	} else {
> +		if (viaparinfo->chip_info->chip_on_slot == PORT_ON_AGP) {
> +			data = ((scl << 1) | sda) << 4;
> +			/* enable GPIO write port */
> +			data = data | (BIT6 + BIT7);
> +			port_addr = GPIOPORT;
> +			/* Write Register Value */
> +			viafb_write_reg(GPIOPORTINDEX, port_addr, data);
> +		}
> +	}
> +}
> +
> +static void i2cReadSdaScl(u8 *pSda, u8 *pScl) {
> +	u8 data;
> +	u16 port_addr;
> +
> +	if (viaparinfo->chip_info->chip_on_slot == PORT_ON_AMR) {
> +		port_addr = I2CPORT;
> +		data = viafb_read_reg(port_addr, I2CPORTINDEX);
> +		*pSda = (data >> 2) & BIT0;	/* get sda */
> +		*pScl = (data >> 3) & BIT0;	/* get scl */
> +	} else {
> +		if (viaparinfo->chip_info->chip_on_slot == PORT_ON_AGP) {
> +			port_addr = GPIOPORT;
> +			data = viafb_read_reg(port_addr, GPIOPORTINDEX);
> +			*pSda = (data >> 2) & BIT0;	/* get sda */
> +			*pScl = (data >> 3) & BIT0;	/* get scl */
> +		}
> +	}
> +}
> +
> +static void i2cWriteSdaSclDelay(u8 sda, u8 scl) {
> +	i2cWriteSdaScl(sda, scl);
> +	viafb_delays(16);		/* Wait 16 uS */
> +}
> +
> +static void i2cStartSignal(void)
> +{
> +	i2cWriteSdaSclDelay(1, 1);
> +	i2cWriteSdaSclDelay(0, 1);
> +	i2cWriteSdaSclDelay(0, 0);
> +}
> +
> +static void i2cStopSignal(void)
> +{
> +	u8 data;
> +	u16 port_addr;
> +
> +	i2cWriteSdaSclDelay(0, 0);
> +	i2cWriteSdaSclDelay(0, 1);
> +	i2cWriteSdaSclDelay(1, 1);
> +
> +	if (viaparinfo->chip_info->chip_on_slot == PORT_ON_AGP) {
> +		/* disable GPIO write port */
> +		data = 0x3c;
> +		port_addr = GPIOPORT;
> +		/* Write Register Value */
> +		viafb_write_reg(GPIOPORTINDEX, port_addr, data);
> +	}
> +	viafb_delays(2);
> +
> +}
> +
> +static void disableSdaGPIO(void)
> +{
> +	u8 data;
> +	u16 port_addr;
> +
> +	if (viaparinfo->chip_info->chip_on_slot == PORT_ON_AGP) {
> +		port_addr = GPIOPORT;
> +		data = viafb_read_reg(port_addr, GPIOPORTINDEX);
> +		/* disable GPIO write port */
> +		data = data & (~BIT6);
> +		/* Write Register Value */
> +		viafb_write_reg(GPIOPORTINDEX, port_addr, data);
> +	}
> +}
> +
> +static void writeSclGPIO(u8 scl)
> +{
> +	u8 data;
> +	u16 port_addr;
> +
> +	if (viaparinfo->chip_info->chip_on_slot == PORT_ON_AGP) {
> +		port_addr = GPIOPORT;
> +		data = viafb_read_reg(port_addr, GPIOPORTINDEX);
> +		data = data & (~BIT5);
> +		/* write data to clock */
> +		data = (data | (scl << 5)) & (~BIT6);
> +		/* Write Register Value */
> +		viafb_write_reg(GPIOPORTINDEX, port_addr, data);
> +	}
> +}
> +
> +static int i2CWaitForSlave(void)
> +{
> +	int time_out = 20000;
> +	u8 sda, scl;
> +
> +	while (time_out--) {
> +		i2cReadSdaScl(&sda, &scl);
> +		if (scl)
> +			return OK;	/* Successful stall */
> +		viafb_delays(1);	/* wait 1 uS */
> +	}
> +	return FAIL;		/* Slave fail */
> +}
> +
> +static int i2cOutByte(u8 data)
> +{
> +	u8 sda, scl;
> +	u8 out_byte;
> +	int bit_count = 8;
> +	int status;
> +
> +	out_byte = data;
> +	while (bit_count--) {
> +		sda = (out_byte >> 7) & 1;	/* Load MSB */
> +		out_byte = out_byte << 1;	/* next bit. */
> +		i2cWriteSdaSclDelay(sda, 0);
> +		i2cWriteSdaSclDelay(sda, 1);
> +
> +		status = i2CWaitForSlave();
> +		if (status == FAIL)
> +			return status;
> +		i2cWriteSdaSclDelay(sda, 0);
> +
> +	}
> +
> +	if ((viaparinfo->chip_info->chip_on_slot == PORT_ON_AGP)) {
> +
> +		writeSclGPIO(0);
> +		disableSdaGPIO();
> +		viafb_delays(2);
> +		writeSclGPIO(1);
> +		viafb_delays(2);
> +		i2cReadSdaScl(&sda, &scl);
> +		writeSclGPIO(0);
> +		viafb_delays(2);
> +		if (sda == 0)
> +			status = OK;
> +		else
> +			status = FAIL;
> +	} else {
> +		i2cWriteSdaSclDelay(1, 0);
> +		i2cWriteSdaSclDelay(1, 1);
> +		status = i2CWaitForSlave();
> +		if (status == FAIL)
> +			return status;
> +
> +		i2cReadSdaScl(&sda, &scl);
> +		if (sda == 0) {
> +			i2cWriteSdaSclDelay(1, 0);
> +			status = OK;
> +		} else {
> +
> +			i2cWriteSdaSclDelay(1, 0);
> +			status = FAIL;
> +		}
> +	}
> +	return status;
> +}
> +
> +static int i2cInputByte(u8 *pInByte, int ack) {
> +
> +	int bit_count = 8;
> +	u8 sda, scl;
> +	u8 data = 0;
> +	int status;
> +
> +	disableSdaGPIO();
> +
> +	while (bit_count--) {
> +		if ((viaparinfo->chip_info->chip_on_slot == PORT_ON_AGP)) {
> +
> +			writeSclGPIO(1);
> +			viafb_delays(2);
> +			status = i2CWaitForSlave();
> +			if (status == FAIL)
> +				return FAIL;
> +			i2cReadSdaScl(&sda, &scl);
> +			data = data << 1;
> +			data |= sda;
> +			writeSclGPIO(0);
> +			viafb_delays(2);
> +
> +		} else {
> +			i2cWriteSdaSclDelay(1, 1);
> +			status = i2CWaitForSlave();
> +			if (status == FAIL)
> +				return FAIL;
> +			i2cReadSdaScl(&sda, &scl);
> +			data = data << 1;
> +			data |= sda;
> +			i2cWriteSdaSclDelay(1, 0);
> +		}
> +	}
> +	*pInByte = data;
> +
> +	if (ack) {
> +		i2cWriteSdaSclDelay(0, 0);
> +		i2cWriteSdaSclDelay(0, 1);
> +		status = i2CWaitForSlave();
> +		if (status == FAIL)
> +			return status;
> +		i2cWriteSdaSclDelay(0, 0);
> +	} else {
> +		i2cWriteSdaSclDelay(1, 0);
> +		i2cWriteSdaSclDelay(1, 1);
> +		status = i2CWaitForSlave();
> +		if (status == FAIL)
> +			return status;
> +	}
> +	i2cWriteSdaSclDelay(1, 0);
> +
> +	return OK;
> +}
> +
> +int viafb_i2cReadByte(u8 slave_addr, u8 index, u8 *pData) {
> +
> +	int status;
> +
> +	i2cStartSignal();
> +
> +	status = i2cOutByte(slave_addr);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +	status = i2cOutByte(index);
> +
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +
> +	i2cStartSignal();
> +	status = i2cOutByte(slave_addr | BIT0);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +	status = i2cInputByte(pData, 0);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +
> +	i2cStopSignal();
> +	return OK;
> +}
> +
> +int viafb_i2cWriteByte(u8 slave_addr, u8 index, u8 data) {
> +
> +	int status;
> +
> +	i2cStartSignal();
> +	status = i2cOutByte(slave_addr);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +	status = i2cOutByte(index);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +	status = i2cOutByte(data);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +	i2cStopSignal();
> +	return OK;
> +}
> +
> +int viafb_i2cReadBytes(u8 slave_addr, u8 index, u8 *buff, int 
> +buff_len) {
> +
> +	int status, i;
> +
> +	i2cStartSignal();
> +
> +	status = i2cOutByte(slave_addr);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +
> +	status = i2cOutByte(index);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +
> +	i2cStartSignal();
> +	status = i2cOutByte(slave_addr | BIT0);
> +	if (status == FAIL) {
> +		i2cStopSignal();
> +		return FAIL;
> +	}
> +
> +	for (i = 0; i < buff_len; i++) {
> +		if (buff_len == 1)
> +			status = i2cInputByte(buff, 0);	/* send NACK */
> +		else if (i < buff_len - 1)
> +			status = i2cInputByte(buff, 1);	/* send ACK */
> +		else
> +			status = i2cInputByte(buff, 0);	/* send NACK */
> +		if (status == FAIL) {
> +			i2cStopSignal();
> +			return (FAIL);
> +		}
> +		buff++;
> +	}
> +
> +	i2cStopSignal();
> +	return OK;
> +}

This looks like an attempt at re-doing the already extant i2c gpio algorithm. Either export via gpiolib and use the i2c-gpio adapter or use the i2c bit-banging algorithm.

--
Ben

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
