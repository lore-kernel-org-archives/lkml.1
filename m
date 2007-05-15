Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbXEOIlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbXEOIlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758882AbXEOIlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:41:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:53764 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584AbXEOIk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:40:59 -0400
Subject: Re: [patch 4/4] powerpc 2.6.21-rt1: reduce scheduling latency
	by	changing tlb flush size
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <yyimz065x1a.wl@toshiba.co.jp>
References: <yyi3b1zapqa.wl@toshiba.co.jp>
	 <1179125506.22481.297.camel@localhost.localdomain>
	 <yyitzuf9857.wl@toshiba.co.jp> <200705141640.02561.arnd@arndb.de>
	 <yyips5261pt.wl@toshiba.co.jp>
	 <1179214707.32247.177.camel@localhost.localdomain>
	 <yyimz065x1a.wl@toshiba.co.jp>
Content-Type: text/plain
Date: Tue, 15 May 2007 18:40:37 +1000
Message-Id: <1179218437.32247.180.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >                                                                Have you measured
> > the time it takes ? We might want to modulate the amount based on wether we
> > are using native hash tables or an hypervisor.
> 
>   Yes, here is the trace log.  Accordint it, flushing  9 entries takes about 50us.
> It means that flushing 192 (PPC64_TLB_BATCH_NR) entries takes 1ms.
> Please note that tracing causes *roughly* 20-30% overhead, though.
> 
>   I'm afraid I don't have numbers w/ native version, but I suppose you have :)

Actually I don't off hand but I'll try to get some.

> # cat /proc/latency_trace
> preemption latency trace v1.1.5 on 2.6.21-rt1
> --------------------------------------------------------------------
>  latency: 60 us, #53/53, CPU#0 | (M:rt VP:0, KP:0, SP:1 HP:1 #P:1)
>     -----------------
>     | task: inetd-358 (uid:0 nice:0 policy:0 rt_prio:0)
>     -----------------
>  => started at: .__switch_to+0xa8/0x178 <c00000000000feec>
>  => ended at:   .__start+0x4000000000000000/0x8 <00000000>
> 
>                  _------=> CPU#            
>                 / _-----=> irqs-off        
>                | / _----=> need-resched    
>                || / _---=> hardirq/softirq 
>                ||| / _--=> preempt-depth   
>                |||| /                      
>                |||||     delay             
>    cmd     pid ||||| time  |   caller      
>       \   /    |||||   \   |   /           
>    inetd-358   0D..2    0us : .user_trace_start (.__switch_to)
>    inetd-358   0D..2    0us : .rt_up (.user_trace_start)
>    inetd-358   0D..3    1us : .rt_mutex_unlock (.rt_up)
>    inetd-358   0D..3    2us : .__flush_tlb_pending (.__switch_to)
>    inetd-358   0D..4    3us : .flush_hash_range (.__flush_tlb_pending)
>    inetd-358   0D..4    3us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4    4us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4    5us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5    6us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   13us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   13us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   14us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   14us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   15us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   18us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   19us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   20us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   20us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   21us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   24us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   25us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   25us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   26us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   26us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   30us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   30us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   31us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   31us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   32us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   36us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   36us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   37us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   37us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   38us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   41us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   42us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   42us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   43us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   43us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   47us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   48us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   48us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   49us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   49us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   52us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..4   53us : .flush_hash_page (.flush_hash_range)
>    inetd-358   0D..4   54us : .beat_lpar_hpte_invalidate (.flush_hash_page)
>    inetd-358   0D..4   54us : .__spin_lock_irqsave (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   55us+: .beat_lpar_hpte_getword0 (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..5   58us : .__spin_unlock_irqrestore (.beat_lpar_hpte_invalidate)
>    inetd-358   0D..2   59us : .user_trace_stop (.__switch_to)
>    inetd-358   0D..2   60us : .user_trace_stop (.__switch_to)
> -- owa

