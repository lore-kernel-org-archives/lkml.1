Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYLEVdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYLEVdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYLEVc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:32:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbYLEVc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:32:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 22:32:12 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812051300.16649.rjw@sisk.pl> <alpine.LFD.2.00.0812050754020.3386@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812050754020.3386@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812052232.12715.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of December 2008, Linus Torvalds wrote:
> 
> On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > > 
> > > It would be very interesting to see if people affected get any printouts 
> > > about IO decodes that don't show up in /proc/ioports...
> > 
> > From my box:
> > 
> > pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH6 ACPI/GP IO/TCO
> > pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH6 GPIO
> > pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
> > pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 01e0 (mask 000f)
> > 
> > The second one shows up in /proc/ioports as "01e0-01ef : pnp 00:09", but the
> > first one (at 680) doesn't.
> 
> Ok, so the patch is interesting and probably worth expanding on (to 
> actually allocate the regions), but at the same time it too doesn't 
> actually explain your problems.
> 
> While the kernel doesn't know about that magic 0x680 allocation, it also 
> won't be allocating anything over it, since we define PCIBIOS_MIN_IO to 
> 0x1000 on x86, and will never allocate new resources under that.

In the meantime I did some more debugging with unpatched mainline and found
that if resume from hibernation fails, it usually fails immediately after
resuming the SATA controller (once it apparently failed right after resuming
EHCI, but then it just might be a problem with printing more messages), where
the resume sequence is (again, for easier reference):

pci:0000:00:00.0
pci:0000:00:02.0 <- graphics
pci:0000:00:02.1 <- graphics
pci:0000:00:1b.0 <- snd_hda_intel
pci:0000:00:1c.0 <- PCI Express port 1
pci:0000:00:1c.2 <- PCI Express port 3
pci:0000:00:1d.0 <- USB UHCI
pci:0000:00:1d.1 <- USB UHCI
pci:0000:00:1d.2 <- USB UHCI
pci:0000:00:1d.3 <- USB UHCI
pci:0000:00:1d.7 <- USB EHCI
pci:0000:00:1e.0 <- transparent bridge (Intel Corporation 82801 Mobile PCI Bridge)
pci:0000:00:1f.0 <- ISA bridge
pci:0000:00:1f.2 <- SATA (ahci)

--> so it usually hangs here or during the e1000e resume (I don't
get any messages from e1000e in the failing cycles, though).

pci:0000:01:00.0 <- e1000e
No Bus:0000:01
pci:0000:02:00.0 <- wireless (iwlagn)
No Bus:0000:02
pci:0000:03:0b.0 <- cardbus bridge
pci:0000:03:0b.1 <- FireWire
pci:0000:03:0b.3 <- SD Host controller (Texas Instruments)
No Bus:0000:04
No Bus:0000:03

Interestingly enough, usually after a failure some messages still get printed
into the screen (eg. messages from the ACPI battery driver) and the keyboard
sort of works, although the keys are not decoded correctly.

Next, as I was unable to get anything with the help of magic sysrq, so I tried
to boot the kernel with nmi_watchdog=1 and in this configuration I could not
reproduce the problem.  This clearly indicates that this really is a timing
issue.

I also noticed two things that may or may not be relevant.

First, the snd_hda_intel device is a PCI Express endpoind integrated into the
root complex which is the host bridge in this case.  This may be relevant since
unloading the snd_hda_intel driver makes things work 100% of the time.

Second, the transparent bridge 0000:00:1e.0 does supports subtractive
decoding, so if there is a device doing subtractive decode behind it (the
cardbus bridge may do that, for example) it will claim any transaction not
claimed by any other device on bus 0.

Next, I'm going to hack the magic sysrq so that it will allow me to get a stack
dump after a resume failure and I will add some debug printks to the PCI
resume code path.

Thanks,
Rafael
