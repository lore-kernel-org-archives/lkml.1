Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYCTGMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYCTGMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 02:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYCTGMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 02:12:13 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:36220 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753279AbYCTGMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 02:12:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YxFrRNewBzA7CQJg6X3VRyCqB4WfgF22h066iHzj+8XBGkCx5/+QyTo7jtMKyNKGLUXExGO2PekmQnTIFEw+MlOP1tdcY+kpUZL2xOzHtIFdqilGKAPz/tkZEFH1jguowHMiWJhCy8FfTZ9kAqcDOv852WroVyUA56L9kDw+AQY=  ;
X-YMail-OSG: OUlITjcVM1mrS1B279ruQzM4pbAVN6Yn7LEoNQ7UeVKjjHlcrz1mQG8osTHKCSTIrtX991iO9L80x1YcyoS7wgzbs0.EcJxw2P30xMxmxNSPHvqdgA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Zhao Yakui <yakui.zhao@intel.com>
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
Date: Wed, 19 Mar 2008 23:12:05 -0700
User-Agent: KMail/1.9.6
Cc: trenn@suse.de, yi.y.yang@intel.com, Zhang Rui <rui.zhang@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net, Holger Macht <hmacht@suse.de>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com> <200803191152.09482.david-b@pacbell.net> <1205989967.4061.80.camel@localhost.localdomain>
In-Reply-To: <1205989967.4061.80.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192312.06523.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 March 2008, Zhao Yakui wrote:
> On Wed, 2008-03-19 at 11:52 -0700, David Brownell wrote:

> > Currently ACPI wakeup mechanisms are not at all integrated with
> > driver model mechanisms, or with non-ACPI bits of the system.
> > 
> > The "why" of that is that those patches still haven't been merged;
> > and the "why" of *that* is, AFAICT, that ACPI sleep/wake/resume
> > support is still in serious flux.
> > 
> > The current model is, yes, those are just flags ... and they only
> > kick in during driver state transitions.  Someday we can hope
> > they will support runtime power management (e.g. putting PCI
> > devices in PCI_D3hot to save power, then letting them trigger
> > runtime wake events when external hardware asks for that) ...
> > but for now, those transitions only kick in when the system as
> > a whole enters a sleep state, via /sys/power/state writes.
> 
> Right. Now the system only supports that the device wakes the whole
> sleeping system.

That's "barely" supported ... disabled by default, hard to
turn on, rarely (if ever) used, and so on.


> Maybe it is necessary to add the runtime wakeup 
> support. (For example: the PCI device that supports PME)

That'd go more smoothly if we first made the "easier" wake
event support work properly.  After all, that's basically
just making code that's been there for years always kick
in during system sleep transitions, and helping to make sure
the relevant drivers know how to use it ...


> > In short:  only USB portions of the tree have those flags set,
> > since USB (a) has some workarounds for the lack of ACPI support
> > on OHCI and EHCI controllers, like 00:1d.7, and (b) supports
> > those flags for devices that ACPI doesn't know about, such as
> > most USB keyboards, hubs, mice, and so forth.  Plus, (c) you
> > aren't using the rtc-cmos driver, which works better with the
> > rest of Linux than the legacy drivers/char/rtc driver.
> 
> It seems that the following only means that the PME is supported by the
> USB PCI device.
> 
> > /sys/devices/pci0000:00/0000:00:1d.7/power/wakeup

It's set by that HCD as it initializes, because ACPI still
doesn't do so.  There are hardware flags the BIOS sets and
the HCD sees, which in this case partially make up for the
weak support from ACPI.

And it's not specific to PME#, except with EHCI.  With
OHCI for example those flags get set with "legacy" PCI
power management too.

 
> When the system enters the sleeping state, whether the 1d.7 PCI device
> can wake the system is related to the following two factors:
>     a. /proc/acpi/wakeup flag for 1d.7 PCI device is enabled.
>     b. the Power/wakeup flag in Sys I/F is enabled. ( It means that PME
> is supported and configured)

And the /proc/acpi/wakeup stuff needs to go away, in favor
of standard driver model mechanisms that (a) aren't specific
to ACPI, and (b) don't default to "off, and hard to turn on".

Note that on at least some systems it seems that the ACPI bits
aren't entirely necessary.  When the driver enables PCI wakeup
mechanisms, the hardware reacts well enough to wake the system
even if ACPI has not *also* told it do do so.  (Of course it'd
be better if there were no issues about whether ACPI has been
appropriately stroked.)
   

> > > Also a second file is missing from which state (S3,S4,S5) the device can
> > > wake the machine up.
> > 
> > Those labels are ACPI-specific, and anything at the core of
> > Linux (like the driver model and its wakeup flags) should
> > never be ACPI-specific!
> 
> Yes. the second file is ACPI-specific. We should add this file.

Why?  "Just because" or is there a real need it would address?


> And the 
> info should be obtained by the associated ACPI device. Maybe it is
> better that it is create in the subdirectory of ACPI device and the link
> is created.

If ACPI-specific state like that "should" be exported, it should
be in an ACPI-specific portion of the tree.  And as for that link,
I'm still not clear on why the patch in

   http://marc.info/?l=linux-acpi&m=120500563430488&w=2

still hasn't merged ... that provides the relevant linkage in
as neutral a way as possible.


> > Plus, it's not clear how much that matters.  It's not as if
> > drivers should prevent entering sleep states if they can't
> > act as wake event sources in that level (e.g. S3 == "mem").
> > That information can stay in /proc/acpi/wakeup until that's
> > finally removed; if no userspace tools need that info, I see
> > no good reason for exporting it.
>
