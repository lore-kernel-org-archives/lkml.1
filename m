Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZHaKoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZHaKoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZHaKoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:44:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:38766 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZHaKnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:43:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182301559"
Message-Id: <20090831104217.039999677@intel.com>
References: <20090831102640.092092954@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 31 Aug 2009 18:26:44 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: lizf@cn.fujitsu.com
CC: nishimura@mxp.nes.nec.co.jp
cc: menage@google.com
CC: linux-mm <linux-mm@kvack.org>
Subject: [RFC][PATCH 4/4] HWPOISON: memory cgroup based hwpoison injection filtering
Content-Disposition: inline; filename=hwpoison-filter-cgroup-pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/hwpoison-inject.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- linux-mm.orig/mm/hwpoison-inject.c	2009-08-30 18:18:41.000000000 +0800
+++ linux-mm/mm/hwpoison-inject.c	2009-08-30 18:24:33.000000000 +0800
@@ -5,10 +5,13 @@
 #include <linux/mm.h>
 #include <linux/bootmem.h>
 #include <linux/pagemap.h>
+#include <linux/page_cgroup.h>
+#include <linux/cgroup.h>
 #include "internal.h"
 
 static struct dentry *hwpoison_dir;
 
+static u32 hwpoison_filter_memcg;
 static u32 hwpoison_filter_dev_major = ~0U;
 static u32 hwpoison_filter_dev_minor = ~0U;
 static u64 hwpoison_filter_flags_mask;
@@ -53,8 +56,37 @@ static int hwpoison_filter_dev(struct pa
 	return 0;
 }
 
+static int hwpoison_filter_cg(struct page *p)
+{
+	struct mem_cgroup *mem;
+	struct cgroup_subsys_state *css;
+	int ret;
+
+	if (!hwpoison_filter_memcg)
+		return 0;
+
+	mem = try_get_mem_cgroup_from_page(p);
+	if (!mem)
+		return -EINVAL;
+
+	css = mem_cgroup_css(mem);
+	if (!css)
+		return -EINVAL;
+
+	if (css_id(css) != hwpoison_filter_memcg)
+		ret = -EINVAL;
+	else
+		ret = 0;
+
+	css_put(css);
+	return ret;
+}
+
 static int hwpoison_filter(struct page *p)
 {
+	if (hwpoison_filter_cg(p))
+		return 1;
+
 	if (hwpoison_filter_dev(p))
 		return -EINVAL;
 
@@ -119,6 +151,11 @@ static int pfn_inject_init(void)
 	if (!dentry)
 		goto fail;
 
+	dentry = debugfs_create_u32("corrupt-filter-memcg", 0600,
+				    hwpoison_dir, &hwpoison_filter_memcg);
+	if (!dentry)
+		goto fail;
+
 	dentry = debugfs_create_u32("corrupt-filter-dev-major", 0600,
 				    hwpoison_dir, &hwpoison_filter_dev_major);
 	if (!dentry)

-- 

