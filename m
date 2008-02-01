Return-Path: <linux-kernel-owner+w=401wt.eu-S934273AbYBAFGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbYBAFGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758141AbYBAFGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:06:25 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49308 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754158AbYBAFGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:06:24 -0500
Message-Id: <20080201050439.009441434@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 31 Jan 2008 21:04:39 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 0/4] [RFC] EMMU Notifiers V5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patchset implementing MMU notifier callbacks based on Andrea's
earlier work. These are needed if Linux pages are referenced from something
else than tracked by the rmaps of the kernel (an external MMU).

The known immediate users are

KVM
- Establishes a refcount to the page via get_user_pages().
- External references are called spte.
- Has page tables to track pages whose refcount was elevated(?) but
  no reverse maps.

GRU
- Simple additional hardware TLB (possibly covering multiple instances of
  Linux)
- Needs TLB shootdown when the VM unmaps pages.
- Determines page address via follow_page (from interrupt context) but can
  fall back to get_user_pages().
- No page reference possible since no page status is kept..

XPmem
- Allows use of a processes memory by remote instances of Linux.
- Provides its own reverse mappings to track remote pte.
- Established refcounts on the exported pages.
- Must sleep in order to wait for remote acks of ptes that are being
  cleared.



Known issues:

- RCU quiescent periods are required on registering
  notifiers to guarantee visibility to other processors.

Andrea's mmu_notifier #4 -> RFC V1

- Merge subsystem rmap based with Linux rmap based approach
- Move Linux rmap based notifiers out of macro
- Try to account for what locks are held while the notifiers are
  called.
- Develop a patch sequence that separates out the different types of
  hooks so that we can review their use.
- Avoid adding include to linux/mm_types.h
- Integrate RCU logic suggested by Peter.

V1->V2:
- Improve RCU support
- Use mmap_sem for mmu_notifier register / unregister
- Drop invalidate_page from COW, mm/fremap.c and mm/rmap.c since we
  already have invalidate_range() callbacks there.
- Clean compile for !MMU_NOTIFIER
- Isolate filemap_xip strangeness into its own diff
- Pass a the flag to invalidate_range to indicate if a spinlock
  is held.
- Add invalidate_all()

V2->V3:
- Further RCU fixes
- Fixes from Andrea to fixup aging and move invalidate_range() in do_wp_page
  and sys_remap_file_pages() after the pte clearing.

V3->V4:
- Drop locking and synchronize_rcu() on ->release since we know on release that
  we are the only executing thread. This is also true for invalidate_all() so
  we could drop off the mmu_notifier there early. Use hlist_del_init instead
  of hlist_del_rcu.
- Do the invalidation as begin/end pairs with the requirement that the driver
  holds off new references in between.
- Fixup filemap_xip.c
- Figure out a potential way in which XPmem can deal with locks that are held.
- Robin's patches to make the mmu_notifier logic manage the PageRmapExported bit.
- Strip cc list down a bit.
- Drop Peters new rcu list macro
- Add description to the core patch

V4->V5:
- Provide missing callouts for mremap.
- Provide missing callouts for copy_page_range.
- Reduce mm_struct space to zero if !MMU_NOTIFIER by #ifdeffing out
  structure contents.
- Get rid of the invalidate_all() callback by moving ->release in place
  of invalidate_all.
- Require holding mmap_sem on register/unregister instead of acquiring it
  ourselves. In some contexts where we want to register/unregister we are
  already holding mmap_sem.
- Split out the rmap support patch so that there is no need to apply
  all patches for KVM and GRU.

-- 
