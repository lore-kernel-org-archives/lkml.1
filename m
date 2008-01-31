Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYAaE7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYAaE7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYAaE6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:58:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37160 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754803AbYAaE6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:58:14 -0500
Message-Id: <20080131045750.855008281@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 20:57:50 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com
Subject: [patch 0/3] [RFC] MMU Notifiers V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope this is finally a release that covers all the requirements. Locking
description is at the top of the core patch.

This is a patchset implementing MMU notifier callbacks based on Andrea's
earlier work. These are needed if Linux pages are referenced from something
else than tracked by the rmaps of the kernel. The known immediate users are

KVM (establishes a refcount to the page. External references called spte)
	(Refcount seems to be not necessary)

GRU (simple TLB shootdown without refcount. Has its own pagetable/tlb)

XPmem (uses its own reverse mappings. Remote ptes, Needs
	to sleep when sending messages)
	XPmem could defer freeing pages if a callback with atomic=1 occurs.

Pending:

- Feedback from users of the callbacks for KVM, RDMA, XPmem and GRU
  (Early tests with the GRU were successful).

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

-- 
