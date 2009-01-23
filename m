Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbZAWGOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbZAWGOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZAWGO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:14:26 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32305 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760717AbZAWGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:14:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LJhVXdqnEMDv1KSN29rB3mMxdEIexYfH1oATvzNrnNQVU4ZEGGGxTb5TxwFEK1ZdHu9IpY6WFrXT1tczfMlrA3SJo40XyJ3QJOGLXubGHhpvhd1/CaOwAzR7hEgruqQlSQrYZCnRnlcF4fOjTN06B3lSVkniKdys7mXJFKRaz84=  ;
X-YMail-OSG: vaxoV_IVM1myunO1NofL0zWfeWjdq67g8kVBw.Lqh5kwyZz0UJhyLDOTAdxpMAX9HB3i2jz.kbhZMy6kEaZM26xIK1Hae.IG3fbz_FMY4qqLNJBuewc4qhI7Z3nHZTp_805VPmvVFIcVf1CW0LInbq9uIFXJ_f2tSCRay8wJ0BhbM8dC0GVVO1EivpRM
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: RFC: Working around dynamic device allocation in i2c.  Interaction with other subystems.
Date: Thu, 22 Jan 2009 22:14:22 -0800
User-Agent: KMail/1.9.10
Cc: linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       Ben Dooks <ben-linux@fluff.org>,
       spi-devel-general@lists.sourceforge.net
References: <4974D20F.20209@cam.ac.uk> <49786CA6.8010303@cam.ac.uk>
In-Reply-To: <49786CA6.8010303@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200901222214.22806.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, Jonathan Cameron wrote:
> > Within board configuration files, i2c devices are currently allocated
> > using i2c_board_info structures.  The only element of these that retains
> > it's memory address once the struct device elements are allocated (upon
> > adapter initialization) is the platform data pointer.
> >
> > Several subsystems (regulator and clock for example) use an association
> > method based upon a device specific string associated with a pointer to
> > a device structure.  Unfortunately as things currently stand there is no
> > means of obtaining a suitable device for i2c devices at the point when
> > it is required (in the board config).

Yeah, kind of awkward.  Multi-Function Device (MFD) drivers have
this kind of problem a lot.  A given I2C device might have a few
dozen child devices -- including regulators and clock generators,
RTCs, GPIOs, input devices, etc -- that can't be set up until the
parent I2C device is probed.

It's solved easily enough by making sure the associations and their
devices get set up after the core of the MFD comes up ... in the
probe() routine.  And by making sure the MFD and its subsystem
initializes early enough that those other devices don't fail too
many hidden assumptions.


> > What do people think? In particular can anyone come up with any other /
> > better way round this issue. (or am I missing something?)
> > In particular, are there any similar cases already in kernel that would
> > suggest a particular approach to solving this issue?

This is a special case of a general problem:  init sequencing.
The initcall levels don't provide sufficient control, so you
need to work around them.

Static device allocation is a bit problematic, and some folk
really dislike it ... I'm not that averse to it, but since
the cost of a device keeps growing I'd rather avoid that in
most cases.  A couple dozen bytes of board_info, especially
if it's __initdata, versus several hundred bytes of "struct
foo_device", multiplied by even just a dozen devices that
won't always be present, adds up.

That leaves a dynamic solution for setting up linkage between
various devices.  In the past I've done that using callbacks
to board-specific code that knows what linkages to establish.

You can see that with the GPIO controllers that use I2C or SPI
communications:  they have setup callbacks that receive the
device and GPIO information, which can continue to set the
stage for the main event ... and teardown callbacks to break
it all down after the show is done.

So for example those callbacks can be used to configure and
then register the devices which rely on those GPIOs ... like
LED banks, MMC/SD card sense switches, voltage regulator
enables, and so on.

- Dave

