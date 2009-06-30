Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbZF3XTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbZF3XTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759696AbZF3XRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:22 -0400
Received: from ozlabs.org ([203.10.76.45]:39648 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbZF3XRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:19 -0400
Message-Id: <20090630230141.088394681@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:48 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/8] perf report: Fix reporting of hypervisor
Content-Disposition: inline; filename=pcl_fix_hypervisor_report.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PERF_EVENT_MISC_* is not a bitmask, so we have to mask and compare.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/builtin-report.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-report.c	2009-07-01 08:21:13.000000000 +1000
+++ linux-2.6-tip/tools/perf/builtin-report.c	2009-07-01 08:21:39.000000000 +1000
@@ -1210,6 +1210,7 @@
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
 	struct ip_callchain *chain = NULL;
+	int cpumode;
 
 	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
@@ -1250,7 +1251,9 @@
 		return -1;
 	}
 
-	if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
 		show = SHOW_KERNEL;
 		level = 'k';
 
@@ -1258,7 +1261,7 @@
 
 		dprintf(" ...... dso: %s\n", dso->name);
 
-	} else if (event->header.misc & PERF_EVENT_MISC_USER) {
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
 
 		show = SHOW_USER;
 		level = '.';

-- 

