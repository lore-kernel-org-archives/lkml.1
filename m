Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYGNFQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYGNFQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 01:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYGNFQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 01:16:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:57320 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYGNFQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 01:16:10 -0400
X-IronPort-AV: E=Sophos;i="4.30,357,1212364800"; 
   d="scan'208";a="126271235"
From: Roland Dreier <rdreier@cisco.com>
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: InfiniBand/RDMA merge plans for 2.6.27
X-Message-Flag: Warning: May contain useful information
Date: Sun, 13 Jul 2008 22:16:08 -0700
Message-ID: <ada8ww5jbaf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Jul 2008 05:16:08.0572 (UTC) FILETIME=[B92A63C0:01C8E570]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been a little lazy about writing this, and 2.6.26 is already out,
so it's time to review what my plans are for the merge window opens.

I have to say that I've been somewhat disappointed with the quality of
things this cycle.  Maybe I've just been in a tetchy mood these days,
but before you send me an email saying, "this is ready to go, when are
you going to merge it," please try doing some of the following;

 - Run your patch through checkpatch.pl so I don't have to nag you to
   fix trivial issues (or spend time fixing them myself).

 - Read your patch over so I don't see a memory leak or deadlock as
   soon as I look at it.

 - Build your patch with sparse checking ("C=2 CF=-D__CHECK_ENDIAN__")
   and make sure it doesn't introduce new warnings.  (A big bonus in
   goodwill for sending patches that fix old warnings)

 - Test your patch on a kernel with things like slab debugging and
   lockdep turned on.

And while you're waiting for me to get to your patch, I sure wouldn't
mind if you read and commented on someone else's patch.  None of this
means you shouldn't remind me about pending patches, since I often
lose track of things and drop them accidentally.

Anyway, here are all the pending things that I'm aware of.  As usual,
if something isn't already in my tree and isn't listed below, I
probably missed it or dropped it by mistake.  Please remind me again
in that case.

Core:

 - I'm waiting to merge the RDMA_CM_EVENT_ADDR_CHANGE changes that
   depend on core networking changes until such changes are upstream.
   Or, please remind me when that happens.

 - Jack's XRC patch set.  I think we're getting closer to converging
   here, and I hope to get this merged but we're getting down to the
   wire, so we'll see.

ULPs:

 - I merged a decent amount of stuff for IPoIB, including LRO,
   "loopback blocking," and better handling of fabric events, and I
   don't think I have anything pending.

HW specific:

 - Yevgeny's mlx4 changes.  We'll see how much time is left after I
   get done with XRC (which is before this on my list) but to be
   honest I'm not sure how mergeable a lot of this is without the
   mlx4_en patches that actually use it.

 - I've been working on memory management extensions support for mlx4,
   but I'm not sure if it will be ready in time.  Firmware for this
   may not be released for a while so it ain't urgent anyway.

Here are a few topics that I believe will not be ready in time for the
2.6.27 window and will need to wait for 2.6.28 at least:

 - Remove LLTX from IPoIB.  I haven't had time to finish this yet, so
   I guess it will probably wait for 2.6.28 now...

 - Multiple CQ event vector support.  No one has convinced me that we
   know how ULPs or userspace apps should decide which vector to use,
   and hence little progress has been made since we deferred this
   during the 2.6.23 merge window.

Here all the patches I already have in my for-2.6.27 branch:

Christophe Jaillet (1):
      RDMA/nes: Remove unnecessary memset()

Dotan Barak (1):
      RDMA: Improve include file coding style

Eli Cohen (12):
      IB/mlx4: Optimize QP stamping
      IPoIB: Copy small received SKBs in connected mode
      IB/mlx4: Configure QPs' max message size based on real device capability
      IB/mlx4: Pass congestion management class MADs to the HCA
      IPoIB: Remove unused IPOIB_MCAST_STARTED code
      IPoIB: Remove priv->mcast_mutex
      IPoIB: Only set Q_Key once: after joining broadcast group
      IPoIB: Use rtnl lock/unlock when changing device flags
      IPoIB: Use dev_set_mtu() to change mtu
      IPoIB/cm: Reduce connected mode TX object size
      IPoIB: Double default RX/TX ring sizes
      IB/mlx4: Use kzalloc() for new QPs so flags are initialized to 0

Joachim Fenkes (2):
      IB/ehca: Reject receive work requests if QP is in RESET state
      IB/ehca: Make device table externally visible

Jon Mason (1):
      RDMA/cxgb3: Propagate HW page size capabilities

Moni Shoua (2):
      IB/sa: Fail requests made while creating new SM AH
      IPoIB: Refresh paths instead of flushing them on SM change events

Or Gerlitz (2):
      RDMA/addr: Keep pointer to netdevice in struct rdma_dev_addr
      RDMA/cma: Simplify locking needed for serialization of callbacks

Ralph Campbell (2):
      IB/core: Reset to error QP state transition is not allowed
      IB/ipath: Use IEEE OUI for vendor_id reported by ibv_query_device()

Robert P. J. Day (1):
      IB/ipath: Simplify code using ARRAY_SIZE() macro

Roland Dreier (13):
      IB/srp: Remove use of cached P_Key/GID queries
      RDMA: Remove subversion $Id tags
      IB/mthca: Remove extra code for RESET->ERR QP state transition
      IB/mlx4: Remove extra code for RESET->ERR QP state transition
      RDMA/cxgb3: Remove write-only iwch_rnic_attributes fields
      RDMA/cma: Add missing newlines to printk()s
      IPoIB/cm: Fix racy use of receive WR/SGL in ipoib_cm_post_receive_nonsrq()
      RDMA/nes: Encapsulate logic nes_put_cqp_request()
      RDMA/nes: Get rid of ring_doorbell parameter of nes_post_cqp_request()
      IPoIB: Get rid of ipoib_mcast_detach() wrapper
      IB/mthca: Remove "stop" flag for catastrophic error polling timer
      IB/mthca: Use round_jiffies() for catastrophic error polling timer
      IB/mthca: Fix check of max_send_sge for special QPs

Ron Livne (3):
      IB/core: Add support for multicast loopback blocking
      IB/mlx4: Add support for blocking multicast loopback packets
      IPoIB: Use multicast loopback blocking if available

Sean Hefty (1):
      RDMA: Fix license text

Stefan Roscher (1):
      IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts

Steve Wise (8):
      RDMA/core: Add memory management extensions support
      RDMA/cxgb3: MEM_MGT_EXTENSIONS support
      RDMA/cxgb3: Fix up some ib_device_attr fields
      RDMA/core: Add iWARP protocol statistics attributes in sysfs
      RDMA/cxgb3: Add support for protocol statistics
      RDMA/cxgb3: Set rkey field for new memory windows in iwch_alloc_mw()
      RDMA/core: Add local DMA L_Key support
      RDMA/cxgb3: Fixes for zero STag

Vladimir Sokolovsky (2):
      IPoIB: add LRO support
      mlx4_core: Use MOD_STAT_CFG command to get minimal page size

