Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZJMFvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZJMFvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZJMFvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:51:24 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:42458 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbZJMFvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:51:23 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: oomkiller over-ambitious after "vmscan: make mapped executable pages the first class citizen" (bisected)
Date: Tue, 13 Oct 2009 07:50:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-self-00256-g36a0790; KDE/4.3.1; i686; ; )
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>
References: <200910122244.19666.borntraeger@de.ibm.com> <20091013022650.GB7345@localhost>
In-Reply-To: <20091013022650.GB7345@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910130750.36392.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 13 Oktober 2009 04:26:50 schrieb Wu Fengguang:
[...]

> Can you try this patch? Thanks!

Yes, this patch solves the problem. In fact, my test case was a reduced version
of KVM on s390 and it helps there as well.

Since the problem also affects 2.6.31 I added stable.

I agree with Rik, that this patch should go to Linus quickly, what is the best 
way? Andrew?

> ---
> vmscan: limit VM_EXEC protection to file pages
> 
> It is possible to have !Anon but SwapBacked pages, and some apps could
> create huge number of such pages with MAP_SHARED|MAP_ANONYMOUS. These
> pages go into the ANON lru list, and hence shall not be protected: we
> only care mapped executable files. Failing to do so may trigger OOM.
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>  mm/vmscan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux.orig/mm/vmscan.c	2009-10-13 09:49:05.000000000 +0800
> +++ linux/mm/vmscan.c	2009-10-13 09:49:37.000000000 +0800
> @@ -1356,7 +1356,7 @@ static void shrink_active_list(unsigned
>  			 * IO, plus JVM can create lots of anon VM_EXEC pages,
>  			 * so we ignore them here.
>  			 */
> -			if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
> +			if ((vm_flags & VM_EXEC) && page_is_file_cache(page)) {
>  				list_add(&page->lru, &l_active);
>  				continue;
>  			}
> 
