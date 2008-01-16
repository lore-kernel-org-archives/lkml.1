Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYAPWd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYAPWd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbYAPW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:27:13 -0500
Received: from ns.suse.de ([195.135.220.2]:56769 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbYAPW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:27:11 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161127.268350000@suse.de>
In-Reply-To: <200801161127.268350000@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/7] Don't disable the APIC if it hasn't been mapped yet
Message-Id: <20080116222710.BF256150CA@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:27:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When the kernel panics early for some unrelated reason 
there would be eventually an early exception inside panic because 
clear_local_APIC tried to disable the not yet mapped APIC.
Check for that explicitely.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/apic_32.c |   11 ++++++++---
 arch/x86/kernel/apic_64.c |    9 +++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/apic_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic_32.c
+++ linux/arch/x86/kernel/apic_32.c
@@ -99,6 +99,8 @@ static DEFINE_PER_CPU(struct clock_event
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
 
+static unsigned long apic_phys;
+
 /*
  * Get the LAPIC version
  */
@@ -616,9 +618,14 @@ int setup_profiling_timer(unsigned int m
  */
 void clear_local_APIC(void)
 {
-	int maxlvt = lapic_get_maxlvt();
+	int maxlvt;
 	u32 v;
 
+	/* APIC hasn't been mapped yet */
+	if (!apic_phys)
+		return;
+
+	maxlvt = lapic_get_maxlvt();
 	/*
 	 * Masking an LVT entry can trigger a local APIC error
 	 * if the vector is zero. Mask LVTERR first to prevent this.
@@ -1105,8 +1112,6 @@ no_apic:
  */
 void __init init_apic_mappings(void)
 {
-	unsigned long apic_phys;
-
 	/*
 	 * If no local APIC can be found then set up a fake all
 	 * zeroes page to simulate the local APIC and another
Index: linux/arch/x86/kernel/apic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/apic_64.c
+++ linux/arch/x86/kernel/apic_64.c
@@ -81,6 +81,8 @@ static struct clock_event_device lapic_c
 };
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
+static unsigned long apic_phys;
+
 /*
  * Get the LAPIC version
  */
@@ -516,6 +518,11 @@ void clear_local_APIC(void)
 	int maxlvt = lapic_get_maxlvt();
 	u32 v;
 
+	/* APIC hasn't been mapped yet */
+	if (!apic_phys)
+		return;
+
+	maxlvt = lapic_get_maxlvt();
 	/*
 	 * Masking an LVT entry can trigger a local APIC error
 	 * if the vector is zero. Mask LVTERR first to prevent this.
@@ -850,8 +857,6 @@ static int __init detect_init_APIC(void)
  */
 void __init init_apic_mappings(void)
 {
-	unsigned long apic_phys;
-
 	/*
 	 * If no local APIC can be found then set up a fake all
 	 * zeroes page to simulate the local APIC and another
