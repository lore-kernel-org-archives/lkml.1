Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbXE3VsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbXE3VsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760292AbXE3Vq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:46:59 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760149AbXE3Vq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:46:57 -0400
Date: Wed, 30 May 2007 14:46:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 7/8] Scanner changes needed to implement per-container
 scanner
Message-Id: <20070530144647.0ace89f3.akpm@linux-foundation.org>
In-Reply-To: <465D9ABD.7050506@openvz.org>
References: <465D9739.8070209@openvz.org>
	<465D9ABD.7050506@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 19:39:41 +0400
Pavel Emelianov <xemul@openvz.org> wrote:

> The core change is that the isolate_lru_pages() call is
> replaced with struct scan_controll->isolate_pages() call.
> 
> Other changes include exporting __isolate_lru_page() for
> per-container isolator and handling variable-to-pointer
> changes in try_to_free_pages().
> 
> This makes possible to use different isolation routines
> for per-container page reclamation. This will be used by
> the following patch.
> 
> ...
>
> +struct rss_container;
> +extern unsigned long try_to_free_pages_in_container(struct rss_container *);
> +int __isolate_lru_page(struct page *page, int mode);


>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
>  extern int vm_swappiness;
>  extern int remove_mapping(struct address_space *mapping, struct page *page);
> diff -upr linux-2.6.22-rc2-mm1.orig/mm/vmscan.c linux-2.6.22-rc2-mm1-0/mm/vmscan.c
> --- linux-2.6.22-rc2-mm1.orig/mm/vmscan.c	2007-05-30 12:32:36.000000000 +0400
> +++ linux-2.6.22-rc2-mm1-0/mm/vmscan.c	2007-05-30 16:13:09.000000000 +0400
> @@ -47,6 +47,8 @@
>  
>  #include "internal.h"
>  
> +#include <linux/rss_container.h>
> +
>  struct scan_control {
>  	/* Incremented by the number of inactive pages that were scanned */
>  	unsigned long nr_scanned;
> @@ -70,6 +72,13 @@ struct scan_control {
>  	int all_unreclaimable;
>  
>  	int order;
> +
> +	struct rss_container *cnt;

Can we please have a better name?  "cnt" is usually a (poorly-chosen) name
for an integer counter.  Perhaps "container", or even "rss_container".

> +		nr_reclaimed += shrink_zones(priority, zones, sc);
> +		if (sc->cnt == NULL)
> +			shrink_slab(sc->nr_scanned, gfp_mask, lru_pages);

We don't we shrink slab if called to shrink a container.

This is a fundamental design decision, and a design shortcoming.  A full
discussion of this is absolutely appropriate to the patch changelog. 
Please don't just hide stuff like this in the patch and leave people
wondering, or ignorant.


