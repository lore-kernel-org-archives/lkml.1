Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbXLTUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbXLTUJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbXLTUIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:08:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924AbXLTUIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:08:44 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 04/15] provide paravirtualized hook for rdtscp
Date: Thu, 20 Dec 2007 18:03:59 -0200
Message-Id: <1198181215625-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981812041672-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com> <11981811852758-git-send-email-gcosta@redhat.com> <11981812041672-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a field in pv_cpu_ops for a paravirtualized hook
for rdtscp, needed for x86_64.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/paravirt.c |    1 +
 include/asm-x86/paravirt.h |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/paravirt.c	2007-12-20 19:07:15.000000000 -0800
+++ linux-2.6-x86/arch/x86/kernel/paravirt.c	2007-12-20 19:07:22.000000000 -0800
@@ -374,6 +374,7 @@
 	.write_msr = native_write_msr_safe,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
+	.read_tscp = native_read_tscp,
 	.load_tr_desc = native_load_tr_desc,
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:18.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:07:22.000000000 -0800
@@ -120,6 +120,7 @@
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(int counter);
+	unsigned long long (*read_tscp)(unsigned int *aux);
 
 	/* These two are jmp to, not actually called. */
 	void (*irq_enable_syscall_ret)(void);
@@ -668,6 +669,27 @@
 	high = _l >> 32;			\
 } while(0)
 
+static inline unsigned long long paravirt_rdtscp(unsigned int *aux)
+{
+	return PVOP_CALL1(u64, pv_cpu_ops.read_tscp, aux);
+}
+
+#define rdtscp(low, high, aux)				\
+do {							\
+	int __aux;					\
+	unsigned long __val = paravirt_rdtscp(&__aux);	\
+	(low) = (u32)__val;				\
+	(high) = (u32)(__val >> 32);			\
+	(aux) = __aux;					\
+} while (0)
+
+#define rdtscpll(val, aux)				\
+do {							\
+	unsigned long __aux; 				\
+	val = paravirt_rdtscp(&__aux);			\
+	(aux) = __aux;					\
+} while (0)
+
 static inline void load_TR_desc(void)
 {
 	PVOP_VCALL0(pv_cpu_ops.load_tr_desc);
