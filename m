Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYHSUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYHSUF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYHSUFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:05:07 -0400
Received: from gw.goop.org ([64.81.55.164]:38833 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYHSUFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:05:05 -0400
Message-ID: <48AB2743.5000500@goop.org>
Date: Tue, 19 Aug 2008 13:04:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH] x86_64: use save/loadsegment in ia32 compat
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use savesegment and loadsegment consistently in ia32 compat code.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/ia32/ia32_aout.c   |   11 +++++++----
 arch/x86/ia32/ia32_signal.c |   21 ++++++++++-----------
 include/asm-x86/elf.h       |    5 +++--
 3 files changed, 20 insertions(+), 17 deletions(-)

===================================================================
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -85,8 +85,10 @@
 	dump->regs.ax = regs->ax;
 	dump->regs.ds = current->thread.ds;
 	dump->regs.es = current->thread.es;
-	asm("movl %%fs,%0" : "=r" (fs)); dump->regs.fs = fs;
-	asm("movl %%gs,%0" : "=r" (gs)); dump->regs.gs = gs;
+	savesegment(fs, fs);
+	dump->regs.fs = fs;
+	savesegment(gs, gs);
+	dump->regs.gs = gs;
 	dump->regs.orig_ax = regs->orig_ax;
 	dump->regs.ip = regs->ip;
 	dump->regs.cs = regs->cs;
@@ -430,8 +432,9 @@
 	current->mm->start_stack =
 		(unsigned long)create_aout_tables((char __user *)bprm->p, bprm);
 	/* start thread */
-	asm volatile("movl %0,%%fs" :: "r" (0)); \
-	asm volatile("movl %0,%%es; movl %0,%%ds": :"r" (__USER32_DS));
+	loadsegment(fs, 0);
+	loadsegment(ds, __USER32_DS);
+	loadsegment(es, __USER32_DS);
 	load_gs_index(0);
 	(regs)->ip = ex.a_entry;
 	(regs)->sp = current->mm->start_stack;
===================================================================
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -201,7 +201,7 @@
 	{ unsigned int cur;						\
 	  unsigned short pre;						\
 	  err |= __get_user(pre, &sc->seg);				\
-	  asm volatile("movl %%" #seg ",%0" : "=r" (cur));		\
+	  savesegment(seg, cur);					\
 	  pre |= mask;							\
 	  if (pre != cur) loadsegment(seg, pre); }
 
@@ -230,7 +230,7 @@
 	 */
 	err |= __get_user(gs, &sc->gs);
 	gs |= 3;
-	asm("movl %%gs,%0" : "=r" (oldgs));
+	savesegment(gs, oldgs);
 	if (gs != oldgs)
 		load_gs_index(gs);
 
@@ -350,14 +350,13 @@
 {
 	int tmp, err = 0;
 
-	tmp = 0;
-	__asm__("movl %%gs,%0" : "=r"(tmp): "0"(tmp));
+	savesegment(gs, tmp);
 	err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
-	__asm__("movl %%fs,%0" : "=r"(tmp): "0"(tmp));
+	savesegment(fs, tmp);
 	err |= __put_user(tmp, (unsigned int __user *)&sc->fs);
-	__asm__("movl %%ds,%0" : "=r"(tmp): "0"(tmp));
+	savesegment(ds, tmp);
 	err |= __put_user(tmp, (unsigned int __user *)&sc->ds);
-	__asm__("movl %%es,%0" : "=r"(tmp): "0"(tmp));
+	savesegment(es, tmp);
 	err |= __put_user(tmp, (unsigned int __user *)&sc->es);
 
 	err |= __put_user((u32)regs->di, &sc->di);
@@ -493,8 +492,8 @@
 	regs->dx = 0;
 	regs->cx = 0;
 
-	asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
-	asm volatile("movl %0,%%es" :: "r" (__USER32_DS));
+	loadsegment(ds, __USER32_DS);
+	loadsegment(es, __USER32_DS);
 
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
@@ -588,8 +587,8 @@
 	regs->dx = (unsigned long) &frame->info;
 	regs->cx = (unsigned long) &frame->uc;
 
-	asm volatile("movl %0,%%ds" :: "r" (__USER32_DS));
-	asm volatile("movl %0,%%es" :: "r" (__USER32_DS));
+	loadsegment(ds, __USER32_DS);
+	loadsegment(es, __USER32_DS);
 
 	regs->cs = __USER32_CS;
 	regs->ss = __USER32_DS;
===================================================================
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -148,8 +148,9 @@
 
 static inline void start_ia32_thread(struct pt_regs *regs, u32 ip, u32 sp)
 {
-	asm volatile("movl %0,%%fs" :: "r" (0));
-	asm volatile("movl %0,%%es; movl %0,%%ds" : : "r" (__USER32_DS));
+	loadsegment(fs, 0);
+	loadsegment(ds, __USER32_DS);
+	loadsegment(es, __USER32_DS);
 	load_gs_index(0);
 	regs->ip = ip;
 	regs->sp = sp;


