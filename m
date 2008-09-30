Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYI3QVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYI3QVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYI3QVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:21:05 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:46343 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842AbYI3QVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:21:04 -0400
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg <penberg@cs.helsinki.fi>, mpm <mpm@selenic.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48E2480A.9090003@linux-foundation.org>
References: <1222787736.2995.24.camel@castor.localdomain>
	 <48E2480A.9090003@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 17:20:38 +0100
Message-Id: <1222791638.2995.41.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 10:38 -0500, Christoph Lameter wrote:
> Richard Kennedy wrote:
> > reduce the total stack usage of slab_err & object_err.
> > 
> > Introduce a new function to display a simple slab bug message, and call
> > this when vprintk is not needed.
> 
> You could simply get rid of the 100 byte buffer by using vprintk? Same method
> could be used elsewhere in the kernel and does not require additional
> functions. Compiles, untestted.
> 
> 
> 
> 
> Subject: Slub reduce slab_bug stack usage by using vprintk
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2008-09-30 10:34:40.000000000 -0500
> +++ linux-2.6/mm/slub.c	2008-09-30 10:36:10.000000000 -0500
> @@ -422,15 +422,14 @@
>  static void slab_bug(struct kmem_cache *s, char *fmt, ...)
>  {
>  	va_list args;
> -	char buf[100];
> 
>  	va_start(args, fmt);
> -	vsnprintf(buf, sizeof(buf), fmt, args);
> -	va_end(args);
>  	printk(KERN_ERR "========================================"
>  			"=====================================\n");
> -	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
> -	printk(KERN_ERR "----------------------------------------"
> +	printk(KERN_ERR "BUG %s: ", s->name);
> +	vprintk(fmt, args);
> +	va_end(args);
> +	printk(KERN_ERR "\n----------------------------------------"
>  			"-------------------------------------\n\n");
>  }
> 
Yes, using vprintk is better but you still have this path :
( with your patch applied)

	object_err -> slab_bug(208) -> printk(216)
instead of 
	object_err -> slab_bug_message(8) -> printk(216)

unfortunately the overhead for having var_args is pretty big, at least
on x86_64. I haven't measured it on 32 bit yet.

Richard


