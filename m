Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbZFIHzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbZFIHzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZFIHyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:54:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39998 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZFIHyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:54:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JnaHa2UyTGJAIudQod9TgkTZWTWgs0SE80A/WudHX+FK0KECf7WJ+ECJsF1Qahxeq
	LcESz3YCZVzi+w+qKCnQw==
Date: Tue, 9 Jun 2009 00:54:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <1244531201.5024.3.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
 <20090608101739.GA15377@csn.ul.ie> <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com> <20090608110303.GD15377@csn.ul.ie> <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI> <20090608141212.GE15070@csn.ul.ie>
 <1244531201.5024.3.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Pekka Enberg wrote:

> Hi Mel,
> 
> On Mon, 2009-06-08 at 15:12 +0100, Mel Gorman wrote:
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 65ffda5..b5acf18 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -1565,6 +1565,8 @@ new_slab:
> > >  		c->page = new;
> > >  		goto load_freelist;
> > >  	}
> > > +	printk(KERN_WARNING "SLUB: unable to satisfy allocation for cache %s (size=%d, node=%d, gfp=%x)\n",
> > > +		s->name, s->size, node, gfpflags);
> > 
> > size could be almost anything here for a casual reader. You are
> > outputting the size of the object plus its metadata so the name should
> > reflect that. I think it would be better to output objsize= and the
> > object size without the metadata overhead. What do you think?
> > 
> > In addition, include how many objects there are per-slab and include what
> > the order is being passed to the page allocator when allocating new slabs.
> > Would that be enough to determine if fallback-to-smaller orders occured?
> 
> So how about something like this then?
> 

Larry reported this stack trace:

kernel: git: page allocation failure. order:1, mode:0x4020
kernel: Pid: 3707, comm: git Not tainted 2.6.30-rc1-wl #115
kernel: Call Trace:
kernel:  [<ffffffff80292f84>] __alloc_pages_internal+0x43d/0x45d
kernel:  [<ffffffff802b2383>] alloc_pages_current+0xbe/0xc6
kernel:  [<ffffffff802b66a4>] new_slab+0xcf/0x28b

That's in the order fallback for new slab allocations; so this cache must 
have oo_order(s->min) of 1.

To diagnose whether its object size dictates a >0 slab order, you could 
enable CONFIG_SLUB_STATS (it's disabled in his .config) and check which 
/sys/kernel/slab/cache/order_fallback increased.  Once you have identified 
the cache, you can get this information via 
/sys/kernel/slab/cache/{objsize,order,size}.  I think this is what 
Christoph was getting at.

You could even boot with `slub_nomerge' to determine whether cache merging 
was the issue where the cache under consideration was unnecessarily merged 
with one that requires larger higher order minimums.

I don't quite understand how its necessary to print the partial lists for 
each node, they should be exhausted if we're allocating a new slab if the 
node doesn't matter (and can't in Larry's case, he only has one).
