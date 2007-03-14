Return-Path: <linux-kernel-owner+w=401wt.eu-S1161240AbXCNMrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161240AbXCNMrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161242AbXCNMrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:47:41 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:36573 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161240AbXCNMrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:47:40 -0400
Message-ID: <45F7EDED.6060107@hitachi.com>
Date: Wed, 14 Mar 2007 21:43:25 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       nikita@clusterfs.com, leroy.vanlogchem@wldelft.nl
Subject: [PATCH 1/3] VM throttling: Add vm.dirty_limit_ratio to sysctl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sysctl variable vm.dirty_limit_ratio.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Signed-off-by: Yuji Kakutani <yuji.kakutani.uw@hitachi.com>
---
 include/linux/sysctl.h    |    1 +
 include/linux/writeback.h |    1 +
 kernel/sysctl.c           |   11 +++++++++++
 mm/page-writeback.c       |    5 +++++
 4 files changed, 18 insertions(+)

Index: linux-2.6.21-rc3-mm2/include/linux/sysctl.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/linux/sysctl.h
+++ linux-2.6.21-rc3-mm2/include/linux/sysctl.h
@@ -208,6 +208,7 @@ enum
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
 	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
 	VM_HUGETLB_TREAT_MOVABLE=36, /* Allocate hugepages from ZONE_MOVABLE */
+	VM_DIRTY_LIMIT_RATIO=37,/* dirty_limit_ratio */

 	/* s390 vm cmm sysctls */
 	VM_CMM_PAGES=1111,
Index: linux-2.6.21-rc3-mm2/include/linux/writeback.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/linux/writeback.h
+++ linux-2.6.21-rc3-mm2/include/linux/writeback.h
@@ -95,6 +95,7 @@ static inline int laptop_spinned_down(vo
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
 extern int vm_dirty_ratio;
+extern int dirty_limit_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
 extern int block_dump;
Index: linux-2.6.21-rc3-mm2/kernel/sysctl.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/sysctl.c
+++ linux-2.6.21-rc3-mm2/kernel/sysctl.c
@@ -684,6 +684,17 @@ static ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 	{
+		.ctl_name	= VM_DIRTY_LIMIT_RATIO,
+		.procname	= "dirty_limit_ratio",
+		.data		= &dirty_limit_ratio,
+		.maxlen		= sizeof(dirty_limit_ratio),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
+	{
 		.ctl_name	= VM_DIRTY_WB_CS,
 		.procname	= "dirty_writeback_centisecs",
 		.data		= &dirty_writeback_interval,
Index: linux-2.6.21-rc3-mm2/mm/page-writeback.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/mm/page-writeback.c
+++ linux-2.6.21-rc3-mm2/mm/page-writeback.c
@@ -75,6 +75,11 @@ int dirty_background_ratio = 10;
 int vm_dirty_ratio = 40;

 /*
+ * The generator of dirty data is blocked at this percentage
+ */
+int dirty_limit_ratio = 45;
+
+/*
  * The interval between `kupdate'-style writebacks, in jiffies
  */
 int dirty_writeback_interval = 5 * HZ;

