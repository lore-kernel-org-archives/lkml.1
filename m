Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbXIEXtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbXIEXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 19:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932116AbXIEXts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 19:49:48 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53762 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942AbXIEXtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 19:49:47 -0400
Subject: Re: [PATCH] Fix preemptible lazy mode bug
From: Zachary Amsden <zach@vmware.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <1189024666.10802.197.camel@localhost.localdomain>
References: <46CE70C8.2030005@vmware.com>
	 <1189024666.10802.197.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 16:49:35 -0700
Message-Id: <1189036175.21516.31.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 06:37 +1000, Rusty Russell wrote:
> On Thu, 2007-08-23 at 22:46 -0700, Zachary Amsden wrote:
> > I recently sent off a fix for lazy vmalloc faults which can happen under 
> > paravirt when lazy mode is enabled.  Unfortunately, I jumped the gun a 
> > bit on fixing this.  I neglected to notice that since the new call to 
> > flush the MMU update queue is called from the page fault handler, it can 
> > be pre-empted.  Both VMI and Xen use per-cpu variables to track lazy 
> > mode state, as all previous calls to set, disable, or flush lazy mode 
> > happened from a non-preemptable state.
> 
> Hi Zach,
> 
> 	I don't think this patch does anything.  The flush is because we want
> the just-completed "set_pte" to have immediate effect, so if preempt is
> enabled we're already screwed because we can be moved between set_pte
> and the arch_flush_lazy_mmu_mode() call.
> 
> Now, where's the problem caller?  By my reading or rc4, vmalloc faults
> are fixed up before enabling interrupts.

I agree.  The patch is a nop.  I just got overly paranoid.  The whole
thing is just very prone to bugs.

So let's go over it carefully:

1) Lazy mode can't be entered unless preempt is disabled
2) Flushes are needed in two known cases: kmap_atomic and vmalloc sync
3) kmap_atomic can only be used when preempt is disabled
4) vmalloc sync happens under protection of interrupts disabled

Good logically.  What can break this logic?

#1 is defined by us
#2 is our currently believed complete list of flush scenarios
#3 is impossible to change by design
#4 seems very unlikely to change anytime soon

Seeing #2 appears weak, let us elaborate:

A) Lazy mode is used in a couple of controlled paths for user page table
updates which requires no immediately updated mapping; further, they are
protected under spinlocks, thus never preempted
B) Thus only kernel mapping updates require explicit flushes
C) Any interrupt / fault during lazy mode can only use kmap_atomic or a
set_pmd to sync a vmalloc region, thus proving my point by circular
logic (for interrupt / fault cases).
D) Or better, other kernel mapping changes (kmap, the pageattr code,
boot_ioremap, vmap, vm86 mark_screen_rdonly) are not usable by
interrupt / fault handlers, thus proving C by exclusion.

So I'm fairly certain there is no further issues with interrupt handlers
or faults, where update semantics are heavily constrained.  What of the
actual lazy mode code itself doing kernel remapping?

Most of these are clearly bogus (pageattr, boot_ioremap, vm86 stuff) for
the mm code to use inside a spinlock protected lazy mode region; it does
seem perfectly acceptable though for the mm code to use kmap or vmap
(not kmap_atomic) internally somewhere in the pagetable code.

We can exclude the trivial lazy mode regions (zeromap, unmap, and
remap).  Easily by inspection.  The PTE copy routine gets deep enough
that not all paths are immediately obvious, though, we should keep it in
mind for bug checking.

Zach

