Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXGIL2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXGIL2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXGIL2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:28:36 -0400
Received: from il.qumranet.com ([82.166.9.18]:37291 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbXGIL2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:28:35 -0400
Message-ID: <46921BE9.4040801@qumranet.com>
Date: Mon, 09 Jul 2007 14:28:41 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, KVM <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
References: <11838956891287-git-send-email-avi@qumranet.com> <11838956893094-git-send-email-avi@qumranet.com> <p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com> <20070709071640.GB10864@one.firstfloor.org> <46920270.3080309@qumranet.com>
In-Reply-To: <46920270.3080309@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Andi Kleen wrote:
>>> Well, smp_call_function_single() is arch specific whereas on_cpu() is
>>>     
>>
>> Yes, but the few instances should be relatively easy to fix.
>>
>>  
>>> generic code.  Perhaps rename smp_call_function_single() to
>>> __smp_call_function_single() and on_cpu() to 
>>> smp_call_function_single()?
>>>     
>>
>> The low level function checks for this anyways. Instead of erroring
>> it should just DTRT.
>>   
>
> Okay.  I'll make that change.
>
>

Here it is (whitespace-mangled, don't try to apply).

diff --git a/arch/i386/kernel/smpcommon.c b/arch/i386/kernel/smpcommon.c
index 1868ae1..bbfe85a 100644
--- a/arch/i386/kernel/smpcommon.c
+++ b/arch/i386/kernel/smpcommon.c
@@ -47,7 +47,7 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 EXPORT_SYMBOL(smp_call_function);
 
 /**
- * smp_call_function_single - Run a function on another CPU
+ * smp_call_function_single - Run a function on a specific CPU
  * @cpu: The target CPU.  Cannot be the calling CPU.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
@@ -66,9 +66,11 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 	int ret;
 	int me = get_cpu();
 	if (cpu == me) {
-		WARN_ON(1);
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
 		put_cpu();
-		return -EBUSY;
+		return 0;
 	}
 
 	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
diff --git a/arch/x86_64/kernel/smp.c b/arch/x86_64/kernel/smp.c
index 2ff4685..e6e5017 100644
--- a/arch/x86_64/kernel/smp.c
+++ b/arch/x86_64/kernel/smp.c
@@ -357,7 +357,7 @@ __smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 
 /*
- * smp_call_function_single - Run a function on another CPU
+ * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: Currently unused.
@@ -372,16 +372,19 @@ __smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
 	int nonatomic, int wait)
 {
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
 	if (cpu == me) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
 		put_cpu();
 		return 0;
 	}
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	spin_lock_bh(&call_lock);
 	__smp_call_function_single(cpu, func, info, nonatomic, wait);
 	spin_unlock_bh(&call_lock);
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 613edd2..ed38a3d 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -118,7 +118,11 @@ static inline void smp_send_reschedule(int cpu) { }
 static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
 					   void *info, int retry, int wait)
 {
-	return -EBUSY;
+	WARN_ON(cpuid != 0);
+	local_irq_disable();
+	func(info);
+	local_irq_enable();
+	return 0;
 }
 
 #endif /* !SMP */


If there are no objections, I will push it (split up) through my kvm updates patchset, as other kvm patches depend on it.  I will submit patches to other archs through the arch maintainers as kvm doesn't care about them yet.


-- 
error compiling committee.c: too many arguments to function

