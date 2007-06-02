Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbXFBBFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbXFBBFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXFBBFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:05:12 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966AbXFBBFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:05:10 -0400
Date: Fri, 1 Jun 2007 18:04:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <Pine.LNX.4.64.0706011721390.10254@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0706011801280.3957@woody.linux-foundation.org>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706011617330.9781@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011638360.3957@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706011642530.9992@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011653290.3957@woody.linux-foundation.org>
 <20070601171612.8194394a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011721390.10254@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Christoph Lameter wrote:
>
> On Fri, 1 Jun 2007, Andrew Morton wrote:
> 
> > I think it'd be better if we kept the WARN_ON_ONCE(size == 0) in there,
> 
> The trouble with the WARN_ON is that it triggers even for code that is 
> okay like noted by Jeremy.

Yes. Sometimes it's just more natural to have

	ptr = kmalloc(size);
	.. use it ..
	free(ptr);

and if a *degenerate* case of size=0 happens, who cares? It should just 
work, as long as we (obviously) don't actually try to access the pointer.

So I don't much like the WARN_ON(size == 0). I think it potentially just 
causes people to write around it, and quite possibly causes the callers to 
write code that is not at all more readable or maintainable!

That's why I'd much rather return BADPTR instead: we'll get an oops for 
buggy code, but we don't penalize the "natural" and good code! So once you 
return BADPTR, there really isn't any good reason for the WARN_ON.

			Linus
