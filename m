Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYKZWzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYKZWzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYKZWzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:55:38 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:28570 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbYKZWzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:55:36 -0500
Date: Wed, 26 Nov 2008 15:55:35 -0700
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the
	device
Message-ID: <20081126225535.GA27936@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trent Piepho <xyzzy@speakeasy.org>:
> On Wed, 26 Nov 2008, Darrick J. Wong wrote:
> > On Wed, Nov 26, 2008 at 01:56:45AM -0800, Trent Piepho wrote:
> > > Ok, that makes sense.  The device I'm using fakephp for doesn't have a
> > > kernel driver so I wouldn't have noticed that.
> > >
> > > Have you tested this with a device that isn't present at boot?  I found
> > > that I needed to a call to pci_enable_device() after assigning resources,
> > > otherwise the BARs wouldn't be enabled.  This only happened if the device
> > > wasn't present at boot time.
> >
> > Yes, I was actually using this driver to <cough> turn the ioatdma
> > controller on after turning it off in the BIOS.
> 
> Maybe it's different on powerpc then?  My pseudo-hotplugable device is also
> the only thing connected to the PCI-E host bus controller.  At boot the
> controller is empty and so I think some code to enable its BARs gets
> skipped.  But without the pci_enable_device(), I get this:
> 
> 01:00.0 Signal processing controller: Freescale Semiconductor Inc Aurora Nexus Trace Interface
>         Flags: fast devsel, IRQ 255
>         Memory at 40000000 (64-bit, prefetchable) [disabled] [size=4K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
>         Capabilities: [60] Express Endpoint IRQ 0
>         Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00
> 
> > > might not be feasible.  It also looks a previous patch by Alex Chiang
> > > completely changed the sysfs interface for fakephp.  I thought sysfs
> > > interfaces were supposed to be stable?!  Also looks like it made fakephp
> >
> > I doubt that, sysfs interfaces change all the time.  I think only the
> > syscall interface has any sort of stability guarantee.
> 
> The ones meant to be used from userspace usually don't.  At least that
> doesn't seem to be what Linus is saying here http://lwn.net/Articles/172986/
> 
> I've written software that uses an established interface, which has been
> the same for years, and I see someone went and broke it, no warning.  That
> hardly seems reasonable.

Which commit are you talking about?

5fe6cc60680d29740b85278e17a002fa27b7e642
PCI: prevent duplicate slot names

fe99740cac117f208707488c03f3789cf4904957
PCI: construct one fakephp slot per PCI slot

Sorry for your frustration. Both patchsets went through multiple
revisions, and had plenty of input from the various PCI
developers. At the time, no one seemed to think that the proposed
changes were unreasonable.

> > > useless.  How are you supposed to figure out which "fake-n" directory is
> > > the right one to disable the device you want?
> >
> > cat /sys/bus/pci/slots/fake*/address
> 
> Ahh, my kernel doesn't have an address attribute in the slot directories.

That is bizarre. You are saying that you're getting slot entries
without address files?

Can you send the output of 'ls /sys/bus/pci/slots' and also:

$ for i in /sys/bus/pci/slots ; do ls $i ; done

What kernel are you on?

> Still, this is much more inefficient than the previous way.  It also has a
> race condition.  After scanning each fake* device to find the one with the
> correct address there is a window before the power attribute is written.
> The fake* device might change in that time and one could write to the wrong
> power attribute.

There is no way for fakephp to hot-add devices. The only use case
is to hot-remove devices.

Once fakephp is loaded, the fake* entry created in sysfs will not
change.

Maybe you're talking about something else. Some more context for
what you're trying to do, please?

/ac

