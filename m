Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZLKHqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZLKHqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758898AbZLKHqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:46:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZLKHqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:46:00 -0500
Message-ID: <4B21F8AE.6020804@cn.fujitsu.com>
Date: Fri, 11 Dec 2009 15:45:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 2/2] tracing: Fix no callsite ifndef CONFIG_KMEMTRACE
References: <4B21F89A.7000801@cn.fujitsu.com>
In-Reply-To: <4B21F89A.7000801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For slab, if CONFIG_KMEMTRACE and CONFIG_DEBUG_SLAB are not set,
__do_kmalloc() will not track callers:

 # ./perf record -f -a -R -e kmem:kmalloc
 ^C
 # ./perf trace
 ...
          perf-2204  [000]   147.376774: kmalloc: call_site=c0529d2d ...
          perf-2204  [000]   147.400997: kmalloc: call_site=c0529d2d ...
          Xorg-1461  [001]   147.405413: kmalloc: call_site=0 ...
          Xorg-1461  [001]   147.405609: kmalloc: call_site=0 ...
       konsole-1776  [001]   147.405786: kmalloc: call_site=0 ...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 9733bb4..c3d092d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3649,7 +3649,7 @@ __do_kmalloc_node(size_t size, gfp_t flags, int node, void *caller)
 	return ret;
 }
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
 	return __do_kmalloc_node(size, flags, node,
@@ -3669,7 +3669,7 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 	return __do_kmalloc_node(size, flags, node, NULL);
 }
 EXPORT_SYMBOL(__kmalloc_node);
-#endif /* CONFIG_DEBUG_SLAB */
+#endif /* CONFIG_DEBUG_SLAB || CONFIG_TRACING */
 #endif /* CONFIG_NUMA */
 
 /**
@@ -3701,7 +3701,7 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 }
 
 
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_KMEMTRACE)
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_TRACING)
 void *__kmalloc(size_t size, gfp_t flags)
 {
 	return __do_kmalloc(size, flags, __builtin_return_address(0));
-- 
1.6.3

