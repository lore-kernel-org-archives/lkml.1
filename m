Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYDEBZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYDEBZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYDEBYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:24:50 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48043 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751108AbYDEBYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:24:49 -0400
Message-Id: <20080405012447.770671000@polaris-admin.engr.sgi.com>
References: <20080405012447.440875000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:24:49 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: modify show_shared_cpu_map in intel_cacheinfo v2
Content-Disposition: inline; filename=mod-intel_cacheinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpus_scnprintf to print cpus on a leaf instead of requiring
a new "cpumask_scnprintf_len" function to determine the size of
the temporary buffer.  cpus_scnprintf can be used to print directly
to the output buffer, eliminating the need for the temporary buffer.

The format that cpus_scnprintf uses is dependent on the sysctl
variable kernel.compat_cpus_printf.  The default is '1' and
results in this printout when NR_CPUS = 4096:

    # cat /sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_map
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,\
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,0000000c

Clearing kernel.compat_cpus_printf changes the output to:

    # sysctl kernel.compat_cpus_printf=0
    # cat /sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_map
    +2-3


[Depends on: x86: add cpus_scnprintf function patch]

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
v2:
    Renamed cpuset_scnprintf() to cpus_scnprintf to avoid confusion with
    "cpusets", and changed the other names to match.
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- linux-2.6.x86.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6.x86/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -593,14 +593,17 @@ static ssize_t show_size(struct _cpuid4_
 
 static ssize_t show_shared_cpu_map(struct _cpuid4_info *this_leaf, char *buf)
 {
+	unsigned long end = ALIGN((unsigned long)buf, PAGE_SIZE);
+	int len = end - (unsigned long)buf;
 	int n = 0;
-	int len = cpumask_scnprintf_len(nr_cpu_ids);
-	char *mask_str = kmalloc(len, GFP_KERNEL);
 
-	if (mask_str) {
-		cpumask_scnprintf(mask_str, len, this_leaf->shared_cpu_map);
-		n = sprintf(buf, "%s\n", mask_str);
-		kfree(mask_str);
+	if (len == 0)
+		len = PAGE_SIZE;
+
+	if (len >= 2) {
+		n = cpus_scnprintf(buf, len-2, this_leaf->shared_cpu_map);
+		buf[n++] = '\n';
+		buf[n] = '\0';
 	}
 	return n;
 }

-- 
