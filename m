Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbZJMLe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbZJMLe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZJMLez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:34:55 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:26928 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353AbZJMLey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:34:54 -0400
X-Trace: 273701757/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.95.113/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.95.113
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQEAEsC1EpQKV9x/2dsb2JhbACBUdRIhC0E
X-IronPort-AV: E=Sophos;i="4.44,550,1249254000"; 
   d="scan'208";a="273701757"
Date: Tue, 13 Oct 2009 12:33:58 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Rik van Riel <riel@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH][BUGFIX] vmscan: limit VM_EXEC protection to file pages
In-Reply-To: <20091013080054.GA20395@localhost>
Message-ID: <Pine.LNX.4.64.0910131221220.25854@sister.anvils>
References: <200910122244.19666.borntraeger@de.ibm.com> <20091013022650.GB7345@localhost>
 <4AD3E6C4.805@redhat.com> <20091013080054.GA20395@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Wu Fengguang wrote:

> It is possible to have !Anon but SwapBacked pages, and some apps could
> create huge number of such pages with MAP_SHARED|MAP_ANONYMOUS. These
> pages go into the ANON lru list, and hence shall not be protected: we
> only care mapped executable files. Failing to do so may trigger OOM.
> 
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

I'm not going to stand against this patch.  But I would like to point
out that it will "penalize" (well, no longer favour) executables being
run from a tmpfs.  Probably not a big deal.

And I want to put on record that (like Andrea) I really loathe this
(vm_flags & VM_EXEC) test: it's a heuristic unlike any other in page
reclaim, and one that is open to any application writer to take unfair
advantage of.

I know that it's there to make some things work better, and that it
has been successful (though now inevitably it's found to require a
tweak - how long until its next tweak?).  But I do hope that one
day you will come up with something much more satisfactory here.

Hugh

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
