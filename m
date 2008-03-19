Return-Path: <linux-kernel-owner+w=401wt.eu-S1762580AbYCSUCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580AbYCSUCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbYCSThr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbYCSThn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:43 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 17/79] [PATCH] add barriers statement
Date: Wed, 19 Mar 2008 14:25:12 -0300
Message-Id: <12059476531095-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476482875-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

goal is to have i386 and x86_64 closer, so we
add barriers to match

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    4 ++++
 arch/x86/kernel/smpboot_64.c |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 4e5416e..a232f4d 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -180,6 +180,9 @@ static void __cpuinit start_secondary(void *unused)
 	smp_callin();
 	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
 		cpu_relax();
+
+	/* otherwise gcc will move up smp_processor_id before the cpu_init */
+	barrier();
 	/*
 	 * Check TSC synchronization with the BP:
 	 */
@@ -432,6 +435,7 @@ wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
 
+	mb();
 	atomic_set(&init_deasserted, 1);
 
 	/*
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index d7b59d6..a9cc911 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -239,6 +239,7 @@ void __cpuinit start_secondary(void)
 
 	setup_secondary_clock();
 
+	wmb();
 	cpu_idle();
 }
 
-- 
1.5.0.6

