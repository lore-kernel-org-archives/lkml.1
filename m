Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYA3CbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYA3CbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 21:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYA3C3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 21:29:51 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40833 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753245AbYA3C3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 21:29:46 -0500
Message-Id: <20080130022909.677301714@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 18:29:09 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: [patch 0/6] [RFC] MMU Notifiers V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patchset implementing MMU notifier callbacks based on Andrea's
earlier work. These are needed if Linux pages are referenced from something
else than tracked by the rmaps of the kernel. The known immediate users are

KVM (establishes a refcount to the page. External references called spte)

GRU (simple TLB shootdown without refcount. Has its own pagetable/tlb)

XPmem (uses its own reverse mappings and refcount. Remote ptes, Needs
	to sleep when sending messages)

Issues:

- Feedback from uses of the callbacks for KVM, RDMA, XPmem and GRU
  Early tests with the GRU were successful.

- Pages may be freed before the external mapping are torn down
  through invalidate_range() if no refcount on the page is taken.
  There is the chance that page content may be visible after
  they have been reallocated (mainly an issue for the GRU that
  takes no refcount).

- invalidate_range() callbacks are sometimes called under i_mmap_lock.
  These need to be dealt with or XPmem needs to be able to work around
  these.

- filemap_xip.c does not follow conventions for Rmap callbacks.
  We could depends on XIP support not being active to avoid the issue.

Things that we leave as is:

- RCU quiescent periods are required on registering and unregistering
  notifiers to guarantee visibility to other processors.
  Currently only mmu_notifier_release() does the correct thing.
  It is up to the user to provide RCU quiescent periods for
  register/unregister functions if they are called outside of the
  ->release method.

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

-- 
