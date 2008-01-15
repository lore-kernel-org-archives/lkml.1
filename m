Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbYAOUys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbYAOUys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYAOUup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:45 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56904 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbYAOUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:33 -0500
Message-Id: <20080115205022.097196207@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 05/30 v3] add notrace annotations for NMI routines
Content-Disposition: inline; filename=mcount-nmi-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This annotates NMI functions with notrace. Some tracers may be able
to live with this, but some cannot. So we turn off NMI tracing.

One solution might be to make a notrace_nmi which would only turn
off NMI tracing if a trace utility needed it off.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 arch/x86/kernel/nmi_32.c   |    2 +-
 arch/x86/kernel/nmi_64.c   |    2 +-
 arch/x86/kernel/traps_32.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-compile.git/arch/x86/kernel/nmi_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/nmi_32.c	2008-01-14 13:13:58.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/nmi_32.c	2008-01-14 13:14:13.000000000 -0500
@@ -323,7 +323,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 extern void die_nmi(struct pt_regs *, const char *msg);
 
-__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 
 	/*
Index: linux-compile.git/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/nmi_64.c	2008-01-14 13:13:58.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/nmi_64.c	2008-01-14 13:14:13.000000000 -0500
@@ -314,7 +314,7 @@ void touch_nmi_watchdog(void)
  	touch_softlockup_watchdog();
 }
 
-int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 	int sum;
 	int touched = 0;
Index: linux-compile.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-compile.git.orig/arch/x86/kernel/traps_32.c	2008-01-14 13:13:58.000000000 -0500
+++ linux-compile.git/arch/x86/kernel/traps_32.c	2008-01-14 13:14:13.000000000 -0500
@@ -722,7 +722,7 @@ void __kprobes die_nmi(struct pt_regs *r
 	do_exit(SIGSEGV);
 }
 
-static __kprobes void default_do_nmi(struct pt_regs * regs)
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 
@@ -762,7 +762,7 @@ static __kprobes void default_do_nmi(str
 
 static int ignore_nmis;
 
-fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
+notrace fastcall __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 

-- 
