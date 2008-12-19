Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYLSSQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYLSSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYLSSNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:13:39 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50368 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193AbYLSSNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:13:38 -0500
Subject: [PATCH 07/14] kmemleak: Add kmemleak_alloc callback from
	alloc_large_system_hash
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 19 Dec 2008 18:13:35 +0000
Message-ID: <20081219181335.7778.62548.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2008 18:13:36.0610 (UTC) FILETIME=[82D49C20:01C96205]
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
index d8ac014..c154b8d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <linux/kmemleak.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -4570,6 +4571,16 @@ void *__init alloc_large_system_hash(const char *tablename,
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
 

