Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYLSACz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYLSACz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYLSAAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:00:38 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59240 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751611AbYLSAAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:00:32 -0500
Message-Id: <20081219000030.698915000@polaris-admin.engr.sgi.com>
References: <20081219000029.540121000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 16:00:37 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
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
