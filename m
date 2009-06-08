Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZFHOMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZFHOMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZFHOMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:12:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34251 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbZFHOMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:12:13 -0400
Date: Mon, 8 Jun 2009 15:12:13 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Message-ID: <20090608141212.GE15070@csn.ul.ie>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com> <20090608101739.GA15377@csn.ul.ie> <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com> <20090608110303.GD15377@csn.ul.ie> <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 04:58:10PM +0300, Pekka J Enberg wrote:
> Hi Mel,
> 
> On Mon, 8 Jun 2009, Mel Gorman wrote:
> > Is there any chance you could hatchet together a patch
> > slab-allocation-failure that reports on slab allocation failures similar
> > to what the page allocator does? Minimally, it should tell us what
> > the size of the allocation was but any other information such as the
> > same of the slab, the size of pages it normally uses are, etc. would
> > also be useful.
> 
> Would something like this be sufficient? Figuring out the actual _size_ 
> passed to kmalloc() is pretty difficult as then we would need to do the 
> NULL test in fastpath code or pass the argument deeper in the call-chain.
> 

It's much better than nothing. In the event of an allocation failure, we'll
know which kmalloc bucket it's coming out of so we'll have a limited range
of possible buffer sizes.

I have some suggestions on what we're outputting though.

> 			Pekka
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 65ffda5..b5acf18 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1565,6 +1565,8 @@ new_slab:
>  		c->page = new;
>  		goto load_freelist;
>  	}
> +	printk(KERN_WARNING "SLUB: unable to satisfy allocation for cache %s (size=%d, node=%d, gfp=%x)\n",
> +		s->name, s->size, node, gfpflags);

size could be almost anything here for a casual reader. You are
outputting the size of the object plus its metadata so the name should
reflect that. I think it would be better to output objsize= and the
object size without the metadata overhead. What do you think?

In addition, include how many objects there are per-slab and include what
the order is being passed to the page allocator when allocating new slabs.
Would that be enough to determine if fallback-to-smaller orders occured?

>  	return NULL;
>  debug:
>  	if (!alloc_debug_processing(s, c->page, object, addr))
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
