Return-Path: <linux-kernel-owner+w=401wt.eu-S967037AbXEGVz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967037AbXEGVz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966703AbXEGVzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:55:21 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967022AbXEGVzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:55:16 -0400
Date: Mon, 7 May 2007 14:54:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Fengguang Wu" <fengguang.wu@gmail.com>
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Steven Pratt" <slpratt@austin.ibm.com>,
       "Ram Pai" <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC] splice() and readahead interaction
Message-Id: <20070507145412.ae8ba25f.akpm@linux-foundation.org>
In-Reply-To: <f6b15c890705050204l11045ba3w66c8c4ae0ac3407f@mail.gmail.com>
References: <377506695.54393@ustc.edu.cn>
	<p73odlc34ga.fsf@bingen.suse.de>
	<20070425160400.GA27954@mail.ustc.edu.cn>
	<20070425160844.GA30132@one.firstfloor.org>
	<377550217.31149@ustc.edu.cn>
	<20070502120216.7350691c.dada1@cosmosbay.com>
	<f6b15c890705050204l11045ba3w66c8c4ae0ac3407f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 05:04:29 -0400
"Fengguang Wu" <fengguang.wu@gmail.com> wrote:

> Readahead logic somehow fails to populate the page range with data.
> It can be because
> 1) the readahead routine is not always called in the following lines of
> fs/splice.c:
>         if (!loff || nr_pages > 1)
>                 page_cache_readahead(mapping, &in->f_ra, in, index,
> nr_pages);
> 2) even called, page_cache_readahead() wont guarantee the pages are there.
> It wont submit readahead I/O for pages already in the radix tree, or when
> (ra_pages == 0), or after 256 cache hits.
> 
> In your case, it should be because of the retried reads, which lead to
> excessive cache hits, and disables readahead at some time.
> 
> And that _one_ failure of readahead blocks the whole read process.
> The application receives EAGAIN and retries the read, but
> __generic_file_splice_read() refuse to make progress:
> - in the previous invocation, it has allocated a blank page and inserted it
> into the radix tree, but never has the chance to start I/O for it: the test
> of SPLICE_F_NONBLOCK goes before that.
> - in the retried invocation, the readahead code will neither get out of the
> cache hit mode, nor will it submit I/O for an already existing page.
> 
> The attached patch should fix the critical splice bug. Sorry for not being
> able to test it locally for now - I'm at home and running knoppix. And the
> readahead bug will be fixed by the upcoming on-demand readahead patch. I
> should be back and submit it after a week.
> 
> Thank you,
> Fengguang Wu
> 
> 
> [splice-nonblock-fix.patch  text/x-patch (506B)]
> --- linux-2.6.21.1/fs/splice.c.old	2007-05-05 04:40:38.000000000 -0400
> +++ linux-2.6.21.1/fs/splice.c	2007-05-05 04:41:59.000000000 -0400
> @@ -378,10 +378,11 @@
>  			 * If in nonblock mode then dont block on waiting
>  			 * for an in-flight io page
>  			 */
> -			if (flags & SPLICE_F_NONBLOCK)
> -				break;
> -
> -			lock_page(page);
> +			if (flags & SPLICE_F_NONBLOCK) {
> +				if (TestSetPageLocked(page))
> +					break;
> +			} else
> +				lock_page(page);
>  
>  			/*
>  			 * page was truncated, stop here. if this isn't the

So.. afaik we're awaiting testing results for this change?

