Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZCXVTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZCXVTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZCXVRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:17:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:60273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbZCXVRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:17:44 -0400
Message-ID: <49C94DAE.9070300@kernel.org>
Date: Tue, 24 Mar 2009 14:16:30 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] x86: use default_cpu_mask_to_apicid for 64bit
References: <200903241619.03517.rusty@rustcorp.com.au> <m1k56frt6e.fsf@fess.ebiederm.org> <49C94134.4000408@kernel.org> <49C94D82.1040708@kernel.org>
In-Reply-To: <49C94D82.1040708@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

use online_mask directly with 64bit too.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apic.h         |   20 ++++++++++----------
 arch/x86/kernel/apic/apic_flat_64.c |   18 ++----------------
 2 files changed, 12 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/x86/include/asm/apic.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/apic.h
+++ linux-2.6/arch/x86/include/asm/apic.h
@@ -489,10 +489,19 @@ static inline int default_apic_id_regist
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
@@ -506,15 +515,6 @@ default_cpu_mask_to_apicid_and(const str
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
Index: linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
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
