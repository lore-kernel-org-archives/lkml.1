Return-Path: <linux-kernel-owner+w=401wt.eu-S1033409AbXEIDNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033409AbXEIDNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970434AbXEIDMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:12:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59008 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970425AbXEIDMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:12:14 -0400
Date: Wed, 09 May 2007 12:11:29 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: [RFC] memory hotremove patch take 2 [06/10] (ia64's remove_memory code)
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
References: <20070509115506.B904.Y-GOTO@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070509120643.B912.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Call offline pages from remove_memory().
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
 arch/ia64/mm/init.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

Index: current_test/arch/ia64/mm/init.c
===================================================================
--- current_test.orig/arch/ia64/mm/init.c	2007-05-08 15:07:20.000000000 +0900
+++ current_test/arch/ia64/mm/init.c	2007-05-08 15:08:07.000000000 +0900
@@ -726,7 +726,18 @@ int arch_add_memory(int nid, u64 start, 
 
 int remove_memory(u64 start, u64 size)
 {
-	return -EINVAL;
+	unsigned long start_pfn, end_pfn;
+	unsigned long timeout = 120 * HZ;
+	int ret;
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = start_pfn + (size >> PAGE_SHIFT);
+	ret = offline_pages(start_pfn, end_pfn, timeout);
+	if (ret)
+		goto out;
+	/* we can free mem_map at this point */
+out:
+	return ret;
 }
+
 EXPORT_SYMBOL_GPL(remove_memory);
 #endif

-- 
Yasunori Goto 


