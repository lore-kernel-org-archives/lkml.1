Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYH0Hkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYH0Hkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYH0Hj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:39:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:17782 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYH0Hjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cNsCw2qHSj3Svgv7yKI8SEeYtzSerbTG1QNcur9/S4QTn6IGspp967YFK3MOL2lT/g
         /Tw7corGZYxKtGBgNYaIxEAvncYJugVdBifrXsGuZfYKZxZhGNChB+b+sazfTjczi3yC
         Mo5P48jsrl602w8h4aShwL5gKzlz5+k0hCXUo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: printk_time to use tsc before cpu_clock is ready
Date: Wed, 27 Aug 2008 00:38:56 -0700
Message-Id: <1219822736-18628-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219822736-18628-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219822736-18628-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so can get tsc value on printk at first.

for debug delay with big system with a lot of memory.

need to apply after
	[PATCH] printk_time: prepare stub for using other than cpu_clock

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common.c    |   11 +++++++++++
 arch/x86/kernel/cpu/common_64.c |   12 ++++++++++++
 2 files changed, 23 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -647,6 +647,15 @@ __setup("clearcpuid=", setup_disablecpui
 
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
+static unsigned long long tsc_clock(int cpu)
+{
+	unsigned long long t;
+
+	rdtscll(t);
+
+	return t;
+}
+
 void __init early_cpu_init(void)
 {
 	struct cpu_vendor_dev *cvdev;
@@ -657,6 +666,8 @@ void __init early_cpu_init(void)
 		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 
 	early_cpu_detect();
+	if (cpu_has_tsc)
+		set_printk_time_clock(tsc_clock);
 	validate_pat_support(&boot_cpu_data);
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -249,6 +249,15 @@ static void __cpuinit detect_nopl(struct
 	}
 }
 
+static unsigned long long tsc_clock(int cpu)
+{
+	unsigned long long t;
+
+	rdtscll(t);
+
+	return t;
+}
+
 static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
 
 void __init early_cpu_init(void)
@@ -261,6 +270,9 @@ void __init early_cpu_init(void)
                 cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 	early_cpu_support_print();
 	early_identify_cpu(&boot_cpu_data);
+
+	if (cpu_has_tsc)
+		set_printk_time_clock(tsc_clock);
 }
 
 /* Do some early cpuid on the boot CPU to get some parameter that are
