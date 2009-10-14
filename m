Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZJNPpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZJNPpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761156AbZJNPpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:45:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721AbZJNPpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:45:17 -0400
Date: Wed, 14 Oct 2009 15:44:15 GMT
From: tip-bot for Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, corbet@lwn.net, tglx@linutronix.de,
       mgross@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, corbet@lwn.net,
       mgross@linux.intel.com
In-Reply-To: <20091010153349.071381158@linutronix.de>
References: <20091010153349.071381158@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/core] pm_qos: remove BKL
Message-ID: <tip-e6fe07a014c7a3466dcd1a387a9ac04d84c2703c@git.kernel.org>
Git-Commit-ID: e6fe07a014c7a3466dcd1a387a9ac04d84c2703c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:44:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6fe07a014c7a3466dcd1a387a9ac04d84c2703c
Gitweb:     http://git.kernel.org/tip/e6fe07a014c7a3466dcd1a387a9ac04d84c2703c
Author:     Jonathan Corbet <corbet@lwn.net>
AuthorDate: Thu, 6 Aug 2009 13:22:40 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 15:31:10 +0200

pm_qos: remove BKL

pm_qos_power_open got its lock_kernel() calls from the open() pushdown.  A
look at the code shows that the only global resources accessed are
pm_qos_array and "name".  pm_qos_array doesn't change (things pointed to
therein do change, but they are atomics and/or are protected by
pm_qos_lock).  Accesses to "name" are totally unprotected with or without
the BKL; that will be fixed shortly.  The BKL is not helpful here; take it
out.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
LKML-Reference: <20091010153349.071381158@linutronix.de>
Acked-by: Mark Gross <mgross@linux.intel.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

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
 
