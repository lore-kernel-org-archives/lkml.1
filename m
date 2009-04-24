Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZDXLMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZDXLMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZDXLMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:12:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32964 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZDXLMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:12:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 5/5] mm: remove unlikelys for unlock in rmap.c
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090325052023.994667072@goodmis.org>
References: <20090325051920.406564281@goodmis.org> <20090325052023.994667072@goodmis.org>
Message-Id: <20090424200713.108B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 24 Apr 2009 20:12:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to lee)

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Impact: clean up
> 
> The annotated branch profiler shows that the rmap calls are likely
> called with unlock set.
> 
>  correct incorrect  %        Function                  File              Line
>  ------- ---------  -        --------                  ----              ----
>        0    46100 100 try_to_unmap_anon              rmap.c               1013
>        0    46100 100 try_to_unmap_anon              rmap.c               1005
>        0     5763 100 try_to_unmap_file              rmap.c               1074
>        0     5763 100 try_to_unmap_file              rmap.c               1069
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

unlock==1 mean munlock() is called.
unlock==0 mean memory shortage and reclaim happend.

So, we did guess end-user don't use munlock() so frequently.
but reclaim is frequently happend.

Oh well, but you have rich machine. hmm...
ok, I can agree user can use munlock() frequently.


	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




> ---
>  mm/rmap.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1652166..ad62fe0 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1002,7 +1002,7 @@ static int try_to_unmap_anon(struct page *page, int unlock, int migration)
>  	unsigned int mlocked = 0;
>  	int ret = SWAP_AGAIN;
>  
> -	if (MLOCK_PAGES && unlikely(unlock))
> +	if (MLOCK_PAGES && unlock)
>  		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
>  
>  	anon_vma = page_lock_anon_vma(page);
> @@ -1010,7 +1010,7 @@ static int try_to_unmap_anon(struct page *page, int unlock, int migration)
>  		return ret;
>  
>  	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
> -		if (MLOCK_PAGES && unlikely(unlock)) {
> +		if (MLOCK_PAGES && unlock) {
>  			if (!((vma->vm_flags & VM_LOCKED) &&
>  			      page_mapped_in_vma(page, vma)))
>  				continue;  /* must visit all unlocked vmas */
> @@ -1066,12 +1066,12 @@ static int try_to_unmap_file(struct page *page, int unlock, int migration)
>  	unsigned int mapcount;
>  	unsigned int mlocked = 0;
>  
> -	if (MLOCK_PAGES && unlikely(unlock))
> +	if (MLOCK_PAGES && unlock)
>  		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
>  
>  	spin_lock(&mapping->i_mmap_lock);
>  	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> -		if (MLOCK_PAGES && unlikely(unlock)) {
> +		if (MLOCK_PAGES && unlock) {
>  			if (!((vma->vm_flags & VM_LOCKED) &&
>  						page_mapped_in_vma(page, vma)))
>  				continue;	/* must visit all vmas */
> -- 
> 1.6.2
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



