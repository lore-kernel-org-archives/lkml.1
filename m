Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYGXMNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYGXMNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYGXMNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:13:47 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:39580 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYGXMNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:13:46 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48887201.8090300@cam.ac.uk>
Date: Thu, 24 Jul 2008 13:13:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Eric Piel <eric.piel@tremplin-utc.net>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>, mgross@linux.intel.com,
       Dmitry Torokhov <dtor@mail.ru>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       David Brownell <david-b@pacbell.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: [spi-devel-general] [Patch 0/4] IndustrialIO subsystem (ADCs,
 accelerometers etc)
References: <488763AD.4050400@gmail.com>	<20080723174801.GC11009@khazad-dum.debian.net> <48884F04.4070403@tremplin-utc.net>
In-Reply-To: <48884F04.4070403@tremplin-utc.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I'd like to see something done to have the common parts of interfaces of the
>> same class (e.g. accelerometers) be standard.  Like hwmon does with
>> temp#_input, etc.
>>
>> Otherwise you made it easier to write drivers, but did nothing to help
>> userspace to USE the drivers :-)
> Hi,
> I completely agree with Henrique. There already exist 3 accelerometer 
> drivers in the kernel (and I'm writing a fourth on). What we are 
> desperately in need of is a _user_ interface. So that a generic program 
> can pop up and say "Oh, there is an accelerometer on this computer, I'll 
> use it to detect free falls."
Agreed. (though on the whole I don't like testing that particular
functionality ;)
> 
> IMHO, I think the ADC should have a much more specific and specialised 
> (user and kernel) API corresponding to the accelerometers. Granted, you 
> probably had in mind only the accelerometers for industrial usage, but 
> it would be much better if the current accelerometer drivers had a 
> reason to be ported to this new subsystem.> 

> In particular, what I think would be worthy would be:
> * Up to 3 pre-defined axes (X, Y, Z) - that's provided by your current 
> version of industrialio
> * If the accelerometer is soldered on the computer, define once for all 
> to which _physical_ movement corresponds which axis (eg: a laptop on its 
> normal position going up has axis Z increasing).
Agreed, though this is more documentation (and strict enforcement on drivers)
> * Free fall event. Either it's hardware detected, or the accelerometer 
> infrastructure will detect it in software.
Hadn't thought of doing that in software - should be relatively straight
forward, though would involve a fairly large overhead if the intention
is to detect it fast enough to park hardware etc. (similar to that for
the ring buffer I guess).  I'll look into getting that done for the next
version (maybe driver specific for now).
> * For each axis, what is the maximum and minimum bound and the unit - 
> Probably worthy for the whole ADC infrastructure
Agreed - only laziness has prevented me adding the sysfs stuff to output
that sort of thing.
> * Joystick emulation (calibrated so that when the computer is not 
> moving, all the values are at 0). All the current drivers have it.
Ok, this is a matter of writing an input subsystem element to do this.
It was discussed in the original discussion on lkml and is definitely
on the todo list (I like playing with that sort of thing as well :)
 
> That's it for my wish-list for accelerometers :-)
> 
> 
> Also, a couple of specific comments on the patches:
> * At a quick glance, it seems the VTI SCA3000 driver sends events at 50% 
> and 75% ring full, while the ST LIS3L02DQ driver sends events at 50% and 
> 100%. Why this difference?
I wrote the lis3l02dq driver first, then discovered the VTI only gives hardware
interrupts on those values.  Probably not something that is going to be easy
to standardize in general.  Can easily add more levels if only to ensure a
consistentish set are available.
> * The accelerometer infrastructure has axis offset and axis gain 
> attributes. However, it seems really specific to the ST accelerometer 
> (and still, I doubt it's useful for most users as those values are 
> factory-set to good values).
I'd seriously debate that! For starters that lis3l02dq is reading slightly
over 10g static on my desk.  For the sort of stuff I do with these, the
factory calibration is typically shockingly inaccurate and subject to issues
like temperature of environment etc.
> Shouldn't they be moved to the ST LIS3L02DQ 
> driver instead of being part of the accelerometer infrastructure?
Based on the other accels I've used (quite a few different ones) these
are pretty standard parameters - and I wish they were there on the VTI chip
as it's calibration is far from perfect.  They are to be found in about half
of all the accelerometers I've come across.
> * It would be also very good to provide a small userspace program 
> showing how to read an industrialio device (à la evtest).
One is on it's way (oops, should have cleaned that up before posting these
patches)

At the moment the big missing element of the subsystem is an easy way of
querying what is there. (proc interface similar to that for the input subsystem)
The lack of this makes writing remotely generic tests pretty hideous.  Currently
I have separate ones for each of the drivers which is just plain silly.
I guess for now posting a commented one of those would be a good start and
I'll do so after lunch.

Thanks for taking a look and particularly the accelerometer wish list. I'll see
what I can do!

--
Jonathan Cameron
