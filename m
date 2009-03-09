Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZCIVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZCIVcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZCIVch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:32:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32861 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZCIVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:32:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=d7CueRJs+19KfuqYnHTHdZ9LjqolaXDC5t0wePPknJrdbwAbHa32BES3/m5QUqEYk
	9Z/WAU+4RGZ5PhDwkWqhQ==
Date: Mon, 9 Mar 2009 14:31:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.1.10.0903091706540.1861@qirst.com>
Message-ID: <alpine.DEB.2.00.0903091422510.5410@chino.kir.corp.google.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com> <20090309181756.CF66.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903091706540.1861@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Christoph Lameter wrote:

> > On large NUMA machines, it is currently possible for a very large
> > percentage (if not all) of your slab allocations to come from memory that
> > is distant from your application's set of allowable cpus.  Such
> > allocations that are long-lived would benefit from having affinity to
> > those processors.  Again, this is the typical use case for cpusets: to
> > bind memory nodes to groups of cpus with affinity to it for the tasks
> > attached to the cpuset.
> 
> Can you show us a real workload that suffers from this issue?
> 

We're more interested in the isolation characteristic, but that also 
benefits large NUMA machines by keeping nodes free of egregious amounts of 
slab allocated for remote cpus.

> If you want to make sure that an allocation comes from a certain node then
> specifying the node in kmalloc_node() will give you what you want.
> 

That's essentially what the change does implicitly: it changes all 
kmalloc() calls to kmalloc_node() for current->mems_allowed.

> > This change would obviously require inode and dentry objects to originate
> > from a node on the cpuset's set of mems_allowed.  That would incur a
> > performance penalty if the cpu slab is not from such a node, but that is
> > assumed by the user who has enabled the option.
> 
> The usage of kernel objects may not be cpuset specific. This is true for
> other objects than inode and dentries well.
> 

Yes, and that's why we require the cpuset hardwall on a configurable 
per-cpuset basis.  If a cpuset has set this option for its workload, then 
it is demanding object allocations from local memory.  Other cpusets that 
do not have memory_slab_hardwall set can still allocate from any cpu slab 
or partial slab, including those allocated for the hardwall cpuset.

> Other memory may spill over too. F.e. two processes from disjunct cpu sets
> cause faults in the same address range (its rather common for this to
> happen to glibc code f.e.). Two processes may use another kernel feature
> that buffers objects (are you going to want to search the LRU lists for objects
> from the right node?)
> 

If a workload is demanding node local object allocation, then an object 
buffer probably isn't in its best interest if they are not all from nodes 
with affinity.

> NUMA affinity is there in the large picture.

It depends heavily on the allocation and freeing pattern, it is quite 
possible that NUMA affinity will never be realized through slub if all 
slabs are consistently allocated on a single node just because we get an 
alloc when the current cpu slab must be replaced.
