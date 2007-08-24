Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbXHXWam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbXHXWam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761243AbXHXW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:29:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39830 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760477AbXHXW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:29:49 -0400
Message-Id: <20070824222654.687510000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 24 Aug 2007 15:26:54 -0700
From: travis@sgi.com
To: Andi Kleen <ak@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 0/6] x86: Reduce Memory Usage and Inter-Node message traffic (v2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes for version v2:

> > Note the addtional change of the cpu_llc_id type from u8
> > to int for ARCH x86_64 to correspond with ARCH i386.

> At least currently it cannot be more than 8 bit. So why
> waste memory? It would be better to change i386

Done.  (x86_64 type => u8).

> > Fix four instances where cpu_to_node is referenced
> > > by array instead of via the cpu_to_node macro.  This
> > > is preparation to moving it to the per_cpu data area.

> Shouldn't this patch be logically before the per cpu 
> conversion (which is 3/6). This way the result would
> be git bisectable.

Done.  (Moved to PATCH 1/6).

> > processor_core.c currently tries to determine the apicid by special casing
> > for IA64 and x86. The desired information is readily available via
> > 
> > 	    cpu_physical_id()
> > 
> > on IA64, i386 and x86_64.
> 
> Have you tried this with a !CONFIG_SMP build? The drivers/dma code was doing
> the same and running into problems because it wasn't defined there.

Fixed. (New export in PATCH 6/6).


Previous Intro:

In x86_64 and i386 architectures most arrays that are sized
using NR_CPUS lay in local memory on node 0.  Not only will most
(99%?) of the systems not use all the slots in these arrays,
particularly when NR_CPUS is increased to accommodate future
very high cpu count systems, but a number of cache lines are
passed unnecessarily on the system bus when these arrays are
referenced by cpus on other nodes.

Typically, the values in these arrays are referenced by the cpu
accessing it's own values, though when passing IPI interrupts,
the cpu does access the data relevant to the targeted cpu/node.
Of course, if the referencing cpu is not on node 0, then the
reference will still require cross node exchanges of cache
lines.  A common use of this is for an interrupt service
routine to pass the interrupt to other cpus local to that node.

Ideally, all the elements in these arrays should be moved to the
per_cpu data area.  In some cases (such as x86_cpu_to_apicid)
the array is referenced before the per_cpu data areas are setup.
In this case, a static array is declared in the __initdata
area and initialized by the booting cpu (BSP).  The values are
then moved to the per_cpu area after it is initialized and the
original static array is freed with the rest of the __initdata.
-- 
