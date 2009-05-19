Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZESIcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZESIcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZESIcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:32:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:60757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZESIch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:32:37 -0400
Date: Tue, 19 May 2009 08:31:00 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, jeff@garzik.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeff@garzik.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
References: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
Subject: [tip:sched/core] sched: properly define the sched_group::cpumask and sched_domain::span fields
Message-ID: <tip-4200efd9acda4accf24640f1e77d24fdcdb524df@git.kernel.org>
Git-Commit-ID: 4200efd9acda4accf24640f1e77d24fdcdb524df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 08:31:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4200efd9acda4accf24640f1e77d24fdcdb524df
Gitweb:     http://git.kernel.org/tip/4200efd9acda4accf24640f1e77d24fdcdb524df
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 19 May 2009 09:22:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 19 May 2009 09:22:19 +0200

sched: properly define the sched_group::cpumask and sched_domain::span fields

Properly document the variable-size structure tricks we are doing
wrt. struct sched_group and sched_domain, and use the field[0] GCC
extension instead of defining a vla array.

Dont use unions for this, as pointed out by Linus.

[ Impact: cleanup, un-confuse Sparse and LLVM ]

Reported-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |   25 ++++++++++++++++++++++---
 kernel/sched.c        |    5 +++--
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index de7b3b2..dbb1043 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -839,7 +839,17 @@ struct sched_group {
 	 */
 	u32 reciprocal_cpu_power;
 
-	unsigned long cpumask[];
+	/*
+	 * The CPUs this group covers.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 *
+	 * It is also be embedded into static data structures at build
+	 * time. (See 'struct static_sched_group' in kernel/sched.c)
+	 */
+	unsigned long cpumask[0];
 };
 
 static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
@@ -925,8 +935,17 @@ struct sched_domain {
 	char *name;
 #endif
 
-	/* span of all CPUs in this domain */
-	unsigned long span[];
+	/*
+	 * Span of all CPUs in this domain.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 *
+	 * It is also be embedded into static data structures at build
+	 * time. (See 'struct static_sched_domain' in kernel/sched.c)
+	 */
+	unsigned long span[0];
 };
 
 static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
diff --git a/kernel/sched.c b/kernel/sched.c
index 497c09b..228acae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7948,8 +7948,9 @@ int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
- * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
- * for nr_cpu_ids < CONFIG_NR_CPUS.
+ *
+ * ( See the the comments in include/linux/sched.h:struct sched_group
+ *   and struct sched_domain. )
  */
 struct static_sched_group {
 	struct sched_group sg;
