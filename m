Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbYA3D0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbYA3D0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYA3DT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:19:29 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:53706 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYA3DS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:18:56 -0500
Message-Id: <20080130031841.482792335@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 22:15:30 -0500
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
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/22 -v7] add notrace annotations to timing events
Content-Disposition: inline; filename=mcount-add-time-notrace-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds notrace annotations to timer functions
that will be used by tracing. This helps speed things up and
also keeps the ugliness of printing these functions down.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/apic_32.c     |    2 +-
 arch/x86/kernel/hpet.c        |    2 +-
 arch/x86/kernel/time_32.c     |    2 +-
 arch/x86/kernel/tsc_32.c      |    2 +-
 arch/x86/kernel/tsc_64.c      |    4 ++--
 arch/x86/lib/delay_32.c       |    6 +++---
 drivers/clocksource/acpi_pm.c |    8 ++++----
 7 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-mcount.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/apic_32.c	2008-01-29 11:35:35.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/apic_32.c	2008-01-29 11:49:47.000000000 -0500
@@ -577,7 +577,7 @@ static void local_apic_timer_interrupt(v
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
 
-void fastcall smp_apic_timer_interrupt(struct pt_regs *regs)
+notrace fastcall void smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
Index: linux-mcount.git/arch/x86/kernel/hpet.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/hpet.c	2008-01-29 11:35:35.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/hpet.c	2008-01-29 11:49:47.000000000 -0500
@@ -295,7 +295,7 @@ static int hpet_legacy_next_event(unsign
 /*
  * Clock source related code
  */
-static cycle_t read_hpet(void)
+static notrace cycle_t read_hpet(void)
 {
 	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
Index: linux-mcount.git/arch/x86/kernel/time_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/time_32.c	2008-01-29 11:35:35.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/time_32.c	2008-01-29 11:49:47.000000000 -0500
@@ -122,7 +122,7 @@ static int set_rtc_mmss(unsigned long no
 
 int timer_ack;
 
-unsigned long profile_pc(struct pt_regs *regs)
+notrace unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
 
Index: linux-mcount.git/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/tsc_32.c	2008-01-29 11:35:35.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/tsc_32.c	2008-01-29 11:49:47.000000000 -0500
@@ -269,7 +269,7 @@ core_initcall(cpufreq_tsc);
 
 static unsigned long current_tsc_khz = 0;
 
-static cycle_t read_tsc(void)
+static notrace cycle_t read_tsc(void)
 {
 	cycle_t ret;
 
Index: linux-mcount.git/arch/x86/kernel/tsc_64.c
===================================================================
--- linux-mcount.git.orig/arch/x86/kernel/tsc_64.c	2008-01-29 11:35:35.000000000 -0500
+++ linux-mcount.git/arch/x86/kernel/tsc_64.c	2008-01-29 11:49:47.000000000 -0500
@@ -248,13 +248,13 @@ __setup("notsc", notsc_setup);
 
 
 /* clock source code: */
-static cycle_t read_tsc(void)
+static notrace cycle_t read_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
 	return ret;
 }
 
-static cycle_t __vsyscall_fn vread_tsc(void)
+static notrace cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret = (cycle_t)get_cycles_sync();
 	return ret;
Index: linux-mcount.git/arch/x86/lib/delay_32.c
===================================================================
--- linux-mcount.git.orig/arch/x86/lib/delay_32.c	2008-01-29 11:35:35.000000000 -0500
+++ linux-mcount.git/arch/x86/lib/delay_32.c	2008-01-29 11:49:47.000000000 -0500
@@ -24,7 +24,7 @@
 #endif
 
 /* simple loop based delay: */
-static void delay_loop(unsigned long loops)
+static notrace void delay_loop(unsigned long loops)
 {
 	int d0;
 
@@ -39,7 +39,7 @@ static void delay_loop(unsigned long loo
 }
 
 /* TSC based delay: */
-static void delay_tsc(unsigned long loops)
+static notrace void delay_tsc(unsigned long loops)
 {
 	unsigned long bclock, now;
 
@@ -72,7 +72,7 @@ int read_current_timer(unsigned long *ti
 	return -1;
 }
 
-void __delay(unsigned long loops)
+notrace void __delay(unsigned long loops)
 {
 	delay_fn(loops);
 }
Index: linux-mcount.git/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-mcount.git.orig/drivers/clocksource/acpi_pm.c	2008-01-29 11:35:35.000000000 -0500
+++ linux-mcount.git/drivers/clocksource/acpi_pm.c	2008-01-29 11:49:47.000000000 -0500
@@ -30,13 +30,13 @@
  */
 u32 pmtmr_ioport __read_mostly;
 
-static inline u32 read_pmtmr(void)
+static inline notrace u32 read_pmtmr(void)
 {
 	/* mask the output to 24 bits */
 	return inl(pmtmr_ioport) & ACPI_PM_MASK;
 }
 
-u32 acpi_pm_read_verified(void)
+notrace u32 acpi_pm_read_verified(void)
 {
 	u32 v1 = 0, v2 = 0, v3 = 0;
 
@@ -56,12 +56,12 @@ u32 acpi_pm_read_verified(void)
 	return v2;
 }
 
-static cycle_t acpi_pm_read_slow(void)
+static notrace cycle_t acpi_pm_read_slow(void)
 {
 	return (cycle_t)acpi_pm_read_verified();
 }
 
-static cycle_t acpi_pm_read(void)
+static notrace cycle_t acpi_pm_read(void)
 {
 	return (cycle_t)read_pmtmr();
 }

-- 
