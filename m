Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXKZJLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXKZJLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbXKZJLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:11:36 -0500
Received: from stinky.trash.net ([213.144.137.162]:50490 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXKZJLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:11:35 -0500
Message-ID: <474A8D97.2030808@trash.net>
Date: Mon, 26 Nov 2007 10:10:47 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Joonwoo Park <joonwpark81@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] xfrm_hash: kmalloc + memset conversion to kzalloc
References: <007c01c8300b$176975a0$9c94fea9@jason>
In-Reply-To: <007c01c8300b$176975a0$9c94fea9@jason>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joonwoo Park wrote:
> diff --git a/net/xfrm/xfrm_hash.c b/net/xfrm/xfrm_hash.c
> index 55ab579..37795bd 100644
> --- a/net/xfrm/xfrm_hash.c
> +++ b/net/xfrm/xfrm_hash.c
> @@ -17,16 +17,17 @@ struct hlist_head *xfrm_hash_alloc(unsigned int sz)
>  	struct hlist_head *n;
>  
>  	if (sz <= PAGE_SIZE)
> -		n = kmalloc(sz, GFP_KERNEL);
> -	else if (hashdist)
> -		n = __vmalloc(sz, GFP_KERNEL, PAGE_KERNEL);
> -	else
> -		n = (struct hlist_head *)
> -			__get_free_pages(GFP_KERNEL | __GFP_NOWARN,
> -					 get_order(sz));
> -
> -	if (n)
> -		memset(n, 0, sz);
> +		n = kzalloc(sz, GFP_KERNEL);
> +	else {
> +		if (hashdist)
> +			n = __vmalloc(sz, GFP_KERNEL, PAGE_KERNEL);
> +		else
> +			n = (struct hlist_head *)
> +				__get_free_pages(GFP_KERNEL | __GFP_NOWARN,
> +						 get_order(sz));
> +		if (n)
> +			memset(n, 0, sz);


How about also switching vmalloc/get_free_pages to GFP_ZERO
and getting rid of the memset entirely while you're at it?
