Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbXDQPMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbXDQPMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbXDQPMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:12:16 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:47425 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbXDQPMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:12:15 -0400
Date: Tue, 17 Apr 2007 17:12:13 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Pavel Emelianov" <xemul@sw.ru>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       devel@openvz.org, "Kirill Korotaev" <dev@openvz.org>,
       linux-mm@kvack.org
Subject: Re: [PATCH] Show slab memory usage on OOM and SysRq-M
Message-Id: <20070417171213.e3cbc260.dada1@cosmosbay.com>
In-Reply-To: <84144f020704170622h2b16f0f6m47ffdbb3b5686758@mail.gmail.com>
References: <4624C3C1.9040709@sw.ru>
	<84144f020704170622h2b16f0f6m47ffdbb3b5686758@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 16:22:48 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi,
> 
> On 4/17/07, Pavel Emelianov <xemul@sw.ru> wrote:
> > +static unsigned long get_cache_size(struct kmem_cache *cachep)
> > +{
> > +       unsigned long slabs;
> > +       struct kmem_list3 *l3;
> > +       struct list_head *lh;
> > +       int node;
> > +
> > +       slabs = 0;
> > +
> > +       for_each_online_node (node) {
> > +               l3 = cachep->nodelists[node];
> > +               if (l3 == NULL)
> > +                       continue;
> > +
> > +               spin_lock(&l3->list_lock);
> > +               list_for_each (lh, &l3->slabs_full)
> > +                       slabs++;
> > +               list_for_each (lh, &l3->slabs_partial)
> > +                       slabs++;
> > +               list_for_each (lh, &l3->slabs_free)
> > +                       slabs++;
> > +               spin_unlock(&l3->list_lock);
> > +       }
> > +
> > +       return slabs * ((PAGE_SIZE << cachep->gfporder) +
> > +               (OFF_SLAB(cachep) ? cachep->slabp_cache->buffer_size : 0));
> > +}
> 
> Considering you're doing this at out_of_memory() time, wouldn't it
> make more sense to add a ->nr_pages to struct kmem_cache and do the
> tracking in kmem_getpages/kmem_freepages?
> 

To avoid a deadlock ? yes...

This nr_pages should be in struct kmem_list3, not in struct kmem_cache, or else you defeat NUMA optimizations if touching a field in kmem_cache at kmem_getpages()/kmem_freepages() time.

       for_each_online_node (node) {
               l3 = cachep->nodelists[node];
               if (l3)
                   slabs += l3->nr_pages; /* dont lock l3->list_lock */
       }
