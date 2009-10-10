Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbZJJPhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbZJJPhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761752AbZJJPhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:19 -0400
Received: from www.tglx.de ([62.245.132.106]:55277 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761739AbZJJPhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:18 -0400
Message-Id: <20091010153349.071381158@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Mark Gross <mgross@linux.intel.com>
Subject: [patch 01/28] pm_qos: remove BKL
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=pm-qos-remove-bkl.patch
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
Cc: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

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
 


