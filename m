Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0CIBCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:02:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49706 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0CIBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:02:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Mar 2010 09:58:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [BUGFIX][PATCH] fix sync_mm_rss in nommu (Was Re: sync_mm_rss()
 issues
Message-Id: <20100309095830.7d4a744d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <30859.1268056796@redhat.com>
References: <30859.1268056796@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David-san, could you check this ?
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix breakage in NOMMU build

commit 34e55232e59f7b19050267a05ff1226e5cd122a5 added sync_mm_rss()
for syncing loosely accounted rss counters. It's for CONFIG_MMU but
sync_mm_rss is called even in NOMMU enviroment (kerne/exit.c, fs/exec.c).
Above commit doesn't handle it well.

This patch changes
  SPLIT_RSS_COUNTING depends on SPLIT_PTLOCKS && CONFIG_MMU

And for avoid unnecessary function calls, sync_mm_rss changed to be inlined
noop function in header file.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mm.h       |    6 ++++++
 include/linux/mm_types.h |    2 +-
 mm/memory.c              |    3 ---
 3 files changed, 7 insertions(+), 4 deletions(-)

Index: mmotm-2.6.33-Mar5/include/linux/mm.h
===================================================================
--- mmotm-2.6.33-Mar5.orig/include/linux/mm.h
+++ mmotm-2.6.33-Mar5/include/linux/mm.h
@@ -974,7 +974,13 @@ static inline void setmax_mm_hiwater_rss
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
Index: mmotm-2.6.33-Mar5/mm/memory.c
===================================================================
--- mmotm-2.6.33-Mar5.orig/mm/memory.c
+++ mmotm-2.6.33-Mar5/mm/memory.c
@@ -190,9 +190,6 @@ static void check_sync_rss_stat(struct t
 {
 }
 
-void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
-{
-}
 #endif
 
 /*
Index: mmotm-2.6.33-Mar5/include/linux/mm_types.h
===================================================================
--- mmotm-2.6.33-Mar5.orig/include/linux/mm_types.h
+++ mmotm-2.6.33-Mar5/include/linux/mm_types.h
@@ -203,7 +203,7 @@ enum {
 	NR_MM_COUNTERS
 };
 
-#if USE_SPLIT_PTLOCKS
+#if USE_SPLIT_PTLOCKS && defined(CONFIG_MMU)
 #define SPLIT_RSS_COUNTING
 struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];

