Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbZHMUKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbZHMUKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZHMUKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:10:12 -0400
Received: from vena.lwn.net ([206.168.112.25]:46266 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbZHMUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:10:03 -0400
Date: Thu, 13 Aug 2009 14:07:16 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Gross <mgross@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] pm_qos: remove the BKL
Message-ID: <20090813140716.4490ab37@bike.lwn.net>
In-Reply-To: <20090813140554.014ce1e0@bike.lwn.net>
References: <20090813140554.014ce1e0@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
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
Cc: Mark Gross <mgross@linux.intel.com>
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

