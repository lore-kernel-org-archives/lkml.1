Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYJWXjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYJWXjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJWXjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:39:24 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:36968 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbYJWXjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:39:23 -0400
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081023081052.GI27492@one.firstfloor.org>
References: <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
	 <1224703427.13953.8.camel@alok-dev1>
	 <20081022195845.GP12825@one.firstfloor.org>
	 <1224712846.13953.37.camel@alok-dev1>
	 <20081022221316.GW12825@one.firstfloor.org>
	 <1224713518.13953.46.camel@alok-dev1>
	 <20081022225409.GB27492@one.firstfloor.org>
	 <1224728478.13953.79.camel@alok-dev1>
	 <20081023081052.GI27492@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 23 Oct 2008 16:39:22 -0700
Message-Id: <1224805162.21776.45.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 01:10 -0700, Andi Kleen wrote:
> >
> > The acpi_pm timer wrap problem has come up only with the clocksource and
> > NO_HZ kernels, without NO_HZ there were periodic interrupts which caused
> > the guest to be scheduled before ACPI_PM could wrap around.


> ACPI_PM should be just fixed. My old independent noidlehz implementation
> just always limited the sleep times to half the wrap time of the
> timer. I suspect this needs to be done here too.
> 

Yeah fixing ACPI_PM is a good idea, but this too won't fix the problem
in the virtualized space as your VCPU can be descheduled for more than
4secs. Now since time was kept using interrupts before clocksources, the
counter wrap around never made a difference. 

> The tsc frequency one didn't sound like a valid bug.

It is not. The calibration algorithm until 2.6.27 did work well for
virtualization. 
But with the new fast path algorithm the error in calibration could now
be as high as 7600ppm, as explained on this thread. 
http://kerneltrap.org/mailarchive/linux-kernel/2008/9/5/3208194

I know that this is a corner case but can be triggered in virtualization
environment and i have seen instances of it. Its not because of any
virtualization defects but because these races are magnified here.


> I though there were some efforts to make it 64bit too?
> Or is there no VMI ROM on 64bit? Perhaps you could do the
> timer without the ROM then.

Yeah i could, the point though is that the current TSC implementation is
already good enough for virtualization with these small changes, so
adding a new algorithm doesn't seem quite that attractive to me.


> >
> > I guess, the only thing that you don't agree over here is the enabling
> > of CONSTANT_TSC bit when VMware is detected, right ?
> 
> My POV is that code supposed to drive real hardware shouldn't
> have any "is hypervisor X|Y|Z" hacks. We already got a whole
> lot of infrastructure for PV hypervisors.

These "is_hypervisor" checks are not in fast path.
Apart from that, with a field in the cpuinfo_structure we wont be
calling all these detection functions over and over again. The move is
already towards standardizing the detection process for any hypervisor.

> 
> For tsc_sync I suspect the fix is to either completely trust CONSTANT_TSC
> or make the check accept more offset or possibly a combination of both

I am ok with the CONSTANT_TSC bit check, but if people think that its
not important to skip this for native, i think adding a new flag to skip
this should be safe enough.


Ingo, HPA your views on this whole detection and skipping thing ? 

Thanks,
Alok

> .
> 
> -Andi
> --
> ak@linux.intel.com

