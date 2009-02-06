Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZBFVak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZBFVak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZBFVab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:30:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbZBFVaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:30:30 -0500
Date: Fri, 6 Feb 2009 13:29:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       adrian@newgolddream.dyndns.info, lkmladrian@gmail.com,
       linux-sh@vger.kernel.org, penberg@cs.helsinki.fi, dbaryshkov@gmail.com,
       penguin-kernel@i-love.sakura.ne.jp, hannes@cmpxchg.org
Subject: Re: [PATCH] fix broken size test in bitmap_find_free_region()
Message-Id: <20090206132950.96c3f92e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0902061313260.6241@axis700.grange>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
	<1232488507.6794.8.camel@localhost.localdomain>
	<20090121033951.GB14094@linux-sh.org>
	<20090121081118.GA14537@linux-sh.org>
	<20090127134831.3dd04182.akpm@linux-foundation.org>
	<20090127225458.GA8756@linux-sh.org>
	<Pine.LNX.4.64.0901280913090.4926@axis700.grange>
	<Pine.LNX.4.64.0902061313260.6241@axis700.grange>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 13:22:33 +0100 (CET)
Guennadi Liakhovetski <lg@denx.de> wrote:

> This loop and test in bitmap_find_free_region()
> 
> 	for (pos = 0; pos < bits; pos += (1 << order))
> 		if (__reg_op(bitmap, pos, order, REG_OP_ISFREE))
> 			break;
> 	if (pos == bits)
> 		return -ENOMEM;
> 
> can only return an error (-ENOMEM) if bits is a multiple of (1 << order), 
> which is, for instance, true, if bits is (also) a power of 2. This 
> is not necessarily the case with dma_alloc_from_coherent(). A failure to 
> recognise too large a request leads in dma_alloc_from_coherent() to 
> accessing beyond available memory, and to writing beyond the bitmap.
> 

Do we have any reports of dma_alloc_from_coherent() actually behaving
in that way?


> ---
> 
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 1338469..d49c37f 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -953,7 +953,7 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
>  	for (pos = 0; pos < bits; pos += (1 << order))
>  		if (__reg_op(bitmap, pos, order, REG_OP_ISFREE))
>  			break;
> -	if (pos == bits)
> +	if (pos + (1 << order) > bits)
>  		return -ENOMEM;
>  	__reg_op(bitmap, pos, order, REG_OP_ALLOC);
>  	return pos;
