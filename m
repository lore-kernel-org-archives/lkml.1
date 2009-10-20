Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZJTQa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZJTQa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZJTQa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:30:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:10681 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZJTQa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,592,1249282800"; 
   d="scan'208";a="459517568"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Miles Lane <miles.lane@gmail.com>
Subject: [PATCH] drm/i915: Avoid potential sleep whilst holding spinlock
Date: Tue, 20 Oct 2009 17:29:16 +0100
Message-Id: <1256056156-16459-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <4ADDE11E.6030502@gmail.com>
References: <4ADDE11E.6030502@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane reported the following error:
2 locks held by cat/4179:
  #0:  (&p->lock){+.+.+.}, at: [<c10a3884>] seq_read+0x25/0x315
  #1:  (&dev_priv->mm.active_list_lock){+.+...}, at: [<c119a854>]
i915_batchbuffer_info+0x2b/0x124
Pid: 4179, comm: cat Not tainted 2.6.32-rc5-git1 #2
Call Trace:
  [<c104874f>] ? __debug_show_held_locks+0x1e/0x20
  [<c1023fb0>] __might_sleep+0xf0/0xf7
  [<c101c393>] kmap+0x17/0x58
  [<c119a8d6>] i915_batchbuffer_info+0xad/0x124
  [<c10a39bf>] seq_read+0x160/0x315
  [<c108fb8c>] ? rw_verify_area+0x98/0xbb
  [<c10a385f>] ? seq_read+0x0/0x315
  [<c1090331>] vfs_read+0x75/0xa9
  [<c10903f9>] sys_read+0x3b/0x5d
  [<c1002a8f>] sysenter_do_call+0x12/0x36

The fix is relatively simple, use the atomic variants of kmap() that
avoid the potential sleep.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Miles Lane <miles.lane@gmail.com>
---
 drivers/gpu/drm/i915/i915_debugfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 2ace8b7..9087c4c 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -268,10 +268,10 @@ static void i915_dump_pages(struct seq_file *m, struct page **pages, int page_co
 	uint32_t *mem;
 
 	for (page = 0; page < page_count; page++) {
-		mem = kmap(pages[page]);
+		mem = kmap_atomic(pages[page], KM_USER0);
 		for (i = 0; i < PAGE_SIZE; i += 4)
 			seq_printf(m, "%08x :  %08x\n", i, mem[i / 4]);
-		kunmap(pages[page]);
+		kunmap_atomic(pages[page], KM_USER0);
 	}
 }
 
-- 
1.6.5

