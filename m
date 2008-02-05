Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYBEHas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYBEHas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 02:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYBEHah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 02:30:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:45570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYBEHaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 02:30:35 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: linux-acpi@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/ counters
Date: Tue, 5 Feb 2008 02:30:10 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802050230.10873.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Here is the ACPI GPE statistics patch, forward ported to grok 2.6.25's kobject changes.
(Greg, let me know if I was able to unleash the inner beauty of the kobj interface)
(yes, I know you don't like sysfs files with more than 1 value,
 but I violate that rule for only one of the 33 files:-)

thanks,
-Len
--

# ls /sys/firmware/acpi/interrupts/
gpe00  gpe02  gpe04  gpe06  gpe08  gpe0A  gpe0C  gpe0E  gpe10  gpe12  gpe14  gpe16  gpe18  gpe1A  gpe1C  gpe1E  summary
gpe01  gpe03  gpe05  gpe07  gpe09  gpe0B  gpe0D  gpe0F  gpe11  gpe13  gpe15  gpe17  gpe19  gpe1B  gpe1D  gpe1F

# cat /sys/firmware/acpi/interrupts/summary
pm_timer     0
glbl_lock    0
power_btn    0
sleep_btn    0
rtc          0
gpe00    0
gpe01    0
gpe02    0
gpe03    0
gpe04    0
gpe05    0
gpe06    0
gpe07    0
gpe08    0
gpe09    2
gpe0A    0
gpe0B    0
gpe0C    0
gpe0D    0
gpe0E    0
gpe0F    0
gpe10    0
gpe11   60
gpe12    0
gpe13    0
gpe14    0
gpe15    0
gpe16    0
gpe17    0
gpe18    0
gpe19    1
gpe1A    0
gpe1B    0
gpe1C    0
gpe1D    0
gpe1E    0
gpe1F    0
gpe_hi    0
gpe_total   63
acpi_irq    63

Inspired-by-original-patch-by: Luming Yu <luming.yu@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/events/evevent.c     |    2 +-
 drivers/acpi/events/evgpe.c       |    2 +
 drivers/acpi/osl.c                |   12 ++-
 drivers/acpi/system.c             |  218 +++++++++++++++++++++++++++++++++++++
 drivers/acpi/utilities/utglobal.c |    2 +
 include/acpi/acglobal.h           |    1 +
 include/acpi/aclocal.h            |    1 +
 include/acpi/acpiosxf.h           |    2 +
 include/linux/acpi.h              |    2 +
 9 files changed, 240 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/events/evevent.c b/drivers/acpi/events/evevent.c
index e412878..18514bf 100644
--- a/drivers/acpi/events/evevent.c
+++ b/drivers/acpi/events/evevent.c
@@ -259,7 +259,7 @@ u32 acpi_ev_fixed_event_detect(void)
 			enable_bit_mask)) {
 
 			/* Found an active (signalled) event */
-
+			acpi_fixed_event_count[i]++;
 			int_status |= acpi_ev_fixed_event_dispatch((u32) i);
 		}
 	}
diff --git a/drivers/acpi/events/evgpe.c b/drivers/acpi/events/evgpe.c
index e22f4a9..515128f 100644
--- a/drivers/acpi/events/evgpe.c
+++ b/drivers/acpi/events/evgpe.c
@@ -620,6 +620,8 @@ acpi_ev_gpe_dispatch(struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
 
 	acpi_gpe_count++;
 
+	acpi_os_gpe_count(gpe_number);
+
 	/*
 	 * If edge-triggered, clear the GPE status bit now.  Note that
 	 * level-triggered events are cleared after the GPE is serviced.
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
index 5ffe0ea..538d154 100644
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
@@ -166,6 +168,222 @@ static int acpi_system_sysfs_init(void)
 	return 0;
 }
 
+/*
+ * ACPI IRQ counters
+ *
+ * /sys/firmware/acpi/interrupts/
+ *   summary -- IRQ, Fixed Event, and GPE counters
+ *   gpeXX -- broken-out counters for up to 32 GPEs
+ */
+
+static u32 *acpi_gpe_counters;
+static u32 gpe_counter_high;			/* bucket for GPE's >= 32 */
+static u32 number_of_gpes;
+static struct attribute **all_attrs;
+
+static struct attribute_group interrupt_stats_attr_group = {
+	.name = "interrupts",
+};
+static struct kobj_attribute *gpe_attrs;
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
+
+	u32 *tmp = acpi_gpe_counters;
+
+	acpi_gpe_counters = NULL;
+	kfree(tmp);
+
+	if (gpe_attrs) {
+		int i;
+
+		for (i = 0; i < number_of_gpes; i++)
+			kfree(gpe_attrs[i].attr.name);
+
+		kfree(gpe_attrs);
+	}
+	kfree(all_attrs);
+
+	return;
+}
+
+static ssize_t interrupt_summary_show(struct kobject *kobj,
+	struct kobj_attribute *attribute, char *buf)
+{
+	int i;
+	ssize_t count = 0;
+
+	/*
+	 * Fixed event counters
+	 */
+	count += sprintf(buf + count, "pm_timer  %4d\n",
+		acpi_fixed_event_count[ACPI_EVENT_PMTIMER]);
+
+	count += sprintf(buf + count, "glbl_lock %4d\n",
+		acpi_fixed_event_count[ACPI_EVENT_GLOBAL]);
+
+	count += sprintf(buf + count, "power_btn %4d\n",
+		acpi_fixed_event_count[ACPI_EVENT_POWER_BUTTON]);
+
+	count += sprintf(buf + count, "sleep_btn %4d\n",
+		acpi_fixed_event_count[ACPI_EVENT_SLEEP_BUTTON]);
+
+	count += sprintf(buf + count, "rtc       %4d\n",
+		acpi_fixed_event_count[ACPI_EVENT_RTC]);
+
+	/*
+	 * General Purpose Events
+	 */
+	for (i = 0; i < number_of_gpes; i++) {
+		count += sprintf(buf + count, "gpe%02X %4d\n",
+			i, acpi_gpe_counters[i]);
+	}
+
+	count += sprintf(buf + count, "gpe_hi %4d\n",
+		gpe_counter_high);
+
+	count += sprintf(buf + count, "gpe_total %4d\n",
+		acpi_gpe_count);
+
+	count += sprintf(buf + count, "acpi_irq  %4d\n",
+		acpi_irq_handled);
+
+	return count;
+}
+
+/*
+ * write anything to summary file: resets all counters
+ */
+static ssize_t interrupt_summary_reset(struct kobject *kobj,
+	struct kobj_attribute *attribute, const char *buf, size_t count)
+{
+	int i;
+
+	for (i = 0; i < ACPI_NUM_FIXED_EVENTS; ++i)
+		acpi_fixed_event_count[i] = 0;
+
+	for (i = 0; i < number_of_gpes; ++i)
+		acpi_gpe_counters[i] = 0;
+
+	acpi_gpe_count = 0;
+	gpe_counter_high = 0;
+	acpi_irq_handled = 0;
+
+	return count;
+}
+void acpi_os_gpe_count(u32 gpe_number)
+{
+
+	if (!acpi_gpe_counters)
+		return;
+
+	if (gpe_number < number_of_gpes)
+		acpi_gpe_counters[gpe_number]++;
+	else
+		gpe_counter_high++;
+
+	return;
+}
+
+static struct kobj_attribute summary_attribute =
+	__ATTR(summary, 0644, interrupt_summary_show, interrupt_summary_reset);
+
+
+static ssize_t gpe_count_show(struct kobject *kobj,
+	struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", acpi_gpe_counters[attr - gpe_attrs]);
+}
+
+static ssize_t gpe_count_reset(struct kobject *kobj,
+	struct kobj_attribute *attr, const char *buf, size_t size)
+{
+	acpi_gpe_counters[attr - gpe_attrs] = strtoul(buf, NULL, 0);
+
+	return size;
+}
+
+void acpi_irq_stats_init(void)
+{
+	int i;
+
+	number_of_gpes = count_num_gpes();
+
+	all_attrs = kzalloc(sizeof(struct attribute *) * (number_of_gpes + 2),
+			GFP_KERNEL);
+	if (all_attrs == NULL)
+		return;
+
+	acpi_gpe_counters = kzalloc(sizeof(u32) * (number_of_gpes), GFP_KERNEL);
+	if (acpi_gpe_counters == NULL)
+		goto fail;
+
+	gpe_attrs = kzalloc(sizeof(struct kobj_attribute) * (number_of_gpes),
+			GFP_KERNEL);
+	if (gpe_attrs == NULL)
+		goto fail;
+
+	for (i = 0; i < number_of_gpes; ++i) {
+		char buffer[10];
+		char *name;
+
+		sprintf(buffer, "gpe%02X", i);
+		name = kzalloc(strlen(buffer) + 1, GFP_KERNEL);
+		if (name == NULL)
+			goto fail;
+		strncpy(name, buffer, strlen(buffer) + 1);
+
+		gpe_attrs[i].attr.name = name;
+		gpe_attrs[i].attr.mode = 0644;
+		gpe_attrs[i].show = gpe_count_show;
+		gpe_attrs[i].store = gpe_count_reset;
+
+		all_attrs[i] = &gpe_attrs[i].attr;
+	}
+	all_attrs[number_of_gpes] = &summary_attribute.attr;
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
index 93ea829..9cc1c3a 100644
--- a/drivers/acpi/utilities/utglobal.c
+++ b/drivers/acpi/utilities/utglobal.c
@@ -672,6 +672,8 @@ void acpi_ut_init_globals(void)
 	/* GPE support */
 
 	acpi_gpe_count = 0;
+	for (i = 0; i < ACPI_NUM_FIXED_EVENTS; i++)
+		acpi_fixed_event_count[i] = 0;
 	acpi_gbl_gpe_xrupt_list_head = NULL;
 	acpi_gbl_gpe_fadt_blocks[0] = NULL;
 	acpi_gbl_gpe_fadt_blocks[1] = NULL;
diff --git a/include/acpi/acglobal.h b/include/acpi/acglobal.h
index 347a911..7b3a2ba 100644
--- a/include/acpi/acglobal.h
+++ b/include/acpi/acglobal.h
@@ -120,6 +120,7 @@ extern u32 acpi_gbl_nesting_level;
 /* Event counters */
 
 ACPI_EXTERN u32 acpi_gpe_count;
+ACPI_EXTERN u32 acpi_fixed_event_count[ACPI_NUM_FIXED_EVENTS];
 
 /* Support for dynamic control method tracing mechanism */
 
diff --git a/include/acpi/aclocal.h b/include/acpi/aclocal.h
index 202cd42..cabdf12 100644
--- a/include/acpi/aclocal.h
+++ b/include/acpi/aclocal.h
@@ -368,6 +368,7 @@ struct acpi_gpe_event_info {
 	struct acpi_gpe_register_info *register_info;	/* Backpointer to register info */
 	u8 flags;		/* Misc info about this GPE */
 	u8 gpe_number;		/* This GPE */
+	u32 count;
 };
 
 /* Information about a GPE register pair, one per each status/enable pair in an array */
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index ca882b8..4a64da5 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -181,6 +181,8 @@ acpi_os_install_interrupt_handler(u32 gsi,
 acpi_status
 acpi_os_remove_interrupt_handler(u32 gsi, acpi_osd_handler service_routine);
 
+void acpi_os_gpe_count(u32 gpe_number);
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
1.5.4.18.gd0b8

