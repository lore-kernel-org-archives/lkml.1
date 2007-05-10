Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbXEJTyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbXEJTyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXEJTyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:54:33 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:59724 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXEJTyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:54:32 -0400
Message-ID: <46437857.9070403@cosmosbay.com>
Date: Thu, 10 May 2007 21:53:59 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] splice() and readahead interaction
References: <377506695.54393@ustc.edu.cn> <p73odlc34ga.fsf@bingen.suse.de>	 <20070425160400.GA27954@mail.ustc.edu.cn>	 <20070425160844.GA30132@one.firstfloor.org>	 <377550217.31149@ustc.edu.cn>	 <20070502120216.7350691c.dada1@cosmosbay.com> <f6b15c890705050204l11045ba3w66c8c4ae0ac3407f@mail.gmail.com>
In-Reply-To: <f6b15c890705050204l11045ba3w66c8c4ae0ac3407f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 10 May 2007 21:54:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu a écrit :
> 2007/5/2, Eric Dumazet <dada1@cosmosbay.com <mailto:dada1@cosmosbay.com>>:
> 
>     Since you work on readahead, could you please find the reason
>     following program triggers a problem in splice() syscall ?
> 
>     Description :
> 
>     I tried to use splice(SPLICE_F_NONBLOCK) in a non blocking
>     environnement, in an attempt to implement cheap AIO, and zero-copy
>     splice() feature.
> 
>     I quicky found that readahead in splice() is not really working.
> 
>     To demonstrate the problem, just compile the attached program, and
>     use it to pipe a big file (not yet in cache) to /dev/null :
> 
>     $ gcc -o spliceout spliceout.c
>     $ spliceout -d BIGFILE | cat >/dev/null
>     offset=49152 ret=49152
>     offset=65536 ret=16384
>     offset=131072 ret=65536
>     ...no more progress...   (splice() returns -1 and EAGAIN)
> 
>     reading splice(SPLICE_F_NONBLOCK) syscall implementation, I expected
>     to exploit its ability to call readahead(), and do some progress if
>     pages are ready in cache.
> 
>     But apparently, even on an idle machine, it is not working as expected.
> 
> 
> 
> Eric Dumazet, thank you for disclosing this bug.
> 
> Readahead logic somehow fails to populate the page range with data.
> It can be because
> 1) the readahead routine is not always called in the following lines of 
> fs/splice.c:
>         if (!loff || nr_pages > 1)
>                 page_cache_readahead(mapping, &in->f_ra, in, index, 
> nr_pages);
> 2) even called, page_cache_readahead() wont guarantee the pages are there.
> It wont submit readahead I/O for pages already in the radix tree, or 
> when (ra_pages == 0), or after 256 cache hits.
> 
> In your case, it should be because of the retried reads, which lead to 
> excessive cache hits, and disables readahead at some time.
> 
> And that _one_ failure of readahead blocks the whole read process.
> The application receives EAGAIN and retries the read, but 
> __generic_file_splice_read() refuse to make progress:
> - in the previous invocation, it has allocated a blank page and inserted 
> it into the radix tree, but never has the chance to start I/O for it: 
> the test of SPLICE_F_NONBLOCK goes before that.
> - in the retried invocation, the readahead code will neither get out of 
> the cache hit mode, nor will it submit I/O for an already existing page.
> 
> The attached patch should fix the critical splice bug. Sorry for not 
> being able to test it locally for now - I'm at home and running knoppix. 
> And the readahead bug will be fixed by the upcoming on-demand readahead 
> patch. I should be back and submit it after a week.
> 
> Thank you,
> Fengguang Wu
> 
> 
> ------------------------------------------------------------------------
> 
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

Sorry for the delay.

This patches solves the problem, thank you !


