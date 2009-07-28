Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZG1RSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZG1RSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZG1RSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:50 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:19596 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753741AbZG1RSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:18 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h87h43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DM-04-A2G-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/26] x86/oprofile: Use per_cpu() instead of __get_cpu_var()
Date: Tue, 28 Jul 2009 19:07:05 +0200
Message-ID: <1248800846-25422-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:47.0869 (UTC) FILETIME=[541E08D0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() calls smp_processor_id(). When the cpu id is already
known, instead use per_cpu() to avoid generating the id again.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index e54f6a0..8cd4658 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -294,7 +294,7 @@ static void nmi_cpu_shutdown(void *dummy)
 {
 	unsigned int v;
 	int cpu = smp_processor_id();
-	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
 
 	/* restoring APIC_LVTPC can trigger an apic error because the delivery
 	 * mode and vector nr combination can be illegal. That's by design: on
@@ -307,7 +307,7 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTERR, v);
 	nmi_cpu_restore_registers(msrs);
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	__get_cpu_var(switch_index) = 0;
+	per_cpu(switch_index, cpu) = 0;
 #endif
 }
 
-- 
1.6.3.3


