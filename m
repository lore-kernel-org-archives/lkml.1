Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbXIQXlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbXIQXlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 19:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXIQXk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 19:40:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52152 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbXIQXk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 19:40:57 -0400
Date: Tue, 18 Sep 2007 05:13:40 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Paul Mackerras <paulus@samba.org>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: Avoid pointless WARN_ON(irqs_disabled()) from panic
 codepath
In-Reply-To: <a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
References: <46EA5CEB.7020104@linux.vnet.ibm.com>
 <a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> ------------[ cut here ]------------
> Badness at arch/powerpc/kernel/smp.c:202

comes when smp_call_function_map() has been called with irqs disabled,
which is illegal. However, there is a special case, the panic() codepath,
when we do not want to warn about this -- warning at that time is pointless
anyway, and only serves to scroll away the *real* cause of the panic and
distracts from the real bug.

* So let's extract the WARN_ON() from smp_call_function_map() into all its
  callers -- smp_call_function() and smp_call_function_single()

* Also, introduce another caller of smp_call_function_map(), namely
  __smp_call_function() (and make smp_call_function() a wrapper over this)
  which does *not* warn about disabled irqs

* Use this __smp_call_function() from the panic codepath's smp_send_stop()

We also end having to move code of smp_send_stop() below the definition
of __smp_call_function().

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

Untested (not even compile-tested) patch.
Could someone point me to ppc32/64 cross-compilers for i386?

 arch/powerpc/kernel/smp.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 1ea4316..b24dcba 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -152,11 +152,6 @@ static void stop_this_cpu(void *dummy)
 		;
 }
 
-void smp_send_stop(void)
-{
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
-}
-
 /*
  * Structure and data for smp_call_function(). This is designed to minimise
  * static memory requirements. It also looks cleaner.
@@ -198,9 +193,6 @@ int smp_call_function_map(void (*func) (void *info), void *info, int nonatomic,
 	int cpu;
 	u64 timeout;
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	if (unlikely(smp_ops == NULL))
 		return ret;
 
@@ -270,10 +262,19 @@ int smp_call_function_map(void (*func) (void *info), void *info, int nonatomic,
 	return ret;
 }
 
+static int __smp_call_function(void (*func)(void *info), void *info,
+			       int nonatomic, int wait)
+{
+	return smp_call_function_map(func,info,nonatomic,wait,cpu_online_map);
+}
+
 int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 			int wait)
 {
-	return smp_call_function_map(func,info,nonatomic,wait,cpu_online_map);
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
+	return __smp_call_function(func, info, nonatomic, wait);
 }
 EXPORT_SYMBOL(smp_call_function);
 
@@ -283,6 +284,9 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
 	cpumask_t map = CPU_MASK_NONE;
 	int ret = 0;
 
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
@@ -299,6 +303,11 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+void smp_send_stop(void)
+{
+	__smp_call_function(stop_this_cpu, NULL, 1, 0);
+}
+
 void smp_call_function_interrupt(void)
 {
 	void (*func) (void *info);
