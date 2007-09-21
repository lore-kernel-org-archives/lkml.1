Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXIUHRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXIUHRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 03:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXIUHQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 03:16:56 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:16936 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbXIUHQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 03:16:55 -0400
Date: Fri, 21 Sep 2007 11:16:41 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten (sysfs?)
Message-ID: <20070921071641.GA30924@localhost.sw.ru>
References: <20070919123907.GA15591@localhost.sw.ru> <20070919125918.GA6760@localhost.sw.ru> <20070919123954.fb552e80.akpm@linux-foundation.org> <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0709191432200.3111@schroedinger.engr.sgi.com> <20070920075353.GA6781@localhost.sw.ru> <20070920103229.GB6781@localhost.sw.ru> <Pine.LNX.4.64.0709201026520.8283@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709201026520.8283@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 10:36:13AM -0700, Christoph Lameter wrote:
> On Thu, 20 Sep 2007, Alexey Dobriyan wrote:
> > The winner is slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
> > Blind bisecting pointed to it and reverting the patch from full -mm makes
> > the problem go away
> 
> Hmmm.. This means likely that the c->node is used somewhere for 
> indexing.... Ahhh... If we count objects for sysfs output then c->node may 
> be used to index into the statistics array. The offset from the poison 
> also makes sense now since we increment values there.
> 
> Does this patch fix the issue?

Yes, it does.

> SLUB: Fix slab object counting.
> 
> We can only use the node value of the per cpu structure for counting if it 
> is positive. A negative value indicates that the slab is not valid.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  mm/slub.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.23-rc6-mm1/mm/slub.c
> ===================================================================
> --- linux-2.6.23-rc6-mm1.orig/mm/slub.c	2007-09-20 10:31:04.000000000 -0700
> +++ linux-2.6.23-rc6-mm1/mm/slub.c	2007-09-20 10:32:19.000000000 -0700
> @@ -3412,12 +3412,16 @@ static unsigned long slab_objects(struct
>  
>  	for_each_possible_cpu(cpu) {
>  		struct page *page;
> +		int node;
>  		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
>  
>  		if (!c)
>  			continue;
>  
>  		page = c->page;
> +		node = c->node;
> +		if (node < 0)
> +			continue;
>  		if (page) {
>  			if (flags & SO_CPU) {
>  				int x = 0;
> @@ -3427,9 +3431,9 @@ static unsigned long slab_objects(struct
>  				else
>  					x = 1;
>  				total += x;
> -				nodes[c->node] += x;
> +				nodes[node] += x;
>  			}
> -			per_cpu[c->node]++;
> +			per_cpu[node]++;
>  		}
>  	}
>  

