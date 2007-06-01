Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbXFAXDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbXFAXDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 19:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbXFAXC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 19:02:59 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbXFAXC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 19:02:58 -0400
Date: Fri, 1 Jun 2007 16:02:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@cthulhu.engr.sgi.com, rientjes@google.com
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777
 warning
Message-Id: <20070601160241.33b304bf.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
References: <465FCA79.70207@in.ibm.com>
	<200706011620.05756.srinivasa@in.ibm.com>
	<466081DE.70205@goop.org>
	<Pine.LNX.4.64.0706011345220.4323@schroedinger.engr.sgi.com>
	<20070601135900.ec44b1aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011444010.5009@schroedinger.engr.sgi.com>
	<20070601151649.bb23c6f9.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011519030.7625@schroedinger.engr.sgi.com>
	<20070601153328.1118ccaf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706011534170.9497@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 15:41:48 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 1 Jun 2007, Andrew Morton wrote:
> 
> > > I should make SLUB put poisoning values in unused areas of a kmalloced 
> > > object?
> > 
> > hm, I hadn't thought of it that way actually.  I was thinking it was
> > specific to kmalloc(0) but as you point out, the situation is
> > generalisable.
> 
> Right it could catch a lot of other bugs as well.
> 
> > Yes, if someone does kmalloc(42) and we satisfy the allocation from the
> > size-64 slab, we should poison and then check the allegedly-unused 22
> > bytes.
> > 
> > Please ;)
> > 
> > (vaguely stunned that we didn't think of doing this years ago).
> 
> Well there are architectural problems. We determine the power of two slab 
> at compile time. The object size information is currently not available in 
> the binary :=).
>  
> > It'll be a large patch, I expect?
> 
> Ummm... Yes. We need to switch off the compile time power of two slab 
> calculation. Then I need to have some way of storing the object size in 
> the metainformation of each object. Changes a lot of function calls.

Oh well.  Don't lose any sleep over it ;)

<loses sleep>

We could store the size of the allocation in the allocated object?  Just
add four bytes to the user's request, then pick the appropriate cache based
on that, then put the user's `size' at the tail of the resulting allocation?

So a kmalloc(62) would get upped to 66, so we allocate from size-128
and put the number 62 at bytes 124-127 and we poison bytes 62-123?
