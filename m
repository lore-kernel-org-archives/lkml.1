Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbYLXOtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbYLXOtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 09:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYLXOtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 09:49:01 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37371 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbYLXOtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 09:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XwGpzltuI8BC+Sw8JnW6/WupirzG17MjQxOOvcb9akac0955fDUuXrwZQrNjM02hNj
         FgICH3jSvXCafIt5g6jkLIDRRjF0qE3kRfRp803WT8cN1w10srTgy5USWhWUpy72Wjo8
         j4l6vEeu16C8B4BUTV0eof7xQWKKUtnsdwXMc=
Message-ID: <49524BD5.9010106@gmail.com>
Date: Wed, 24 Dec 2008 15:48:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] tracing/ftrace: don't trace on early stage of a secondary
 cpu boot
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a crash/hard-reboot while enabling cpu on runtime

On some archs, the boot of a secondary cpu can have an early fragile state.
On x86-64, the pda is not initialized on the first stage of a cpu boot but
it is needed to get the cpu number and the current task pointer. These datas
are needed during tracing. As they were dereferenced at this stage, we got a
crash while turning on a cpu on runtime while tracing.

Some other archs like ia64 can have such kind of issue too.

Changes on v2:

We drop the previous solution of a per-arch called function to guess the current state
of a cpu. That could make slow the tracing.
This patch just drop the -pg flag on arch/x86/kernel/cpu/common.c where
live the low level cpu boot functions, and on start_secondary() and a helper
function used at this stage.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/msr.h   |    3 ++-
 arch/x86/kernel/cpu/Makefile |    5 +++++
 arch/x86/kernel/smpboot.c    |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 4640ddd..638bf62 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -85,7 +85,8 @@ static inline void native_write_msr(unsigned int msr,
 	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
 }
 
-static inline int native_write_msr_safe(unsigned int msr,
+/* Can be uninlined because referenced by paravirt */
+notrace static inline int native_write_msr_safe(unsigned int msr,
 					unsigned low, unsigned high)
 {
 	int err;
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index fc99173..c381330 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -2,6 +2,11 @@
 # Makefile for x86-compatible CPU details, features and quirks
 #
 
+# Don't trace early stages of a secondary CPU boot
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_common.o = -pg
+endif
+
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b1d571b..31869bf 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -282,7 +282,7 @@ static int __cpuinitdata unsafe_smp;
 /*
  * Activate a secondary processor.
  */
-static void __cpuinit start_secondary(void *unused)
+notrace static void __cpuinit start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
-- 
1.6.0.4

