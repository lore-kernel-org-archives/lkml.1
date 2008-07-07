Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYGGW6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYGGW6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYGGW62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:58:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49920 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbYGGW61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:58:27 -0400
Message-Id: <20080707225824.774567787@us.ibm.com>
References: <20080707225823.502032693@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 15:58:27 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Menage <menage@google.com>, Pavel Machek <pavel@ucw.cz>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: [PATCH 4/4] Container Freezer: Skip frozen cgroups during power management resume
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Le Goater <clg@fr.ibm.com>
Subject: [PATCH 4/4] Container Freezer: Skip frozen cgroups during power management resume

When a system is resumed after a suspend, it will also unfreeze 
frozen cgroups. 

This patchs modifies the resume sequence to skip the tasks which 
are part of a frozen control group. 

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
---
 kernel/power/process.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.26-rc5-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/kernel/power/process.c
+++ linux-2.6.26-rc5-mm2/kernel/power/process.c
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
@@ -133,10 +134,13 @@ static void thaw_tasks(bool nosig_only)
 			continue;
 
 		if (nosig_only && should_send_signal(p))
 			continue;
 
+		if (cgroup_frozen(p))
+			continue;
+
 		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 }
 

-- 
