Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbXEOPRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbXEOPRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXEOPRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:17:47 -0400
Received: from waste.org ([66.93.16.53]:41536 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbXEOPRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:17:47 -0400
Date: Tue, 15 May 2007 10:17:31 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc][patch] slob: improvements
Message-ID: <20070515151731.GO11115@waste.org>
References: <20070515084305.GA28631@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515084305.GA28631@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 10:43:05AM +0200, Nick Piggin wrote:
> This patch goes on top of my previous RCU patch, and has various
> improvements for slob I noticed while implementing said patch ;)
> 
> Comments?

I'm warming to this. Please check that the comment block at the top is
still accurate.

> +/*
> + * slob_block has a field 'units', which indicates size of block if +ve,
> + * or offset of next block if -ve (in SLOB_UNITs).
> + *
> + * Free blocks of size 1 unit simply contain the offset of the next block.
> + * Those with larger size contain their size in the first SLOB_UNIT of
> + * memory, and the offset of the next free block in the second SLOB_UNIT.
> + */
> +#if PAGE_SIZE <= (32*1024)
> +typedef s16 slobidx_t;
> +#else
> +typedef s32 slobidx_t;
> +#endif

This math is wrong because you're doing pointer math on slobidx_ts:

> +static slob_t *slob_next(slob_t *s)
> +{
> +	slob_t *base = (slob_t *)((unsigned long)s & PAGE_MASK);
> +	slobidx_t next;
> +
> +	if (s[0].units < 0)
> +		next = -s[0].units;
> +	else
> +		next = s[1].units;
> +	return base+next;
> +}

The max is 64K.

-- 
Mathematics is the supreme nostalgia of our time.
