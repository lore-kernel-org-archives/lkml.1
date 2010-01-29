Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493Ab0A2Uww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0A2Uww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270Ab0A2Uwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:52:32 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42789 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0A2UvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:20 -0500
Message-Id: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:31 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Slab Fragmentation Reduction V15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is one of these year long projects to address fundamental issues in the
Linux VM. The problem is that sparse use of objects in slab caches can cause
large amounts of memory to become unusable. The first ideas to address this
were developed in 2005 by various people. Some of the issues with SLAB that
we discovered while prototyping these ideas also contributed to the locking
design in SLUB which is highly decentralized and allows stabilizing the object
state slab wise by taking a per slab lock.

This patchset was first proposed in the beginning of 2007. It was almost merged
in 2008 when last minute objections arose in the way this interacts with
filesystem objects (inode/dentry).

Andi has asked that we reconsider this issue. So I have updated the patchset
to apply against current upstream (and also -next with a special patch
at the end). The issues with icache/dentry locking remain. In order
for this to be merged we would have to come up with a revised dentry/inode
locking code that can

	1. Establish a reference to an dentry/inode so that it is pinned.
           Hopefully in a way that is not too expensive (i.e. no superblock
           lock)

	2. A means to free a dentry/inode objects from the VM reclaim context.

Both of those do not need to work reliably and can fail. Reclaim is a heuristic
process after all. Failure to reclaim will make the allocator skip the slab on
future scans and use it for allocations instead. When all objects in a slab have
been used and an object is freed then the slab becomes subject to
VM reclaim scans again.

The other objection against this patchset was that it does not support
reclaim through SLAB. It is possible to add this type of support to SLAB too
but one would have to take the node l3 lock to lock down all objects on
a node (and purge the percpu caches beforehand). This would stop all
allocations during a reclaim pass on a slab and make targeted reclaim
much more expensive.


     Patch description

Slab fragmentation is mainly an issue if Linux is used as a fileserver
and large amounts of dentries, inodes and buffer heads accumulate. In some
load situations the slabs become very sparsely populated so that a lot of
memory is wasted by slabs that only contain one or a few objects. In
extreme cases the performance of a machine will become sluggish since
we are continually running reclaim without much succes.
Slab defragmentation adds the capability to recover the memory that
is wasted.

Memory reclaim for the following slab caches is possible:

1. dentry cache
2. inode cache (with a generic interface to allow easy setup of more
   filesystems than the currently supported ext2/3/4 reiserfs, XFS
   and proc)
3. buffer_heads

One typical mechanism that triggers slab defragmentation on my systems
is the daily run of

	updatedb

Updatedb scans all files on the system which causes a high inode and dentry
use. After updatedb is complete we need to go back to the regular use
patterns (typical on my machine: kernel compiles). Those need the memory now
for different purposes. The inodes and dentries used for updatedb will
gradually be aged by the dentry/inode reclaim algorithm which will free
up the dentries and inode entries randomly through the slabs that were
allocated. As a result the slabs will become sparsely populated. If they
become empty then they can be freed but a lot of them will remain sparsely
populated. That is where slab defrag comes in: It removes the objects from
the slabs with just a few entries reclaiming more memory for other uses.
In the simplest case (as provided here) this is done by simply reclaiming
the objects.

However, if the logic in the kick() function is made more
sophisticated then we will be able to move the objects out of the slabs.
Allocations of objects is possible if a slab is fragmented without the use of
the page allocator because a large number of free slots are available. Moving
an object will reduce fragmentation in the slab the object is moved to.

V14->V15
- Provide missing Documentation/ABI documentation pieces
- Add -next transition patch
- Re-add the dentry patch
- Put warnings into the patches with issues

V13->V14
- Rediff against linux-next on request of Andrew
- TestSetPageLocked -> trylock_page conversion.

V12->v13:
- Rebase onto Linux 2.6.27-rc1 (deal with page flags conversion, ctor parameters etc)
- Fix unitialized variable issue

V11->V12:
- Pekka and me fixed various minor issues pointed out by Andrew.
- Split ext2/3/4 defrag support patches.
- Add more documentation
- Revise the way that slab defrag is triggered from reclaim. No longer
  use a timeout but track the amount of slab reclaim done by the shrinkers.
  Add a field in /proc/sys/vm/slab_defrag_limit to control the threshold.
- Display current slab_defrag_counters in /proc/zoneinfo (for a zone) and
  /proc/sys/vm/slab_defrag_count (for global reclaim).
- Add new config vaue slab_defrag_limit to /proc/sys/vm/slab_defrag_limit
- Add a patch that obsoletes SLAB and explains why SLOB does not support
  defrag (Either of those could be theoretically equipped to support
  slab defrag in some way but it seems that Andrew/Linus want to reduce
  the number of slab allocators).

V10->V11
- Simplify determination when to reclaim: Just scan over all partials
  and check if they are sparsely populated.
- Add support for performance counters
- Rediff on top of current slab-mm.
- Reduce frequency of scanning. A look at the stats showed that we
  were calling into reclaim very frequently when the system was under
  memory pressure which slowed things down. Various measures to
  avoid scanning the partial list too frequently were added and the
  earlier (expensive) method of determining the defrag ratio of the slab
  cache as a whole was dropped. I think this addresses the issues that
  Mel saw with V10.

V9->V10
- Rediff against upstream

V8->V9
- Rediff against 2.6.24-rc6-mm1

V7->V8
- Rediff against 2.6.24-rc3-mm2

V6->V7
- Rediff against 2.6.24-rc2-mm1
- Remove lumpy reclaim support. No point anymore given that the antifrag
  handling in 2.6.24-rc2 puts reclaimable slabs into different sections.
  Targeted reclaim never triggers. This has to wait until we make
  slabs movable or we need to perform a special version of lumpy reclaim
  in SLUB while we scan the partial lists for slabs to kick out.
  Removal simplifies handling significantly since we
  get to slabs in a more controlled way via the partial lists.
  The patchset now provides pure reduction of fragmentation levels.
- SLAB/SLOB: Provide inlines that do nothing
- Fix various smaller issues that were brought up during review of V6.

V5->V6
- Rediff against 2.6.24-rc2 + mm slub patches.
- Add reviewed by lines.
- Take out the experimental code to make slab pages movable. That
  has to wait until this has been considered by Mel.

V4->V5:
- Support lumpy reclaim for slabs
- Support reclaim via slab_shrink()
- Add constructors to insure a consistent object state at all times.

V3->V4:
- Optimize scan for slabs that need defragmentation
- Add /sys/slab/*/defrag_ratio to allow setting defrag limits
  per slab.
- Add support for buffer heads.
- Describe how the cleanup after the daily updatedb can be
  improved by slab defragmentation.

V2->V3
- Support directory reclaim
- Add infrastructure to trigger defragmentation after slab shrinking if we
  have slabs with a high degree of fragmentation.

V1->V2
- Clean up control flow using a state variable. Simplify API. Back to 2
  functions that now take arrays of objects.
- Inode defrag support for a set of filesystems
- Fix up dentry defrag support to work on negative dentries by adding
  a new dentry flag that indicates that a dentry is not in the process
  of being freed or allocated.


-- 
