Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbXLNSIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbXLNSIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXLNSIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:08:05 -0500
Received: from www.tglx.de ([62.245.132.106]:33663 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbXLNSIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:08:01 -0500
Date: Fri, 14 Dec 2007 19:07:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
In-Reply-To: <20071214180119.4c492f6c@linux360.ro>
Message-ID: <alpine.LFD.0.99999.0712141835510.3668@localhost.localdomain>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <20071214154106.4f0b2d8c@linux360.ro> <20071214122048.GA12550@one.firstfloor.org>
 <20071214180119.4c492f6c@linux360.ro>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Eduard-Gabriel Munteanu wrote:

> LAPIC is seemingly disabled (C1E detection code does this), but
> clockevents still tries to use it, instead of relying on HPET.

It relies on HPET. The LAPIC is just used as a mechanism which allows
us to broadcast the tick to both cores.

> I'll look into this, but please give me a heads up if you know more
> about what's happening. Looks like fixing this is better than using
> LAPIC for dynticks (and disabling C1E) on such systems.

Yes, it's definitely worth fixing, but it's not trivial:

For Highres/dyntick we need per CPU clock event devices to avoid
serialization and broadcasting overhead in the normal operation mode.

The LAPIC timer is per CPU, fast and the best thing we have, except
for C1E enabled AMD systems.

The perfect solution for those systems would be to use the HPET
channels seperately as per CPU clock event devices. Venki tried this
some time ago, but it's hard to resolve simply because none of the
BIOSes gives us an idea to which interrupts we can route the HPET
channel interrupts. The only choice we have is to use the legacy
interrupts, which gives us the headache of emulating the RTC via the
HPET and some other stupid legacy issues.

We can not utilize the broadcast mechanism of the cpuidle code because
we do not have an idea that we are going into C1E as it is done
magically in the SMM code. To work around this is we would need to add
the broadcast notification to the halt(), safe_halt(), pm_idle_halt()
variants which float around in the kernel and make this conditional on
the C1E detection. That's nasty, but it seems the only solution for
now.

Thanks,

	tglx



