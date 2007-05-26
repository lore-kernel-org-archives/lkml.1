Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXEZCtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXEZCtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 22:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXEZCtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 22:49:32 -0400
Received: from web52606.mail.re2.yahoo.com ([206.190.48.209]:36858 "HELO
	web52606.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750821AbXEZCtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 22:49:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=DntptJGEIpsA3ha1qXPoFwDLI8m3DSJ6jMHlrmpXFG00s9hd3uRjwJQcAwOosHH8rgQ/myXERvR7NhG7WYVRTgBM1VqTr4x/4FLWGXkcqfbDGw05mg7gkTjV6gex2kB/0DKj8rufqIbodmo8ZMDCvDkyRAUyM0vK6kNtxgvpNjM=;
X-YMail-OSG: gZAe_lgVM1mPMtb5eKobz0GKtm565lDrmwqe2k8SWP5eoagi0AOv0u2LpfwFXONGjnXsMtoXkZ9AWlwHne8gMUY_DRoiGaJ7.Omwii95W8zfI0MOjFIq3Qtb1vRDZg--
Date: Sat, 26 May 2007 12:49:30 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705251850350.9013@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <95208.131.qm@web52606.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Christoph Lameter <clameter@sgi.com> wrote:
> I finally figured out the second issue. Took some time to get that figure 
> out. Sorry. But now all the bug reports make sense.

[...]

Impressive Christoph. Indeed, this fixes my problem on latest -git (its hg
equivalent :-)). Well done.

(Tested with CONFIG_SLAB_DEBUG without slub_debug; all was well. Then with
slub_debug & slabinfo -v also; again all was well. I had many LOCKDEP and its
relatives also compiled in.)

Now hoping it'll be in 2.6.22-rc3 :-)).

> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  mm/slub.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: slub/mm/slub.c
> ===================================================================
> --- slub.orig/mm/slub.c	2007-05-25 18:28:42.000000000 -0700
> +++ slub/mm/slub.c	2007-05-25 18:29:46.000000000 -0700
> @@ -2473,6 +2473,7 @@ void __init kmem_cache_init(void)
>  	 */
>  	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
>  		sizeof(struct kmem_cache_node), GFP_KERNEL);
> +	kmalloc_caches[0].refcount = -1;
>  #endif
>  
>  	/* Able to allocate the per node structures */
> @@ -2520,6 +2521,12 @@ static int slab_unmergeable(struct kmem_
>  	if (s->ctor)
>  		return 1;
>  
> +	/*
> +	 * We may have set a slab to be unmergeable during bootstrap.
> +	 */
> +	if (s->refcount < 0)
> +		return 1;
> +
>  	return 0;
>  }



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

