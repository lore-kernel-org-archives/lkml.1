Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZEYFca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZEYFca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZEYFcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:32:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:60065 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZEYFcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:32:22 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.LFD.2.01.0905240947490.3435@localhost.localdomain>
References: <20090518142707.GA24142@elte.hu>
	 <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
	 <20090518164921.GA6903@elte.hu>
	 <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
	 <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
	 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
	 <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0905240947490.3435@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 25 May 2009 15:16:49 +1000
Message-Id: <1243228609.24376.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-24 at 11:18 -0700, Linus Torvalds wrote:
> In fact, it would be nice to perhaps try to move it even earlier. Now you 
> moved it to before the scheduler init (good!), but I do wonder if it could 
> be moved up to even before the setup_per_cpu_areas() etc crud. 
> 
> I realize that the allocator wants to use the per-CPU area, but if we have 
> just the boot CPU area set up statically at that point, since it's only 
> the boot CPU running, maybe we could do those per-cpu area allocations 
> without the bootmem allocator too?

Well, we want at least node information since we want per-cpu areas
to be allocated on the right node etc...

But then, bootmem has them, so we should be able to feed them off
to SL*B early.

One thing I'm wondering... Most archs I see have their own allocator
for before bootmem is available even. On PowerPC and Sparc, we call it
LMB and it's in fact in generic code now. x86 seems to have several
layers but thew e820 early allocator seems to fit a similar bill.

I wonder if we could try to shoot bootmem that way.

With a blend of Pekka's approach which can drastically reduce how much
we need bootmem, for the remaining bits such as the SL*B own data
structures and the mem_map, the arch is responsible to provide a simple
API to provide node local allocations that is roughly equivalent to
whatever bits of bootmem remain and are needed.

That API wraps on top of whatever the arch already has for early boot
stuff.

Finally, we can keep bootmem around in lib/ or such for archs that
don't want to convert or don't have an existing suitable early
allocator.

Cheers,
Ben.




