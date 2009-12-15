Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbZLOELg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbZLOELg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759262AbZLOEL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:11:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbZLOEHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:07:11 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 08/20] Export the reference TSC from KVM module
Date: Mon, 14 Dec 2009 18:08:35 -1000
Message-Id: <1260850127-9766-9-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-8-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
 <1260850127-9766-4-git-send-email-zamsden@redhat.com>
 <1260850127-9766-5-git-send-email-zamsden@redhat.com>
 <1260850127-9766-6-git-send-email-zamsden@redhat.com>
 <1260850127-9766-7-git-send-email-zamsden@redhat.com>
 <1260850127-9766-8-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM now maintains a reference TSC, which can be exported to the
individual backends for private use.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 144a820..170fd5d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -742,6 +742,7 @@ static DEFINE_PER_CPU(int, cpu_tsc_shift);
 static DEFINE_PER_CPU(s64, cpu_tsc_offset);
 static DEFINE_PER_CPU(u64, cpu_tsc_measure_base);
 static DEFINE_PER_CPU(atomic_t, cpu_tsc_synchronized);
+static DEFINE_PER_CPU(int, cpu_tsc_generation);
 static int tsc_base_cpu = -1;
 static unsigned long ref_tsc_khz;
 
@@ -813,6 +814,29 @@ static inline u64 compute_ref_tsc(int cpu)
 	return tsc + per_cpu(cpu_tsc_offset, cpu);
 }
 
+/*
+ * kvm_get_ref_tsc returns a reference TSC value which we attempt to keep
+ * stable across all CPUs, regardless of frequency shift, CPU hotplug, or
+ * pre-existing TSC offsets.
+ */
+u64 kvm_get_ref_tsc(void)
+{
+	int cpu, gen;
+	u64 tsc;
+
+	cpu = get_cpu();
+again:
+	gen = per_cpu(cpu_tsc_generation, cpu);
+	smp_rmb();
+	tsc = compute_ref_tsc(cpu);
+	smp_rmb();
+	if (unlikely(gen != per_cpu(cpu_tsc_generation, cpu)))
+		goto again;
+	put_cpu();
+	return tsc;
+}
+EXPORT_SYMBOL_GPL(kvm_get_ref_tsc);
+
 #define SYNC_TRIES 64
 
 /*
@@ -929,6 +953,7 @@ static void kvm_sync_tsc(void *cpup)
 			accumulator -= delta[i+SYNC_TRIES];
 		accumulator = accumulator / (SYNC_TRIES*2-12);
 		per_cpu(cpu_tsc_offset, new_cpu) = accumulator;
+		++per_cpu(cpu_tsc_generation, new_cpu);
 		atomic_set(&per_cpu(cpu_tsc_synchronized, new_cpu), 1);
 		pr_debug("%s: OUT, cpu = %d, cpu_tsc_offset = %lld, cpu_tsc_multiplier=%ld, cpu_tsc_shift=%d\n", __func__, raw_smp_processor_id(), per_cpu(cpu_tsc_offset, new_cpu), per_cpu(cpu_tsc_multiplier, new_cpu), per_cpu(cpu_tsc_shift, new_cpu));
 	}
-- 
1.6.5.2

