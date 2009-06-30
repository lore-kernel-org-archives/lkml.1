Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZF3VPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZF3VPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZF3VPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:15:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZF3VPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:15:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mstePixbDe8vEf77ckjiNdxkfb9nlS5UOFbfMpUVvkiktrWa71BxNjrvWLzLi8/LI
	2zQuBlCUgg7HbOc3YiWbQ==
Date: Tue, 30 Jun 2009 14:15:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
Message-ID: <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>  <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>  <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>  <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
 <alpine.DEB.1.10.0906301030260.6124@gentwo.org> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org> <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Christoph Lameter wrote:

> > diff --git a/mm/slub.c b/mm/slub.c
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -142,6 +142,11 @@
> >  				SLAB_POISON | SLAB_STORE_USER)
> >
> >  /*
> > + * The maximum amount of metadata added to a slab when debugging is enabled.
> > + */
> > +#define MAX_DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
> > +
> > +/*
> >   * Set of flags that will prevent slab merging
> >   */
> >  #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> > @@ -1561,6 +1566,21 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
> >  		"default order: %d, min order: %d\n", s->name, s->objsize,
> >  		s->size, oo_order(s->oo), oo_order(s->min));
> >
> > +	if (s->flags & (SLAB_POISON | SLAB_RED_ZONE | SLAB_STORE_USER)) {
> > +		int min_order;
> > +
> > +		/*
> > +		 * Debugging is enabled, which may increase oo_order(s->min), so
> > +		 * warn the user that allocation failures may be avoided if
> > +		 * debugging is enabled for this cache.
> > +		 */
> > +		min_order = get_order(s->size - MAX_DEBUG_SIZE);
> > +		if (min_order < oo_order(s->min))
> > +			printk(KERN_WARNING "  %s debugging increased min order "
> > +			       "from %d to %d, use slab_debug=-,%s to disable.",
> > +			       s->name, min_order, oo_order(s->min), s->name);
> 
> It may be easier to check the order of the initial size vs. the order of
> the size with all metadata
> 
> if (get_order(s->size) > get_order(s->objsize)
> 

Ah, right.  Then we could simply eliminate the check on s->flags to begin 
with.

This patch is supposing that `slab_debug=-,<cache>' actually disables all 
debugging for <cache> which would need to be implemented first, but I 
think this is a better alternative than requiring slab_debug=A for full 
debugging after enabling CONFIG_SLUB_DEBUG_ON.
