Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223Ab0AFAZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0AFAZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681Ab0AFAZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:25:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47046 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0AFAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:25:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 6 Jan 2010 09:22:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-Id: <20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	<20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>
	<20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 07:26:31 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 5 Jan 2010, KAMEZAWA Hiroyuki wrote:
> > #
> > # Overhead          Command             Shared Object  Symbol
> > # ........  ...............  ........................  ......
> > #
> >     43.23%  multi-fault-all  [kernel]                  [k] smp_invalidate_interrupt
> >     16.27%  multi-fault-all  [kernel]                  [k] flush_tlb_others_ipi
> >     11.55%  multi-fault-all  [kernel]                  [k] _raw_spin_lock_irqsave    <========(*)
> >      6.23%  multi-fault-all  [kernel]                  [k] intel_pmu_enable_all
> >      2.17%  multi-fault-all  [kernel]                  [k] _raw_spin_unlock_irqrestore
> 
> Hmm.. The default rwsem implementation shouldn't have any spin-locks in 
> the fast-path. And your profile doesn't seem to have any scheduler 
> footprint, so I wonder what is going on.
> 
> Oh.
> 
> Lookie here:
> 
>  - arch/x86/Kconfig.cpu:
> 
> 	config X86_XADD
> 		def_bool y
> 		depends on X86_32 && !M386
> 
>  - arch/x86/Kconfig:
> 
> 	config RWSEM_GENERIC_SPINLOCK
> 	        def_bool !X86_XADD
> 
> 	config RWSEM_XCHGADD_ALGORITHM
> 	        def_bool X86_XADD   
> 
> it looks like X86_XADD only gets enabled on 32-bit builds. Which means 
> that x86-64 in turn seems to end up always using the slower "generic 
> spinlock" version.
> 
> Are you sure this isn't the reason why your profiles are horrible?
> 
I think this is the 1st reason but haven't rewrote rwsem itself and tested,
sorry.

This is a profile in other test.
==
2.6.33-rc2's score of the same test program is here.

    75.42%  multi-fault-all  [kernel]                  [k] _raw_spin_lock_irqsav
            |
            --- _raw_spin_lock_irqsave
               |
               |--49.13%-- __down_read_trylock
               |          down_read_trylock
               |          do_page_fault
               |          page_fault
               |          0x400950
               |          |
               |           --100.00%-- (nil)
               |
               |--46.92%-- __up_read
               |          up_read
               |          |
               |          |--99.99%-- do_page_fault
               |          |          page_fault
               |          |          0x400950
               |          |          (nil)
               |           --0.01%-- [...]
==
yes, spinlock is from rwsem.

Why I tried "skipping rwsem" is because I like avoid locking rather than rewrite
lock itself when I think of the influence of the patch....


Thanks,
-Kame




