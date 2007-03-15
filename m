Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbXCOLj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbXCOLj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbXCOLj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:39:28 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:46427 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933470AbXCOLj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:39:26 -0400
Message-ID: <45F92D99.1020007@boichat.ch>
Date: Thu, 15 Mar 2007 19:27:21 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, debian-user@lists.debian.org,
       bytes@linuxgazette.net, Rudolf Marek <r.marek@assembler.cz>
Subject: Re: Intel Core Duo/Solo Temperature Monitoring Working On Intel DG965
 Motherboard
References: <Pine.LNX.4.64.0703100707320.3807@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0703100707320.3807@p34.internal.lan>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.191.155 (nusnet-191-155.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Justin Piszcz wrote:
> DISCLAIMER: This patch is still experimental. AUTHOR: Rudolf Marek has
> written the coretemp module for Intel Core Duo/Solo
> processors.
>
> Without this patch, you cannot monitor your CPU temperature, at least
> not on a DG965 motherboard.
[snip]
> Commentary:
> It will probably be a few weeks until this is incorporated into Linus'
> tree, hopefully it can make it into 2.6.22, then userland support
> should follow over time.
>
I ported this patch to the latest git, I hope this can help to get it
merged.

I'm just wondering if it is right to export the functions msr_read and
msr_write from arch/i386/kernel/msr.c, or if it would be better to put
these functions in arch/i386/lib/msr-on-cpu.c with rdmsr_on_cpu and
wrmsr_on_cpu.

Note the difference between msr_read/msr_write and
rdmsr_on_cpu/wrmsr_on_cpu is that msr_read/msr_write use "safe" rdmsr
/wrmsr functions (i.e. test return value), while
rdmsr_on_cpu/wrmsr_on_cpu does not. Coretemp needs the return value to
work properly.

Best regards,

Nicolas

Intel Core Duo/Solo Temperature Monitoring driver.

Author: Rudolf Marek <r.marek@assembler.cz>
---

 Documentation/hwmon/coretemp |   37 ++++
 arch/i386/kernel/msr.c       |   31 ++-
 drivers/hwmon/Kconfig        |    9 +
 drivers/hwmon/Makefile       |    1 
 drivers/hwmon/coretemp.c     |  400 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/msr.h       |    3 
 include/asm-x86_64/msr.h     |    3 
 7 files changed, 470 insertions(+), 14 deletions(-)

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
new file mode 100644
index 0000000..ba02dee
--- /dev/null
+++ b/Documentation/hwmon/coretemp
@@ -0,0 +1,37 @@
+Kernel driver coretemp
+======================
+
+Supported chips:
+  * All Intel Core family
+    Prefix: 'coretemp'
+    Addresses scanned: CPUID (family 0x6, models 0xe, 0xf)
+    Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
+               Volume 3A: System Programming Guide
+
+Author: Rudolf Marek
+Contact: Rudolf Marek <r.marek@assembler.cz>
+
+Description
+-----------
+
+This driver permits reading temperature sensor embedded inside Intel Core CPU.
+Temperature is measured in degrees Celsius and measurement resolution is
+1 degree C. Valid temperatures are from 0 to TjMax degrees C, because
+the actual temperature is in fact a delta from TjMax.
+
+Temperature known as TjMax is the maximum junction temperature of processor.
+Intel defines this temperature as 85C or 100C. At this temperature, protection
+mechanism will perform actions to forcibly cool down the processor. Alarm
+may be raised, if the temperature grows enough (more than TjMax) to trigger
+the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
+
+temp1_input	 - Core temperature (in milidegrees of Celsius).
+temp1_crit	 - Maximum junction temperature  (in milidegrees of Celsius).
+temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
+		   Correct CPU operation is no longer guaranteed.
+temp1_label	 - Contains string with the "Core X", where X is processor
+		   number.
+
+The TjMax temperature is set to 85C if undocumented model specific register
+(UMSR) 0xee has bit 30 set. If not the TjMax is 100C as documented in processor
+datasheet. Intel will not disclose this information to individuals.
diff --git a/arch/i386/kernel/msr.c b/arch/i386/kernel/msr.c
index bcaa6e9..c9a8f88 100644
--- a/arch/i386/kernel/msr.c
+++ b/arch/i386/kernel/msr.c
@@ -87,7 +87,7 @@ static void msr_smp_rdmsr(void *cmd_block)
 	cmd->err = rdmsr_eio(cmd->reg, &cmd->data[0], &cmd->data[1]);
 }
 
-static inline int do_wrmsr(int cpu, u32 reg, u32 eax, u32 edx)
+int msr_write(int cpu, u32 reg, u32 eax, u32 edx)
 {
 	struct msr_command cmd;
 	int ret;
@@ -107,7 +107,7 @@ static inline int do_wrmsr(int cpu, u32 reg, u32 eax, u32 edx)
 	return ret;
 }
 
-static inline int do_rdmsr(int cpu, u32 reg, u32 * eax, u32 * edx)
+int msr_read(int cpu, u32 reg, u32 * eax, u32 * edx)
 {
 	struct msr_command cmd;
 	int ret;
@@ -131,19 +131,22 @@ static inline int do_rdmsr(int cpu, u32 reg, u32 * eax, u32 * edx)
 
 #else				/* ! CONFIG_SMP */
 
-static inline int do_wrmsr(int cpu, u32 reg, u32 eax, u32 edx)
+int msr_write(int cpu, u32 reg, u32 eax, u32 edx)
 {
 	return wrmsr_eio(reg, eax, edx);
 }
 
-static inline int do_rdmsr(int cpu, u32 reg, u32 *eax, u32 *edx)
+int msr_read(int cpu, u32 reg, u32 *eax, u32 *edx)
 {
 	return rdmsr_eio(reg, eax, edx);
 }
 
 #endif				/* ! CONFIG_SMP */
 
-static loff_t msr_seek(struct file *file, loff_t offset, int orig)
+EXPORT_SYMBOL_GPL(msr_write);
+EXPORT_SYMBOL_GPL(msr_read);
+
+static loff_t msr_fseek(struct file *file, loff_t offset, int orig)
 {
 	loff_t ret = -EINVAL;
 
@@ -161,7 +164,7 @@ static loff_t msr_seek(struct file *file, loff_t offset, int orig)
 	return ret;
 }
 
-static ssize_t msr_read(struct file *file, char __user * buf,
+static ssize_t msr_fread(struct file *file, char __user * buf,
 			size_t count, loff_t * ppos)
 {
 	u32 __user *tmp = (u32 __user *) buf;
@@ -174,7 +177,7 @@ static ssize_t msr_read(struct file *file, char __user * buf,
 		return -EINVAL;	/* Invalid chunk size */
 
 	for (; count; count -= 8) {
-		err = do_rdmsr(cpu, reg, &data[0], &data[1]);
+		err = msr_read(cpu, reg, &data[0], &data[1]);
 		if (err)
 			return err;
 		if (copy_to_user(tmp, &data, 8))
@@ -185,7 +188,7 @@ static ssize_t msr_read(struct file *file, char __user * buf,
 	return ((char __user *)tmp) - buf;
 }
 
-static ssize_t msr_write(struct file *file, const char __user *buf,
+static ssize_t msr_fwrite(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	const u32 __user *tmp = (const u32 __user *)buf;
@@ -200,7 +203,7 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	for (; count; count -= 8) {
 		if (copy_from_user(&data, tmp, 8))
 			return -EFAULT;
-		err = do_wrmsr(cpu, reg, data[0], data[1]);
+		err = msr_write(cpu, reg, data[0], data[1]);
 		if (err)
 			return err;
 		tmp += 2;
@@ -209,7 +212,7 @@ static ssize_t msr_write(struct file *file, const char __user *buf,
 	return ((char __user *)tmp) - buf;
 }
 
-static int msr_open(struct inode *inode, struct file *file)
+static int msr_fopen(struct inode *inode, struct file *file)
 {
 	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
 	struct cpuinfo_x86 *c = &(cpu_data)[cpu];
@@ -227,10 +230,10 @@ static int msr_open(struct inode *inode, struct file *file)
  */
 static const struct file_operations msr_fops = {
 	.owner = THIS_MODULE,
-	.llseek = msr_seek,
-	.read = msr_read,
-	.write = msr_write,
-	.open = msr_open,
+	.llseek = msr_fseek,
+	.read = msr_fread,
+	.write = msr_fwrite,
+	.open = msr_fopen,
 };
 
 static int msr_device_create(int i)
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index c3d4856..707e727 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -167,6 +167,15 @@ config SENSORS_ATXP1
 	  This driver can also be built as a module.  If so, the module
 	  will be called atxp1.
 
+config SENSORS_CORETEMP
+	tristate "Intel Core (2) Duo/Solo temperature sensor"
+	depends on HWMON && X86 && EXPERIMENTAL
+	select X86_MSR
+	help
+	  If you say yes here you get support for the temperature
+	  sensor inside your CPU. Supported all are all known variants
+	  of Intel Core family.
+
 config SENSORS_DS1621
 	tristate "Dallas Semiconductor DS1621 and DS1625"
 	depends on HWMON && I2C
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 4165c27..0c1cf01 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SENSORS_ADM1031)	+= adm1031.o
 obj-$(CONFIG_SENSORS_ADM9240)	+= adm9240.o
 obj-$(CONFIG_SENSORS_AMS)	+= ams/
 obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
+obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
 obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
 obj-$(CONFIG_SENSORS_F71805F)	+= f71805f.o
 obj-$(CONFIG_SENSORS_FSCHER)	+= fscher.o
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
new file mode 100644
index 0000000..f139b41
--- /dev/null
+++ b/drivers/hwmon/coretemp.c
@@ -0,0 +1,400 @@
+/*
+ * coretemp.c - Linux kernel module for hardware monitoring
+ *
+ * Copyright (C) 2006 Rudolf Marek <r.marek@assembler.cz>
+ *
+ * Inspired from many hwmon drivers
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
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
+#include <asm/msr.h>
+#include <linux/cpu.h>
+
+#define DRVNAME		"coretemp"
+
+typedef enum { SHOW_TEMP, SHOW_TJMAX, SHOW_LABEL, SHOW_NAME } SHOW;
+
+/*
+ * Functions declaration
+ */
+
+static struct coretemp_data *coretemp_update_device(struct device *dev);
+
+struct coretemp_data {
+	struct class_device *class_dev;
+	struct mutex update_lock;
+	const char *name;
+	u32 id;
+	char valid;		/* zero until following fields are valid */
+	unsigned long last_updated;	/* in jiffies */
+	int temp;
+	int tjmax;
+	/* registers values */
+	u32 therm_status;
+};
+
+static struct coretemp_data *coretemp_update_device(struct device *dev);
+
+/*
+ * Sysfs stuff
+ */
+
+
+static ssize_t show_name(struct device *dev, struct device_attribute
+			  *devattr, char *buf)
+{
+	int ret;
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct coretemp_data *data = dev_get_drvdata(dev);
+
+	if (attr->index == SHOW_NAME)
+		ret = sprintf(buf, "%s\n", data->name);
+	else	/* show label */
+		ret = sprintf(buf, "Core %d\n", data->id);
+	return ret;
+}
+
+static ssize_t show_alarm(struct device *dev, struct device_attribute
+			  *devattr, char *buf)
+{
+	struct coretemp_data *data = coretemp_update_device(dev);
+	/* read the Out-of-spec log, never clear */
+	return sprintf(buf, "%d\n", (data->therm_status >> 5) & 1);
+}
+
+static ssize_t show_temp(struct device *dev,
+			 struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct coretemp_data *data = coretemp_update_device(dev);
+	return sprintf(buf, "%d\n",
+		       attr->index ==
+		       SHOW_TEMP ? data->temp : data->tjmax);
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL,
+			  SHOW_TEMP);
+static SENSOR_DEVICE_ATTR(temp1_crit, S_IRUGO, show_temp, NULL,
+			  SHOW_TJMAX);
+static DEVICE_ATTR(temp1_crit_alarm, S_IRUGO, show_alarm, NULL);
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_name, NULL, SHOW_LABEL);
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, SHOW_NAME);
+
+static struct attribute *coretemp_attributes[] = {
+	&sensor_dev_attr_name.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&dev_attr_temp1_crit_alarm.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_crit.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group coretemp_group = {
+	.attrs = coretemp_attributes,
+};
+
+static struct coretemp_data *coretemp_update_device(struct device *dev)
+{
+	struct coretemp_data *data = dev_get_drvdata(dev);
+
+	mutex_lock(&data->update_lock);
+
+	if (!data->valid || time_after(jiffies, data->last_updated + HZ)) {
+		u32 eax, edx;
+
+		data->valid = 0;
+		msr_read(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
+		data->therm_status = eax;
+
+		/* update only if data has been valid */
+		if (eax & 0x80000000) {
+			data->temp = data->tjmax - (((data->therm_status >> 16)
+							& 0x7f) * 1000);
+			data->valid = 1;
+		}
+		data->last_updated = jiffies;
+	}
+
+	mutex_unlock(&data->update_lock);
+	return data;
+}
+
+static int __devinit coretemp_probe(struct platform_device *pdev)
+{
+	struct coretemp_data *data;
+	struct cpuinfo_x86 *c = &(cpu_data)[pdev->id];
+	int err;
+	u32 eax, edx;
+
+	if (!(data = kzalloc(sizeof(struct coretemp_data), GFP_KERNEL))) {
+		err = -ENOMEM;
+		dev_err(&pdev->dev, "Out of memory\n");
+		goto exit;
+	}
+
+	data->id = pdev->id;
+	data->name = "coretemp";
+	mutex_init(&data->update_lock);
+	/* Tjmax default is 100C */
+	data->tjmax = 100000;
+
+	/* Some processors have Tjmax 85 following magic should detect it */
+	/* family is always 0x6 */
+
+	if (((c->x86_model == 0xf) && (c->x86_mask > 3 )) ||
+		(c->x86_model == 0xe))  {
+
+		err = msr_read(data->id, 0xee, &eax, &edx);
+		if (err) {
+			dev_warn(&pdev->dev,
+				 "Unable to access MSR 0xEE, Tjmax left at %d\n",
+				 data->tjmax);
+		} else if (eax & 0x40000000) {
+			data->tjmax = 85000;
+		}
+	}
+
+	/* test if we can access the THERM_STATUS MSR */
+	err = msr_read(data->id, MSR_IA32_THERM_STATUS, &eax, &edx);
+
+	if (err) {
+		dev_err(&pdev->dev,
+			"Unable to access THERM_STATUS MSR, giving up\n");
+		goto exit_free;
+	}
+	platform_set_drvdata(pdev, data);
+
+	if ((err = sysfs_create_group(&pdev->dev.kobj, &coretemp_group)))
+		goto exit_free;
+
+	data->class_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->class_dev)) {
+		err = PTR_ERR(data->class_dev);
+		dev_err(&pdev->dev, "Class registration failed (%d)\n",
+			err);
+		goto exit_class;
+	}
+
+	return 0;
+
+exit_class:
+	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int __devexit coretemp_remove(struct platform_device *pdev)
+{
+	struct coretemp_data *data = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(data->class_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &coretemp_group);
+	platform_set_drvdata(pdev, NULL);
+	kfree(data);
+	return 0;
+}
+
+static struct platform_driver coretemp_driver = {
+	.driver = {
+		   .owner = THIS_MODULE,
+		   .name = DRVNAME,
+		   },
+	.probe = coretemp_probe,
+	.remove = __devexit_p(coretemp_remove),
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
+static int __cpuinit coretemp_devices_add(unsigned int cpu)
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
+
+	}
+
+	pdev_entry = kzalloc(sizeof(struct pdev_entry), GFP_KERNEL);
+
+	if (!pdev_entry) {
+		err = -ENOMEM;
+		goto exit_device_put;
+	}
+
+	err = platform_device_add(pdev);
+
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
+void coretemp_devices_remove(unsigned int cpu)
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
+static int coretemp_cpu_callback(struct notifier_block *nfb,
+				 unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long) hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+		coretemp_devices_add(cpu);
+		break;
+	case CPU_DEAD:
+		coretemp_devices_remove(cpu);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata coretemp_cpu_notifier = {
+	.notifier_call = coretemp_cpu_callback,
+};
+#endif				/* !CONFIG_HOTPLUG_CPU */
+
+static int __init coretemp_init(void)
+{
+	int i, err = -ENODEV;
+	struct pdev_entry *p, *n;
+
+	if (current_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		goto exit;
+
+	err = platform_driver_register(&coretemp_driver);
+	if (err)
+		goto exit;
+
+	for_each_online_cpu(i) {
+		struct cpuinfo_x86 *c = &(cpu_data)[i];
+
+		/* check if family 6, models e, f */
+		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
+		    !((c->x86_model == 0xe) || (c->x86_model == 0xf))) {
+
+			/* supported CPU not found, but report the unknown
+			   family 6 CPU */
+			if ((c->x86 == 0x6) && (c->x86_model > 0xf))
+				printk(KERN_WARNING DRVNAME ": Unknown CPU, please"
+ 			   " report to the lm-sensors@lm-sensors.org\n");
+			continue;
+		}
+
+		err = coretemp_devices_add(i);
+		if (err)
+			goto exit_driver;
+	}
+	if (list_empty(&pdev_list)) {
+		err = -ENODEV;
+		goto exit_driver_unreg;
+	}
+
+#ifdef CONFIG_HOTPLUG_CPU
+	register_hotcpu_notifier(&coretemp_cpu_notifier);
+#endif
+	return 0;
+
+exit_driver:
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		kfree(p);
+	}
+	mutex_unlock(&pdev_list_mutex);
+exit_driver_unreg:
+	platform_driver_unregister(&coretemp_driver);
+exit:
+	return err;
+}
+
+static void __exit coretemp_exit(void)
+{
+	struct pdev_entry *p, *n;
+#ifdef CONFIG_HOTPLUG_CPU
+	unregister_hotcpu_notifier(&coretemp_cpu_notifier);
+#endif
+	mutex_lock(&pdev_list_mutex);
+	list_for_each_entry_safe(p, n, &pdev_list, list) {
+		platform_device_unregister(p->pdev);
+		list_del(&p->list);
+		kfree(p);
+	}
+	mutex_unlock(&pdev_list_mutex);
+	platform_driver_unregister(&coretemp_driver);
+}
+
+MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
+MODULE_DESCRIPTION("Intel Core temperature monitor");
+MODULE_LICENSE("GPL");
+
+module_init(coretemp_init)
+module_exit(coretemp_exit)
diff --git a/include/asm-i386/msr.h b/include/asm-i386/msr.h
index ec3b680..ff73a99 100644
--- a/include/asm-i386/msr.h
+++ b/include/asm-i386/msr.h
@@ -97,6 +97,9 @@ static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 }
 #endif  /*  CONFIG_SMP  */
 
+int msr_write(int cpu, u32 reg, u32 eax, u32 edx);
+int msr_read(int cpu, u32 reg, u32 *eax, u32 *edx);
+
 /* symbolic names for some interesting MSRs */
 /* Intel defined MSRs. */
 #define MSR_IA32_P5_MC_ADDR		0
diff --git a/include/asm-x86_64/msr.h b/include/asm-x86_64/msr.h
index 902f9a5..90662f4 100644
--- a/include/asm-x86_64/msr.h
+++ b/include/asm-x86_64/msr.h
@@ -160,6 +160,9 @@ static inline unsigned int cpuid_edx(unsigned int op)
 #define MSR_IA32_UCODE_WRITE		0x79
 #define MSR_IA32_UCODE_REV		0x8b
 
+int msr_write(int cpu, u32 reg, u32 eax, u32 edx);
+int msr_read(int cpu, u32 reg, u32 *eax, u32 *edx);
+
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);


