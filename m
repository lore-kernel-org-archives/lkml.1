Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbXFAX0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbXFAX0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXFAX0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:26:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbXFAX0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:26:08 -0400
Date: Fri, 1 Jun 2007 16:25:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Srinivasa Ds <srinivasa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601160241.33b304bf.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706011615480.3957@woody.linux-foundation.org>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
 <20070601160241.33b304bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Jun 2007, Andrew Morton wrote:
> 
> We could store the size of the allocation in the allocated object?  Just
> add four bytes to the user's request, then pick the appropriate cache based
> on that, then put the user's `size' at the tail of the resulting allocation?

It should be easy enough to do it for _most_ allocations by just doing it 
when there is already "enough slack" to do it (which is likely true most 
of the time).

IOW, if you ask for a 42-byte allocation, and we allocate from a 64-byte 
slab, you get the slab allocation at address X, you don't actually have to 
return "X" at all. Just return "X+8", and then you do:

 - at 32-bit word at X+0 you put the "real length"
 - at 32-bit word at X+4 you put some good redzone marker
 - at 32-bit word at "X + reallen + 8" you put the endzone marker.

And then you say: if the real length was within 12 bytes of the allocation 
length, we just don't do this.

So you wouldn't get any redzoning for those allocations that are exactly 
sized (or close enough) to fit in an allocation block, but I bet *most* 
allocations would get this for free.

And then, if you actually turn on redzoning, you just always add the 12 
byte to the allocation size (assuming the alignment rules allow you to).

The nice thing about this is that the freeing path already knows where the 
object is *supposed* to start (because it sees the allocation size in the 
slub/slab data structures), so the kfree() path can actually figure out on 
its own whether it is given a "X" or an "X+8" kind of address.

So you don't actually need any extra information. You literally just need 
enough slop in the allocation that you can do this in the first place, so 
there is no cost (except for the cost of checking itself, of course).

Hmm?

			Linus
