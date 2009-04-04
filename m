Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZDDOIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZDDOIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 10:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZDDOIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 10:08:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:56374 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZDDOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 10:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kcIUqKirO4152uPUHK+2e2LyOAJM9FGOoU7P7jsmJoMZbsFr7mUzfr5AJrSS14m3eH
         TmIDx5KLR4v1a7bWPRfrQz/1bykoyImhj18UtZtVujqtm8q+FodGJVYxZm3npxL/EXct
         p0oLUfHEQIUiOGj/EBtHlFc/x5Mc46YzQic68=
Date: Sat, 4 Apr 2009 17:08:52 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, alexn@dsv.su.se, akpm@linux-foundation.org,
       alexn@telia.com, apw@shadowen.org, cl@linux-foundation.org,
       haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090404140852.GA5736@localhost>
References: <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie> <20090401134917.GC18677@elte.hu> <1238597398.23857.11.camel@penberg-laptop> <20090401152251.GB23390@elte.hu> <1238656331.26286.17.camel@penberg-laptop> <20090403042131.GA15669@localhost> <20090403141743.GF8875@elte.hu> <49D61F09.2080808@cs.helsinki.fi> <20090403144344.GA9643@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403144344.GA9643@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 04:43:44PM +0200, Ingo Molnar wrote:
> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Ingo Molnar wrote:
> >> * Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:
> >>
> >>> One thing I'm not sure about this patch is whether it manages to  
> >>> record an allocation only once, i.e. does it log a single event  
> >>> when/if the slab allocator requests pages? Some time ago I sent a  
> >>> patch adding GFP_NOTRACE to gfp.h, but was rejected. Maybe this  
> >>> could be a way out of the mess.
> >>>
> >>> (GFP_NOTRACE would also allow us to log "backend" allocations easily 
> >>> and treat them separately, for the record, or simply filter them 
> >>> out.)
> >>
> >> makes a lot of sense IMO to annotate these via a GFP flag.
> >
> > Yup, make sense. I think I rejected the patch (did I?) because I 
> > wanted to fix the slub/slab mess differently but here it makes 
> > perfect sense.

Uh, I don't remember exactly, not sure who did it.

But to expand on the upside of doing it this way, we could expect to see
something like...

xxxxx	CPU0	GFP_KERNEL			kmalloc
xxxxx	CPU0	GFP_KERNEL | GFP_NOTRACE	__get_free_pages
xxxxx	CPU0	GFP_KERNEL | GFP_NOTRACE	kmalloc
xxxxx	CPU0	GFP_KERNEL			kmem_cache_alloc

So it's easy to see that allocations 2 and 3 are in fact part of the
fourth. It will get confused by IRQs, preemption and sleeping while
allocating, but we could use additional information (e.g. tracking
returned ptr's) to eliminate some/many such confusions in userspace.

> I'm wondering how much could be shared with the kmemcheck's 
> internal-allocation annotations. There's some overlap (although not 
> a full match) i suspect?
> 
> 	Ingo

I had already suggested this to Vegard some time ago. Basically,
kmemcheck should hook to the same tracepoints. As far as I remember,
kmemtrace gets more info out of the allocators, so this should suit
kmemcheck as well. Though this would incur additional overhead for the
latter due to the extra parameters being passed, but kmemcheck is slow
anyway.


	Eduard

