Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZALUkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZALUkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZALUk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:40:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZALUk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:40:26 -0500
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, dcm@acm.org,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <496B9FC7.3090108@colorfullife.com>
References: <1231571060.3538.18.camel@localhost.localdomain>
	 <49686465.70501@s5r6.in-berlin.de>
	 <20090110011557.9d94e111.akpm@linux-foundation.org>
	 <496872E0.9030007@s5r6.in-berlin.de>
	 <1231773620.6365.21.camel@gaara.bos.redhat.com>
	 <496B9FC7.3090108@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jan 2009 15:38:32 -0500
Message-Id: <1231792712.6365.31.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 20:53 +0100, Manfred Spraul wrote:
> Kristian Høgsberg wrote:
> >   The problem
> > isn't about returning un-zeroed-out objects to the kmem cache, the
> > problem is returning them to the idr free list.
> >   
> I think this is wrong:
> The slab allocator assumes that the objects that are given to 
> kmem_cache_free() are properly constructed.
> I.e.: No additional constructor is called prior to returning the object 
> from the next kmem_cache_alloc() call.

That's fine, the ctor associated with the kmem cache is called, and in
the case of idr, it does a memset().

> > Every idr use I've seen could just do the whole thing
> > under a mutex and not worry about the awkward retry idea.
> Unfortunately there are some users that do idr_get_new() within a spinlock.
> e.g. from drivers/gpu/drm/drm_gem.c:
> >         if (idr_pre_get(&file_priv->object_idr, GFP_KERNEL) == 0)
> >                 return -ENOMEM;
> >
> >         /* do the allocation under our spinlock */
> >         spin_lock(&file_priv->table_lock);
> >         ret = idr_get_new_above(&file_priv->object_idr, obj, 1, handlep);
> >         spin_unlock(&file_priv->table_lock);
> :-(

That's valid use of the idr interface, idr_get_new_above() won't block
or allocate, just return -EAGAIN if the idr_layer struct allocated by
idr_pre_get() got snatched up in between the two calls.  My complaint
was that in many cases you don't need to access the idr from interrupt
context and you can then just put the idr_pre_get() and
idr_get_new_above() under one big mutex.  Even so, many people just
copy-n-paste the boiler plate code that does the
idr_pre_get()/idr_get_new_above()/if(EAGAIN) goto retry sequence.

cheers,
Kristian

