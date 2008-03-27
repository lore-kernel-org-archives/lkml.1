Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbYC0XRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbYC0XRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYC0XQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:16:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43857 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752003AbYC0XQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:16:55 -0400
Message-Id: <20080327231654.599276000@polaris-admin.engr.sgi.com>
References: <20080327231654.284673000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 16:16:56 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: modify show_shared_cpu_map in intel_cacheinfo
Content-Disposition: inline; filename=mod-intel_cacheinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used cpulist_scnprintf to print cpus on a leaf instead of requiring
a new "cpumask_scnprintf_len" function to determine the size of
the temporary buffer.  cpulist_scnprintf can be used to print directly
to the output buffer, eliminating the need for the temporary buffer.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- linux.trees.git.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux.trees.git/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -593,14 +593,23 @@ static ssize_t show_size(struct _cpuid4_
 
 static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
 {
-	int n = 0;
-	int len = cpumask_scnprintf_len(nr_cpu_ids);
-	char *mask_str = kmalloc(len, GFP_KERNEL);
-
-	if (mask_str) {
-		cpumask_scnprintf(mask_str, len, this_leaf->shared_cpu_map);
-		n = sprintf(buf, "%s\n", mask_str);
-		kfree(mask_str);
+	/*
+	 * cpulist_scnprintf() has the advantage of compressing
+	 * consecutive cpu numbers into a single range which seems
+	 * appropriate for cpus on a leaf.  This will change what is
+	 * output so scripts that process the output will have to change.
+	 * The good news is that the output format is compatible
+	 * with cpulist_parse() [bitmap_parselist()].
+	 *
+	 * Have to guess at output buffer size... 128 seems reasonable
+	 * to represent all cpus on a leaf in the worst case, like
+	 * if all cpus are non-consecutive and large numbers.
+	 */
+	int n = cpulist_scnprintf(buf, 128, this_leaf->shared_cpu_map);
+
+	if (n > 0) {
+		sprintf(buf+n, "\n");
+		n++;
 	}
 	return n;
 }

-- 
