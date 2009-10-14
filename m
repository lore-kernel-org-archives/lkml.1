Return-Path: <linux-kernel-owner+w=401wt.eu-S1761874AbZJNPdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761874AbZJNPdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934527AbZJNPdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:33:00 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57779 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934491AbZJNPc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:32:59 -0400
Subject: [PATCH] kmemleak: Do not use off-slab management with SLAB_NOLEAKTRACE
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Date: Wed, 14 Oct 2009 16:31:46 +0100
Message-ID: <20091014153146.8955.19964.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc3-10-g00be
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Oct 2009 15:31:46.0992 (UTC) FILETIME=[70F5BB00:01CA4CE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the slab allocator, if off-slab management is enabled for the
kmem_caches used by kmemleak, it leads to recursive calls into
kmemleak_alloc(). Off-slab management can be triggered by other config
options increasing the slab size, e.g. DEBUG_PAGEALLOC.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/slab.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..646db30 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2261,9 +2261,11 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	/*
 	 * Determine if the slab management is 'on' or 'off' slab.
 	 * (bootstrapping cannot cope with offslab caches so don't do
-	 * it too early on.)
+	 * it too early on. Always use on-slab management when
+	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
 	 */
-	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init)
+	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
+	    !(flags & SLAB_NOLEAKTRACE))
 		/*
 		 * Size is large, assume best to place the slab management obj
 		 * off-slab (should allow better packing of objs).

