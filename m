Return-Path: <linux-kernel-owner+w=401wt.eu-S964905AbYAaWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbYAaWNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934474AbYAaWKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35693 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934326AbYAaWKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:38 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: silence section mismatch warning in smpboot_64.c
Date: Thu, 31 Jan 2008 23:10:38 +0100
Message-Id: <1201817440-5081-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silence the following warning:
WARNING: o-x86_64/arch/x86/kernel/built-in.o(.text+0x17cd3): Section mismatch in reference from the function remove_cpu_from_maps() to the variable .cpuinit.data:cpu_initialized

remove_cpu:maps() had a single user: __cpu_disable() so
mark it static and annotate it with __ref to silence the
warning from modpost.

_cpu_disable() has a single user in kernel/cpu.c:
 => take_cpu_down()
    which again has a single user in the following call:
    => __stop_machine_run(take_cpu_down, &tcd_param, cpu);
Here a kthread is created.

So maybe the warning is correct and the right fix is to
remove the __cpuinitdata annotation of cpu_initialized?

Note: The analysis were disturbed by the fact that we had a variable
      with the same name in cpu/common.c - but this is 32 bit only]
Note: Should smpboot_64 use cpu_clear()?

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/smpboot_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index cc64b80..d53bd6f 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -1019,7 +1019,7 @@ static void remove_siblinginfo(int cpu)
 	cpu_clear(cpu, cpu_sibling_setup_map);
 }
 
-void remove_cpu_from_maps(void)
+static void __ref remove_cpu_from_maps(void)
 {
 	int cpu = smp_processor_id();
 
-- 
1.5.4.rc3.14.g44397

