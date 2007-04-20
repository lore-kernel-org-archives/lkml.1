Return-Path: <linux-kernel-owner+w=401wt.eu-S2992993AbXDTLo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992993AbXDTLo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992947AbXDTLo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:44:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58752 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993013AbXDTLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:44:56 -0400
Date: Fri, 20 Apr 2007 20:43:56 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Make new setting of panic_on_oom
Cc: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Larry Woodman <lwoodman@redhat.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070420202752.0E69.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The current panic_on_oom may not work if there is a process using 
cpusets/mempolicy, because other nodes' memory may still free.
But some people want failover by panic ASAP even if they are used.
This patch makes new setting for its request.

This is not tested yet. But it would work.

Please apply.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 Documentation/sysctl/vm.txt |   23 +++++++++++++++++------
 mm/oom_kill.c               |    3 +++
 2 files changed, 20 insertions(+), 6 deletions(-)

Index: panic_on_oom2/Documentation/sysctl/vm.txt
===================================================================
--- panic_on_oom2.orig/Documentation/sysctl/vm.txt	2007-04-19 11:19:07.000000000 +0900
+++ panic_on_oom2/Documentation/sysctl/vm.txt	2007-04-19 14:11:24.000000000 +0900
@@ -197,11 +197,22 @@
 
 panic_on_oom
 
-This enables or disables panic on out-of-memory feature.  If this is set to 1,
-the kernel panics when out-of-memory happens.  If this is set to 0, the kernel
-will kill some rogue process, called oom_killer.  Usually, oom_killer can kill
-rogue processes and system will survive.  If you want to panic the system
-rather than killing rogue processes, set this to 1.
+This enables or disables panic on out-of-memory feature.
 
-The default value is 0.
+If this is set to 0, the kernel will kill some rogue process,
+called oom_killer.  Usually, oom_killer can kill rogue processes and
+system will survive.
+
+If this is set to 1, the kernel panics when out-of-memory happens.
+However, if a process limits using nodes by mempolicy/cpusets,
+and those nodes become memory exhaustion status, one process
+may be killed by oom-killer. No panic occurs in this case.
+Because other nodes' memory may be free. This means system total status
+may be not fatal yet.
 
+If this is set to 2, the kernel panics compulsorily even on the
+above-mentioned.
+
+The default value is 0.
+1 and 2 are for failover of clustering. Please select either
+according to your policy of failover.
Index: panic_on_oom2/mm/oom_kill.c
===================================================================
--- panic_on_oom2.orig/mm/oom_kill.c	2007-04-19 11:27:31.000000000 +0900
+++ panic_on_oom2/mm/oom_kill.c	2007-04-19 12:01:44.000000000 +0900
@@ -412,6 +412,9 @@
 	cpuset_lock();
 	read_lock(&tasklist_lock);
 
+	if (sysctl_panic_on_oom == 2)
+		panic("out of memory. Compulsory panic_on_oom is selected.\n");
+
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.

-- 
Yasunori Goto 


