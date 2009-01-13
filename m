Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZAMKkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZAMKkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZAMKjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:51121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbZAMKjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:15 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/13] x86: make early_per_cpu() a lvalue and use it
Date: Tue, 13 Jan 2009 19:38:06 +0900
Message-Id: <1231843097-18003-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make early_per_cpu() a lvalue as per_cpu() is and use it where
applicable.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h   |    6 +++---
 arch/x86/include/asm/topology.h |    5 +----
 arch/x86/kernel/apic.c          |   13 ++-----------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index ece7205..df644f3 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -195,9 +195,9 @@ do {							\
 #define	early_per_cpu_ptr(_name) (_name##_early_ptr)
 #define	early_per_cpu_map(_name, _idx) (_name##_early_map[_idx])
 #define	early_per_cpu(_name, _cpu) 				\
-	(early_per_cpu_ptr(_name) ?				\
-		early_per_cpu_ptr(_name)[_cpu] :		\
-		per_cpu(_name, _cpu))
+	*(early_per_cpu_ptr(_name) ?				\
+		&early_per_cpu_ptr(_name)[_cpu] :		\
+		&per_cpu(_name, _cpu))
 
 #else	/* !CONFIG_SMP */
 #define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)		\
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index ff386ff..3ac51b5 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -96,10 +96,7 @@ static inline int cpu_to_node(int cpu)
 /* Same function but used if called before per_cpu areas are setup */
 static inline int early_cpu_to_node(int cpu)
 {
-	if (early_per_cpu_ptr(x86_cpu_to_node_map))
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-
-	return per_cpu(x86_cpu_to_node_map, cpu);
+	return early_per_cpu(x86_cpu_to_node_map);
 }
 
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index b5229af..c2f4cbd 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1865,17 +1865,8 @@ void __cpuinit generic_processor_info(int apicid, int version)
 #endif
 
 #if defined(CONFIG_X86_SMP) || defined(CONFIG_X86_64)
-	/* are we being called early in kernel startup? */
-	if (early_per_cpu_ptr(x86_cpu_to_apicid)) {
-		u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
-		u16 *bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
-
-		cpu_to_apicid[cpu] = apicid;
-		bios_cpu_apicid[cpu] = apicid;
-	} else {
-		per_cpu(x86_cpu_to_apicid, cpu) = apicid;
-		per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
-	}
+	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
+	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
 #endif
 
 	cpu_set(cpu, cpu_possible_map);
-- 
1.5.6

