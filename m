Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZIVRb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZIVRb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZIVRby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:31:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZIVRby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:31:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=k+yYpz9y2cXhVVGWXna2VosHWJNCs0ry1LLBkN7FB1w4xxWzecvbC1Uh7GyNIaT2I
	3oJCKIpgHUBXpiJP5dKmQ==
Date: Tue, 22 Sep 2009 10:31:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
In-Reply-To: <20090922152649.GG25965@csn.ul.ie>
Message-ID: <alpine.DEB.1.00.0909221018380.7114@chino.kir.corp.google.com>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <1253577603.7103.174.camel@pasglop> <20090922152649.GG25965@csn.ul.ie>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Mel Gorman wrote:

> Lumping the per-cpu allocator to cover per-cpu and per-node feels a bit
> confusing. Maybe it would have been easier if there simply were never
> memoryless nodes and cpus were always mapped to their closest, instead of
> their local, node. There likely would be a few corner cases though and memory
> hotplug would add to the mess. I haven't been able to decide on a sensible
> way forward that doesn't involve a number of invasive changes.
> 

I strongly agree with removing memoryless node support from the kernel, 
but I don't think we should substitute it with a multiple cpu binding 
approach because it doesn't export the true physical topology of the 
system.

If we treat all cpus equally with respect to a region of memory when one 
happens to be more remote, userspace can no longer use sched_setaffinity() 
for latency-sensitive apps nor can it correctly interleave with other 
nodes.  Reduced to its simplest form, a machine now with a single node 
because memoryless nodes have been obsoleted would incorrectly report that 
all cpus are true siblings.

While memoryless nodes are inconvenient for the implementation, they do 
have the benefit of being able to represent the actual physical topology 
when binding cpus to their nearest node, even though it may not be local, 
would not.

It's important to accurately represent the physical topology, and that can 
be done with the device class abstraction model as I described in 
http://lkml.org/lkml/2009/9/22/97 of which a node is only a locality of a 
particular type.
