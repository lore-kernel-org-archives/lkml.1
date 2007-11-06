Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbXKFIhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbXKFIhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbXKFIha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:37:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:55128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbXKFIha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,377,1188802800"; 
   d="scan'208";a="196955897"
Subject: [Patch2/2] fix wrong proc cpuinfo on x64
From: Zou Nan hai <nanhai.zou@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Organization: 
Message-Id: <1194333940.3046.38.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 06 Nov 2007 16:28:20 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in 2.6.24-rc1 kernel, 
The /proc/cpuinfo display is wrong.

Another issue is that it will display bogus cpus with wrong information
if the kernel is compiled with a big CONFIG_NR_CPU.

That is because before a cpu in cpu_present_map is up, c->cpu_index of
that cpu is 0.
thus the cpu_online(c->cpu_index) check in show_cpuinfo is invalid.

This patch will let cpuinfo_op use cpu_online_map instead of
cpu_present_map to iterate cpus.


Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>

--- linux-2.6.24-rc1/arch/x86/kernel/setup_64.c	2007-10-29 22:03:05.000000000 -0400
+++ b/arch/x86/kernel/setup_64.c	2007-11-05 23:09:06.000000000 -0500
@@ -1078,8 +1078,6 @@ static int show_cpuinfo(struct seq_file 
 
 
 #ifdef CONFIG_SMP
-	if (!cpu_online(c->cpu_index))
-		return 0;
 	cpu = c->cpu_index;
 #endif
 
@@ -1171,15 +1169,15 @@ static int show_cpuinfo(struct seq_file 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_possible_map);
-	if ((*pos) < NR_CPUS && cpu_possible(*pos))
+		*pos = first_cpu(cpu_online_map);
+	if ((*pos) < NR_CPUS && cpu_online(*pos))
 		return &cpu_data(*pos);
 	return NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_possible_map);
+	*pos = next_cpu(*pos, cpu_online_map);
 	return c_start(m, pos);
 }
 

