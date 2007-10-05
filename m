Return-Path: <linux-kernel-owner+w=401wt.eu-S1764689AbXJEXSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764689AbXJEXSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbXJEXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:18:45 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52442 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXJEXSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:18:43 -0400
X-IronPort-AV: E=Sophos;i="4.21,237,1188802800"; 
   d="scan'208";a="231527716"
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Updated InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 05 Oct 2007 16:18:42 -0700
Message-ID: <adaodfdkv59.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Oct 2007 23:18:42.0857 (UTC) FILETIME=[12087990:01C807A6]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.23 still isn't out, and I've managed to reduce my patch
review backlog a bit, it's probably a good idea to give another update
about what I have queued for 2.6.24 already and what I hope to get to
before the merge window opens.

Core:

 - My user_mad P_Key index support patch.  Merged this, although I
   still owe Sasha a patch to update libraries to use this.

 - A fix to the user_mad 32-bit big-endian userspace 64/32 problem
   with the method_mask when registering agents.  Merged.

 - Sean's QoS changes.  Merged.

 - Sean's IB CM MRA interface changes.  I merged these -- what the
   heck, if it breaks we can back them out.

ULPs:

 - Pradeep's IPoIB CM support for devices that don't have SRQs.  Sean
   started reviewing but I didn't see any updated patches.

 - Moni's IPoIB bonding support.  Seems like we found a clean set of
   changes, and these will go in via another (Jeff Garzik's?) tree.

 - Rolf's IPoIB MGID scope changes.  No review progress here.

 - Eli and Michael's IPoIB stateless offload (checksum offload, LSO,
   LRO, etc).  Not much review progress here; I'll try to chip away at
   the series and see what we can get into 2.6.24.

 - Or's IPoIB/userspace multicast coexistence stuff.  I think we've
   converged on this; I'll merge this once a final version of the
   patch appears.

HW specific:

 - I already merged patches to enable MSI-X by default for mthca and
   mlx4.  I hope there aren't too many systems that get hosed if a
   MSI-X interrupt is generated.

 - Jack and Michael's mlx4 FMR support.  Merged.  I guess the fix for
   running in Xen domU may need to wait for 2.6.25, but I'll see what
   I can do.

 - ehca patch queue.  Merged everything I think.

 - Steve's mthca router mode support.  No one looked at it, seems like
   it's at risk of missing the window.

 - Arthur's mthca doorbell alignment fixes.  I still need to check
   various approaches;  I'll definitely merge something for 2.6.24.

 - Michael's mlx4 WQE shrinking patch.  May miss the window and go for
   2.6.25, I'll see if I can get to it.

Here are a few topics that I believe will not be ready in time for the
2.6.24 window and will need to wait for 2.6.25:

 - Multiple CQ event vector support.  I haven't seen any discussions
   about how ULPs or userspace apps should decide which vector to use,
   and hence no progress has been made since we deferred this during
   the 2.6.23 merge window.

 - XRC.  Given the length of the backlog above and the fact that a
   first draft of this code has not been posted yet, I don't see any
   way that we could have something this major ready in time.

BOILERPLATE
===========

I keep patches in a git tree, available from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git

There are several branches of interest in this tree:

    for-2.6.23 - changes queued for merging into the current kernel release
    for-2.6.24 - changes queued for the next merge window
    for-linus  - changes I have asked Linus to pull upstream
    for-mm     - pulled by Andrew for inclusion in -mm

I frequently rewrite history and rebase my tree, so the best way to
track it is to keep a clone of Linus's tree around and then pull a
fresh copy of my tree with

    git clone --reference /path/to/linus/tree \
        git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git

If you would like me to merge a patch, please send it to me as soon as
it is ready.  Do NOT wait for the merge window to open; if your change
is not strictly a fix and you send it to me after the merge window
opens, then it will likely have to wait for the next merge window.
Please let me know if your patch is a fix that should go into the
current release or if it can wait for the next merge window; if it is
a fix, please describe the severity of the issue your are fixing, so I
can make a good judgement about which release it should go into.

Including a good changelog entry that explains what you are changing,
why you are changing it, and how your change accomplishes your goal
will greatly increase the chance of your patch being merged promptly.
Getting an independent review and a Reviewed-by: line also helps a lot.

The files Documentation/SubmittingPatches and Documentation/SubmitChecklist
in kernel source tree also have a lot of good advice that makes it
easier for me to handle your patches.

DETAILS
=======

Here is the complete list of patches I have in my for-2.6.24 branch:

Ali Ayoub (1):
      IB/sa: Error handling thinko fix

Anton Blanchard (3):
      IB/fmr_pool: Clean up some error messages in fmr_pool.c
      IB/ehca: Make output clearer by removing some debug messages
      IB/ehca: Export module parameters in sysfs

Dotan Barak (1):
      mlx4_core: Use enum value GO_BIT_TIMEOUT_MSECS

Eli Cohen (2):
      IPoIB: Fix typo to end statement with ';' instead of ','
      IPoIB: Fix error path memory leak

Hoang-Nam Nguyen (4):
      IB/ehca: Use remap_4k_pfn() to map firmware contexts to user space
      IB/ehca: Fix large page HW cap defines
      IB/ehca: Fix mem leak of firmware ctrlblock in ehca_create_srq()
      IB/ehca: Adjust 64-bit alignment of create QP response for userspace

Jack Morgenstein (5):
      IB/mlx4:  Display misc device information under /sys/class/infiniband/
      mlx4_core: Support ICM tables in coherent memory
      mlx4_core: Write MTTs from CPU instead with of WRITE_MTT FW command
      IB/mlx4: Implement FMRs
      mlx4_core: Increase max number of QPs per multicast group to 56

Joachim Fenkes (11):
      IB/ehca: Refactor hvcall tracing
      IB/ehca: Print return codes as signed decimal integers
      IB/ehca: ehca_gen_warn() should always print
      IB/ehca: Add check for max #SGE to create_qp()
      IB/ehca: Path migration support
      IB/ehca: Serialize MR alloc and MR free hvCalls
      IB/ehca: Replace get_paca()->paca_index by the more portable raw_smp_processor_id()
      IB/ehca: Bump version number and change its format
      IB/umem: Add hugetlb flag to struct ib_umem
      IB/ehca: Only use MR large pages for hugetlb regions
      IB/ehca: Return srq_attr->max_sge in ehca_query_srq()

Michael S. Tsirkin (2):
      mlx4_core: Enable MSI-X by default
      IB/mthca: Enable MSI-X by default

Peter Oruba (1):
      IB/mthca: Use PCI-X/PCI-Express read control interfaces

Ralph Campbell (1):
      IB/core: Fix handling of multicast response failures

Roland Dreier (14):
      IPoIB: Make sure no receives are handled when stopping device
      IB: find_first_zero_bit() takes unsigned pointer
      mlx4_core: Don't free special QPs in QP number bitmap
      IB/mlx4: Use __set_data_seg() in mlx4_ib_post_recv()
      IB/ehca: Include <linux/mutex.h> from ehca_classes.h
      IB/mlx4: Fix up SRQ limit_watermark endianness
      IB/iser: Remove unnecessary includes
      mlx4_core: Change capability decoding: SRC->XRC
      IB/umad: Add P_Key index support
      IB/umad: Fix bit ordering and 32-on-64 problems on big endian systems
      IB/uverbs: Make ib_uverbs_release_event_file() static
      mlx4_core: Reserve the correct number of MTT segments
      mlx4_core: Fix meaning of dev->caps.reserved_mtts
      IB/mthca: Increase max number of QPs per multicast group to 56

Satyam Sharma (1):
      IB/ehca: Misc cpuinit section annotations and #ifdef cleanups

Sean Hefty (7):
      IPoIB: Specify Traffic Class with path record queries for QoS support
      IB/sa: Add new QoS fields to path record
      RDMA/cma: Add ability to specify type of service
      RDMA/ucma: Allow user space to set service type
      IB/srp: Add QoS support through service ID
      IB/cm: Modify interface to send MRAs in response to duplicate messages
      RDMA/cma: Queue IB CM MRAs to avoid unnecessary remote retries

Stefan Roscher (2):
      IB/ehca: Small QP userspace support
      IB/ehca: Support more than 4k QPs for userspace and kernelspace

Steve Wise (2):
      RDMA/cxgb3: Make the iw_cxgb3 module parameters writable
      RDMA/cma: Use neigh_event_send() to start neighbour discovery
