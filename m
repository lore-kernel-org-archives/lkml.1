Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbXKNOmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbXKNOmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbXKNOlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:41:55 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35364 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbXKNOly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:41:54 -0500
Message-ID: <473B0317.6010603@linux.vnet.ibm.com>
Date: Wed, 14 Nov 2007 19:45:51 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Reply-To: ciju@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: wli@holomorphy.com, agl@us.ibm.com
Subject: [RFC] [PATCH] hugetlbfs :shmget with SHM_HUGETLB only works as root
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a normal user is trying to allocate huge pages using shmget(), the 
user is not able to get the memory even if the gid is present in 
/proc/sys/vm/hugetlb_shm_group. The function user_shm_lock() is not 
successful. The user does not have the capability to perform a 
CAP_IPC_LOCK. A check is added here to see whether the gid is present in 
hugetlb_shm_group. Please review the patch.

Signed-off-by: Ciju Rajan (ciju@linux.vnet.ibm.com)
---
--- linux-2.6.23/mm/mlock.c.orig    2007-11-14 17:35:02.000000000 +0530
+++ linux-2.6.23/mm/mlock.c    2007-11-14 17:50:31.000000000 +0530
@@ -8,6 +8,7 @@
 #include <linux/capability.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
+#include <linux/hugetlb.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
@@ -248,8 +249,14 @@ int user_shm_lock(size_t size, struct us
         allowed = 1;
     lock_limit >>= PAGE_SHIFT;
     spin_lock(&shmlock_user_lock);
+#ifdef CONFIG_HUGETLB_PAGE
+    if (!allowed &&
+        locked + user->locked_shm > lock_limit &&
+        (!(capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group))))
+#else
     if (!allowed &&
         locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
+#endif
         goto out;
     get_uid(user);
     user->locked_shm += locked;
