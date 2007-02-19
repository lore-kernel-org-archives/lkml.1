Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXBSItg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXBSItg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 03:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbXBSItg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 03:49:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45258 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXBSItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 03:49:35 -0500
Date: Mon, 19 Feb 2007 17:48:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mcr@sandelman.ca,
       clameter@sgi.com
Subject: Re: [PATCH] slab: ensure cache_alloc_refill terminates
Message-Id: <20070219174814.ec942249.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0702191020490.2085@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0702191020490.2085@sbz-30.cs.Helsinki.FI>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007 10:22:52 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> @@ -2987,6 +2987,14 @@
>  		slabp = list_entry(entry, struct slab, list);
>  		check_slabp(cachep, slabp);
>  		check_spinlock_acquired(cachep);
> +
> +		/*
> +		 * The slab was either on partial or free list so
> +		 * there must be at least one object available for
> +		 * allocation.
> +		 */
> +		BUG_ON(slabp->inuse >= cachep->num);
> +
I welcome this patch. 

>From my experience, this infinite loop in cache_alloc_refill() is caused by 
double-free, always...(I'm sorry if my knowledge around the slab is too old.)

And it looks this additional check can caught the problem but maybe no help for
fixing problem...How about adding printk like this ?
==
if (unlikely(slabp->inuse >= cachep->num)) {
	printk("A problem is detected on slab %s\n", cachep->name);//this information is useful.
	printk("please use DEBUG_SLAB kernel for detecting what happens.");
	BUG(); 
}


-Kame

