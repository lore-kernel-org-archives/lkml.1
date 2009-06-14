Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbZFNWQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbZFNWQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 18:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932915AbZFNWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 18:16:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37729 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913AbZFNWQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 18:16:22 -0400
Message-ID: <4A3576C3.2040500@redhat.com>
Date: Mon, 15 Jun 2009 01:16:35 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ksm: write protect pages from inside ksm
References: <1244843100-4128-1-git-send-email-ieidus@redhat.com> <Pine.LNX.4.64.0906142217270.6369@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906142217270.6369@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Sat, 13 Jun 2009, Izik Eidus wrote:
>   
>> Hugh, so untill here we are sync,
>>     
>
> Yes, that fits with what I have here, thanks (or where it didn't
> quite fit, e.g. ' versus `, I've adjusted to what you have!).  And
> thanks for fixing my *orig_pte = *ptep bug, you did point that out
> before, but I misunderstood at first.
>
>   
>> Question is what you want me to do now?,
>> (Beacuse we are skipping 2.6.31, It is ok to you to tell me something
>>  like: "Shut up and let me see what i can get with this madvise" -
>>  that from one side.
>>  From another side if you want me to do anything please say.
>>     
>
> I had to get a bit further at my end before answering on that,
> but now the answer is clear: please do some testing of your RFC
> madvise() version (which is what I'm just tidying up a little),
> and let me know any bugfixes you find.  Try with SLAB or SLUB or
> SLQB debug on e.g. CONFIG_SLUB=y, CONFIG_SLUB_DEBUG=y and boot
> option "slub_debug".
>   

Sure, let me check it.
(You do have Andrea patch that fix the "used after free slab entries" ?)

> I'm finding, whether with your RFC or my tidyup, that kksmd
> soon oopses in get_next_mmlist (or perhaps find_vma): presumably
> accessing a vma or mm which already got freed (if you don't have
> slab debugging on, it's liable to hang instead).
>
> (I've also not seen it actually merging yet: if you register
> or madvise a large anon area and memset it, the /dev/ksm version
> would merge all its pages, but I've not seen the madvise version
> do so yet - though maybe there's something stupidly wrong in my
> testing, really I'm more worried about the oopses at present.)
>
> Note that mmotm includes a patch of Nick's which adds a function
> madvise_behavior_valid() - you'll need to add your MADVs into its
> list to get it to work at all there.
>
> Here's a patch I added a month or so ago, when trying to experiment
> with KSM on all mms: shouldn't be necessary if your mm refcounting
> is right, but might help to avoid extra weirdness when things go
> wrong: exit_mmap() leaves stale vma pointers around, reckoning
> that nobody can be interested by now; but maybe KSM might peep
> so better to tidy them up at least while debugging...
>
> Thanks,
> Hugh
>
> --- old/mm/mmap.c	2009-05-01 13:47:45.000000000 +0100
> +++ new/mm/mmap.c	2009-05-03 11:34:47.000000000 +0100
> @@ -2112,6 +2112,14 @@ void exit_mmap(struct mm_struct *mm)
>  	tlb_finish_mmu(tlb, 0, end);
>  
>  	/*
> +	 * Make sure get_user_pages() and find_vma() etc. will find nothing:
> +	 * this may be necessary for KSM.
> +	 */
> +	mm->mmap = NULL;
> +	mm->mmap_cache = NULL;
> +	mm->mm_rb = RB_ROOT;
> +
> +	/*
>  	 * Walk the list again, actually closing and freeing it,
>  	 * with preemption enabled, without holding any MM locks.
>  	 */
>   

