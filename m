Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZCKBB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZCKBB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZCKBBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:01:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:25222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbZCKBBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:01:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,338,1233561600"; 
   d="scan'208";a="118934607"
Date: Wed, 11 Mar 2009 09:00:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] proc: fix kflags to uflags copying in /proc/kpageflags
Message-ID: <20090311010004.GA8237@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kpf_copy_bit(src,dst) to be kpf_copy_bit(dst,src) to match the
actual call patterns, e.g. kpf_copy_bit(kflags, KPF_LOCKED, PG_locked).

This misplacement of src/dst only affected reporting of PG_writeback,
PG_reclaim and PG_buddy. For others kflags==uflags so not affected.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

This is a tested and trivial no-side-effect fix.
I'd suggest it for 2.6.29-rc7 and 2.6.28.X kernels.

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 2d13451..e998383 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -80,7 +80,7 @@ static const struct file_operations proc_kpagecount_operations = {
 #define KPF_RECLAIM    9
 #define KPF_BUDDY     10
 
-#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
+#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
 
 static ssize_t kpageflags_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
