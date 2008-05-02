Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbYEBGNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbYEBGNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 02:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYEBGNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 02:13:25 -0400
Received: from ozlabs.org ([203.10.76.45]:34842 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYEBGNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 02:13:24 -0400
Date: Fri, 2 May 2008 15:56:48 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [POWERPC][v2] Bolt in SLB entry for kernel stack on secondary
	cpus
Message-ID: <20080502055648.GA28378@yookeroo.seuss>
Mail-Followup-To: Paul Mackerras <paulus@samba.org>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <18458.39064.783013.268948@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18458.39064.783013.268948@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 02:29:12PM +1000, Paul Mackerras wrote:
> This fixes a regression reported by Kamalesh Bulabel where a POWER4
> machine would crash because of an SLB miss at a point where the SLB
> miss exception was unrecoverable.  This regression is tracked at:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10082
> 
> SLB misses at such points shouldn't happen because the kernel stack is
> the only memory accessed other than things in the first segment of the
> linear mapping (which is mapped at all times by entry 0 of the SLB).
> The context switch code ensures that SLB entry 2 covers the kernel
> stack, if it is not already covered by entry 0.  None of entries 0
> to 2 are ever replaced by the SLB miss handler.
> 
> Where this went wrong is that the context switch code assumes it
> doesn't have to write to SLB entry 2 if the new kernel stack is in the
> same segment as the old kernel stack, since entry 2 should already be
> correct.  However, when we start up a secondary cpu, it calls
> slb_initialize, which doesn't set up entry 2.  This is correct for
> the boot cpu, where we will be using a stack in the kernel BSS at this
> point (i.e. init_thread_union), but not necessarily for secondary
> cpus, whose initial stack can be allocated anywhere.  This doesn't
> cause any immediate problem since the SLB miss handler will just
> create an SLB entry somewhere else to cover the initial stack.
> 
> In fact it's possible for the cpu to go quite a long time without SLB
> entry 2 being valid.  Eventually, though, the entry created by the SLB
> miss handler will get overwritten by some other entry, and if the next
> access to the stack is at an unrecoverable point, we get the crash.
> 
> This fixes the problem by making slb_initialize create a suitable
> entry for the kernel stack, if we are on a secondary cpu and the stack
> isn't covered by SLB entry 0.  This requires initializing the
> get_paca()->kstack field earlier, so I do that in smp_create_idle
> where the current field is initialized.  This also abstracts a bit of
> the computation that mk_esid_data in slb.c does so that it can be used
> in slb_initialize.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> Michael Ellerman pointed out that I should be comparing
> raw_smp_processor_id() with boot_cpuid rather than with 0.

Do you even need the processor ID test at all?  The boot processor
should always have its stack covered by SLB entry 0 when we come
through here, shouldn't it?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
