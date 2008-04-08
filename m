Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbYDHSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbYDHSnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYDHSnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 14:43:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37133 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754965AbYDHSnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 14:43:02 -0400
Message-Id: <20080408184301.842103000@polaris-admin.engr.sgi.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Apr 2008 11:43:02 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: modify show_shared_cpu_map in intel_cacheinfo v3
Content-Disposition: inline; filename=mod-intel_cacheinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Removed kmalloc (or local array) in show_shared_cpu_map().

  * Added show_shared_cpu_list() function.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v3:
    Removed cpus_scnprintf() and all references.
v2:
    Renamed cpuset_scnprintf() to cpus_scnprintf to avoid confusion with
    "cpusets", and changed the other names to match.
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- linux-2.6.x86.sched.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6.x86.sched/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -591,20 +591,34 @@ static ssize_t show_size(struct _cpuid4_
 	return sprintf (buf, "%luK\n", this_leaf->size / 1024);
 }
 
-static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
+					int type, char *buf)
 {
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
 	int n = 0;
-	int len = cpumask_scnprintf_len(nr_cpu_ids);
-	char *mask_str = kmalloc(len, GFP_KERNEL);
 
-	if (mask_str) {
-		cpumask_scnprintf(mask_str, len, this_leaf->shared_cpu_map);
-		n = sprintf(buf, "%s\n", mask_str);
-		kfree(mask_str);
+	if (len > 1) {
+		cpumask_t *mask = &this_leaf->shared_cpu_map;
+
+		n = type?
+			cpulist_scnprintf(buf, len-2, *mask):
+			cpumask_scnprintf(buf, len-2, *mask);
+		buf[n++] = '\n';
+		buf[n] = '\0';
 	}
 	return n;
 }
 
+static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf)
+{
+	return show_shared_cpu_map_func(leaf, 0, buf);
+}
+
+static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf)
+{
+	return show_shared_cpu_map_func(leaf, 1, buf);
+}
+
 static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf) {
 	switch(this_leaf->eax.split.type) {
 	    case CACHE_TYPE_DATA:
@@ -640,6 +654,7 @@ define_one_ro(ways_of_associativity);
 define_one_ro(number_of_sets);
 define_one_ro(size);
 define_one_ro(shared_cpu_map);
+define_one_ro(shared_cpu_list);
 
 static struct attribute * default_attrs[] = {
 	&type.attr,
@@ -650,6 +665,7 @@ static struct attribute * default_attrs[
 	&number_of_sets.attr,
 	&size.attr,
 	&shared_cpu_map.attr,
+	&shared_cpu_list.attr,
 	NULL
 };
 

-- 
