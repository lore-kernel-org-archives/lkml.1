Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZKFIl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZKFIl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZKFIlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:41:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZKFIlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:41:25 -0500
Date: Fri, 6 Nov 2009 09:40:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
Message-ID: <20091106084041.GA22505@elte.hu>
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu> <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu> <4AF3DD30.8050200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF3DD30.8050200@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Ingo Molnar wrote:
> > I havent looked deeply but at first sight i'm not 100% sure that even 
> > the lock dance hack is safe - doesnt vfree() do TLB flushes, which must 
> > be done with irqs enabled in general? If yes, then the whole notion of 
> > using the allocator from irqs-off sections is wrong and the flags 
> > save/restore is misguided (or at least incomplete).
> 
> The only place where any v*() call is nested under pcpu_lock is in the 
> alloc path, specifically pcpu_extend_area_map() ends up calling 
> vfree().  pcpu_free() path which can be called from irq context never 
> calls any vmalloc function directly.  The reclaiming is deferred to a 
> work.  Breaking the single nesting completely decouples the two locks 
> and nobody would be calling vfree() with irq disabled, so I don't 
> think there will be any problem.

My question is, why do we do flags save/restore in pcpu-alloc? Do we 
ever call it with irqs disabled? If yes, then the vfree might be unsafe 
due to vfree() potentially flushing TLBs (on all CPUs) and that act of 
sending IPIs requiring irqs to be enabled.

( Now, Nick has optimized vfree recently to lazy-free areas, but that 
  was a statistical optimization: TLB flushes are still possible, just 
  done more rarely. So we might end up calling flush_tlb_kernel_range()
  from vfree(). I've Cc:-ed Nick. )

	Ingo
