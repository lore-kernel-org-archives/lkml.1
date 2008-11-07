Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYKGJG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYKGJG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYKGJGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:06:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54021 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbYKGJGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:06:01 -0500
Message-ID: <49140456.8020400@cn.fujitsu.com>
Date: Fri, 07 Nov 2008 17:03:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rewrite SCHED_CPUMASK_ALLOC
References: <4911341C.7020207@cn.fujitsu.com> <20081106080057.GF8459@elte.hu> <4913EB8C.8010003@cn.fujitsu.com> <20081107081627.GC4435@elte.hu>
In-Reply-To: <20081107081627.GC4435@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Sorry, you are right - keep the SCHED_CPUMASK_DECLARE() macro please. 
> 
> But the other macros can become an inline function just fine, correct?
> 

Yes, but sched_cpumask_alloc() should be declared this way:
	void sched_cpumask_alloc(struct **allmasks)
but not:
	struct *allmasks sched_cpumask_alloc(void)

Because the latter is not workable for <128 CPUs case.

(patch is based on [PATCH] sched: fix memory leak in a failing path)

==============

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Fri, 7 Nov 2008 16:49:47 +0800
Subject: [PATCH] sched: rewrite SCHED_CPUMASK_ALLOC

The #if/#endif is ugly. Change SCHED_CPUMASK_ALLOC and
SCHED_CPUMASK_FREE to static inline functions.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 24a70d5..fe4f15e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7318,13 +7318,21 @@ struct allmasks {
 };
 
 #if	NR_CPUS > 128
-#define	SCHED_CPUMASK_ALLOC		1
-#define	SCHED_CPUMASK_FREE(v)		kfree(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+#define SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+static inline void sched_cpumask_alloc(struct allmasks **masks)
+{
+	*masks = kmalloc(sizeof(**masks), GFP_KERNEL);
+}
+static inline void sched_cpumask_free(struct allmasks *masks)
+{
+	kfree(masks);
+}
 #else
-#define	SCHED_CPUMASK_ALLOC		0
-#define	SCHED_CPUMASK_FREE(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+#define SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+static inline void sched_cpumask_alloc(struct allmasks **masks)
+{ }
+static inline void sched_cpumask_free(struct allmasks *masks)
+{ }
 #endif
 
 #define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
@@ -7400,9 +7408,8 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		return -ENOMEM;
 	}
 
-#if SCHED_CPUMASK_ALLOC
 	/* get space for all scratch cpumask variables */
-	allmasks = kmalloc(sizeof(*allmasks), GFP_KERNEL);
+	sched_cpumask_alloc(&allmasks);
 	if (!allmasks) {
 		printk(KERN_WARNING "Cannot alloc cpumask array\n");
 		kfree(rd);
@@ -7411,7 +7418,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 #endif
 		return -ENOMEM;
 	}
-#endif
+
 	tmpmask = (cpumask_t *)allmasks;
 
 
@@ -7665,13 +7672,13 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		cpu_attach_domain(sd, rd, i);
 	}
 
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	sched_cpumask_free(allmasks);
 	return 0;
 
 #ifdef CONFIG_NUMA
 error:
 	free_sched_groups(cpu_map, tmpmask);
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	sched_cpumask_free(allmasks);
 	kfree(rd);
 	return -ENOMEM;
 #endif
-- 
1.5.4.rc3


