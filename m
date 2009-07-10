Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZGJNnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZGJNnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbZGJNnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:43:41 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:61629 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbZGJNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:43:40 -0400
X-Trace: 224629039/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.78.190/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.78.190
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAH/iVkpPRU6+/2dsb2JhbACBUc5chAgFgTo
X-IronPort-AV: E=Sophos;i="4.42,378,1243810800"; 
   d="scan'208";a="224629039"
Date: Fri, 10 Jul 2009 14:43:00 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: KSM: current madvise rollup
In-Reply-To: <4A560ED7.2070403@redhat.com>
Message-ID: <Pine.LNX.4.64.0907101349360.10761@sister.anvils>
References: <Pine.LNX.4.64.0906291419440.5078@sister.anvils>
 <4A49E051.1080400@redhat.com> <Pine.LNX.4.64.0906301518370.967@sister.anvils>
 <4A4A5C56.5000109@redhat.com> <Pine.LNX.4.64.0907010057320.4255@sister.anvils>
 <4A4B317F.4050100@redhat.com> <Pine.LNX.4.64.0907082035400.10356@sister.anvils>
 <4A560ED7.2070403@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Izik Eidus wrote:
> Hugh Dickins wrote:
> >
> > But if you still like the patch below, let's advance to splitting
> > it up and getting it into mmotm: I have some opinions on the splitup,
> > I'll make some suggestions on that tomorrow.
> 
> I like it very much, you really ~cleaned / optimized / made better interface~
> it up i got to say, thanks you.
> (Very high standard you have)

Be careful: I might think you're flattering me to get KSM in ;)

> (I actually searched where you have exported follow_page and handle_mm_fault,
> and then realized that life are easier when you are not a modules anymore)

Yes, I'm glad Chris nudged us that way: your use of get_user_pages()
was great for working from the outside, but non-modular makes better
options available (options I wouldn't want a driver to be using, but
use within the mm/ directory seems fine).

> > And revealed that really those tree_items were a waste of space, can
> > be packed within the rmap_items that pointed to them, while still
> > keeping to the nice cache-friendly 64-byte or 32-byte rmap_item.
> > (If another field needed later, can make rmap_list singly linked.)
> 
> That change together with the "is_stable_tree" embedded inside the
> rmap_item address are my favorite changes.

Oh good.  I was rather expecting you to say, let's leave that to a
separate patch afterwards - that would be reasonable, and if you'd
actually prefer it that way, just say so.

> > ksmd used to be running at higher priority: now nice 0.
> 
> That is indeed logical change, maybe we can even punish it in another
> 5 points in nice...

When I noticed it running at nice -5 in top, I felt sure that's wrong,
and get better behaviour now it's not preempting ordinary loads.  But
as a babysitter, I didn't feel entitled to punish your baby too much:
if you think it's right to punish it more yourself, yes, go ahead.

> The only thing i was afraid is if the check inside the stable_tree_search is
> safe:
> 
> +			page2[0] = get_ksm_page(tree_rmap_item);
> +			if (page2[0])
> +				break;
> 
> 
> But i convinced myself that it is safe due to the fact that the page is
> anonymous, so it wasnt be able to get remapped by the user (to try to
> corrupt the stable tree) without the page will get breaked.

Did I change the dynamics there?  I thought I was just doing the same
as before more efficiently, while guarding against some races.

> So from my side I believe we can send it to mmotm I still want to run it on my
> machine and play with it, to add some bug_ons (just for my own testing) to see
> that everything
> going well, but I couldn't find one objection to any of your changes. (And i
> did try hard to find at least one..., i thought maybe module_init() can be
> replaced with something different, but i then i saw it used in vmscan.c, so i
> gave up...)

I think I went round that same loop of suspicion with the module_init(),
but in fact it's a common way of saying this init has no high precedence.

If you want something to criticize harshly, look no further than
break_ksm, where at least I had the decency to leave a comment:
	/* Which leaves us looping there if VM_FAULT_OOM: hmmm... */
but only realized later is unacceptable in the MADV_UNMERGEABLE or
KSM_RUN_UNMERGE cases - a single mm of one often repeated page could
balloon up into something huge there, we definitely need to do better.

But that needs a separate kind of testing, and what happens under
OOM has been changing recently I believe.  I'll experiment there,
but it's no reason to delay the KSM patches now going to mmotm.

> What you want to do now? send it to mmotm or do you want to
> play with it more?

And not or.  What we have now should go to mmotm, it's close
enough; but there's a little more playing to do (the OOM issue,
additional stats, Documentation, madvise man page).

I've got to rush off now, will resume later in the day: but
regarding the split up, what I have in mind is about nine patches:
perhaps I send to you, then you adjust and send on to Andrew?

I'm anxious that we get Signed-off-by's from Andrea and Chris,
for the main ones at least: too much has changed for us to assume
their signoffs, but so much the same that we very much want them in.

The nine patches that I'm thinking of, concentrating reviewers on
different aspects, most of them fairly trivial:-

Your mmu notifier mods:
include/linux/mmu_notifier.h
mm/memory.c
mm/mmu_notifier.c

My madvise_behavior rationalization:
mm/madvise.c

MADV_MERGEABLE and MADV_UNMERGEABLE (or maybe 5 patches)
arch/alpha/include/asm/mman.h
arch/mips/include/asm/mman.h
arch/parisc/include/asm/mman.h
arch/xtensa/include/asm/mman.h
include/asm-generic/mman-common.h

The interface to a dummy ksm.c:
include/linux/ksm.h
include/linux/mm.h
include/linux/sched.h
kernel/fork.c
mm/Kconfig
mm/Makefile
mm/ksm.c
mm/madvise.c

My reversion of DEBUG_VM page_dup_rmap:
include/linux/rmap.h
mm/memory.c
mm/rmap.c

Introduction of PageKsm:
fs/proc/page.c
include/linux/ksm.h
mm/memory.c

The main work:
mm/ksm.c

My fix to mremap move messing up the stable tree:
mm/mremap.c

My substitution for confusing VM_MERGEABLE_FLAGS:
mm/mmap.c

Makes sense?  Or split up mm/ksm.c more somehow?

Hugh
