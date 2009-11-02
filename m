Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZKBHbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZKBHbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZKBHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:31:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52694 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZKBHbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:31:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Nov 2009 16:28:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: [RFC][-mm][PATCH 5/6] oom-killer: check last total_vm expansion
Message-Id: <20091102162837.405783f3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At considering oom-kill algorithm, we can't avoid to take runtime
into account. But this can adds too big bonus to slow-memory-leaker.
For adding penalty to slow-memory-leaker, we record jiffies of
the last mm->hiwater_vm expansion. That catches processes which leak
memory periodically.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mm_types.h |    2 ++
 include/linux/sched.h    |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: mmotm-2.6.32-Nov2/include/linux/mm_types.h
===================================================================
--- mmotm-2.6.32-Nov2.orig/include/linux/mm_types.h
+++ mmotm-2.6.32-Nov2/include/linux/mm_types.h
@@ -291,6 +291,8 @@ struct mm_struct {
 #endif
 	/* For OOM, fork-bomb detector */
 	unsigned long bomb_score;
+	/* set to jiffies at total_vm is finally expanded (see sched.h) */
+	unsigned long last_vm_expansion;
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
Index: mmotm-2.6.32-Nov2/include/linux/sched.h
===================================================================
--- mmotm-2.6.32-Nov2.orig/include/linux/sched.h
+++ mmotm-2.6.32-Nov2/include/linux/sched.h
@@ -422,8 +422,10 @@ extern void arch_unmap_area_topdown(stru
 		(mm)->hiwater_rss = _rss;		\
 } while (0)
 #define update_hiwater_vm(mm)	do {			\
-	if ((mm)->hiwater_vm < (mm)->total_vm)		\
+	if ((mm)->hiwater_vm < (mm)->total_vm) {	\
 		(mm)->hiwater_vm = (mm)->total_vm;	\
+		(mm)->last_vm_expansion = jiffies;	\
+	}\
 } while (0)
 
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)

