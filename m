Return-Path: <linux-kernel-owner+w=401wt.eu-S1751235AbZL1AjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbZL1AjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 19:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZL1AjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 19:39:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57178 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZL1AjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 19:39:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 09:36:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-Id: <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1261915391.15854.31.camel@laptop>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	<1261915391.15854.31.camel@laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 13:03:11 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-12-25 at 10:51 +0900, KAMEZAWA Hiroyuki wrote:
> >  /*
> > + * Returns vma which contains given address. This scans rb-tree in speculative
> > + * way and increment a reference count if found. Even if vma exists in rb-tree,
> > + * this function may return NULL in racy case. So, this function cannot be used
> > + * for checking whether given address is valid or not.
> > + */
> > +struct vm_area_struct *
> > +find_vma_speculative(struct mm_struct *mm, unsigned long addr)
> > +{
> > +       struct vm_area_struct *vma = NULL;
> > +       struct vm_area_struct *vma_tmp;
> > +       struct rb_node *rb_node;
> > +
> > +       if (unlikely(!mm))
> > +               return NULL;;
> > +
> > +       rcu_read_lock();
> > +       rb_node = rcu_dereference(mm->mm_rb.rb_node);
> > +       vma = NULL;
> > +       while (rb_node) {
> > +               vma_tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);
> > +
> > +               if (vma_tmp->vm_end > addr) {
> > +                       vma = vma_tmp;
> > +                       if (vma_tmp->vm_start <= addr)
> > +                               break;
> > +                       rb_node = rcu_dereference(rb_node->rb_left);
> > +               } else
> > +                       rb_node = rcu_dereference(rb_node->rb_right);
> > +       }
> > +       if (vma) {
> > +               if ((vma->vm_start <= addr) && (addr < vma->vm_end)) {
> > +                       if (!atomic_inc_not_zero(&vma->refcnt))
> 
> And here you destroy pretty much all advantage of having done the
> lockless lookup ;-)
> 
Hmm ? for single-thread apps ? This patch's purpose is not for lockless
lookup, it's just a part of work. My purpose is avoiding false-sharing.

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

Most of time is used for up/down read.

Here is a comparison between
 - page fault by 8 threads on one vma
 - page fault by 8 threads on 8 vma on x86-64.

== one vma ==
# Samples: 1338964273489
#
# Overhead          Command             Shared Object  Symbol
# ........  ...............  ........................  ......
#
    26.90%  multi-fault-all  [kernel]                  [k] clear_page_c
            |
            --- clear_page_c
                __alloc_pages_nodemask
                handle_mm_fault
                do_page_fault
                page_fault
                0x400940
               |
                --100.00%-- (nil)

    20.65%  multi-fault-all  [kernel]                  [k] _raw_spin_lock
            |
            --- _raw_spin_lock
               |
               |--85.07%-- free_pcppages_bulk
               |          free_hot_cold_page

    ....<snip>
    3.94%  multi-fault-all  [kernel]                  [k] find_vma_speculative
            |
            --- find_vma_speculative
               |
               |--99.40%-- do_page_fault
               |          page_fault
               |          0x400940
               |          |
               |           --100.00%-- (nil)
               |
                --0.60%-- page_fault
                          0x400940
                          |
                           --100.00%-- (nil)
==

== 8 vma ==
    27.98%  multi-fault-all  [kernel]                  [k] clear_page_c
            |
            --- clear_page_c
                __alloc_pages_nodemask
                handle_mm_fault
                do_page_fault
                page_fault
                0x400950
               |
                --100.00%-- (nil)

    21.91%  multi-fault-all  [kernel]                  [k] _raw_spin_lock
            |
            --- _raw_spin_lock
               |
               |--77.01%-- free_pcppages_bulk
               |          free_hot_cold_page
               |          __pagevec_free
               |          release_pages
...<snip>

     0.21%  multi-fault-all  [kernel]                  [k] find_vma_speculative
            |
            --- find_vma_speculative
               |
               |--87.50%-- do_page_fault
               |          page_fault
               |          0x400950
               |          |
               |           --100.00%-- (nil)
               |
                --12.50%-- page_fault
                          0x400950
                          |
                           --100.00%-- (nil)
==
Yes, this atomic_inc_unless adds some overhead. But this isn't as bad as
false sharing in mmap_sem. Anyway, as Minchan pointed out, this code contains
bug. I consider this part again.


> The idea is to let the RCU lock span whatever length you need the vma
> for, the easy way is to simply use PREEMPT_RCU=y for now, 

I tried to remove his kind of reference count trick but I can't do that
without synchronize_rcu() somewhere in unmap code. I don't like that and
use this refcnt.

> the hard way
> is to also incorporate the drop-mmap_sem on blocking patches from a
> while ago.
> 
"drop-mmap_sem if block" is no help for this false-sharing problem.

Thanks,
-Kame




