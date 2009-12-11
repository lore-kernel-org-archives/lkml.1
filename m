Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZLKI46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZLKI46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZLKI4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:56:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:52634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbZLKI4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:56:46 -0500
Date: Fri, 11 Dec 2009 08:55:30 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, lizf@cn.fujitsu.com,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, linux-mm@kvack.org, mingo@elte.hu,
       cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, linux-mm@kvack.org, cl@linux-foundation.org,
       mingo@elte.hu
In-Reply-To: <4B21F8AE.6020804@cn.fujitsu.com>
References: <4B21F8AE.6020804@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing, slab: Fix no callsite ifndef CONFIG_KMEMTRACE
Message-ID: <tip-0bb38a5cdeb39f543657ec6fb9950343d2de6918@git.kernel.org>
Git-Commit-ID: 0bb38a5cdeb39f543657ec6fb9950343d2de6918
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bb38a5cdeb39f543657ec6fb9950343d2de6918
Gitweb:     http://git.kernel.org/tip/0bb38a5cdeb39f543657ec6fb9950343d2de6918
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 11 Dec 2009 15:45:50 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Dec 2009 09:17:03 +0100

tracing, slab: Fix no callsite ifndef CONFIG_KMEMTRACE

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
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <4B21F8AE.6020804@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
