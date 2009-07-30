Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbZG3JL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbZG3JL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZG3JL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:11:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:13249 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZG3JL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:11:58 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j)
X-WSS-ID: 0KNL862-04-WWJ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] x86, msr: execute on the correct CPU subset
Date: Thu, 30 Jul 2009 11:10:01 +0200
Message-ID: <1248945002-2931-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <4A7099E8.30003@zytor.com>
References: <4A7099E8.30003@zytor.com>
X-OriginalArrivalTime: 30 Jul 2009 09:10:03.0408 (UTC) FILETIME=[85F72900:01CA10F5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make rdmsr_on_cpus/wrmsr_on_cpus execute on the current CPU only if it
is in the supplied bitmask.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/lib/msr.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 1440b9c..caa24ac 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -89,16 +89,13 @@ void rdmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	rv.msrs	  = msrs;
 	rv.msr_no = msr_no;
 
-	preempt_disable();
-	/*
-	 * FIXME: handle the CPU we're executing on separately for now until
-	 * smp_call_function_many has been fixed to not skip it.
-	 */
-	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __rdmsr_on_cpu, &rv, 1);
+	this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		__rdmsr_on_cpu(&rv);
 
 	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
-	preempt_enable();
+	put_cpu();
 }
 EXPORT_SYMBOL(rdmsr_on_cpus);
 
@@ -121,16 +118,13 @@ void wrmsr_on_cpus(const cpumask_t *mask, u32 msr_no, struct msr *msrs)
 	rv.msrs   = msrs;
 	rv.msr_no = msr_no;
 
-	preempt_disable();
-	/*
-	 * FIXME: handle the CPU we're executing on separately for now until
-	 * smp_call_function_many has been fixed to not skip it.
-	 */
-	this_cpu = raw_smp_processor_id();
-	smp_call_function_single(this_cpu, __wrmsr_on_cpu, &rv, 1);
+	this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		__wrmsr_on_cpu(&rv);
 
 	smp_call_function_many(mask, __wrmsr_on_cpu, &rv, 1);
-	preempt_enable();
+	put_cpu();
 }
 EXPORT_SYMBOL(wrmsr_on_cpus);
 
-- 
1.6.3.3


