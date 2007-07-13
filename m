Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbXGMM7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbXGMM7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760012AbXGMM72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:59:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:53491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761285AbXGMM7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:59:25 -0400
Subject: [PATCH - 2/2] Identify native drivers and ACPI subsystem accessing
	the same resources - Main implementation
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Jean Delvare <khali@linux-fr.org>,
       akpm <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 14:59:23 +0200
Message-Id: <1184331563.3960.107.camel@d88.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also request ACPI OperationRegion SystemIO to be reserved via /proc/ioports

This patch registers ACPI OperationRegions (only SystemIO, SystemMemory might
follow if this works out) in /proc/ioports. Only ACPI drivers are allowed to
request space beloning to these regions via acpi_request_region (e.g. also
pnpacpi makes use of it).

Also acpi_enforce_resources= param is introduces:
  - no (default)   same behaviour as without that patch
  - lax            print msg to syslog which driver might interfere with
                   which ACPI OperationRegion
  - strict         Like lax, but also returns -EBUSY on failed interfering
                   native drivers, to force them to not load (and potentially
                   interfere with ACPI)

Signed-off-by: Thomas Renninger <trenn@suse.de>


---
 drivers/acpi/osl.c            |  283 +++++++++++++++++++++++++++++++++++++-----
 drivers/acpi/processor_core.c |    2 
 drivers/pnp/isapnp/core.c     |    9 -
 drivers/pnp/pnpacpi/core.c    |    9 -
 drivers/pnp/pnpbios/core.c    |    9 -
 drivers/pnp/system.c          |   43 ++++--
 include/linux/acpi.h          |    3 
 include/linux/ioport.h        |    2 
 include/linux/pnp.h           |    5 
 kernel/resource.c             |   16 +-
 10 files changed, 323 insertions(+), 58 deletions(-)

Index: linux-2.6.22.1/drivers/acpi/osl.c
===================================================================
--- linux-2.6.22.1.orig/drivers/acpi/osl.c
+++ linux-2.6.22.1/drivers/acpi/osl.c
@@ -44,6 +44,14 @@
 #include <asm/uaccess.h>
 
 #include <linux/efi.h>
+#include <linux/ioport.h>
+#include <linux/list.h>
+
+#if 1
+#define dprintk printk   /* debug */
+#else
+#define dprintk(format,args...)
+#endif
 
 #define _COMPONENT		ACPI_OS_SERVICES
 ACPI_MODULE_NAME("osl");
@@ -74,6 +82,15 @@ static void *acpi_irq_context;
 static struct workqueue_struct *kacpid_wq;
 static struct workqueue_struct *kacpi_notify_wq;
 
+struct ioport_res_list{
+	struct resource res;
+	struct list_head res_list;
+};
+
+static LIST_HEAD(ioport_res_list);
+DEFINE_SPINLOCK(acpi_res_lock);
+
+
 #define	OSI_STRING_LENGTH_MAX 64	/* arbitrary */
 static char osi_additional_string[OSI_STRING_LENGTH_MAX];
 
@@ -89,49 +106,133 @@ int osi_linux;		/* disable _OSI(Linux) b
 static struct __initdata dmi_system_id acpi_osl_dmi_table[];
 #endif
 
-static void __init acpi_request_region (struct acpi_generic_address *addr,
-	unsigned int length, char *desc)
-{
-	struct resource *res;
+/*
+  type: We have three mappings:
+	ACPI_ADR_SPACE_SYSTEM_IO and friends in include/acpi/actypes.h
+	IORESOURCE_IO            and friends in include/linux/ioport.h
+	and the one we go for (as we only support IO and MEM here anyway):
+	PORT (Y/N) -> IO for yes, MEM for no, also see:
+	drivers/pnp/system.c
+*/
+
+int acpi_request_region (resource_size_t addr, unsigned int length,
+			 const char *desc, unsigned int port)
+{
+	struct resource *par_res = NULL;
+	struct resource *new_res;
+	struct ioport_res_list *io_res_list;
+
+	new_res = (struct resource*) kzalloc(sizeof (struct resource), GFP_KERNEL);
+
+	new_res->start =  addr;
+	new_res->end   =  addr + length - 1;
+	new_res->name  =  desc;
 
-	if (!addr->address || !length)
-		return;
+	if (port)
+		new_res->flags |= IORESOURCE_IO;
+	else
+		new_res->flags |= IORESOURCE_MEM;
 
-	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
-		res = request_region(addr->address, length, desc);
-	else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		res = request_mem_region(addr->address, length, desc);
+	if (!addr || !length){
+		kfree(new_res);
+		return -1;
+	}
+
+	spin_lock(&acpi_res_lock);
+	list_for_each_entry(io_res_list, &ioport_res_list, res_list){
+		if (new_res->start < io_res_list->res.start){
+			if (new_res->end >= io_res_list->res.start)
+				goto err_out;
+			else
+				continue;
+		}
+		else if (new_res->end > io_res_list->res.end){
+			if (new_res->start <= io_res_list->res.end)
+				goto err_out;
+			else
+				continue;
+		}
+		par_res = &io_res_list->res;
+		break;
+	}
+
+	if (port){
+		if (par_res){
+			new_res->flags |= IORESOURCE_BUSY;
+			if (insert_resource(par_res, new_res))
+				goto err_out;
+			else
+				dprintk (KERN_ERR "Insert ACPI resource success:"
+					 " %s->%s\n", io_res_list->res.name,
+					 new_res->name);
+		}
+		else{
+			if (request_region(addr, length, desc))
+				dprintk ("Added io reg: start: %lX, end: %lX, name: %s\n",
+					 (long unsigned int)new_res->start,
+					 (long unsigned int)new_res->end, new_res->name);
+			else
+				goto err_out;
+		}
+	}
+	else{
+		if (request_mem_region(addr, length, desc))
+			dprintk ("Added mem reg: start: %lX, end: %lX, name: %s\n",
+				 (long unsigned int)new_res->start,
+				 (long unsigned int)new_res->end, new_res->name);
+		else
+			if (request_region(addr, length, desc))
+				goto err_out;
+	}
+	spin_unlock(&acpi_res_lock);
+	return 0;
+
+ err_out:
+	spin_unlock(&acpi_res_lock);
+
+	/* Partial overlap? Bad, and unfixable */
+	printk (KERN_ERR  "Could not add %s reg: start: %lX, end: %lX, name: "
+		"%s\n", port ? "IO" : "mem", (long unsigned int)new_res->start,
+		(long unsigned int)new_res->end, new_res->name);
+	if (par_res)
+		printk (KERN_ERR  "Could not add %s reg to parent: start: %lX,"
+			" end: %lX, name: %s\n", port ? "IO" : "mem",
+			(long unsigned int)par_res->start,
+			(long unsigned int)par_res->end, par_res->name);
+	kfree(new_res);
+	return -EBUSY;
 }
+EXPORT_SYMBOL(acpi_request_region);
 
 static int __init acpi_reserve_resources(void)
 {
-	acpi_request_region(&acpi_gbl_FADT.xpm1a_event_block, acpi_gbl_FADT.pm1_event_length,
-		"ACPI PM1a_EVT_BLK");
+	acpi_request_region(acpi_gbl_FADT.xpm1a_event_block.address, acpi_gbl_FADT.pm1_event_length,
+		"ACPI PM1a_EVT_BLK", 1);
 
-	acpi_request_region(&acpi_gbl_FADT.xpm1b_event_block, acpi_gbl_FADT.pm1_event_length,
-		"ACPI PM1b_EVT_BLK");
+	acpi_request_region(acpi_gbl_FADT.xpm1b_event_block.address, acpi_gbl_FADT.pm1_event_length,
+		"ACPI PM1b_EVT_BLK", 1);
 
-	acpi_request_region(&acpi_gbl_FADT.xpm1a_control_block, acpi_gbl_FADT.pm1_control_length,
-		"ACPI PM1a_CNT_BLK");
+	acpi_request_region(acpi_gbl_FADT.xpm1a_control_block.address, acpi_gbl_FADT.pm1_control_length,
+		"ACPI PM1a_CNT_BLK", 1);
 
-	acpi_request_region(&acpi_gbl_FADT.xpm1b_control_block, acpi_gbl_FADT.pm1_control_length,
-		"ACPI PM1b_CNT_BLK");
+	acpi_request_region(acpi_gbl_FADT.xpm1b_control_block.address, acpi_gbl_FADT.pm1_control_length,
+		"ACPI PM1b_CNT_BLK", 1);
 
 	if (acpi_gbl_FADT.pm_timer_length == 4)
-		acpi_request_region(&acpi_gbl_FADT.xpm_timer_block, 4, "ACPI PM_TMR");
+		acpi_request_region(acpi_gbl_FADT.xpm_timer_block.address, 4, "ACPI PM_TMR", 1);
 
-	acpi_request_region(&acpi_gbl_FADT.xpm2_control_block, acpi_gbl_FADT.pm2_control_length,
-		"ACPI PM2_CNT_BLK");
+	acpi_request_region(acpi_gbl_FADT.xpm2_control_block.address, acpi_gbl_FADT.pm2_control_length,
+		"ACPI PM2_CNT_BLK", 1);
 
 	/* Length of GPE blocks must be a non-negative multiple of 2 */
 
 	if (!(acpi_gbl_FADT.gpe0_block_length & 0x1))
-		acpi_request_region(&acpi_gbl_FADT.xgpe0_block,
-			       acpi_gbl_FADT.gpe0_block_length, "ACPI GPE0_BLK");
+		acpi_request_region(acpi_gbl_FADT.xgpe0_block.address,
+			       acpi_gbl_FADT.gpe0_block_length, "ACPI GPE0_BLK", 1);
 
 	if (!(acpi_gbl_FADT.gpe1_block_length & 0x1))
-		acpi_request_region(&acpi_gbl_FADT.xgpe1_block,
-			       acpi_gbl_FADT.gpe1_block_length, "ACPI GPE1_BLK");
+		acpi_request_region(acpi_gbl_FADT.xgpe1_block.address,
+			       acpi_gbl_FADT.gpe1_block_length, "ACPI GPE1_BLK", 1);
 
 	return 0;
 }
@@ -1049,6 +1150,57 @@ static int __init acpi_wake_gpes_always_
 __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
 
 /*
+ * Enforce declarations of ACPI OperationRegion
+ * (SystemIO and SystemMemory only) to be used as exclusive IO resources.
+ * IO ports and memory declared in ACPI might be used by the ACPI subsystem
+ * and can interfere with legacy drivers.
+ * acpi_enforce_resources= can be set to:
+ *
+ *   - strict           (2)
+ *     -> further driver trying to access the resources will not load
+ *   - lax              (1)
+ *     -> further driver trying to access the resources will load, but you
+ *     get a system message that something might go wrong...
+ *
+ *   - no (default)     (0)
+ *     -> ACPI Operation Region resources will not be registered
+ *
+ */
+
+#define ENFORCE_RESOURCES_STRICT 2
+#define ENFORCE_RESOURCES_LAX    1
+#define ENFORCE_RESOURCES_NO     0
+
+static unsigned int acpi_enforce_resources;
+
+static int __init acpi_enforce_resources_setup(char *str)
+{
+
+	char msg[64] = "Setting acpi_enforce_resources=";
+
+	if (str == NULL || *str == '\0')
+		return 0;
+
+	if (!strcmp("strict", str)){
+		acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
+		strcat(msg, "strict");
+	}
+	else if (!strcmp("lax", str)){
+		acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+		strcat(msg, "lax");
+	}
+	else if (!strcmp("no", str)){
+		acpi_enforce_resources = ENFORCE_RESOURCES_NO;
+		strcat(msg, "no");
+	}
+
+	printk(KERN_INFO "%s\n", msg);
+	return 1;
+}
+
+__setup("acpi_enforce_resources=", acpi_enforce_resources_setup);
+
+/*
  * max_cstate is defined in the base kernel so modules can
  * change it w/o depending on the state of the processor module.
  */
@@ -1220,15 +1372,90 @@ acpi_status
 acpi_os_validate_address (
     u8                   space_id,
     acpi_physical_address   address,
-    acpi_size               length)
+    acpi_size               length,
+    char *name)
 {
+	char *buf;
+	struct ioport_res_list *res;
+
+	if (acpi_enforce_resources == ENFORCE_RESOURCES_NO)
+		return AE_OK;
+
+	/*
+	   This will never ever get freed again...
+	   This could get a problem for dynamic table allocation/removal
+	   with SSDTs, needs to be handled at later time.
+	*/
+	res = (struct ioport_res_list*) kzalloc(sizeof(struct ioport_res_list), GFP_KERNEL);
+	buf = (char*)kzalloc(strlen(name) + 6, GFP_KERNEL);
 
-    return AE_OK;
+	if(!buf || !res)
+		return AE_OK;
+
+	res->res.name = buf;
+	res->res.start = address;
+	res->res.end = address + length - 1;
+
+	sprintf (buf, "ACPI %s", name);
+	switch (space_id){
+	case ACPI_ADR_SPACE_SYSTEM_IO:
+		res->res.flags |= IORESOURCE_IO;
+		list_add(&res->res_list, &ioport_res_list);
+		if (acpi_enforce_resources == ENFORCE_RESOURCES_STRICT)
+			res->res.flags |= IORESOURCE_BUSY;
+		else if (acpi_enforce_resources == ENFORCE_RESOURCES_LAX)
+			res->res.flags |= IORESOURCE_SHARED;
+		if (insert_resource(&ioport_resource, &res->res))
+			printk(KERN_ERR "Could not insert resource: %s\n",
+			       res->res.name);
+		else
+			dprintk ("Added %s %s: IO reg: start: %lX, end: %lX, "
+				 "name: %s\n",
+				 (res->res.flags & IORESOURCE_SHARED)
+				 ? "sharable" : "",
+				 (res->res.flags & IORESOURCE_BUSY)
+				 ? "busy" : "",
+				 (long unsigned int)res->res.start,
+				 (long unsigned int)res->res.end,
+				 res->res.name);
+		break;
+
+	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
+		res->res.flags |= IORESOURCE_MEM;
+		printk ("%s - %s\n", __FUNCTION__, buf);
+		if (acpi_enforce_resources == ENFORCE_RESOURCES_STRICT)
+			res->res.flags |= IORESOURCE_BUSY;
+		else if (acpi_enforce_resources == ENFORCE_RESOURCES_LAX)
+			res->res.flags |= IORESOURCE_SHARED;
+		if (insert_resource(&iomem_resource, &res->res))
+			printk(KERN_ERR "Could not insert resource: %s\n",
+			       res->res.name);
+		else
+			dprintk ("Added %s %s: mem reg: start: %lX, end: %lX, "
+				 "name: %s\n",
+				 (res->res.flags & IORESOURCE_SHARED)
+				 ? "sharable" : "",
+				 (res->res.flags & IORESOURCE_BUSY)
+				 ? "busy" : "",
+				 (long unsigned int)res->res.start,
+				 (long unsigned int)res->res.end,
+				 res->res.name);
+		break;
+ 	case ACPI_ADR_SPACE_PCI_CONFIG:
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
 #ifdef	OSI_LINUX_ENABLED
-static int dmi_osi_not_linux(struct dmi_system_id *d)
+	static int dmi_osi_not_linux(struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: requires not _OSI(Linux)\n", d->ident);
 	enable_osi_linux(0);
Index: linux-2.6.22.1/include/linux/ioport.h
===================================================================
--- linux-2.6.22.1.orig/include/linux/ioport.h
+++ linux-2.6.22.1/include/linux/ioport.h
@@ -45,6 +45,8 @@ struct resource_list {
 #define IORESOURCE_SHADOWABLE	0x00010000
 #define IORESOURCE_BUS_HAS_VGA	0x00080000
 
+#define IORESOURCE_SHARED	0x00100000	/* This IO address appears in ACPI namespace */
+
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
 #define IORESOURCE_AUTO		0x40000000
Index: linux-2.6.22.1/kernel/resource.c
===================================================================
--- linux-2.6.22.1.orig/kernel/resource.c
+++ linux-2.6.22.1/kernel/resource.c
@@ -80,11 +80,12 @@ static int r_show(struct seq_file *m, vo
 	for (depth = 0, p = r; depth < MAX_IORES_LEVEL; depth++, p = p->parent)
 		if (p->parent == root)
 			break;
-	seq_printf(m, "%*s%0*llx-%0*llx : %s\n",
+	seq_printf(m, "%*s%0*llx-%0*llx : %s%s - %p\n",
 			depth * 2, "",
 			width, (unsigned long long) r->start,
 			width, (unsigned long long) r->end,
-			r->name ? r->name : "<BAD>");
+			r->name ? r->name : "<BAD>", r->flags &
+		        IORESOURCE_SHARED ? "*" : "",r);
 	return 0;
 }
 
@@ -382,8 +383,10 @@ int insert_resource(struct resource *par
 
 	for (next = first; ; next = next->sibling) {
 		/* Partial overlap? Bad, and unfixable */
-		if (next->start < new->start || next->end > new->end)
+		if (next->start < new->start || next->end > new->end){
+			result = -EFAULT;
 			goto out;
+		}
 		if (!next->sibling)
 			break;
 		if (next->sibling->start > new->end)
@@ -503,6 +506,13 @@ struct resource * __request_region(struc
 			if (!conflict)
 				break;
 			if (conflict != parent) {
+				if (conflict->flags & IORESOURCE_SHARED){
+					printk(KERN_ERR "IO region [%s]"
+					       " conflicts with [%s]. "
+					       " Ignoring.., system might run"
+					       " unstable.\n",
+					       res->name, conflict->name);
+				}
 				parent = conflict;
 				if (!(conflict->flags & IORESOURCE_BUSY))
 					continue;
Index: linux-2.6.22.1/drivers/pnp/system.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/system.c
+++ linux-2.6.22.1/drivers/pnp/system.c
@@ -22,21 +22,18 @@ static const struct pnp_device_id pnp_de
 	{	"",			0	}
 };
 
-static void reserve_range(const char *pnpid, resource_size_t start, resource_size_t end, int port)
+int pnp_reserve_range(resource_size_t start, unsigned int length,
+		  const char *pnpid, int port)
 {
 	struct resource *res;
-	char *regionid;
 
-	regionid = kmalloc(16, GFP_KERNEL);
-	if (regionid == NULL)
-		return;
-	snprintf(regionid, 16, "pnp %s", pnpid);
 	if (port)
-		res = request_region(start, end-start+1, regionid);
+		res = request_region(start, length, pnpid);
 	else
-		res = request_mem_region(start, end-start+1, regionid);
+		res = request_region(start, length, pnpid);
+
 	if (res == NULL)
-		kfree(regionid);
+		return -EBUSY;
 	else
 		res->flags &= ~IORESOURCE_BUSY;
 	/*
@@ -47,13 +44,15 @@ static void reserve_range(const char *pn
 	printk(KERN_INFO
 		"pnp: %s: %s range 0x%llx-0x%llx %s reserved\n",
 		pnpid, port ? "ioport" : "iomem",
-                (unsigned long long)start, (unsigned long long)end,
+                (unsigned long long)start, (unsigned long long)start+length,
 		NULL != res ? "has been" : "could not be");
+	return 0;
 }
 
 static void reserve_resources_of_dev(const struct pnp_dev *dev)
 {
 	int i;
+	char *regionid;
 
 	for (i = 0; i < PNP_MAX_PORT; i++) {
 		if (!pnp_port_valid(dev, i))
@@ -73,16 +72,32 @@ static void reserve_resources_of_dev(con
 		if (pnp_port_end(dev, i) < pnp_port_start(dev, i))
 			continue;	/* invalid */
 
-		reserve_range(dev->dev.bus_id, pnp_port_start(dev, i),
-			pnp_port_end(dev, i), 1);
+		regionid = kmalloc(16, GFP_KERNEL);
+		if (regionid == NULL)
+			return;
+		snprintf(regionid, 16, "pnp %s", dev->dev.bus_id);
+
+   		if (dev->protocol->request_sys_resource(pnp_port_start(dev, i),
+							pnp_port_end(dev, i)
+							- pnp_port_start(dev, i) + 1,
+							regionid, 1))
+			kfree(regionid);
 	}
 
 	for (i = 0; i < PNP_MAX_MEM; i++) {
 		if (!pnp_mem_valid(dev, i))
 			continue;
 
-		reserve_range(dev->dev.bus_id, pnp_mem_start(dev, i),
-			pnp_mem_end(dev, i), 0);
+		regionid = kmalloc(16, GFP_KERNEL);
+		if (regionid == NULL)
+			return;
+		snprintf(regionid, 16, "pnp %s", dev->dev.bus_id);
+
+   		if (dev->protocol->request_sys_resource(pnp_port_start(dev, i),
+							pnp_port_end(dev, i)
+							- pnp_port_start(dev, i) + 1,
+							regionid, 1))
+			kfree(regionid);
 	}
 
 	return;
Index: linux-2.6.22.1/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.22.1.orig/drivers/acpi/processor_core.c
+++ linux-2.6.22.1/drivers/acpi/processor_core.c
@@ -606,7 +606,7 @@ static int acpi_processor_get_info(struc
 		 *
 		 * (In particular, allocating the IO range for Cardbus)
 		 */
-		request_region(pr->throttling.address, 6, "ACPI CPU throttle");
+		acpi_request_region(pr->throttling.address, 6, "ACPI CPU throttle", 1);
 	}
 
 #ifdef CONFIG_CPU_FREQ
Index: linux-2.6.22.1/include/linux/pnp.h
===================================================================
--- linux-2.6.22.1.orig/include/linux/pnp.h
+++ linux-2.6.22.1/include/linux/pnp.h
@@ -326,6 +326,9 @@ struct pnp_card_driver {
  * Protocol Management
  */
 
+int pnp_reserve_range(resource_size_t start, unsigned int length,
+		      const char *pnpid, int port);
+
 struct pnp_protocol {
 	struct list_head	protocol_list;
 	char		      * name;
@@ -334,6 +337,8 @@ struct pnp_protocol {
 	int (*get)(struct pnp_dev *dev, struct pnp_resource_table *res);
 	int (*set)(struct pnp_dev *dev, struct pnp_resource_table *res);
 	int (*disable)(struct pnp_dev *dev);
+	int (*request_sys_resource)(resource_size_t addr, unsigned int length,
+				    const char *desc, unsigned int port);
 
 	/* used by pnp layer only (look but don't touch) */
 	unsigned char		number;		/* protocol number*/
Index: linux-2.6.22.1/drivers/pnp/isapnp/core.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/isapnp/core.c
+++ linux-2.6.22.1/drivers/pnp/isapnp/core.c
@@ -1032,10 +1032,11 @@ static int isapnp_disable_resources(stru
 }
 
 struct pnp_protocol isapnp_protocol = {
-	.name	= "ISA Plug and Play",
-	.get	= isapnp_get_resources,
-	.set	= isapnp_set_resources,
-	.disable = isapnp_disable_resources,
+	.name			= "ISA Plug and Play",
+	.get			= isapnp_get_resources,
+	.set			= isapnp_set_resources,
+	.disable		= isapnp_disable_resources,
+	.request_sys_resource	= pnp_reserve_range,
 };
 
 static int __init isapnp_init(void)
Index: linux-2.6.22.1/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/pnpacpi/core.c
+++ linux-2.6.22.1/drivers/pnp/pnpacpi/core.c
@@ -120,10 +120,11 @@ static int pnpacpi_disable_resources(str
 }
 
 static struct pnp_protocol pnpacpi_protocol = {
-	.name	= "Plug and Play ACPI",
-	.get	= pnpacpi_get_resources,
-	.set	= pnpacpi_set_resources,
-	.disable = pnpacpi_disable_resources,
+	.name			= "Plug and Play ACPI",
+	.get			= pnpacpi_get_resources,
+	.set			= pnpacpi_set_resources,
+	.disable		= pnpacpi_disable_resources,
+	.request_sys_resource	= acpi_request_region,
 };
 
 static int __init pnpacpi_add_device(struct acpi_device *device)
Index: linux-2.6.22.1/drivers/pnp/pnpbios/core.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/pnpbios/core.c
+++ linux-2.6.22.1/drivers/pnp/pnpbios/core.c
@@ -310,10 +310,11 @@ static int pnpbios_disable_resources(str
 /* PnP Layer support */
 
 struct pnp_protocol pnpbios_protocol = {
-	.name	= "Plug and Play BIOS",
-	.get	= pnpbios_get_resources,
-	.set	= pnpbios_set_resources,
-	.disable = pnpbios_disable_resources,
+	.name			= "Plug and Play BIOS",
+	.get			= pnpbios_get_resources,
+	.set			= pnpbios_set_resources,
+	.disable		= pnpbios_disable_resources,
+	.request_sys_resource	= pnp_reserve_range,
 };
 
 static int insert_device(struct pnp_dev *dev, struct pnp_bios_node * node)
Index: linux-2.6.22.1/include/linux/acpi.h
===================================================================
--- linux-2.6.22.1.orig/include/linux/acpi.h
+++ linux-2.6.22.1/include/linux/acpi.h
@@ -174,6 +174,9 @@ struct acpi_pci_driver {
 int acpi_pci_register_driver(struct acpi_pci_driver *driver);
 void acpi_pci_unregister_driver(struct acpi_pci_driver *driver);
 
+int acpi_request_region (resource_size_t addr, unsigned int length,
+			 const char *desc, unsigned int port);
+
 #endif /* CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_EC


