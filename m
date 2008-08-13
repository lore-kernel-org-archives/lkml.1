Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYHMORo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYHMORo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbYHMOQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:16:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45561 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbYHMOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:16:43 -0400
Subject: Re: No, really, stop trying to delete slab until you've finished
	making slub perform as well
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48986AC6.5030406@linux-foundation.org>
	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48A2DD2C.3090602@linux-foundation.org>
	 <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>
Date: Wed, 13 Aug 2008 17:16:22 +0300
Message-Id: <1218636982.7813.332.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 23:14 +0900, KOSAKI Motohiro wrote:
> >> :t-0000128               28739     128     1.3G  20984/20984/8  512 0  99   0 *
> >
> > Argh. Most slabs contain a single object. Probably due to the conflict resolution.
> 
> agreed with the issue exist in lock contention code.
> 
> 
> > The obvious fix is to avoid allocating another slab on conflict but how will
> > this impact performance?
> >
> >
> > Index: linux-2.6/mm/slub.c
> > ===================================================================
> > --- linux-2.6.orig/mm/slub.c    2008-08-13 08:06:00.000000000 -0500
> > +++ linux-2.6/mm/slub.c 2008-08-13 08:07:59.000000000 -0500
> > @@ -1253,13 +1253,11 @@
> >  static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
> >                                                        struct page *page)
> >  {
> > -       if (slab_trylock(page)) {
> > -               list_del(&page->lru);
> > -               n->nr_partial--;
> > -               __SetPageSlubFrozen(page);
> > -               return 1;
> > -       }
> > -       return 0;
> > +       slab_lock(page);
> > +       list_del(&page->lru);
> > +       n->nr_partial--;
> > +       __SetPageSlubFrozen(page);
> > +       return 1;
> >  }
> 
> I don't mesure it yet. I don't like this patch.
> maybe, it decrease other typical benchmark.
> 
> So, I think better way is
> 
> 1. slab_trylock(), if success goto 10.
> 2. check fragmentation ratio, if low goto 10
> 3. slab_lock()
> 10. return func
> 
> I think this way doesn't cause performance regression.
> because high fragmentation cause defrag and compaction lately.
> So, prevent fragmentation often increase performance.
> 
> Thought?

I guess that would work. But how exactly would you quantify
"fragmentation ratio?"

