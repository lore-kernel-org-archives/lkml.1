Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253Ab0ALPUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab0ALPUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448Ab0ALPUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:20:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab0ALPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:20:47 -0500
Date: Tue, 12 Jan 2010 07:19:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as 
 hotplug cpus.
In-Reply-To: <86802c441001120059s46a2e93aydc76067960aa07e6@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001120719260.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>  <1263264483-3959-4-git-send-email-yinghai@kernel.org>  <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain> <86802c441001120059s46a2e93aydc76067960aa07e6@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 12 Jan 2010, Yinghai Lu wrote:
> >
> > Slightly more intelligent:
> >
> >  - Look at the ACPI socket count, and hey, if it says it might have more
> >   sockets - whether they are really hotplug or not, don't use flat mode,
> >   because we simply don't know. But do _not_ do some kind of DMI table to
> >   say one way or the other.
> 
> that acpi could lie, for example, some system share one BIOS between 2
> socket/4 socket/8 sockets
> model. and BIOS could have bunch disabled entries in MADT. or MPTABLE.

That's fine. So it would mean that sometimes we'd use non-flat mode even 
if we strictly didn't need to (because we _think_ that there could be four 
sockets even though there is only one, and three are disabled). But things 
would still work without any special cases.

> > And if it's _really_ important:
> >
> >  - if flat mode is so important that you want to enable it whenever
> >   possible, what about enabling/disabling it dynamically at CPU hotplug
> >   time? That does sound _very_ painful, but it's still better than having
> >   to maintain some list of all systems that can ever hot-plug.
> 
> interesting, could be done.
> init_apic_ldr is called even for physical flat on 64 bit.
> could change apic on fly.

Quite frankly, while I suggested it as an option, I really suspect it's 
too much complexity for very little real gain.

Say that you have only four cores, but the kernel decided that it can't 
use logical flat APIC mode because it sees three disabled sockets and 
thinks "ok, we may end up with a total of 16 cores if those sockets are 
hotplugged". Is that such a disaster?

Realistically, do we really care? Do you have performance numbers that say 
that logical flat mode is so important that we really _really_ want to use 
it, even at the cost of nasty run-time complexity with having to 
re-program the APIC setup entirely when going from 8->9 CPU's?

			Linus
