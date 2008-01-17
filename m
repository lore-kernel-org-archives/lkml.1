Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYAQSMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYAQSMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYAQSMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:12:15 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:34813 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYAQSMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:12:14 -0500
Date: Thu, 17 Jan 2008 19:12:22 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
Message-ID: <20080117181222.GA24411@aepfle.de>
References: <20080115150949.GA14089@aepfle.de> <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com> <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, Christoph Lameter wrote:

> On Thu, 17 Jan 2008, Pekka Enberg wrote:
> 
> > Looks similar to the one discussed on linux-mm ("[BUG] at
> > mm/slab.c:3320" thread). Christoph?
> 
> Right. Try the latest version of the patch to fix it:

The patch does not help.
 
> Index: linux-2.6/mm/slab.c
> ===================================================================
> --- linux-2.6.orig/mm/slab.c	2008-01-03 12:26:42.000000000 -0800
> +++ linux-2.6/mm/slab.c	2008-01-09 15:59:49.000000000 -0800
> @@ -2977,7 +2977,10 @@ retry:
>  	}
>  	l3 = cachep->nodelists[node];
>  
> -	BUG_ON(ac->avail > 0 || !l3);
> +	if (!l3)
> +		return NULL;
> +
> +	BUG_ON(ac->avail > 0);
>  	spin_lock(&l3->list_lock);
>  
>  	/* See if we can refill from the shared array */

Is this hunk supposed to go into cache_grow()? There is no NULL check
for l3.

But if I do that, it does not help:

freeing bootmem node 1
Memory: 3496632k/3571712k available (6188k kernel code, 75080k reserved, 1324k data, 1220k bss, 304k init)
cache_grow(2781) swapper(0):c0,j4294937299 cp c0000000006a4fb8 !l3
Kernel panic - not syncing: kmem_cache_create(): failed to create slab `size-32'

Rebooting in 1 seconds..    

