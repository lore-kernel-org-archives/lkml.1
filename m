Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbYDCVEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbYDCVEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYDCVDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:03:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38495 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbYDCVDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:03:19 -0400
Message-Id: <20080403210317.442655956@us.ibm.com>
References: <20080403210316.397506379@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Apr 2008 14:03:20 -0700
From: matthltc@us.ibm.com
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, linux-pm@lists.linux-foundation.org
Subject: [RFC PATCH 4/4] Container Freezer: Skip frozen cgroups during power management resume
Content-Disposition: inline; filename=cgroup-freezer/cgroup-freezer-do-not-unfreeze-a-frozen-cgroup-when-system-is-resumed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a system is resumed after a suspend, it will also unfreeze 
frozen cgroups. 

This patchs modifies the resume sequence to skip the tasks which 
are part of a frozen control group. 

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-pm@lists.linux-foundation.org
---
 kernel/power/process.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.25-rc5-mm1/kernel/power/process.c
===================================================================
--- linux-2.6.25-rc5-mm1.orig/kernel/power/process.c
+++ linux-2.6.25-rc5-mm1/kernel/power/process.c
@@ -11,10 +11,11 @@
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/cgroup_freezer.h>
 
 /* 
  * Timeout for stopping processes
  */
 #define TIMEOUT	(20 * HZ)
@@ -150,10 +151,13 @@ static void thaw_tasks(int thaw_user_spa
 			continue;
 
 		if (!p->mm == thaw_user_space)
 			continue;
 
+		if (cgroup_frozen(p))
+			continue;
+
 		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }
 

-- 
