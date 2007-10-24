Return-Path: <linux-kernel-owner+w=401wt.eu-S1760134AbXJXOeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134AbXJXOeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759692AbXJXOdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:33:03 -0400
Received: from ns1.suse.de ([195.135.220.2]:48485 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759388AbXJXOdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:33:00 -0400
Subject: [PATCH 2/5] Provide acpi_check_{mem_}region.
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-acpi <linux-acpi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 24 Oct 2007 16:32:59 +0200
Message-Id: <1193236379.4590.229.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide acpi_check_{mem_}region.

Drivers can additionally check against possible ACPI interference by also
invoking this shortly before they call request_region.
If -EBUSY is returned, the driver must not load.
Use acpi_enforce_resources=strict/lax/no options to:
  - strict: let conflicting drivers fail to load with an error message
  - lax:    let conflicting driver work normal with a warning message
  - no:     no functional change at all


Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/osl.c   |  175 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi.h |   13 +++
 2 files changed, 186 insertions(+), 2 deletions(-)

Index: lenb/drivers/acpi/osl.c
===================================================================
--- lenb.orig/drivers/acpi/osl.c
+++ lenb/drivers/acpi/osl.c
@@ -44,6 +44,8 @@
 #include <asm/uaccess.h>
 
 #include <linux/efi.h>
+#include <linux/ioport.h>
+#include <linux/list.h>
 
 #define _COMPONENT		ACPI_OS_SERVICES
 ACPI_MODULE_NAME("osl");
@@ -74,6 +76,18 @@ static void *acpi_irq_context;
 static struct workqueue_struct *kacpid_wq;
 static struct workqueue_struct *kacpi_notify_wq;
 
+struct acpi_res_list {
+	resource_size_t start;
+	resource_size_t end;
+	acpi_adr_space_type resource_type; /* IO port, System memory, ...*/
+	char name[5];   /* only can have a length of 4 chars, make use of this
+			   one instead of res->name, no need to kalloc then */
+	struct list_head resource_list;
+};
+
+static LIST_HEAD(resource_list_head);
+static DEFINE_SPINLOCK(acpi_res_lock);
+
 #define	OSI_STRING_LENGTH_MAX 64	/* arbitrary */
 static char osi_additional_string[OSI_STRING_LENGTH_MAX];
 
@@ -1042,6 +1056,127 @@ static int __init acpi_wake_gpes_always_
 
 __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
 
+/* Check of resource interference between native drivers and ACPI
+ * OperationRegions (SystemIO and System Memory only).
+ * IO ports and memory declared in ACPI might be used by the ACPI subsystem
+ * in arbitrary AML code and can interfere with legacy drivers.
+ * acpi_enforce_resources= can be set to:
+ *
+ *   - strict           (2)
+ *     -> further driver trying to access the resources will not load
+ *   - lax (default)    (1)
+ *     -> further driver trying to access the resources will load, but you
+ *     get a system message that something might go wrong...
+ *
+ *   - no               (0)
+ *     -> ACPI Operation Region resources will not be registered
+ *
+ */
+#define ENFORCE_RESOURCES_STRICT 2
+#define ENFORCE_RESOURCES_LAX    1
+#define ENFORCE_RESOURCES_NO     0
+
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+
+static int __init acpi_enforce_resources_setup(char *str)
+{
+	if (str == NULL || *str == '\0')
+		return 0;
+
+	if (!strcmp("strict", str))
+		acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
+	else if (!strcmp("lax", str))
+		acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+	else if (!strcmp("no", str))
+		acpi_enforce_resources = ENFORCE_RESOURCES_NO;
+
+	return 1;
+}
+
+__setup("acpi_enforce_resources=", acpi_enforce_resources_setup);
+
+/* Check for resource conflicts between ACPI OperationRegions and native
+ * drivers */
+static int acpi_check_resource_conflict(struct resource *res)
+{
+	struct acpi_res_list *res_list_elem;
+	int ioport;
+	int clash = 0;
+
+	if (acpi_enforce_resources == ENFORCE_RESOURCES_NO)
+		return 0;
+	if (!(res->flags & IORESOURCE_IO) && !(res->flags & IORESOURCE_MEM))
+		return 0;
+
+	ioport = res->flags & IORESOURCE_IO;
+
+	spin_lock(&acpi_res_lock);
+	list_for_each_entry(res_list_elem, &resource_list_head,
+			    resource_list) {
+		if (ioport && (res_list_elem->resource_type
+			       != ACPI_ADR_SPACE_SYSTEM_IO))
+			continue;
+		if (!ioport && (res_list_elem->resource_type
+				!= ACPI_ADR_SPACE_SYSTEM_MEMORY))
+			continue;
+
+		if (res->end < res_list_elem->start
+		    || res_list_elem->end < res->start)
+			continue;
+		clash = 1;
+		break;
+	}
+	spin_unlock(&acpi_res_lock);
+
+	if (clash) {
+		if (acpi_enforce_resources != ENFORCE_RESOURCES_NO) {
+			printk("%sACPI: %s resource %s [0x%llx-0x%llx]"
+			       " conflicts with ACPI region %s"
+			       " [0x%llx-0x%llx]\n",
+			       acpi_enforce_resources == ENFORCE_RESOURCES_LAX
+			       ? KERN_WARNING : KERN_ERR,
+			       ioport ? "I/O" : "Memory", res->name,
+			       (long long) res->start, (long long) res->end,
+			       res_list_elem->name,
+			       (long long) res_list_elem->start,
+			       (long long) res_list_elem->end);
+			printk(KERN_INFO "ACPI: Device needs an ACPI driver\n");
+		}
+		if (acpi_enforce_resources == ENFORCE_RESOURCES_STRICT)
+			return -EBUSY;
+	}
+	return 0;
+}
+
+int acpi_check_region(resource_size_t start, resource_size_t n,
+		      const char *name)
+{
+	struct resource res = {
+		.start = start,
+		.end   = start + n - 1,
+		.name  = name,
+		.flags = IORESOURCE_IO,
+	};
+
+	return acpi_check_resource_conflict(&res);
+}
+EXPORT_SYMBOL(acpi_check_region);
+
+int acpi_check_mem_region(resource_size_t start, resource_size_t n,
+		      const char *name)
+{
+	struct resource res = {
+		.start = start,
+		.end   = start + n - 1,
+		.name  = name,
+		.flags = IORESOURCE_MEM,
+	};
+
+	return acpi_check_resource_conflict(&res);
+
+}
+EXPORT_SYMBOL(acpi_check_mem_region);
+
 /*
  * Acquire a spinlock.
  *
@@ -1199,10 +1334,46 @@ acpi_status
 acpi_os_validate_address (
     u8                   space_id,
     acpi_physical_address   address,
-    acpi_size               length)
+    acpi_size               length,
+    char *name)
 {
+	struct acpi_res_list *res;
+	if (acpi_enforce_resources == ENFORCE_RESOURCES_NO)
+		return AE_OK;
 
-    return AE_OK;
+	switch (space_id) {
+	case ACPI_ADR_SPACE_SYSTEM_IO:
+	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
+		/* Only interference checks against SystemIO and SytemMemory
+		   are needed */
+		res = kzalloc(sizeof(struct acpi_res_list), GFP_KERNEL);
+		if (!res)
+			return AE_OK;
+		/* ACPI names are fixed to 4 bytes, still better use strlcpy */
+		strlcpy(res->name, name, 5);
+		res->start = address;
+		res->end = address + length - 1;
+		res->resource_type = space_id;
+		spin_lock(&acpi_res_lock);
+		list_add(&res->resource_list, &resource_list_head);
+		spin_unlock(&acpi_res_lock);
+		pr_debug("Added %s resource: start: 0x%llx, end: 0x%llx, "
+			 "name: %s\n", (space_id == ACPI_ADR_SPACE_SYSTEM_IO)
+			 ? "SystemIO" : "System Memory",
+			 res->start,
+			 (unsigned long)res->end,
+			 (unsigned long)res->name);
+		break;
+	case ACPI_ADR_SPACE_PCI_CONFIG:
+	case ACPI_ADR_SPACE_EC:
+	case ACPI_ADR_SPACE_SMBUS:
+	case ACPI_ADR_SPACE_CMOS:
+	case ACPI_ADR_SPACE_PCI_BAR_TARGET:
+	case ACPI_ADR_SPACE_DATA_TABLE:
+	case ACPI_ADR_SPACE_FIXED_HARDWARE:
+		break;
+	}
+	return AE_OK;
 }
 
 #ifdef CONFIG_DMI
Index: lenb/include/linux/acpi.h
===================================================================
--- lenb.orig/include/linux/acpi.h
+++ lenb/include/linux/acpi.h
@@ -123,10 +123,23 @@ extern int pci_mmcfg_config_num;
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
+int acpi_check_region(resource_size_t start, resource_size_t n,
+		      const char *name);
+int acpi_check_mem_region(resource_size_t start, resource_size_t n,
+		      const char *name);
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_mp_config	0
 
+static inline int acpi_check_region(resource_size_t start, resource_size_t n,
+				    const char *name)
+{ return 0; }
+
+static inline int acpi_check_mem_region(resource_size_t start,
+					resource_size_t n, const char *name)
+{ return 0; }
+
 #endif 	/* !CONFIG_ACPI */
 
 int acpi_register_gsi (u32 gsi, int triggering, int polarity);


