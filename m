Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZKCE3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZKCE3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbZKCE3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:29:04 -0500
Received: from ozlabs.org ([203.10.76.45]:39516 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479AbZKCE3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:29:03 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031459.06857.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:59:06 +1030
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ashok Raj <ashok.raj@intel.com>
Subject: [PATCH 14/14] cpumask: don't recommend set_cpus_allowed hack in Documentation/cpu-hotplug.txt
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ashok Raj <ashok.raj@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ashok Raj <ashok.raj@intel.com>
---
 Documentation/cpu-hotplug.txt |   49 ++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -309,41 +309,26 @@ A: The following are what is required fo
 
 Q: I need to ensure that a particular cpu is not removed when there is some
    work specific to this cpu is in progress.
-A: First switch the current thread context to preferred cpu
+A: There are two ways.  If your code can be run in interrupt context, use
+   smp_call_function_single(), otherwise use work_on_cpu().  Note that
+   work_on_cpu() can fail due to out of memory:
 
 	int my_func_on_cpu(int cpu)
 	{
-		cpumask_t saved_mask, new_mask = CPU_MASK_NONE;
-		int curr_cpu, err = 0;
-
-		saved_mask = current->cpus_allowed;
-		cpu_set(cpu, new_mask);
-		err = set_cpus_allowed(current, new_mask);
-
-		if (err)
-			return err;
-
-		/*
-		 * If we got scheduled out just after the return from
-		 * set_cpus_allowed() before running the work, this ensures
-		 * we stay locked.
-		 */
-		curr_cpu = get_cpu();
-
-		if (curr_cpu != cpu) {
-			err = -EAGAIN;
-			goto ret;
-		} else {
-			/*
-			 * Do work : But cant sleep, since get_cpu() disables preempt
-			 */
-		}
-		ret:
-			put_cpu();
-			set_cpus_allowed(current, saved_mask);
-			return err;
-		}
-
+		int err;
+		cpu_hotplug_lock();
+		if (!cpu_online(cpu))
+			err = -EINVAL;
+		else
+#if NEEDS_BLOCKING
+			err = work_on_cpu(cpu, __my_func_on_cpu, NULL);
+#else
+			smp_call_function_single(cpu, __my_func_on_cpu, &err,
+						 true);
+#endif
+		cpu_hotplug_unlock();
+		return err;
+	}
 
 Q: How do we determine how many CPUs are available for hotplug.
 A: There is no clear spec defined way from ACPI that can give us that

