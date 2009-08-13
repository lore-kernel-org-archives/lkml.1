Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZHMLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZHMLpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbZHMLpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:45:30 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:43899 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZHMLp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:45:28 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A83A896.8080305@cam.ac.uk>
Date: Thu, 13 Aug 2009 05:45:58 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: RFC: Merge strategy for Industrial I/O (staging?)
References: <4A828AE9.9090807@cam.ac.uk> <20090812211033.GX13320@pengutronix.de>
In-Reply-To: <20090812211033.GX13320@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> Hi Jonathan,
> 
> On Wed, Aug 12, 2009 at 09:27:05AM +0000, Jonathan Cameron wrote:
>> The last couple of versions of IIO have recieved some useful feedback
>> from a number of people, and feedback from various users has led to a
>> number of recent bug fixes. Unfortunately, full reviews of any given
>> element have not be forthcoming. Several people who have in principle
>> offered to help haven't had the time as yet.
> 
> Uuuh, sorry, same here. Wanted to check your code and docs for quite
> some time now. 
Not to worry, there are always far too many things to do in the day!
> So I'll try to at least give you a brain dump on that
> topic here.
> 
> A driver framework for industrial I/O would be quite welcome; we
> constantly see a need for something like that in our automation &
> control projects. However, I see some requirements which are currently
> not fully addressed by your code.
> 
> I'll try to outline the requirements (as I see them) below:
> 
> - "process variables" contain the actual data (voltage, temperature etc)
>   from the in/outputs. However, process variables need some additional
>   meta data to be attached to them, like min/max, unit, scale etc. This
>   could be done in userspace, but some cards can provide that
>   information directly from the hardware.
I definitely agree this sort of info is useful.  Even in cases where the chip
doesn't directly provide it, a given driver often covers multiple chips
with say different accelerations ranges. It is useful to have everything needed
to use the data exported to userspace.  In the case of ring buffers, the data
may even be unprocessed and not aligned in a simple fashion. Similar variables
could be used to tell userspace that the data coming out is 10 bits shifted 2
within a 16 bit field. Personally I favor exporting this sort of thing under
standard names in sysfs rather than the alternative of creating any sort
of HAL type record.  Makes it easy to retrofit these only where needed.  If there
is no shift or a parameter we don't have info on, then there is nothing under
the relevant name in sysfs.  A suitable userspace library then does any mangling
transparently.

> 
> - The memory layout of process data is dictated by the transportation
>   model. Most modern industrial I/O systems are not based on single-
>   channel local I/Os, but on fieldbus I/Os. 
> So for example, if we
>   get an EtherCAT frame, we want to push the whole frame into memory
>   by DMA, without copying the actual data any more. Let's say that
>   several process variables in a block of memory are a "transportation
>   unit".
I feel we need to be a little careful with not over extending the scope of
a given subsystem.  I'm not familiar with fieldbus (being mostly interested
in embedded sensors directly connected to a linux running device)
so my understanding bares a startling resemblance to the wikipedia page.

Given the example above, you probably want a zero copy solution (which IIO
gets no where near at the momentm vu) I'd imagine best bet is to shift the frame
directly into userspace and do all your processing here. (however this is
well out of my experience, so I could be completely wrong!)
> 
>   All these "simple" I/O sources like I2C or SPI based ADCs,
>   acceleration devices etc. are just a simplified case of the above.
>   For example, acceleration devices often have a three-register process
>   data block which contains the three accel values, and the
>   transportation unit could be the SPI transfer.
That seems reasonable though we are talking whole different levels of
complexity.
> 
>   Events may happen when transportation units arrive; either because
>   the hardware does it automatically (i.e. Hilscher CIF(x) cards can
>   trigger an interrupt if they have done their bus cycles), or by
>   an artificial software event (i.e. in Modbus/TCP you have to decide
>   about the "cycle" in software, simply because there is no cycle).

> - Applications need to access the process data asynchronously. As
>   process data will come from several sources, it can not be expected
>   that there is any synchronisation mechanism. So how to synchronize
>   the data? I assume some kind of RCU mechanism would be great. For
>   each Transportation Unit, there is one producer (the driver) and
>   many consumers (the applications). New data which comes in from
>   the data source will superseed old data, but for applications
>   which didn't finish their cycle yet, the old data needs to stay
>   consistent (with all meta data, min/max etc).
Makes sense.  Though I'd imagine there are also cases where you don't want
to always replace data, so things might need to be more complex.
> 
>   However, I'm not sure if the RCU based process image handling
>   should be done in kernel or user space. From the code management view,
>   it would be great to have an infrastructure in the kernel.
>   Technically, I'm not sure.
> 
>   Is something like RCU protected objects in a shared memory space
>   possible between kernel and userspace?
> 
> - Synchronisation on the application level is coupled to the I/O layer.
>   For example, in CANopen networks you have a "sync" message. In Sercos
>   III you have the network cycle (MTs/ATs). These may want to trigger an
>   application cycle (i.e. PLC cycle) which needs access to the data. So
>   what we need is a possibility to let userspace apps sleep until the
>   process data layer triggers an event (netlink?).
Netlink would work, or a simple chardev (like input or indeed IIO use)
> 
> - We need persistence in the framework. PLCs have the requirement to be
>   power-fail safe. Let's assume you have a transportation belt and get
>   information about the position of a "thing" on the belt, then the
>   power fails and comes back (box boots), you want to continue with the
>   old position of the "thing". So the process data backing store
>   must be able to live for example on a battery backed SRAM, and all
>   transactions need to be atomic.
This sort of requirement does suggest to me that you want to do as much
as possible in userspace where things like backing stores would be much
easier to implement in a hardware agnostic way.

> 
> - Process data access has realtime requirements, but only during an
>   "operational" state of an application data block. A usual pattern is
>   that, while being in non-operational mode, an application does some
>   preparation work, like mapping it's process data, initializing
>   things etc. Then it enters operational-mode. During that phase,
>   hard realtime conditions may have to be fulfilled. So no memory
>   allocation is allowed, mlockall(), priorities must be taken care of
>   etc.
That shouldn't be too much of a problem as you can always preallcoate
a large memory pool to cover any eventualities as I'd imagine you can
work out the worst cases in advance.
 
> - The application "blocks" probably want to live in userspace, but the
>   layer that provides the process data should be the kernel.
> 
> So in conclusion, I think that before discussing the I/O layer we need
> to address the process data handling first. If we start with the
> drivers, it won't be possible to add features like persistence any more.
You have an interesting situation, but I'm not sure it corresponds terribly
closely to what IIO is currently aimed at.  The complexity that you describe
would be a complete nightmare on a relatively light weight device if you don't 
actually need it. Ironically the name would be much more suitable for your
application requirements that mine!

To get more feedback I'd suggest reposting your requirements to LKML in a
separate thread with a specific title.  I suspect not many relevant
people will come across them in this one! (please cc me.)
Even if optimum approaches are different, as you've identified there are
elements that overlap between the usecases.

Thanks,

Jonathan



