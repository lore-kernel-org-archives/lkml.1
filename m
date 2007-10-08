Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbXJHXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbXJHXMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXJHXML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:12:11 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:38856 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751167AbXJHXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:12:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hU+EdpzhMdOD7s2i1eWqfiWF9XNFdNFKGwuhxi8Ugmzy9RUlGx4dXChivDVbIHBYoQdUvFvpD8z3QodFbm6O6hzTHwHg8OBmc6hYfYR1oI78ksWCq4zp9fvcPomYUYzGtS6eu2Ia+lJw1WCy3nChbDyOcR6VQcjHirvbvqY8kAg=  ;
X-YMail-OSG: 9jEkNu4VM1mgJmXMlAPLOVBDSGy4LTZtWD0DyiQOqJk8A30H
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: set_page_dirty_balance() vs ->page_mkwrite()
Date: Mon, 8 Oct 2007 16:37:00 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Howells <dhowells@redhat.com>, Dave Chinner <dgc@sgi.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, mark.fasheh@oracle.com,
       hugh <hugh@veritas.com>, stable <stable@kernel.org>
References: <1191862477.20745.22.camel@twins>
In-Reply-To: <1191862477.20745.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081637.01122.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 02:54, Peter Zijlstra wrote:
> It seems that with the recent usage of ->page_mkwrite() a little detail
> was overlooked.
>
> .22-rc1 merged OCFS2 usage of this hook
> .23-rc1 merged XFS usage
> .24-rc1 will most likely merge NFS usage
>
> Please consider this for .23 final and maybe even .22.x
>
> ---
> Subject: mm: set_page_dirty_balance() vs ->page_mkwrite()
>
> All the current page_mkwrite() implementations also set the page dirty.
> Which results in the set_page_dirty_balance() call to _not_ call balance,
> because the page is already found dirty.
>
> This allows us to dirty a _lot_ of pages without ever hitting
> balance_dirty_pages().  Not good (tm).
>
> Force a balance call if ->page_mkwrite() was successful.

Would it be better to just have the callers set_page_dirty_balance()?


> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/writeback.h |    2 +-
>  mm/memory.c               |    9 +++++++--
>  mm/page-writeback.c       |    4 ++--
>  3 files changed, 10 insertions(+), 5 deletions(-)
>
> Index: linux-2.6/include/linux/writeback.h
> ===================================================================
> --- linux-2.6.orig/include/linux/writeback.h
> +++ linux-2.6/include/linux/writeback.h
> @@ -137,7 +137,7 @@ int sync_page_range(struct inode *inode,
>  			loff_t pos, loff_t count);
>  int sync_page_range_nolock(struct inode *inode, struct address_space
> *mapping, loff_t pos, loff_t count);
> -void set_page_dirty_balance(struct page *page);
> +void set_page_dirty_balance(struct page *page, int page_mkwrite);
>  void writeback_set_ratelimit(void);
>
>  /* pdflush.c */
> Index: linux-2.6/mm/memory.c
> ===================================================================
> --- linux-2.6.orig/mm/memory.c
> +++ linux-2.6/mm/memory.c
> @@ -1559,6 +1559,7 @@ static int do_wp_page(struct mm_struct *
>  	struct page *old_page, *new_page;
>  	pte_t entry;
>  	int reuse = 0, ret = 0;
> +	int page_mkwrite = 0;
>  	struct page *dirty_page = NULL;
>
>  	old_page = vm_normal_page(vma, address, orig_pte);
> @@ -1607,6 +1608,8 @@ static int do_wp_page(struct mm_struct *
>  			page_cache_release(old_page);
>  			if (!pte_same(*page_table, orig_pte))
>  				goto unlock;
> +
> +			page_mkwrite = 1;
>  		}
>  		dirty_page = old_page;
>  		get_page(dirty_page);
> @@ -1691,7 +1694,7 @@ unlock:
>  		 * do_no_page is protected similarly.
>  		 */
>  		wait_on_page_locked(dirty_page);
> -		set_page_dirty_balance(dirty_page);
> +		set_page_dirty_balance(dirty_page, page_mkwrite);
>  		put_page(dirty_page);
>  	}
>  	return ret;
> @@ -2238,6 +2241,7 @@ static int __do_fault(struct mm_struct *
>  	struct page *dirty_page = NULL;
>  	struct vm_fault vmf;
>  	int ret;
> +	int page_mkwrite = 0;
>
>  	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
>  	vmf.pgoff = pgoff;
> @@ -2315,6 +2319,7 @@ static int __do_fault(struct mm_struct *
>  					anon = 1; /* no anon but release vmf.page */
>  					goto out;
>  				}
> +				page_mkwrite = 1;
>  			}
>  		}
>
> @@ -2375,7 +2380,7 @@ out_unlocked:
>  	if (anon)
>  		page_cache_release(vmf.page);
>  	else if (dirty_page) {
> -		set_page_dirty_balance(dirty_page);
> +		set_page_dirty_balance(dirty_page, page_mkwrite);
>  		put_page(dirty_page);
>  	}
>
> Index: linux-2.6/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.orig/mm/page-writeback.c
> +++ linux-2.6/mm/page-writeback.c
> @@ -460,9 +460,9 @@ static void balance_dirty_pages(struct a
>  		pdflush_operation(background_writeout, 0);
>  }
>
> -void set_page_dirty_balance(struct page *page)
> +void set_page_dirty_balance(struct page *page, int page_mkwrite)
>  {
> -	if (set_page_dirty(page)) {
> +	if (set_page_dirty(page) || page_mkwrite) {
>  		struct address_space *mapping = page_mapping(page);
>
>  		if (mapping)
