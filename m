Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbXFMEBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbXFMEBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 00:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXFMEA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 00:00:56 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:56435 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752012AbXFMEAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 00:00:55 -0400
Message-ID: <381707239.04870@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 13 Jun 2007 12:00:44 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
Message-ID: <20070613040044.GB6494@mail.ustc.edu.cn>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224818.841068730@mail.ustc.edu.cn> <1181622986.6237.65.camel@localhost.localdomain> <20070612103518.GA9624@mail.ustc.edu.cn> <1181698833.6237.113.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181698833.6237.113.camel@localhost.localdomain>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 11:40:33AM +1000, Rusty Russell wrote:
> On Tue, 2007-06-12 at 18:35 +0800, Fengguang Wu wrote:
> > > This seems a little like two functions crammed into one.  Do you think
> > > page_cache_readahead_ondemand() should be split into
> > > "page_cache_readahead()" which doesn't take a page*, and
> > > "page_cache_check_readahead_page()" which is an inline which does the
> > > PageReadahead(page) check as well?
> > 
> > page_cache_check_readahead_page(..., page) is a good idea.
> > But which part of the code should we put to page_cache_readahead()
> > that does not take a page param?
> 
> OK, here's my attempt.  I also made them return void, since none of the
> callers seem to mind.  I didn't change the internals much: I think
> they're pretty clear and I didn't want to clash if you decided to rename
> the "ra" fields.  It compiles and boots.
> 
> Thoughts?

Thank you, comments follow.

> +void page_cache_sync_readahead(struct address_space *mapping,
> +			       struct file_ra_state *ra,
> +			       struct file *filp,
> +			       pgoff_t offset,
> +			       unsigned long size);
> +
> +void page_cache_async_readahead(struct address_space *mapping,
> +				struct file_ra_state *ra,
> +				struct file *filp,
> +				struct page *pg,
> +				pgoff_t offset,
> +				unsigned long size);

Got your idea: it looks like a nice split.

> +/* If page has PG_readahead flag set, call async readahead logic. */
> +static inline void
> +page_cache_check_readahead_page(struct address_space *mapping,
> +				struct file_ra_state *ra,
> +				struct file *filp,
> +				struct page *pg,
> +				pgoff_t offset,
> +				unsigned long size)
> +{
> +	if (!PageReadahead(pg))
> +		return;
> +	page_cache_async_readahead(mapping, ra, filp, pg, offset, size);
> +}

This function might not be necessary?
I guess the explicit code is clear enough.

>  static unsigned long
>  ondemand_readahead(struct address_space *mapping,
>  		   struct file_ra_state *ra, struct file *filp,
> -		   struct page *page, pgoff_t offset,
> +		   bool hit_lookahead_marker, pgoff_t offset,

Or use names like async/is_async for hit_lookahead_marker?
Seems that you have accepted the 'lookahead' term ;)

>  		   unsigned long req_size)
>  {
>  	unsigned long max;	/* max readahead pages */
> @@ -379,7 +379,7 @@ ondemand_readahead(struct address_space 
>  	 * Standalone, small read.
>  	 * Read as is, and do not pollute the readahead state.
>  	 */
> -	if (!page && !sequential) {
> +	if (!hit_lookahead_marker && !sequential) {
>  		return __do_page_cache_readahead(mapping, filp,
>  						offset, req_size, 0);
>  	}
> @@ -400,7 +400,7 @@ ondemand_readahead(struct address_space 
>  	 * E.g. interleaved reads.
>  	 * Not knowing its readahead pos/size, bet on the minimal possible one.
>  	 */
> -	if (page) {
> +	if (hit_lookahead_marker) {
>  		ra_index++;
>  		ra_size = min(4 * ra_size, max);
>  	}

> +/**
> + * page_cache_async_readahead - file readahead for marked pages
> + * @mapping: address_space which holds the pagecache and I/O vectors
> + * @ra: file_ra_state which holds the readahead state
> + * @filp: passed on to ->readpage() and ->readpages()
> + * @page: the page at @offset which has the PageReadahead flag set

                                               ^PG_readahead

> + * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
> + * @req_size: hint: total size of the read which the caller is performing in
> + *            PAGE_CACHE_SIZE units

                 ^in pagecache pages?
//Christoph is changing the fixed PAGE_CACHE_SIZE to variable ones.

> + *
> + * page_cache_async_ondemand() should be called when a page is used which
> + * has the PageReadahead flag: this is a marker to suggest that the application

              ^PG_readahead

> + * has used up enough of the readahead window that we should start pulling in
> + * more pages. */
> +void
> +page_cache_async_readahead(struct address_space *mapping,
> +			   struct file_ra_state *ra, struct file *filp,
> +			   struct page *page, pgoff_t offset,
> +			   unsigned long req_size)
> +{
> +	/* no read-ahead */
> +	if (!ra->ra_pages)
> +		return;
> +
> +	/*
> +	 * Same bit is used for PG_readahead and PG_reclaim.

I like this new comment!

> +	 */
> +	if (PageWriteback(page))
> +		return;
> +
> +	ClearPageReadahead(page);

Thank you,
Fengguang

