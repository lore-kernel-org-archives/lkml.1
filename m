Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbYCSUOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbYCSUOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYCSTi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbYCSTin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:43 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 54/79] [PATCH] provide an end_local_APIC_setup function
Date: Wed, 19 Mar 2008 14:25:49 -0300
Message-Id: <12059478181262-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478142946-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

It splits setup_local_APIC in two, providing a function corresponding
to the ending part of it. As a side effect, smp_callin looks the same
between i386 and x86_64.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_32.c    |    7 ++++++-
 arch/x86/kernel/smpboot_32.c |    3 +++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 80c81c7..6f50602 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1064,9 +1064,13 @@ void __cpuinit setup_local_APIC(void)
 	if (!integrated)		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write_around(APIC_LVT1, value);
+}
 
-	lapic_setup_esr();
+void __cpuinit end_local_APIC_setup(void)
+{
+	unsigned long value;
 
+	lapic_setup_esr();
 	/* Disable the local apic timer */
 	value = apic_read(APIC_LVTT);
 	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
@@ -1256,6 +1260,7 @@ int __init APIC_init_uniprocessor(void)
 
 	setup_local_APIC();
 
+	end_local_APIC_setup();
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config)
 		if (!skip_ioapic_setup && nr_ioapics)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index c03596e..dbfaeb3 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -161,6 +161,7 @@ static void __cpuinit smp_callin(void)
 	Dprintk("CALLIN, before setup_local_APIC().\n");
 	smp_callin_clear_local_apic();
 	setup_local_APIC();
+	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
 	/*
@@ -780,6 +781,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 			printk(KERN_INFO "activating minimal APIC for NMI watchdog use.\n");
 			connect_bsp_APIC();
 			setup_local_APIC();
+			end_local_APIC_setup();
 		}
 		return -1;
 	}
@@ -813,6 +815,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 
 	connect_bsp_APIC();
 	setup_local_APIC();
+	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
 
-- 
1.5.0.6

