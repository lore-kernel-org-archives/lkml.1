Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXFAWl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXFAWl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXFAWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:41:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55163 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753046AbXFAWls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:41:48 -0400
Date: Fri, 1 Jun 2007 15:41:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
In-Reply-To: <20070601153328.1118ccaf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com> <200706011620.05756.srinivasa@in.ibm.com>
 <466081DE.70205@goop.org> <Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
 <20070601135900.ec44b1aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
 <20070601151649.bb23c6f9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
 <20070601153328.1118ccaf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Andrew Morton wrote:

> > I should make SLUB put poisoning values in unused areas of a kmalloced 
> > object?
> 
> hm, I hadn't thought of it that way actually.  I was thinking it was
> specific to kmalloc(0) but as you point out, the situation is
> generalisable.

Right it could catch a lot of other bugs as well.

> Yes, if someone does kmalloc(42) and we satisfy the allocation from the
> size-64 slab, we should poison and then check the allegedly-unused 22
> bytes.
> 
> Please ;)
> 
> (vaguely stunned that we didn't think of doing this years ago).

Well there are architectural problems. We determine the power of two slab 
at compile time. The object size information is currently not available in 
the binary :=).
 
> It'll be a large patch, I expect?

Ummm... Yes. We need to switch off the compile time power of two slab 
calculation. Then I need to have some way of storing the object size in 
the metainformation of each object. Changes a lot of function calls.

> Actually, I have this vague memory that slab would take that kmalloc(42)
> and would then return kmalloc(64)+22, so the returned memory is
> "right-aligned".  This way the existing overrun-detection is applicable to
> all kmallocs.  Maybe I dreamed it.

Yes, that would be possible by simply adding a compile time generated 
offset to the compile time generated call to kmem_cache_alloc. But then 
kfree() will have a difficult time figuring out which object to free. 
Hmmm... But I can get to the slab via the page struct which allows me to 
figure out the power of two size. This would mean that kfree would work 
with an arbitrary pointer anywhere into the object.
