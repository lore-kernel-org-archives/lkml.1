Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZF3VG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZF3VG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZF3VFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:05:47 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35359 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758065AbZF3VFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:05:46 -0400
Date: Tue, 30 Jun 2009 17:05:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>  <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net>  <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>  <84144f020906292355o7cf63f7ch47bd19961cf92da3@mail.gmail.com>
 <alpine.DEB.1.10.0906301030260.6124@gentwo.org> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org> <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, David Rientjes wrote:

> I don't see how that's different from enabling debugging on all caches
> like CONFIG_SLAB_DEBUG_ON currently does and then warning at the time of
> slab allocation failure that it may be the result of the debugging
> metadata so the user can subsequently prevent it.  In other words, if we
> use MAX_DEBUG_SIZE as Pekka originally implemented as
> (3 * sizeof(void *) + 2 * sizeof(struct track)), do this:

I like it.

> diff --git a/mm/slub.c b/mm/slub.c
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -142,6 +142,11 @@
>  				SLAB_POISON | SLAB_STORE_USER)
>
>  /*
> + * The maximum amount of metadata added to a slab when debugging is enabled.
> + */
> +#define MAX_DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
> +
> +/*
>   * Set of flags that will prevent slab merging
>   */
>  #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> @@ -1561,6 +1566,21 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
>  		"default order: %d, min order: %d\n", s->name, s->objsize,
>  		s->size, oo_order(s->oo), oo_order(s->min));
>
> +	if (s->flags & (SLAB_POISON | SLAB_RED_ZONE | SLAB_STORE_USER)) {
> +		int min_order;
> +
> +		/*
> +		 * Debugging is enabled, which may increase oo_order(s->min), so
> +		 * warn the user that allocation failures may be avoided if
> +		 * debugging is enabled for this cache.
> +		 */
> +		min_order = get_order(s->size - MAX_DEBUG_SIZE);
> +		if (min_order < oo_order(s->min))
> +			printk(KERN_WARNING "  %s debugging increased min order "
> +			       "from %d to %d, use slab_debug=-,%s to disable.",
> +			       s->name, min_order, oo_order(s->min), s->name);

It may be easier to check the order of the initial size vs. the order of
the size with all metadata

if (get_order(s->size) > get_order(s->objsize)

