Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbYBSHkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbYBSHkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbYBSHki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:40:38 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:59677
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759875AbYBSHkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:40:36 -0500
Message-ID: <47BA87F0.1050709@cosmosbay.com>
Date: Tue, 19 Feb 2008 08:40:32 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Valdis.Kletnieks@vt.edu, David Miller <davem@davemloft.net>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: tbench regression in 2.6.25-rc1
References: <47B52B95.3070607@cosmosbay.com>	 <1203057044.3027.134.camel@ymzhang> <47B59FFC.4030603@cosmosbay.com>	 <20080215.152200.145584182.davem@davemloft.net>	 <1203322358.3027.200.camel@ymzhang>	 <20040.1203356033@turing-police.cc.vt.edu> <1203403903.3248.29.camel@ymzhang>
In-Reply-To: <1203403903.3248.29.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin a écrit :
> On Mon, 2008-02-18 at 12:33 -0500, Valdis.Kletnieks@vt.edu wrote: 
>> On Mon, 18 Feb 2008 16:12:38 +0800, "Zhang, Yanmin" said:
>>
>>> I also think __refcnt is the key. I did a new testing by adding 2 unsigned long
>>> pading before lastuse, so the 3 members are moved to next cache line. The performance is
>>> recovered.
>>>
>>> How about below patch? Almost all performance is recovered with the new patch.
>>>
>>> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
>> Could you add a comment someplace that says "refcnt wants to be on a different
>> cache line from input/output/ops or performance tanks badly", to warn some
>> future kernel hacker who starts adding new fields to the structure?
> Ok. Below is the new patch.
> 
> 1) Move tclassid under ops in case CONFIG_NET_CLS_ROUTE=y. So sizeof(dst_entry)=200
> no matter if CONFIG_NET_CLS_ROUTE=y/n. I tested many patches on my 16-core tigerton by
> moving tclassid to different place. It looks like tclassid could also have impact on
> performance.
> If moving tclassid before metrics, or just don't move tclassid, the performance isn't
> good. So I move it behind metrics.
> 
> 2) Add comments before __refcnt.
> 
> If CONFIG_NET_CLS_ROUTE=y, the result with below patch is about 18% better than
> the one without the patch.
> 
> If CONFIG_NET_CLS_ROUTE=n, the result with below patch is about 30% better than
> the one without the patch.
> 
> Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> ---
> 
> --- linux-2.6.25-rc1/include/net/dst.h	2008-02-21 14:33:43.000000000 +0800
> +++ linux-2.6.25-rc1_work/include/net/dst.h	2008-02-22 12:52:19.000000000 +0800
> @@ -52,15 +52,10 @@ struct dst_entry
>  	unsigned short		header_len;	/* more space at head required */
>  	unsigned short		trailer_len;	/* space to reserve at tail */
>  
> -	u32			metrics[RTAX_MAX];
> -	struct dst_entry	*path;
> -
> -	unsigned long		rate_last;	/* rate limiting for ICMP */
>  	unsigned int		rate_tokens;
> +	unsigned long		rate_last;	/* rate limiting for ICMP */
>  
> -#ifdef CONFIG_NET_CLS_ROUTE
> -	__u32			tclassid;
> -#endif
> +	struct dst_entry	*path;
>  
>  	struct neighbour	*neighbour;
>  	struct hh_cache		*hh;
> @@ -70,10 +65,20 @@ struct dst_entry
>  	int			(*output)(struct sk_buff*);
>  
>  	struct  dst_ops	        *ops;
> -		
> -	unsigned long		lastuse;
> +
> +	u32			metrics[RTAX_MAX];
> +
> +#ifdef CONFIG_NET_CLS_ROUTE
> +	__u32			tclassid;
> +#endif
> +
> +	/*
> +	 * __refcnt wants to be on a different cache line from
> +	 * input/output/ops or performance tanks badly
> +	 */
>  	atomic_t		__refcnt;	/* client references	*/
>  	int			__use;
> +	unsigned long		lastuse;
>  	union {
>  		struct dst_entry *next;
>  		struct rtable    *rt_next;
> 
> 
> 

I prefer this patch, but unfortunatly your perf numbers are for 64 bits kernels.

Could you please test now with 32 bits one ?

Thank you
