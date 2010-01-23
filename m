Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401Ab0AWAnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0AWAnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100Ab0AWAnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:43:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:52381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0AWAnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:43:01 -0500
Date: Sat, 23 Jan 2010 00:42:35 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1264172467-25155-2-git-send-email-bp@amd64.org>
References: <1264172467-25155-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, lib: Add wbinvd smp helpers
Message-ID: <tip-a7b480e7f30b3813353ec009f10f2ac7a6669f3b@git.kernel.org>
Git-Commit-ID: a7b480e7f30b3813353ec009f10f2ac7a6669f3b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Jan 2010 00:42:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7b480e7f30b3813353ec009f10f2ac7a6669f3b
Gitweb:     http://git.kernel.org/tip/a7b480e7f30b3813353ec009f10f2ac7a6669f3b
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 22 Jan 2010 16:01:03 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 22 Jan 2010 16:05:42 -0800

x86, lib: Add wbinvd smp helpers

Add wbinvd_on_cpu and wbinvd_on_all_cpus stubs for executing wbinvd on a
particular CPU.

[ hpa: renamed lib/smp.c to lib/cache-smp.c ]
[ hpa: wbinvd_on_all_cpus() returns int, but wbinvd() returns
  void.  Thus, the former cannot be a macro for the latter,
  replace with an inline function. ]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-2-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/smp.h |    9 +++++++++
 arch/x86/lib/Makefile      |    2 +-
 arch/x86/lib/cache-smp.c   |   19 +++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1e79678..4cfc908 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -135,6 +135,8 @@ int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
+void wbinvd_on_cpu(int cpu);
+int wbinvd_on_all_cpus(void);
 
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
@@ -147,6 +149,13 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
+#else /* !CONFIG_SMP */
+#define wbinvd_on_cpu(cpu)     wbinvd()
+static inline int wbinvd_on_all_cpus(void)
+{
+	wbinvd();
+	return 0;
+}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..d85e0e4 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 
 clean-files := inat-tables.c
 
-obj-$(CONFIG_SMP) += msr-smp.o
+obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
new file mode 100644
index 0000000..a3c6688
--- /dev/null
+++ b/arch/x86/lib/cache-smp.c
@@ -0,0 +1,19 @@
+#include <linux/smp.h>
+#include <linux/module.h>
+
+static void __wbinvd(void *dummy)
+{
+	wbinvd();
+}
+
+void wbinvd_on_cpu(int cpu)
+{
+	smp_call_function_single(cpu, __wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_cpu);
+
+int wbinvd_on_all_cpus(void)
+{
+	return on_each_cpu(__wbinvd, NULL, 1);
+}
+EXPORT_SYMBOL(wbinvd_on_all_cpus);
