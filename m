Return-Path: <linux-kernel-owner+w=401wt.eu-S1765338AbYCSUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765338AbYCSUOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYCSTi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206AbYCSTip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:45 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 72/79] [PATCH] change x86_64 native_smp_prepare_cpus to match i386
Date: Wed, 19 Mar 2008 14:26:07 -0300
Message-Id: <12059478973254-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478933780-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

An APIC test is moved, and code is replaced by the mach-default
already defined function (smpboot_setup_io_apic).
setup_portio_remap() is added, but it is a nop in mach-default.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index f4363a3..6679ac5 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -71,6 +71,7 @@ int smp_threads_ready;
 cycles_t cacheflush_time;
 unsigned long cache_decay_ticks;
 
+static int boot_cpu_logical_apicid;
 /*
  * Fall back to non SMP mode after errors.
  *
@@ -167,7 +168,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	nmi_watchdog_default();
 	smp_cpu_index_default();
+	cpu_callin_map = cpumask_of_cpu(0);
+	mb();
+
 	current_cpu_data = boot_cpu_data;
+	boot_cpu_logical_apicid = logical_smp_processor_id();
 	current_thread_info()->cpu = 0;  /* needed? */
 	set_cpu_sibling_map(0);
 
@@ -177,6 +182,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	}
 
+	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_physical_apicid) {
+		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
+		     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_physical_apicid);
+		/* Or can we switch back to PIC here? */
+	}
 
 	/*
 	 * Switch from PIC to APIC mode.
@@ -190,20 +200,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		enable_IO_APIC();
 	end_local_APIC_setup();
 
-	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_physical_apicid) {
-		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
-		     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_physical_apicid);
-		/* Or can we switch back to PIC here? */
-	}
-
-	/*
-	 * Now start the IO-APICs
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else
-		nr_ioapics = 0;
-
 	/*
 	 * Set up local APIC timer on boot CPU.
 	 */
-- 
1.5.0.6

