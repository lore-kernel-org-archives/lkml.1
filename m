Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbZFKWDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbZFKWDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbZFKWDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:03:08 -0400
Received: from main.gmane.org ([80.91.229.2]:48526 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761044AbZFKWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:03:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Subject: Re: [PATCH] hwmon: Add driver for VIA CPU core temperature
Date: Thu, 11 Jun 2009 22:02:58 +0000 (UTC)
Message-ID: <loom.20090611T215551-336@post.gmane.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org> <loom.20090610T172830-164@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 84.20.248.126 (Opera/9.64 (Windows NT 5.1; U; en) Presto/2.1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomaz Mertelj <tomaz.mertelj <at> guest.arnes.si> writes:

> 
> Harald,
> 
> I tested it on 2.6.28.3 kernel on VIA VB7002 motherboard and it does not work 
> correctly.
> 


Multiplication of the output temperature by 1000 is necessary. 
Here is a modified 
patch.

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index d73f5f4..e863833 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -787,6 +787,14 @@ config SENSORS_THMC50
 	  This driver can also be built as a module.  If so, the module
 	  will be called thmc50.

+config SENSORS_VIA_CPUTEMP
+	tristate "VIA CPU temperature sensor"
+	depends on X86
+	help
+	  If you say yes here you get support for the temperature
+	  sensor inside your CPU. Supported all are all known variants
+	  of the VIA C7 and Nano.
+
 config SENSORS_VIA686A
 	tristate "VIA686A"
 	depends on PCI
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 0ae2698..3edf7fa 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
 obj-$(CONFIG_SENSORS_SMSC47M1)	+= smsc47m1.o
 obj-$(CONFIG_SENSORS_SMSC47M192)+= smsc47m192.o
 obj-$(CONFIG_SENSORS_THMC50)	+= thmc50.o
+obj-$(CONFIG_SENSORS_VIA_CPUTEMP)+= via-cputemp.o
 obj-$(CONFIG_SENSORS_VIA686A)	+= via686a.o
 obj-$(CONFIG_SENSORS_VT1211)	+= vt1211.o
 obj-$(CONFIG_SENSORS_VT8231)	+= vt8231.o
diff --git a/drivers/hwmon/via-cputemp.c b/drivers/hwmon/via-cputemp.c
new file mode 100644
index 0000000..1032355
--- /dev/null
+++ b/drivers/hwmon/via-cputemp.c
@@ -0,0 +1,354 @@
+/*
+ * via-cputemp.c - Driver for VIA CPU core temperature monitoring
+ * Copyright (C) 2009 VIA Technologies, Inc.
+ *
+ * based on existing coretemp.c, which is
+ *
+ * Copyright (C) 2007 Rudolf Marek <r.marek <at> assembler.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301 USA.
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <linux/hwmon.h>
+#include <linux/sysfs.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/platform_device.h>
+#include <linux/cpu.h>
+#include <asm/msr.h>
+#include <asm/processor.h>
+
+#define DRVNAME	"via-cputemp"
+
+typedef enum { SHOW_TEMP, SHOW_LABEL, SHOW_NAME } SHOW;
+
+/*
+ * Functions declaration
+ */
+
+struct via_cputemp_data {
+	struct device *hwmon_dev;
+	const char *name;
+	u32 id;
+	u32 msr;
+};
+
+/*
+ * Sysfs stuff
+ */
+
+static ssize_t show_name(struct device *dev, struct device_attribute
+			  *devattr, char *buf)
+{
+	int ret;
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct via_cputemp_data *data = dev_get_drvdata(dev);
+
+	if (attr->index == SHOW_NAME)
+		ret = sprintf(buf, "%s\n", data->name);
+	else	/* show label */
+		ret = sprintf(buf, "Core %d\n", data->id);
+	return ret;
+}
+
+static ssize_t show_temp(struct device *dev,
+			 struct device_attribute *devattr, char *buf)
+{
+	struct via_cputemp_data *data = dev_get_drvdata(dev);
+	u32 eax, edx;
+	int err;
+
+	err = rdmsr_safe_on_cpu(data->id, data->msr, &eax, &edx);
+	if (err)
+		return -EAGAIN;
+
+	err = sprintf(buf, "%d\n", (eax & 0xffffff)*1000);
+
+	return err;
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL,
+			  SHOW_TEMP);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_name, NULL, SHOW_LABEL);
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, SHOW_NAME);
+
+static struct attribute *via_cputemp_attributes[] = {
+	&sensor_dev_attr_name.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group via_cputemp_group = {
+	.attrs = via_cputemp_attributes,
+};
+
+static int __devinit via_cputemp_probe(struct platform_device *pdev)
+{
+	struct via_cputemp_data *data;
+	struct cpuinfo_x86 *c = &cpu_data(pdev->id);
+	int err;
+	u32 eax, edx;
+
+	if (!(data = kzalloc(sizeof(struct via_cputemp_data), GFP_KERNEL))) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "Out of memory\n");
+		goto exit;
+	}
+
+	data->id = pdev->id;
+	data->name = "via-cputemp";
+
+	switch (c->x86_model) {
+	case 0xA:
+		/* C7 A */
+	case 0xD:
+		/* C7 D */
+		data->msr = 0x1169;
+		break;
+	case 0xF:
+		/* Nano */
+		data->msr = 0x1423;
+		break;
+	default:
+		err = -ENODEV;
+		goto exit_free;
+	}
+
+	/* test if we can access the TEMPERATURE MSR */
+	err = rdmsr_safe_on_cpu(data->id, data->msr, &eax, &edx);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Unable to access TEMPERATURE MSR, giving up\n");
+		goto exit_free;
+	}
+
+	platform_set_drvdata(pdev, data);
+
+	if ((err = sysfs_create_group(&pdev->dev.kobj, &via_cputemp_group)))
+		goto exit_free;
+
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		dev_err(&pdev->dev, "Class registration failed (%d)\n",
+			err);
+		goto exit_class;
+	}
+
+	return 0;
+
+exit_class:
+	sysfs_remove_group(&pdev->dev.kobj, &via_cputemp_group);
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int __devexit via_cputemp_remove(struct platform_device *pdev)
+{
+	struct via_cputemp_data *data = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &via_cputemp_group);
+	platform_set_drvdata(pdev, NULL);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver via_cputemp_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = DRVNAME,
+	},
+	.probe = via_cputemp_probe,
+	.remove = __devexit_p(via_cputemp_remove),
+};
+
+struct pdev_entry {
+	struct list_head list;
+	struct platform_device *pdev;
+	unsigned int cpu;
+};
+
+static LIST_HEAD(pdev_list);
+static DEFINE_MUTEX(pdev_list_mutex);
+
+static int __cpuinit via_cputemp_device_add(unsigned int cpu)
+{
+	int err;
+	struct platform_device *pdev;
+	struct pdev_entry *pdev_entry;
+
+	pdev = platform_device_alloc(DRVNAME, cpu);
+	if (!pdev) {
+		err = -ENOMEM;
+		printk(KERN_ERR DRVNAME ": Device allocation failed\n");
+		goto exit;
+	}
+
+	pdev_entry = kzalloc(sizeof(struct pdev_entry), GFP_KERNEL);
+	if (!pdev_entry) {
+		err = -ENOMEM;
+		goto exit_device_put;
+	}
+
+	err = platform_device_add(pdev);
+	if (err) {
+		printk(KERN_ERR DRVNAME ": Device addition failed (%d)\n",
+		       err);
+		goto exit_device_free;
+	}
+
+	pdev_entry->pdev = pdev;
+	pdev_entry->cpu = cpu;
+	mutex_lock(&pdev_list_mutex);
+	list_add_tail(&pdev_entry->list, &pdev_list);
+	mutex_unlock(&pdev_list_mutex);
+
+	return 0;
+
+exit_device_free:
+	kfree(pdev_entry);
+exit_device_put:
+	platform_device_put(pdev);
+exit:
+	return err;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+static void via_cputemp_device_remove(unsigned int cpu)
+{
+	struct pdev_entry *p, *n;
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		if (p->cpu == cpu) {
+			platform_device_unregister(p->pdev);
+			list_del(&p->list);
+			kfree(p);
+		}
+	}
+	mutex_unlock(&pdev_list_mutex);
+}
+
+static int __cpuinit via_cputemp_cpu_callback(struct notifier_block *nfb,
+				 unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long) hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		via_cputemp_device_add(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		via_cputemp_device_remove(cpu);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block via_cputemp_cpu_notifier __refdata = {
+	.notifier_call = via_cputemp_cpu_callback,
+};
+#endif				/* !CONFIG_HOTPLUG_CPU */
+
+static int __init via_cputemp_init(void)
+{
+	int i, err = -ENODEV;
+	struct pdev_entry *p, *n;
+
+	if (cpu_data(0).x86_vendor != X86_VENDOR_CENTAUR) {
+		printk(KERN_DEBUG "not a VIA CPU\n");
+		goto exit;
+	}
+
+	err = platform_driver_register(&via_cputemp_driver);
+	if (err)
+		goto exit;
+
+	for_each_online_cpu(i) {
+		struct cpuinfo_x86 *c = &cpu_data(i);
+
+		if (c->x86 != 6)
+			continue;
+
+		if (c->x86_model < 0x0a)
+			continue;
+
+		if (c->x86_model > 0x0f) {
+			printk(KERN_WARNING DRVNAME ": Unknown CPU "
+				"model %x\n", c->x86_model);
+			continue;
+		}
+
+		err = via_cputemp_device_add(i);
+		if (err)
+			goto exit_devices_unreg;
+	}
+	if (list_empty(&pdev_list)) {
+		err = -ENODEV;
+		goto exit_driver_unreg;
+	}
+
+#ifdef CONFIG_HOTPLUG_CPU
+	register_hotcpu_notifier(&via_cputemp_cpu_notifier);
+#endif
+	return 0;
+
+exit_devices_unreg:
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		kfree(p);
+	}
+	mutex_unlock(&pdev_list_mutex);
+exit_driver_unreg:
+	platform_driver_unregister(&via_cputemp_driver);
+exit:
+	return err;
+}
+
+static void __exit via_cputemp_exit(void)
+{
+	struct pdev_entry *p, *n;
+#ifdef CONFIG_HOTPLUG_CPU
+	unregister_hotcpu_notifier(&via_cputemp_cpu_notifier);
+#endif
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		kfree(p);
+	}
+	mutex_unlock(&pdev_list_mutex);
+	platform_driver_unregister(&via_cputemp_driver);
+}
+
+MODULE_AUTHOR("Harald Welte <HaraldWelte <at> viatech.com>");
+MODULE_DESCRIPTION("VIA CPU temperature monitor");
+MODULE_LICENSE("GPL");
+
+module_init(via_cputemp_init)
+module_exit(via_cputemp_exit)



