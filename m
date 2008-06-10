Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbYFJVDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbYFJVDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbYFJVCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:02:49 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:24888 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758308AbYFJVCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:02:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KxUaPr2OXaa/kP96UmLsXMgx+mVhNUW9JNnTtApkelSJhdqSjbThCeyS8D+gz7jFgdRfQIKxR8n1h7qwtDbxYOC1aXmCaUo0OmtUgv4LZuS6+vEqKWRQz/b1Ya8ndJskcXqw98/oHZrBApuuJQ1VwbgcaapMwp2ohHBHVaVh0vw=  ;
X-YMail-OSG: EY6deHcVM1khgMEN5U2uvY2r6TNmJgTwMhsIcDWKVf03orZZ1yWohxdhjhuCUcp2GZqJMeu3cTYYEoPVsUA1QRtXEHdeI2uOWXJm91AUgpVBkGRUdUV5CIflhvrIg1g_Z5Y-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Date: Tue, 10 Jun 2008 13:55:07 -0700
User-Agent: KMail/1.9.9
Cc: Ryan Mallon <ryan@bluewatersys.com>, Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <200806091541.43899.u.luckas@road.de> <484DA046.4010804@bluewatersys.com> <20080610085708.12c2d2a2@hyperion.delvare>
In-Reply-To: <20080610085708.12c2d2a2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101355.07792.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>> i2c should really be initialised before framebuffer devices because
> > >>> framebuffer devices tend to want to read DDC from monitors, which is
> > >>> basically a I2C EEPROM in the monitor.
> 
> This is already the case. i2c-core is initialized with
> subsys_initcall(), so it's available to all drivers initialized with
> module_init().

That's only one of many examples.  The more general reason to
want to change the position of I2C so it's early in the link
order (like many other "system" busses) is to ensure that I2C
drivers can rely on that initialization no matter where they
are in *link order* ... it's not just an init sequence issue.


> > >>> ... but there's probably some reason why it's done the way it is today,
> > >>> and changing it could well cause stuff to break.
> > >>>       
> > >> We have made i2c the first driver subsystem to come up in our 2.6.20
> > >> kernel since we use i2c io expanders for power domain control. All we
> > >> did was change drivers/Makefile so that obj-$(CONFIG_I2C) += i2c/ is at
> > >> the very top of the file. We didn't have any problems with doing this.
> > >> YMMV of course.
> 
> Why don't you simply initialize the drivers in question with
> subsys_initcall()? That's what i2c-pnx, i2c-omap, i2c-davinci and
> tps65010 are doing at the moment.

If they happen to sit outside the I2C tree and *before* it in
link order, things will misbehave.

Agreed init sequencing declarations should Do The Right Thing.
But those declarations are of two types:  *_initcall() stuff,
and link order.  We've seen cases where the initcalls alone are
insufficient.

> >  
> > +obj-y				+= i2c/
> >  obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
> 
> Some i2c bus drivers bit-bang GPIO pins...
> 
> >  obj-$(CONFIG_PCI)		+= pci/
> 
> ... and many are PCI devices, so will this work OK?

The gpiochip_add() function needed a bit of care to ensure that
platforms can use GPIOs well before tasking and IRQs work, and
thus before any initcalls run.  So that's not a problem.

Re PCI ... someone could investigate.


For the record, the OMAP tree puts I2C in the link order
later than this.  It wasn't moved earlier mostly out of
paranoia like yours.  (See below.  I'm not sure why "cbus"
is listed twice, or what OMAP boards have similar issues
with serio ...)

- Dave

# we also need input/serio early so serio bus is initialized by the time
# serial drivers start registering their serio ports
obj-$(CONFIG_SERIO)             += input/serio/
obj-y                           += serial/
obj-$(CONFIG_PARPORT)           += parport/
obj-y                           += base/ block/ misc/ mfd/ net/ media/ cbus/
obj-y                           += i2c/
obj-y                           += cbus/
obj-$(CONFIG_ARCH_OMAP)         += dsp/dspgateway/
obj-$(CONFIG_NUBUS)             += nubus/
obj-$(CONFIG_ATM)               += atm/
obj-y                           += macintosh/
obj-$(CONFIG_IDE)               += ide/
obj-$(CONFIG_SCSI)              += scsi/
obj-$(CONFIG_ATA)               += ata/
obj-$(CONFIG_FUSION)            += message/
 
