Return-Path: <linux-kernel-owner+w=401wt.eu-S1031422AbXDZSU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031422AbXDZSU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031426AbXDZSU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:20:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:34131 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031422AbXDZSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:20:53 -0400
X-IronPort-AV: i="4.14,456,1170662400"; 
   d="scan'208"; a="141007850:sNHT54130176"
To: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: What's in infiniband.git for 2.6.22
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 26 Apr 2007 11:20:48 -0700
Message-ID: <adaps5rro8v.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Apr 2007 18:20:48.0289 (UTC) FILETIME=[9D0A5910:01C7882F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a short summary of what my plans for 2.6.22 are.  For
reference, everything is in my git tree:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git

Please let me know if you have any thoughts on these plans, or if
there is something that you feel is missing from this list.

* mlx4 driver for new Mellanox ConnectX HCAs.  This is the connectx
  branch in git.  I will merge this soon, after a few more cleanups
  and one final posting for review.  There are actually two parts here:

  - "IB/uverbs: Export ib_umem_get()/ib_umem_release() to modules"
    This touches the core and all drivers, but I think it is a better
    design and actually helps other drivers too in addition to being a
    prerequisite for the mlx4 driver.  I haven't heard anyone speak
    out against it so I plan to go ahead and merge it.

  - "IB/mlx4: Add driver for Mellanox ConnectX HCAs"
    I'll fold all the mlx4_core and mlx4_ib code into this patch and
    merge it.

  - "mlx4_eth: Add 10 gigabit ethernet driver for Mellanox ConnectX"
    This will NOT be merged for 2.6.22 at least.  For one thing it is
    pretty much just a stub that doesn't do anything useful.  When
    there is working 10 gig support, I'll post this to lkml and netdev
    for review, but this is 2.6.23 stuff at the soonest.

* IPoIB NAPI work.  This is the ipoib branch in git.  Again, there are
  really two parts here:

  - "IB: Return "maybe missed event" hint from ib_req_notify_cq()"
    This extends the API in a way that lets us implement NAPI, but may
    be useful for other things too.  It touches all the drivers, and I
    still need to finish updating cxgb3 to work correctly.  I haven't
    heard anything negative about this, so I'll fix it up, post it one
    more time for review, and plan on merging it.

  - "IPoIB: Convert to NAPI"
    This is the actual conversion of IPoIB to use NAPI, based on the
    previous extension to ib_req_notify_cq().  There seems to be a
    need to merge this, based on people's experiences with congestion
    collapse under high load.  So I'm planning on merging this too.

* I also have the following bunch  of more minor patches queued, and I
  will ask Linus to pull them soon.  The majority of them are ipath
  fixes (and I hope Qlogic will send fixes for the two other bugs that
  I know of, namely corrupting the list of pending mmaps if an object
  is destroyed before userspace mmaps it, and doing spin_lock_irq()
  from interrupt context).  There are a few other cleanups and minor
  fixes scattered around.  Here's the shortlog of the for-2.6.22 branch:

    Arthur Jones (2):
          IB/ipath: Call free_irq() on chip specific initialization failure
          IB/ipath: Force PIOAvail update entry point

    Bryan O'Sullivan (17):
          IB/ipath: Add ability to set and clear IB local loopback
          IB/ipath: Fix user memory region creation when IOMMU present
          IB/ipath: Definitions of two RXE parity err bits were reversed
          IB/ipath: Fix up some debug messages
          IB/ipath: Change packet problems vs chip errors handling and reporting
          IB/ipath: Fix bad argument to clear_bit()
          IB/ipath: Fix CQ flushing when QP is modified to error state
          IB/ipath: Remove unused ipath_read_kreg64_port()
          IB/ipath: Fix calculation for number of kernel PIO buffers
          IB/ipath: Discard multicast packets without a GRH
          IB/ipath: Print better error messages if kernel is misconfigured
          IB/ipath: Improve handling and reporting of parity errors
          IB/ipath: On unrecoverable errors, force link down, LEDs off
          IB/ipath: Prevent random program use of diags interface
          IB/ipath: Disable IB link earlier in shutdown sequence
          IB/ipath: Don't allow QPs 0 and 1 to be opened multiple times
          IB/ipath: Fix unit selection when all CPU affinity bits set

    Hal Rosenstock (3):
          IB/umad: Fix declaration of dev_map[]
          IB/mad: Change SMI to use enums rather than magic return codes
          IB/umad: Clarify documentation of transaction ID

    Joachim Fenkes (2):
          IB/ehca: Implement modify_port
          IB: Set class_dev->dev in core for nice device symlink

    Mark Debbage (1):
          IB/ipath: Allow receive ports mapped into userspace to be shared

    Michael Albaugh (1):
          IB/ipath: Fix driver crash (in interrupt or during unload) after chip reset

    Ralph Campbell (8):
          IB/ipath: Don't initialize port memory for subports
          IB/ipath: Fix SRQ limit event causing dropped CQ entry
          IB/ipath: NMI cpu lockup if local loopback used
          IB/ipath: Support larger IB_QP_MAX_DEST_RD_ATOMIC and IB_QP_MAX_QP_RD_ATOMIC
          IB/ipath: Fix QP error completion queue entries
          IB/ipath: Fix PSN update for RC retries
          IB/ipath: Fix port sharing on powerpc
          IB/ipath: Fix RDMA reads of length zero and error handling

    Robert Walsh (4):
          IB/ipath: Check reserved memory keys
          IB/ipath: Remove duplicate stuff from ipath_verbs.h
          IB/ipath: Check that a UD work request's address handle is valid
          IB/ipath: Fix WC format drift between user and kernel space

    Roland Dreier (6):
          IB: Remove reference to obsolete CONFIG_IPATH_CORE
          IPoIB: Remove pointless opcode field from debugging output
          IB/mthca: Update HCA firmware revisions
          IB/mthca: Fix mthca_write_mtt() on HCAs with hidden memory
          IB/mthca: Simplify CQ cleaning in mthca_free_qp()
          IPoIB/cm: spin_lock_irqsave() -> spin_lock_irq() replacements

    Sean Hefty (5):
          RDMA/ucma: Simplify ucma_get_event()
          IB/ucm: Simplify ib_ucm_event()
          IB/sa: Set src_path_bits correctly in ib_init_ah_from_path()
          IB/ipoib: Use ib_init_ah_from_path to initialize ah_attr
          IB/umad: Implement GRH handling for sent/received MADs
