Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbYLSQCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYLSQCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYLSQBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:01:48 -0500
Received: from relay3.sgi.com ([192.48.171.31]:59905 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750958AbYLSQBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:01:46 -0500
Message-Id: <20081219160144.867989000@polaris-admin.engr.sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 08:01:45 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] cpumask: convert kernel/compat.c
Content-Disposition: inline; filename=cpumask:convert-kernel_compat.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Reduce stack usage, use new cpumask API.

Straightforward conversion; cpumasks' size is given by cpumask_size() (now
a variable rather than fixed) and on-stack cpu masks use cpumask_var_t.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/compat.c |   49 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

--- linux-2.6.28.orig/kernel/compat.c
+++ linux-2.6.28/kernel/compat.c
@@ -454,16 +454,16 @@ asmlinkage long compat_sys_waitid(int wh
 }
 
 static int compat_get_user_cpu_mask(compat_ulong_t __user *user_mask_ptr,
-				    unsigned len, cpumask_t *new_mask)
+				    unsigned len, struct cpumask *new_mask)
 {
 	unsigned long *k;
 
-	if (len < sizeof(cpumask_t))
-		memset(new_mask, 0, sizeof(cpumask_t));
-	else if (len > sizeof(cpumask_t))
-		len = sizeof(cpumask_t);
+	if (len < cpumask_size())
+		memset(new_mask, 0, cpumask_size());
+	else if (len > cpumask_size())
+		len = cpumask_size();
 
-	k = cpus_addr(*new_mask);
+	k = cpumask_bits(new_mask);
 	return compat_get_bitmap(k, user_mask_ptr, len * 8);
 }
 
@@ -471,40 +471,51 @@ asmlinkage long compat_sys_sched_setaffi
 					     unsigned int len,
 					     compat_ulong_t __user *user_mask_ptr)
 {
-	cpumask_t new_mask;
+	cpumask_var_t new_mask;
 	int retval;
 
-	retval = compat_get_user_cpu_mask(user_mask_ptr, len, &new_mask);
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	retval = compat_get_user_cpu_mask(user_mask_ptr, len, new_mask);
 	if (retval)
-		return retval;
+		goto out;
 
-	return sched_setaffinity(pid, &new_mask);
+	retval = sched_setaffinity(pid, new_mask);
+out:
+	free_cpumask_var(new_mask);
+	return retval;
 }
 
 asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
 					     compat_ulong_t __user *user_mask_ptr)
 {
 	int ret;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	unsigned long *k;
-	unsigned int min_length = sizeof(cpumask_t);
+	unsigned int min_length = cpumask_size();
 
-	if (NR_CPUS <= BITS_PER_COMPAT_LONG)
+	if (nr_cpu_ids <= BITS_PER_COMPAT_LONG)
 		min_length = sizeof(compat_ulong_t);
 
 	if (len < min_length)
 		return -EINVAL;
 
-	ret = sched_getaffinity(pid, &mask);
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = sched_getaffinity(pid, mask);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	k = cpus_addr(mask);
+	k = cpumask_bits(mask);
 	ret = compat_put_bitmap(user_mask_ptr, k, min_length * 8);
-	if (ret)
-		return ret;
+	if (ret == 0)
+		ret = min_length;
 
-	return min_length;
+out:
+	free_cpumask_var(mask);
+	return ret;
 }
 
 int get_compat_itimerspec(struct itimerspec *dst,

-- 
