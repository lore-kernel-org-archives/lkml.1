Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZHIR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZHIR3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZHIR3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 13:29:22 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:5950 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbZHIR3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 13:29:21 -0400
X-Trace: 239938059/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.120.111/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.120.111
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAL2kfkpPRXhv/2dsb2JhbACBUcpGhBgF
X-IronPort-AV: E=Sophos;i="4.43,349,1246834800"; 
   d="scan'208";a="239938059"
Date: Sun, 9 Aug 2009 18:28:48 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ZERO_PAGE again v5.
In-Reply-To: <20090805191643.2b11ae78.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0908091753250.30153@sister.anvils>
References: <20090805191643.2b11ae78.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Aug 2009, KAMEZAWA Hiroyuki wrote:
> Updated from v4 as
>   - avoid to add new arguments to vm_normal_page().
>     vm_normal_page() always returns NULL if ZERO_PAGE is found.
>   - follow_page() directly handles pte_special and ANON_ZERO_PAGE.
> 
> Then, amount of changes are reduced. Thanks for advices.
> 
> Concerns pointed out:
>   - Does use_zero_page() cover all cases ?
>     I think yes..
>   - All get_user_pages() callers, which may find ZERO_PAGE is safe ?
>     need tests.
>   - All follow_pages() callers, which may find ZERO_PAGE is safe ?
>     I think yes.

Sorry, KAMEZAWA-san, I'm afraid this is still some way off being right.

Certainly the extent of the v5 patch is much more to my taste than v4
was, thank you.

Something that's missing, which we can get away with but probably
need to reinstate, is the shortcut when COWing: not to copy the
ZERO_PAGE, but just do a memset.

But just try mlock'ing a private readonly anon area into which you've
faulted a zero page, and the "BUG: Bad page map" message tells us
it's quite wrong to be trying use_zero_page() there.

Actually, I don't understand ignore_zero at all: it's used solely by
the mlock case, yet its effect seems to be precisely not to fault in
pages if they're missing - I wonder if you've got in a muddle between
the two very different awkward cases, mlocking and coredumps of
sparsely populated areas.

And I don't at all like the way you flush_dcache_page(page) on a
page which may now be NULL: okay, you're only encouraging x86 to
say Yes to the Kconfig option, but that's a landmine for the first
arch with a real flush_dcache_page(page) which says Yes to it.

Actually, the Kconfig stuff seems silly to me (who's going to know
how to choose on or off?): the only architecture which wanted more
than one ZERO_PAGE was MIPS, and it doesn't __HAVE_ARCH_PTE_SPECIAL
yet, so I think I'm going to drop all the Kconfig end of it.

Because I hate reviewing things and trying to direct other people
by remote control: what usually happens is I send them off in some
direction which, once I try to do it myself, turns out to have been
the wrong direction.  I do need to try to do this myself, instead of
standing on the sidelines criticizing.

In fairness, I think Linus himself was a little confused when he
separated off use_zero_page(): I think we've all got confused around
there (as we noticed a month or so ago when discussing its hugetlb
equivalent), and I need to think it through again at last.

I'll get on to it now.

Hugh
