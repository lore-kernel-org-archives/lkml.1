Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZBKOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZBKOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZBKOZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:25:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37226 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbZBKOZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:25:51 -0500
Date: Wed, 11 Feb 2009 15:25:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20090211142534.GA31297@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Hugh Dickins (1):
      profiling: fix broken profiling regression

Steven Rostedt (2):
      tracing, x86: fix fixup section to return to original code
      tracing, x86: fix constraint for parent variable


 arch/x86/kernel/ftrace.c |   17 +++++++++--------
 kernel/profile.c         |    3 +++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b43086..231bdd3 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -488,20 +488,21 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	 * ignore such a protection.
 	 */
 	asm volatile(
-		"1: " _ASM_MOV " (%[parent_old]), %[old]\n"
-		"2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
+		"1: " _ASM_MOV " (%[parent]), %[old]\n"
+		"2: " _ASM_MOV " %[return_hooker], (%[parent])\n"
 		"   movl $0, %[faulted]\n"
+		"3:\n"
 
 		".section .fixup, \"ax\"\n"
-		"3: movl $1, %[faulted]\n"
+		"4: movl $1, %[faulted]\n"
+		"   jmp 3b\n"
 		".previous\n"
 
-		_ASM_EXTABLE(1b, 3b)
-		_ASM_EXTABLE(2b, 3b)
+		_ASM_EXTABLE(1b, 4b)
+		_ASM_EXTABLE(2b, 4b)
 
-		: [parent_replaced] "=r" (parent), [old] "=r" (old),
-		  [faulted] "=r" (faulted)
-		: [parent_old] "0" (parent), [return_hooker] "r" (return_hooker)
+		: [old] "=r" (old), [faulted] "=r" (faulted)
+		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
 		: "memory"
 	);
 
diff --git a/kernel/profile.c b/kernel/profile.c
index 784933a..7724e04 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -114,12 +114,15 @@ int __ref profile_init(void)
 	if (!slab_is_available()) {
 		prof_buffer = alloc_bootmem(buffer_bytes);
 		alloc_bootmem_cpumask_var(&prof_cpu_mask);
+		cpumask_copy(prof_cpu_mask, cpu_possible_mask);
 		return 0;
 	}
 
 	if (!alloc_cpumask_var(&prof_cpu_mask, GFP_KERNEL))
 		return -ENOMEM;
 
+	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
+
 	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
 	if (prof_buffer)
 		return 0;
