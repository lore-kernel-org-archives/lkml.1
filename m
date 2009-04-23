Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZDWTBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZDWTBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbZDWTBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:01:20 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:56289 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZDWTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:01:19 -0400
Date: Thu, 23 Apr 2009 14:52:26 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add
 Documentation/ABI/testing/sysfs-kernel-slab
In-Reply-To: <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0904231436410.7406@qirst.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, David Rientjes wrote:

> +What:		/sys/kernel/slab/cache/alloc_calls
> +Date:		May 2007
> +KernelVersion:	2.6.22
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The alloc_calls file is read-only and lists the locations of
> +		object allocs for SLAB_STORE_USER caches as specified on the
> +		kernel command line (see Documentation/vm/slub.txt).

Thats a bit ambiguous:

Alloc_calls list the kernel code locations from which allocations for this
cache were performed. The alloc_calls file only contains information if
debugging was enabled for the cache (f.e. via the kernel command line
parameter)

> +What:		/sys/kernel/slab/cache/alloc_fastpath
> +Date:		February 2008
> +KernelVersion:	2.6.25
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The alloc_fastpath file is read-only and specifies how many
> +		objects have been allocated utilizing the cache's fastpath

objects have been allocating using the fast path

> +What:		/sys/kernel/slab/cache/alloc_from_partial
> +Date:		February 2008
> +KernelVersion:	2.6.25
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The alloc_from_partial file is read-only and specifies how
> +		many times a cpu slab has been full and it has been refilled
> +		by a partial slab.

by using a slab from the list of partially used slabs.

?

> +What:		/sys/kernel/slab/cache/alloc_refill
> +Date:		February 2008
> +KernelVersion:	2.6.25
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The alloc_refill file is read-only and specifies how many
> +		times a cpu slab needed to be refilled because it was full.
> +		Available when CONFIG_SLUB_STATS is enabled.

Nope. A refill is when the per cpu list became empty but there are objects
on the list of free objects in the page struct associated with the slab
page (occurs when other cpus free objects allocated from the per cpu
slab).

> +Description:
> +		The alloc_slowpath file is read-only and specifies how many
> +		objects have been allocated utilizing the cache's slowpath
> +		(i.e. from a partial or new slab).
> +		Available when CONFIG_SLUB_STATS is enabled.

Slowpath can do a refill. In that case no partial or new slab is needed.

> +Description:
> +		The cpu_slabs file is read-only and displays how many cpu slabs
> +		are active and from which nodes they are from.

are active and their NUMA locality

?

> +Description:
> +		The file cpu_slab_flush is read-only and specifies how many
> +		times a cache's cpu slabs have been flushed as the result of
> +		destroying or shrinking a cache and when a cpu goes offline.
> +		Available when CONFIG_SLUB_STATS is enabled.

A flush also may occur as a result of forcing an allocation from a certain
NUMA node.

> +Description:
> +		The file free_add_partial is read-only and specifies how many
> +		times an object has been freed to a full slab so that it had to

been freed in a full slab so that it had to

> +Description:
> +		The free_calls file is read-only and lists the locations of
> +		object frees for SLAB_STORE_USER caches as specified on the

object frees if slab debugging is enabled (see Documentation/vm/slub.txt)

> +Description:
> +		The free_fastpath file is read-only and specifies how many
> +		objects have been freed utilizing the cache's fastpath (i.e.

objects have been free using the fastpath because it was an object from
the cpu_slab.

> +What:		/sys/kernel/slab/cache/order
> +Date:		May 2007
> +KernelVersion:	2.6.22
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The order file specifies the page order at which new slabs are
> +		allocated.  If a slab cannot be allocated because of
> +		fragmentation, SLUB will retry with the minimum order possible
> +		depending on its characteristics.

The order is writable and can be changed to increase objects per slab.

> +What:		/sys/kernel/slab/cache/sanity_checks
> +Date:		May 2007
> +KernelVersion:	2.6.22
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The sanity_checks file specifies whether expensive checks
> +		should be performed on free.  This is actually a no-op for SLUB
> +		so it only acts to prevent slab merging.

It enables at mininum the double free checks.

> +What:		/sys/kernel/slab/cache/slab_size
> +Date:		May 2007
> +KernelVersion:	2.6.22
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The slab_size file is read-only and specifies the object size
> +		with metadata (debugging information and alignment) in bytes.

Also includes alignment.

> +
> +What:		/sys/kernel/slab/cache/validate
> +Date:		May 2007
> +KernelVersion:	2.6.22
> +Contact:	Pekka Enberg <penberg@cs.helsinki.fi>,
> +		Christoph Lameter <cl@linux-foundation.org>
> +Description:
> +		The validate file is written whenever a cache should be
> +		validated for correctness.

Writing to the validate files makes SLUB traverse all its objects and
check the validity of metadata.

