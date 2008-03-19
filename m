Return-Path: <linux-kernel-owner+w=401wt.eu-S1764266AbYCSUKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764266AbYCSUKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYCSTio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbYCSTia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:30 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 70/79] [PATCH] additions to i386 native_smp_prepare_cpus.
Date: Wed, 19 Mar 2008 14:26:05 -0300
Message-Id: <1205947889164-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947885365-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Add function calls to native_smp_prepare_cpus in i386
to match x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index d153d84..6be36d3 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -172,11 +172,23 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	return 0;
 }
 
-/* These are wrappers to interface to the new boot process.  Someone
-   who understands all this stuff should rewrite it properly. --RR 15/Jul/02 */
+static void __init smp_cpu_index_default(void)
+{
+	int i;
+	struct cpuinfo_x86 *c;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		c = &cpu_data(i);
+		/* mark all to hotplug */
+		c->cpu_index = NR_CPUS;
+	}
+}
+
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
  	nmi_watchdog_default();
+ 	smp_cpu_index_default();
+ 	current_cpu_data = boot_cpu_data;
  	cpu_callin_map = cpumask_of_cpu(0);
  	mb();
 
@@ -195,7 +207,11 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	}
 
-	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
+	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_physical_apicid) {
+		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
+		     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_physical_apicid);
+		/* Or can we switch back to PIC here? */
+	}
 
 	connect_bsp_APIC();
 	setup_local_APIC();
-- 
1.5.0.6

