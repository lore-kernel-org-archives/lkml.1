Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbZGJJcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbZGJJcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZGJJbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:31:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZGJJbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:31:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sDUASzXJwVMR20NBjfElfmfRI2EXhLUPy03JAc9HkQInu59UGf69xSoWWNBmbbyo9
	pjsA9oQI3CPAk6PSsk7aw==
Date: Fri, 10 Jul 2009 02:31:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ingo Molnar <mingo@elte.hu>, Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       graydon@redhat.com, fche@redhat.com, Nick Piggin <npiggin@suse.de>,
       cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
In-Reply-To: <1247217548.771.10.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0907100223140.14601@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com> <1247217548.771.10.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Pekka Enberg wrote:

> > I'm not sure what the status of slqb is, although I would have expected it 
> > to have been pushed for inclusion in 2.6.31 as a slab allocator 
> > alternative.  Nick, any forecast for inclusion?
> 
> 2.6.32 most likely. Nick has fixed a bunch of problems but there's still
> one ppc boot time bug that's turning out to be hard to find.
> 

Ah, ok, there's still outstanding bugs.  I was curious as to why it wasn't 
merged as a non-default option that would have perhaps attracted more 
attention to it.

> > SLUB has a pretty noticeable performance degradation on benchmarks such as 
> > netperf TCP_RR with high numbers of threads (see my post about it: 
> > http://marc.info/?l=linux-kernel&m=123839191416472).  CONFIG_SLAB is the 
> > optimal configuration for workloads that share similiar slab thrashing 
> > patterns (which my patchset dealt with in an indirect way and yet still 
> > didn't match slab's performance).  I haven't yet seen data that suggests 
> > anything other than CONFIG_SLAB has parity with such a benchmark.
> 
> As I said before, I'm interesting in getting those patches merged. I
> think Christoph raised some issues that need to be take care of before
> we can do that, no?
> 

The issue was the addition of an increment to the freeing fastpath and 
some arithemetic in the allocation slowpath that would have negatively 
affected performance for caches that don't suffer from the issue, even 
under affected benchmarks such as netperf TCP_RR.

Even ignoring the impact on workloads that don't suffer from these 
patterns, parity with slab still unfortunately isn't reached with the 
patchset.  It also diverges from the fundamental design of slub which is 
optimized by filling up partial slabs as quickly as possible to minimize 
the scanning contention on list_lock for high cpu counts and less memory 
consumption overall by reducing slab internal fragmentation.
