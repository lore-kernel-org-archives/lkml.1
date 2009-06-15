Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZFOO4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZFOO4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZFOO4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:56:06 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59403 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083AbZFOO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:56:05 -0400
Date: Mon, 15 Jun 2009 10:55:47 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
Message-ID: <alpine.DEB.1.10.0906151051240.19931@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906121317140.23840@gentwo.org> <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Pekka J Enberg wrote:

> How about something like this? There should be no extra code in fastpaths
> for production configs with this one.

Yes something like that would be good. More comments below.

> index 4d6004c..5e8cea1 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1613,6 +1613,8 @@ another_slab:
>  	deactivate_slab(s, c);
>
>  new_slab:
> +	gfpflags &= slab_gfp_mask;
> +

Move the processing of GFP_RECLAIM_MASK etc up to here from new_slab? Then
the flow is also more logical. The flags handling is concentrated in one
spot in the allocator and its more obvious how we handle gfp flags.

> @@ -1668,13 +1670,14 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
>  	struct kmem_cache_cpu *c;
>  	unsigned long flags;
>  	unsigned int objsize;
> +	gfp_t real_gfp;
>
> -	gfpflags &= slab_gfp_mask;
> +	real_gfp = gfpflags & slab_gfp_mask;
>
> -	lockdep_trace_alloc(gfpflags);
> -	might_sleep_if(gfpflags & __GFP_WAIT);
> +	lockdep_trace_alloc(real_gfp);
> +	might_sleep_if(real_gfp & __GFP_WAIT);
>
> -	if (should_failslab(s->objsize, gfpflags))
> +	if (should_failslab(s->objsize, real_gfp))
>  		return NULL;
>
>  	local_irq_save(flags);

Dont do it there. Only modify the slow path.

Look at __might_sleep(). It already has an exception for system_state !=
RUNNING. If it still triggers then add to the condition there.


