Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbZCUQ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbZCUQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZCUQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:29:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbZCUQ3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:29:14 -0400
Date: Sat, 21 Mar 2009 17:28:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] futex: Dynamically size futexes hash table
Message-ID: <20090321162829.GF11183@elte.hu>
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com> <49C4D5A0.5020106@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C4D5A0.5020106@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> @@ -2016,7 +2021,28 @@ static int __init futex_init(void)
>  {
>  	u32 curval;
>  	int i;
> +#if !defined(CONFIG_BASE_SMALL)
> +#if defined(CONFIG_PROVE_LOCKING)
> +	unsigned int nb_slots = 256;
> +#else
> +	unsigned int nb_slots = roundup_pow_of_two(num_possible_cpus()) * 256;
> +#endif
> +	size_t sz;
>  
> +retry:
> +	sz = nb_slots * sizeof(struct futex_hash_bucket);
> +	if (sz > PAGE_SIZE)
> +		futex_queues = vmalloc(sz);
> +	else
> +		futex_queues = kmalloc(sz, GFP_KERNEL);
> +	if (!futex_queues) {
> +		nb_slots >>= 1;
> +		if (!nb_slots)
> +			panic("Could not allocate futex hash table");
> +		goto retry;
> +	}
> +	futex_hash_mask = nb_slots - 1;
> +#endif

no fundamental objections and the hash sizing problem is causing 
real problems and need to be fixed, but this code sequence is too 
ugly to live.

Is there really no big-hash-alloc framework in existence? I have 
some vague memories of networking having met such problems in the 
past - maybe they have some goodness there we could reuse 
shamelessly in the futex code?

	Ingo
