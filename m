Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYK1XSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYK1XSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYK1XSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:18:24 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:13168 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYK1XSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:18:22 -0500
Date: Fri, 28 Nov 2008 16:18:20 -0700
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the
	device
Message-ID: <20081128231820.GA23578@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net> <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trent Piepho <xyzzy@speakeasy.org>:
> On Wed, 26 Nov 2008, Alex Chiang wrote:
> >
> > Which commit are you talking about?
> >
> > fe99740cac117f208707488c03f3789cf4904957 PCI: construct one
> > fakephp slot per PCI slot
> 
> This one.  It will break any software that used the existing
> interface.
> 
> > Sorry for your frustration. Both patchsets went through
> > multiple revisions, and had plenty of input from the various
> > PCI developers. At the time, no one seemed to think that the
> > proposed changes were unreasonable.
> 
> I wonder how many users of fakephp saw them?  I can't monitor
> every patch to linux kernel.  I checked the lkml archive and
> didn't see any discussion of the change to the fakephp
> interface.  There was stuff about the other patches, but
> nothing about that.

Until now, I hadn't realized that there were "real" users of
fakephp. My assumption was that anyone using it was a developer.

I see now that my assumption was wrong.

> Is there a reason you had to change it?  It breaks an existing
> interface.  It's clearly more inefficient and complicated to
> find a slot using it.  The exiting PCI device name, like
> "0000:01:00.0", has been used in the sysfs interface and with
> tools like lspci since forever.  

As Willy pointed out, we had to change fakephp to move to one
'slot' per device to normalize the other hotplug drivers. The
overall goal was to reduce the complexity of the individual
hotplug drivers and move more functionality into the hotplug
core. This change in fakephp was a side-effect.

> Why should /sys/bus/pci/slots use different names from
> /sys/bus/pci/devices for the same device?

Because they are fundamentally different concepts. Entries in
/sys/bus/pci/slots/ _should_ correspond to physical PCI slots.

> > That is bizarre. You are saying that you're getting slot
> > entries without address files?
> >
> > Can you send the output of 'ls /sys/bus/pci/slots' and also:
> >
> > $ for i in /sys/bus/pci/slots ; do ls $i ; done
> >
> > What kernel are you on?
> 
> It's a 2.6.23 kernel, but I've back-ported the PCI code from
> 2.6.26 since there were a number of important powerpc
> improvements that I needed.  I assure you there is no 'address'
> attribute in the directories in bus/pci/slots.

It sounds like you didn't backport enough stuff then.

> > There is no way for fakephp to hot-add devices. The only use case
> > is to hot-remove devices.
> 
> Sure it's possible to hot-add devices.  Look at the patch to fakephp just
> previous to your first patch:

Oh, ok. The reason I didn't realize this is because the fakeN
entry goes away after you echo a 0 into its power file. Since I'm
not a heavy fakephp user, I never realized that it was possible
to get it to rescan the bus.

> > Once fakephp is loaded, the fake* entry created in sysfs will not
> > change.
> >
> > Maybe you're talking about something else. Some more context for
> > what you're trying to do, please?
> 
> / # lspci
> 00:00.0 PCI bridge: Freescale Semiconductor Inc MPC8572 PowerQUICC III PCIe Host Controller (rev 11)
> 01:00.0 Signal processing controller: Freescale Semiconductor Inc Aurora Nexus Trace Interface
> / # echo 0 > /sys/bus/pci/slots/`lspci -Dm -d 1957:fc00|cut -d\  -f1`/power
> / # lspci
> 00:00.0 PCI bridge: Freescale Semiconductor Inc MPC8572 PowerQUICC III PCIe Host Controller (rev 11)
> / # [reload the image on the FPGA, which implements the PCI-E interface]
> / # echo 1 > /sys/bus/pci/slots/0000:00:00.0/power
> / # lspci
> 00:00.0 PCI bridge: Freescale Semiconductor Inc MPC8572 PowerQUICC III PCIe Host Controller (rev 11)
> 01:00.0 Signal processing controller: Freescale Semiconductor Inc Aurora Nexus Trace Interface
> 
> Note that the device doesn't exist after boot, as the image on the FPGA
> which implements the PCI-E interface must be loaded from Linux first.  When
> the image is reloaded in the middle step, it could change the device into a
> completely different one.  Different PCI id, different BARs, PCI-E link
> width changing from 4x to 8x, and so on.  I just don't have any visibly
> different images handy that run on the hardware I have online at the
> moment.
> 
> Having a PCI/PCI-E interface that exists in an FPGA isn't uncommon for
> custom hardware.  An IP block for a PCI/whatever interface is a standard
> feature for any FPGA powerful enough for that sort of thing.  I know there
> are others who use fakephp for this same thing with there FPGA based
> hardware.
 
I have to be honest, my first reaction to reading your
attack-filled mails was to shrug and think, "I don't know who
this jerk is, but I sure don't feel like helping him."

Whatever, I'm over it.

Let's try and find a solution that will work for everyone. I
don't think that going back to one entry in /sys/bus/pci/slots
per function is a solution.

Last time, Willy proposed a few ideas in this thread:

	http://lkml.org/lkml/2008/9/9/28

I like this idea:

	Maybe we want a /sys/bus/pci/scan or
	/sys/bus/pci/devices/scan file that we can echo
	"0000:01:02.3" to scan just that function, or
	"0000:01:02" to scan the device.

Will that work for you, Trent?

/ac

