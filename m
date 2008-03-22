Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYCVR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYCVR7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbYCVR7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:59:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47234 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbYCVR7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:59:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported regressions from 2.6.24)
Date: Sat, 22 Mar 2008 18:58:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de>
In-Reply-To: <47E540E7.7030108@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221858.56408.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of March 2008, Thomas Meyer wrote:
> Stefan Richter schrieb:
> > Rafael J. Wysocki wrote:
> >> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=10080
> >> Subject        : 2.6.25-rc2: ohci1394 problem (MMIO broken)
> >> Submitter    : Thomas Meyer <thomas@m3y3r.de>
> >> Date        : 2008-02-20 08:47 (31 days old)
> >> References    : http://lkml.org/lkml/2008/2/20/58
> >> Handled-By    : Stefan Richter <stefanr@s5r6.in-berlin.de>
> >
> > This bug is alas an orphan.  It is /not/ handled by me, because it is 
> > not an IEEE 1394 subsystem bug and I have no idea what to do about it.
> >
> > Note the following:
> >
> >   - Several or all of ohci1394's MMIO reads return ~0 (all bits set
> >     to one) --- or 0 --- where different values are expected.
> >
> >   - In http://lkml.org/lkml/2008/2/23/244 we get to see a
> >     WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xa7/0x16a()
> >     which is "WARN_ON_ONCE(page_is_ram(pfn));".
> >     After that, the failures start.
> >     But before that, "Unknown symbol" messages pop up when ohci1394
> >     is loaded.  These symbols are implemented by ieee1394 on which
> >     ohci1394 depends.
> >
> > More context from http://lkml.org/lkml/2008/2/23/244:
> >
> >> [  199.908169] ath_pci: wifi0: Atheros 5424/2424: mem=0x94300000, irq=17
> >
> > ath_hal taints the kernel.
> I removed the ath driver, see bug 
> http://bugzilla.kernel.org/show_bug.cgi?id=10080.
> >
> >> [  847.318678] ohci1394: Unknown symbol hpsb_iso_wake
> >> [  847.318791] ohci1394: Unknown symbol hpsb_resume_host
> > ...
> >
> > Some unexplained build problem.
> I moved ohci1394.ko + ieee1394.ko file manually to avoid automatic 
> loading. then i used insmod on those files and forgot to insmod ieee1394 
> first. That's all. This is not related to the bug.
> >
> >> [  856.789954] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, 
> >> low) -> IRQ 19
> >> [  856.790040] ------------[ cut here ]------------
> >> [  856.790044] WARNING: at arch/x86/mm/ioremap.c:137 
> >> __ioremap+0xa7/0x16a()
> >> [  856.790048] Modules linked in: ohci1394(+) ieee1394 wlan_wep 
> >> wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal(P) firmware_class 
> >> fuse snd_seq snd_seq_device nls_iso8859_15 nls_cp850 vfat fat usbhid 
> >> appletouch applesmc input_polldev led_class dummy binfmt_misc tun 
> >> pktcdvd loop msr cpuid coretemp hwmon eeprom cpufreq_powersave 
> >> cpufreq_conservative acpi_cpufreq thermal ehci_hcd tpm_infineon 
> >> i2c_i801 i2c_core tpm uhci_hcd usbcore tpm_bios processor ac battery 
> >> sr_mod rng_core iTCO_wdt button firewire_ohci firewire_core sg 
> >> snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc evdev 
> >> intel_agp cdrom [last unloaded: microcode]
> >> [  856.790119] Pid: 7140, comm: insmod Tainted: P         2.6.25-rc2 
> >> #115
> >> [  856.790125]  [<c011e5ab>] warn_on_slowpath+0x40/0x4f
> >> [  856.790143]  [<c0118045>] __wake_up+0x29/0x39
> >> [  856.790154]  [<c0277305>] netlink_broadcast+0x26e/0x2af
> >> [  856.790169]  [<c01cc36b>] kobject_uevent_env+0x33d/0x361
> >> [  856.790178]  [<c025ef2b>] pci_mmcfg_write+0xc4/0xd5
> >> [  856.790187]  [<c0260157>] raw_pci_write+0x3e/0x46
> >> [  856.790200]  [<c01148f8>] __ioremap+0xa7/0x16a
> >> [  856.790210]  [<f8b14425>] ohci1394_pci_probe+0x20c/0x5a6 [ohci1394]
> >> [  856.790226]  [<c01d63f1>] pci_device_probe+0x36/0x55
> >> [  856.790236]  [<c02226cb>] driver_probe_device+0x9d/0x114
> > ...
> >> [  856.790598] ---[ end trace 5b0384c17c339107 ]---
> >> [  856.943807] ohci1394: fw-host0: Get PHY Reg timeout 
> >> [0x00008400/0x00000000/100]
> >
> > MMIO read expected 0x00008400, got 0x00000000.
> >
> > ...
> >> [  921.826439] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
> >
> > MMIO read got random bits in the interrupt event register.
> >
> > ...
> >> [  994.471724] ohci1394: fw-host0: OHCI-1394 0.35 (PCI): IRQ=[19]  
> >> MMIO=[100000000-1000007ff]  Max Packet=[65536]  IR/IT contexts=[32/32]
> >
> > The values for Max Packet and IR/IT contexts came from bogus MMIO reads.
> >
> > Thomas, you wrote in http://lkml.org/lkml/2008/3/17/316 that the 
> > problem resurfaced.
> >   - Are the "Unknown symbol"s still there?  These are not supposed to
> >     happen.
> No. (See explanation above).
> >   - Is the "WARNING: at arch/x86/mm/ioremap.c" still there?
> No. I couldn't reproduce this warning, yet.
> 
> >   - Can you reproduce it without the atheros driver?
> Yes.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=10080.
> 
> >
> > Rafael, no matter how it looks, this is not "handled-by: me". :-)
> > I don't know nothing about kbuild nor about arch/x86/mm nor about WLAN.
> > The IEEE 1394 bits in the bug of which I know something about are 
> > purely accidental.
> Seems so.

Yes, I tend to forget about it.  I'll do my best to remember.

Thanks,
Rafael
