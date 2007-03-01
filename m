Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXCABsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXCABsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932965AbXCABsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:48:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44428
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932968AbXCABsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:48:14 -0500
Date: Wed, 28 Feb 2007 17:48:12 -0800 (PST)
Message-Id: <20070228.174812.25474757.davem@davemloft.net>
To: clameter@engr.sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] SLUB The unqueued slab allocator V3
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0702281656450.1488@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702281120110.27828@schroedinger.engr.sgi.com>
	<20070228.140022.74750199.davem@davemloft.net>
	<Pine.LNX.4.64.0702281656450.1488@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@engr.sgi.com>
Date: Wed, 28 Feb 2007 17:06:19 -0800 (PST)

> On Wed, 28 Feb 2007, David Miller wrote:
> 
> > Arguably SLAB_HWCACHE_ALIGN and SLAB_MUST_HWCACHE_ALIGN should
> > not be set here, but SLUBs change in semantics in this area
> > could cause similar grief in other areas, an audit is probably
> > in order.
> > 
> > The above example was from sparc64, but x86 does the same thing
> > as probably do other platforms which use SLAB for pagetables.
> 
> Maybe this will address these concerns?
> 
> Index: linux-2.6.21-rc2/mm/slub.c
> ===================================================================
> --- linux-2.6.21-rc2.orig/mm/slub.c	2007-02-28 16:54:23.000000000 -0800
> +++ linux-2.6.21-rc2/mm/slub.c	2007-02-28 17:03:54.000000000 -0800
> @@ -1229,8 +1229,10 @@ static int calculate_order(int size)
>  static unsigned long calculate_alignment(unsigned long flags,
>  		unsigned long align)
>  {
> -	if (flags & (SLAB_MUST_HWCACHE_ALIGN|SLAB_HWCACHE_ALIGN))
> +	if (flags & SLAB_HWCACHE_ALIGN)
>  		return L1_CACHE_BYTES;
> +	if (flags & SLAB_MUST_HWCACHE_ALIGN)
> +		return max(align, (unsigned long)L1_CACHE_BYTES);
>  
>  	if (align < ARCH_SLAB_MINALIGN)
>  		return ARCH_SLAB_MINALIGN;

It would achiever parity with existing SLAB behavior, sure.
