Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbYEUJXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbYEUJXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbYEUJXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:23:08 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:33447 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYEUJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:23:07 -0400
From: Li Yang <leoli@freescale.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Kong Wei <weikong@redflag-linux.com>
Subject: [PATCH] [mm] limit the min_free_kbytes
Date: Wed, 21 May 2008 17:34:41 +0800
Message-Id: <1211362481-2136-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.5.5.1.248.g4b17
X-OriginalArrivalTime: 21 May 2008 09:23:01.0584 (UTC) FILETIME=[441A2500:01C8BB24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kong Wei <weikong@redflag-linux.com>

Unlimited of min_free_kbytes is dangerous,
An user of our company set this value bigger than 3584*1024*K,
cause the system OOM on DMA.
And I try a even more bigger number will cause the system hang immediately.
Limited as 64M may not a good value, but as default in init_per_zone_pages_min.
And this option may not need again?

Signed-off-by: Kong Wei <weikong@redflag-linux.com>
---
 kernel/sysctl.c |    5 ++++-
 mm/page_alloc.c |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8b7e954..d052522 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -103,6 +103,8 @@ static int minolduid;
 static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
+static int min_min_free_kbytes = 128;
+static int max_min_free_kbytes = 65536;
 
 #ifdef CONFIG_KMOD
 extern char modprobe_path[];
@@ -1010,7 +1012,8 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &min_free_kbytes_sysctl_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
+		.extra1		= &min_min_free_kbytes,
+		.extra2		= &max_min_free_kbytes,
 	},
 	{
 		.ctl_name	= VM_PERCPU_PAGELIST_FRACTION,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75b9793..52979e9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4179,7 +4179,7 @@ module_init(init_per_zone_pages_min)
 int min_free_kbytes_sysctl_handler(ctl_table *table, int write, 
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
-	proc_dointvec(table, write, file, buffer, length, ppos);
+	proc_dointvec_minmax(table, write, file, buffer, length, ppos);
 	if (write)
 		setup_per_zone_pages_min();
 	return 0;
-- 
1.5.0.3

