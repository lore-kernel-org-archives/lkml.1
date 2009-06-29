Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbZF2OUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbZF2OUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZF2OUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:20:37 -0400
Received: from demumfd001.nsn-inter.net ([217.115.75.233]:11704 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbZF2OUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:20:36 -0400
Subject: Re: RapidIO - general questions
From: Jan Neskudla <jan.neskudla.ext@nsn.com>
To: ext Li Yang <leoli@freescale.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org,
       "IDT - Kim,Chul" <Chul.Kim@idt.com>
In-Reply-To: <1242802800.9160.143.camel@demuxf9c>
References: <1242119872.16400.113.camel@demuxf9c>
	 <2a27d3730905130357re0adf41l19f5603a70dac57b@mail.gmail.com>
	 <1242372791.26759.34.camel@demuxf9c>
	 <2a27d3730905150056m7298b66ckb9db92f9432953d6@mail.gmail.com>
	 <1242802800.9160.143.camel@demuxf9c>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 16:19:53 +0200
Message-Id: <1246285193.10035.245.camel@demux9hc>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-41.el4_7.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi as I already informed you, 
we'd like to contribute to the Linux RapidIO subsystem, with several
features, Here are few general information about the design of
implementation of such features.

naming: 
domain - a several boards connected together via rio, with only one host
host -  a MCU with host bit set, only one per domain
domain master - a host which have also domain_master_bit set ( boot
param), only one in overall system. 

* Domains configuration - traverse the whole rio network by domain
master to find all the hosts, providing a domain IDs to them and finally
programing domain routing tables to the switches. Since we are
cooperating with a IDT as a switch supplier, the IDT will public their
private API for setting such a domain routing tables under GPL. 
- there is an issue how to proceed with a locking of the switches,
during enumeration of domains and later on during enumeration of
endpoint by hosts. All the time, of running system, there  will be two
MCUs trying to configure the same switch in certain situation,
especially during hot-plug of domain. So this is not clear yet.

* Static ID configuration based on port numbers  
  tree sysfs files for providing necessary info : 
      host_id - this is the same like riohdid boot parameter now
      switch_ids - this file is for providing source ids for switches to
be able to report problems via port-write packets 
      endpoint_ids - to provide list of all endpoint in one domain.  
  I read somewhere that passing of structures via sysFS is not
acceptable, but how to pass some more information to the kernel. 
I expect to pass those structures via bin sysFS files, analyze the input
not only cast it, and than use it. Is it this OK ? 

* User triggered enumeration/discovery
This is necessary because of the static IDs. They have to be know before
enumeration can start, and this is most general way of doing this. 
So once the static Ids are provided over sysFS files, then via another
sysFS file a enumeration is triggered. I am talking about enumeration
only because the endpoints that wait for the enumeration are going to
preform discovery as usual, after enumeration. 
This needs some changes. Whole enumeration process have to be put into
the kthread and discovery as well. Then kernel can boots up to user
space and enumeration can be triggered. 
Is there any standard way in the kernel how to postpone and than trigger
a configuration of a bus from the user space ? 

* User space library for configuring switches 
IDT is going to provide user space GPL library that will covers an rio
switch configuration based on rio spec 2.0. 

* Error handling (port-write packets - configuration, handling of them)
This should be as general as possible, and IDT is designing this part.
So a port-write packet (have to be written) driver will receive a
packet, analyze this and perform an action: - two scenarios can happen.
1. The port-write info is part of the rio spec 2.0 and the packet is
processed by kernel directly 
2. The port-write info is vendor specific and it is passed to the user
space, where is processed and proper action is than taken via current
sysFS config files. 

* Hot-plug (hot-insert/hot-remove) of devices
This is case of error handling. 
In case of any error covered by rio spec 2.0 (bad CRC, bad
character, .. ) the ports of the switch that generates this port-write
info are scanned for PORT_OK status or PORT_UNINITIALIZED so we are able
to catch the hot-plug/hot-extract of any device. 
Hotplug should be functional in the time of enumeration, because
enumeration process traverse the system port by port, and if some
endpoint is powered on after enumeration process testes its port but
before the end of the standard enumeration process, this device can be
missed. 

* Aux driver - basic driver, for sending messages over different
mboxes, 
right now we implemented this as a character device. If any one is
interested let me know, I will send this to you. 

On the end we'd like to support already existing scenario of dynamic
assignment of the devID as well as static ID and user space triggered
enumeration. 

The question is if there is a static table of IDs, do we still needs an
discovery process on every endpoint ? Propagating any hot-plug/hot-
extract event to every endpoint to reflect this in local sysfs structure
would be quite hard. 

Any comment to this topics is highly appreciated, as well as forwarding
this to anyone who can be interested. 

                           Jan 


 

On Wed, 2009-05-20 at 09:00 +0200, ext Jan Neskudla wrote:
> n Fri, 2009-05-15 at 15:56 +0800, ext Li Yang wrote:
> > On Fri, May 15, 2009 at 3:33 PM, Jan Neskudla
> <jan.neskudla.ext@nsn.com> wrote:
> > > On Wed, 2009-05-13 at 18:57 +0800, ext Li Yang wrote:
> > >> cc'ed LKML
> > >>
> > >> On Tue, May 12, 2009 at 5:17 PM, Jan Neskudla
> <jan.neskudla.ext@nsn.com> wrote:
> > >> > Hallo
> > >> >
> > >> > we'd likes to use a RapidIO as a general communication bus on
> our new
> > >> > product, and so I have some questions about general design of
> Linux RIO
> > >> > subsystem. I did not find any better mailing list for RapidIO
> > >> > discussion.
> > >> >
> > >> > [1] - we'd like to implement following features
> > >> >    * Hot-plug (hot-insert/hot-remove) of devices
> > >> >    * Error handling (port-write packets - configuration,
> handling of
> > >> > them)
> > >> >    * Static ID configuration based on port numbers
> > >> >    * Aux driver - basic driver, for sending messages over
> different
> > >> > mboxes, handling ranges of doorbells
> > >> >
> > >> >    Is it here anyone who is working on any improvement, or
> anyone who
> > >> > knows the development plans for RapidIO subsystem?
> > >> >
> > >>
> > >> AFAIK, there is no one currently working on these features for
> Linux.
> > >> It will be good if you can add these useful features.
> > > Yes it looks like that, currently we are analyzing current rapidIO
> > > system, and how we can add these features.
> > >
> > >>
> > >> > [2] - I have a following problem with a current implementation
> of
> > >> > loading drivers. The driver probe-function call is based on
> comparison
> > >> > of VendorID (VID) and DeviceID (DID) only. Thus if I have 3
> devices with
> > >> > same DID and VID connected to the same network (bus), the
> driver is
> > >> > loaded 3times, instead only once for the actual device Master
> port.
> > >>
> > >> This should be the correct way as you actually have 3 instances
> of the device.
> > >>
> > >> >
> > >> > Rionet driver solved this by enabling to call initialization
> function
> > >> > just once, and it expect that this is the Master port.
> > >>
> > >> Rionet is kind of special.  It's not working like a simple device
> > >> driver, but more like a customized protocol stack to support
> multiple
> > >> ethernet over rio links.
> > >>
> > >> >
> > >> > Is it this correct behavior  ? It looks to me that RapidIO is
> handled
> > >> > like a local bus (like PCI)
> > >>
> > >> This is correct behavior.  All of them are using Linux
> device/driver
> > >> infrastructure, but rionet is a special device.
> > >
> > > But I do not have a 3 devices on one silicon. I am talking about 3
> > > devices (3 x EP8548 boards + IDT switch) connected over rapidIO
> through
> > > the switch. And in this case I'd like to have only one driver
> siting on
> > > the top of Linux RapidIO subsystem. I don't see the advantage of
> loading
> >
> > You are having one driver, but it probes 3 times for each device
> using
> > the driver.
> >
> > > a driver locally for remote device. Am I missing something  ?
> >
> > If you want to interact with the remote device, you need the driver
> to
> > do the work locally.
> 
> We are going to use a RapidIO as a bigger network of active devices,
> and
> each will have each own driver (sitting on its own), and all the
> settings will be done over maintenance packets.
> 
> May be it will be solved by the fact, that we are going to use a
> staticIDs, so there will be no discovery as it is now. And thus there
> will be only one device visible in the internal structures of the
> subsystem, and thus only one drive will be loaded.
> 
> >
> > >
> > > And one more think, I am getting so much Bus errors OOPSes.
> Whenever
> > > there is a problem with a comunication over Rio I get such a
> kernel OPS.
> > > I had to add some delays into some function to be able to finish
> the
> > > enum+discovery process. Did you have some experience with some
> bigger
> > > rio network running under linux ?
> >
> > It looks like an known issue for switched rio network, but I don't
> > have the correct equipment to reproduce the problem here.  Could you
> > do some basic debugging and share your findings?  Thanks.
> 
> I tried to acquired some info about the problem, I found that the OOPS
> always occur when there is no respond from the device or the respond
> is
> too slow. I always got that error during function call
> rio_get_host_deviceid_lock when it tries to access a remote device or
> switch. This function is the first call of the
> rio_mport_read_config_32
> so is also first try of remote access to any device.
> 
> It is a timing issue, and after placing a printk into the
> rio_get_host_deviceid_lock the OOPSing almost disappeared.
> 
>                                  Jan
> 
> >
> > - Leo
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 

