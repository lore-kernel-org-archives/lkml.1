Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbXDFU0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbXDFU0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXDFU0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:26:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33380 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbXDFU0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:26:37 -0400
Date: Fri, 6 Apr 2007 13:26:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB: Add Kconfig option for SLAB quirks
Message-Id: <20070406132634.1f64d4a1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704061227170.11797@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704061227170.11797@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 12:53:22 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> This patch may allow to reduce the churn for SLUB. It adds a Kconfig
> option that makes SLUB replicate SLAB special handling for slab caches.
> 
> ... 
>
> Index: linux-2.6.21-rc5-mm4/init/Kconfig
> ===================================================================
> --- linux-2.6.21-rc5-mm4.orig/init/Kconfig	2007-04-06 12:12:59.000000000 -0700
> +++ linux-2.6.21-rc5-mm4/init/Kconfig	2007-04-06 12:21:44.000000000 -0700
> @@ -569,6 +569,32 @@ config SLUB
>  	   of queues of objects. SLUB can use memory efficiently
>  	   way and has enhanced diagnostics.
>  
> +config SLUB_SLAB_QUIRKS
> +	depends on SLUB
> +	bool "SLUB: Handle SLAB quirks"
> +	help
> +	  Make SLUB emulate various inconsistent behaviors of SLAB in order
> +	  to avoid having to fix these issues. Switching this on will make
> +	  debugging on some slabs impossible and may lead to a slight
> +	  performance degradation (one additional check in the hotpath).
> +
> +	  The issues addressed are
> +	  1. Page order slabs are always aligned on page boundaries
> +	     regardless of other alignment requirements. This also
> +	     affects the kmalloc array. Kmalloc slabs are usually aligned
> +	     to KMALLOC_MINALIGN. Now we make an exception for those of
> +	     page order. Debugging options are disabled if they would
> +	     misalign a cache.
> +
> +	  2. Page order slabs are handled in such a way that page->index
> +	     can be used for other purposes.
> +
> +	  3. PAGE_SIZE slabs are never increased beyond PAGE_SIZE.
> +	     Debugging is switched off in order to guarantee that.
> +	     This allows the use of page->private for other purposes.
> +	     All slab allocators use compound pages for higher order
> +	     allocations which would no longer allow the use of page->private.

urgh.  It would be better to continue to rework slab/slub callers in the
fashion which you have been doing, don't you think?



Rephrasing my earlier point: are we doing things in the correct order here,
and efficiently?  It is not settled in my mind whether we want to merge
slub _at all_.  Do we have enough information yet to be able to make that
decision?

And if that information indicates that a slub merge _is_ justified, why is
the chosen approach superior to the incremental one: if slab code is grotty
(it is), clean it up.  If slab has unnecessary stuff, delete it.

