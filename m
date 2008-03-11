Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYCKKxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYCKKxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYCKKwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:52:45 -0400
Received: from phunq.net ([64.81.85.152]:44386 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755932AbYCKKwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:52:43 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Stacking bio support
Date: Tue, 11 Mar 2008 02:52:40 -0800
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110352.41479.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or: The Head of the Axe

With a nice shiny new interface paradigm in hand that can be easily 
adapted to a variety of alternate back ends[1], let me now supply an 
important building block for such a back end.  This three patch series 
improves both the existing block layer and device mapper without 
disrupting anything, and lays the groundwork for generalizing the block 
layer to be much more flexible than it is now.  The ultimate goal of 
this effort is a complete merge of device mapper capabilities into the 
generic block layer, which could equally well be called lvm3 or bio2.  
While admittedly an ambitious undertaking, I should not need to explain 
why it is necessary, or why one cannot get to the end of a long road 
without taking the first step.

This patch set adds support for block device stacking to the block io 
layer.  Due to tightening up some code and removing unnecessary slab 
objects, the patch set as a whole reduces core kernel size slightly.  
Further code size reductions can be expected as things progress, and 
modest memory savings as well.

1: bio.single.alloc-2.6.23.12

This patch eliminates 50% of the slab allocations in the bio fast path, 
tightens up some code, and turns struct bio into a variable sized 
object.  It replaces the bio slab by an array of bio slabs and removes 
the existing biovec slab array.  A small amount of system memory is 
saved and some code is removed.

diffstat patch/1/bio.single.alloc-2.6.23.12
 drivers/md/dm.c     |    2
 fs/bio.c            |  187 
++++++++++++++--------------------------------------
 include/linux/bio.h |    2
 3 files changed, 54 insertions(+), 137 deletions(-)

2: bio.hide.endio-2.6.23.12

In preparation for moving the bio endio function pointer from a fixed 
location in the bio to a location on the internal stack, direct 
structure references to the bio endio field are disallowed.  This patch 
renames the endio field, introduces wrappers to get/put field contents, 
and edits all existing references to the field to go through the 
wrappers.

This is a large patch, consisting entirely of trivial changes.  May I 
have some volunteer proofreading on this, please?  With this many edits 
there are sure to be a few slips.  Not all of the affected files have 
even been compiled.  I would appreciate very much if interested 
observers would volunteer.

diffstat patch/2/bio.hide.endio-2.6.23.12
 block/ll_rw_blk.c            |    6 ++---
 drivers/block/floppy.c       |    2 -
 drivers/block/pktcdvd.c      |    8 +++----
 drivers/md/dm-crypt.c        |    2 -
 drivers/md/dm-emc.c          |    2 -
 drivers/md/dm-io.c           |    2 -
 drivers/md/dm.c              |    2 -
 drivers/md/faulty.c          |    4 +--
 drivers/md/md.c              |    6 ++---
 drivers/md/multipath.c       |    4 +--
 drivers/md/raid1.c           |   44 
+++++++++++++++++++++----------------------
 drivers/md/raid10.c          |   24 +++++++++++------------
 drivers/md/raid5.c           |   18 ++++++++---------
 drivers/s390/block/xpram.c   |    2 -
 drivers/scsi/scsi_lib.c      |    2 -
 fs/bio.c                     |   12 +++++------
 fs/block_dev.c               |    2 -
 fs/buffer.c                  |    2 -
 fs/direct-io.c               |    4 +--
 fs/gfs2/super.c              |    3 --
 fs/jfs/jfs_logmgr.c          |    4 +--
 fs/jfs/jfs_metapage.c        |    4 +--
 fs/mpage.c                   |    4 +--
 fs/ocfs2/cluster/heartbeat.c |    2 -
 fs/xfs/linux-2.6/xfs_aops.c  |    6 ++---
 fs/xfs/linux-2.6/xfs_buf.c   |    4 +--
 include/linux/bio.h          |   12 ++++++++++-
 kernel/power/swap.c          |    2 -
 mm/bounce.c                  |    8 +++----
 mm/page_io.c                 |    2 -
 30 files changed, 104 insertions(+), 95 deletions(-)

3: bio.stack-2.6.23.12

This adds an internal stack to each struct bio and introduces two new 
bio operations:

        data = bio_push(bio, worksize, endio);
        data = bio_pop(bio);

The first is used before submitting a bio and the second is used in the 
endio handler, which gives the driver a nice way to share context 
between the two events.  If the requested amount stack space is not 
available in the bio, the bio stack is automatically extended.

Currently the stack size in the bio is set to zero and is always 
extended on the first bio_push.  An upcoming revision will add a 
mechanism for a block driver to specify the initial amount of stack 
space it knows will always be needed.  Some time further in the future, 
a mechanism for discovering the stack requirements of several block 
devices in a stack may be added, so that a typical bio submission is 
able to traverse the entire stack with only a single bio allocation.  
(I learned from Andreas Dilger last month at FAST that Lustre already 
implements a mechanism along these lines.)

In addition to stacking context data, the bio endio handler is also 
placed on the stack.  This reflects the fact that the only valid 
purpose for putting data on the bio stack is to communicate it to a 
stacked endio handler, so it makes sense to set the endio handler at 
the same time as allocating stack space.

It is not as clear whether the bio target device should be moved to the 
stack as well.  If it were, the generic endio handler could easily 
account congestion data etc for the device to which the bio was 
submitted.  For now, this field just stays as it was.

This patch changes the wrapper functions introduced in the previous 
patch to access the endio function through the stack instead of a 
direct field lookup.  

As currently implemented, an empty bio stack adds eight bytes to a bio 
on a 32 bit machine.  The expectation is that considerably more memory 
in stacking drivers will be saved in return.  (As it happens, this size 
increase disappears in the noise of slab alignment effects, but all the 
same...)  A bio variant could be created without any stack for the 
common case of direct bio submission to a nonstacking driver, though 
the expected memory saving is arguably not worth the effort.

The fast path of the bio stacking code looks like this:

void *bio_push(struct bio *bio, unsigned size, bio_end_io_t *endio)
{
        struct bioframe *frame = bio->bi_stack;
        size += sizeof(struct bioframe);
        size += -size & (BIOSTACK_ALIGN - 1);
        bio->bi_stack += size;
        *(struct bioframe *)bio->bi_stack = (struct bioframe){
                .stacksize = frame->stacksize - size,
                .framesize = size, .endio = endio };
        return frame->space;
}

void *bio_pop(struct bio *bio)
{
        struct bioframe *frame = bio->bi_stack;
        frame = bio->bi_stack -= frame->framesize;
        return frame->space;
}

For the push, just an 8 byte structure assignment, add to memory and 
some arithmetic.  The pop is just an add to memory.  Both are lockless 
and cacheline efficient.  The slab allocations that will be replaced by 
this mechanism are not lockless.

diffstat patch/3/bio.stack-2.6.23.12
 fs/bio.c            |   48 
++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |   11 +++++++++--
 2 files changed, 57 insertions(+), 2 deletions(-)

Results

Booting a typical workstation to a graphical desktop with a vanilla 
2.6.23.13 kernel leaves the slabs looking like this:

cat /proc/slabinfo | grep bio | cut -b-38
biovec-256             2      2   3072
biovec-128             2      5   1536
biovec-64              4     10    768
biovec-16              5     15    256
biovec-4              11     59     64
biovec-1              59    203     16
bio                   96    150    128

Ater bio.bvec.combine, thinks look a little different:

cat /proc/slabinfo | grep bio | cut -b-38
bio-256                2      2   3200
bio-128                2      4   1664
bio-64                16     16    896
bio-16                20     20    384
bio-4                 30     30    128
bio-1                 90    150    128

The original bio slab is gone and the biovec slabs have been replaced by 
bio slabs with slightly larger object size.  (The slab object size 
distribution will eventually be retuned so that the smallest slabs are 
not same size when rounded to a hardware cache line boundary.)

After bio.stack, the slabs look like:

cat /proc/slabinfo | grep bio | cut -b-38
biospace               0      0    128
bio-256                2      2   3200
bio-128                2      4   1664
bio-64                 5     16    896
bio-16                 9     20    384
bio-4                  6     30    128
bio-1                120    150    128

A new biospace slab has appeared to hold bio stack extension, otherwise 
things look much the same.

4: dm.reduce.allocs-2.6.23.12

Each bio submitted to a device mapper device currently requires a 
minimum of six slab allocations:

   * Submitter creates the original bio (2 slab allocations)

   * device mapper makes a clone of the bio (2 slab allocations)

   * device mapper allocates a dm_io and a dm_target_io structure,
     attaches the dm_target_io to the dm_io and attaches the dm_io
     to the private pointer of the clone (2 slab allocations)

Each additional layer in a stacked device adds at least four more 
allocations.  Further allocations are typically done inside the target 
driver, for example, ddsnap does at least one additional allocation for 
all bio transfers except origin reads.

Thus, for a simple stack consisting of a ddsnap driver on top of an lvm 
partition a minimum of 11 slab allocations take place each time a bio 
travels down the stack.  The object of the fourth patch in this set is 
to reduce this to a single allocation per bio in the common case, by 
taking advantage of the bio stacking functionality implemented in the 
first three patches.

The bio.single.alloc patch removes three slab allocations by allowing a 
bio or a clone to be created with a single allocation instead of two.  
The dm.reduce.allocs patch, when finished, will replace the three slab 
allocations at each device mapper level with a single call to bio_push.  
Finally, ddsnap can be modified to use bio_push instead of allocating a 
hook structure, which arrives at the desired single allocation for the 
entire path.

All About Clone_and_Map

Each device mapper virtual device is actually a concatenation of device 
mapper targets.  Device mapper has to handle the case where an incoming 
bio has to be split across an arbitrary number of target devices that 
it overlaps.  This is implemented in the call chain:

    dm_request  -> 
        __split_bio ->
            __clone_and_map ->
                __map_bio

The __clone_and_map function is the one of interest (note the CRUD START 
and CRUD END comments in dm.c.).

Device mapper proceeds by working from beginning to end of the original 
bio, creating and submitting clone bios that do not cross target 
boundaries until the remainder fits entirely within a single target.  
The final case is the common one, and in fact the only case when the 
virtual device has a single target.  Today's patch optimizes the 
remainder case to use the push/pop mechanism to allow the original bio 
to be resubmitted instead of submitting a clone.  The other cases are 
left alone for now, so the code does not actually get smaller yet.   
But you can compare my new "dm_map" function to the __map_bio function 
used by the clones and see that it is quite a bit shorter already, and 
so is the code that drives it from __clone_and_map.

In the general case where a bio crosses target boundaries, cloning 
cannot be avoided because we want to initiate multiple dependent 
transfers in parallel.  However, the dm_io and dm_target_io allocations 
can be replaced by stack allocations within the bio.

Finally, the whole call chain above can be cleaned up considerably, 
because it really should be a single function, and suffers from 
considerable fluff associated with communicating between the wrongly 
factored pieces.  The result will look lot like what the generic bio 
layer needs in order to do the tricks that device mapper does.

In passing I have to say that __clone_and_map, apart from looking pretty 
ugly, is a really nice hack.  Joe Thornber surely got out of the right 
side of bed the day he dreamed that up.  It is just too bad that our 
little community managed to annoy him so much that he ran off to work 
in a bank, thus depriving us of further insights from him, and leaving 
Device Mapper core in a state of suspended animation for the last four 
years while Sun did not stand still.  Food for thought.

Finally

Once again, thankyou intrepid reader for reading all the way to here.  I 
have heard at least one complaint that my posts are too long.  Well, I 
have this to say about that: if you think today's post is a lot of 
words to read, don't even think about reading War and Peace :-)

Stay tuned for more yummy patches on the road to lvm3.

[1] ddsetup, http://lkml.org/lkml/2008/3/5/82, An alternative interface 
to device mapper

http://zumastor.org/lvm3/bio.single.alloc-2.6.23.12
http://zumastor.org/lvm3/bio.hide.endio-2.6.23.12
http://zumastor.org/lvm3/bio.stack-2.6.23.12
http://zumastor.org/lvm3/dm.reduce.allocs-2.6.23.12
