Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZCIVRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZCIVRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 17:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZCIVQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 17:16:53 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:38781 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751286AbZCIVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 17:16:52 -0400
Date: Mon, 9 Mar 2009 17:14:07 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903091706540.1861@qirst.com>
References: <20090309123011.A228.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903090206010.24605@chino.kir.corp.google.com> <20090309181756.CF66.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903091313090.27253@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, David Rientjes wrote:

> On Mon, 9 Mar 2009, KOSAKI Motohiro wrote:
>
> > My question mean, Why anyone need isolation?
> > your patch insert new branch into hotpath.
> > then, it makes slower hotpath a abit although a user don't use this feature.
> On large NUMA machines, it is currently possible for a very large
> percentage (if not all) of your slab allocations to come from memory that
> is distant from your application's set of allowable cpus.  Such
> allocations that are long-lived would benefit from having affinity to
> those processors.  Again, this is the typical use case for cpusets: to
> bind memory nodes to groups of cpus with affinity to it for the tasks
> attached to the cpuset.

Can you show us a real workload that suffers from this issue?

If you want to make sure that an allocation comes from a certain node then
specifying the node in kmalloc_node() will give you what you want.

> > typically, slab cache don't need strict node binding because
> > inode/dentry touched from multiple cpus.
> This change would obviously require inode and dentry objects to originate
> from a node on the cpuset's set of mems_allowed.  That would incur a
> performance penalty if the cpu slab is not from such a node, but that is
> assumed by the user who has enabled the option.

The usage of kernel objects may not be cpuset specific. This is true for
other objects than inode and dentries well.

> > In addition, on large numa systems, slab cache is relatively small
> > than page cache. then this feature's improvement seems relatively small too.
> That's irrelevant, large NUMA machines may still require memory affinity
> to a specific group of cpus, the size of the global slab cache isn't
> important if that's the goal.  When the option is enabled for cpusets
> that require that memory locality, we happily trade off partial list
> fragmentation and increased slab allocations for the long-lived local
> allocations.

Other memory may spill over too. F.e. two processes from disjunct cpu sets
cause faults in the same address range (its rather common for this to
happen to glibc code f.e.). Two processes may use another kernel feature
that buffers objects (are you going to want to search the LRU lists for objects
from the right node?)

NUMA affinity is there in the large picture. In detail the allocation
strategies over nodes etc etc may be disturbed by this and that in
particular if processes with disjoint cpusets run on the same processor.

Just dont do it. Dedicate a cpu to a cpuset. Overlapping cpusets can cause
other strange things as well.

