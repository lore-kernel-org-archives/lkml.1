Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbZFNNRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbZFNNRs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbZFNNRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:17:40 -0400
Received: from www.tglx.de ([62.245.132.106]:42237 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZFNNRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:17:40 -0400
Date: Sun, 14 Jun 2009 15:17:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: "Benjamin S." <sbenni@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "js@sig21.net" <js@sig21.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: RE: 2.6.30 enabling cpu1 on resume fails after suspend to memory
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4669244187@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0906141514120.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way> <200906141400.27331.rjw@sisk.pl> <alpine.LFD.2.00.0906141405450.2800@localhost.localdomain> <200906141415.16949.rjw@sisk.pl> <20090614143708.32ec250c@pluto-lenny.milky.way>
 <alpine.LFD.2.00.0906141444500.2800@localhost.localdomain> <7E82351C108FA840AB1866AC776AEC4669244187@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Pallipadi, Venkatesh wrote:
> >On Sun, 14 Jun 2009, Benjamin S. wrote:
> >
> >This is odd as well:
> >>            CPU0       CPU1       
> >>   0:         42          1   IO-APIC-edge      timer
> >>  24:       4830          0  HPET_MSI-edge      hpet2
> >> LOC:         42       5070   Local timer interrupts
> >
> >So we set up only one hpet channel for CPU0 and CPU1 uses the local
> >timer interrupt. Need to look at that as well.
> >
>
 
> Logic in percpu HPET is something like this.
>
> - Number of per cpu HPET channels = total number of HPET channels -
>   1 (global HPET) - 1 (legacy RTC replacement) - 1 (reserved for
>   /dev/hpet).
>
> - So, this number is assigned one per CPU and remaining CPUs use
>   APIC timer + broadcast logic
>
> Looks like there is a slight problem with the above though. We
> should start such per cpu assignment from CPU 1 instead of CPU 0,
> when number of HPET channels is less than number of CPUs. Will send
> a patch for that. But, this suspend resume problem should not be due
> to the percpu HPET logic. It will be good to try with hpet=disable
> to make sure...

Benjamin just confirmed that. The logic in disable_device_interrupts()
already skips interrupts marked with IRQF_TIMER, but I suspect that
the hpet/MSI interupts are not marked that way.

Thanks,

	tglx
