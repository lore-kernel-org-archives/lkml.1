Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbYEKNvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbYEKNvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYEKNvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:51:39 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:9968 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYEKNvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:51:38 -0400
Date: Sun, 11 May 2008 15:50:39 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, heukelum@fastmail.fm
Subject: [PATCH] Make for_each_cpu_mask a bit smaller
Message-ID: <20080511135039.GA3286@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sun, 11 May 2008 15:50:45 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.17; VDF: 7.0.4.23; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The for_each_cpu_mask loop is used quite often in the kernel. It
makes use of two functions: first_cpu and next_cpu. This patch
changes for_each_cpu_mask to use only one function: a newly
introduced find_next_cpu. Each use of the for_each_cpu_mask
constuct then becomes a few bytes smaller. An x86_64 defconfig
kernel is about 2000 bytes smaller with this patch applied:

   text	   data	    bss	    dec	    hex	filename
5395732	 976736	 734280	7106748	 6c70bc	vmlinux.orig
5393639	 976736	 734280	7104655	 6c688f	vmlinux

Runs fine on qemu UP/SMP x86_64/i386.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hello Andrew,

Could you add this patch to -mm?

Greetings,
	Alexander

 include/linux/cpumask.h |   14 ++++++++------
 lib/cpumask.c           |    6 ++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9650806..a760e29 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -221,9 +221,11 @@ int __first_cpu(const cpumask_t *srcp);
 #define first_cpu(src) __first_cpu(&(src))
 int __next_cpu(int n, const cpumask_t *srcp);
 #define next_cpu(n, src) __next_cpu((n), &(src))
+int find_next_cpu_mask(int n, const cpumask_t *srcp);
 #else
-#define first_cpu(src)		({ (void)(src); 0; })
-#define next_cpu(n, src)	({ (void)(src); 1; })
+#define first_cpu(src)			({ (void)(src); 0; })
+#define next_cpu(n, src)		({ (void)(src); 1; })
+#define find_next_cpu_mask(n, src)	({ (void)(src); n; })
 #endif
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
@@ -351,10 +353,10 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 }
 
 #if NR_CPUS > 1
-#define for_each_cpu_mask(cpu, mask)		\
-	for ((cpu) = first_cpu(mask);		\
-		(cpu) < NR_CPUS;		\
-		(cpu) = next_cpu((cpu), (mask)))
+#define for_each_cpu_mask(cpu, mask)				\
+	for ((cpu) = 0;						\
+		(cpu) = find_next_cpu_mask((cpu), &(mask)),	\
+		(cpu) < NR_CPUS; (cpu)++)
 #else /* NR_CPUS == 1 */
 #define for_each_cpu_mask(cpu, mask)		\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
diff --git a/lib/cpumask.c b/lib/cpumask.c
index bb4f76d..93dd6ca 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -15,6 +15,12 @@ int __next_cpu(int n, const cpumask_t *srcp)
 }
 EXPORT_SYMBOL(__next_cpu);
 
+int find_next_cpu_mask(int n, const cpumask_t *srcp)
+{
+	return find_next_bit(srcp->bits, NR_CPUS, n);
+}
+EXPORT_SYMBOL(find_next_cpu_mask);
+
 int __any_online_cpu(const cpumask_t *mask)
 {
 	int cpu;
