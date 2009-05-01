Return-Path: <linux-kernel-owner+w=401wt.eu-S1763292AbZEATQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763292AbZEATQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZEATQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:16:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59548 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755105AbZEATQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:16:03 -0400
Date: Fri, 1 May 2009 15:16:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@users.sf.net>
cc: Robert Hancock <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
In-Reply-To: <20090501091501.GA29466@ime.usp.br>
Message-ID: <Pine.LNX.4.44L0.0905011509220.2989-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, [utf-8] Rogério Brito wrote:

> > It's not all that simple.  The host controller allows the OS to set the
> > number of hardware retries to 1, 2, 3, or unlimited.  Linux uses 3;  
> > those XactErr debugging messages in your log show that the driver was
> > extending the number of retries in software.
> 
> Right. I didn't know that. Obviously, setting it to unlimited can give
> undefined behavior of the computer.

No, the behavior would be defined.  But it wouldn't be what we want.  
Instead of getting an immediate error followed by a reset, you would 
have to wait for the command to time out (somewhere between 10 and 30 
seconds) before the reset occurred.

> > It's not possible to change the time interval between retries done by
> > the hardware.  While it is possible in theory to change the interval
> > between retries done by the driver, it would be rather difficult and
> > so ehci-hcd doesn't attempt it.
> 
> Oh, what a pity. It seems that the device at hand sort of gets in shape
> again after some time, since I have an automounter here and the device
> nodes appear again under dev and it auto-mounts the device at the
> appropriate mount point. Weird.

There is probably a reset in between.  I doubt that the device recovers 
all by itself.

> > The software retries were introduced to solve one particular problem:
> > Many EHCI controllers will generate a transaction error if a data
> > transfer is occurring on one port at the same time as a device is
> > being unplugged on another port.
> 
> Right. I just got myself a (non powered) USB hub and I noticed one thing
> (unrelated to this problem): if I plug a USB disk to this hub and, then,
> plug a printer, very weird things happen, like the disc being unmounted
> or things like that.

That is different from what I was talking about.  The Intel controllers 
in question work okay when a new device is plugged in, but they get 
errors when a device is unplugged.

> > This is clearly a hardware bug, and the software retries were intended
> > to work around it.  In practice only a couple of software retries are
> > needed; if the transfer hasn't succeeded by that point then it's never
> > going to succeed.  I set the upper limit to 32 retries just to be
> > conservative.
> 
> OK. Thanks for the nice and clear explanation of the problem. I only
> wonder why I not seeing these errors on other machines while I *do* see
> them on other machines (this one is an intel ICH5).

Quality varies a lot with USB components, and sometimes you can't tell 
where the problem is.

I've got a USB disk drive and cable that do not work on my home PC, 
although they do work on my office PC.  If I use a different cable then 
the drive does work on the home PC.  If I use the same cable but 
substitute a USB stick for the drive, again it works.  So which 
component is bad: the home PC, the cable, or the drive?

> > If transaction errors aren't caused by noise in the cable then they
> > are almost always caused by bugs or failures in the device.
> 
> I will try again with a shorter and newer cable. Let's see how that
> works. BTW, is there any way to check the quality of a cable? I have a
> multimeter here and I would be willing to do some extensive tests.
> Testing the USB enclosure is also pretty feasible.

I don't know any way to test these things without using some pretty
fancy equipment.

Alan Stern

