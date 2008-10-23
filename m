Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbYJWCW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbYJWCW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbYJWCVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:21:21 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:56310 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760660AbYJWCVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:21:19 -0400
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081022225409.GB27492@one.firstfloor.org>
References: <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
	 <1224703427.13953.8.camel@alok-dev1>
	 <20081022195845.GP12825@one.firstfloor.org>
	 <1224712846.13953.37.camel@alok-dev1>
	 <20081022221316.GW12825@one.firstfloor.org>
	 <1224713518.13953.46.camel@alok-dev1>
	 <20081022225409.GB27492@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 22 Oct 2008 19:21:18 -0700
Message-Id: <1224728478.13953.79.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 15:54 -0700, Andi Kleen wrote:
> > Not really, there are problems with the pm timer too, the one about
> > missing the counter wrap and time dropping in chunks of 4 seconds.
> > Tried to explain it over here, http://lkml.org/lkml/2008/10/22/525
> 
> Well then pit. 

PIT is not available as a clocksource if highres or one-shot timers are
enabled. So PIT is not a possibility. 

> 
> Or are you saying time is always broken on VMware & Linux?

The acpi_pm timer wrap problem has come up only with the clocksource and
NO_HZ kernels, without NO_HZ there were periodic interrupts which caused
the guest to be scheduled before ACPI_PM could wrap around.

> > So TSC is the ideal clocksource from performance and correctness point
> > of view for VMware.
> 
> But you don't seem to emulate it "ideal"ly otherwise you wouldn't
> need all these hacks you're adding?

"All these hacks" ? i guess you are talking about only this particular,
skipping the tsc_sync checks.
Rest of them are valid bugs as i have mentioned.

> 
> I think you should either implement a TSC that matches what
> real hardware does (including CPUID semantics) 

Yeah accepted, i agree this is the right approach and that's the long
term view that we are taking too.

> or implement
> a real vmware PV timer and just say it's PV and not fully virtualized.
> But doesn't the vmware paravirt ops have that already anyways?

That's for 32bit only. Apart from the tsc_sync problem i doubt we have
any other issue with the TSC as clocksource, so adding a similar
clocksource is something that i would avoid.

> 
> But I personally think it wouldn't really scale to add detection for
> more and more "nearly PV" hypervisors to the standard native kernel.

I think we anyways need a way to detect if we are running on a
hypervisor. That's the only way we can move towards having a single
image which runs well on both native hardware and a virtualized
environment. 

I guess, the only thing that you don't agree over here is the enabling
of CONSTANT_TSC bit when VMware is detected, right ?
I would agree that this could be viewed as a hack but that is the only
way we can have the kernel still working correctly on the already
released platforms. And, this should be viewed no different than the
case of fixing a slightly different behavior of a particular hardware. 

Thanks,
Alok


> 
> -Andi

