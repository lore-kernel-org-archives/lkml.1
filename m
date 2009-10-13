Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbZJMGt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbZJMGt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZJMGt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:49:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53163 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbZJMGt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:49:56 -0400
Date: Tue, 13 Oct 2009 08:49:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org,
       andreaorru91@gmail.com, jjorge@free.fr
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden
	code
Message-ID: <20091013064901.GD9470@elte.hu>
References: <200908072333.24631.storm@sys49152.net> <4ACAC8F1.1050706@kernel.org> <4AD24B5C.4050905@kernel.org> <200910121059.10366.bjorn.helgaas@hp.com> <4AD37CA4.90601@kernel.org> <20091012192242.GA2691@elte.hu> <4AD38734.2040600@kernel.org> <1255414115.14484.47.camel@dc7800.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255414115.14484.47.camel@dc7800.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> We've established that the bridge and the NIC are handed off from BIOS 
> like this:
> 
>   pci 0000:00:1c.4: bridge io port: [0x3000-0x3fff]
>   pci 0000:00:1c.4: bridge 32bit mmio: [0xf4500000-0xf45fffff]
>   pci 0000:07:00.0: reg 10 64bit mmio: [0xf4500000-0xf4503fff]
>   pci 0000:07:00.0: reg 18 io port: [0x3000-0x30ff]
> 
> Unless we boot with "acpi=off", this configuration is lost, and by the 
> time we discover them, they look like this:
> 
>   pci 0000:00:1c.4: bridge io port: [0x00-0xfff]
>   pci 0000:00:1c.4: bridge 32bit mmio: [0x000000-0x0fffff]
>   pci 0000:00:1c.4: bridge 64bit mmio pref: [0x000000-0x0fffff]
>   pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
>   pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
> 
> Mystery #1 is why this configuration gets lost, and whether this is 
> telling us about a Linux defect.  We might get a clue about this if we 
> could see what resources the NIC uses under Windows.  If it uses the 
> handoff range (0xf4500000-0xf4503fff), it's likely that Windows 
> managed to keep the BIOS-programmed resources, and Linux is doing 
> something wrong.  If it uses some other range, then Windows likely had 
> to reconfigure the device just like Linux does.

I can see two possibilities here, on the Linux side:

- AML: if there's an ACPI table with an AML script in it, with some BIOS 
  provided vendor quirk that reprograms those BARs, that would explain 
  why acpi=off makes the side-effect go away. ACPI does not touch BARs 
  except if told by the firmware.

- The other possibility would be for there to be some ACPI table driven
  Linux PCI/driver/chipset quirk somewhere. With acpi=off that quirk 
  does not get executed.

> Mystery #2 is why, even with the lost configuration, 2.6.30 configures 
> the NIC so it works, but 2.6.31 does not.  In 2.6.30, we put the NIC 
> in the [0xb8000000-0xb80fffff] range, and in 2.6.31, we put it in 
> [0xb6000000-0xb60fffff].  I'd really like to know what the host bridge 
> _CRS says.  It's possible that we're only supposed to use the range 
> above 0xb8000000.  If that's the case, the fact that we're ignoring 
> the _CRS would be another Linux defect.

Another theory would be just pure luck: the device might have a BAR 
address constraint (which the BIOS knows about but doesnt tell us), and 
2.6.30 gets it right accidentally while 2.6.31 violates the constraint.

> In the patch below, I added some extra PCI dumps of the bridge and the 
> NIC around the ACPI EC init.  The patch also removes Yinghai's 
> workaround so we should see the original failure, just with a little 
> more debug.

Btw., i'd _strongly_ suggest to finally add some sort of pci=verbose 
easy-to-use debug toggle for users to enable.

Everything that matters to resource allocation. We should print the BIOS 
state (Yinghai did a patch for this some time ago and that is upstream 
already), we should print quirk execution, we should print ACPI AML 
execution - everything that might matter to PCI allocations.

An easy-to-use 'give me all the debug info' feature is really important. 
We have apic=verbose for similar reasons.

	Ingo
