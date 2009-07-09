Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbZGIX1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbZGIX1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZGIX0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:26:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:46817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZGIX0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:26:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CYQk/5+saZr7xZdtmucOHrbVRgY/TABGY4rh//fmzDME9hHTgUHXNWgklSNz0Iko0
	wMyFV7ruKt4ifchIGnC3g==
Date: Thu, 9 Jul 2009 16:26:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch v2] slub: add option to disable higher order debugging
 slabs
In-Reply-To: <alpine.DEB.1.10.0907071150010.5124@gentwo.org>
Message-ID: <alpine.DEB.2.00.0907091620470.16817@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org> <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301722280.17682@gentwo.org> <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com> <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
 <alpine.DEB.2.00.0907021016380.30890@chino.kir.corp.google.com> <84144f020907030023v2d09632bt13b6c25f96c0b803@mail.gmail.com> <alpine.DEB.2.00.0907062252500.9699@chino.kir.corp.google.com> <alpine.DEB.2.00.0907070013400.14978@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0907071150010.5124@gentwo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Christoph Lameter wrote:

> > + * Debugging flags that require metadata to be stored in the slab, up to
> > + * DEBUG_SIZE in size.
> > + */
> > +#define DEBUG_SIZE_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
> > +#define DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
> 
> There is no need for DEBUG_SIZE since slub keeps both the size of the
> object kmem_cache->objsize and the size with the metadata kmem_cache->size
> 
> If the order of both is different then the order would increase.
> 

Without DEBUG_SIZE_FLAGS, the only way to determine what flags have 
increased the size is in calculate_sizes() and then disable them by 
default if slub_debug=O is specified.  calculate_sizes() is used by 
the `store', `poison', and `red_zone' callbacks, so the admin still has 
the ability to enable these options even though slub_debug=O was used.

So we can either mask off the size-increasing debug bits when the cache is 
created in kmem_cache_flags() like I did, or we can move the logic to 
calculate_sizes() with an added formal to determine whether this is from 
kmem_cache_open() or one of the attribute callbacks.

I think my solution is the cleanest and provides a single entity, 
DEBUG_SIZE_FLAGS, which specifies the flags that slub_debug=O clears if 
the minimum order increases.
