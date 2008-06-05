Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYFEJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYFEJ2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYFEJ2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:28:00 -0400
Received: from gw.goop.org ([64.81.55.164]:50213 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYFEJ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:28:00 -0400
Message-ID: <4847B177.7070501@goop.org>
Date: Thu, 05 Jun 2008 10:27:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: operation ordering during pgd_alloc/pgd_free
References: <4847C54B.76E4.0078.0@novell.com>
In-Reply-To: <4847C54B.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> At present, pgd_ctor() adds a new pgd to pgd_list solely based on
> !SHARED_KERNEL_PMD. For PAE && !SHARED_KERNEL_PMD (i.e. Xen)
> this doesn't seem correct, as the pgd is still empty, which will confuse
> vmalloc_sync_all(). So in this case, list insertion should only happen at
> the end of pgd_prepopulate_pmd().
>   

How does vmalloc_sync_all() get confused?

> Likewise, pgd_free() calls pgd_mop_up_pmds() *before* pgd_dtor(),
> with the former zeroing pgd entries as it goes and only the latter
> removing the pgd from the list. Just as above this can confuse
> vmalloc_sync_all(), so here I would think that the two calls should just
> be swapped. However, if they get swapped, careful inspection of the
> interaction with save/restore will be needed - 

Yes, I specifically wanted to make sure that the pgd was on the list 
from before it had any entries until after it has any, to make sure that 
no pmds escape visibility from xen_mm_pin_all().  (Note to self: put a 
memory barrier to make sure the list update is complete before/after 
inserting/removing any pmd entries.)

> XenSource's Linux tree
> has a comment specifically to that effect:
>
> /*
>  * After this the pgd should not be pinned for the duration of this
>  * function's execution. We should never sleep and thus never race:
>  *  1. User pmds will not become write-protected under our feet due
>  *     to a concurrent mm_pin_all().
>  *  2. The machine addresses in PGD entries will not become invalid
>  *     due to a concurrent save/restore.
>  */
>
> Since that tree doesn't support preemption, this is perhaps fine, but
> likely going to cause problems in the (preemptable) pv-ops code.
>   

I don't think so.  When saving with preemption enabled, it first puts 
all processes in the freezer before entering stop_machine_run(); a 
process constructing a pagetable should be finished by the time it can 
be frozen.

But I think there's a problem *without* preemption.  
pmd_prepopulate_pgd() allocates new pmds with GFP_KERNEL, and so it can 
block, which undermines the precondition of the comment you quote.  This 
allows an unlisted and unpinned pgd to be missed at save time.  I could 
just use the freezer unconditionally, but there was some concern about 
how much time it would take on a busy system.

Alternatively, a different ordering would fix it:

   1. preallocate - but don't install - the pmds
   2. take pgd_lock
   3. install pmds into pgd
   4. insert pgd onto list
   5. release pgd_lock

Holding pgd_lock will prevent both vmalloc_sync_all() and 
xen_mm_pin_all() from being able to visit the pgd while it is in its 
transitional state.

> The issue with vmalloc_sync_all() would even go unnoticed, since the
> patch to unify the pgd_list mechanism with x86-64 removed the
> BUG_ON() that was meant to trigger on issues like this.
>   

Is there an inherent reason vmalloc_sync_all can't deal with a partially 
constructed pgd?  Couldn't it just skip them, as if it wasn't (or 
rather, not yet) on the list?  In fact, that looks like what it does now.

Thanks for looking at this.

    J
