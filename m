Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYJWVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYJWVen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYJWVee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:34:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58247 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbYJWVee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:34:34 -0400
Message-ID: <4900EE23.7040904@sgi.com>
Date: Thu, 23 Oct 2008 14:35:31 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Fwd: [PATCH 1/1]: cpumask: fix compiler errors/warnings] - resubmit
 - correct sp error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> On Friday 24 October 2008 01:20:25 Ingo Molnar wrote:
>>> Thomas has started a -tip cross-build test, and there's massive
>>> cross-build failures as well due to the cpumask changes:
>> Yes.  linux-next reported the same thing.  I've backed out various 
>> arch changes for this reason.
>>
>>> it seems to me that this commit is massively borked:
>>>
>>>   4a792c2: cpumask: make CONFIG_NR_CPUS always valid
>> Yep.  This is the big one I dropped.  There are a few others; Mike is 
>> just porting the changes across to your tree now.
> 
> guys. I already spent hours integrating the "latest" of this stuff today 
> and established baseline quality for it on x86. I've dropped 4a792c2 and 
> pushed out a new tip/cpus4096-v2, please send append-only patches for 
> the rest of the changes.
> 
> 	Ingo

Here are the only changes I could find from Rusty's last patches that
apply to tip/cpus4096-v2.

* Fix NR_CPUS reference in arch/powerpc/platforms/cell/spu_base.c

* modify arch/x86/Kconfig so CONFIG_NR_CPUS is always defined.  Also it
  does not prompt if MAXSMP is set.

* change include/linux/threads.h so CONFIG_NR_CPUS is defined for those
  arch's that do not define it.

Signed-of-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-of-by: Mike Travis <travis@sgi.com>
---
Note I haven't been able test anything on this branch, patches or not.
(Everything that has SMP set hangs during startup.  I've tried a number
of approaches to creating a source tree but all fail.)
---
 arch/powerpc/platforms/cell/spu_base.c |    9 ++++++---
 arch/x86/Kconfig                       |    2 +-
 include/linux/threads.h                |   16 ++++++++--------
 3 files changed, 15 insertions(+), 12 deletions(-)

--- linux-2.6-cpus4096-v2.orig/arch/powerpc/platforms/cell/spu_base.c
+++ linux-2.6-cpus4096-v2/arch/powerpc/platforms/cell/spu_base.c
@@ -111,10 +111,13 @@ void spu_flush_all_slbs(struct mm_struct
  */
 static inline void mm_needs_global_tlbie(struct mm_struct *mm)
 {
-	int nr = (NR_CPUS > 1) ? NR_CPUS : NR_CPUS + 1;
-
 	/* Global TLBIE broadcast required with SPEs. */
-	__cpus_setall(&mm->cpu_vm_mask, nr);
+	if (NR_CPUS > 1)
+		cpumask_setall(&mm->cpu_vm_mask);
+	else {
+		cpumask_set_cpu(0, &mm->cpu_vm_mask);
+		cpumask_set_cpu(1, &mm->cpu_vm_mask);
+	}
 }
 
 void spu_associate_mm(struct spu *spu, struct mm_struct *mm)
--- linux-2.6-cpus4096-v2.orig/arch/x86/Kconfig
+++ linux-2.6-cpus4096-v2/arch/x86/Kconfig
@@ -585,9 +585,9 @@ config MAXSMP
 	  If unsure, say N.
 
 config NR_CPUS
-	depends on SMP
  	int "Maximum number of CPUs" if SMP && !MAXSMP
  	range 2 512 if SMP && !MAXSMP
+	default "1" if !SMP
 	default "4096" if MAXSMP
  	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
 	default "8"
--- linux-2.6-cpus4096-v2.orig/include/linux/threads.h
+++ linux-2.6-cpus4096-v2/include/linux/threads.h
@@ -8,17 +8,17 @@
  */
 
 /*
- * Maximum supported processors that can run under SMP.  This value is
- * set via configure setting.  The maximum is equal to the size of the
- * bitmasks used on that platform, i.e. 32 or 64.  Setting this smaller
- * saves quite a bit of memory.
+ * Maximum supported processors.  Setting this smaller saves quite a
+ * bit of memory.  Use nr_cpu_ids instead of this except for static bitmaps.
  */
-#ifdef CONFIG_SMP
-#define NR_CPUS		CONFIG_NR_CPUS
-#else
-#define NR_CPUS		1
+#ifndef CONFIG_NR_CPUS
+/* FIXME: This should be fixed in the arch's Kconfig */
+#define CONFIG_NR_CPUS	1
 #endif
 
+/* Places which use this should consider cpumask_var_t. */
+#define NR_CPUS		CONFIG_NR_CPUS
+
 #define MIN_THREADS_LEFT_FOR_ROOT 4
 
 /*
