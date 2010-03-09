Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0CIQz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:55:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0CIQzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:55:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix breakage in NOMMU build
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
       David Howells <dhowells@redhat.com>
Date: Tue, 09 Mar 2010 16:55:09 +0000
Message-ID: <20100309165508.8522.63314.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Commit 34e55232e59f7b19050267a05ff1226e5cd122a5 added sync_mm_rss() for
syncing loosely accounted rss counters.  It's for CONFIG_MMU but sync_mm_rss
is called even in NOMMU enviroment (kerne/exit.c, fs/exec.c).  Above commit
doesn't handle it well.

This patch changes
  SPLIT_RSS_COUNTING depends on SPLIT_PTLOCKS && CONFIG_MMU

And for avoid unnecessary function calls, sync_mm_rss changed to be inlined
noop function in header file.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/mm.h       |    6 ++++++
 include/linux/mm_types.h |    2 +-
 mm/memory.c              |    3 ---
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3899395..7f693b2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -971,7 +971,13 @@ static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
 		*maxrss = hiwater_rss;
 }
 
+#if defined(SPLIT_RSS_COUNTING)
 void sync_mm_rss(struct task_struct *task, struct mm_struct *mm);
+#else
+static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
+{
+}
+#endif
 
 /*
  * A callback you can register to apply pressure to ageable caches.
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 048b462..b8bb9a6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -203,7 +203,7 @@ enum {
 	NR_MM_COUNTERS
 };
 
-#if USE_SPLIT_PTLOCKS
+#if USE_SPLIT_PTLOCKS && defined(CONFIG_MMU)
 #define SPLIT_RSS_COUNTING
 struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
diff --git a/mm/memory.c b/mm/memory.c
index d1153e3..3d9130b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -190,9 +190,6 @@ static void check_sync_rss_stat(struct task_struct *task)
 {
 }
 
-void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
-{
-}
 #endif
 
 /*

