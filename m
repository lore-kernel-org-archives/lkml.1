Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYBIPRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYBIPRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYBIPRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:17:03 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:22716 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYBIPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:17:01 -0500
From: Andi Kleen <ak@suse.de>
References: <20080209416.271135970@suse.de>
In-Reply-To: <20080209416.271135970@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/5] Add warning when RTC clock reports binary 
Message-Id: <20080209151659.4F0EA1B41D1@basil.firstfloor.org>
Date: Sat,  9 Feb 2008 16:16:59 +0100 (CET)
X-OriginalArrivalTime: 09 Feb 2008 15:10:38.0736 (UTC) FILETIME=[EDCC7900:01C86B2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We tend to assume the RTC clock is BCD, so print a warning
if it claims to be binary.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/kernel/rtc.c
===================================================================
--- linux.orig/arch/x86/kernel/rtc.c
+++ linux/arch/x86/kernel/rtc.c
@@ -94,6 +94,8 @@ int mach_set_rtc_mmss(unsigned long nowt
 
 unsigned long mach_get_cmos_time(void)
 {
+	unsigned status;
+	static int warned;
 	unsigned int year, mon, day, hour, min, sec, century = 0;
 
 	/*
@@ -119,7 +121,13 @@ unsigned long mach_get_cmos_time(void)
 		century = CMOS_READ(acpi_gbl_FADT.century);
 #endif
 
-	if (RTC_ALWAYS_BCD || !(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY)) {
+	status = CMOS_READ(RTC_CONTROL);
+	if (RTC_ALWAYS_BCD && (status & RTC_DM_BINARY) && !warned) {
+		printk(KERN_INFO "RTC clock reports binary. Ignored\n");
+		warned = 1;
+	}
+
+	if (RTC_ALWAYS_BCD || !(status & RTC_DM_BINARY)) {
 		BCD_TO_BIN(sec);
 		BCD_TO_BIN(min);
 		BCD_TO_BIN(hour);
