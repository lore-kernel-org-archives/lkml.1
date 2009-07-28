Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZG1RSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZG1RSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZG1RR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:17:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35089 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZG1RR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:17:59 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DK-03-BLS-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 01/26] x86/oprofile: Rework and simplify nmi_cpu_setup()
Date: Tue, 28 Jul 2009 19:07:01 +0200
Message-ID: <1248800846-25422-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:47.0431 (UTC) FILETIME=[53DB3370:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the function nmi_save_registers(). Per-cpu code is
now executed only in the function nmi_cpu_setup().  Also, it renames
the per-cpu function nmi_restore_registers() to
nmi_cpu_restore_registers().

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 93df76d..25da1e1 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -87,13 +87,6 @@ static void nmi_cpu_save_registers(struct op_msrs *msrs)
 	}
 }
 
-static void nmi_save_registers(void *dummy)
-{
-	int cpu = smp_processor_id();
-	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
-	nmi_cpu_save_registers(msrs);
-}
-
 static void free_msrs(void)
 {
 	int i;
@@ -137,6 +130,7 @@ static void nmi_cpu_setup(void *dummy)
 {
 	int cpu = smp_processor_id();
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
+	nmi_cpu_save_registers(msrs);
 	spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(model, msrs);
 	spin_unlock(&oprofilefs_lock);
@@ -182,13 +176,12 @@ static int nmi_setup(void)
 		}
 
 	}
-	on_each_cpu(nmi_save_registers, NULL, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	return 0;
 }
 
-static void nmi_restore_registers(struct op_msrs *msrs)
+static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
 	struct op_msr *counters = msrs->counters;
 	struct op_msr *controls = msrs->controls;
@@ -220,7 +213,7 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTERR, v | APIC_LVT_MASKED);
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
-	nmi_restore_registers(msrs);
+	nmi_cpu_restore_registers(msrs);
 }
 
 static void nmi_shutdown(void)
-- 
1.6.3.3


