Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYH1DEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYH1DEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 23:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYH1DD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 23:03:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58001
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbYH1DDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 23:03:55 -0400
Date: Wed, 27 Aug 2008 20:03:50 -0700 (PDT)
Message-Id: <20080827.200350.79735512.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: sparc build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080827.190409.80969099.davem@davemloft.net>
References: <20080828114602.6c6df4a2.sfr@canb.auug.org.au>
	<20080827.190409.80969099.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 27 Aug 2008 19:04:09 -0700 (PDT)

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 28 Aug 2008 11:46:02 +1000
> 
> > Linus' tree fails to build for sparc32 allmodconfig:
> > 
> > kernel/relay.c:701: undefined reference to `smp_call_function_single'
> > 
> > This is because it has CONFIG_SMP but not CONFIG_USE_GENERIC_SMP_HELPERS.
> > 
> > I am not sure what to do about this.
> 
> I'll try to come up with a fix for this, thanks.

Here's what I'll likely push to linus to fix this.

Thanks for the report Stephen.

sparc32: Implement smp_call_function_single().

Reported by Stephen Rothwell.

Needed to fix the build when CONFIG_RELAY is enabled.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/smp_32.h |   25 +++++++++++++++----------
 arch/sparc/kernel/sun4d_smp.c   |   16 ++++++++++------
 arch/sparc/kernel/sun4m_smp.c   |   12 ++++++++----
 3 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/arch/sparc/include/asm/smp_32.h b/arch/sparc/include/asm/smp_32.h
index 7201752..a8180e5 100644
--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -50,27 +50,24 @@ struct seq_file;
 void smp_bogo(struct seq_file *);
 void smp_info(struct seq_file *);
 
-BTFIXUPDEF_CALL(void, smp_cross_call, smpfunc_t, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)
+BTFIXUPDEF_CALL(void, smp_cross_call, smpfunc_t, cpumask_t, unsigned long, unsigned long, unsigned long, unsigned long)
 BTFIXUPDEF_CALL(int, __hard_smp_processor_id, void)
 BTFIXUPDEF_BLACKBOX(hard_smp_processor_id)
 BTFIXUPDEF_BLACKBOX(load_current)
 
-#define smp_cross_call(func,arg1,arg2,arg3,arg4,arg5) BTFIXUP_CALL(smp_cross_call)(func,arg1,arg2,arg3,arg4,arg5)
+#define smp_cross_call(func,mask,arg1,arg2,arg3,arg4) BTFIXUP_CALL(smp_cross_call)(func,mask,arg1,arg2,arg3,arg4)
 
-static inline void xc0(smpfunc_t func) { smp_cross_call(func, 0, 0, 0, 0, 0); }
+static inline void xc0(smpfunc_t func) { smp_cross_call(func, cpu_online_map, 0, 0, 0, 0); }
 static inline void xc1(smpfunc_t func, unsigned long arg1)
-{ smp_cross_call(func, arg1, 0, 0, 0, 0); }
+{ smp_cross_call(func, cpu_online_map, arg1, 0, 0, 0); }
 static inline void xc2(smpfunc_t func, unsigned long arg1, unsigned long arg2)
-{ smp_cross_call(func, arg1, arg2, 0, 0, 0); }
+{ smp_cross_call(func, cpu_online_map, arg1, arg2, 0, 0); }
 static inline void xc3(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 			   unsigned long arg3)
-{ smp_cross_call(func, arg1, arg2, arg3, 0, 0); }
+{ smp_cross_call(func, cpu_online_map, arg1, arg2, arg3, 0); }
 static inline void xc4(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4)
-{ smp_cross_call(func, arg1, arg2, arg3, arg4, 0); }
-static inline void xc5(smpfunc_t func, unsigned long arg1, unsigned long arg2,
-			   unsigned long arg3, unsigned long arg4, unsigned long arg5)
-{ smp_cross_call(func, arg1, arg2, arg3, arg4, arg5); }
+{ smp_cross_call(func, cpu_online_map, arg1, arg2, arg3, arg4); }
 
 static inline int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
@@ -78,6 +75,14 @@ static inline int smp_call_function(void (*func)(void *info), void *info, int wa
 	return 0;
 }
 
+static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
+					   void *info, int wait)
+{
+	smp_cross_call((smpfunc_t)func, cpumask_of_cpu(cpuid),
+		       (unsigned long) info, 0, 0, 0);
+	return 0;
+}
+
 static inline int cpu_logical_map(int cpu)
 {
 	return cpu;
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index dfde77f..6959640 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -262,8 +262,9 @@ static struct smp_funcall {
 static DEFINE_SPINLOCK(cross_call_lock);
 
 /* Cross calls must be serialized, at least currently. */
-void smp4d_cross_call(smpfunc_t func, unsigned long arg1, unsigned long arg2,
-		    unsigned long arg3, unsigned long arg4, unsigned long arg5)
+static void smp4d_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
+			     unsigned long arg2, unsigned long arg3,
+			     unsigned long arg4)
 {
 	if(smp_processors_ready) {
 		register int high = smp_highest_cpu;
@@ -278,7 +279,7 @@ void smp4d_cross_call(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 			register unsigned long a2 asm("i2") = arg2;
 			register unsigned long a3 asm("i3") = arg3;
 			register unsigned long a4 asm("i4") = arg4;
-			register unsigned long a5 asm("i5") = arg5;
+			register unsigned long a5 asm("i5") = 0;
 
 			__asm__ __volatile__(
 				"std %0, [%6]\n\t"
@@ -290,11 +291,10 @@ void smp4d_cross_call(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 
 		/* Init receive/complete mapping, plus fire the IPI's off. */
 		{
-			cpumask_t mask;
 			register int i;
 
-			mask = cpumask_of_cpu(hard_smp4d_processor_id());
-			cpus_andnot(mask, cpu_online_map, mask);
+			cpu_clear(smp_processor_id(), mask);
+			cpus_and(mask, cpu_online_map, mask);
 			for(i = 0; i <= high; i++) {
 				if (cpu_isset(i, mask)) {
 					ccall_info.processors_in[i] = 0;
@@ -309,12 +309,16 @@ void smp4d_cross_call(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 
 			i = 0;
 			do {
+				if (!cpu_isset(i, mask))
+					continue;
 				while(!ccall_info.processors_in[i])
 					barrier();
 			} while(++i <= high);
 
 			i = 0;
 			do {
+				if (!cpu_isset(i, mask))
+					continue;
 				while(!ccall_info.processors_out[i])
 					barrier();
 			} while(++i <= high);
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 406ac1a..a14a76a 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -244,9 +244,9 @@ static struct smp_funcall {
 static DEFINE_SPINLOCK(cross_call_lock);
 
 /* Cross calls must be serialized, at least currently. */
-static void smp4m_cross_call(smpfunc_t func, unsigned long arg1,
+static void smp4m_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
 			     unsigned long arg2, unsigned long arg3,
-			     unsigned long arg4, unsigned long arg5)
+			     unsigned long arg4)
 {
 		register int ncpus = SUN4M_NCPUS;
 		unsigned long flags;
@@ -259,14 +259,14 @@ static void smp4m_cross_call(smpfunc_t func, unsigned long arg1,
 		ccall_info.arg2 = arg2;
 		ccall_info.arg3 = arg3;
 		ccall_info.arg4 = arg4;
-		ccall_info.arg5 = arg5;
+		ccall_info.arg5 = 0;
 
 		/* Init receive/complete mapping, plus fire the IPI's off. */
 		{
-			cpumask_t mask = cpu_online_map;
 			register int i;
 
 			cpu_clear(smp_processor_id(), mask);
+			cpus_and(mask, cpu_online_map, mask);
 			for(i = 0; i < ncpus; i++) {
 				if (cpu_isset(i, mask)) {
 					ccall_info.processors_in[i] = 0;
@@ -284,12 +284,16 @@ static void smp4m_cross_call(smpfunc_t func, unsigned long arg1,
 
 			i = 0;
 			do {
+				if (!cpu_isset(i, mask))
+					continue;
 				while(!ccall_info.processors_in[i])
 					barrier();
 			} while(++i < ncpus);
 
 			i = 0;
 			do {
+				if (!cpu_isset(i, mask))
+					continue;
 				while(!ccall_info.processors_out[i])
 					barrier();
 			} while(++i < ncpus);
-- 
1.5.6.5.GIT

