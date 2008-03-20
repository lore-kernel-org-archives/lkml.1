Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYCTF0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYCTF0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 01:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYCTFZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 01:25:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:40704 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYCTFZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 01:25:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,529,1199692800"; 
   d="scan'208";a="536818720"
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
From: Zhao Yakui <yakui.zhao@intel.com>
To: David Brownell <david-b@pacbell.net>
Cc: trenn@suse.de, yi.y.yang@intel.com, Zhang Rui <rui.zhang@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net, Holger Macht <hmacht@suse.de>
In-Reply-To: <200803191152.09482.david-b@pacbell.net>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1200009342.5389.12.camel@yangyi-dev.bj.intel.com>
	 <1205931982.21619.301.camel@queen.suse.de>
	 <200803191152.09482.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 13:12:47 +0800
Message-Id: <1205989967.4061.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-19 at 11:52 -0700, David Brownell wrote:
> On Wednesday 19 March 2008, Thomas Renninger wrote:
> > On Fri, 2008-01-11 at 07:55 +0800, Yi Yang wrote:
> > > > > I think that it would be much much better to place wake-up attributes under
> > > > > corresponding PCI and PNP devices.
> > > > > Probably it is even better to link this code to PCI code, so PCI
> > > > > drivers will be aware of ACPI. 
> > > >
> > > > I like this idea, maxim. :)
> > > > And that's what we actually did about half a year ago.
> > > > 
> > > > Yi,
> > > > Please refer to http://bugzilla.kernel.org/show_bug.cgi?id=6892
> > > > and David's patch set here:
> > > > http://marc.info/?l=linux-mm-commits&m=117701595209299&w=2
> > > > http://marc.info/?l=linux-mm-commits&m=117701866524935&w=2
> > > > You can have a look at this thread as well:
> > > > http://marc.info/?l=linux-acpi&m=119982937409968&w=2
> 
> And I have some more split-out versions of those patches
> now, too.  Cleanups and simplifications should be more
> directly mergeable, and the tricky bits affecting GPE use
> can be addressed by folk who are actively involved in the
> nitty-gritty of making the power management parts of ACPI
> work right for Linux.
> 
> I think I'll repost them soonish, to linux-pm and, as relevant,
> to linux-acpi.  LKML for stuff that's IMO mergeable as-is.
> 
>  
> > > I checked those patches you mentioned, they did bind two wakeup flag to
> > > some extent, but they can't be exchanged to use and they are just partly
> > > in current linus tree, two flags bind isn't in linus tree.
> 
> Right.
> 
> 
> > > According to my test on the latest linus tree, wakeup flag of
> > > acpi_device hasn't any association with device's, i don't know if they
> > > are the same thing. if we enbale or disable it manually, what will
> > > happen? From source code, it is just a flag, it doesn't trigger any
> > > event or hardware operation.
> 
> Currently ACPI wakeup mechanisms are not at all integrated with
> driver model mechanisms, or with non-ACPI bits of the system.
> 
> The "why" of that is that those patches still haven't been merged;
> and the "why" of *that* is, AFAICT, that ACPI sleep/wake/resume
> support is still in serious flux.
> 
> The current model is, yes, those are just flags ... and they only
> kick in during driver state transitions.  Someday we can hope
> they will support runtime power management (e.g. putting PCI
> devices in PCI_D3hot to save power, then letting them trigger
> runtime wake events when external hardware asks for that) ...
> but for now, those transitions only kick in when the system as
> a whole enters a sleep state, via /sys/power/state writes.
> 
Right. Now the system only supports that the device wakes the whole
sleeping system. Maybe it is necessary to add the runtime wakeup
support.(For example: the PCI device that supports PME)
> 
> > > > thanks,
> > > > Rui
> > > > > For example it will fix the 'EHCI instantly wakes up the system
> > > > > from S4' on my system, since here USB doesn't wake 
> > > > > up anything from S4, and ACPI tables correctly show that.
> > > > > 
> > > > > If ehci driver was aware of that it could disable #PME on entrance to S4.
> > > > > And we even can reuse its 'wakeup' attribute, thus enabling wakeup
> > > > > automatically. 
> > > > > 
> > > > > Going ever further, I think that it will be great to get rid of ACPI
> > > > > device tree, since 
> > > > > most acpi devices are ether PCI of PNP ones.
> > > > > 
> > > > > Or, even better have a small ACPI tree, that will contain 'true'
> > > > > ACPI devices, like cpus thermal sensors, buttons, etc. 
> 
> There's a bit of state in the ACPI device nodes that's not
> currently visible through PCI or PNP.  The patch I posted
> a while back to cross-link ACPI nodes to the "real" nodes
> should help sort out some of that.  (Basically, it's just
> an updated version of a patch from Zhang Rui.)
> 
> 
> > Any news on this?
> 
> Not from me, but that sounds like a useful direction.  In
> the same vein, it'd make sense to properly root PCI from the
> PNP record for the PCI root.
> 
> 
> > I ran into a problem with the current implementation:
> > 
> > If one GPE is tight to several devices you get a message:
> > echo XYZ >/tmp/acpi/wakeup
> > ACPI: 'XXX' and 'XYZ' have the same GPE, can't disable/enable one
> > seperately
> > ACPI: 'YYY' and 'XYZ' have the same GPE, can't disable/enable one
> > seperately
> > and none of the devices are activated to be able to wake the machine up.
> 
> I've not happened across that myself.
> 
> 
> > Which I expect is wrong, all should be enabled/disabled then IMO, but
> > it's probably not worth much fixing in /proc/acpi/...
> 
> Agreed.
> 
>  
> > The correct interface to use seem to be:
> > drivers/base/power/sysfs.c
> > But this is rather broken?
> > Here an output of /proc/acpi/wakeup and /sys/...:
> > for x in `find /sys/ |grep wakeup`;do if [ $(cat $x) ];then echo $x; cat $x;fi;done
> > /sys/devices/pnp0/00:04/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/4-5/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/4-1/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.7/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.1/usb2/power/wakeup
> > enabled
> > /sys/devices/pci0000:00/0000:00:1d.0/usb1/power/wakeup
> > enabled
> 
> In short:  only USB portions of the tree have those flags set,
> since USB (a) has some workarounds for the lack of ACPI support
> on OHCI and EHCI controllers, like 00:1d.7, and (b) supports
> those flags for devices that ACPI doesn't know about, such as
> most USB keyboards, hubs, mice, and so forth.  Plus, (c) you
> aren't using the rtc-cmos driver, which works better with the
> rest of Linux than the legacy drivers/char/rtc driver.
It seems that the following only means that the PME is supported by the
USB PCI device. 
 > /sys/devices/pci0000:00/0000:00:1d.7/power/wakeup 
When the system enters the sleeping state, whether the 1d.7 PCI device
can wake the system is related to the following two factors:
    a. /proc/acpi/wakeup flag for 1d.7 PCI device is enabled.
    b. the Power/wakeup flag in Sys I/F is enabled. ( It means that PME
is supported and configured)
  
> > enabled
> 
> If you had applied patches like my "teach ACPI how to use the
> wakeup flags", you should see more devices with such flags.
> 
> 
> > trenn@stravinsky:/extern/trenn/packages/home:trenn> cat /proc/acpi/wakeup 
> > Device  S-state   Status   Sysfs node
> > PCI0      S5     disabled  no-bus:pci0000:00
> 
> Hmm, and (d) you've got a system that doesn't do much in terms
> of ACPI wakeup:  a PCI root bridge, and maybe some buttons.  Why
> that root bridge shows up as a "no-bus" node I don't know... 
> there's usually a PNP node for it, and otherwise it'd seem like
> it should be a PCI device.  (The buttons seem to never show up.)
> 
> It's not uncommon for the ACPI device tables to list devices
> that don't actually exist in /proc/acpi/wakeup.  Many of the
> devices with no sysfs node seem to be of that type.  To me,
> this just highlights the current weak handling of wakeups in
> the ACPI stack.
> 
> 
> > I still think (from comments in drivers/base/power/sysfs.c, not sure
> > whether it really is that appropriate) it is wakeup sysfs file that
> > should be used for this.
> 
> Yes.
> 
> 
> > I wonder why each device has a wakeup file, it should be enough to
> > create them dynamically if wakeup enable/disable is supported for a
> > specific device?
> 
> Because that can change dynamically.  Classic example:  a USB
> device with two active configurations, plus "configuration zero".
> Whether it's wakeup-capable depends on a bit in the descriptor
> for the active configuration ... so config zero may never waake
> the system, while either (or both!) of the active configs might.
> 
> 
> > Also a second file is missing from which state (S3,S4,S5) the device can
> > wake the machine up.
> 
> Those labels are ACPI-specific, and anything at the core of
> Linux (like the driver model and its wakeup flags) should
> never be ACPI-specific!
> 
Yes. the second file is ACPI-specific. We should add this file. And the
info should be obtained by the associated ACPI device. Maybe it is
better that it is create in the subdirectory of ACPI device and the link
is created.
> Plus, it's not clear how much that matters.  It's not as if
> drivers should prevent entering sleep states if they can't
> act as wake event sources in that level (e.g. S3 == "mem").
> That information can stay in /proc/acpi/wakeup until that's
> finally removed; if no userspace tools need that info, I see
> no good reason for exporting it.
> 
> 
> > If there can be multiple devices for one GPE, this information (the
> > power directory of multiple devices) could be linked together in sysfs?
> > E.g.
> > /sys/devices/pci0000:00/0000:00:1d.7/usb4/power/wakeup
> > is a link to:
> > /sys/devices/pci0000:00/0000:00:1d.2/usb3/power/wakeup
> > If both are using one wake-up GPE.
> 
> That doesn't seem helpful ... it'd mean that you couldn't
> manage wakeup policy for individual devices. 

> This issue is an ACPI-ism, having to do with how wakeup
> is implemented on one platform:  "GPE" signals, which are
> not exposed in any useful way, rather than IRQs (fully
> exposed and shareable, see irq_chip.set_wake) or some other
> mechanism.  So it doesn't belong in the driver model core.
> 
> 
> > Also if the ACPI device caught through acpi_get_physical device is a PCI
> > bridge, it should get evaluated what is behind the bridge and this
> > device (e.g. a network card) should get the wakeup stuff set up, not the
> > bridge?
> 
> One part of the bug 6892 discussion is specifically about
> how PCI bridges don't support wakeup events ... PME# signals,
> or their PCIE equivalent, as issued by add-in PCI cards.
> I think that'll work better if ACPI gets sane support for
> wakeup from the built-in devices first.  And oddly enough,
> basic patches supporting that have been around for well over
> a year now ...
> 
> 
> > Does someone still look at this?
> > If not, shall I or is it on some queue?
> > Should this be discussed a bit more detailed first?
> 
> I'll do my bit by (re)reposting the patches I have.
> 
> - Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

