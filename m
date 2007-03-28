Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbXC1TS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbXC1TS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXC1TS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:18:29 -0400
Received: from gw.goop.org ([64.81.55.164]:50681 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbXC1TS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:18:28 -0400
Message-ID: <460ABF84.5060201@goop.org>
Date: Wed, 28 Mar 2007 12:18:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Stephane Eranian <eranian@hpl.hp.com>, Ingo Molnar <mingo@elte.hu>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] Simplify smp_call_function*() by using common implementation
References: <46099709.2000304@goop.org> <200703282103.50191.ak@suse.de>
In-Reply-To: <200703282103.50191.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wednesday 28 March 2007 00:13, Jeremy Fitzhardinge wrote:
>   
>> smp_call_function and smp_call_function_single are almost complete
>> duplicates of the same logic.  This patch combines them by
>> implementing them in terms of the more general
>> smp_call_function_mask().
>>     
>
> I think I got those already.
>   

OK.  Do you have smp_ops and machine_ops?

There's a doc update patch too:

Subject: Fix smp_call_function* docs

As reported by Randy Dunlap <rdunlap@xenotime.net>

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>

---
 arch/i386/kernel/smp.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

===================================================================
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -570,8 +570,10 @@ static int __smp_call_function_mask(cpum
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have finished.
+  * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
@@ -593,11 +595,13 @@ int smp_call_function_mask(cpumask_t mas
  * smp_call_function(): Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: currently unused.
+ * @nonatomic: Unused.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
- * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
@@ -609,17 +613,18 @@ int smp_call_function(void (*func) (void
 }
 EXPORT_SYMBOL(smp_call_function);
 
-/*
+/**
  * smp_call_function_single - Run a function on another CPU
+ * @cpu: The target CPU.  Cannot be the calling CPU.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: Currently unused.
+ * @nonatomic: Unused.
  * @wait: If true, wait until function has completed on other CPUs.
  *
- * Retrurns 0 on success, else a negative status code.
- *
- * Does not return until the remote CPU is nearly ready to execute <func>
- * or is or has executed.
+ * Returns 0 on success, else a negative status code.
+ *
+ * If @wait is true, then returns once @func has returned; otherwise
+ * it returns just before the target cpu calls @func.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int nonatomic, int wait)

