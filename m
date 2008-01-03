Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbYACAzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbYACAzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYACAuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:20 -0500
Received: from ns1.suse.de ([195.135.220.2]:51788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848AbYACAuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:14 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [17/20] x86: Remove explicit C3 TSC check on 64bit
Message-Id: <20080103005013.2060014D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trust the ACPI code to disable TSC instead when C3 is used.

AMD Fam10h does not disable TSC in any C states so the
check was incorrect there anyways after the change
to handle this like Intel on AMD too.

This allows to use the TSC when C3 is disabled in software
(acpi.max_c_state=2), but the BIOS supports it anyways.

Match i386 behaviour.

Cc: lenb@kernel.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/tsc_64.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: linux/arch/x86/kernel/tsc_64.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_64.c
+++ linux/arch/x86/kernel/tsc_64.c
@@ -277,15 +277,8 @@ __cpuinit int unsynchronized_tsc(void)
 		return 1;
 #endif
 
-	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
-#ifdef CONFIG_ACPI
-		/* But TSC doesn't tick in C3 so don't use it there */
-		if (acpi_gbl_FADT.header.length > 0 &&
-		    acpi_gbl_FADT.C3latency < 1000)
-			return 1;
-#endif
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		return 0;
-	}
 
 	/* Assume multi socket systems are not synchronized */
 	return num_present_cpus() > 1;
