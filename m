Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXFLKfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXFLKfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXFLKf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:35:26 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59499 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752501AbXFLKfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:35:25 -0400
Message-ID: <381644514.12057@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 12 Jun 2007 18:35:18 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
Message-ID: <20070612103518.GA9624@mail.ustc.edu.cn>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>
References: <20070516224752.500812933@mail.ustc.edu.cn> <20070516224818.841068730@mail.ustc.edu.cn> <1181622986.6237.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181622986.6237.65.camel@localhost.localdomain>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Tue, Jun 12, 2007 at 02:36:26PM +1000, Rusty Russell wrote:
> On Thu, 2007-05-17 at 06:47 +0800, Fengguang Wu wrote:
> > +static unsigned long
> > +ondemand_readahead(struct address_space *mapping,
> > +		   struct file_ra_state *ra, struct file *filp,
> > +		   struct page *page, pgoff_t offset,
> > +		   unsigned long req_size)
> > +{
> > +	unsigned long max;	/* max readahead pages */
> > +	pgoff_t ra_index;	/* readahead index */
> > +	unsigned long ra_size;	/* readahead size */
> > +	unsigned long la_size;	/* lookahead size */
> > +	int sequential;
> > +
> > +	max = ra->ra_pages;
> > +	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);
>
> This <= 1UL seems weird.  prev_index is end of last request, so I'd
> expect offset == prev_index + 1 for sequential reads?  Does offset ==
> ra->prev_index happen?  If not, this would be clearer as (offset ==
> ra->prev_index + 1).

It's possible to have (offset == ra->prev_index) when someone is doing
1K reads or 10K reads, which do not always align to page boundaries.

> (prev_index is not a great name either, but that's not your patch 8).

It was just renamed from `prev_page', hehe.

> > +	/*
> > +	 * Lookahead/readahead hit, assume sequential access.
> > +	 * Ramp up sizes, and push forward the readahead window.
> > +	 */
> > +	if (offset && (offset == ra->lookahead_index ||
> > +			offset == ra->readahead_index)) {
> > +		ra_index = ra->readahead_index;
> > +		ra_size = get_next_ra_size2(ra, max);
> > +		la_size = ra_size;
> > +		goto fill_ra;
> > +	}
>
> Will offset hit lookahead_index or readahead_index exactly?  Should this
> be checking the range from offset to offset + req_size?

Yes, normally lookahead_index will be hit(1). But in case readahead is
canceled because of IO congestion at that time, readahead_index will
be hit later(2).

The readahead code is called on two possible conditions:
(1) page != NULL and PageReadahead(page)
It will be an asynchronous readahead.
In this case, (offset == ra->lookahead_index) indicates sequential
reads that have been associated with a valid readahead window.

(2) page == NULL
It will be a synchronous readahead.
In this case, (offset == ra->readahead_index) indicates sequential
reads that has just consumed all of the readahead pages.

> > +	ra_index = offset;
> > +	ra_size = get_init_ra_size(req_size, max);
> > +	la_size = ra_size > req_size ? ra_size - req_size : ra_size;
>
> So if we're doing a big sequential read, ra_size < req_size, so next
> time offset will be > ra->readahead_index and the "ramp up sizes" code
> won't get run?

For big reads, (ra_size = max) and (max < req_size), la_size will be
equal to ra_size, or max. So after this readahead invocation submits
max pages of I/O and returns to do_generic_mapping_read(), it will
*immediately* be called again because of lookahead hit:

                if (!page) {
                        page_cache_readahead_ondemand(mapping,
                                        &ra, filp, page,
                                        index, last_index - index);
                        page = find_get_page(mapping, index);
                        if (unlikely(page == NULL))
                                goto no_cached_page;
                }
lookahead hit:  if (PageReadahead(page)) {
                        page_cache_readahead_ondemand(mapping,
                                        &ra, filp, page,
                                        index, last_index - index);
                }

Then it will submit another max pages of readahead I/O, whether or not
the size ramp up code will be executed: either the remaining request
size is still > max and get_init_ra_size() is called, or the remaining
request size is <= max and get_next_ra_size() is called, in both cases
they will return max.  This behavior is inherited from the current
readahead, and makes sense.

> > +	/*
> > +	 * Hit on a lookahead page without valid readahead state.
> > +	 * E.g. interleaved reads.
> > +	 * Not knowing its readahead pos/size, bet on the minimal possible one.
> > +	 */
> > +	if (page) {
> > +		ra_index++;
> > +		ra_size = min(4 * ra_size, max);
> > +	}
>
> If I understand correctly, it's expected to happen when we have multiple
> streams: we previously marked the lookahead page, but then the other
> stream changed the ra to somewhere else in the file.  We now change it
> back to our stream, but we've lost information so we make it up.

Yeah, exactly!

> This seems a little like two functions crammed into one.  Do you think
> page_cache_readahead_ondemand() should be split into
> "page_cache_readahead()" which doesn't take a page*, and
> "page_cache_check_readahead_page()" which is an inline which does the
> PageReadahead(page) check as well?

page_cache_check_readahead_page(..., page) is a good idea.
But which part of the code should we put to page_cache_readahead()
that does not take a page param?

Thank you,
Fengguang

