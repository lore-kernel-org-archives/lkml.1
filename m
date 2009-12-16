Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbZLPAiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbZLPAiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934235AbZLPAiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:38:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59143 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761449AbZLPAiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:38:07 -0500
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
From: Keith Mannthey <kmannth@us.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20091215164950.1fd41caf@bike.lwn.net>
References: <1260907788.6521.10.camel@keith-laptop>
	 <20091215164950.1fd41caf@bike.lwn.net>
Content-Type: text/plain
Date: Tue, 15 Dec 2009 16:38:05 -0800
Message-Id: <1260923885.6521.41.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 16:49 -0700, Jonathan Corbet wrote:
> On Tue, 15 Dec 2009 12:09:48 -0800
> Keith Mannthey <kmannth@us.ibm.com> wrote:
> 
> > This driver supports the Real-Time Linux (RTL) BIOS feature.  The RTL
> > feature allows non-fatal System Management Interrupts (SMIs) to be
> > disabled on supported IBM platforms. 
> 
> ...and that seems like a really useful thing to be able to do.
> 
> A few notes, while I was in the neighborhood...
> 
> 
> > --- linux-2.6.32/drivers/misc/ibmrtl/ibm_rtl.c	1969-12-31 16:00:00.000000000 -0800
> > +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/ibm_rtl.c	2009-12-14 16:37:19.000000000 -0800
> 
> Do you need to create a new directory for a single .c file?

Perhaps not. I have a single .h and a single .c file. 
Do you think I should move them right into misc (with maybe a better
name the rtl.h)? 

> > @@ -0,0 +1,189 @@
> > +/*
> > + * IBM Premium Real-Time Mode Device Driver
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright (C) IBM Corporation, 2008, 2009
> > + *
> > + * Author: Keith Mannthey <kmannth@us.ibm.com>
> > + *
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/delay.h>
> > +#include <linux/module.h>
> > +#include <linux/io.h>
> > +#include <linux/sysdev.h>
> > +#include <asm/byteorder.h>
> > +#include "rtl.h"
> > +
> > +static spinlock_t rtl_lock;
> 
> You should probably include <linux/spinlock.h> for this.

ack. 

> > +static void __iomem *rtl_table;
> > +static void __iomem *edba_map;
> > +
> > +static int ibm_rtl_write(u8 value)
> > +{
> > +	int count = 0, ret = 0;
> > +	u32 cmd_prt_value, cmd_port_addr;
> > +
> > +	if ((value != RTL_ENABLE) && (value != RTL_DISABLE))
> > +		return -EINVAL;
> > +
> > +	spin_lock(&rtl_lock);
> > +
> > +	if (readb(rtl_table+RTL_STATE) != value) {
> > +		writeb(value, (rtl_table+RTL_CMD));
> > +
> > +		/* Trigger the command to be processed*/
> > +		cmd_prt_value = readw(rtl_table + RTL_CMD_PORT_VALUE);
> > +		cmd_port_addr = readw(rtl_table + RTL_CMD_PORT_ADDR);
> > +		outb(cmd_prt_value, cmd_port_addr);
> > +
> > +		/* Wait for the command to finish */
> > +		while (readb(rtl_table+RTL_CMD)) {
> > +			mdelay(10);
> 
> For a driver which is intended to help reduce latencies, a 10ms delay with
> a spinlock held seems a little harsh.  It seems like maybe you could drop
> the lock and use msleep()?

Irony is that doing this special write actually triggers an SMI. 

Well I really don't want any other possible action to happen until after
the command finishes.  I can definitely shorten the amount of time of
the mdelay but I don't want any possible way to start another write
until the command finishes.  

> > +			if (count++ > 10000) {
> 
> ...that's 100 seconds total - a *long* time...

The is a "possible" error condition that I have given a large window
too. More than happy to shorten it up to say a small human amount of
time maybe 2 seconds?

> > +				printk(KERN_ERR "IBM_RTL: Hardware not "
> > +					"responding to mode switch request\n");
> > +				spin_unlock(&rtl_lock);
> > +				return -EIO;
> > +			}
> > +		}
> > +
> > +		if (readb(rtl_table + RTL_CMD_STATUS))
> > +			ret = -EIO;
> > +	}
> > +
> > +	spin_unlock(&rtl_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static ssize_t rtl_show_version(struct sysdev_class *dev, char *buf)
> > +{
> > +	return sprintf(buf, "%d\n", (int) readb(rtl_table+RTL_VERSION));
> > +}
> > +
> > +static ssize_t rtl_show_state(struct sysdev_class *dev, char *buf)
> > +{
> > +	return sprintf(buf, "%d\n", readb(rtl_table+RTL_STATE));
> > +}
> > +
> > +static ssize_t rtl_set_state(struct sysdev_class *dev, const char *buf,
> > +				 size_t size)
> > +{
> > +	ssize_t ret;
> > +
> > +	if (size != 2)
> > +		return -EINVAL;
> 
> People do use "echo -n" to write to sysfs files sometimes.

I fill fix this up to allow for non null terminated inputs.  

What is the proper return?  Always whatever was inputted should I always
be retuning 1? 

> > +
> > +	switch (buf[0]) {
> > +	case '0':
> > +		ret = ibm_rtl_write(RTL_DISABLE);
> > +		break;
> > +	case '1':
> > +		ret = ibm_rtl_write(RTL_ENABLE);
> > +		break;
> > +	default:
> > +		ret = -EINVAL;
> > +	}
> > +	if (ret >= 0)
> > +		ret = size;
> > +
> > +	return ret;
> > +}
> > +
> > +static struct sysdev_class class_rtl = {
> > +	.name = "ibm_rtl",
> > +};
> > +
> > +static SYSDEV_CLASS_ATTR(version, S_IRUGO, rtl_show_version, NULL);
> > +static SYSDEV_CLASS_ATTR(state, 0600, rtl_show_state, rtl_set_state);
> > +
> > +static struct sysdev_class_attribute *rtl_attributes[] = {
> > +	&attr_version,
> > +	&attr_state,
> > +	NULL
> > +};
> > +
> > +static int rtl_setup_sysfs(void)
> > +{
> > +	int ret, i;
> > +
> > +	ret = sysdev_class_register(&class_rtl);
> > +
> > +	if (!ret) {
> > +		for (i = 0; rtl_attributes[i]; i++)
> > +			sysdev_class_create_file(&class_rtl, rtl_attributes[i]);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static void rtl_teardown_sysfs(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; rtl_attributes[i]; i++)
> > +		sysdev_class_remove_file(&class_rtl, rtl_attributes[i]);
> > +
> > +	sysdev_class_unregister(&class_rtl);
> > +	return;
> > +}
> > +
> > +/* Only allow the modules to load if the _RTL_ table can be found */
> > +int init_module(void)
> 
> This needs to be static.
> 
> > +{
> > +	unsigned long ebda_size, ebda_addr;
> > +	unsigned int ebda_kb;
> > +	u32 *table;
> > +	int ret;
> > +
> > +	/* Get the address for the Extende Biso Data Area */
> > +	ebda_addr = *(u16 *) phys_to_virt(EDBA_ADDR);
> > +	ebda_addr <<= 4;
> > +	edba_map = ioremap(ebda_addr, 4);
> 
> Me confused.  Where is this data area, and how are you remapping it?  This
> could use an explanatory comment.

Sorry I foobrrd that comment.  This table is the EDBA (Extened BIOS Data
Area).  As Alan has pointed up I am still not accessing it correctly.
On machines where it is present the EDBA is at 0x40E physical. 

> > +	if (!edba_map)
> > +		return -ENOMEM;
> > +
> > +	/* First word in the EDBA is the Size in KB */
> > +	ebda_kb = *(u32 *) edba_map;
> 
> Probably better to use ioread32() here.

Yes I appears I need to do an ioread to even tell if the table is
there. 

> > +	ebda_size = ebda_kb*1024;
> > +	iounmap(edba_map);
> > +
> > +	/* Remap the whole table */
> > +	edba_map = ioremap(ebda_addr, ebda_size);
> > +	if (!edba_map)
> > +		return -ENOMEM;
> > +
> > +	for (table = (u32 *) edba_map ; \
> > +			table < (u32 *) edba_map + ebda_size/4; table++)
> > +		if (*table == RTL_MAGIC_IDENT) {
> 
> Again, you should use ioread32() here.

I should never directly access the ioremap region? 

> > +			rtl_table = table;
> > +			ret = rtl_setup_sysfs();
> > +			return ret;
> > +		}
> > +
> > +	ret = -ENODEV;
> > +	iounmap(edba_map);
> > +	return ret;
> > +}
> > +
> > +void cleanup_module(void)
> 
> static
> 
> > +{
> > +	rtl_teardown_sysfs();
> > +	iounmap(edba_map);
> > +}
> > +
> > +MODULE_LICENSE("GPL");
> > diff -urN linux-2.6.32/drivers/misc/ibmrtl/Makefile linux-2.6.32-rtl/drivers/misc/ibmrtl/Makefile
> > --- linux-2.6.32/drivers/misc/ibmrtl/Makefile	1969-12-31 16:00:00.000000000 -0800
> > +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/Makefile	2009-12-11 10:24:23.000000000 -0800
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_IBM_RTL) := ibm_rtl.o
> > diff -urN linux-2.6.32/drivers/misc/ibmrtl/rtl.h linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h
> > --- linux-2.6.32/drivers/misc/ibmrtl/rtl.h	1969-12-31 16:00:00.000000000 -0800
> > +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h	2009-12-11 10:24:23.000000000 -0800
> > @@ -0,0 +1,27 @@
> > +#include <linux/io.h>
> > +
> > +/* The RTL table looks something like
> > +	u8 signature[5];
> > +	u8 version;
> > +	u8 RT_Status;
> > +	u8 Command;
> > +	u8 CommandStatus;
> > +	u8 CMDAddressType;
> > +	u8 CmdGranularity;
> > +	u8 CmdOffset;
> > +	u16 Reserve1;
> > +	u8 CmdPortAddress[4];
> > +	u8 CmdPortValue[4];
> > +*/
> > +#define RTL_TABLE_SIZE 0x16
> > +#define RTL_MAGIC_IDENT (('L'<<24)|('T'<<16)|('R'<<8)|'_')
> > +#define RTL_VERSION 0x5
> > +#define RTL_STATE 0x6
> > +#define RTL_CMD 0x7
> > +#define RTL_CMD_STATUS 0x8
> > +#define RTL_CMD_PORT_ADDR 0xE
> > +#define RTL_CMD_PORT_VALUE 0x12
> > +
> > +#define EDBA_ADDR 0x40E
> > +#define RTL_ENABLE 1
> > +#define RTL_DISABLE 2
> 
> These seem like a bit of a strange obfuscation; why not just use a normal,
> zero-or-one int value?

The firmware uses 1 and 2 to represent "on and off".  The driver uses 0
and 1 at the sysfs level as it is more analogous to me for "on and off".
Passing "1" or "2" as arguments into the function seems more unclear to
me at least.  

Thanks,
  Keith Mannthey 
  LTC Real-Time 

