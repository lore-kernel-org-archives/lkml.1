Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbXFGPsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbXFGPsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762197AbXFGPsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:48:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:2760 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbXFGPsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=azf2qnX9vRwC+Ag7NBCiV1bwp7e7tpHHYEfECDMvOCvF6OvjE1jZY4D104BKppyb8iGD1apaUW1WSsQm5CDfxnJFfCZjnV60sXP6RYAgeUO72TDxa6n6suzqQIy0ATMyMWV2iANEM1s98EwL0lutBId/yPZks/FbEibxperUQBU=
Message-ID: <a781481a0706070848j2256cc1elea8723778ab7da5b@mail.gmail.com>
Date: Thu, 7 Jun 2007 21:18:37 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make smp_call_function{_single} go WARNING and return -EINVAL on !SMP (was Re: [PATCH] i386/x86_64: NMI watchdog: Protect smp_call_function() within CONFIG_SMP)
Cc: "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Alan Cox" <alan@redhat.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> [...]
> BTW: smp_call_function() simply returns 0 and
> smp_call_function_single() simply returns -EBUSY when !SMP.
> These appear to be just some ad hoc values. IMHO, we should
> be going BUG() in both these cases because "other" CPUs for
> !SMP are undefined / meaningless.

79974a0e4c6be6e9a3717b4c5a5d5c44c36b1653 from a couple
weeks back (discussed on http://lkml.org/lkml/2007/5/14/68 i.e.
[patch] Let smp_call_function_single return -EBUSY.) introduced
this behaviour. [ Adding Heiko Carstens, Andrew and David Miller
to Cc: list. ]

I realized a warning would be more appropriate for this case than
a BUG at the last moment ... this doesn't quite meet Linus' "You
killed my father; prepare to die!" criterion :-)

---

The smp_call_function{_single} functions are used to run
given function on all {or speicified} *other* CPUs. For
UP systems, "other" CPUs simply don't exist, so we flag
such incorrect usage of these functions using a WARNING.

Also, -EBUSY is generally returned by arch implementations
when they find that target_cpu == current_cpu, which is not
a comparable case to the !SMP case. Use -EINVAL instead,
similar to what powerpc does for !cpu_online(target), which
is somewhat more analogous.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>

---

 include/linux/smp.h |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

---

diff -ruNp a/include/linux/smp.h b/include/linux/smp.h
--- a/include/linux/smp.h	2007-06-07 12:46:50.000000000 +0530
+++ b/include/linux/smp.h	2007-06-07 21:13:29.000000000 +0530
@@ -6,6 +6,7 @@
  *		Alan Cox. <alan@redhat.com>
  */

+#include <linux/bug.h>
 #include <linux/errno.h>

 extern void cpu_idle(void);
@@ -84,11 +85,6 @@ void smp_prepare_boot_cpu(void);
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-static inline int up_smp_call_function(void)
-{
-	return 0;
-}
-#define smp_call_function(func,info,retry,wait)	(up_smp_call_function())
 #define on_each_cpu(func,info,retry,wait)	\
 	({					\
 		local_irq_disable();		\
@@ -99,10 +95,17 @@ static inline int up_smp_call_function(v
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
+static inline int smp_call_function(void (*func)(void *info),
+				    void *info, int retry, int wait)
+{
+	WARN_ON(1);
+	return -EINVAL;
+}
 static inline int smp_call_function_single(int cpuid, void (*func)
(void *info),
 					   void *info, int retry, int wait)
 {
-	return -EBUSY;
+	WARN_ON(1);
+	return -EINVAL;
 }

 #endif /* !SMP */
