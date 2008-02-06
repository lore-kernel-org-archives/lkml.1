Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYBFGk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYBFGk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 01:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYBFGkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 01:40:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:42662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbYBFGko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 01:40:44 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] ACPI: create /sys/firmware/acpi/interrupts/ (v2)
Date: Wed, 6 Feb 2008 01:40:26 -0500
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200802050230.10873.lenb@kernel.org> <20080206024349.GA10883@suse.de> <200802060133.25863.lenb@kernel.org>
In-Reply-To: <200802060133.25863.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060140.27116.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

See Documentation/ABI/testing/sysfs-firmware-acpi

Inspired-by: Luming Yu <luming.yu@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/ABI/testing/sysfs-firmware-acpi |   99 ++++++++++++
 drivers/acpi/events/evevent.c                 |    2 +-
 drivers/acpi/events/evgpe.c                   |    2 +-
 drivers/acpi/osl.c                            |   12 ++-
 drivers/acpi/system.c                         |  208 +++++++++++++++++++++++++
 drivers/acpi/utilities/utglobal.c             |    2 -
 include/acpi/acglobal.h                       |    4 -
 include/acpi/acpiosxf.h                       |    3 +
 include/linux/acpi.h                          |    2 +
 9 files changed, 325 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-acpi

diff --git a/Documentation/ABI/testing/sysfs-firmware-acpi b/Documentation/ABI/testing/sysfs-firmware-acpi
new file mode 100644
index 0000000..9470ed9
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-acpi
@@ -0,0 +1,99 @@
+What:		/sys/firmware/acpi/interrupts/
+Date:		February 2008
+Contact:	Len Brown <lenb@kernel.org>
+Description:
+		All ACPI interrupts are handled via a single IRQ,
+		the System Control Interrupt (SCI), which appears
+		as "acpi" in /proc/interrupts.
+
+		However, one of the main functions of ACPI is to make
+		the platform understand random hardware without
+		special driver support.  So while the SCI handles a few
+		well known (fixed feature) interrupts sources, such
+		as the power button, it can also handle a variable
+		number of a "General Purpose Events" (GPE).
+
+		A GPE vectors to a specified handler in AML, which
+		can do a anything the BIOS writer wants from
+		OS context.  GPE 0x12, for example, would vector
+		to a level or edge handler called _L12 or _E12.
+		The handler may do its business and return.
+		Or the handler may send send a Notify event
+		to a Linux device driver registered on an ACPI device,
+		such as a battery, or a processor.
+
+		To figure out where all the SCI's are coming from,
+		/sys/firmware/acpi/interrupts contains a file listing
+		every possible source, and the count of how many
+		times it has triggered.
+
+		$ cd /sys/firmware/acpi/interrupts
+		$ grep . *
+		error:0
+		ff_gbl_lock:0
+		ff_pmtimer:0
+		ff_pwr_btn:0
+		ff_rt_clk:0
+		ff_slp_btn:0
+		gpe00:0
+		gpe01:0
+		gpe02:0
+		gpe03:0
+		gpe04:0
+		gpe05:0
+		gpe06:0
+		gpe07:0
+		gpe08:0
+		gpe09:174
+		gpe0A:0
+		gpe0B:0
+		gpe0C:0
+		gpe0D:0
+		gpe0E:0
+		gpe0F:0
+		gpe10:0
+		gpe11:60
+		gpe12:0
+		gpe13:0
+		gpe14:0
+		gpe15:0
+		gpe16:0
+		gpe17:0
+		gpe18:0
+		gpe19:7
+		gpe1A:0
+		gpe1B:0
+		gpe1C:0
+		gpe1D:0
+		gpe1E:0
+		gpe1F:0
+		gpe_all:241
+		sci:241
+
+		sci - The total number of times the ACPI SCI
+		has claimed an interrupt.
+
+		gpe_all - count of SCI caused by GPEs.
+
+		gpeXX - count for individual GPE source
+
+		ff_gbl_lock - Global Lock
+
+		ff_pmtimer - PM Timer
+
+		ff_pwr_btn - Power Button
+
+		ff_rt_clk - Real Time Clock
+
+		ff_slp_btn - Sleep Button
+
+		error - an interrupt that can't be accounted for above.
+
+		Root has permission to clear any of these counters.  Eg.
+		# echo 0 > gpe11
+
+		All counters can be cleared by clearing the total "sci":
+		# echo 0 > sci
+
+		None of these counters has an effect on the function
+		of the system, they are simply statistics.
diff --git a/drivers/acpi/events/evevent.c b/drivers/acpi/events/evevent.c
index e412878..3048801 100644
--- a/drivers/acpi/events/evevent.c
+++ b/drivers/acpi/events/evevent.c
@@ -259,7 +259,7 @@ u32 acpi_ev_fixed_event_detect(void)
 			enable_bit_mask)) {
 
 			/* Found an active (signalled) event */
-
+			acpi_os_fixed_event_count(i);
 			int_status |= acpi_ev_fixed_event_dispatch((u32) i);
 		}
 	}
diff --git a/drivers/acpi/events/evgpe.c b/drivers/acpi/events/evgpe.c
index e22f4a9..4bd9e22 100644
--- a/drivers/acpi/events/evgpe.c
+++ b/drivers/acpi/events/evgpe.c
@@ -618,7 +618,7 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
 
 	ACPI_FUNCTION_TRACE(ev_gpe_dispatch);
 
-	acpi_gpe_count++;
+	acpi_os_gpe_count(gpe_number);
 
 	/*
 	 * If edge-triggered, clear the GPE status bit now.  Note that
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e53fb51..1087efe 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -332,7 +332,15 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 
 static irqreturn_t acpi_irq(int irq, void *dev_id)
 {
-	return (*acpi_irq_handler) (acpi_irq_context) ? IRQ_HANDLED : IRQ_NONE;
+	u32 handled;
+
+	handled = (*acpi_irq_handler) (acpi_irq_context);
+
+	if (handled) {
+		acpi_irq_handled++;
+		return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
 }
 
 acpi_status
@@ -341,6 +349,8 @@ acpi_os_install_interrupt_handler(u32 gsi, acpi_osd_handler handler,
 {
 	unsigned int irq;
 
+	acpi_irq_stats_init();
+
 	/*
 	 * Ignore the GSI from the core, and use the value in our copy of the
 	 * FADT. It may not be the same if an interrupt source override exists
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index 5ffe0ea..ce88171 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -40,6 +40,8 @@ ACPI_MODULE_NAME("system");
 #define ACPI_SYSTEM_CLASS		"system"
 #define ACPI_SYSTEM_DEVICE_NAME		"System"
 
+u32 acpi_irq_handled;
+
 /*
  * Make ACPICA version work as module param
  */
@@ -166,6 +168,212 @@ static int acpi_system_sysfs_init(void)
 	return 0;
 }
 
+/*
+ * Detailed ACPI IRQ counters in /sys/firmware/acpi/interrupts/
+ * See Documentation/ABI/testing/sysfs-firmware-acpi
+ */
+
+#define COUNT_GPE 0
+#define COUNT_SCI 1	/* acpi_irq_handled */
+#define COUNT_ERROR 2	/* other */
+#define NUM_COUNTERS_EXTRA 3
+
+static u32 *all_counters;
+static u32 num_gpes;
+static u32 num_counters;
+static struct attribute **all_attrs;
+static u32 acpi_gpe_count;
+
+static struct attribute_group interrupt_stats_attr_group = {
+	.name = "interrupts",
+};
+static struct kobj_attribute *counter_attrs;
+
+static int count_num_gpes(void)
+{
+	int count = 0;
+	struct acpi_gpe_xrupt_info *gpe_xrupt_info;
+	struct acpi_gpe_block_info *gpe_block;
+	acpi_cpu_flags flags;
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
+	gpe_xrupt_info = acpi_gbl_gpe_xrupt_list_head;
+	while (gpe_xrupt_info) {
+		gpe_block = gpe_xrupt_info->gpe_block_list_head;
+		while (gpe_block) {
+			count += gpe_block->register_count *
+			    ACPI_GPE_REGISTER_WIDTH;
+			gpe_block = gpe_block->next;
+		}
+		gpe_xrupt_info = gpe_xrupt_info->next;
+	}
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+
+	return count;
+}
+
+static void delete_gpe_attr_array(void)
+{
+	u32 *tmp = all_counters;
+
+	all_counters = NULL;
+	kfree(tmp);
+
+	if (counter_attrs) {
+		int i;
+
+		for (i = 0; i < num_gpes; i++)
+			kfree(counter_attrs[i].attr.name);
+
+		kfree(counter_attrs);
+	}
+	kfree(all_attrs);
+
+	return;
+}
+
+void acpi_os_gpe_count(u32 gpe_number)
+{
+	acpi_gpe_count++;
+
+	if (!all_counters)
+		return;
+
+	if (gpe_number < num_gpes)
+		all_counters[gpe_number]++;
+	else
+		all_counters[num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_ERROR]++;
+
+	return;
+}
+
+void acpi_os_fixed_event_count(u32 event_number)
+{
+	if (!all_counters)
+		return;
+
+	if (event_number < ACPI_NUM_FIXED_EVENTS)
+		all_counters[num_gpes + event_number]++;
+	else
+		all_counters[num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_ERROR]++;
+
+	return;
+}
+
+static ssize_t counter_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	all_counters[num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_SCI] =
+		acpi_irq_handled;
+	all_counters[num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_GPE] =
+		acpi_gpe_count;
+
+	return sprintf(buf, "%d\n", all_counters[attr - counter_attrs]);
+}
+
+/*
+ * counter_set() sets the specified counter.
+ * setting the total "sci" file to any value clears all counters.
+ */
+static ssize_t counter_set(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t size)
+{
+	int index = attr - counter_attrs;
+
+	if (index == num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_SCI) {
+		int i;
+		for (i = 0; i < num_counters; ++i)
+			all_counters[i] = 0;
+		acpi_gpe_count = 0;
+		acpi_irq_handled = 0;
+
+	} else
+		all_counters[index] = strtoul(buf, NULL, 0);
+
+	return size;
+}
+
+void acpi_irq_stats_init(void)
+{
+	int i;
+
+	if (all_counters)
+		return;
+
+	num_gpes = count_num_gpes();
+	num_counters = num_gpes + ACPI_NUM_FIXED_EVENTS + NUM_COUNTERS_EXTRA;
+
+	all_attrs = kzalloc(sizeof(struct attribute *) * (num_counters + 1),
+			GFP_KERNEL);
+	if (all_attrs == NULL)
+		return;
+
+	all_counters = kzalloc(sizeof(u32) * (num_counters), GFP_KERNEL);
+	if (all_counters == NULL)
+		goto fail;
+
+	counter_attrs = kzalloc(sizeof(struct kobj_attribute) * (num_counters),
+			GFP_KERNEL);
+	if (counter_attrs == NULL)
+		goto fail;
+
+	for (i = 0; i < num_counters; ++i) {
+		char buffer[10];
+		char *name;
+
+		if (i < num_gpes)
+			sprintf(buffer, "gpe%02X", i);
+		else if (i == num_gpes + ACPI_EVENT_PMTIMER)
+			sprintf(buffer, "ff_pmtimer");
+		else if (i == num_gpes + ACPI_EVENT_GLOBAL)
+			sprintf(buffer, "ff_gbl_lock");
+		else if (i == num_gpes + ACPI_EVENT_POWER_BUTTON)
+			sprintf(buffer, "ff_pwr_btn");
+		else if (i == num_gpes + ACPI_EVENT_SLEEP_BUTTON)
+			sprintf(buffer, "ff_slp_btn");
+		else if (i == num_gpes + ACPI_EVENT_RTC)
+			sprintf(buffer, "ff_rt_clk");
+		else if (i == num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_GPE)
+			sprintf(buffer, "gpe_all");
+		else if (i == num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_SCI)
+			sprintf(buffer, "sci");
+		else if (i == num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_ERROR)
+			sprintf(buffer, "error");
+		else
+			sprintf(buffer, "bug%02X", i);
+
+		name = kzalloc(strlen(buffer) + 1, GFP_KERNEL);
+		if (name == NULL)
+			goto fail;
+		strncpy(name, buffer, strlen(buffer) + 1);
+
+		counter_attrs[i].attr.name = name;
+		counter_attrs[i].attr.mode = 0644;
+		counter_attrs[i].show = counter_show;
+		counter_attrs[i].store = counter_set;
+
+		all_attrs[i] = &counter_attrs[i].attr;
+	}
+
+	interrupt_stats_attr_group.attrs = all_attrs;
+	sysfs_create_group(acpi_kobj, &interrupt_stats_attr_group);
+	return;
+
+fail:
+	delete_gpe_attr_array();
+	return;
+}
+
+static void __exit interrupt_stats_exit(void)
+{
+	sysfs_remove_group(acpi_kobj, &interrupt_stats_attr_group);
+
+	delete_gpe_attr_array();
+
+	return;
+}
+
 /* --------------------------------------------------------------------------
                               FS Interface (/proc)
    -------------------------------------------------------------------------- */
diff --git a/drivers/acpi/utilities/utglobal.c b/drivers/acpi/utilities/utglobal.c
index 93ea829..630c9a2 100644
--- a/drivers/acpi/utilities/utglobal.c
+++ b/drivers/acpi/utilities/utglobal.c
@@ -671,7 +671,6 @@ void acpi_ut_init_globals(void)
 
 	/* GPE support */
 
-	acpi_gpe_count = 0;
 	acpi_gbl_gpe_xrupt_list_head = NULL;
 	acpi_gbl_gpe_fadt_blocks[0] = NULL;
 	acpi_gbl_gpe_fadt_blocks[1] = NULL;
@@ -735,4 +734,3 @@ void acpi_ut_init_globals(void)
 
 ACPI_EXPORT_SYMBOL(acpi_dbg_level)
     ACPI_EXPORT_SYMBOL(acpi_dbg_layer)
-    ACPI_EXPORT_SYMBOL(acpi_gpe_count)
diff --git a/include/acpi/acglobal.h b/include/acpi/acglobal.h
index 347a911..47a1fd8 100644
--- a/include/acpi/acglobal.h
+++ b/include/acpi/acglobal.h
@@ -117,10 +117,6 @@ extern u32 acpi_dbg_layer;
 
 extern u32 acpi_gbl_nesting_level;
 
-/* Event counters */
-
-ACPI_EXTERN u32 acpi_gpe_count;
-
 /* Support for dynamic control method tracing mechanism */
 
 ACPI_EXTERN u32 acpi_gbl_original_dbg_level;
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index ca882b8..1a16cfb 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -181,6 +181,9 @@ acpi_os_install_interrupt_handler(u32 gsi,
 acpi_status
 acpi_os_remove_interrupt_handler(u32 gsi, acpi_osd_handler service_routine);
 
+void acpi_os_gpe_count(u32 gpe_number);
+void acpi_os_fixed_event_count(u32 fixed_event_number);
+
 /*
  * Threads and Scheduling
  */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 63f2e6e..cb911f3 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -115,7 +115,9 @@ int acpi_unmap_lsapic(int cpu);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
+void acpi_irq_stats_init(void);
 
+extern u32 acpi_irq_handled;
 extern int acpi_mp_config;
 
 extern struct acpi_mcfg_allocation *pci_mmcfg_config;
-- 
1.5.4.23.gef5b9

