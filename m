Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbZAPMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbZAPMsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760614AbZAPMsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:48:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933706AbZAPMsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:48:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kexec fail with e1000 and e1000e
Date: Fri, 16 Jan 2009 13:47:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-tst; KDE/4.1.3; x86_64; ; )
Cc: "Barnes, Jesse" <jesse.barnes@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440901152031k55bf8e2eu31c8b9658c2216ac@mail.gmail.com> <86802c440901152039i2021a8b0j3d6797593e05968e@mail.gmail.com> <200901161328.19194.rjw@sisk.pl>
In-Reply-To: <200901161328.19194.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161347.14212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Rafael J. Wysocki wrote:
> On Friday 16 January 2009, Yinghai Lu wrote:
> > On Thu, Jan 15, 2009 at 8:31 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > > [    8.652468] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> > > [    8.658896] Copyright (c) 1999-2006 Intel Corporation.
> > > [    8.680008] e1000 0000:05:01.0: enabling device (0000 -> 0003)
> > > [    8.685831] vendor=1022 device=7458
> > > [    8.689314] e1000 0000:05:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
> > > [    8.696184] e1000 0000:05:01.0: enabling bus mastering
> > > [    8.953642] e1000: 0000:05:01.0: e1000_probe: The EEPROM Checksum
> > > Is Not Valid
> > > [    9.863340] /*********************/
> > > [    9.866829] Current EEPROM Checksum : 0xffff
> > > [    9.871092] Calculated              : 0xbaf9
> > > [    9.875354] Offset    Values
> > > [    9.878230] ========  ======
> > > [    9.881107] 00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.887622] 00000010: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.894137] 00000020: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.900653] 00000030: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.907168] 00000040: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.913684] 00000050: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.920200] 00000060: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.926715] 00000070: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> > > [    9.933231] Include this output when contacting your support provider.
> > > [    9.939746] This is not a software error! Something bad happened to
> > > your hardware or
> > > [    9.947475] EEPROM image. Ignoring this problem could result in
> > > further problems,
> > > [    9.954945] possibly loss of data, corruption or system hangs!
> > > [    9.960767] The MAC Address will be reset to 00:00:00:00:00:00,
> > > which is invalid
> > > [    9.968149] and requires you to set the proper MAC address manually
> > > before continuing
> > > [    9.975964] to enable this network device.
> > > [    9.980053] Please inspect the EEPROM dump and report the issue to
> > > your hardware vendor
> > > [    9.988041] or Intel Customer Support.
> > > [    9.991770] /*********************/
> > >
> > > git bisect said following patch is first bad one.
> > >
> > > commit 98e6e286d7b01deb7453b717aa38ebb69d6cefc0
> > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > Date:   Wed Jan 7 13:10:35 2009 +0100
> > >
> > >    PCI PM: Register power state of devices during initialization
> > >
> > >    Use the observation that the power state of a PCI device can be
> > >    loaded into its pci_dev structure as soon as pci_pm_init() is run for
> > >    it and make that happen.
> > >
> > >    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > >    Acked-by: Pavel Machek <pavel@suse.cz>
> > >    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > reverting that patch will make kexec work with e1000 again.
> 
> Well, although I think that reverting the patch won't make much harm, I also
> don't quite understand why this should matter for kexec at all.
> 
> Can you please check if the problem also happens with the appended debug patch?

OK, scratch that, I think I know what happens.

shutdown() puts the device into D3 and then kexec relies on the device's
current_state being PCI_UNKNOWN so that pci_restore_bars() is called when
pci_set_power_state() runs for the first time.  This looks fragile, but I don't
know how to fix it cleanly at the moment and I can see this can also happen
in some other cases.  My bad.

Linus, please revert commit 98e6e286d7b01deb7453b717aa38ebb69d6cefc0
(PCI PM: Register power state of devices during initialization), because it
breaks the mechanism by which pci_restore_bars() is called during
initialization if the device is initially in D3.

Thanks,
Rafael

