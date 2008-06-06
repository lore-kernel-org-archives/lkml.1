Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbYFFC3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbYFFC3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 22:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763085AbYFFC2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 22:28:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64172 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763127AbYFFC2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 22:28:12 -0400
Date: Fri, 6 Jun 2008 03:27:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: APIC/UP: Downgrade the NMI watchdog for no I/O APIC
Message-ID: <Pine.LNX.4.55.0806060245520.2875@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 If configured to use the I/O APIC, the NMI watchdog is deemed to fail if
the chip will not be used in the UP configuration, because "noapic" has
been specified or the chip is simply not there.  Downgrade to the local
APIC watchdog to rectify.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 The new #ifdef is ugly, I know.  A proper solution is to provide suitable
definitions of smp_found_config, etc. for !CONFIG_X86_IO_APIC in a header.  
Likewise the whole if () condition should be moved to a static inline
function.  Such clean-ups are beyond the scope of this change and can be 
done once the whole issue of the timer has been sorted out.

  Maciej

patch-2.6.26-rc1-20080505-lapic-watchdog-up-1
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/apic_32.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/apic_32.c	2008-06-06 01:04:03.000000000 +0000
@@ -1269,6 +1269,10 @@ int __init APIC_init_uniprocessor(void)
 
 	setup_local_APIC();
 
+#ifdef CONFIG_X86_IO_APIC
+	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
+#endif
+		localise_nmi_watchdog();
 	end_local_APIC_setup();
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config)
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/apic_64.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/apic_64.c	2008-06-06 01:05:35.000000000 +0000
@@ -954,6 +954,8 @@ int __init APIC_init_uniprocessor(void)
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
 
+	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
+		localise_nmi_watchdog();
 	end_local_APIC_setup();
 
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
