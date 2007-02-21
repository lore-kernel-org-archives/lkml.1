Return-Path: <linux-kernel-owner+w=401wt.eu-S964817AbXBUBvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbXBUBvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964822AbXBUBvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:51:21 -0500
Received: from ns.suse.de ([195.135.220.2]:42820 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817AbXBUBvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:51:15 -0500
Date: Tue, 20 Feb 2007 17:49:53 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>, Chuck Ebbert <76306.1226@compuserve.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 03/18] Dont leak NT bit into next task
Message-ID: <20070221014953.GD3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="don-t-leak-nt-bit-into-next-task.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andi Kleen <ak@suse.de>

SYSENTER can cause a NT to be set which might cause crashes on the IRET
in the next task.

Following similar i386 patch from Linus.

Signed-off-by: Andi Kleen <ak@suse.de>
[backport from Chuck Ebbert]
Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86_64/kernel/entry.S   |    4 ++++
 arch/x86_64/kernel/setup64.c |    4 ++++
 include/asm-x86_64/system.h  |    5 +++--
 3 files changed, 11 insertions(+), 2 deletions(-)

--- linux-2.6.18.7.orig/arch/x86_64/kernel/entry.S
+++ linux-2.6.18.7/arch/x86_64/kernel/entry.S
@@ -146,6 +146,10 @@
 /* rdi:	prev */	
 ENTRY(ret_from_fork)
 	CFI_DEFAULT_STACK
+	push kernel_eflags(%rip)
+	CFI_ADJUST_CFA_OFFSET 4
+	popf				# reset kernel eflags
+	CFI_ADJUST_CFA_OFFSET -4
 	call schedule_tail
 	GET_THREAD_INFO(%rcx)
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT),threadinfo_flags(%rcx)
--- linux-2.6.18.7.orig/arch/x86_64/kernel/setup64.c
+++ linux-2.6.18.7/arch/x86_64/kernel/setup64.c
@@ -178,6 +178,8 @@ void __cpuinit check_efer(void)
         }       
 }
 
+unsigned long kernel_eflags;
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -290,4 +292,6 @@ void __cpuinit cpu_init (void)
 	set_debugreg(0UL, 7);
 
 	fpu_init(); 
+
+	raw_local_save_flags(kernel_eflags);
 }
--- linux-2.6.18.7.orig/include/asm-x86_64/system.h
+++ linux-2.6.18.7/include/asm-x86_64/system.h
@@ -14,12 +14,13 @@
 #define __RESTORE(reg,offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
 /* frame pointer must be last for get_wchan */
-#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\n\t"
+#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
 
 #define __EXTRA_CLOBBER  \
 	,"rcx","rbx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"
 
+/* Save restore flags to clear handle leaking NT */
 #define switch_to(prev,next,last) \
 	asm volatile(SAVE_CONTEXT						    \
 		     "movq %%rsp,%P[threadrsp](%[prev])\n\t" /* save RSP */	  \

--
