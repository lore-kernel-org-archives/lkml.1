Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0BVTLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:11:46 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46491 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab0BVTLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:11:41 -0500
Subject: [PATCH v2 07/12] ACPI: processor: driver doesn't need to evaluate _PDC
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Date: Mon, 22 Feb 2010 12:11:39 -0700
Message-ID: <20100222191139.19752.57656.stgit@bob.kio>
In-Reply-To: <20100222190145.19752.20978.stgit@bob.kio>
References: <20100222190145.19752.20978.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the early _PDC evaluation path knows how to correctly
evaluate _PDC on only physically present processors, there's no
need for the processor driver to evaluate it later when it loads.

To cover the hotplug case, push _PDC evaluation down into the
hotplug paths.

Cc: x86@kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 arch/ia64/kernel/acpi.c         |    3 +++
 arch/x86/kernel/acpi/boot.c     |    3 +++
 drivers/acpi/processor_core.c   |    7 -------
 drivers/acpi/processor_driver.c |    3 ---
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 40574ae..394742a 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -44,6 +44,7 @@
 #include <linux/efi.h>
 #include <linux/mmzone.h>
 #include <linux/nodemask.h>
+#include <acpi/processor.h>
 #include <asm/io.h>
 #include <asm/iosapic.h>
 #include <asm/machvec.h>
@@ -936,6 +937,8 @@ int acpi_map_lsapic(acpi_handle handle, int *pcpu)
 	cpu_set(cpu, cpu_present_map);
 	ia64_cpu_to_sapicid[cpu] = physid;
 
+	acpi_processor_set_pdc(handle);
+
 	*pcpu = cpu;
 	return (0);
 }
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 97229f3..124de35 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -480,6 +480,7 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
  *  ACPI based hotplug support for CPU
  */
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
+#include <acpi/processor.h>
 
 static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 {
@@ -538,6 +539,8 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 		goto free_new_map;
 	}
 
+	acpi_processor_set_pdc(handle);
+
 	cpu = cpumask_first(new_map);
 
 	*pcpu = cpu;
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index ef34faa..626c754 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -317,8 +317,6 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 	return status;
 }
 
-static int early_pdc_done;
-
 void acpi_processor_set_pdc(acpi_handle handle)
 {
 	struct acpi_object_list *obj_list;
@@ -326,9 +324,6 @@ void acpi_processor_set_pdc(acpi_handle handle)
 	if (arch_has_acpi_pdc() == false)
 		return;
 
-	if (early_pdc_done)
-		return;
-
 	obj_list = acpi_processor_alloc_pdc();
 	if (!obj_list)
 		return;
@@ -369,6 +364,4 @@ void __init acpi_early_processor_set_pdc(void)
 	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX,
 			    early_init_pdc, NULL, NULL, NULL);
-
-	early_pdc_done = 1;
 }
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 777d046..7e8e1ba 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -606,9 +606,6 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 		goto err_remove_fs;
 	}
 
-	/* _PDC call should be done before doing anything else (if reqd.). */
-	acpi_processor_set_pdc(pr->handle);
-
 #ifdef CONFIG_CPU_FREQ
 	acpi_processor_ppc_has_changed(pr, 0);
 #endif

