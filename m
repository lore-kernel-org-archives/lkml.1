Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYEPOjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYEPOjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbYEPOj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:39:29 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:39744 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbYEPOj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:39:28 -0400
Date: Fri, 16 May 2008 15:39:23 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jan Beulich <jbeulich@novell.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove double indirection on tlb parameter to free_pgd_range()
 & Co
In-Reply-To: <482C6917.76E4.0078.0@novell.com>
Message-ID: <Pine.LNX.4.64.0805161517510.8758@blonde.site>
References: <482C6917.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Jan Beulich wrote:
> The double indirection here is not needed anywhere and hence (at least)
> confusing.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Please hold off on this.  I was writing a mail to say that it should be
okay (might as well include what I wrote then below), then checked and
noticed that Andrea/Christoph have an mmu_notifier patch which removes
that argument to free_pgtables (it could alternatively keep the argument,
but make use of the double indirection).  It's not yet clear whether
or when their patch goes in, but let's not obstruct their functional
enhancements with this cleanup.

What I originally wrote was...
I had to look up my original comment on it:

    Pass mmu_gather** in the
    public interfaces, since we might want to add latency lockdrops later;
    but no attempt to do so yet, going by vma should itself reduce latency.

By "latency lockdrops" I meant the tlb_finish_mmu/tlb_gather_mmu pair
you find in unmap_vmas: I expected free_pgtables to need the same soon.

free_pgtables does have a latency issue, but not so bad that we've rushed
in to reduce it, at the expense of increasing TLB flushes, and ugliness.

We'd several of us like to rework the mmu_gathering so as not to disable
preemption: I got stuck and BenH took over, a patch much like yours below
was a part of what I had - I too was glad to get rid of the **s.

So, assuming we won't suddenly need a quick hack fix to free_pgtables
latency before one of us fixes the wider mmu_gathering issues, your
patch should be fine (and could be reverted if a sudden need occurs).

But... could I ask you to omit that move from include/linux/mm.h to
mm/internal.h?  To me that's nothing but an irritation, and internal.h
is the last place I think of to look for anything.  There's a thousand
other things internal to mm which aren't in it, and personally I wouldn't
even be thrilled by a janitorial project to move stuff over to it in bulk.

But, returning to the start, please let's hold yours back after all.

Thanks,
Hugh
