Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZCXVcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZCXVcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZCXVbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:31:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:50338 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZCXVbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:31:48 -0400
Date: Tue, 24 Mar 2009 21:30:29 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49C94DAE.9070300@kernel.org>
References: <49C94DAE.9070300@kernel.org>
Subject: [tip:x86/apic] x86: use default_cpu_mask_to_apicid for 64bit
Message-ID: <tip-f56e5034121c4911a155ba907076ab920754626d@git.kernel.org>
Git-Commit-ID: f56e5034121c4911a155ba907076ab920754626d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 21:30:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f56e5034121c4911a155ba907076ab920754626d
Gitweb:     http://git.kernel.org/tip/f56e5034121c4911a155ba907076ab920754626d
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 24 Mar 2009 14:16:30 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 22:28:38 +0100

x86: use default_cpu_mask_to_apicid for 64bit

Impact: cleanup

Use online_mask directly on 64bit too.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49C94DAE.9070300@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h         |   20 ++++++++++----------
 arch/x86/kernel/apic/apic_flat_64.c |   18 ++----------------
 2 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 00f5962..130a9e2 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -489,10 +489,19 @@ static inline int default_apic_id_registered(void)
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
+static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
+
+extern int default_apicid_to_node(int logical_apicid);
+
+#endif
+
 static inline unsigned int
 default_cpu_mask_to_apicid(const struct cpumask *cpumask)
 {
-	return cpumask_bits(cpumask)[0];
+	return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
 }
 
 static inline unsigned int
@@ -506,15 +515,6 @@ default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return (unsigned int)(mask1 & mask2 & mask3);
 }
 
-static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-extern int default_apicid_to_node(int logical_apicid);
-
-#endif
-
 static inline unsigned long default_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
 	return physid_isset(apicid, bitmap);
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index f933822..0014714 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -159,20 +159,6 @@ static int flat_apic_id_registered(void)
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
-static unsigned int flat_cpu_mask_to_apicid(const struct cpumask *cpumask)
-{
-	return cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
-}
-
-static unsigned int flat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-						const struct cpumask *andmask)
-{
-	unsigned long mask1 = cpumask_bits(cpumask)[0] & APIC_ALL_CPUS;
-	unsigned long mask2 = cpumask_bits(andmask)[0] & APIC_ALL_CPUS;
-
-	return mask1 & mask2;
-}
-
 static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
@@ -213,8 +199,8 @@ struct apic apic_flat =  {
 	.set_apic_id			= set_apic_id,
 	.apic_id_mask			= 0xFFu << 24,
 
-	.cpu_mask_to_apicid		= flat_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= flat_cpu_mask_to_apicid_and,
+	.cpu_mask_to_apicid		= default_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= default_cpu_mask_to_apicid_and,
 
 	.send_IPI_mask			= flat_send_IPI_mask,
 	.send_IPI_mask_allbutself	= flat_send_IPI_mask_allbutself,
