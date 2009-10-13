Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZJMCeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZJMCeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZJMCeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:34:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781AbZJMCeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:34:09 -0400
Message-ID: <4AD3E6C4.805@redhat.com>
Date: Mon, 12 Oct 2009 22:32:36 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: oomkiller over-ambitious after "vmscan: make mapped executable
 pages the first class citizen" (bisected)
References: <200910122244.19666.borntraeger@de.ibm.com> <20091013022650.GB7345@localhost>
In-Reply-To: <20091013022650.GB7345@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

> vmscan: limit VM_EXEC protection to file pages
> 
> It is possible to have !Anon but SwapBacked pages, and some apps could
> create huge number of such pages with MAP_SHARED|MAP_ANONYMOUS. These
> pages go into the ANON lru list, and hence shall not be protected: we
> only care mapped executable files. Failing to do so may trigger OOM.

Good catch!  The MAP_SHARED|MAP_ANONYMOUS segments may
be backed by anonymous tmpfs files, instead of by
actual anonymous memory!

If this patch solves Christian's problem, I believe
it should get merged into Linus's tree ASAP.

> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

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


-- 
All rights reversed.
