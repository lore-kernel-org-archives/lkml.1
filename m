Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYDKXNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYDKXNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYDKXNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:13:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28482 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282AbYDKXNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=D53bFTm4fGaZn7gw+Vdug4+a6YzlJtw23C8nbohdReNjy2VsTWjYaEJSGMg5Ms3H6Z1IMxMwnpgmBLOLQxl1Zoosk7k4fl7l3aBVFdAbJ8BmF+66qOdX8MB+941n2ECMDWvXwNq7EAj+mCQCR6O7c1+C6n+r6ixV/qnW2o1kG6U=
Date: Sat, 12 Apr 2008 03:09:11 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: 2.6.25-rc8-mm2: boot hang after "ACPI: using IOAPIC for
	interrupt routing"
Message-ID: <20080411230911.GA4733@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org> <20080411062928.GB4748@martell.zuzino.mipt.ru> <1207910128.7212.4.camel@haji> <20080411210715.GA4851@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0804120024470.18799@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804120024470.18799@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 12:25:21AM +0300, Pekka J Enberg wrote:
> On Sat, 12 Apr 2008, Alexey Dobriyan wrote:
> > > Alexey, can you try passing the 'slub_nomerge' option to the kernel to
> > > see if the hang goes away with that?
> > 
> > nomerge doesn't help as well as turning on combinations of SLUB debug options.
> 
> Does the following patch fix it?
> 
> 			Pekka
> 
> From 7c7e7e5e7ec07c0a47705b2d21c779c39ba02252 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> Date: Fri, 11 Apr 2008 17:17:43 +0300
> Subject: [PATCH] slub: add missing slab_unlock() to __kmem_cache_shrink()
> 
> If page is not kickable, remember to slab_unlock() before continuing the loop.
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slub.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4b694a7..f09f1fb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2926,8 +2926,10 @@ static unsigned long __kmem_cache_shrink(struct kmem_cache *s, int node,
>  			continue;
>  
>  		if (page->inuse) {
> -			if (!SlabKickable(page))
> +			if (!SlabKickable(page)) {
> +				slab_unlock(page);
>  				continue;
> +			}

Yes, it helps. Now I have some more bugs to report. :-(

