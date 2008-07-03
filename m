Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbYGCHHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbYGCHHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYGCG5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:33577 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbYGCCr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:47:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,741,1204531200"; 
   d="scan'208";a="584550729"
Subject: Re: [RFC PATCH 2/4] ACPI: introduce the mechanism to save/restore
	ACPI NVS memory
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
In-Reply-To: <1215051874.5628.34.camel@rzhang-dt.sh.intel.com>
References: <1215051874.5628.34.camel@rzhang-dt.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Jul 2008 10:46:05 +0800
Message-Id: <1215053165.5628.40.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, send to the right linux-kernel mail list, :)

thanks,
rui

On Thu, 2008-07-03 at 10:24 +0800, Zhang Rui wrote:
> According to the ACPI spec, ACPI NVS memory region is required to be
> saved/restored by OS during hibernation.
> 
> Section 15.3.2 ACPI Spec 3.0b,
> "OSPM will call the _PTS control method some time before entering a sleeping state,
> to allow the platform’s AML code to update this memory image before entering the
> sleeping state. After the system awakes from an S4 state, OSPM will restore this memory
> area and call the _WAK control method to enable the BIOS to reclaim its memory image."
> 
> Add the mechanism to save/restore ACPI NVS memory during hibernation.
> 
> Note: now Linux save ACPI NVS memory in acpi_hibernation_pre_snapshot, and restore it in
> 	acpi_hibernation_leave. Both of these functions will be invoked only once during
> 	the hibernate and resume.
> Note: in Section 14.3 ACPI spec 3.0b, I only get
> 	"EfiACPIMemoryNVS: The OS and loader must preserve this memory range in
> 	the working and ACPI S1–S3 states."
> 	whether we should save/restore this piece of memory is not cleared.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/sleep/main.c |  103 +++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/acpi.h      |    3 +
>  2 files changed, 104 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/sleep/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/sleep/main.c	2008-06-30 16:28:56.000000000 +0800
> +++ linux-2.6/drivers/acpi/sleep/main.c	2008-07-01 09:30:36.000000000 +0800
> @@ -15,6 +15,7 @@
>  #include <linux/dmi.h>
>  #include <linux/device.h>
>  #include <linux/suspend.h>
> +#include <linux/highmem.h>
>  
>  #include <asm/io.h>
>  
> @@ -255,11 +256,91 @@
>  #endif /* CONFIG_SUSPEND */
>  
>  #ifdef CONFIG_HIBERNATION
> +
> +/* ACPI NVS memory need to be saved/stored during hibernation */
> +struct nvs_page {
> +	unsigned long pfn;
> +	void *data;
> +	struct list_head node;
> +};
> +static LIST_HEAD(nvs_pages_list);
> +
> +int acpi_mark_nvs_region(unsigned long start, unsigned long end)
> +{
> +	struct nvs_page *pos;
> +
> +	while (start <= end) {
> +		pos = kzalloc(sizeof(struct nvs_page), GFP_KERNEL);
> +		if (!pos)
> +			return -ENOMEM;
> +		pos->pfn = start;
> +		start++;
> +		list_add_tail(&pos->node, &nvs_pages_list);
> +	}
> +	return 0;
> +}
> +
> +static int acpi_free_nvs_pages(void)
> +{
> +	struct nvs_page *pos;
> +
> +	list_for_each_entry(pos, &nvs_pages_list, node) {
> +		if (!pos->data)
> +			break;
> +		free_page((long)pos->data);
> +		pos->data = NULL;
> +	}
> +	return 0;
> +}
> +
> +static int acpi_allocate_nvs_pages(void)
> +{
> +	struct nvs_page *pos;
> +
> +	list_for_each_entry(pos, &nvs_pages_list, node) {
> +		pos->data = (void *)__get_free_page(GFP_KERNEL);
> +		if (!pos->data) {
> +			acpi_free_nvs_pages();
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void acpi_save_nvs_memory(void)
> +{
> +	void *kaddr;
> +	struct nvs_page *pos;
> +
> +	pr_debug("ACPI: Saving ACPI NVS memory\n");
> +	list_for_each_entry(pos, &nvs_pages_list, node) {
> +		/* nvs page might not have a 'struct page' */
> +		kaddr = kmap_atomic_pfn(pos->pfn, KM_USER0);
> +		copy_page(pos->data, kaddr);
> +		kunmap_atomic(kaddr, KM_USER0);
> +	}
> +	return;
> +}
> +
> +static void acpi_restore_nvs_memory(void)
> +{
> +	void *kaddr;
> +	struct nvs_page *pos;
> +
> +	pr_debug("ACPI: Restoring ACPI NVS memory\n");
> +	list_for_each_entry(pos, &nvs_pages_list, node) {
> +		kaddr = kmap_atomic_pfn(pos->pfn, KM_USER0);
> +		copy_page(kaddr, pos->data);
> +		kunmap_atomic(kaddr, KM_USER0);
> +	}
> +}
> +
>  static int acpi_hibernation_begin(void)
>  {
>  	acpi_target_sleep_state = ACPI_STATE_S4;
>  
> -	return 0;
> +	/* allocate pages for ACPI NVS memory before swsusp_shrink_memory */
> +	return acpi_allocate_nvs_pages();
>  }
>  
>  static int acpi_hibernation_prepare(void)
> @@ -274,6 +355,20 @@
>  	return ACPI_SUCCESS(acpi_hw_disable_all_gpes()) ? 0 : -EFAULT;
>  }
>  
> +static int acpi_hibernation_pre_snapshot(void)
> +{
> +	int error = acpi_sleep_prepare(ACPI_STATE_S4);
> +
> +	if (error) {
> +		acpi_target_sleep_state = ACPI_STATE_S0;
> +		return error;
> +	}
> +
> +	acpi_save_nvs_memory();
> +
> +	return ACPI_SUCCESS(acpi_hw_disable_all_gpes()) ? 0 : -EFAULT;
> +}
> +
>  static int acpi_hibernation_enter(void)
>  {
>  	acpi_status status = AE_OK;
> @@ -301,6 +396,7 @@
>  	acpi_enable();
>  	/* Reprogram control registers and execute _BFS */
>  	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
> +	acpi_restore_nvs_memory();
>  }
>  
>  static void acpi_hibernation_finish(void)
> @@ -321,6 +417,9 @@
>  	 * during a failing transition to the sleep state.
>  	 */
>  	acpi_target_sleep_state = ACPI_STATE_S0;
> +
> +	/* free pages allocated for ACPI NVS memory */
> +	acpi_free_nvs_pages();
>  }
>  
>  static int acpi_hibernation_pre_restore(void)
> @@ -340,7 +439,7 @@
>  static struct platform_hibernation_ops acpi_hibernation_ops = {
>  	.begin = acpi_hibernation_begin,
>  	.end = acpi_hibernation_end,
> -	.pre_snapshot = acpi_hibernation_prepare,
> +	.pre_snapshot = acpi_hibernation_pre_snapshot,
>  	.finish = acpi_hibernation_finish,
>  	.prepare = acpi_hibernation_prepare,
>  	.enter = acpi_hibernation_enter,
> Index: linux-2.6/include/linux/acpi.h
> ===================================================================
> --- linux-2.6.orig/include/linux/acpi.h	2008-06-30 16:28:56.000000000 +0800
> +++ linux-2.6/include/linux/acpi.h	2008-06-30 16:29:26.000000000 +0800
> @@ -106,6 +106,9 @@
>  void acpi_numa_arch_fixup(void);
>  #endif
>  
> +#ifdef CONFIG_HIBERNATION
> +int acpi_mark_nvs_region(unsigned long, unsigned long);
> +#endif
>  #ifdef CONFIG_ACPI_HOTPLUG_CPU
>  /* Arch dependent functions for cpu hotplug support */
>  int acpi_map_lsapic(acpi_handle handle, int *pcpu);
> 

