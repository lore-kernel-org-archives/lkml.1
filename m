Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZKFIxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZKFIxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZKFIxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:53:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:40406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbZKFIxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:53:11 -0500
Message-ID: <4AF3E3D1.7010101@kernel.org>
Date: Fri, 06 Nov 2009 17:52:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu> <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu> <4AF3DD30.8050200@kernel.org> <20091106084041.GA22505@elte.hu>
In-Reply-To: <20091106084041.GA22505@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> My question is, why do we do flags save/restore in pcpu-alloc?

That's strictly for calls from sched_init().

> Do we ever call it with irqs disabled? If yes, then the vfree might
> be unsafe due to vfree() potentially flushing TLBs (on all CPUs) and
> that act of sending IPIs requiring irqs to be enabled.

And when called from sched_init(), it won't call vfree().

> ( Now, Nick has optimized vfree recently to lazy-free areas, but that 
>   was a statistical optimization: TLB flushes are still possible, just 
>   done more rarely. So we might end up calling flush_tlb_kernel_range()
>   from vfree(). I've Cc:-ed Nick. )

Nevertheless, it would be nice to allow at least the free part to be
called from irqsafe context.  vmalloc is doing a lot of things lazily
so deferring TLB flushes to a work wouldn't make much difference, I
suppose?

Thanks.

-- 
tejun
