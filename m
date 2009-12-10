Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbZLJRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbZLJRT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbZLJRT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:19:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:47008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZLJRT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:19:58 -0500
Date: Thu, 10 Dec 2009 17:18:32 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, gorcunov@openvz.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       Ralf.Hildebrandt@charite.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, gorcunov@openvz.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       Ralf.Hildebrandt@charite.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091210165634.GF5086@lenovo>
References: <20091210165634.GF5086@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86, perf events: Check if we have APIC enabled
Message-ID: <tip-125580380f418000b1a06d9a54700f1191b6e561@git.kernel.org>
Git-Commit-ID: 125580380f418000b1a06d9a54700f1191b6e561
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  125580380f418000b1a06d9a54700f1191b6e561
Gitweb:     http://git.kernel.org/tip/125580380f418000b1a06d9a54700f1191b6e561
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Thu, 10 Dec 2009 19:56:34 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 18:00:30 +0100

x86, perf events: Check if we have APIC enabled

Ralf Hildebrandt reported this boot warning:

| Running a vanilla 2.6.32 as Xen DomU, I'm getting:
|
| [    0.000999] CPU: Physical Processor ID: 0
| [    0.000999] CPU: Processor Core ID: 1
| [    0.000999] Performance Events: AMD PMU driver.
| [    0.000999] ------------[ cut here ]------------
| [    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy

So we need to check if APIC functionality is available, and
not just in the P6 driver but elsewhere as well.

Reported-by: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091210165634.GF5086@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1342f23..18f05ec 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -2066,12 +2066,6 @@ static __init int p6_pmu_init(void)
 
 	x86_pmu = p6_pmu;
 
-	if (!cpu_has_apic) {
-		pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
-		pr_info("no hardware sampling interrupt available.\n");
-		x86_pmu.apic = 0;
-	}
-
 	return 0;
 }
 
@@ -2163,6 +2157,16 @@ static __init int amd_pmu_init(void)
 	return 0;
 }
 
+static void __init pmu_check_apic(void)
+{
+	if (cpu_has_apic)
+		return;
+
+	x86_pmu.apic = 0;
+	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
+	pr_info("no hardware sampling interrupt available.\n");
+}
+
 void __init init_hw_perf_events(void)
 {
 	int err;
@@ -2184,6 +2188,8 @@ void __init init_hw_perf_events(void)
 		return;
 	}
 
+	pmu_check_apic();
+
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
