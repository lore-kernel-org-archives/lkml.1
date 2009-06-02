Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZFBWeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZFBWeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZFBWdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:33:52 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:49483 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZFBWdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:33:52 -0400
X-IronPort-AV: E=Sophos;i="4.41,294,1241395200"; 
   d="scan'208";a="166660518"
From: Roland Dreier <rdreier@cisco.com>
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: InfiniBand/RDMA merge plans for 2.6.31
X-Message-Flag: Warning: May contain useful information
Date: Tue, 02 Jun 2009 15:33:53 -0700
Message-ID: <adafxeib6zy.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jun 2009 22:33:53.0884 (UTC) FILETIME=[359C41C0:01C9E3D2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.30-rc7 has been out more than a week already, it's probably
a good time to talk about 2.6.31 merge plans.  All the pending things
that I'm aware of are listed below.  (For some reason this cycle seems
to have not produced many patches -- we'll probably be very busy
reviewing things for 2.6.32)

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

 - Removal of unnecessary casts of void * to other pointer types.

 - Userspace MMU notifiers ("ummunot") -- the code looks great to me
   (since I wrote it), but I don't think this is suitable to merge
   through the InfiniBand/RDMA tree, and I think a prerequisite to even
   asking for broader review by the core kernel and VM community is to
   prove that this approach works by actually prototyping support for
   this in an MPI implementation.  I'm working with Jeff Squyres on Open
   MPI support but I suspect we're already too close to the 2.6.31
   window for this to be appropriate.  However 2.6.32 should be easily
   doable, assuming the approach I took actually works and is palatable
   to the kernel community.

ULPs:

 - One fix for IPoIB multicast packet drops.

HW specific:

 - A few cxgb3 fixes.

 - A few optimizations to ehca QP creation.

 - Add a module parameter to mthca and mlx4 to be able to register
   more memory by increasing MTT segment size.

 - A fix to an almost-impossible-to-hit off-by-one in nes.

Here are a few topics that I believe will not be ready in time for the
2.6.31 window and will need to wait for 2.6.32 at least:

 - Jack's XRC patch set.  I still need time to work through and clean
   up the code.  (I actually did make some progress on this during
   this cycle -- if you look closely you can see my xrc branch has
   changed -- but not enough to actually finish unfortunately)

Here all the patches I already have in my for-next branch:

Anton Blanchard (1):
      IB/ehca: Replace vmalloc() with kmalloc() for queue allocation

Christoph Lameter (1):
      IPoIB: Don't drop multicast packets sent before group is joined

Eli Cohen (2):
      IB/mthca: Add module parameter for number of MTTs per segment
      mlx4_core: Add module parameter for number of MTTs per segment

Jack Stone (1):
      infiniband: Remove void casts

Roel Kluin (1):
      RDMA/nes: Fix off-by-one bugs in reset_adapter_ne020() and init_serdes()

Stefan Roscher (3):
      IB/ehca: Fall back to vmalloc() for big allocations
      IB/ehca: Remove unnecessary memory operations for userspace queue pairs
      IB/ehca: Increment version number

Steve Wise (2):
      RDMA/cxgb3: Report correct port state and MTU
      RDMA/cxgb3: Limit fast register size based on T3 limitations

