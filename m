Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572Ab0ALR4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0ALR4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356Ab0ALR4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:56:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:62975 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab0ALR4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:56:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,263,1262592000"; 
   d="scan'208";a="530625439"
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, "ananth@in.ibm.com" <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1001120719260.17145@localhost.localdomain>
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
	 <1263264483-3959-4-git-send-email-yinghai@kernel.org>
	 <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
	 <86802c441001120059s46a2e93aydc76067960aa07e6@mail.gmail.com>
	 <alpine.LFD.2.00.1001120719260.17145@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jan 2010 09:54:48 -0800
Message-Id: <1263318889.2854.146.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 07:19 -0800, Linus Torvalds wrote:
> On Tue, 12 Jan 2010, Yinghai Lu wrote:
> > > And if it's _really_ important:
> > >
> > >  - if flat mode is so important that you want to enable it whenever
> > >   possible, what about enabling/disabling it dynamically at CPU hotplug
> > >   time? That does sound _very_ painful, but it's still better than having
> > >   to maintain some list of all systems that can ever hot-plug.
> > 
> > interesting, could be done.
> > init_apic_ldr is called even for physical flat on 64 bit.
> > could change apic on fly.
> 
> Quite frankly, while I suggested it as an option, I really suspect it's 
> too much complexity for very little real gain.

I agree.

> Say that you have only four cores, but the kernel decided that it can't 
> use logical flat APIC mode because it sees three disabled sockets and 
> thinks "ok, we may end up with a total of 16 cores if those sockets are 
> hotplugged". Is that such a disaster?
> 
> Realistically, do we really care? Do you have performance numbers that say 
> that logical flat mode is so important that we really _really_ want to use 
> it, 

We had some customers in the past who wanted to use logical flat mode
when there are only 8 logical cpus mainly because they can use chipset
based interrupt routing. I think in one case, they wanted to use HW's
round-robin algorithm so that the interrupt load was uniformly
distributed to all the logical cpu's etc. This is probably fine if all
the logical cpu's are in the same socket (/under same memory
controller). But this might be a bad idea if those 8 logical cpu's are
spread across different sockets etc.

Also, sending IPI's becomes easier as we can target multiple logical
cpu's in the logical IPI destination mask etc.

> even at the cost of nasty run-time complexity with having to 
> re-program the APIC setup entirely when going from 8->9 CPU's?

No. I don't think it is worth it. As we have more and more cores, flat
mode usage will reduce and perhaps will remain mainly for
netbooks/laptops (before we have > 8 logical cpus in that space
aswell...). Also future generations will start supporting x2apic, where
we can use x2apic cluster mode.

For now, I think we should just make sure that for smaller HW configs
like laptops/desktops we should use flat mode when we have no more than
8 logical cpu's and use physical mode when there is a potential of
supporting more than 8 cpu's.

thanks,
suresh

