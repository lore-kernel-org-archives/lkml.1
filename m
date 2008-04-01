Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbYDAWzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbYDAWzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYDAWyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:54:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43860 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751784AbYDAWyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:54:23 -0400
Message-Id: <20080401225422.382979000@polaris-admin.engr.sgi.com>
References: <20080401225422.064890000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 15:54:24 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH 2/3] x86: modify show_shared_cpu_map in intel_cacheinfo
Content-Disposition: inline; filename=mod-intel_cacheinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpuset_scnprintf to print cpus on a leaf instead of requiring
a new "cpumask_scnprintf_len" function to determine the size of
the temporary buffer.  cpuset_scnprintf can be used to print directly
to the output buffer, eliminating the need for the temporary buffer.

The format that cpuset_scnprintf uses is dependent on the sysctl
variable kernel.compat_cpuset_printf.  The default is '1' and results
in this printout when NR_CPUS = 4096:

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
    00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000008

Clearing kernel.compat_cpuset_printf changes the output to:

    # sysctl kernel.compat_cpuset_printf=0
    # cat /sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_map
    3


[Depends on: x86: add cpuset_scnprintf function patch]

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Bert Wesarg <bert.wesarg@googlemail.com>
Signed-off-by: Mike Travis <travis@sgi.com>
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
+		n = cpuset_scnprintf(buf, len-2, this_leaf->shared_cpu_map);
+		buf[n++] = '\n';
+		buf[n] = '\0';
 	}
 	return n;
 }

-- 
