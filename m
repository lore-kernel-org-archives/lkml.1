Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbXFUTPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbXFUTPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbXFUTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:15:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29634 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbXFUTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=QFsnWz4mZ7U4WBCzT3Qg9j7kyJhM32HoTo+FNarbOm0hRih7R6ok/EuozdCol3gogAf+d6li0fLkW0jhdy4lqgwj+HOuMDyKEEPdGoBb9bRZLw0FSHqxK//hiTocSkYZS3BTLOQPjjNIGuZBoQ75Gs/cTJZLcFISiGXuVd8gKUs=
Message-ID: <467ACE57.2010400@gmail.com>
Date: Thu, 21 Jun 2007 23:15:35 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Rudolf Marek <r.marek@assembler.cz>
CC: Luca Tettamanti <kronos.it@gmail.com>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
References: <20070513223329.GA29207@dreamland.darkstar.lan> <46520F36.4080006@assembler.cz> <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com> <46528B6F.3050701@assembler.cz> <20070602222829.GA11893@dreamland.darkstar.lan> <467ACB2A.4070707@assembler.cz>
In-Reply-To: <467ACB2A.4070707@assembler.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------060705040902060108020201"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705040902060108020201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I think you might be interested in following patch, which implements _ACPI_ driver for the same hardware...
It is only "proof of concept" at the moment, but it does main thing -- reads hwmon device using ACPI interfaces.

Regards,
Alex.

Rudolf Marek wrote:
> Hi again,
> 
> Of course it is not there because I removed it myself :/ The "sensors"
> command will just produce "general parse error" this is because of the
> unknown device class (imho). So I removed that and forgot. Well now I
> have the sysfs files:
> 
> /sys/class/hwmon/hwmon2/device/:
> bus         fan0_min    fan2_input  fan3_label    in0_input  in1_label 
> in2_max    in3_min    temp0_crit   temp1_input
> driver      fan1_input  fan2_label  fan3_max      in0_label  in1_max   
> in2_min    name       temp0_input  temp1_label
> fan0_input  fan1_label  fan2_max    fan3_min      in0_max    in1_min
> in3_input  path       temp0_label  temp1_max
> fan0_label  fan1_max    fan2_min    hid           in0_min    in2_input
> in3_label  power      temp0_max    uevent
> fan0_max    fan1_min    fan3_input  hwmon:hwmon2  in1_input  in2_label 
> in3_max    subsystem  temp1_crit
> 
> 
> Please note that in kernelsrc/Documentation/hwmon/sysfs-interface
> is defined the interface. We have fans starting from 1 and not 0
> Also temperatures are in milidegrees. So your 3200 should be 32000.
> Temps file starts also from 1 and not 0. (so no temp0...)
> 
> Please can you fix this issues? I will do the review later once this
> things are fixed. Values seems to match.
> 
> Thanks,
> Rudolf
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------060705040902060108020201
Content-Type: text/x-patch;
 name="asoc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="asoc.patch"

ASOC

From: Alexey Starikovskiy <aystarik@gmail.com>


---

 drivers/acpi/Makefile |    1 
 drivers/acpi/asoc.c   |  154 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index d4336f1..0e61225 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -60,3 +60,4 @@ obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
 obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= acpi_memhotplug.o
 obj-y				+= cm_sbs.o
 obj-$(CONFIG_ACPI_SBS)		+= sbs.o
+obj-m				+= asoc.o
diff --git a/drivers/acpi/asoc.c b/drivers/acpi/asoc.c
new file mode 100644
index 0000000..996ca9e
--- /dev/null
+++ b/drivers/acpi/asoc.c
@@ -0,0 +1,154 @@
+/*
+ *  acpi_ac.c - ACPI ASUS hwmon driver
+ *
+ *  Copyright (C) 2007 Alexey Starikovskiy <astarikovskiy@suse.de>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+
+
+MODULE_AUTHOR("Alexey Starikovskiy");
+MODULE_DESCRIPTION("ACPI ASUS hwmon Driver");
+MODULE_LICENSE("GPL");
+
+static int acpi_asoc_add(struct acpi_device *device);
+static int acpi_asoc_remove(struct acpi_device *device, int type);
+
+static struct acpi_driver acpi_asoc_driver = {
+	.name = "asoc",
+	.class = "ACPI ASUS hwmon",
+	.ids = "ATK0110",
+	.ops = {
+		.add = acpi_asoc_add,
+		.remove = acpi_asoc_remove,
+		},
+};
+
+struct acpi_asoc {
+	struct acpi_device * device;
+};
+
+static acpi_status asoc_read_sif(struct acpi_device *device, char prefix)
+{
+	int i, ret = 0;
+	unsigned long value;
+	acpi_status status = 0;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer buffer2 = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *fsif = NULL;
+	union acpi_object *fdesc = NULL;
+	union acpi_object arg = {.type = ACPI_TYPE_INTEGER};
+	struct acpi_object_list arglist = {.count = 1, .pointer = &arg};
+	char name[5];
+
+	snprintf(name, 5, "%cSIF", prefix);
+	status = acpi_evaluate_object(device->handle, name, NULL, &buffer);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_ERR PREFIX "Evaluating %s failed, status = %d\n", name, (int)status);
+		return -ENODEV;
+	}
+
+	fsif = buffer.pointer;
+	if (!fsif || (fsif->type != ACPI_TYPE_PACKAGE) || (!fsif->package.count)) {
+		printk(KERN_ERR PREFIX "Invalid data\n");
+		ret = -EFAULT;
+		goto error;
+	}
+	for (i = 1; i < fsif->package.count; ++i) {
+		status = acpi_evaluate_object(fsif->package.elements[i].reference.handle, NULL, NULL, &buffer2);
+		if (ACPI_FAILURE(status)) {
+			printk("element evaluation failed, status = %d\n", (int)status);
+			ret = -EFAULT;
+			goto error;
+		}
+		fdesc = buffer2.pointer;
+		snprintf(name, 5, "%cGET", prefix);
+		arg.integer.value = i - 1;
+		status = acpi_evaluate_integer(device->handle, name, &arglist, &value);
+		if (ACPI_FAILURE(status)) {
+			printk("%s evaluation failed, status = %d\n", name, (int)status);
+			ret = -EFAULT;
+			kfree(buffer2.pointer);
+			goto error;
+		}
+		printk(KERN_INFO PREFIX "\"%s\" [%d,%d] = %ld\n",
+			fdesc->package.elements[1].string.pointer,
+			(int)fdesc->package.elements[2].integer.value,
+			(int)fdesc->package.elements[3].integer.value,
+			value);
+		kfree(fdesc);
+		buffer2.pointer = NULL;
+		buffer2.length = ACPI_ALLOCATE_BUFFER;
+	}
+error:
+	kfree(buffer.pointer);
+	return ret;
+}
+
+static int acpi_asoc_add(struct acpi_device *device)
+{
+	int i, result = 0;
+	acpi_status status = AE_OK;
+	struct acpi_ac *ac = NULL;
+	char prefix[] = {'V', 'T', 'F'};
+
+	if (!device)
+		return -EINVAL;
+	for (i = 0; i < 3; ++i) {
+		result = asoc_read_sif(device, prefix[i]);
+		if (result)
+			return result;
+	}
+	return result;
+}
+
+static int acpi_asoc_remove(struct acpi_device *device, int type)
+{
+	acpi_status status = AE_OK;
+
+	if (!device)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __init acpi_asoc_init(void)
+{
+	if (acpi_disabled)
+		return -ENODEV;
+	acpi_bus_register_driver(&acpi_asoc_driver);
+	return 0;
+}
+
+static void __exit acpi_asoc_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_asoc_driver);
+}
+
+module_init(acpi_asoc_init);
+module_exit(acpi_asoc_exit);

--------------060705040902060108020201--
