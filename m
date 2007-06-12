Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbXFLEgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbXFLEgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 00:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXFLEgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 00:36:47 -0400
Received: from ozlabs.org ([203.10.76.45]:60933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXFLEgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 00:36:46 -0400
Subject: Re: [PATCH 5/9] readahead: on-demand readahead logic
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
In-Reply-To: <20070516224818.841068730@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	 <20070516224818.841068730@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 14:36:26 +1000
Message-Id: <1181622986.6237.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 06:47 +0800, Fengguang Wu wrote:
> +static unsigned long
> +ondemand_readahead(struct address_space *mapping,
> +		   struct file_ra_state *ra, struct file *filp,
> +		   struct page *page, pgoff_t offset,
> +		   unsigned long req_size)
> +{
> +	unsigned long max;	/* max readahead pages */
> +	pgoff_t ra_index;	/* readahead index */
> +	unsigned long ra_size;	/* readahead size */
> +	unsigned long la_size;	/* lookahead size */
> +	int sequential;
> +
> +	max = ra->ra_pages;
> +	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);

Hi again!

This <= 1UL seems weird.  prev_index is end of last request, so I'd
expect offset == prev_index + 1 for sequential reads?  Does offset ==
ra->prev_index happen?  If not, this would be clearer as (offset ==
ra->prev_index + 1).

(prev_index is not a great name either, but that's not your patch 8).

> +	/*
> +	 * Lookahead/readahead hit, assume sequential access.
> +	 * Ramp up sizes, and push forward the readahead window.
> +	 */
> +	if (offset && (offset == ra->lookahead_index ||
> +			offset == ra->readahead_index)) {
> +		ra_index = ra->readahead_index;
> +		ra_size = get_next_ra_size2(ra, max);
> +		la_size = ra_size;
> +		goto fill_ra;
> +	}

Will offset hit lookahead_index or readahead_index exactly?  Should this
be checking the range from offset to offset + req_size?

> +	ra_index = offset;
> +	ra_size = get_init_ra_size(req_size, max);
> +	la_size = ra_size > req_size ? ra_size - req_size : ra_size;

So if we're doing a big sequential read, ra_size < req_size, so next
time offset will be > ra->readahead_index and the "ramp up sizes" code
won't get run?

> +	/*
> +	 * Hit on a lookahead page without valid readahead state.
> +	 * E.g. interleaved reads.
> +	 * Not knowing its readahead pos/size, bet on the minimal possible one.
> +	 */
> +	if (page) {
> +		ra_index++;
> +		ra_size = min(4 * ra_size, max);
> +	}

If I understand correctly, it's expected to happen when we have multiple
streams: we previously marked the lookahead page, but then the other
stream changed the ra to somewhere else in the file.  We now change it
back to our stream, but we've lost information so we make it up.

This seems a little like two functions crammed into one.  Do you think
page_cache_readahead_ondemand() should be split into
"page_cache_readahead()" which doesn't take a page*, and
"page_cache_check_readahead_page()" which is an inline which does the
PageReadahead(page) check as well?

Thanks,
Rusty.

