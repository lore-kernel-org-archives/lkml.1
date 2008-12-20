Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbYLTBDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbYLTBDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbYLTBBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:01:00 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54034 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753583AbYLTBA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:00:58 -0500
Message-Id: <20081220010044.972109000@polaris-admin.engr.sgi.com>
References: <20081220010043.879277000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 17:00:51 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH 8/8] cpumask: use percpu allocations instead of array in arch/x86/kernel/cpu/mcheck/mce_64.c From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:percpu_alloc-mce_64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce memory usage, use alloc_percpu().

Instead of allocating an nr_cpu_ids array, most places should be using
percpu_alloc().  This doesn't waste space if cpu numbers aren't
contiguous.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -568,7 +568,7 @@ static void collect_tscs(void *data)
 {
 	unsigned long *cpu_tsc = (unsigned long *)data;
 
-	rdtscll(cpu_tsc[smp_processor_id()]);
+	rdtscll(*per_cpu_ptr(cpu_tsc, smp_processor_id()));
 }
 
 static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
@@ -580,7 +580,7 @@ static ssize_t mce_read(struct file *fil
 	char __user *buf = ubuf;
 	int i, err;
 
-	cpu_tsc = kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
+	cpu_tsc = alloc_percpu(unsigned long);
 	if (!cpu_tsc)
 		return -ENOMEM;
 
@@ -590,7 +590,7 @@ static ssize_t mce_read(struct file *fil
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
 		mutex_unlock(&mce_read_mutex);
-		kfree(cpu_tsc);
+		free_percpu(cpu_tsc);
 		return -EINVAL;
 	}
 
@@ -624,7 +624,8 @@ static ssize_t mce_read(struct file *fil
 	on_each_cpu(collect_tscs, cpu_tsc, 1);
 	for (i = next; i < MCE_LOG_LEN; i++) {
 		if (mcelog.entry[i].finished &&
-		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
+		    mcelog.entry[i].tsc < *per_cpu_ptr(cpu_tsc,
+						       mcelog.entry[i].cpu)) {
 			err |= copy_to_user(buf, mcelog.entry+i,
 					    sizeof(struct mce));
 			smp_rmb();
@@ -633,7 +634,7 @@ static ssize_t mce_read(struct file *fil
 		}
 	}
 	mutex_unlock(&mce_read_mutex);
-	kfree(cpu_tsc);
+	free_percpu(cpu_tsc);
 	return err ? -EFAULT : buf - ubuf;
 }
 

-- 
