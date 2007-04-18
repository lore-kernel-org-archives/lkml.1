Return-Path: <linux-kernel-owner+w=401wt.eu-S1422942AbXDRMKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422942AbXDRMKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422953AbXDRMKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:10:55 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:44970 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422943AbXDRMKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dvBKrJFUCrBXiDfeYeKcYrZIzUBwOjYYrCCwKFEyrktWzAn557eq9DeIdSba2NNMviB9eCJrCG6Cm1qrr4PlYR7rNhaGQAhElIvwSNkE4C0rUza8KuumVMdfO99TeEHbl3xfsvPUiTBxgGtpUvHibPY44hiac8XKUW1hlkhnXQI=
Message-ID: <2ff216280704180510w28136a6cw6816f834593aff13@mail.gmail.com>
Date: Wed, 18 Apr 2007 17:40:53 +0530
From: "=?UTF-8?Q?=E0=A4=85=E0=A4=AD=E0=A4=BF=E0=A4=9C?=
	=?UTF-8?Q?=E0=A4=BF=E0=A4=A4_=E0=A4=AD?=
	=?UTF-8?Q?=E0=A5=8B=E0=A4=AA=E0=A4=9F=E0=A4=95=E0=A4=B0_(A?=
	=?UTF-8?Q?bhijit_Bhopatkar)?=" <bainonline@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@osdl.org>, akpm@osdl.org, jgarzik@pobox.com
Subject: [PATCH] [RFC] Throttle swappiness for interactive tasks
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The mm structures of interactive tasks are marked and
the pages belonging to them are never shifted to inactive
list in lru algorithm. Thus keeping interactive tasks in
memory as long as possible.
The interactivity is already determined by schedular so
we reuse that knowledge to mark the mm structures.

Signed-off-by: Abhijit Bhopatkar <bainonline@gmail.com>
---
 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    4 ++++
 kernel/sched.c            |    4 ++++
 mm/rmap.c                 |    5 +++++
 4 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index a2d95ff..12ba3c1 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -54,6 +54,7 @@
        .page_table_lock =  __SPIN_LOCK_UNLOCKED(name.page_table_lock), \
        .mmlist         = LIST_HEAD_INIT(name.mmlist),          \
        .cpu_vm_mask    = CPU_MASK_ALL,                         \
+       .interactive    = 0,                                    \
 }

 #define INIT_SIGNALS(sig) {                                            \
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 49fe299..1f233e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -373,6 +373,10 @@ struct mm_struct {
        /* aio bits */
        rwlock_t                ioctx_list_lock;
        struct kioctx           *ioctx_list;
+
+       /* interactivity flag */
+       unsigned char interactive;
+
 };

 struct sighand_struct {
diff --git a/kernel/sched.c b/kernel/sched.c
index b9a6837..72caf94 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -746,6 +746,10 @@ static inline int __normal_prio(struct task_struct *p)
                prio = MAX_RT_PRIO;
        if (prio > MAX_PRIO-1)
                prio = MAX_PRIO-1;
+
+       /* Update interactivity flag in mm if interactive. */
+       if(p->mm && TASK_INTERACTIVE(p))
+                 p->mm->interactive = 1;
        return prio;
 }

diff --git a/mm/rmap.c b/mm/rmap.c
index b82146e..0735168 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -317,6 +317,11 @@ static int page_referenced_one(struct page *page,
                        rwsem_is_locked(&mm->mmap_sem))
                referenced++;

+       /* Pretend the page is referenced if the task is
+          interactive. */
+       if (mm != current->mm && mm->interactive)
+               referenced++;
+
        (*mapcount)--;
        pte_unmap_unlock(pte, ptl);
 out:
--
1.4.4.2
