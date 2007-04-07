Return-Path: <linux-kernel-owner+w=401wt.eu-S965793AbXDGMKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793AbXDGMKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 08:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965795AbXDGMKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 08:10:12 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:60884 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965793AbXDGMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 08:10:10 -0400
Message-ID: <461789CF.8000106@cosmosbay.com>
Date: Sat, 07 Apr 2007 14:08:47 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Vasily Averin <vvs@sw.ru>
CC: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH nf-2.6.22] [netfilter] early_drop imrovement
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru> <4616626C.9020100@trash.net> <4617845F.7080203@sw.ru>
In-Reply-To: <4617845F.7080203@sw.ru>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 07 Apr 2007 14:08:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Averin a e'crit :
> When the number of conntracks is reached nf_conntrack_max limit, early_drop() is
> called and tries to free one of already used conntracks in one of the hash
> buckets. If it does not find any conntracks that may be freed, it
> leads to transmission errors.
> However it is not fair because of current hash bucket may be empty but the
> neighbour ones can have the number of conntracks that can be freed. On the other
> hand the number of checked conntracks is not limited and it can cause a long delay.
> The following patch limits the number of checked conntracks by average number of
> conntracks in one hash bucket and allows to search conntracks in other hash buckets.

Hi Vasily

> 
>  			atomic_inc(&ct->ct_general.use);
>  			break;
>  		}
> +		if (!--(*cnt)) {
> +			dropped = 1;
> +			break;
> +		}


> +	cnt = (nf_conntrack_max/nf_conntrack_htable_size) + 1;

I am sorry but this wont help in the case you mentioned in an earlier mail :

If nf_conntrack_max  < nf_conntrack_htable_size, cnt will be set to 1.

Then in __early_drop() you endup in breaking the list_for_each_entry_reverse() 
loop after the first element was tested ! Not what you intended I'm afraid, 
because you wont event scan the whole chain as before your patch :(

I believe you should not test --cnt in __early_drop() but in the caller.

(That is not counting the number of found cells, but the number of hash chains 
you tried)


