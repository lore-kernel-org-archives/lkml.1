Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYE3GI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYE3GI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbYE3GIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:08:14 -0400
Received: from ozlabs.org ([203.10.76.45]:42288 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbYE3GII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:08:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 03/41] cpu alloc: Use cpu allocator instead of the builtin modules per cpu allocator
Date: Fri, 30 May 2008 16:08:01 +1000
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.451400376@sgi.com>
In-Reply-To: <20080530040011.451400376@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805301608.01584.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 May 2008 13:56:23 Christoph Lameter wrote:
> --- linux-2.6.orig/kernel/module.c	2008-05-29 17:57:39.825214766 -0700
> +++ linux-2.6/kernel/module.c	2008-05-29 18:00:50.496815514 -0700
> @@ -314,121 +314,6 @@ static struct module *find_module(const
>  	return NULL;
>  }

115 lines removed... This is my favourite part of the series so far :)

>  	if (mod->percpu)
> -		percpu_modfree(mod->percpu);
> +		cpu_free(mod->percpu, mod->percpu_size);

Hmm, does cpu_free(NULL, 0) do something?  Seems like it shouldn't, for 
symmetry with free().

> +		if (align > PAGE_SIZE) {
> +			printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> +			mod->name, align, PAGE_SIZE);
> +			align = PAGE_SIZE;
> +		}
> +		percpu = cpu_alloc(size, GFP_KERNEL|__GFP_ZERO, align);
> +		if (!percpu)
> +			printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
> +										size);
>  		if (!percpu) {
>  			err = -ENOMEM;
>  			goto free_mod;

OK, we've *never* had a report of the per-cpu alignment message, so I'd be 
happy to pass that through to cpu_alloc() and have it fail.  Also, the if 
(!percpu) cases should be combined.

>   free_percpu:
>  	if (percpu)
> -		percpu_modfree(percpu);
> +		cpu_free(percpu, percpu_size);

As above.

> +	goal = __per_cpu_size;

Where did __per_cpu_size come from?  I missed it in the earlier patches...

Thanks,
Rusty.
