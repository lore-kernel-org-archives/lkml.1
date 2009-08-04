Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbZHDT2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbZHDT2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933045AbZHDT2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:28:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44437 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928AbZHDT2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:28:10 -0400
Message-ID: <4A788CBE.7080100@redhat.com>
Date: Tue, 04 Aug 2009 22:32:14 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 9/12] ksm: fix oom deadlock
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031317190.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031317190.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> There's a now-obvious deadlock in KSM's out-of-memory handling:
> imagine ksmd or KSM_RUN_UNMERGE handling, holding ksm_thread_mutex,
> trying to allocate a page to break KSM in an mm which becomes the
> OOM victim (quite likely in the unmerge case): it's killed and goes
> to exit, and hangs there waiting to acquire ksm_thread_mutex.
>
> Clearly we must not require ksm_thread_mutex in __ksm_exit, simple
> though that made everything else: perhaps use mmap_sem somehow?
> And part of the answer lies in the comments on unmerge_ksm_pages:
> __ksm_exit should also leave all the rmap_item removal to ksmd.
>
> But there's a fundamental problem, that KSM relies upon mmap_sem to
> guarantee the consistency of the mm it's dealing with, yet exit_mmap
> tears down an mm without taking mmap_sem.  And bumping mm_users won't
> help at all, that just ensures that the pages the OOM killer assumes
> are on their way to being freed will not be freed.
>
> The best answer seems to be, to move the ksm_exit callout from just
> before exit_mmap, to the middle of exit_mmap: after the mm's pages
> have been freed (if the mmu_gather is flushed), but before its page
> tables and vma structures have been freed; and down_write,up_write
> mmap_sem there to serialize with KSM's own reliance on mmap_sem.
>
> But KSM then needs to be careful, whenever it downs mmap_sem, to
> check that the mm is not already exiting: there's a danger of using
> find_vma on a layout that's being torn apart, or writing into page
> tables which have been freed for reuse; and even do_anonymous_page
> and __do_fault need to check they're not being called by break_ksm
> to reinstate a pte after zap_pte_range has zapped that page table.
>
> Though it might be clearer to add an exiting flag, set while holding
> mmap_sem in __ksm_exit, that wouldn't cover the issue of reinstating
> a zapped pte.  All we need is to check whether mm_users is 0 - but
> must remember that ksmd may detect that before __ksm_exit is reached.
> So, ksm_test_exit(mm) added to comment such checks on mm->mm_users.
>
> __ksm_exit now has to leave clearing up the rmap_items to ksmd,
> that needs ksm_thread_mutex; but shift the exiting mm just after the
> ksm_scan cursor so that it will soon be dealt with.  __ksm_enter raise
> mm_count to hold the mm_struct, ksmd's exit processing (exactly like
> its processing when it finds all VM_MERGEABLEs unmapped) mmdrop it,
> similar procedure for KSM_RUN_UNMERGE (which has stopped ksmd).
>
> But also give __ksm_exit a fast path: when there's no complication
> (no rmap_items attached to mm and it's not at the ksm_scan cursor),
> it can safely do all the exiting work itself.  This is not just an
> optimization: when ksmd is not running, the raised mm_count would
> otherwise leak mm_structs.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>   
Acked-by: Izik Eidus <ieidus@redhat.com>
