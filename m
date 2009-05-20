Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZETIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZETIeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZETIeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:34:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49532 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZETIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:34:05 -0400
Date: Wed, 20 May 2009 10:33:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: UV BAU activation descriptor init
Message-ID: <20090520083350.GE6736@elte.hu>
References: <E1M6YCG-0002eM-1Z@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M6YCG-0002eM-1Z@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> The UV tlb shootdown code has a serious initialization error.
> 
> An array of structures [32*8] is initialized as if it were [32].
> The array is indexed by (cpu number on the blade)*8, so the short
> initialization works for up to 4 cpus on a blade.
> But above that, we provide an invalid opcode to the hub's
> broadcast assist unit.
> 
> This patch changes the allocation of the array to use its symbolic
> dimensions for better clarity. And initializes all 32*8 entries.
> 
> Tested on the UV simulator.
> 
> Diffed against 2.6.30-rc6
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> 
> ---
>  arch/x86/kernel/tlb_uv.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/kernel/tlb_uv.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/tlb_uv.c
> +++ linux/arch/x86/kernel/tlb_uv.c
> @@ -715,7 +715,14 @@ uv_activation_descriptor_init(int node, 
>  	struct bau_desc *adp;
>  	struct bau_desc *ad2;
>  
> -	adp = (struct bau_desc *)kmalloc_node(16384, GFP_KERNEL, node);
> +	/*
> +	 * each bau_desc is 64 bytes; there are 8 (UV_ITEMS_PER_DESCRIPTOR)
> +	 * per cpu; and up to 32 (UV_ACTIVATION_DESCRIPTOR_SIZE) cpu's
> +	 * per blade
> +	 */
> +	adp = (struct bau_desc *)kmalloc_node(sizeof(struct bau_desc)*
> +		UV_ACTIVATION_DESCRIPTOR_SIZE*UV_ITEMS_PER_DESCRIPTOR,
> +		GFP_KERNEL, node);
>  	BUG_ON(!adp);
>  
>  	pa = uv_gpa(adp); /* need the real nasid*/
> @@ -729,7 +736,14 @@ uv_activation_descriptor_init(int node, 
>  				      (n << UV_DESC_BASE_PNODE_SHIFT | m));
>  	}
>  
> -	for (i = 0, ad2 = adp; i < UV_ACTIVATION_DESCRIPTOR_SIZE; i++, ad2++) {
> +	/*
> +	 * initializing all 8 (UV_ITEMS_PER_DESCRIPTOR) descriptors for each
> +	 * cpu even though we only use the first one; one descriptor can
> +	 * describe a broadcast to 256 nodes.
> +	 */
> +	for (i = 0, ad2 = adp;
> +		i < (UV_ACTIVATION_DESCRIPTOR_SIZE*UV_ITEMS_PER_DESCRIPTOR);
> +		i++, ad2++) {
>  		memset(ad2, 0, sizeof(struct bau_desc));
>  		ad2->header.sw_ack_flag = 1;
>  		/*

looks good but could you please define a shortcut for:

	UV_ACTIVATION_DESCRIPTOR_SIZE*UV_ITEMS_PER_DESCRIPTOR

because its length causes a lot of ugly linebreaks. Something like 
UV_ADP_SIZE should do the trick?

	Ingo
