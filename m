Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZETHAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZETHAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZETHA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:00:27 -0400
Received: from demumfd002.nsn-inter.net ([217.115.75.234]:12613 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZETHA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:00:26 -0400
Subject: Re: RapidIO - general questions
From: Jan Neskudla <jan.neskudla.ext@nsn.com>
To: ext Li Yang <leoli@freescale.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org
In-Reply-To: <2a27d3730905150056m7298b66ckb9db92f9432953d6@mail.gmail.com>
References: <1242119872.16400.113.camel@demuxf9c>
	 <2a27d3730905130357re0adf41l19f5603a70dac57b@mail.gmail.com>
	 <1242372791.26759.34.camel@demuxf9c>
	 <2a27d3730905150056m7298b66ckb9db92f9432953d6@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 09:00:00 +0200
Message-Id: <1242802800.9160.143.camel@demuxf9c>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-41.el4_7.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n Fri, 2009-05-15 at 15:56 +0800, ext Li Yang wrote:
> On Fri, May 15, 2009 at 3:33 PM, Jan Neskudla <jan.neskudla.ext@nsn.com> wrote:
> > On Wed, 2009-05-13 at 18:57 +0800, ext Li Yang wrote:
> >> cc'ed LKML
> >>
> >> On Tue, May 12, 2009 at 5:17 PM, Jan Neskudla <jan.neskudla.ext@nsn.com> wrote:
> >> > Hallo
> >> >
> >> > we'd likes to use a RapidIO as a general communication bus on our new
> >> > product, and so I have some questions about general design of Linux RIO
> >> > subsystem. I did not find any better mailing list for RapidIO
> >> > discussion.
> >> >
> >> > [1] - we'd like to implement following features
> >> >    * Hot-plug (hot-insert/hot-remove) of devices
> >> >    * Error handling (port-write packets - configuration, handling of
> >> > them)
> >> >    * Static ID configuration based on port numbers
> >> >    * Aux driver - basic driver, for sending messages over different
> >> > mboxes, handling ranges of doorbells
> >> >
> >> >    Is it here anyone who is working on any improvement, or anyone who
> >> > knows the development plans for RapidIO subsystem?
> >> >
> >>
> >> AFAIK, there is no one currently working on these features for Linux.
> >> It will be good if you can add these useful features.
> > Yes it looks like that, currently we are analyzing current rapidIO
> > system, and how we can add these features.
> >
> >>
> >> > [2] - I have a following problem with a current implementation of
> >> > loading drivers. The driver probe-function call is based on comparison
> >> > of VendorID (VID) and DeviceID (DID) only. Thus if I have 3 devices with
> >> > same DID and VID connected to the same network (bus), the driver is
> >> > loaded 3times, instead only once for the actual device Master port.
> >>
> >> This should be the correct way as you actually have 3 instances of the device.
> >>
> >> >
> >> > Rionet driver solved this by enabling to call initialization function
> >> > just once, and it expect that this is the Master port.
> >>
> >> Rionet is kind of special.  It's not working like a simple device
> >> driver, but more like a customized protocol stack to support multiple
> >> ethernet over rio links.
> >>
> >> >
> >> > Is it this correct behavior  ? It looks to me that RapidIO is handled
> >> > like a local bus (like PCI)
> >>
> >> This is correct behavior.  All of them are using Linux device/driver
> >> infrastructure, but rionet is a special device.
> >
> > But I do not have a 3 devices on one silicon. I am talking about 3
> > devices (3 x EP8548 boards + IDT switch) connected over rapidIO through
> > the switch. And in this case I'd like to have only one driver siting on
> > the top of Linux RapidIO subsystem. I don't see the advantage of loading
> 
> You are having one driver, but it probes 3 times for each device using
> the driver.
> 
> > a driver locally for remote device. Am I missing something  ?
> 
> If you want to interact with the remote device, you need the driver to
> do the work locally.

We are going to use a RapidIO as a bigger network of active devices, and
each will have each own driver (sitting on its own), and all the
settings will be done over maintenance packets. 

May be it will be solved by the fact, that we are going to use a
staticIDs, so there will be no discovery as it is now. And thus there
will be only one device visible in the internal structures of the
subsystem, and thus only one drive will be loaded. 

> 
> >
> > And one more think, I am getting so much Bus errors OOPSes. Whenever
> > there is a problem with a comunication over Rio I get such a kernel OPS.
> > I had to add some delays into some function to be able to finish the
> > enum+discovery process. Did you have some experience with some bigger
> > rio network running under linux ?
> 
> It looks like an known issue for switched rio network, but I don't
> have the correct equipment to reproduce the problem here.  Could you
> do some basic debugging and share your findings?  Thanks.

I tried to acquired some info about the problem, I found that the OOPS
always occur when there is no respond from the device or the respond is
too slow. I always got that error during function call
rio_get_host_deviceid_lock when it tries to access a remote device or
switch. This function is the first call of the rio_mport_read_config_32
so is also first try of remote access to any device. 

It is a timing issue, and after placing a printk into the
rio_get_host_deviceid_lock the OOPSing almost disappeared. 

                                 Jan 

> 
> - Leo

