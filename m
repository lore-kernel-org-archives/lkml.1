Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbYIJPnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbYIJPnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIJPm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:42:56 -0400
Received: from vena.lwn.net ([206.168.112.25]:56450 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYIJPmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:42:55 -0400
Date: Wed, 10 Sep 2008 09:42:53 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux-kernel@vger.kernel.org, Janne Grunau <j@jannua.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 05/18] lirc driver for i2c-based IR receivers
Message-ID: <20080910094253.73a03ab3@bike.lwn.net>
In-Reply-To: <1220933164-10160-6-git-send-email-jwilson@redhat.com>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com>
	<1220933164-10160-2-git-send-email-jwilson@redhat.com>
	<1220933164-10160-3-git-send-email-jwilson@redhat.com>
	<1220933164-10160-4-git-send-email-jwilson@redhat.com>
	<1220933164-10160-5-git-send-email-jwilson@redhat.com>
	<1220933164-10160-6-git-send-email-jwilson@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config LIRC_I2C
> +	tristate "I2C Based IR Receivers"
> +	default n
> +	depends on LIRC_DEV
> +	help
> +	  Driver for I2C-based IR receivers, such as those commonly
> +	  found onboard Hauppauge PVR-150/250/350 video capture cards

This driver offers relatively few things to gripe about.  But I'm not one
to shrink from a challenge...

> +#include <linux/semaphore.h>

It looks like this driver is semaphore-free?  Actually, it looks kind of
lock-free in general.  That's probably my biggest concern; what is
protecting against concurrent operations on the device?

> +static int add_to_buf_pcf8574(void *data, struct lirc_buffer *buf)
> +{
> +	struct IR *ir = data;
> +	int rc;
> +	unsigned char all, mask;
> +	unsigned char key;
> +
> +	/* compute all valid bits (key code + pressed/release flag) */
> +	all = ir->bits | ir->flag;
> +
> +	/* save IR writable mask bits */
> +	mask = i2c_smbus_read_byte(&ir->c) & ~all;
> +
> +	/* send bit mask */
> +	rc = i2c_smbus_write_byte(&ir->c, (0xff & all) | mask);
> +
> +	/* receive scan code */
> +	rc = i2c_smbus_read_byte(&ir->c);
> +
> +	if (rc == -1) {
> +		dprintk("%s read error\n", ir->c.name);
> +		return -EIO;
> +	}

This ignores the return value from the first i2c_smbus_read_byte() and
i2c_smbus_write_byte() calls.  Beyond that, i2c_smbus_read_byte() can
return -EANYTHING, so I think the check should be "rc < 0", no?  Tests
against -1 are common in this driver, I'll not point them all out.

> +static int ir_attach(struct i2c_adapter *adap, int addr,
> +		     unsigned short flags, int kind)
> +{

...

> +	ir->l.minor = lirc_register_plugin(&ir->l);
> +
> +	return 0;
> +}

The lirc_register_plugin() call can fail, the result should be checked.

> +#ifdef MODULE
> +
> +int init_module(void)
> +{
> +	request_module("bttv");
> +	request_module("rivatv");
> +	request_module("ivtv");
> +	request_module("cx8800");
> +	i2c_add_driver(&driver);
> +	return 0;
> +}

Why are all these modules being loaded here?  That would seem like a job
for udev.

jon
