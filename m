Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZBWJ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZBWJ6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbZBWJ6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:58:16 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZBWJ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:58:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ulu3Oy9Gwj+R0w5u2gjb/Zps7qWQR2EbWVgj7FaXtCUwLE0BYNPyCxx0lldegtBK4
	pqr8L5S3BGWWcO8XvWM+A==
Date: Mon, 23 Feb 2009 01:58:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add min_partial sysfs tunable
In-Reply-To: <1235377162.6216.5.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0902230126080.19494@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com>  <alpine.DEB.2.00.0902221712160.26165@chino.kir.corp.google.com> <1235377162.6216.5.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Pekka Enberg wrote:

> The patches look good but the description is bit lacking. Does this
> actually fix up something? Why don't we fix the limit calculations
> instead?
> 
> I'm a sucker for numbers so I'm easily fooled into merging patches with
> statements of the form "this shaves off N bytes/kb/mb on XYZ systems".
> 

The memory savings from simply moving min_partial from struct 
kmem_cache_node to struct kmem_cache is obviously not significant (unless 
maybe you're from SGI or something), at the largest it's

	# allocated caches * (MAX_NUMNODES - 1) * sizeof(unsigned long)

The true savings occurs when userspace reduces the number of partial slabs 
that would otherwise be wasted, especially on machines with a large 
number of nodes (ia64 with CONFIG_NODES_SHIFT at 10 for default?).  As 
well as the kernel estimates ideal values for n->min_partial and ensures 
it's within a sane range, userspace has no other input other than writing 
to /sys/kernel/slab/cache/shrink.

There simply isn't any better heuristic to add when calculating the 
partial values for a better estimate that works for all possible caches.  
And since it's currently a static value, the user really has no way of 
reclaiming that wasted space, which can be significant when constrained by 
a cgroup (either cpusets or, later, memory controller slab limits) without 
shrinking it entirely.

This also allows the user to specify that increased fragmentation and more 
partial slabs are actually desired to avoid the cost of allocating new 
slabs at runtime for specific caches.

There's also no reason why this should be a per-struct kmem_cache_node 
value in the first place.  You could argue that a machine would have such 
node size asymmetries that it should be specified on a per-node basis, but 
we know nobody is doing that right now since it's a purely static value at 
the moment and there's no convenient way to tune that via slub's sysfs 
interface.
