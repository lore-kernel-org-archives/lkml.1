Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZC1M2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZC1M2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 08:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZC1M2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 08:28:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZC1M2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 08:28:38 -0400
Subject: Re: [PATCH 1/2] x86/mm: maintain a percpu "in get_user_pages_fast"
 flag
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <49CDAF17.5060207@goop.org>
References: <49CD37B8.4070109@goop.org> <49CD9E25.2090407@redhat.com>
	 <49CDAF17.5060207@goop.org>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 13:27:15 +0100
Message-Id: <1238243235.4039.715.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 22:01 -0700, Jeremy Fitzhardinge wrote:
> Avi Kivity wrote:
> > Jeremy Fitzhardinge wrote:
> >> get_user_pages_fast() relies on cross-cpu tlb flushes being a barrier
> >> between clearing and setting a pte, and before freeing a pagetable page.
> >> It usually does this by disabling interrupts to hold off IPIs, but
> >> some tlb flush implementations don't use IPIs for tlb flushes, and
> >> must use another mechanism.
> >>
> >> In this change, add in_gup_cpumask, which is a cpumask of cpus currently
> >> performing a get_user_pages_fast traversal of a pagetable.  A cross-cpu
> >> tlb flush function can use this to determine whether it should hold-off
> >> on the flush until the gup_fast has finished.
> >>
> >> @@ -255,6 +260,10 @@ int get_user_pages_fast(unsigned long start, int 
> >> nr_pages, int write,
> >>      * address down to the the page and take a ref on it.
> >>      */
> >>     local_irq_disable();
> >> +
> >> +    cpu = smp_processor_id();
> >> +    cpumask_set_cpu(cpu, in_gup_cpumask);
> >> +
> >
> > This will bounce a cacheline, every time.  Please wrap in CONFIG_XEN 
> > and skip at runtime if Xen is not enabled.
> 
> Every time?  Only when running successive gup_fasts on different cpus, 
> and only twice per gup_fast. (What's the typical page count?  I see that 
> kvm and lguest are page-at-a-time users, but presumably direct IO has 
> larger batches.)

The larger the batch, the longer the irq-off latency, I've just proposed
adding a batch mechanism to gup_fast() to limit this.




