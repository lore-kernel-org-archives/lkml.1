Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYLTBCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYLTBCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYLTBA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:00:59 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40118 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753316AbYLTBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:00:55 -0500
Message-Id: <20081220010044.713265000@polaris-admin.engr.sgi.com>
References: <20081220010043.879277000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 17:00:49 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 6/8] x86: use-cpumask_var_t-in-acpi_boot_c
Content-Disposition: inline; filename=x86:use-cpumask_var_t-in-acpi_boot.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce stack size, use new API.

Replace cpumask_t with cpumask_var_t.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/acpi/boot.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6-for-ingo/arch/x86/kernel/acpi/boot.c
@@ -538,9 +538,10 @@ static int __cpuinit _acpi_map_lsapic(ac
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	struct acpi_madt_local_apic *lapic;
-	cpumask_t tmp_map, new_map;
+	cpumask_var_t tmp_map, new_map;
 	u8 physid;
 	int cpu;
+	int retval = -ENOMEM;
 
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_MAT", NULL, &buffer)))
 		return -EINVAL;
@@ -569,23 +570,39 @@ static int __cpuinit _acpi_map_lsapic(ac
 	buffer.length = ACPI_ALLOCATE_BUFFER;
 	buffer.pointer = NULL;
 
-	tmp_map = cpu_present_map;
+	if (!alloc_cpumask_var(&tmp_map, GFP_KERNEL))
+		goto free_buffer_pointer;
+
+	if (!alloc_cpumask_var(&new_map, GFP_KERNEL))
+		goto free_tmp_map;
+
+	cpumask_copy(tmp_map, cpu_present_mask);
 	acpi_register_lapic(physid, lapic->lapic_flags & ACPI_MADT_ENABLED);
 
 	/*
 	 * If mp_register_lapic successfully generates a new logical cpu
 	 * number, then the following will get us exactly what was mapped
 	 */
-	cpus_andnot(new_map, cpu_present_map, tmp_map);
-	if (cpus_empty(new_map)) {
+	cpumask_andnot(new_map, cpu_present_mask, tmp_map);
+	if (cpumask_empty(new_map)) {
 		printk ("Unable to map lapic to logical cpu number\n");
-		return -EINVAL;
+		retval = -EINVAL;
+		goto free_new_map;
 	}
 
-	cpu = first_cpu(new_map);
+	cpu = cpumask_first(new_map);
 
 	*pcpu = cpu;
-	return 0;
+	retval = 0;
+
+free_new_map:
+	free_cpumask_var(new_map);
+free_tmp_map:
+	free_cpumask_var(tmp_map);
+free_buffer_pointer:
+	kfree(buffer.pointer);
+
+	return retval;
 }
 
 /* wrapper to silence section mismatch warning */

-- 
