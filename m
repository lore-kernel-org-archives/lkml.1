Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZHYPCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZHYPCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZHYPC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:02:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057AbZHYPC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:02:28 -0400
Date: Tue, 25 Aug 2009 16:58:32 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 9/12] ksm: fix oom deadlock
Message-ID: <20090825145832.GP14722@random.random>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031317190.16754@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908031317190.16754@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 01:18:16PM +0100, Hugh Dickins wrote:
> tables which have been freed for reuse; and even do_anonymous_page
> and __do_fault need to check they're not being called by break_ksm
> to reinstate a pte after zap_pte_range has zapped that page table.

This deadlocks exit_mmap in an infinite loop when there's some region
locked. mlock calls gup and pretends to page fault successfully if
there's a vma existing on the region, but it doesn't page fault
anymore because of the mm_count being 0 already, so follow_page fails
and gup retries the page fault forever. And generally I don't like to
add those checks to page fault fast path.

Given we check mm_users == 0 (ksm_test_exit) after taking mmap_sem in
unmerge_and_remove_all_rmap_items, why do we actually need to care
that a page fault happens? We hold mmap_sem so we're guaranteed to see
mm_users == 0 and we won't ever break COW on that mm with mm_users ==
0 so I think those troublesome checks from page fault can be simply
removed.
