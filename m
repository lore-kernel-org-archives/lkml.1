Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbYAZEdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbYAZEdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 23:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbYAZE2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 23:28:38 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:36237 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYAZE2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 23:28:22 -0500
Message-Id: <20080126042802.072086932@goodmis.org>
References: <20080126042152.526086719@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jan 2008 23:21:58 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/23 -v6] add notrace annotations for NMI routines
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

Index: linux-mcount.git/arch/x86/kernel/nmi_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/nmi_32.c	2008-01-25 21:46:50.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/nmi_32.c	2008-01-25 21:47:08.000000000 -0500
@@ -318,7 +318,7 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 extern void die_nmi(struct pt_regs *, const char *msg);
 
-__kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 
 	/*
Index: linux-mcount.git/arch/x86/kernel/nmi_64.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/nmi_64.c	2008-01-25 21:46:50.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/nmi_64.c	2008-01-25 21:47:08.000000000 -0500
@@ -314,7 +314,7 @@ void touch_nmi_watchdog(void)
  	touch_softlockup_watchdog();
 }
 
-int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
+notrace __kprobes int nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
 	int sum;
 	int touched = 0;
Index: linux-mcount.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/traps_32.c	2008-01-25 21:46:50.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/traps_32.c	2008-01-25 21:47:08.000000000 -0500
@@ -723,7 +723,7 @@ void __kprobes die_nmi(struct pt_regs *r
 	do_exit(SIGSEGV);
 }
 
-static __kprobes void default_do_nmi(struct pt_regs * regs)
+static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 
@@ -763,7 +763,7 @@ static __kprobes void default_do_nmi(str
 
 static int ignore_nmis;
 
-fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
+notrace fastcall __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 

-- 
