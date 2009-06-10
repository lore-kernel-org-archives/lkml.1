Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbZFJPti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbZFJPti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZFJPt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:49:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54783 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZFJPt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:49:27 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de,
       yanmin.zhang@linux.intel.com
In-Reply-To: <1244648659.23799.26.camel@penberg-laptop>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
	 <1244534315.5024.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
	 <1244536124.5024.41.camel@penberg-laptop>  <4A2FC62C.6030407@lwfinger.net>
	 <1244648659.23799.26.camel@penberg-laptop>
Date: Wed, 10 Jun 2009 18:49:28 +0300
Message-Id: <1244648968.23799.27.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 18:44 +0300, Pekka Enberg wrote:

> Aha, SLUB thinks the minimum order for 4096 is 1. I guess you have
> CONFIG_SLUB_DEBUG enabled? If yes, something like to following should
> help. Christoph, are you okay with this patch?
> 
> 			Pekka
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 65ffda5..2c93c30 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2334,6 +2334,8 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
>  
>  }
>  
> +#define MAX_DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
> +
>  static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
>  		const char *name, size_t size,
>  		size_t align, unsigned long flags,
> @@ -2346,6 +2348,9 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
>  	s->align = align;
>  	s->flags = kmem_cache_flags(size, flags, name, ctor);
>  
> +	if ((size + MAX_DEBUG_SIZE) >= PAGE_SIZE)
> +		flags &= ~(SLAB_POISON|SLAB_RED_ZONE|SLAB_STORE_USER);
> +
>  	if (!calculate_sizes(s, -1))
>  		goto error;
>  
> 
Argh, that patch has a typo. Please try this one instead.

			Pekka

diff --git a/mm/slub.c b/mm/slub.c
index 65ffda5..cb0473c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2334,6 +2334,8 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 }
 
+#define MAX_DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
+
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
@@ -2346,6 +2348,9 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	s->align = align;
 	s->flags = kmem_cache_flags(size, flags, name, ctor);
 
+	if ((size + MAX_DEBUG_SIZE) >= PAGE_SIZE)
+		s->flags &= ~(SLAB_POISON|SLAB_RED_ZONE|SLAB_STORE_USER);
+
 	if (!calculate_sizes(s, -1))
 		goto error;
 


