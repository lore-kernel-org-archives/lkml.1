Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYIWN5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYIWN5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYIWNsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52440 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbYIWNr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:56 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 34/40] x86: KVM guest: use paravirt function to calculate cpu khz
Date: Tue, 23 Sep 2008 16:46:48 +0300
Message-Id: <1222177614-26669-35-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

We're currently facing timing problems in guests that do
calibration under heavy load, and then the load vanishes.
This means we'll have a much lower lpj than we actually should,
and delays end up taking less time than they should, which is a
nasty bug.

Solution is to pass on the lpj value from host to guest, and have it
preset.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/kvmclock.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index d02def0..774ac49 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -78,6 +78,34 @@ static cycle_t kvm_clock_read(void)
 	return ret;
 }
 
+/*
+ * If we don't do that, there is the possibility that the guest
+ * will calibrate under heavy load - thus, getting a lower lpj -
+ * and execute the delays themselves without load. This is wrong,
+ * because no delay loop can finish beforehand.
+ * Any heuristics is subject to fail, because ultimately, a large
+ * poll of guests can be running and trouble each other. So we preset
+ * lpj here
+ */
+static unsigned long kvm_get_tsc_khz(void)
+{
+	return preset_lpj;
+}
+
+static void kvm_get_preset_lpj(void)
+{
+	struct pvclock_vcpu_time_info *src;
+	unsigned long khz;
+	u64 lpj;
+
+	src = &per_cpu(hv_clock, 0);
+	khz = pvclock_tsc_khz(src);
+
+	lpj = ((u64)khz * 1000);
+	do_div(lpj, HZ);
+	preset_lpj = lpj;
+}
+
 static struct clocksource kvm_clock = {
 	.name = "kvm-clock",
 	.read = kvm_clock_read,
@@ -153,6 +181,7 @@ void __init kvmclock_init(void)
 		pv_time_ops.get_wallclock = kvm_get_wallclock;
 		pv_time_ops.set_wallclock = kvm_set_wallclock;
 		pv_time_ops.sched_clock = kvm_clock_read;
+		pv_time_ops.get_tsc_khz = kvm_get_tsc_khz;
 #ifdef CONFIG_X86_LOCAL_APIC
 		pv_apic_ops.setup_secondary_clock = kvm_setup_secondary_clock;
 #endif
@@ -163,6 +192,7 @@ void __init kvmclock_init(void)
 #ifdef CONFIG_KEXEC
 		machine_ops.crash_shutdown  = kvm_crash_shutdown;
 #endif
+		kvm_get_preset_lpj();
 		clocksource_register(&kvm_clock);
 	}
 }
-- 
1.6.0.1

