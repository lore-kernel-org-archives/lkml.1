Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYFBKQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYFBKQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYFBKQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:16:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYFBKQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:16:10 -0400
Date: Mon, 2 Jun 2008 12:15:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of
	__GFP_NORETRY
Message-ID: <20080602101547.GD7459@elte.hu>
References: <20080526234940.GA1376@xs4all.net> <20080527014720.6db68517.akpm@linux-foundation.org> <20080528024727.GB20824@one.firstfloor.org> <1211963485.28138.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211963485.28138.14.camel@localhost.localdomain>
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


* Miquel van Smoorenburg <mikevs@xs4all.net> wrote:

> Okay, so how about this then ?
> 
> --- linux-2.6.26-rc4.orig/arch/x86/kernel/pci-dma.c	2008-05-26 20:08:11.000000000 +0200
> +++ linux-2.6.26-rc4/arch/x86/kernel/pci-dma.c	2008-05-28 10:27:41.000000000 +0200
> @@ -397,9 +397,6 @@
>  	if (dev->dma_mask == NULL)
>  		return NULL;
>  
> -	/* Don't invoke OOM killer */
> -	gfp |= __GFP_NORETRY;
> -
>  #ifdef CONFIG_X86_64
>  	/* Why <=? Even when the mask is smaller than 4GB it is often
>  	   larger than 16MB and in this case we have a chance of
> @@ -410,7 +407,9 @@
>  #endif
>  
>   again:
> -	page = dma_alloc_pages(dev, gfp, get_order(size));
> +	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
> +	page = dma_alloc_pages(dev,
> +		(gfp & GFP_DMA) ? gfp | __GFP_NORETRY : gfp, get_order(size));
>  	if (page == NULL)
>  		return NULL;

applied to tip/pci-for-jesse for more testing. Thanks,

	Ingo
