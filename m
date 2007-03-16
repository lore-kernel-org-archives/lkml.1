Return-Path: <linux-kernel-owner+w=401wt.eu-S1750964AbXCPDji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbXCPDji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 23:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXCPDji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 23:39:38 -0400
Received: from xenotime.net ([66.160.160.81]:38104 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750709AbXCPDjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 23:39:37 -0400
Date: Thu, 15 Mar 2007 19:38:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephane Eranian <eranian@hpl.hp.com>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 10/34] Xen-pv_ops: Simplify smp_call_function*() by
 using common implementation
Message-Id: <20070315193804.e8867472.rdunlap@xenotime.net>
In-Reply-To: <20070313233031.149028836@goop.org>
References: <20070313233017.933601256@goop.org>
	<20070313233031.149028836@goop.org>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007 16:30:27 -0700 Jeremy Fitzhardinge wrote:

> smp_call_function and smp_call_function_single are almost complete
> duplicates of the same logic.  This patch combines them by
> implementing them in terms of the more general
> smp_call_function_mask().

The kernel-doc is still not quite correct.  Patch below applies
on top of this patch from Jeremy.
---

From: Randy Dunlap <randy.dunlap@oracle.com>

Clean up arch/i386/kernel/smp.c after the Xen pv_ops patches for
smp_call_function variants.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/i386/kernel/smp.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux-2621-rc3.orig/arch/i386/kernel/smp.c
+++ linux-2621-rc3/arch/i386/kernel/smp.c
@@ -517,14 +517,14 @@ static struct call_data_struct *call_dat
 
 
 /**
- * smp_call_function_mask(): Run a function on a set of other CPUs.
+ * smp_call_function_mask - Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on.  Must not include the current cpu.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
  * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have finished.
+ * remote CPUs are nearly ready to execute func() or are or have finished.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
@@ -583,14 +583,14 @@ int smp_call_function_mask(cpumask_t mas
 }
 
 /**
- * smp_call_function(): Run a function on all other CPUs.
+ * smp_call_function - Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: currently unused.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
  * Returns 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
+ * remote CPUs are nearly ready to execute func() or are or have executed.
  *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
@@ -602,8 +602,9 @@ int smp_call_function(void (*func) (void
 }
 EXPORT_SYMBOL(smp_call_function);
 
-/*
+/**
  * smp_call_function_single - Run a function on another CPU
+ * @cpu: The target (destination) CPU number.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: Currently unused.
@@ -611,7 +612,7 @@ EXPORT_SYMBOL(smp_call_function);
  *
  * Retrurns 0 on success, else a negative status code.
  *
- * Does not return until the remote CPU is nearly ready to execute <func>
+ * Does not return until the remote CPU is nearly ready to execute func()
  * or is or has executed.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
