Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZHGAsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZHGAsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbZHGAsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:48:19 -0400
Received: from vena.lwn.net ([206.168.112.25]:40286 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZHGAsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:48:18 -0400
Date: Thu, 6 Aug 2009 13:59:53 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Gross <mgross@linux.intel.com>
Subject: [PATCH 1/2] pm_qos: remove BKL
Message-ID: <20090806135953.7706e57d@bike.lwn.net>
In-Reply-To: <20090806135841.46682114@bike.lwn.net>
References: <20090806135841.46682114@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_qos_power_open got its lock_kernel() calls from the open() pushdown.  A
look at the code shows that the only global resources accessed are
pm_qos_array and "name".  pm_qos_array doesn't change (things pointed to
therein do change, but they are atomics and/or are protected by
pm_qos_lock).  Accesses to "name" are totally unprotected with or without
the BKL; that will be fixed shortly.  The BKL is not helpful here; take it
out.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 kernel/pm_qos_params.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index dfdec52..d96b83e 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -29,7 +29,6 @@
 
 #include <linux/pm_qos_params.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/time.h>
@@ -352,20 +351,15 @@ static int pm_qos_power_open(struct inode *inode, struct file *filp)
 	int ret;
 	long pm_qos_class;
 
-	lock_kernel();
 	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
 	if (pm_qos_class >= 0) {
 		filp->private_data = (void *)pm_qos_class;
 		sprintf(name, "process_%d", current->pid);
 		ret = pm_qos_add_requirement(pm_qos_class, name,
 					PM_QOS_DEFAULT_VALUE);
-		if (ret >= 0) {
-			unlock_kernel();
+		if (ret >= 0)
 			return 0;
-		}
 	}
-	unlock_kernel();
-
 	return -EPERM;
 }
 
-- 
1.6.2.5

