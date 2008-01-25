Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbYAYOv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbYAYOv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYAYOvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:51:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:42177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbYAYOvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:51:19 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git] new CPA implementation
From: Andi Kleen <andi@firstfloor.org>
References: <20080125002401.GA31745@elte.hu>
	<200801250901.48422.ak@novell.com> <20080125133015.GA29040@elte.hu>
Date: Fri, 25 Jan 2008 15:51:18 +0100
In-Reply-To: <20080125133015.GA29040@elte.hu> (Ingo Molnar's message of "Fri\, 25 Jan 2008 14\:30\:15 +0100")
Message-ID: <p73myqu7yc9.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Andi Kleen <ak@novell.com> wrote:
>
>> > - the new implementation is much more scalable, because it is 
>> > lockless
>> >   in the fastpath
>> 
>> What fast path?  This should not really be called that often, 
>> especially not when DEBUG_PAGEALLOC has its own simple implementation.

> that's a point you are still missing badly in all these discussions 
> about unification and sound design practices: code reuse and a clean,
> layered design.

kernel_map_pages does its own thing for flushes. I must admit I always
considered that abuse because it gives a somewhat fragile special case
where c_p_a() is not allowed to set up any state for g_f_t() for some
specific cases. Clean layering looks different to me.

> PAGEALLOC now uses change_page_attr() again and that 
> approach is working really well.

I don't really see any attempt to stop the

allocation -> kernel_map_pages -> split -> allocation -> kernel_map_pages -> 
other split -> allocation -> ....

recursion. Ok perhaps it is bounded in most cases, still looks
quite risky to me. For gbpages it will be even more likely a problem
because the max recursion depth is far deeper with the one more
level to split. Probably will resort to clear direct_gbpages
with DEBUG_PAGEALLOC, but that also seems unclean.

I also don't like that you always force GFP_ATOMIC for all c_p_a()s
now.  That makes c_p_a() much less reliable than it should be.
GFP_ATOMIC without a clear fallback is usually a mistake and most non
debugalloc c_p_a users don't have one. Yes i386 did this always, but
it was always wrong and now x86-64 got that misfeature too.

When I said earlier that not clearing PSE is a good idea I had assumed
you would set some other flag that forces all pages to be 4k from
the start, but that doesn't seem to be the case.

> it wasnt "dropped" - your wbinvd->clflush feature was never submitted in 
> a clean fashion. The "great CPA" patchset you submitted to lkml 3 weeks 
> ago was a badly interwined tangle of features and fixes,

I reviewed the sequence of changes on git-x86 you did and they seem
hardly be more separated into fixes and cleanups and changes than my
patchkit was. The main difference seems to be that it doesn't add anything,
just removes a lot of features. Since removing tends to be easier
it is a little shorter, but not much. So I think this particular criticism 
is unfair since your own attempt at this was not any better.

-Andi
