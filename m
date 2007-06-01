Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbXFAX5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbXFAX5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXFAX5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:57:38 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757171AbXFAX5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:57:37 -0400
Date: Fri, 1 Jun 2007 16:57:20 -0700 (PDT)
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
In-Reply-To: <Pine.LNX.4.64.0706011642530.9992@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.0.98.0706011653290.3957@woody.linux-foundation.org>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Christoph Lameter wrote:
> 
> A too large alloc is >32MB or MAX_ORDER << PAGE_SIZE. A BUG_ON in 
> kmalloc_slab() will trigger.

Did we use to BUG_ON()? I think that's wrong. There are ways for users to 
potentially ask the kernel to do big allocations, and the correct response 
is to say "no can do", not to crash!

> Here is the updated patch. It works fine here:
> 
> SLUB: Return BADPTR instead of warning for kmalloc(0)

Looks fine to me. My only comment is that

> -	if (!x)
> +	if (!x || x == BADPTR)
>  		return;

This could be micro-optimized (again, non-standard, but it should be 
"practically portable") to have just a single test using something like

	if ((unsigned long)x <= 16)
		return;

but I guess it doesn't really matter much.

I think this is better than what we have now, but I also suspect it's 
*not* something we should try this late in the -rc sequence ;)

Andrew, want to take this patch to -mm to see if it triggers anything?

		Linus
