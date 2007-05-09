Return-Path: <linux-kernel-owner+w=401wt.eu-S968669AbXEIDMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968669AbXEIDMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970414AbXEIDMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:12:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46858 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970403AbXEIDMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:12:03 -0400
Date: Wed, 09 May 2007 12:10:50 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [RFC] memory hotremove patch take 2 [03/10] (drain all pages)
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070509120337.B90A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add function drain_all_pages(void) to drain all 
pages on per-cpu-freelist.
Page isolation will catch them in free_one_page.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

 include/linux/page_isolation.h |    1 +
 mm/page_alloc.c                |   13 +++++++++++++
 2 files changed, 14 insertions(+)

Index: current_test/mm/page_alloc.c
===================================================================
--- current_test.orig/mm/page_alloc.c	2007-05-08 15:08:03.000000000 +0900
+++ current_test/mm/page_alloc.c	2007-05-08 15:08:33.000000000 +0900
@@ -1070,6 +1070,19 @@ void drain_all_local_pages(void)
 	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
 }
 
+#ifdef CONFIG_PAGE_ISOLATION
+static void drain_local_zone_pages(struct work_struct *work)
+{
+	drain_local_pages();
+}
+
+void drain_all_pages(void)
+{
+	schedule_on_each_cpu(drain_local_zone_pages);
+}
+
+#endif /* CONFIG_PAGE_ISOLATION */
+
 /*
  * Free a 0-order page
  */
Index: current_test/include/linux/page_isolation.h
===================================================================
--- current_test.orig/include/linux/page_isolation.h	2007-05-08 15:08:03.000000000 +0900
+++ current_test/include/linux/page_isolation.h	2007-05-08 15:08:33.000000000 +0900
@@ -39,6 +39,7 @@ extern void detach_isolation_info_zone(s
 extern void free_isolation_info(struct isolation_info *info);
 extern void unuse_all_isolated_pages(struct isolation_info *info);
 extern void free_all_isolated_pages(struct isolation_info *info);
+extern void drain_all_pages(void);
 
 #else
 

-- 
Yasunori Goto 


