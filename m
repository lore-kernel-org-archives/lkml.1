Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZAJJQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZAJJQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZAJJQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:16:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbZAJJQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:16:26 -0500
Date: Sat, 10 Jan 2009 01:15:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dcm@acm.org, Nadia Derbey <Nadia.Derbey@bull.net>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
Message-Id: <20090110011557.9d94e111.akpm@linux-foundation.org>
In-Reply-To: <49686465.70501@s5r6.in-berlin.de>
References: <1231571060.3538.18.camel@localhost.localdomain>
	<49686465.70501@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 10:03:33 +0100 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> David Moore wrote:
> > From: David Moore <dcm@acm.org>
> > 
> > The idr_remove_all() function returns unused slabs to the kmem cache,
> > but needs to zero them first or else they will be uninitialized upon
> > next use.  This fixes crashes which have been observed in the firewire
> > subsystem.
> > 

hm.

> 
> > ---
> >  lib/idr.c |   16 +++++++++++++++-
> >  1 files changed, 15 insertions(+), 1 deletions(-)
> > 
> > diff --git a/lib/idr.c b/lib/idr.c
> > index 1c4f928..69c3455 100644
> > --- a/lib/idr.c
> > +++ b/lib/idr.c
> > @@ -65,6 +65,20 @@ static inline void free_layer(struct idr_layer *p)
> >  	call_rcu(&p->rcu_head, idr_layer_rcu_free);
> >  }
> >  
> > +static void idr_layer_rcu_free_zero(struct rcu_head *head)
> > +{
> > +	struct idr_layer *layer;
> > +
> > +	layer = container_of(head, struct idr_layer, rcu_head);
> > +	memset(layer, 0, sizeof(struct idr_layer));
> > +	kmem_cache_free(idr_layer_cache, layer);
> > +}
> > +
> > +static inline void free_layer_zero(struct idr_layer *p)
> > +{
> > +	call_rcu(&p->rcu_head, idr_layer_rcu_free_zero);
> > +}
> > +
> >  /* only called when idp->lock is held */
> >  static void __move_to_free_list(struct idr *idp, struct idr_layer *p)
> >  {
> > @@ -462,7 +476,7 @@ void idr_remove_all(struct idr *idp)
> >  		id += 1 << n;
> >  		while (n < fls(id)) {
> >  			if (p)
> > -				free_layer(p);
> > +				free_layer_zero(p);
> >  			n += IDR_BITS;
> >  			p = *--paa;
> >  		}
> 
> Nadia,
> 
> it appears as if post-2.6.26 commit
> cf481c20c476ad2c0febdace9ce23f5a4db19582 "idr: make idr_remove rcu-safe"
> was buggy as it removed a memset(...0...) from idr_remove_all() without
> any obvious replacement.  And this patch fixes it.  Is this correct?
> 
> This was observed by David in Fedora 2.6.27.* kernels and in 2.6.28, and
> I have it seen in vanilla 2.6.28 --- but only after I disabled some
> debug kconfig options.  The trigger for the bug is not the existing
> usage of idr in drivers/firewire/, but a new usage which is not yet in
> mainline.  More details:
> http://marc.info/?l=linux1394-devel&m=123140439522563
> 
> The symptom is that after a few destructions of idr trees (which involve
> idr_remove_all() of course), there appear spurious idr entries in
> subsequently newly created idr trees.  These spurious entries then crash
> the driver when it iterates over them.
> 
> Andrew,
> 
> the triggering code are feature additions which I vaguely hoped of still
> getting ready for pull before 2.6.29-rc1.  I see as my options now
>   - to queue up this lib/idr fix --- if reviewers like it --- together
>     with my drivers/firewire updates for a pull request very very soon,
>   - to send my firewire updates independently of this idr patch but
>     with a simple temporary workaround at the new idr using driver code,
>   - to wait with these firewire features for 2.6.30.
> It's about these updates:
> http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=shortlog;h=test

Are we sure that all the other callers of free_layer() are freeing
zeroed objects?

It would be cleaner, safer and quite possibly faster to remove the
constructor altogether and use kmem_cache_zalloc() to allocate new
objects.

