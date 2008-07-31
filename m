Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYGaMDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYGaMDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYGaMDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:03:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45834 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYGaMDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:03:32 -0400
Date: Thu, 31 Jul 2008 21:02:21 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [RFC:Patch: 006/008](memory hotplug) kswapd_stop() definition
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
References: <20080731203549.2A3F.E1E9C6FF@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080731210119.2A4D.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is to make kswapd_stop().
It must be stopped before node removing.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 include/linux/swap.h |    3 +++
 mm/vmscan.c          |   13 +++++++++++++
 2 files changed, 16 insertions(+)

Index: current/mm/vmscan.c
===================================================================
--- current.orig/mm/vmscan.c	2008-07-29 22:17:16.000000000 +0900
+++ current/mm/vmscan.c	2008-07-29 22:17:16.000000000 +0900
@@ -1985,6 +1985,9 @@ static int kswapd(void *p)
 		}
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
+		if (kthread_should_stop())
+			break;
+
 		if (!try_to_freeze()) {
 			/* We can speed up thawing tasks if we don't call
 			 * balance_pgdat after returning from the refrigerator
@@ -2216,6 +2219,16 @@ int kswapd_run(int nid)
 	return ret;
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+void kswapd_stop(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	if (pgdat->kswapd)
+		kthread_stop(pgdat->kswapd);
+}
+#endif
+
 static int __init kswapd_init(void)
 {
 	int nid;
Index: current/include/linux/swap.h
===================================================================
--- current.orig/include/linux/swap.h	2008-07-29 21:20:02.000000000 +0900
+++ current/include/linux/swap.h	2008-07-29 22:17:16.000000000 +0900
@@ -262,6 +262,9 @@ static inline void scan_unevictable_unre
 #endif
 
 extern int kswapd_run(int nid);
+#ifdef CONFIG_MEMORY_HOTREMOVE
+extern void kswapd_stop(int nid);
+#endif
 
 #ifdef CONFIG_MMU
 /* linux/mm/shmem.c */

-- 
Yasunori Goto 


