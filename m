Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYK0Bor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYK0Bor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYK0Boi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:44:38 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:46871 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYK0Boh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:44:37 -0500
Date: Wed, 26 Nov 2008 17:44:35 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Alex Chiang <achiang@hp.com>
cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
In-Reply-To: <20081126225535.GA27936@ldl.fc.hp.com>
Message-ID: <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
 <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum>
 <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Alex Chiang wrote:
> * Trent Piepho <xyzzy@speakeasy.org>:
> > > I doubt that, sysfs interfaces change all the time.  I think only the
> > > syscall interface has any sort of stability guarantee.
> >
> > The ones meant to be used from userspace usually don't.  At least that
> > doesn't seem to be what Linus is saying here http://lwn.net/Articles/172986/
> >
> > I've written software that uses an established interface, which has been
> > the same for years, and I see someone went and broke it, no warning.  That
> > hardly seems reasonable.
>
> Which commit are you talking about?
>
> fe99740cac117f208707488c03f3789cf4904957
> PCI: construct one fakephp slot per PCI slot

This one.  It will break any software that used the existing interface.

> Sorry for your frustration. Both patchsets went through multiple
> revisions, and had plenty of input from the various PCI
> developers. At the time, no one seemed to think that the proposed
> changes were unreasonable.

I wonder how many users of fakephp saw them?  I can't monitor every patch
to linux kernel.  I checked the lkml archive and didn't see any discussion
of the change to the fakephp interface.  There was stuff about the other
patches, but nothing about that.

Is there a reason you had to change it?  It breaks an existing interface.
It's clearly more inefficient and complicated to find a slot using it.  The
exiting PCI device name, like "0000:01:00.0", has been used in the sysfs
interface and with tools like lspci since forever.  Why should
/sys/bus/pci/slots use different names from /sys/bus/pci/devices for the
same device?

> > > > useless.  How are you supposed to figure out which "fake-n" directory is
> > > > the right one to disable the device you want?
> > >
> > > cat /sys/bus/pci/slots/fake*/address
> >
> > Ahh, my kernel doesn't have an address attribute in the slot directories.
>
> That is bizarre. You are saying that you're getting slot entries
> without address files?
>
> Can you send the output of 'ls /sys/bus/pci/slots' and also:
>
> $ for i in /sys/bus/pci/slots ; do ls $i ; done
>
> What kernel are you on?

It's a 2.6.23 kernel, but I've back-ported the PCI code from 2.6.26 since
there were a number of important powerpc improvements that I needed.  I
assure you there is no 'address' attribute in the directories in
bus/pci/slots.  /sys/bus/pci/slots/* == /sys/bus/pci/devices/*, which is
quite nice.

> > Still, this is much more inefficient than the previous way.  It also has a
> > race condition.  After scanning each fake* device to find the one with the
> > correct address there is a window before the power attribute is written.
> > The fake* device might change in that time and one could write to the wrong
> > power attribute.
>
> There is no way for fakephp to hot-add devices. The only use case
> is to hot-remove devices.

Sure it's possible to hot-add devices.  Look at the patch to fakephp just
previous to your first patch:

commit ca99eb8c2d56bdfff0161388b81e641f4e039b3f
Author: Trent Piepho <tpiepho@freescale.com>
Date:   Mon Apr 7 16:04:16 2008 -0700

    PCI: Hotplug: fakephp: Return success, not ENODEV, when bus rescan is triggered

What is the purpose of a bus rescan, if not to hot-add devices?

> Once fakephp is loaded, the fake* entry created in sysfs will not
> change.
>
> Maybe you're talking about something else. Some more context for
> what you're trying to do, please?

/ # lspci
00:00.0 PCI bridge: Freescale Semiconductor Inc MPC8572 PowerQUICC III PCIe Host Controller (rev 11)
01:00.0 Signal processing controller: Freescale Semiconductor Inc Aurora Nexus Trace Interface
/ # echo 0 > /sys/bus/pci/slots/`lspci -Dm -d 1957:fc00|cut -d\  -f1`/power
/ # lspci
00:00.0 PCI bridge: Freescale Semiconductor Inc MPC8572 PowerQUICC III PCIe Host Controller (rev 11)
/ # [reload the image on the FPGA, which implements the PCI-E interface]
/ # echo 1 > /sys/bus/pci/slots/0000:00:00.0/power
/ # lspci
00:00.0 PCI bridge: Freescale Semiconductor Inc MPC8572 PowerQUICC III PCIe Host Controller (rev 11)
01:00.0 Signal processing controller: Freescale Semiconductor Inc Aurora Nexus Trace Interface

Note that the device doesn't exist after boot, as the image on the FPGA
which implements the PCI-E interface must be loaded from Linux first.  When
the image is reloaded in the middle step, it could change the device into a
completely different one.  Different PCI id, different BARs, PCI-E link
width changing from 4x to 8x, and so on.  I just don't have any visibly
different images handy that run on the hardware I have online at the
moment.

Having a PCI/PCI-E interface that exists in an FPGA isn't uncommon for
custom hardware.  An IP block for a PCI/whatever interface is a standard
feature for any FPGA powerful enough for that sort of thing.  I know there
are others who use fakephp for this same thing with there FPGA based
hardware.
