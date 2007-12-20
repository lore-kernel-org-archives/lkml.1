Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbXLTULv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbXLTULv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbXLTUK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:10:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758706AbXLTUKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:10:55 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 09/15] adds paravirt hook for swapgs
Date: Thu, 20 Dec 2007 18:04:04 -0200
Message-Id: <11981813192341-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1198181309285-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com> <1198181215625-git-send-email-gcosta@redhat.com> <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds paravirt hook for swapgs operation, which is a privileged
operation in x86_64.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/paravirt.c  |    1 +
 include/asm-x86/paravirt.h  |    9 +++++++++
 include/asm-x86/processor.h |    8 ++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/paravirt.c	2007-12-20 19:07:22.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/paravirt.c	2007-12-20 19:08:06.000000000 -0800
@@ -390,6 +390,7 @@
 
 	.irq_enable_syscall_ret = native_irq_enable_syscall_ret,
 	.iret = native_iret,
+	.swapgs = native_swapgs,
 
 	.set_iopl_mask = native_set_iopl_mask,
 	.io_delay = native_io_delay,
Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:29.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:08:06.000000000 -0800
@@ -127,6 +127,8 @@
 	void (*irq_enable_syscall_ret)(void);
 	void (*iret)(void);
 
+	void (*swapgs)(void);
+
 	struct pv_lazy_ops lazy_mode;
 };
 
@@ -1228,6 +1230,13 @@
 	call *pv_cpu_ops+PV_CPU_read_cr0;	\
 	pop %edx; pop %ecx
 #else
+#define SWAPGS								\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
+		  PV_SAVE_REGS						\
+		  call *pv_cpu_ops+PV_CPU_swapgs;			\
+		  PV_RESTORE_REGS					\
+		 )
+
 #define GET_CR2_INTO_RCX			\
 	call *pv_mmu_ops+PV_MMU_read_cr2;	\
 	movq %rax, %rcx;			\
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h	2007-12-20 19:06:59.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/processor.h	2007-12-20 19:08:06.000000000 -0800
@@ -435,6 +435,13 @@
 #endif
 }
 
+static inline void native_swapgs(void)
+{
+#ifdef CONFIG_X86_64
+	asm volatile("swapgs" ::: "memory");
+#endif
+}
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
@@ -456,6 +463,7 @@
 }
 
 #define set_iopl_mask native_set_iopl_mask
+#define SWAPGS	swapgs
 #endif /* CONFIG_PARAVIRT */
 
 /*
