Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYKEFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYKEFxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 00:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbYKEFxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 00:53:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61961 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYKEFxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 00:53:14 -0500
Message-ID: <4911341C.7020207@cn.fujitsu.com>
Date: Wed, 05 Nov 2008 13:50:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: rewrite SCHED_CPUMASK_ALLOC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The #if/#endif is ugly. Let SCHED_CPUMASK_ALLOC do kmalloc().

Also remove unnecessary pointer casting.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..dee79ad 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7318,13 +7318,13 @@ struct allmasks {
 };
 
 #if	NR_CPUS > 128
-#define	SCHED_CPUMASK_ALLOC		1
-#define	SCHED_CPUMASK_FREE(v)		kfree(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+#define SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+#define SCHED_CPUMASK_ALLOC(v)		v = kmalloc(sizeof(*v), GFP_KERNEL)
+#define SCHED_CPUMASK_FREE(v)		kfree(v)
 #else
-#define	SCHED_CPUMASK_ALLOC		0
-#define	SCHED_CPUMASK_FREE(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+#define SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+#define SCHED_CPUMASK_ALLOC(v)
+#define SCHED_CPUMASK_FREE(v)
 #endif
 
 #define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
@@ -7400,9 +7400,8 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		return -ENOMEM;
 	}
 
-#if SCHED_CPUMASK_ALLOC
 	/* get space for all scratch cpumask variables */
-	allmasks = kmalloc(sizeof(*allmasks), GFP_KERNEL);
+	SCHED_CPUMASK_ALLOC(allmasks);
 	if (!allmasks) {
 		printk(KERN_WARNING "Cannot alloc cpumask array\n");
 		kfree(rd);
@@ -7411,7 +7410,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 #endif
 		return -ENOMEM;
 	}
-#endif
+
 	tmpmask = (cpumask_t *)allmasks;
 
 
@@ -7665,13 +7664,13 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		cpu_attach_domain(sd, rd, i);
 	}
 
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	SCHED_CPUMASK_FREE(allmasks);
 	return 0;
 
 #ifdef CONFIG_NUMA
 error:
 	free_sched_groups(cpu_map, tmpmask);
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	SCHED_CPUMASK_FREE(allmasks);
 	return -ENOMEM;
 #endif
 }
-- 
1.5.4.rc3
