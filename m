Return-Path: <linux-kernel-owner+w=401wt.eu-S932971AbZLOXt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbZLOXt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZLOXty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:49:54 -0500
Received: from tex.lwn.net ([70.33.254.29]:47566 "EHLO tex.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbZLOXty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:49:54 -0500
Date: Tue, 15 Dec 2009 16:49:50 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
Message-ID: <20091215164950.1fd41caf@bike.lwn.net>
In-Reply-To: <1260907788.6521.10.camel@keith-laptop>
References: <1260907788.6521.10.camel@keith-laptop>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.19.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 12:09:48 -0800
Keith Mannthey <kmannth@us.ibm.com> wrote:

> This driver supports the Real-Time Linux (RTL) BIOS feature.  The RTL
> feature allows non-fatal System Management Interrupts (SMIs) to be
> disabled on supported IBM platforms. 

...and that seems like a really useful thing to be able to do.

A few notes, while I was in the neighborhood...


> --- linux-2.6.32/drivers/misc/ibmrtl/ibm_rtl.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/ibm_rtl.c	2009-12-14 16:37:19.000000000 -0800

Do you need to create a new directory for a single .c file?

> @@ -0,0 +1,189 @@
> +/*
> + * IBM Premium Real-Time Mode Device Driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2008, 2009
> + *
> + * Author: Keith Mannthey <kmannth@us.ibm.com>
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/sysdev.h>
> +#include <asm/byteorder.h>
> +#include "rtl.h"
> +
> +static spinlock_t rtl_lock;

You should probably include <linux/spinlock.h> for this.

> +static void __iomem *rtl_table;
> +static void __iomem *edba_map;
> +
> +static int ibm_rtl_write(u8 value)
> +{
> +	int count = 0, ret = 0;
> +	u32 cmd_prt_value, cmd_port_addr;
> +
> +	if ((value != RTL_ENABLE) && (value != RTL_DISABLE))
> +		return -EINVAL;
> +
> +	spin_lock(&rtl_lock);
> +
> +	if (readb(rtl_table+RTL_STATE) != value) {
> +		writeb(value, (rtl_table+RTL_CMD));
> +
> +		/* Trigger the command to be processed*/
> +		cmd_prt_value = readw(rtl_table + RTL_CMD_PORT_VALUE);
> +		cmd_port_addr = readw(rtl_table + RTL_CMD_PORT_ADDR);
> +		outb(cmd_prt_value, cmd_port_addr);
> +
> +		/* Wait for the command to finish */
> +		while (readb(rtl_table+RTL_CMD)) {
> +			mdelay(10);

For a driver which is intended to help reduce latencies, a 10ms delay with
a spinlock held seems a little harsh.  It seems like maybe you could drop
the lock and use msleep()?

> +			if (count++ > 10000) {

...that's 100 seconds total - a *long* time...

> +				printk(KERN_ERR "IBM_RTL: Hardware not "
> +					"responding to mode switch request\n");
> +				spin_unlock(&rtl_lock);
> +				return -EIO;
> +			}
> +		}
> +
> +		if (readb(rtl_table + RTL_CMD_STATUS))
> +			ret = -EIO;
> +	}
> +
> +	spin_unlock(&rtl_lock);
> +
> +	return ret;
> +}
> +
> +static ssize_t rtl_show_version(struct sysdev_class *dev, char *buf)
> +{
> +	return sprintf(buf, "%d\n", (int) readb(rtl_table+RTL_VERSION));
> +}
> +
> +static ssize_t rtl_show_state(struct sysdev_class *dev, char *buf)
> +{
> +	return sprintf(buf, "%d\n", readb(rtl_table+RTL_STATE));
> +}
> +
> +static ssize_t rtl_set_state(struct sysdev_class *dev, const char *buf,
> +				 size_t size)
> +{
> +	ssize_t ret;
> +
> +	if (size != 2)
> +		return -EINVAL;

People do use "echo -n" to write to sysfs files sometimes.

> +
> +	switch (buf[0]) {
> +	case '0':
> +		ret = ibm_rtl_write(RTL_DISABLE);
> +		break;
> +	case '1':
> +		ret = ibm_rtl_write(RTL_ENABLE);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +	if (ret >= 0)
> +		ret = size;
> +
> +	return ret;
> +}
> +
> +static struct sysdev_class class_rtl = {
> +	.name = "ibm_rtl",
> +};
> +
> +static SYSDEV_CLASS_ATTR(version, S_IRUGO, rtl_show_version, NULL);
> +static SYSDEV_CLASS_ATTR(state, 0600, rtl_show_state, rtl_set_state);
> +
> +static struct sysdev_class_attribute *rtl_attributes[] = {
> +	&attr_version,
> +	&attr_state,
> +	NULL
> +};
> +
> +static int rtl_setup_sysfs(void)
> +{
> +	int ret, i;
> +
> +	ret = sysdev_class_register(&class_rtl);
> +
> +	if (!ret) {
> +		for (i = 0; rtl_attributes[i]; i++)
> +			sysdev_class_create_file(&class_rtl, rtl_attributes[i]);
> +	}
> +	return ret;
> +}
> +
> +static void rtl_teardown_sysfs(void)
> +{
> +	int i;
> +
> +	for (i = 0; rtl_attributes[i]; i++)
> +		sysdev_class_remove_file(&class_rtl, rtl_attributes[i]);
> +
> +	sysdev_class_unregister(&class_rtl);
> +	return;
> +}
> +
> +/* Only allow the modules to load if the _RTL_ table can be found */
> +int init_module(void)

This needs to be static.

> +{
> +	unsigned long ebda_size, ebda_addr;
> +	unsigned int ebda_kb;
> +	u32 *table;
> +	int ret;
> +
> +	/* Get the address for the Extende Biso Data Area */
> +	ebda_addr = *(u16 *) phys_to_virt(EDBA_ADDR);
> +	ebda_addr <<= 4;
> +	edba_map = ioremap(ebda_addr, 4);

Me confused.  Where is this data area, and how are you remapping it?  This
could use an explanatory comment.

> +	if (!edba_map)
> +		return -ENOMEM;
> +
> +	/* First word in the EDBA is the Size in KB */
> +	ebda_kb = *(u32 *) edba_map;

Probably better to use ioread32() here.

> +	ebda_size = ebda_kb*1024;
> +	iounmap(edba_map);
> +
> +	/* Remap the whole table */
> +	edba_map = ioremap(ebda_addr, ebda_size);
> +	if (!edba_map)
> +		return -ENOMEM;
> +
> +	for (table = (u32 *) edba_map ; \
> +			table < (u32 *) edba_map + ebda_size/4; table++)
> +		if (*table == RTL_MAGIC_IDENT) {

Again, you should use ioread32() here.

> +			rtl_table = table;
> +			ret = rtl_setup_sysfs();
> +			return ret;
> +		}
> +
> +	ret = -ENODEV;
> +	iounmap(edba_map);
> +	return ret;
> +}
> +
> +void cleanup_module(void)

static

> +{
> +	rtl_teardown_sysfs();
> +	iounmap(edba_map);
> +}
> +
> +MODULE_LICENSE("GPL");
> diff -urN linux-2.6.32/drivers/misc/ibmrtl/Makefile linux-2.6.32-rtl/drivers/misc/ibmrtl/Makefile
> --- linux-2.6.32/drivers/misc/ibmrtl/Makefile	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/Makefile	2009-12-11 10:24:23.000000000 -0800
> @@ -0,0 +1 @@
> +obj-$(CONFIG_IBM_RTL) := ibm_rtl.o
> diff -urN linux-2.6.32/drivers/misc/ibmrtl/rtl.h linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h
> --- linux-2.6.32/drivers/misc/ibmrtl/rtl.h	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h	2009-12-11 10:24:23.000000000 -0800
> @@ -0,0 +1,27 @@
> +#include <linux/io.h>
> +
> +/* The RTL table looks something like
> +	u8 signature[5];
> +	u8 version;
> +	u8 RT_Status;
> +	u8 Command;
> +	u8 CommandStatus;
> +	u8 CMDAddressType;
> +	u8 CmdGranularity;
> +	u8 CmdOffset;
> +	u16 Reserve1;
> +	u8 CmdPortAddress[4];
> +	u8 CmdPortValue[4];
> +*/
> +#define RTL_TABLE_SIZE 0x16
> +#define RTL_MAGIC_IDENT (('L'<<24)|('T'<<16)|('R'<<8)|'_')
> +#define RTL_VERSION 0x5
> +#define RTL_STATE 0x6
> +#define RTL_CMD 0x7
> +#define RTL_CMD_STATUS 0x8
> +#define RTL_CMD_PORT_ADDR 0xE
> +#define RTL_CMD_PORT_VALUE 0x12
> +
> +#define EDBA_ADDR 0x40E
> +#define RTL_ENABLE 1
> +#define RTL_DISABLE 2

These seem like a bit of a strange obfuscation; why not just use a normal,
zero-or-one int value?

jon
