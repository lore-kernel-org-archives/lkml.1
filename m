Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZC1Mif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZC1Mif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZC1MiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 08:38:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:44103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZC1MiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 08:38:24 -0400
Subject: Re: [PATCH 1/2] x86/mm: maintain a percpu "in get_user_pages_fast"
 flag
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <49CDD7B4.4020701@cosmosbay.com>
References: <49CD37B8.4070109@goop.org> <49CD9E25.2090407@redhat.com>
	 <49CDAF17.5060207@goop.org>  <49CDD7B4.4020701@cosmosbay.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Mar 2009 13:31:58 +0100
Message-Id: <1238243518.4039.725.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 08:54 +0100, Eric Dumazet wrote:
> Jeremy Fitzhardinge a écrit :
> > Avi Kivity wrote:
> >> Jeremy Fitzhardinge wrote:
> >>> get_user_pages_fast() relies on cross-cpu tlb flushes being a barrier
> >>> between clearing and setting a pte, and before freeing a pagetable page.
> >>> It usually does this by disabling interrupts to hold off IPIs, but
> >>> some tlb flush implementations don't use IPIs for tlb flushes, and
> >>> must use another mechanism.
> >>>
> >>> In this change, add in_gup_cpumask, which is a cpumask of cpus currently
> >>> performing a get_user_pages_fast traversal of a pagetable.  A cross-cpu
> >>> tlb flush function can use this to determine whether it should hold-off
> >>> on the flush until the gup_fast has finished.
> >>>
> >>> @@ -255,6 +260,10 @@ int get_user_pages_fast(unsigned long start, int
> >>> nr_pages, int write,
> >>>      * address down to the the page and take a ref on it.
> >>>      */
> >>>     local_irq_disable();
> >>> +
> >>> +    cpu = smp_processor_id();
> >>> +    cpumask_set_cpu(cpu, in_gup_cpumask);
> >>> +
> >>
> >> This will bounce a cacheline, every time.  Please wrap in CONFIG_XEN
> >> and skip at runtime if Xen is not enabled.
> > 
> > Every time?  Only when running successive gup_fasts on different cpus,
> > and only twice per gup_fast. (What's the typical page count?  I see that
> > kvm and lguest are page-at-a-time users, but presumably direct IO has
> > larger batches.)
> 
> If I am not mistaken, shared futexes where hitting hard mm semaphore.
> Then gup_fast was introduced in kernel/futex.c to remove this contention point.
> Yet, this contention point was process specific, not a global one :)
> 
> And now, you want to add a global hot point, that would slow
> down unrelated processes, only because they use shared futexes, thousand
> times per second...

Yet another reason to turn all this virt muck off :-) I just wish I
could turn off the paravirt code impact, it makes finding functions in
the x86 code a terrible pain.

> > Alternatively, it could have per-cpu flags and the other side could
> > construct the mask (I originally had that, but this was simpler).
> 
> Simpler but would be a regression for legacy applications still using shared
> futexes (because statically linked with old libc)

Still doesn't help those apps that really use shared futexes.

