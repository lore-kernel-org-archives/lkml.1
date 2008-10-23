Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYJWIDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYJWIDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYJWIDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:03:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51731 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbYJWID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:03:27 -0400
Date: Thu, 23 Oct 2008 10:10:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081023081052.GI27492@one.firstfloor.org>
References: <20081021181536.GI12825@one.firstfloor.org> <1224616236.6161.60.camel@alok-dev1> <20081021192746.GJ12825@one.firstfloor.org> <1224703427.13953.8.camel@alok-dev1> <20081022195845.GP12825@one.firstfloor.org> <1224712846.13953.37.camel@alok-dev1> <20081022221316.GW12825@one.firstfloor.org> <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224728478.13953.79.camel@alok-dev1>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Or are you saying time is always broken on VMware & Linux?
> 
> The acpi_pm timer wrap problem has come up only with the clocksource and
> NO_HZ kernels, without NO_HZ there were periodic interrupts which caused
> the guest to be scheduled before ACPI_PM could wrap around.

ACPI_PM should be just fixed. My old independent noidlehz implementation
just always limited the sleep times to half the wrap time of the
timer. I suspect this needs to be done here too.



> 
> > > So TSC is the ideal clocksource from performance and correctness point
> > > of view for VMware.
> > 
> > But you don't seem to emulate it "ideal"ly otherwise you wouldn't
> > need all these hacks you're adding?
> 
> "All these hacks" ? i guess you are talking about only this particular,

Everything that requires vmware detection means your hardware
emulation is not good enough.

> skipping the tsc_sync checks.
> Rest of them are valid bugs as i have mentioned.

The tsc frequency one didn't sound like a valid bug.

> > or implement
> > a real vmware PV timer and just say it's PV and not fully virtualized.
> > But doesn't the vmware paravirt ops have that already anyways?
> 
> That's for 32bit only.

I though there were some efforts to make it 64bit too?
Or is there no VMI ROM on 64bit? Perhaps you could do the 
timer without the ROM then.

> Apart from the tsc_sync problem i doubt we have
> any other issue with the TSC as clocksource, so adding a similar
> clocksource is something that i would avoid.
> 
> > 
> > But I personally think it wouldn't really scale to add detection for
> > more and more "nearly PV" hypervisors to the standard native kernel.
> 
> I think we anyways need a way to detect if we are running on a
> hypervisor.

For PV sure. But not for non PV.

> That's the only way we can move towards having a single
> image which runs well on both native hardware and a virtualized
> environment. 

If a hypervisor is not good enough to simulate hardware closely
enough it should just set up respective paravirt ops (or register
own clock drivers etc.), but not complicate the native code with a weird 
half PV half fully emulated mix.


> 
> I guess, the only thing that you don't agree over here is the enabling
> of CONSTANT_TSC bit when VMware is detected, right ?

My POV is that code supposed to drive real hardware shouldn't
have any "is hypervisor X|Y|Z" hacks. We already got a whole
lot of infrastructure for PV hypervisors.

For tsc_sync I suspect the fix is to either completely trust CONSTANT_TSC
or make the check accept more offset or possibly a combination of both.

-Andi
-- 
ak@linux.intel.com
