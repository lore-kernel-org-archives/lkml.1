Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZDUHz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZDUHz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZDUHzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:55:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57775 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZDUHzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:55:09 -0400
Subject: Re: [PATCH 18/25] Do not disable interrupts in free_page_mlock()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-19-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-19-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 10:55:07 +0300
Message-Id: <1240300507.771.52.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 23:20 +0100, Mel Gorman wrote:
> free_page_mlock() tests and clears PG_mlocked using locked versions of the
> bit operations. If set, it disables interrupts to update counters and this
> happens on every page free even though interrupts are disabled very shortly
> afterwards a second time.  This is wasteful.
> 
> This patch splits what free_page_mlock() does. The bit check is still
> made. However, the update of counters is delayed until the interrupts are
> disabled and the non-lock version for clearing the bit is used. One potential
> weirdness with this split is that the counters do not get updated if the
> bad_page() check is triggered but a system showing bad pages is getting
> screwed already.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/internal.h   |   11 +++--------
>  mm/page_alloc.c |    8 +++++++-
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 987bb03..58ec1bc 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -157,14 +157,9 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
>   */
>  static inline void free_page_mlock(struct page *page)
>  {
> -	if (unlikely(TestClearPageMlocked(page))) {
> -		unsigned long flags;
> -
> -		local_irq_save(flags);
> -		__dec_zone_page_state(page, NR_MLOCK);
> -		__count_vm_event(UNEVICTABLE_MLOCKFREED);
> -		local_irq_restore(flags);
> -	}

Maybe add a VM_BUG_ON(!PageMlocked(page))?

> +	__ClearPageMlocked(page);
> +	__dec_zone_page_state(page, NR_MLOCK);
> +	__count_vm_event(UNEVICTABLE_MLOCKFREED);
>  }
>  
>  #else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */

