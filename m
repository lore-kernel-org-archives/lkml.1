Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXFLDbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXFLDbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbXFLDbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:31:13 -0400
Received: from ozlabs.org ([203.10.76.45]:43280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXFLDbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:31:12 -0400
Subject: Re: [PATCH 4/9] readahead: data structure and routines
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
In-Reply-To: <20070516224818.683288460@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	 <20070516224818.683288460@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 13:30:50 +1000
Message-Id: <1181619050.6237.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 06:47 +0800, Fengguang Wu wrote: 
> /*
>   * Track a single file's readahead state
> + *
> + *  ================#============|==================#==================|
> + *                  ^            ^                  ^                  ^
> + *  file_ra_state.la_index    .ra_index   .lookahead_index   .readahead_index
>   */
>  struct file_ra_state {
>  	unsigned long start;		/* Current window */
> @@ -711,6 +715,12 @@ struct file_ra_state {
>  	unsigned long prev_index;	/* Cache last read() position */
>  	unsigned long ahead_start;	/* Ahead window */
>  	unsigned long ahead_size;
> +
> +	pgoff_t la_index;               /* enqueue time */
> +	pgoff_t ra_index;               /* begin offset */
> +	pgoff_t lookahead_index;        /* time to do next readahead */
> +	pgoff_t readahead_index;        /* end offset */
> +

Hi Fengguang,

I found these variables a little confusing.  la_index is the last offset
passed to ondemand_readahead, so perhaps "last_request_start" is a
better name?  The comment "enqueue time" seems strange, too.

ra_index seems ok, although "readahead_start" might be better.  Perhaps
readahead_index should be expressed as readahead_size, which is how it
seems to be used.  Perhaps "lookahead_index" is best expressed as a
buffer at the end of the readahead zone (readahead_min?).

ie:
	pgoff_t last_request_start;     /* start of req which triggered readahead */
	pgoff_t readahead_start;        /* Where readahead started */
	pgoff_t readahead_size;         /* PAGE_CACHE_SIZE units of readahead */
	pgoff_t readahead_min;          /* readahead_size left before we recalc */

This gets rid of many of the accessors, I think, and avoids introducing
a new term to understand (lookahead).

> +/*
> + * Where is the old read-ahead and look-ahead?
> + */
> +static inline void ra_set_index(struct file_ra_state *ra,
> +				pgoff_t la_index, pgoff_t ra_index)
> +{
> +	ra->la_index = la_index;
> +	ra->ra_index = ra_index;
> +}
> +
> +/*
> + * Where is the new read-ahead and look-ahead?
> + */
> +static inline void ra_set_size(struct file_ra_state *ra,
> +				unsigned long ra_size, unsigned long la_size)
> +{
> +	ra->readahead_index = ra->ra_index + ra_size;
> +	ra->lookahead_index = ra->ra_index + ra_size - la_size;
> +}

These are only called in one place, so I think it's clearer to do this
there directly.  But I see you exported ra_submit, too, even though it's
only used in the same file.  Are there plans for other users?

Thanks,
Rusty.

