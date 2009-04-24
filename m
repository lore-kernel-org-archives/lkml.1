Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbZDXQnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbZDXQnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbZDXQmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:24 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41580 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759914AbZDXQmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:23 -0400
Subject: [PATCH 07/14] kmemleak: Add kmemleak_alloc callback from
	alloc_large_system_hash
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Apr 2009 17:41:37 +0100
Message-ID: <20090424164137.4476.20373.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:22.0064 (UTC) FILETIME=[A3CBAF00:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alloc_large_system_hash function is called from various places in
the kernel and it contains pointers to other allocated structures. It
therefore needs to be traced by kmemleak.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/page_alloc.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e2f2699..c722aa6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <linux/kmemleak.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -4597,6 +4598,16 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (_hash_mask)
 		*_hash_mask = (1 << log2qty) - 1;
 
+	/*
+	 * If hashdist is set, the table allocation is done with __vmalloc()
+	 * which invokes the kmemleak_alloc() callback. This function may also
+	 * be called before the slab and kmemleak are initialised when
+	 * kmemleak simply buffers the request to be executed later
+	 * (GFP_ATOMIC flag ignored in this case).
+	 */
+	if (!hashdist)
+		kmemleak_alloc(table, size, 1, GFP_ATOMIC);
+
 	return table;
 }
 

