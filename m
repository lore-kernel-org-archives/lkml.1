Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZIBXMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZIBXMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 19:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZIBXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 19:12:24 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:17463 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZIBXMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 19:12:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJ+YnkqrR7PD/2dsb2JhbADDQYhBAZBaBYQbgVw
X-IronPort-AV: E=Sophos;i="4.44,321,1249257600"; 
   d="scan'208";a="92902098"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       linux-rdma@vger.kernel.org
Subject: InfiniBand/RDMA merge plans for 2.6.32
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Sep 2009 16:12:24 -0700
Message-ID: <adar5upos9z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Sep 2009 23:12:24.0588 (UTC) FILETIME=[D4E6B4C0:01CA2C22]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.31-rc8 has been out more than a week already, it's probably
a good time to talk about 2.6.32 merge plans.  All the pending things
that I'm aware of are listed below.

Boilerplate:

If something isn't already in my tree and it isn't listed below, I
probably missed it or dropped it unintentionally.  Please remind me.

As usual, when submitting a patch:

 - Give a good changelog that explains what issue your patch
   addresses, how you address the issue, how serious the issue is, and
   any other information that would be useful to someone evaluating
   your patch or reading it years from now.

 - Please make sure that you include a "Signed-off-by:" line, and put
   any extra junk that should not go into the final kernel log *after*
   the "---" line so that git tools strip it off automatically.  Make
   the subject line be appropriate for inclusion in the kernel log as
   well once the leading "[PATCH ...]" stuff is stripped off.  I waste a
   lot of time fixing patches by hand that could otherwise be spent
   doing something productive like watching youtube.

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

Core:

 - Userspace MMU notifiers ("ummunotify") -- my code looks great to
   me, seems to have passed review on linux-kernel, and has spent time
   in -mm and -next.  Jeff Squyres has put together a proof-of-concept
   implementation of Open MPI support, so I think all things are go
   for asking that this be pulled into 2.6.32.  I'll send Linus a
   separate pull request for this once the merge window opens.

 - Make queue sizes tunable in the MAD module.

 - Various fixes and cleanups, including a fix for a lockdep issue in
   the MAD module.  This fix may evolve if the core kernel API grows
   __cancel_delayed_work() to help with this.

ULPs:

 - For IPoIB, I merged Jason's patch to check multicast addresses, and
   further fixes in this area may be forthcoming.

HW specific:

 - A couple of minor amso1100 cleanups/fixes.

 - A bunch of fixes to the cxgb3 and nes iWARP drivers.

 - A few ehca fixes.

 - Some mlx4 and mthca fixes, including using the PCI device name in
   interrupt names so multiple devices can be managed.

Here are a few topics that I believe will not be ready in time for the
2.6.32 window and will need to wait for 2.6.33 at least:

 - Jack's XRC patch set.  I still need time to work through and clean
   up the code.  (I actually did make some progress on this during
   this cycle -- if you look closely you can see my xrc branch has
   changed -- but not enough to actually finish unfortunately)

Here all the patches I already have in my for-next branch:

Alexander Schmidt (1):
      IB/ehca: Make port autodetect mode the default

Arputham Benjamin (2):
      mlx4_core: Distinguish multiple devices in /proc/interrupts
      IB/mthca: Distinguish multiple devices in /proc/interrupts

Chien Tung (1):
      RDMA/nes: Map MTU to IB_MTU_* and correctly report link state

Don Wood (10):
      RDMA/nes: Update refcnt during disconnect
      RDMA/nes: Allocate work item for disconnect event handling
      RDMA/nes: Change memory allocation for cqp request to GFP_ATOMIC
      RDMA/nes: Clean out CQ completions when QP is destroyed
      RDMA/nes: Add CQ error handling
      RDMA/nes: Implement Terminate Packet
      RDMA/nes: Use flush mechanism to set status for wqe in error
      RDMA/nes: Make poll_cq return correct number of wqes during flush
      RDMA/nes: Use the flush code to fill in cqe error
      RDMA/nes: Rework the disconn routine for terminate and flushing

Hal Rosenstock (1):
      IB/mad: Allow tuning of QP0 and QP1 sizes

Jack Morgenstein (3):
      IB/mthca: Don't allow userspace open while recovering from catastrophic error
      IB/mlx4: Don't allow userspace open while recovering from catastrophic error
      IB/uverbs: Return ENOSYS for unimplemented commands (not EINVAL)

Jason Gunthorpe (1):
      IPoIB: Check multicast address format

Joachim Fenkes (2):
      IB/ehca: Construct MAD redirect replies from request MAD
      IB/ehca: Fix CQE flags reporting

Marcin Slusarz (1):
      IB: Use printk_once() for driver versions

Roel Kluin (2):
      IB/ipath: strncpy() doesn't always NUL-terminate
      RDMA/amso1100: Check kmalloc() result in c2_register_device()

Roland Dreier (13):
      IPoIB: Remove unused <rdma/ib_cache.h> includes
      IB: Use DEFINE_SPINLOCK() for static spinlocks
      mlx4_core: Use pci_request_regions()
      mlx4_core: Remove unnecessary includes of <linux/init.h>
      IB/mthca: Remove unnecessary include of <asm/page.h>
      IB/mthca: Remove unnecessary include of <linux/init.h>
      ummunotify: Userspace support for MMU notifications
      IB/mad: Check hop count field in directed route MAD to avoid array overflow
      IPoIB: Drop priv->lock before calling ipoib_send()
      IB/mlx4: Annotate CQ locking
      IB/mthca: Annotate CQ locking
      IB/mad: Fix possible lock-lock-timer deadlock
      mlx4_core: Allocate and map sufficient ICM memory for EQ context

Steve Wise (5):
      RDMA/cxgb3: iwch_unregister_device leaks memory
      RDMA/cxgb3: Set the appropriate IO channel in rdma_init work requests
      RDMA/cxgb3: Handle port events properly
      RDMA/cxgb3: Don't free endpoints early
      RDMA/cxgb3: Wake up any waiters on peer close/abort

Tobias Klauser (1):
      RDMA/amso1100: Use %pM conversion specifier

Yevgeny Petrilin (1):
      mlx4_core: Avoid double free_icms

Yossi Etigin (1):
      IB/core: Fix send multicast group leave retry
