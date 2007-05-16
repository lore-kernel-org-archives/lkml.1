Return-Path: <linux-kernel-owner+w=401wt.eu-S1762513AbXEPD1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762513AbXEPD1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 23:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXEPD1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 23:27:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756771AbXEPD1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 23:27:24 -0400
Date: Tue, 15 May 2007 20:24:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>
Subject: Re: Pagecache zeroing: zero_user_segment, zero_user_segments and
 zero_user
Message-Id: <20070515202442.eeaa49a0.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 20:00:18 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> Simplify page cache zeroing of segments of pages through 3 functions
> 
> 
> zero_user_segments(page, start1, end1, start2, end2)
> 
> 	Zeros two segments of the page. It takes the position where to
> 	start and end the zeroing which avoids length calculations.
> 
> zero_user_segment(page, start, end)
> 
> 	Same for a single segment.
> 
> zero_user(page, start, length)
> 
> 	Length variant for the case where we know the length.
> 
> 
> 
> We remove the zero_user_page macro. Issues:
> 
> 1. Its a macro. Inline functions are preferable.
> 
> 2. It has a useless parameter specifying the kmap slot.
>    The functions above default to KM_USER0 which is also always used when
>    zero_user_page was called except in one single case. We open code that
>    single case to draw attention to the spot.
> 

Dunno.  fwiw, we decided to _not_ embed KM_USER0 in the callee: we have had
some pretty ghastly bugs in the past due to misuse of kmap slots so the
idea was to shove the decision into the caller's face, make them think
about what they're doing

> +static inline void zero_user_segments(struct page *page,
> +	unsigned start1, unsigned end1,
> +	unsigned start2, unsigned end2)
> +{
> +	void *kaddr = kmap_atomic(page, KM_USER0);
> +
> +	BUG_ON(end1 > PAGE_SIZE ||
> +		end2 > PAGE_SIZE);
> +
> +	if (end1 > start1)
> +		memset(kaddr + start1, 0, end1 - start1);
> +
> +	if (end2 > start2)
> +		memset(kaddr + start2, 0, end2 - start2);
> +
> +	flush_dcache_page(page);
> +	kunmap_atomic(kaddr, KM_USER0);
> +}

For some reason we've always done the flush_dcache_page() while holding the
kmap.  There's no reason for doing it this way and it just serves to worsen
scheduling latency a tiny bit.


