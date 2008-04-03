Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYDCLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYDCLsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYDCLsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 07:48:03 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:50143 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbYDCLsA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 07:48:00 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Thu, 3 Apr 2008 13:47:20 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804030704.21480.volker.armin.hemmann@tu-clausthal.de> <47F46A74.504@gmail.com>
In-Reply-To: <47F46A74.504@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200804031347.20352.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 3. April 2008, Tejun Heo wrote:
> Hello, Volker.
>
> Volker Armin Hemmann wrote:
> >>> In short, no changes at all.
> >>
> >> Thanks for confirming.
> >>
> >> Peer, Kuan.  Volker is reporting detection problems on MCP65 AHCI.
> >> The followings are what we've discovered till now.
> >>
> >> 1. When the controller is put into non-raid mode in BIOS
> >>
> >>   * If softreset is used, either the softreset itself or IDENTIFY
> >>     following it times out once.  On retrial, it works fine.  It
> >>     doesn't matter whether the SRST is issued by itself or as
> >>     follow-up-srst after hardreset.  Using only hardreset works fine.
> >>
> >>   * The controller doesn't indicate MSI capability and MSI isn't used
> >>     by default.
> >>
> >> 2. When the controller is put into ahci mode in BIOS
> >>
> >>   * SRST works fine.
> >>
> >>   * The controller indicates MSI capability but MSI doesn't work
> >>     properly resulting in IRQ delivery failure.  Adding
> >>     intx_disable_bug quirk doesn't help.
> >>
> >> I've performed similar test on MCP67 and everything worked fine on it.
> >>
> >> Both problems (SRST and MSI) can be worked around but I need more
> >> information to work around those.
> >>
> >> * Which chips are affected?  Are there proper fixes?
> >>
> >> * For the MSI problem, is it system wide problem or local to the ahci
> >>   controller?
> >
> > I rebooted with non-raid set, without pci=nomsi
> >
> > this is cat /proc/interrupts:
> >           CPU0       CPU1
> >   0:         57          1   IO-APIC-edge      timer
> >   1:          0         81   IO-APIC-edge      i8042
> >   8:          0          1   IO-APIC-edge      rtc
> >   9:          0          1   IO-APIC-fasteoi   acpi
> >  12:          0          3   IO-APIC-edge      i8042
> >  17:          2       2868   IO-APIC-fasteoi   nvidia
> >  18:          0          0   IO-APIC-fasteoi   EMU10K1
> >  22:          4        745   IO-APIC-fasteoi   ehci_hcd:usb1
> > 314:          0        158   PCI-MSI-edge      eth0
> > 315:          7      12769   PCI-MSI-edge      ahci
> >
> > as you can see, only the sata controller and the network uses msi.
> >
> > And networking works - or I wouldn't be able to send you this mail.
>
> I guess the ahci controller works too.  This is getting confusing, so
> MSI doesn't work iff the controller is configured as ahci in BIOS?

that is correct, if I set it to 'ahci' in bios, no interrupts are delivered.

>From systemrescuecd, ahci in bios, no nomsi:
           CPU0       CPU1       
  0:        147          1   IO-APIC-edge      timer
  1:          0        607   IO-APIC-edge      i8042
  8:          0         61   IO-APIC-edge      rtc
  9:          0          1   IO-APIC-fasteoi   acpi
 12:          0          4   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      libata
 15:          0          0   IO-APIC-edge      libata
 18:          0         16   IO-APIC-fasteoi   aic7xxx
 21:          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 22:          2       8428   IO-APIC-fasteoi   ehci_hcd:usb1
1274:          0          0   PCI-MSI-edge      ahci
1275:          0        222   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:      14777      16785   Local timer interrupts
RES:       7250       6100   Rescheduling interrupts
CAL:         41         52   function call interrupts
TLB:       1866       1876   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          6

With my 'own' kernel, AHCI has interrupt 315. I will try and make a more 
monolithic kernel so I might be able to boot from a usb-flash device.
.
.
.
which didn't work. Hm, I am too stupid for that today...


>
> > I will reboot from systemresucecd later today and post some results with
> > ahci-mode set, no nomsi. Just can't try patches that way.
>
> Is sytemrescuecd using the same kernel?  Otherwise, it will only add
> more to the confusion.

almost.  A heavily patched 2.6.24.2. That is why I don't sent a dmesg ... just 
cat /proc/interrupts. I can send you lspci -vv and dmesg from systemrescuecd 
if you want.

Glueck Auf,
Volker



