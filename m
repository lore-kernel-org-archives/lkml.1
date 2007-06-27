Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbXF0N0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbXF0N0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbXF0N0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:26:06 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48462 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbXF0N0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:26:03 -0400
Message-ID: <46826566.2060304@sw.ru>
Date: Wed, 27 Jun 2007 17:25:58 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       "David S. Miller" <davem@davemloft.net>, devel@openvz.org
Subject: Re: [NETFILTER] early_drop() imrovement (v4)
References: <4615FE1D.80206@sw.ru>	<20070406102433.d3a670a5.dada1@cosmosbay.com>	<4616203A.80203@sw.ru> <4616626C.9020100@trash.net>	<4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com>	<46187770.1070106@sw.ru> <46417137.5080501@sw.ru>	<467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>	<468223D0.90305@sw.ru> <46822540.2010004@trash.net> <4682523F.6000002@trash.net> <4682582D.7080501@sw.ru> <46825D63.3060500@trash.net> <46825FE0.7060306@sw.ru> <4682638F.40507@trash.net>
In-Reply-To: <4682638F.40507@trash.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Vasily Averin wrote:
>> Patrick McHardy wrote:
> -static int early_drop(struct hlist_head *chain)
> +static int early_drop(unsigned int hash)
>  {
>  	/* Use oldest entry, which is roughly LRU */
>  	struct nf_conntrack_tuple_hash *h;
>  	struct nf_conn *ct = NULL, *tmp;
>  	struct hlist_node *n;
> -	int dropped = 0;
> +	unsigned int i;
> +	int dropped = 0, cnt = NF_CT_EVICTION_RANGE;
>  
>  	read_lock_bh(&nf_conntrack_lock);
> -	hlist_for_each_entry(h, n, chain, hnode) {
> -		tmp = nf_ct_tuplehash_to_ctrack(h);
> -		if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
> -			ct = tmp;
> +	for (i = 0; i < nf_conntrack_htable_size; i++) {
> +		hlist_for_each_entry(h, n, &nf_conntrack_hash[hash], hnode) {
> +			tmp = nf_ct_tuplehash_to_ctrack(h);
> +			if (!test_bit(IPS_ASSURED_BIT, &tmp->status))
> +				ct = tmp;

It is incorrect: you should break nested loop here too.

> +			if (--cnt <= 0)
> +				goto stop;
> +		}
> +		if (ct)
> +			break;
> +		hash = (hash + 1) & (nf_conntrack_htable_size - 1);
>  	}
> +stop:
>  	if (ct)
>  		atomic_inc(&ct->ct_general.use);
>  	read_unlock_bh(&nf_conntrack_lock);

