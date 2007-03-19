Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXCSVK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXCSVK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXCSVK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:10:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbXCSVKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:10:55 -0400
Date: Mon, 19 Mar 2007 14:10:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, ast@domdv.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-Id: <20070319141038.212d4ac9.akpm@linux-foundation.org>
In-Reply-To: <20070319204945.GJ10459@waste.org>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
	<Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com>
	<20070319204945.GJ10459@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 15:49:46 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Mon, Mar 19, 2007 at 10:08:03AM -0700, Christoph Lameter wrote:
> > On Mon, 19 Mar 2007, Pekka J Enberg wrote:
> > 
> > > This changes kmem_cache_free() to deal with NULL objects passed to it. The 
> > > current behavior is inconsistent with kfree() so there are callers 
> > > passing NULL to kmem_cache_free().
> > 
> > Hmmm.. kmem_cache_free is significantly different. One also needs to 
> > specify the slab cache.
> 
> I think this sort of thing should work:
> 
> a = kmalloc(...)
> b = kmem_cache_alloc(..)
> c = allocate_some_id(...)
> if (!a || !b || !c) {
>    free_some_id(c)
>    kmem_cache_free(c)
>    kfree(a);
>    return -ENOMEM;
> }

Would prefer to do:

static inline void kmem_cache_free_if_not_null(struct kmem_cache *cachep,
						void *objp)
{
	if (objp)
		kmem_cache_free(cachep, objp);
}

so that we don't add extra overhead to all the thousands of existing,
well-behaved callsites.

