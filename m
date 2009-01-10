Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZAJVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZAJVou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZAJVom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:44:42 -0500
Received: from kanga.kvack.org ([205.233.56.17]:51929 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbZAJVol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:44:41 -0500
X-Greylist: delayed 1095 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2009 16:44:41 EST
Date: Sat, 10 Jan 2009 16:26:25 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [x86-64] remove locked instruction from switch_to()
Message-ID: <20090110212625.GE13467@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an unnecessary locked instruction from switch_to().  
TIF_FORK is only ever set in copy_thread() on initial process creation, and 
gets cleared during the first scheduling of the process.  As such, it is 
safe to use an unlocked test for the flag within switch_to()./

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 2ed3f0f..ee2e589 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -96,15 +96,15 @@ do {									\
 	     "thread_return:\n\t"					  \
 	     "movq %%gs:%P[pda_pcurrent],%%rsi\n\t"			  \
 	     "movq %P[thread_info](%%rsi),%%r8\n\t"			  \
-	     LOCK_PREFIX "btr  %[tif_fork],%P[ti_flags](%%r8)\n\t"	  \
 	     "movq %%rax,%%rdi\n\t" 					  \
-	     "jc   ret_from_fork\n\t"					  \
+	     "testl  %[_tif_fork],%P[ti_flags](%%r8)\n\t"	  \
+	     "jnz   ret_from_fork\n\t"					  \
 	     RESTORE_CONTEXT						  \
 	     : "=a" (last)					  	  \
 	     : [next] "S" (next), [prev] "D" (prev),			  \
 	       [threadrsp] "i" (offsetof(struct task_struct, thread.sp)), \
 	       [ti_flags] "i" (offsetof(struct thread_info, flags)),	  \
-	       [tif_fork] "i" (TIF_FORK),			  	  \
+	       [_tif_fork] "i" (_TIF_FORK),			  	  \
 	       [thread_info] "i" (offsetof(struct task_struct, stack)),   \
 	       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))  \
 	     : "memory", "cc" __EXTRA_CLOBBER)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b86f332..16b4587 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -247,6 +247,7 @@ ENTRY(native_usergs_sysret64)
  */ 	
 /* rdi:	prev */	
 ENTRY(ret_from_fork)
+	LOCK ; btr $TIF_FORK,TI_flags(%r8)
 	CFI_DEFAULT_STACK
 	push kernel_eflags(%rip)
 	CFI_ADJUST_CFA_OFFSET 8
