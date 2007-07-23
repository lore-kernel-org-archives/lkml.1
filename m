Return-Path: <linux-kernel-owner+w=401wt.eu-S936151AbXGWUsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936151AbXGWUsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761778AbXGWUsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:48:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759459AbXGWUsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:48:24 -0400
Date: Mon, 23 Jul 2007 13:47:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] fix slub krealloc()
Message-Id: <20070723134713.2b1218bd.akpm@linux-foundation.org>
In-Reply-To: <20070723133206.2220db7e@schroedinger.engr.sgi.com>
References: <1184773331.4002.4.camel@johannes.berg>
	<20070723133206.2220db7e@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 13:32:06 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 18 Jul 2007 17:42:11 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > Commit ef2ad80c7d255ed0449eda947c2d700635b7e0f5 breaks
> > krealloc(NULL, ...) badly, it BUG_ON()s.
> > 
> > This patch fixes it but the fix should probably be in mm/util.c
> > because the documentation says that krealloc(NULL, x, gfp) is
> > equivalent to kmalloc(x, gfp) and that's not true any more even after
> > this patch when you do krealloc(NULL, 0, gfp)
> 
> Right. We need to fix util.c. ksize should not be called with a NULL
> parameter.
> Index: linux-2.6/mm/util.c
> ===================================================================
> --- linux-2.6.orig/mm/util.c	2007-07-23 13:29:42.000000000 -0700
> +++ linux-2.6/mm/util.c	2007-07-23 13:31:28.000000000 -0700
> @@ -88,7 +88,11 @@ void *krealloc(const void *p, size_t new
>  		return ZERO_SIZE_PTR;
>  	}
>  
> -	ks = ksize(p);
> +	if (p)
> +		ks = ksize(p);
> +	else
> +		ks = 0;
> +
>  	if (ks >= new_size)
>  		return (void *)p;
>  

I think we already fixed this?

commit 1d4ec7b1d6f130818f9b62dea3411d9ee2ff6ff6
Author: Roland Dreier <rdreier@cisco.com>
Date:   Fri Jul 20 12:13:20 2007 -0700

    Fix ZERO_OR_NULL_PTR(ZERO_SIZE_PTR)
    
    The comparison with ZERO_SIZE_PTR in ZERO_OR_NULL_PTR() needs to be <=
    (not just <) so that ZERO_OR_NULL_PTR(ZERO_SIZE_PTR) is 1.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    [ Duh!  - Linus ]
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7d0ecc1..d859354 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -40,7 +40,7 @@ #define SLAB_TRACE		0x00200000UL	/* Trac
  */
 #define ZERO_SIZE_PTR ((void *)16)
 
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) < \
+#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)
 
 /*

