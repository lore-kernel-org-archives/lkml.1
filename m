Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbXIQUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbXIQUVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbXIQUVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:21:11 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:33528 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbXIQUVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:21:09 -0400
Subject: Re: [PATCH]  2.6.23-rc6:  Fix NUMA Memory Policy Reference Counting
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ak@suse.de, eric.whitney@hp.com, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <Pine.LNX.4.64.0709171235190.28178@schroedinger.engr.sgi.com>
References: <20070830185053.22619.96398.sendpatchset@localhost>
	 <1190057534.5460.131.camel@localhost>
	 <Pine.LNX.4.64.0709171235190.28178@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 17 Sep 2007 16:19:53 -0400
Message-Id: <1190060393.5460.143.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 12:37 -0700, Christoph Lameter wrote:
> On Mon, 17 Sep 2007, Lee Schermerhorn wrote:
> 
> > Here is the 23-rc6 verison of the patch.  Andi considers it a high
> > priority bug fix for .23.  I'm a bit uncomfortable with this, this late
> > in the 23 cycle.  I've not heard of problems w/o this patch, but then,
> > maybe no one notices if they leak a memory policy struct now and then,
> > or occasionally allocate memory on the wrong node because they used a
> > prematurely freed memory policy.
> 
> The patch does require concurrent increments and decrements in the main 
> fault patch. The potential is to create another bouncing cacheline for 
> concurrent faults. This looks like it would cause a performance issue.

Only for vma policy, right?  show_numa_maps() isn't a performance path,
and shared policies are already reference counted--just not unref'd!

> 
> > Kernel Build [16cpu, 32GB, ia64] - average of 10 runs:
> > 
> > 		w/o patch	w/ refcount patch
> > 	    Avg	  Std Devn	   Avg	  Std Devn
> > Real:	 100.59	    0.38	 100.63	    0.43
> > User:	1209.60	    0.37	1209.91	    0.31
> > System:   81.52	    0.42	  81.64	    0.34
> 
> Single threaded build? I would suggest to try concurrently faulting memory 
> from multiple processors. You may not see this on a kernel build even if 
> this is run with -j16 because concurrent faults are rare.

Well, it was a 32-way parallel build [-j32] on a 16-cpu system--my usual
build method.  But, I'm guessing that all of the build tools are single
threaded and all using default policy, so no reference counting is
needed.

I'm taking a look at your 'pft' program, and I'll try that.

I do have some ideas for enhancements to memtoy to test vma policies in
a multi-threaded task.  I have the basic multi-threading infrastructure
that binds threads to cpus, allocates node local stacks, thread state
structs, ... in my mmtrace tool that I can probably hack for use in
memtoy to provoke cacheline bouncing of the mem policy.  But, if pft
does the trick, I won't rush the memtoy enhancments...

Meanwhile, we do have a mem policy ref counting bug in the mainline.

Later,
Lee


