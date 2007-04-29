Return-Path: <linux-kernel-owner+w=401wt.eu-S1161578AbXD2XvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161578AbXD2XvC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161624AbXD2Xq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:58 -0400
Received: from mail.suse.de ([195.135.220.2]:41964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161603AbXD2Xqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:30 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: davej@redhat.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [19/26] i386: Enable bank 0 on non K7 Athlon
Message-Id: <20070429234628.F1E2C151C5@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As a bug workaround bank 0 on K7s is normally disabled, but no need
to do that on other AMD CPUs.

Cc: davej@redhat.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/mcheck/k7.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/cpu/mcheck/k7.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/k7.c
+++ linux/arch/i386/kernel/cpu/mcheck/k7.c
@@ -82,9 +82,13 @@ void amd_mcheck_init(struct cpuinfo_x86 
 	nr_mce_banks = l & 0xff;
 
 	/* Clear status for MC index 0 separately, we don't touch CTL,
-	 * as some Athlons cause spurious MCEs when its enabled. */
-	wrmsr (MSR_IA32_MC0_STATUS, 0x0, 0x0);
-	for (i=1; i<nr_mce_banks; i++) {
+	 * as some K7 Athlons cause spurious MCEs when its enabled. */
+	if (boot_cpu_data.x86 == 6) {
+		wrmsr (MSR_IA32_MC0_STATUS, 0x0, 0x0);
+		i = 1;
+	} else
+		i = 0;
+	for (; i<nr_mce_banks; i++) {
 		wrmsr (MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
 		wrmsr (MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
 	}
