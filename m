Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYFITtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYFITtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbYFITtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:49:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbYFITtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:49:01 -0400
Message-ID: <484D8813.4040807@redhat.com>
Date: Mon, 09 Jun 2008 16:44:19 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> <1213021018-14159-2-git-send-email-gcosta@redhat.com> <1213021018-14159-3-git-send-email-gcosta@redhat.com> <1213021018-14159-4-git-send-email-gcosta@redhat.com> <1213021018-14159-5-git-send-email-gcosta@redhat.com> <1213021018-14159-6-git-send-email-gcosta@redhat.com> <1213021018-14159-7-git-send-email-gcosta@redhat.com> <1213021018-14159-8-git-send-email-gcosta@redhat.com> <1213021018-14159-9-git-send-email-gcosta@redhat.com> <1213021018-14159-10-git-send-email-gcosta@redhat.com> <1213021018-14159-11-git-send-email-gcosta@redhat.com> <1213021018-14159-12-git-send-email-gcosta@redhat.com> <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806091620250.26593@cliff.in.clinika.pl>
Content-Type: multipart/mixed;
 boundary="------------060401050605090806010400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060401050605090806010400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Maciej W. Rozycki wrote:
> On Mon, 9 Jun 2008, Glauber Costa wrote:
> 
>> Do it, instead of keeping in io_apic_32.c. This is the way x86_64
>> already does.
> 
>  This change looks wrong -- is native_smp_prepare_cpus() at all run on
> !CONFIG_SMP?  I don't think so.  You have to do this differently.
> 
>   Maciej

How about this one instead?

This one does enable_IO_APIC in the init_uniprocessor too, and should 
account for the !smp case.

--------------060401050605090806010400
Content-Type: text/x-patch;
 name="0001-x86-move-enabling-of-io_apic-to-prepare_cpus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-move-enabling-of-io_apic-to-prepare_cpus.patch"

>From 87f8366012e1dc3cf7212e241b0aa552d7825338 Mon Sep 17 00:00:00 2001
From: Glauber Costa <gcosta@redhat.com>
Date: Wed, 28 May 2008 17:04:12 -0300
Subject: [PATCH] x86: move enabling of io_apic to prepare_cpus

Do it, instead of keeping in io_apic_32.c. This is the way x86_64 already does.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_32.c    |    3 +++
 arch/x86/kernel/io_apic_32.c |    4 ++--
 arch/x86/kernel/smpboot.c    |    2 +-
 include/asm-x86/hw_irq.h     |    2 --
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index fa8cf79..8385dc6 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1273,6 +1273,9 @@ int __init APIC_init_uniprocessor(void)
 	setup_local_APIC();
 
 #ifdef CONFIG_X86_IO_APIC
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+
 	if (!smp_found_config || skip_ioapic_setup || !nr_ioapics)
 #endif
 		localise_nmi_watchdog();
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 7fc071f..fa4f0a0 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1606,7 +1606,7 @@ void /*__init*/ print_PIC(void)
 
 #endif  /*  0  */
 
-static void __init enable_IO_APIC(void)
+void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
@@ -2295,7 +2295,7 @@ void __init setup_IO_APIC(void)
 	for (i = first_system_vector; i < NR_VECTORS; i++)
 		set_bit(i, used_vectors);
 
-	enable_IO_APIC();
+	/* calling enable_IO_APIC() is moved to setup_local_APIC for BP */
 
 	if (acpi_ioapic)
 		io_apic_irqs = ~0;	/* all IRQs go through IOAPIC */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f5ac5b2..e537c7b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1175,7 +1175,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	setup_local_APIC();
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_IO_APIC
 	/*
 	 * Enable IO APIC before setting up error vector
 	 */
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 18f067c..4c81d1b 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -67,9 +67,7 @@ extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
 extern void setup_ioapic_dest(void);
 
-#ifdef CONFIG_X86_64
 extern void enable_IO_APIC(void);
-#endif
 
 /* IPI functions */
 extern void send_IPI_self(int vector);
-- 
1.5.4.5


--------------060401050605090806010400--
