Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZFOKUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZFOKUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZFOKUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:20:05 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:33406 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbZFOKUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:20:03 -0400
Date: Mon, 15 Jun 2009 12:20:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <npiggin@suse.de>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615102004.GB5411@osiris.boeblingen.de.ibm.com>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <20090615082636.GA30964@wotan.suse.de> <1245054779.23207.6.camel@penberg-laptop> <20090615085209.GB30964@wotan.suse.de> <1245056919.23207.7.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245056919.23207.7.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ---
> >  mm/slub.c |   17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6/mm/slub.c
> > ===================================================================
> > --- linux-2.6.orig/mm/slub.c
> > +++ linux-2.6/mm/slub.c
> > @@ -2596,6 +2596,7 @@ static noinline struct kmem_cache *dma_k
> >  	struct kmem_cache *s;
> >  	char *text;
> >  	size_t realsize;
> > +	unsigned long slabflags;
> >  
> >  	s = kmalloc_caches_dma[index];
> >  	if (s)
> > @@ -2617,9 +2618,18 @@ static noinline struct kmem_cache *dma_k
> >  			 (unsigned int)realsize);
> >  	s = kmalloc(kmem_size, flags & ~SLUB_DMA);
> >  
> > +	/*
> > +	 * Must defer sysfs creation to a workqueue because we don't know
> > +	 * what context we are called from. Before sysfs comes up, we don't
> > +	 * need to do anything because slab_sysfs_init will start by
> > +	 * adding all existing slabs to sysfs.
> > +	 */
> > +	slabflags = SLAB_CACHE_DMA;
> > +	if (slab_state >= SYSFS)
> > +		slabflags |= __SYSFS_ADD_DEFERRED;
> > +
> >  	if (!s || !text || !kmem_cache_open(s, flags, text,
> > -			realsize, ARCH_KMALLOC_MINALIGN,
> > -			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
> > +			realsize, ARCH_KMALLOC_MINALIGN, slabflags, NULL)) {
> >  		kfree(s);
> >  		kfree(text);
> >  		goto unlock_out;
> > @@ -2628,7 +2638,8 @@ static noinline struct kmem_cache *dma_k
> >  	list_add(&s->list, &slab_caches);
> >  	kmalloc_caches_dma[index] = s;
> >  
> > -	schedule_work(&sysfs_add_work);
> > +	if (slab_state >= SYSFS)
> > +		schedule_work(&sysfs_add_work);
> >  
> >  unlock_out:
> >  	up_write(&slub_lock);
> 
> Looks good to me. Heiko, does it fix your case?

Yes, works fine. Thanks!

Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
