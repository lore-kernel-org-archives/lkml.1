Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbZE0XTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbZE0XTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZE0XTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:19:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZE0XTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:19:13 -0400
Date: Thu, 28 May 2009 01:18:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, starlight@binnacle.cx,
       Eric B Munson <ebmunson@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
       Andy Whitcroft <apw@canonical.com>, wli@movementarian.org
Subject: Re: [PATCH 1/2] x86: Ignore VM_LOCKED when determining if
	hugetlb-backed page tables can be shared or not
Message-ID: <20090527231803.GA30002@elte.hu>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie> <1243422749-6256-2-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243422749-6256-2-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> On x86 and x86-64, it is possible that page tables are shared 
> beween shared mappings backed by hugetlbfs. As part of this, 
> page_table_shareable() checks a pair of vma->vm_flags and they 
> must match if they are to be shared. All VMA flags are taken into 
> account, including VM_LOCKED.
> 
> The problem is that VM_LOCKED is cleared on fork(). When a process 
> with a shared memory segment forks() to exec() a helper, there 
> will be shared VMAs with different flags. The impact is that the 
> shared segment is sometimes considered shareable and other times 
> not, depending on what process is checking.
> 
> What happens is that the segment page tables are being shared but 
> the count is inaccurate depending on the ordering of events. As 
> the page tables are freed with put_page(), bad pmd's are found 
> when some of the children exit. The hugepage counters also get 
> corrupted and the Total and Free count will no longer match even 
> when all the hugepage-backed regions are freed. This requires a 
> reboot of the machine to "fix".
> 
> This patch addresses the problem by comparing all flags except 
> VM_LOCKED when deciding if pagetables should be shared or not for 
> hugetlbfs-backed mapping.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>  arch/x86/mm/hugetlbpage.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)

i suspect it would be best to do this due -mm, due to the (larger) 
mm/hugetlb.c cross section, right?

	Ingo
