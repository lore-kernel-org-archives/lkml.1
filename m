Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbXFTRZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbXFTRZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXFTRY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:24:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:60225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXFTRY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:24:57 -0400
Subject: Re: [PATCH 2/3] ACPI autoloading - Create acpi alias interface
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Kay Sievers <kasievers@suse.de>
In-Reply-To: <20070620155220.GA9226@inferi.kami.home>
References: <1182111854.4204.4.camel@noname>
	 <1182112047.4204.12.camel@noname>  <20070620155220.GA9226@inferi.kami.home>
Content-Type: multipart/mixed; boundary="=-ZtsrFCLGdz6Bwra/8l5d"
Organization: Novell/SUSE
Date: Wed, 20 Jun 2007 19:24:54 +0200
Message-Id: <1182360294.28514.685.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZtsrFCLGdz6Bwra/8l5d
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-06-21 at 00:52 +0900, Mattia Dongili wrote:
> On Sun, Jun 17, 2007 at 10:27:27PM +0200, Thomas Renninger wrote:
> > Create acpi alias interface
> ...
> > +static __initdata struct acpi_device_id excluded_id_list[] ={
> > +	{"PNP0C09", 0}, /* EC */
> > +	{"PNP0C0F", 0}, /* Link device */
> > +	{"PNP0000", 0}, /* PIC */
> > +	{"PNP0100", 0}, /* Timer */
> > +	{"", 0};
>               ^^^
> eeek!

Autch... Did not even compile, right? I first forgot to initialise this
one at all with {"", 0}, then added it and did not test recompile, sorry
about that.

Thanks a lot for trying out!

That one is better:

Create acpi alias interface

Modify modpost (file2alias.c) to add acpi*:XYZ0001: alias in modules.alias
like:
grep acpi /lib/modules/2.6.22-rc4-default/modules.alias 
alias acpi*:SNY5001:* sony_laptop
alias acpi*:SNY6001:* sony_laptop
for e.g. the sony_laptop module.
This module matches against all ACPI devices with a HID or CID of SNY5001
or SNY6001

Export an uevent and modalias sysfs file containing the string:
[MODALIAS=]acpi:PNP0C0C:
additional CIDs are concatenated at the end.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/scan.c             |  163 ++++++++++++++++++++++++++++------------
 drivers/pnp/pnpacpi/core.c      |   19 ++--
 include/linux/acpi.h            |    1 
 include/linux/mod_devicetable.h |   15 +++
 scripts/mod/file2alias.c        |   12 ++
 5 files changed, 158 insertions(+), 52 deletions(-)

Index: linux-2.6.22-rc5/include/linux/mod_devicetable.h
===================================================================
--- linux-2.6.22-rc5.orig/include/linux/mod_devicetable.h
+++ linux-2.6.22-rc5/include/linux/mod_devicetable.h
@@ -159,6 +159,21 @@ struct ap_device_id {
 
 #define AP_DEVICE_ID_MATCH_DEVICE_TYPE		0x01
 
+#define ACPI_ID_LEN	9
+
+/*
+  Similar exists in include/acpi/acmacros.h
+  use this one for acpi linux specific stuff e.g.
+  in ACPI modules and the other one inside the
+  interpreter
+*/
+
+/* Exists already in acpi includes (include/acpi/actypes.h) */
+
+struct acpi_device_id {
+	__u8 id[ACPI_ID_LEN];
+	kernel_ulong_t driver_data;
+};
 
 #define PNP_ID_LEN	8
 #define PNP_MAX_DEVICES	8
Index: linux-2.6.22-rc5/scripts/mod/file2alias.c
===================================================================
--- linux-2.6.22-rc5.orig/scripts/mod/file2alias.c
+++ linux-2.6.22-rc5/scripts/mod/file2alias.c
@@ -290,6 +290,14 @@ static int do_serio_entry(const char *fi
 	return 1;
 }
 
+/* looks like: "acpi:ACPI0003 or acpi:PNP0C0B" */
+static int do_acpi_entry(const char *filename,
+			struct acpi_device_id *id, char *alias)
+{
+	sprintf(alias, "acpi*:%s:", id->id);
+	return 1;
+}
+
 /* looks like: "pnp:dD" */
 static int do_pnp_entry(const char *filename,
 			struct pnp_device_id *id, char *alias)
@@ -551,6 +559,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct serio_device_id), "serio",
 			 do_serio_entry, mod);
+	else if (sym_is(symname, "__mod_acpi_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct acpi_device_id), "acpi",
+			 do_acpi_entry, mod);
 	else if (sym_is(symname, "__mod_pnp_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct pnp_device_id), "pnp",
Index: linux-2.6.22-rc5/drivers/acpi/scan.c
===================================================================
--- linux-2.6.22-rc5.orig/drivers/acpi/scan.c
+++ linux-2.6.22-rc5/drivers/acpi/scan.c
@@ -16,7 +16,7 @@ ACPI_MODULE_NAME("scan");
 extern struct acpi_device *acpi_root;
 
 #define ACPI_BUS_CLASS			"system_bus"
-#define ACPI_BUS_HID			"ACPI_BUS"
+#define ACPI_BUS_HID			"XBUS0001"
 #define ACPI_BUS_DEVICE_NAME		"System Bus"
 
 static LIST_HEAD(acpi_device_list);
@@ -29,6 +29,69 @@ struct acpi_device_bus_id{
 	unsigned int instance_no;
 	struct list_head node;
 };
+
+/*
+  Currently only handles ID strings, not compressed EISA, here the spec:
+
+  A _HID object evaluates to either a numeric 32-bit compressed EISA type ID
+  or a string. If a string, the format must be an alphanumeric PNP or ACPI ID
+  with no asterisk or other leading characters.
+
+  Why is hardware_id char[15] -> see include/acpi/acpi_bus.h ?!?
+
+  This function only handles devices correctly that have a HID.
+  If there are devices that have CID(s), but no HID work needs
+*/
+int create_modalias(struct acpi_device *acpi_dev, char *modalias, int size){
+
+	int len;
+
+	if (!acpi_dev->flags.hardware_id)
+		return -ENODEV;
+
+	len = snprintf(modalias, size, "acpi:%s:",
+		       acpi_dev->pnp.hardware_id);
+	if (len < 0 || len >= size)
+		return -EINVAL;
+	size -= len;
+
+	if (acpi_dev->flags.compatible_ids) {
+		struct acpi_compatible_id_list *cid_list;
+		int i;
+		int count;
+
+		cid_list = acpi_dev->pnp.cid_list;
+		for (i = 0; i < cid_list->count; i++) {
+			count = snprintf(&modalias[len], size, "%s:",
+					 cid_list->id[i].value);
+			if (count < 0 || count >= size) {
+				printk(KERN_ERR "acpi: %s cid[%i] exceeds event buffer size",
+				       acpi_dev->pnp.device_name, i);
+				break;
+			}
+			len += count;
+			size -= count;
+		}
+	}
+
+	modalias[len] = '\0';
+	return len;
+}
+
+static ssize_t
+acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, char *buf) {
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	int len;
+
+	/* Device has no HID and no CID or string is >1024 */
+	len = create_modalias(acpi_dev, buf, 1024);
+	if (len <= 0)
+		return 0;
+	buf[len++] = '\n';
+	return len;
+}
+static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
+
 static int acpi_eject_operation(acpi_handle handle, int lockable)
 {
 	struct acpi_object_list arg_list;
@@ -154,6 +217,12 @@ static int acpi_device_setup_files(struc
 			goto end;
 	}
 
+	if (dev->flags.hardware_id || dev->flags.compatible_ids){
+		result = device_create_file(&dev->dev, &dev_attr_modalias);
+		if(result)
+			goto end;
+	}
+
         /*
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
@@ -178,6 +247,9 @@ static void acpi_device_remove_files(str
 	if (ACPI_SUCCESS(status))
 		device_remove_file(&dev->dev, &dev_attr_eject);
 
+	if (dev->flags.hardware_id || dev->flags.compatible_ids)
+		device_remove_file(&dev->dev, &dev_attr_modalias);
+
 	if(dev->flags.hardware_id)
 		device_remove_file(&dev->dev, &dev_attr_hid);
 	if(dev->handle)
@@ -186,6 +258,37 @@ static void acpi_device_remove_files(str
 /* --------------------------------------------------------------------------
 			ACPI Bus operations
    -------------------------------------------------------------------------- */
+
+int acpi_match_device_ids(struct acpi_device *device,
+			  const struct acpi_device_id *ids)
+{
+	const struct acpi_device_id *id;
+
+	if (device->flags.hardware_id) {
+		for (id = ids; id->id[0]; id++) {
+			if (!strcmp((char*)id->id, device->pnp.hardware_id))
+				return 0;
+		}
+	}
+
+	if (device->flags.compatible_ids) {
+		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
+		int i;
+
+		for (id = ids; id->id[0]; id++) {
+			/* compare multiple _CID entries against driver ids */
+			for (i = 0; i < cid_list->count; i++) {
+				if (!strcmp((char*)id->id,
+					    cid_list->id[i].value))
+					return 0;
+			}
+		}
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL(acpi_match_device_ids);
+
 static void acpi_device_release(struct device *dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
@@ -219,37 +322,19 @@ static int acpi_bus_match(struct device 
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	return !acpi_match_ids(acpi_dev, acpi_drv->ids);
+	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }
 
 static int acpi_device_uevent(struct device *dev, char **envp, int num_envp,
-	char *buffer, int buffer_size)
+			      char *buffer, int buffer_size)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
-	int i = 0, length = 0, ret = 0;
-
-	if (acpi_dev->flags.hardware_id)
-		ret = add_uevent_var(envp, num_envp, &i,
-			buffer, buffer_size, &length,
-			"HWID=%s", acpi_dev->pnp.hardware_id);
-	if (ret)
-		return -ENOMEM;
-	if (acpi_dev->flags.compatible_ids) {
-		int j;
-		struct acpi_compatible_id_list *cid_list;
 
-		cid_list = acpi_dev->pnp.cid_list;
-
-		for (j = 0; j < cid_list->count; j++) {
-			ret = add_uevent_var(envp, num_envp, &i, buffer,
-				buffer_size, &length, "COMPTID=%s",
-				cid_list->id[j].value);
-			if (ret)
-				return -ENOMEM;
-		}
+	strcpy(buffer, "MODALIAS=");
+	if (create_modalias(acpi_dev, buffer + 9, buffer_size - 9) > 0) {
+		envp[0] = buffer;
+		envp[1] = NULL;
 	}
-
-	envp[i] = NULL;
 	return 0;
 }
 
@@ -543,25 +628,6 @@ void acpi_bus_data_handler(acpi_handle h
 	return;
 }
 
-int acpi_match_ids(struct acpi_device *device, char *ids)
-{
-	if (device->flags.hardware_id)
-		if (strstr(ids, device->pnp.hardware_id))
-			return 0;
-
-	if (device->flags.compatible_ids) {
-		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
-		int i;
-
-		/* compare multiple _CID entries against driver ids */
-		for (i = 0; i < cid_list->count; i++) {
-			if (strstr(ids, cid_list->id[i].value))
-				return 0;
-		}
-	}
-	return -ENOENT;
-}
-
 static int acpi_bus_get_perf_flags(struct acpi_device *device)
 {
 	device->performance.state = ACPI_STATE_UNKNOWN;
@@ -624,6 +690,13 @@ static int acpi_bus_get_wakeup_device_fl
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *package = NULL;
 
+	struct acpi_device_id button_device_ids[] = {
+		{"PNP0C0D", 0},
+		{"PNP0C0C", 0},
+		{"PNP0C0E", 0},
+		{"", 0},
+	};
+
 
 	/* _PRW */
 	status = acpi_evaluate_object(device->handle, "_PRW", NULL, &buffer);
@@ -643,7 +716,7 @@ static int acpi_bus_get_wakeup_device_fl
 
 	device->wakeup.flags.valid = 1;
 	/* Power button, Lid switch always enable wakeup */
-	if (!acpi_match_ids(device, "PNP0C0D,PNP0C0C,PNP0C0E"))
+	if (!acpi_match_device_ids(device, button_device_ids))
 		device->wakeup.flags.run_wake = 1;
 
       end:
Index: linux-2.6.22-rc5/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-2.6.22-rc5.orig/drivers/pnp/pnpacpi/core.c
+++ linux-2.6.22-rc5/drivers/pnp/pnpacpi/core.c
@@ -21,7 +21,10 @@
 
 #include <linux/acpi.h>
 #include <linux/pnp.h>
+#include <linux/mod_devicetable.h>
 #include <acpi/acpi_bus.h>
+#include <acpi/actypes.h>
+
 #include "pnpacpi.h"
 
 static int num = 0;
@@ -33,15 +36,17 @@ static int num = 0;
  * have irqs (PIC, Timer) because we call acpi_register_gsi.
  * Finaly only devices that have a CRS method need to be in this list.
  */
-static char __initdata excluded_id_list[] =
-	"PNP0C09," /* EC */
-	"PNP0C0F," /* Link device */
-	"PNP0000," /* PIC */
-	"PNP0100," /* Timer */
-	;
+static __initdata struct acpi_device_id excluded_id_list[] ={
+	{"PNP0C09", 0}, /* EC */
+	{"PNP0C0F", 0}, /* Link device */
+	{"PNP0000", 0}, /* PIC */
+	{"PNP0100", 0}, /* Timer */
+	{"", 0},
+};
+
 static inline int is_exclusive_device(struct acpi_device *dev)
 {
-	return (!acpi_match_ids(dev, excluded_id_list));
+	return (!acpi_match_device_ids(dev, excluded_id_list));
 }
 
 /*
Index: linux-2.6.22-rc5/include/linux/acpi.h
===================================================================
--- linux-2.6.22-rc5.orig/include/linux/acpi.h
+++ linux-2.6.22-rc5/include/linux/acpi.h
@@ -33,6 +33,7 @@
 #endif
 
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
 
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>


--=-ZtsrFCLGdz6Bwra/8l5d
Content-Disposition: attachment; filename=acpi_autoloading_interface.patch
Content-Type: text/x-patch; name=acpi_autoloading_interface.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Create acpi alias interface

Modify modpost (file2alias.c) to add acpi*:XYZ0001: alias in modules.alias
like:
grep acpi /lib/modules/2.6.22-rc4-default/modules.alias 
alias acpi*:SNY5001:* sony_laptop
alias acpi*:SNY6001:* sony_laptop
for e.g. the sony_laptop module.
This module matches against all ACPI devices with a HID or CID of SNY5001
or SNY6001

Export an uevent and modalias sysfs file containing the string:
[MODALIAS=]acpi:PNP0C0C:
additional CIDs are concatenated at the end.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/scan.c             |  163 ++++++++++++++++++++++++++++------------
 drivers/pnp/pnpacpi/core.c      |   19 ++--
 include/linux/acpi.h            |    1 
 include/linux/mod_devicetable.h |   15 +++
 scripts/mod/file2alias.c        |   12 ++
 5 files changed, 158 insertions(+), 52 deletions(-)

Index: linux-2.6.22-rc5/include/linux/mod_devicetable.h
===================================================================
--- linux-2.6.22-rc5.orig/include/linux/mod_devicetable.h
+++ linux-2.6.22-rc5/include/linux/mod_devicetable.h
@@ -159,6 +159,21 @@ struct ap_device_id {
 
 #define AP_DEVICE_ID_MATCH_DEVICE_TYPE		0x01
 
+#define ACPI_ID_LEN	9
+
+/*
+  Similar exists in include/acpi/acmacros.h
+  use this one for acpi linux specific stuff e.g.
+  in ACPI modules and the other one inside the
+  interpreter
+*/
+
+/* Exists already in acpi includes (include/acpi/actypes.h) */
+
+struct acpi_device_id {
+	__u8 id[ACPI_ID_LEN];
+	kernel_ulong_t driver_data;
+};
 
 #define PNP_ID_LEN	8
 #define PNP_MAX_DEVICES	8
Index: linux-2.6.22-rc5/scripts/mod/file2alias.c
===================================================================
--- linux-2.6.22-rc5.orig/scripts/mod/file2alias.c
+++ linux-2.6.22-rc5/scripts/mod/file2alias.c
@@ -290,6 +290,14 @@ static int do_serio_entry(const char *fi
 	return 1;
 }
 
+/* looks like: "acpi:ACPI0003 or acpi:PNP0C0B" */
+static int do_acpi_entry(const char *filename,
+			struct acpi_device_id *id, char *alias)
+{
+	sprintf(alias, "acpi*:%s:", id->id);
+	return 1;
+}
+
 /* looks like: "pnp:dD" */
 static int do_pnp_entry(const char *filename,
 			struct pnp_device_id *id, char *alias)
@@ -551,6 +559,10 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct serio_device_id), "serio",
 			 do_serio_entry, mod);
+	else if (sym_is(symname, "__mod_acpi_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct acpi_device_id), "acpi",
+			 do_acpi_entry, mod);
 	else if (sym_is(symname, "__mod_pnp_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct pnp_device_id), "pnp",
Index: linux-2.6.22-rc5/drivers/acpi/scan.c
===================================================================
--- linux-2.6.22-rc5.orig/drivers/acpi/scan.c
+++ linux-2.6.22-rc5/drivers/acpi/scan.c
@@ -16,7 +16,7 @@ ACPI_MODULE_NAME("scan");
 extern struct acpi_device *acpi_root;
 
 #define ACPI_BUS_CLASS			"system_bus"
-#define ACPI_BUS_HID			"ACPI_BUS"
+#define ACPI_BUS_HID			"XBUS0001"
 #define ACPI_BUS_DEVICE_NAME		"System Bus"
 
 static LIST_HEAD(acpi_device_list);
@@ -29,6 +29,69 @@ struct acpi_device_bus_id{
 	unsigned int instance_no;
 	struct list_head node;
 };
+
+/*
+  Currently only handles ID strings, not compressed EISA, here the spec:
+
+  A _HID object evaluates to either a numeric 32-bit compressed EISA type ID
+  or a string. If a string, the format must be an alphanumeric PNP or ACPI ID
+  with no asterisk or other leading characters.
+
+  Why is hardware_id char[15] -> see include/acpi/acpi_bus.h ?!?
+
+  This function only handles devices correctly that have a HID.
+  If there are devices that have CID(s), but no HID work needs
+*/
+int create_modalias(struct acpi_device *acpi_dev, char *modalias, int size){
+
+	int len;
+
+	if (!acpi_dev->flags.hardware_id)
+		return -ENODEV;
+
+	len = snprintf(modalias, size, "acpi:%s:",
+		       acpi_dev->pnp.hardware_id);
+	if (len < 0 || len >= size)
+		return -EINVAL;
+	size -= len;
+
+	if (acpi_dev->flags.compatible_ids) {
+		struct acpi_compatible_id_list *cid_list;
+		int i;
+		int count;
+
+		cid_list = acpi_dev->pnp.cid_list;
+		for (i = 0; i < cid_list->count; i++) {
+			count = snprintf(&modalias[len], size, "%s:",
+					 cid_list->id[i].value);
+			if (count < 0 || count >= size) {
+				printk(KERN_ERR "acpi: %s cid[%i] exceeds event buffer size",
+				       acpi_dev->pnp.device_name, i);
+				break;
+			}
+			len += count;
+			size -= count;
+		}
+	}
+
+	modalias[len] = '\0';
+	return len;
+}
+
+static ssize_t
+acpi_device_modalias_show(struct device *dev, struct device_attribute *attr, char *buf) {
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	int len;
+
+	/* Device has no HID and no CID or string is >1024 */
+	len = create_modalias(acpi_dev, buf, 1024);
+	if (len <= 0)
+		return 0;
+	buf[len++] = '\n';
+	return len;
+}
+static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
+
 static int acpi_eject_operation(acpi_handle handle, int lockable)
 {
 	struct acpi_object_list arg_list;
@@ -154,6 +217,12 @@ static int acpi_device_setup_files(struc
 			goto end;
 	}
 
+	if (dev->flags.hardware_id || dev->flags.compatible_ids){
+		result = device_create_file(&dev->dev, &dev_attr_modalias);
+		if(result)
+			goto end;
+	}
+
         /*
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
@@ -178,6 +247,9 @@ static void acpi_device_remove_files(str
 	if (ACPI_SUCCESS(status))
 		device_remove_file(&dev->dev, &dev_attr_eject);
 
+	if (dev->flags.hardware_id || dev->flags.compatible_ids)
+		device_remove_file(&dev->dev, &dev_attr_modalias);
+
 	if(dev->flags.hardware_id)
 		device_remove_file(&dev->dev, &dev_attr_hid);
 	if(dev->handle)
@@ -186,6 +258,37 @@ static void acpi_device_remove_files(str
 /* --------------------------------------------------------------------------
 			ACPI Bus operations
    -------------------------------------------------------------------------- */
+
+int acpi_match_device_ids(struct acpi_device *device,
+			  const struct acpi_device_id *ids)
+{
+	const struct acpi_device_id *id;
+
+	if (device->flags.hardware_id) {
+		for (id = ids; id->id[0]; id++) {
+			if (!strcmp((char*)id->id, device->pnp.hardware_id))
+				return 0;
+		}
+	}
+
+	if (device->flags.compatible_ids) {
+		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
+		int i;
+
+		for (id = ids; id->id[0]; id++) {
+			/* compare multiple _CID entries against driver ids */
+			for (i = 0; i < cid_list->count; i++) {
+				if (!strcmp((char*)id->id,
+					    cid_list->id[i].value))
+					return 0;
+			}
+		}
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL(acpi_match_device_ids);
+
 static void acpi_device_release(struct device *dev)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
@@ -219,37 +322,19 @@ static int acpi_bus_match(struct device 
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	return !acpi_match_ids(acpi_dev, acpi_drv->ids);
+	return !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }
 
 static int acpi_device_uevent(struct device *dev, char **envp, int num_envp,
-	char *buffer, int buffer_size)
+			      char *buffer, int buffer_size)
 {
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
-	int i = 0, length = 0, ret = 0;
-
-	if (acpi_dev->flags.hardware_id)
-		ret = add_uevent_var(envp, num_envp, &i,
-			buffer, buffer_size, &length,
-			"HWID=%s", acpi_dev->pnp.hardware_id);
-	if (ret)
-		return -ENOMEM;
-	if (acpi_dev->flags.compatible_ids) {
-		int j;
-		struct acpi_compatible_id_list *cid_list;
 
-		cid_list = acpi_dev->pnp.cid_list;
-
-		for (j = 0; j < cid_list->count; j++) {
-			ret = add_uevent_var(envp, num_envp, &i, buffer,
-				buffer_size, &length, "COMPTID=%s",
-				cid_list->id[j].value);
-			if (ret)
-				return -ENOMEM;
-		}
+	strcpy(buffer, "MODALIAS=");
+	if (create_modalias(acpi_dev, buffer + 9, buffer_size - 9) > 0) {
+		envp[0] = buffer;
+		envp[1] = NULL;
 	}
-
-	envp[i] = NULL;
 	return 0;
 }
 
@@ -543,25 +628,6 @@ void acpi_bus_data_handler(acpi_handle h
 	return;
 }
 
-int acpi_match_ids(struct acpi_device *device, char *ids)
-{
-	if (device->flags.hardware_id)
-		if (strstr(ids, device->pnp.hardware_id))
-			return 0;
-
-	if (device->flags.compatible_ids) {
-		struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
-		int i;
-
-		/* compare multiple _CID entries against driver ids */
-		for (i = 0; i < cid_list->count; i++) {
-			if (strstr(ids, cid_list->id[i].value))
-				return 0;
-		}
-	}
-	return -ENOENT;
-}
-
 static int acpi_bus_get_perf_flags(struct acpi_device *device)
 {
 	device->performance.state = ACPI_STATE_UNKNOWN;
@@ -624,6 +690,13 @@ static int acpi_bus_get_wakeup_device_fl
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *package = NULL;
 
+	struct acpi_device_id button_device_ids[] = {
+		{"PNP0C0D", 0},
+		{"PNP0C0C", 0},
+		{"PNP0C0E", 0},
+		{"", 0},
+	};
+
 
 	/* _PRW */
 	status = acpi_evaluate_object(device->handle, "_PRW", NULL, &buffer);
@@ -643,7 +716,7 @@ static int acpi_bus_get_wakeup_device_fl
 
 	device->wakeup.flags.valid = 1;
 	/* Power button, Lid switch always enable wakeup */
-	if (!acpi_match_ids(device, "PNP0C0D,PNP0C0C,PNP0C0E"))
+	if (!acpi_match_device_ids(device, button_device_ids))
 		device->wakeup.flags.run_wake = 1;
 
       end:
Index: linux-2.6.22-rc5/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-2.6.22-rc5.orig/drivers/pnp/pnpacpi/core.c
+++ linux-2.6.22-rc5/drivers/pnp/pnpacpi/core.c
@@ -21,7 +21,10 @@
 
 #include <linux/acpi.h>
 #include <linux/pnp.h>
+#include <linux/mod_devicetable.h>
 #include <acpi/acpi_bus.h>
+#include <acpi/actypes.h>
+
 #include "pnpacpi.h"
 
 static int num = 0;
@@ -33,15 +36,17 @@ static int num = 0;
  * have irqs (PIC, Timer) because we call acpi_register_gsi.
  * Finaly only devices that have a CRS method need to be in this list.
  */
-static char __initdata excluded_id_list[] =
-	"PNP0C09," /* EC */
-	"PNP0C0F," /* Link device */
-	"PNP0000," /* PIC */
-	"PNP0100," /* Timer */
-	;
+static __initdata struct acpi_device_id excluded_id_list[] ={
+	{"PNP0C09", 0}, /* EC */
+	{"PNP0C0F", 0}, /* Link device */
+	{"PNP0000", 0}, /* PIC */
+	{"PNP0100", 0}, /* Timer */
+	{"", 0},
+};
+
 static inline int is_exclusive_device(struct acpi_device *dev)
 {
-	return (!acpi_match_ids(dev, excluded_id_list));
+	return (!acpi_match_device_ids(dev, excluded_id_list));
 }
 
 /*
Index: linux-2.6.22-rc5/include/linux/acpi.h
===================================================================
--- linux-2.6.22-rc5.orig/include/linux/acpi.h
+++ linux-2.6.22-rc5/include/linux/acpi.h
@@ -33,6 +33,7 @@
 #endif
 
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
 
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>

--=-ZtsrFCLGdz6Bwra/8l5d--

