Return-Path: <linux-kernel-owner+w=401wt.eu-S1750701AbXBSI6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750701AbXBSI6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 03:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXBSI6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 03:58:11 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51567 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbXBSI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 03:58:10 -0500
Date: Mon, 19 Feb 2007 10:58:08 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mcr@sandelman.ca,
       clameter@sgi.com
Subject: Re: [PATCH] slab: ensure cache_alloc_refill terminates
In-Reply-To: <20070219174814.ec942249.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0702191051060.3230@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0702191020490.2085@sbz-30.cs.Helsinki.FI>
 <20070219174814.ec942249.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, KAMEZAWA Hiroyuki wrote:
> From my experience, this infinite loop in cache_alloc_refill() is caused by 
> double-free, always...(I'm sorry if my knowledge around the slab is too old.)

Well, I don't know what exactly caused slabp->inuse (could be cachep->num 
too, although sounds unlikely) to corrupt for Michael. But yeah, freeing 
an object twice obviously corrupts slabp->inuse too.

On Mon, 19 Feb 2007, KAMEZAWA Hiroyuki wrote:
> And it looks this additional check can caught the problem but maybe no help for
> fixing problem...How about adding printk like this ?
> ==
> if (unlikely(slabp->inuse >= cachep->num)) {
> 	printk("A problem is detected on slab %s\n", cachep->name);//this information is useful.
> 	printk("please use DEBUG_SLAB kernel for detecting what happens.");
> 	BUG(); 
> }

I don't think cachep->name is enough to debug the problem and as soon as 
you turn on CONFIG_SLAB_DEBUG double-frees should show up in 
verify_redzone_free with nice debugging info. So, I'd prefer we keep the 
simple BUG_ON and simply ask people to turn on debugging if they hit it.

				Pekka
