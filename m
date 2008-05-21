Return-Path: <linux-kernel-owner+w=401wt.eu-S937751AbYEUVNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937751AbYEUVNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937432AbYEUVKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:10:37 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63939 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756464AbYEUVKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:10:32 -0400
Date: Wed, 21 May 2008 22:10:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] x86: APIC/SMP: Downgrade the NMI watchdog for "nosmp"
Message-ID: <Pine.LNX.4.55.0805212035540.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 If configured to use the I/O APIC, the NMI watchdog is deemed to fail if 
the chip has been deactivated as a result of "nosmp".  Downgrade to the 
local APIC watchdog similarly to what is done for the UP case.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-nosmp-watchdog-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/smpboot.c linux-2.6.26-rc1-20080505/arch/x86/kernel/smpboot.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/smpboot.c	2008-05-21 06:24:25.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/smpboot.c	2008-05-21 06:24:25.000000000 +0000
@@ -1147,6 +1147,10 @@ static int __init smp_sanity_check(unsig
 	if (!max_cpus) {
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		smpboot_clear_io_apic();
+
+		if (nmi_watchdog != NMI_NONE && nmi_watchdog != NMI_DISABLED)
+			nmi_watchdog = NMI_LOCAL_APIC;
+
 #ifdef CONFIG_X86_32
 		connect_bsp_APIC();
 #endif
