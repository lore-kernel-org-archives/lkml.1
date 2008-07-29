Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYG2KL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYG2KL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbYG2KKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:10:39 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:3578 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbYG2KKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QTV/mWRuyZhEbntzbVjPG6Vecz/yqq4TQ5uzZkfGCVFFBNJoyw2Drzk56fDstfj06A
         +PI2VCp+x2wUrfeDBHrMkfR/JRpb/F3eSg8R1qN4VmEuKgCBHv6nEaZ5VbSjeKcVwwCC
         dl6GwfSiQXddflDRVCrww01cVJeZb/0WYtAzI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: printk_time to use tsc before cpu_clock is ready
Date: Tue, 29 Jul 2008 03:09:44 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807290308.35230.yhlu.kernel@gmail.com>
In-Reply-To: <200807290308.35230.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807290309.44869.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so can get tsc value on printk

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
@@ -617,6 +617,15 @@ __setup("clearcpuid=", setup_disablecpui
 
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
@@ -627,6 +636,8 @@ void __init early_cpu_init(void)
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
@@ -215,6 +215,15 @@ static void __init early_cpu_support_pri
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
@@ -227,6 +236,9 @@ void __init early_cpu_init(void)
                 cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
 	early_cpu_support_print();
 	early_identify_cpu(&boot_cpu_data);
+
+	if (cpu_has_tsc)
+		set_printk_time_clock(tsc_clock);
 }
 
 /* Do some early cpuid on the boot CPU to get some parameter that are
