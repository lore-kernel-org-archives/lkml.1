Return-Path: <linux-kernel-owner+w=401wt.eu-S1762787AbYBZRP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762787AbYBZRP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYBZRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:15:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56790 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYBZRPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:15:49 -0500
Date: Tue, 26 Feb 2008 11:26:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: [demo patch/RFC] sleepy linux
Message-ID: <20080226102652.GA1830@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sleepy linux support, demo version, but it works on my thinkpad x60 ;-).

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/power/sleepy.txt b/Documentation/power/sleepy.txt
new file mode 100644
index 0000000..a9caf05
--- /dev/null
+++ b/Documentation/power/sleepy.txt
@@ -0,0 +1,55 @@
+		Sleepy Linux
+		~~~~~~~~~~~~
+
+Copyright 2007 Pavel Machek <pavel@suse.cz>
+	  GPLv2
+
+Current Linux versions can enter suspend-to-RAM just fine, but only
+can do it on explicit request. But suspend-to-RAM is important, eating
+something like 10% of power needed for idle system. Starting suspend
+manually is not too convinient; it is not an option on multiuser
+machine, and even on single user machine, some things are not easy:
+
+1) Download this big chunk in mozilla, then go to sleep
+
+2) Compile this, then go to sleep
+
+3) You can sleep now, but wake me up in 8:30 with mp3 player
+
+Todays hardware is mostly capable of doing better: with correctly set
+up wakeups, machine can sleep and successfully pretend it is not
+sleeping -- by waking up whenever something interesting happens. Of
+course, it is easier on machines not connected to the network, and on
+notebook computers.
+
+Requirements:
+
+0) Working suspend-to-RAM, with kernel being able to bring video back.
+
+1) RTC clock that can wake up system
+
+2) Lid that can wake up a system,
+   or keyboard that can wake up system and does not loose keypress
+   or special screensaver setup
+
+3) Network card that is either down
+   or can wake up system on any packet (and not loose too many packets)
+
+How to use it
+~~~~~~~~~~~~~
+
+First, make sure your config is tiny enough that cpu sleeps at least
+five or so seconds between wakeups. You'll probably need to disable
+USB, make some kernel timers way longer than default and boot with
+init=/bin/bash.
+
+Then, enable SCSI powersave by something like:
+
+mount /sys
+echo auto > /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/power/level
+echo 3 > /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/power/autosuspend
+echo adisk > /sys/power/state
+mount / -oremount,commit=900
+
+Then, echo auto > /sys/power/state should enable sleepy support. Do it
+twice, and it will ignore open lid and sleep anyway.
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a7d50a5..4c25613 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -187,6 +187,7 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick();
+		detect_idle();
 		while (!need_resched()) {
 			void (*idle)(void);
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 29e71bd..0197b1f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -32,6 +32,7 @@
  *
  */
 
+#define DEBUG
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -259,8 +260,8 @@ static void ahci_fill_cmd_slot(struct ah
 			       u32 opts);
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
-static int ahci_pci_device_resume(struct pci_dev *pdev);
+int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
 static struct class_device_attribute *ahci_shost_attrs[] = {
@@ -268,6 +269,41 @@ static struct class_device_attribute *ah
 	NULL
 };
 
+struct pci_dev *my_pdev;
+int autosuspend_enabled;
+
+struct sleep_disabled_reason ahci_active = {
+        "ahci"
+};
+
+/* The host and its devices are all idle so we can autosuspend */
+static int autosuspend(struct Scsi_Host *host)
+{
+	if (my_pdev && autosuspend_enabled) {
+		printk("ahci: should autosuspend\n");
+		ahci_pci_device_suspend(my_pdev, PMSG_SUSPEND);
+		enable_auto_sleep(&ahci_active);
+		return 0;
+	} 
+	printk("ahci: autosuspend disabled\n");
+	return -EINVAL;
+}
+
+/* The host needs to be autoresumed */
+static int autoresume(struct Scsi_Host *host)
+{
+	if (my_pdev && autosuspend_enabled) {
+		printk("ahci: should autoresume\n");
+		disable_auto_sleep(&ahci_active);
+		ahci_pci_device_resume(my_pdev);
+		return 0;
+	}
+	printk("ahci: autoresume disabled\n");
+	return -EINVAL;
+}
+
+
+
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -286,6 +322,8 @@ static struct scsi_host_template ahci_sh
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 	.shost_attrs		= ahci_shost_attrs,
+	.autosuspend		= autosuspend,
+	.autoresume		= autoresume,
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -1820,6 +1858,10 @@ static void ahci_thaw(struct ata_port *a
 
 static void ahci_error_handler(struct ata_port *ap)
 {
+	struct ata_host *host = ap->host;
+	int rc;
+	extern int slept;
+
 	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
 		/* restart engine */
 		ahci_stop_engine(ap);
@@ -1926,13 +1968,16 @@ static int ahci_port_suspend(struct ata_
 	return rc;
 }
 
-static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
+int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	u32 ctl;
+	int ret;
 
-	if (mesg.event == PM_EVENT_SUSPEND) {
+	printk("sleepy: ahci_pci_device_suspend start\n");
+	if (mesg.event == PM_EVENT_SUSPEND
+	    || mesg.event == PM_EVENT_HIBERNATE) {
 		/* AHCI spec rev1.1 section 8.3.3:
 		 * Software must disable interrupts prior to requesting a
 		 * transition of the HBA to D3 state.
@@ -1943,28 +1988,38 @@ static int ahci_pci_device_suspend(struc
 		readl(mmio + HOST_CTL); /* flush */
 	}
 
-	return ata_pci_device_suspend(pdev, mesg);
+	ret = ata_pci_device_suspend(pdev, mesg);
+	printk("sleepy: ahci_pci_device_suspend done\n");
+	return ret;
 }
 
-static int ahci_pci_device_resume(struct pci_dev *pdev)
+
+int ahci_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	int rc;
 
+	printk("sleepy: ahci_pci_device_resume start\n");
 	rc = ata_pci_device_do_resume(pdev);
+	printk("do_resume done\n");
 	if (rc)
 		return rc;
 
-	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
+	if (1) {
+		printk("reset_controller\n");
 		rc = ahci_reset_controller(host);
 		if (rc)
 			return rc;
 
+		printk("init_controller\n");
 		ahci_init_controller(host);
 	}
 
+	printk("ata_host_resume\n");
 	ata_host_resume(host);
 
+	printk("all ok\n");
+	printk("sleepy: ahci_pci_device_resume done\n");
 	return 0;
 }
 #endif
@@ -2189,6 +2244,7 @@ static void ahci_p5wdh_workaround(struct
 	}
 }
 
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2300,8 +2356,12 @@ static int ahci_init_one(struct pci_dev 
 	ahci_print_info(host);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
+
+	rc = ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_sht);
+	pci_save_state(pdev);
+	my_pdev = pdev;
+	return rc;
 }
 
 static int __init ahci_init(void)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index beaa3a9..ee77dc9 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -782,6 +782,7 @@ void ata_lpm_schedule(struct ata_port *a
 }
 
 #ifdef CONFIG_PM
+/* This disables link power management */
 static void ata_lpm_enable(struct ata_host *host)
 {
 	struct ata_link *link;
@@ -798,6 +799,7 @@ static void ata_lpm_enable(struct ata_ho
 	}
 }
 
+/* This enables link power management */
 static void ata_lpm_disable(struct ata_host *host)
 {
 	int i;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 4e31071..5c40ac2 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -32,6 +32,7 @@
  *
  */
 
+#define DEBUG
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <scsi/scsi.h>
@@ -380,7 +381,7 @@ enum scsi_eh_timer_return ata_scsi_timed
  *	Inherited from SCSI layer (none, can sleep)
  *
  *	RETURNS:
- *	Zero.
+ *	Nothing.
  */
 void ata_scsi_error(struct Scsi_Host *host)
 {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1cea18f..62b3ee0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -33,6 +33,7 @@
  *
  */
 
+#define DEBUG
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bdc03f7..268855d 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -19,6 +19,7 @@
  * ancestral dependencies that the subsystem list maintains.
  */
 
+#define DEBUG
 #include <linux/device.h>
 #include <linux/kallsyms.h>
 #include <linux/mutex.h>
@@ -319,6 +320,7 @@ static void unregister_dropped_devices(v
  *
  *	Resume all the devices, unlock them all, and allow new
  *	devices to be registered once again.
+ *	Called with interrupts disabled, may not sleep.
  */
 void device_resume(void)
 {
@@ -419,11 +421,6 @@ int suspend_device(struct device *dev, p
 {
 	int error = 0;
 
-	if (dev->power.power_state.event) {
-		dev_dbg(dev, "PM: suspend %d-->%d\n",
-			dev->power.power_state.event, state.event);
-	}
-
 	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
@@ -444,6 +441,34 @@ int suspend_device(struct device *dev, p
 	return error;
 }
 
+int device_suspend_fake(pm_message_t state)
+{
+	int error = 0;
+
+	mutex_lock(&dpm_list_mtx);
+	while (!list_empty(&dpm_active) && error == 0) {
+		struct list_head * entry = dpm_active.prev;
+		struct device * dev = to_device(entry);
+
+		get_device(dev);
+
+		/* Check if the device got removed */
+		if (!list_empty(&dev->power.entry)) {
+			/* Move it to the dpm_off list */
+			if (!error)
+				list_move(&dev->power.entry, &dpm_off);
+		}
+		if (error)
+			printk(KERN_ERR "Could not suspend device %s: "
+				"error %d%s\n",
+				kobject_name(&dev->kobj), error,
+				error == -EAGAIN ? " (please convert to suspend_late)" : "");
+		put_device(dev);
+	}
+	mutex_unlock(&dpm_list_mtx);
+	return error;
+}
+
 /**
  *	dpm_suspend - Suspend every device.
  *	@state:	Power state to put each device in.
@@ -496,6 +521,8 @@ static int dpm_suspend(pm_message_t stat
  *
  *	Go through the dpm_active list. Carefully lock each device's
  *	semaphore and put it in on the dpm_locked list.
+ *
+ *	Must be called with disabled interrupts, may not sleep.
  */
 static void lock_all_devices(void)
 {
diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 490918a..ed2bdf2 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -153,7 +153,7 @@ int input_register_polled_device(struct 
 
 	INIT_DELAYED_WORK(&dev->work, input_polled_device_work);
 	if (!dev->poll_interval)
-		dev->poll_interval = 500;
+		dev->poll_interval = 50000;
 	input->private = dev;
 	input->open = input_open_polled_device;
 	input->close = input_close_polled_device;
diff --git a/drivers/input/input.c b/drivers/input/input.c
index f02c242..7e9f46a 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -251,6 +251,11 @@ static void input_handle_event(struct in
 		input_pass_event(dev, type, code, value);
 }
 
+struct sleep_disabled_reason keyboard_active = {
+        "keyboard"
+};
+
+
 /**
  * input_event() - report new input event
  * @dev: device that generated the event
@@ -267,8 +272,14 @@ void input_event(struct input_dev *dev,
 {
 	unsigned long flags;
 
-	if (is_event_supported(type, dev->evbit, EV_MAX)) {
+	if ((type == EV_SW) && (code == SW_LID)) {
+		int is_closed = value;
+//		printk("LID: %d\n", value);
+		if (is_closed) enable_auto_sleep(&keyboard_active);
+		else disable_auto_sleep(&keyboard_active);
+	}
 
+	if (is_event_supported(type, dev->evbit, EV_MAX)) {
 		spin_lock_irqsave(&dev->event_lock, flags);
 		add_input_randomness(type, code, value);
 		input_handle_event(dev, type, code, value);
@@ -1646,6 +1657,8 @@ static int __init input_init(void)
 		goto fail2;
 	}
 
+	/* FIXME: should only inc it if LID is open */
+	disable_auto_sleep(&keyboard_active);
 	return 0;
 
  fail2:	input_proc_exit();
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index e059f94..fadf651 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -93,7 +93,7 @@ static inline int is_intr(u8 rtc_intr)
 
 /*----------------------------------------------------------------*/
 
-static int cmos_read_time(struct device *dev, struct rtc_time *t)
+int cmos_read_time(struct device *dev, struct rtc_time *t)
 {
 	/* REVISIT:  if the clock has a "century" register, use
 	 * that instead of the heuristic in get_rtc_time().
@@ -185,7 +185,7 @@ static int cmos_read_alarm(struct device
 	return 0;
 }
 
-static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	mon, mday, hrs, min, sec;
@@ -494,6 +494,35 @@ static struct bin_attribute nvram = {
 /*----------------------------------------------------------------*/
 
 static struct cmos_rtc	cmos_rtc;
+static struct device *pc_rtc_device;
+
+int set_alarm(int length)
+{
+	ssize_t retval;
+	unsigned long now, alarm;
+	struct rtc_wkalrm alm;
+
+	if (!pc_rtc_device)
+		return -EFAULT;
+	retval = cmos_read_time(pc_rtc_device, &alm.time);
+	if (retval < 0) {
+		printk("Auto sleep: can't get time?\n");
+		return retval;
+	}
+	rtc_tm_to_time(&alm.time, &now);
+	printk("Auto sleep: Now %ld\n", now);
+
+	alarm = now+length;
+	rtc_time_to_tm(alarm, &alm.time);
+
+	retval = cmos_set_alarm(pc_rtc_device, &alm);
+	if (retval < 0) {
+		printk("Auto sleep: can't set alarm.\n");
+		return retval;
+	}
+	printk("Auto sleep: Alarm set\n");
+	return 0;
+}
 
 static irqreturn_t cmos_interrupt(int irq, void *p)
 {
@@ -552,6 +581,8 @@ cmos_do_probe(struct device *dev, struct
 	if (cmos_rtc.dev)
 		return -EBUSY;
 
+	pc_rtc_device = dev;
+
 	if (!ports)
 		return -ENODEV;
 
@@ -712,7 +743,7 @@ cleanup0:
 
 static void cmos_do_shutdown(void)
 {
-	unsigned char	rtc_control;
+	unsigned char rtc_control;
 
 	spin_lock_irq(&rtc_lock);
 	rtc_control = CMOS_READ(RTC_CONTROL);
@@ -727,6 +758,7 @@ static void __exit cmos_do_remove(struct
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	struct resource *ports;
 
+	pc_rtc_device = NULL;
 	cmos_do_shutdown();
 
 	sysfs_remove_bin_file(&dev->kobj, &nvram);
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 4d27ccc..b0c609e 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -156,16 +156,6 @@ rtc_sysfs_set_wakealarm(struct device *d
 
 	alarm = simple_strtoul(buf, NULL, 0);
 	if (alarm > now) {
-		/* Avoid accidentally clobbering active alarms; we can't
-		 * entirely prevent that here, without even the minimal
-		 * locking from the /dev/rtcN api.
-		 */
-		retval = rtc_read_alarm(rtc, &alm);
-		if (retval < 0)
-			return retval;
-		if (alm.enabled)
-			return -EBUSY;
-
 		alm.enabled = 1;
 	} else {
 		alm.enabled = 0;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5393e15..25bebc1 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -340,6 +340,21 @@ static int scsi_bus_uevent(struct device
 	return 0;
 }
 
+static int scsi_bus_remove(struct device *dev)
+{
+	struct device_driver *drv = dev->driver;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int err = 0;
+
+	/* reset the prep_fn back to the default since the
+	 * driver may have altered it and it's being removed */
+	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
+
+	if (drv && drv->remove)
+		err = drv->remove(dev);
+
+	return 0;
+}
 
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 16add9a..9ca12d1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1596,6 +1596,8 @@ static int sd_revalidate_disk(struct gen
 	return 0;
 }
 
+struct device *my_scsi_disk; 
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -1715,6 +1717,7 @@ static int sd_probe(struct device *dev)
 
 	scsi_use_ULD_pm(sdp, 1);
 	scsi_autosuspend_device(sdp);
+	my_scsi_disk = dev;
 	return 0;
 
  out_suspend:
@@ -1835,6 +1838,8 @@ static int sd_suspend(struct device *dev
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
 
+	printk("sleepy: sd_suspend start\n");
+
 	if (!sdkp)
 		return 0;	/* this can happen */
 
@@ -1845,14 +1850,17 @@ static int sd_suspend(struct device *dev
 			goto done;
 	}
 
-	if (mesg.event == PM_EVENT_SUSPEND &&
-	    sdkp->device->manage_start_stop) {
+	if ((mesg.event == PM_EVENT_SUSPEND
+	     )
+	    && sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
 	}
 
 done:
 	scsi_disk_put(sdkp);
+
+	printk("sleepy: sd_suspend done\n");
 	return ret;
 }
 
@@ -1861,6 +1869,8 @@ static int sd_resume(struct device *dev)
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
 
+	printk("sleepy: sd_resume start\n");
+
 	if (!sdkp->device->manage_start_stop)
 		goto done;
 
@@ -1869,6 +1879,7 @@ static int sd_resume(struct device *dev)
 
 done:
 	scsi_disk_put(sdkp);
+	printk("sleepy: sd_resume done\n");
 	return ret;
 }
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 78bbaca..df2dd4f 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -298,6 +298,13 @@ enum {
 	SCR_ACTIVE		= 3,
 	SCR_NOTIFICATION	= 4,
 
+	/* SControl subfields, each field is 4 bit wide */
+	ATA_SCTL_DET		= 0, /* lsb */
+	ATA_SCTL_SPD		= 1,
+	ATA_SCTL_IPM		= 2,
+	ATA_SCTL_SPM		= 3,
+	ATA_SCTL_PMP		= 4,
+
 	/* SError bits */
 	SERR_DATA_RECOVERED	= (1 << 0), /* recovered data error */
 	SERR_COMM_RECOVERED	= (1 << 1), /* recovered comm failure */
@@ -441,8 +448,12 @@ static inline int ata_is_data(u8 prot)
 #define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
 #define ata_id_has_lba(id)	((id)[49] & (1 << 9))
 #define ata_id_has_dma(id)	((id)[49] & (1 << 8))
+#define ata_id_has_sata(id)	((id)[76] && (id)[76] != 0xffff)
 #define ata_id_has_ncq(id)	((id)[76] & (1 << 8))
 #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
+#define ata_id_has_hips(id)	(ata_id_has_sata(id) && ((id)[76] & (1 << 9)))
+#define ata_id_has_dips(id)	(ata_id_has_sata(id) && ((id)[78] & (1 << 3)))
+#define ata_id_dips_enabled(id)	(ata_id_has_sata(id) && ((id)[79] & (1 << 3)))
 #define ata_id_removeable(id)	((id)[0] & (1 << 7))
 #define ata_id_has_atapi_AN(id)	\
 	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
diff --git a/include/linux/pm.h b/include/linux/pm.h
index eccf59e..3a02c91 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -143,6 +143,9 @@ typedef struct pm_message {
  * 		the upcoming system state (such as PCI_D3hot), and enable
  * 		wakeup events as appropriate.
  *
+ * HIBERNATE	Enter a low power device state appropriate for the hibernation
+ * 		state (eg. ACPI S4) and enable wakeup events as appropriate.
+ *
  * FREEZE	Quiesce operations so that a consistent image can be saved;
  * 		but do NOT otherwise enter a low power device state, and do
  * 		NOT emit system wakeup events.
@@ -167,14 +170,16 @@ #define PM_EVENT_ON 0
 #define PM_EVENT_FREEZE 1
 #define PM_EVENT_SUSPEND 2
 #define PM_EVENT_PRETHAW 3
+#define PM_EVENT_HIBERNATE 4
 
 #define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
 #define PMSG_PRETHAW	((struct pm_message){ .event = PM_EVENT_PRETHAW, })
 #define PMSG_SUSPEND	((struct pm_message){ .event = PM_EVENT_SUSPEND, })
+#define PMSG_HIBERNATE	((struct pm_message){ .event = PM_EVENT_HIBERNATE, })
 #define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
 
 struct dev_pm_info {
-	pm_message_t		power_state;
+	pm_message_t __deprecated power_state;
 	unsigned		can_wakeup:1;
 #ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
@@ -246,6 +251,24 @@ #define device_init_wakeup(dev,val) \
 		device_set_wakeup_enable(dev,val); \
 	} while(0)
 
+void detect_idle(void);
+void enter_auto_sleep(int length);
+extern atomic_t cpu_needed;
+
+struct sleep_disabled_reason {
+	char *text;
+};
+
+static inline void disable_auto_sleep(struct sleep_disabled_reason *reason)
+{
+	atomic_inc(&cpu_needed);
+}
+
+static inline void enable_auto_sleep(struct sleep_disabled_reason *reason)
+{
+	atomic_dec(&cpu_needed);
+}
+
 /*
  * Global Power Management flags
  * Used to keep APM and ACPI from both being active
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index f7dfff2..e5693d6 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -5,7 +5,7 @@ endif
 
 obj-y				:= main.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
-obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
+obj-$(CONFIG_PM_SLEEP)		+= process.o console.o sleepy.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
diff --git a/kernel/power/main.c b/kernel/power/main.c
index a29da58..2470e94 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -3,6 +3,7 @@
  *
  * Copyright (c) 2003 Patrick Mochel
  * Copyright (c) 2003 Open Source Development Lab
+ * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>
  * 
  * This file is released under the GPLv2
  *
@@ -22,7 +23,10 @@ #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
 
+#include <asm/percpu.h>
+
 #include "power.h"
+#include "../../drivers/scsi/scsi_priv.h"
 
 DEFINE_MUTEX(pm_mutex);
 
@@ -269,6 +273,7 @@ void __attribute__ ((weak)) arch_suspend
  *	@state:		state to enter
  *
  *	This function should be called after devices have been suspended.
+ *	May not sleep.
  */
 static int suspend_enter(suspend_state_t state)
 {
@@ -277,6 +282,7 @@ static int suspend_enter(suspend_state_t
 	arch_suspend_disable_irqs();
 	BUG_ON(!irqs_disabled());
 
+	printk("Device_power_down\n");
 	if ((error = device_power_down(PMSG_SUSPEND))) {
 		printk(KERN_ERR "PM: Some devices failed to power down\n");
 		goto Done;
@@ -296,6 +302,8 @@ static int suspend_enter(suspend_state_t
  *	suspend_devices_and_enter - suspend devices and enter the desired system
  *				    sleep state.
  *	@state:		  state to enter
+ *
+ *	Needs to be called from process state and may sleep.
  */
 int suspend_devices_and_enter(suspend_state_t state)
 {
@@ -339,6 +347,7 @@ int suspend_devices_and_enter(suspend_st
  Finish:
 	if (suspend_ops->finish)
 		suspend_ops->finish();
+
  Resume_devices:
 	suspend_test_start();
 	device_resume();
@@ -392,6 +401,8 @@ static inline int valid_state(suspend_st
  *	happen when we wake up.
  *	Then, do the setup for suspend, enter the state, and cleaup (after
  *	we've woken up).
+ *
+ *	Needs to be called from process context, and may sleep.
  */
 static int enter_state(suspend_state_t state)
 {
@@ -426,6 +437,76 @@ static int enter_state(suspend_state_t s
 	return error;
 }
 
+/* Returns how long it waited in ms */
+//extern long (*panic_blink)(long time);
+
+int slept;
+
+/*
+   list crying_babies?
+
+   struct one_baby {
+   list_head;
+   char *name;
+   }
+
+   struct one_baby { "morning tasks" };
+*/
+
+struct sleep_disabled_reason wakeup_tasks = {
+	"wakeup_tasks"
+};
+
+int device_suspend_fake(pm_message_t state);
+
+int
+do_auto_sleep(void)
+{
+	int error,i;
+	int state = PM_SUSPEND_MEM;
+
+	/* add baby "morning tasks" to the lists. BUG if it is not
+	   the only baby */
+
+	if (slept)
+		return;
+	slept++;
+	disable_auto_sleep(&wakeup_tasks);
+//	device_suspend_fake(PMSG_SUSPEND);
+	suspend_enter(state);
+
+	/* FIXME: run "morning tasks" in process context; drivers need to check why
+	   machine was woken, and perhaps put themselves back to crying babies list
+	   if lid was opened or something. */
+
+	enable_auto_sleep(&wakeup_tasks);
+
+#if 0
+	printk("finishing\n");
+	if (suspend_ops->finish)
+		suspend_ops->finish();
+#endif
+
+	return 0;
+}
+
+extern int set_alarm(int length);
+
+void
+enter_auto_sleep(int length)
+{
+	int error;
+
+	if (atomic_read(&cpu_needed))
+		return;
+
+	printk("Auto sleeping\n");
+	set_alarm(length);
+
+	error = do_auto_sleep();
+	if (error)
+		printk("enter auto sleep failed: %d\n", error);
+}
 
 /**
  *	pm_suspend - Externally visible function for suspending system.
@@ -481,6 +562,12 @@ #endif
 	return (s - buf);
 }
 
+extern struct pci_dev *my_pdev;
+extern int autosuspend_enabled;
+extern struct device *my_scsi_disk;
+extern int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
+extern int ahci_pci_device_resume(struct pci_dev *pdev);
+
 static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 			   const char *buf, size_t n)
 {
@@ -495,6 +582,63 @@ #endif
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
+	if (len == 5 && !strncmp(buf, "adisk", len)) {
+		autosuspend_enabled = 1;
+		error = 0;
+  goto Exit;
+	}
+
+	if (len == 4 && !strncmp(buf, "down", len)) {
+		scsi_bus_suspend(my_scsi_disk, PMSG_SUSPEND);
+		ahci_pci_device_suspend(my_pdev, PMSG_SUSPEND);
+		error = 0;
+  goto Exit;
+	}
+
+	if (len == 2 && !strncmp(buf, "up", len)) {
+		ahci_pci_device_resume(my_pdev);
+		scsi_bus_resume(my_scsi_disk);
+		error = 0;
+  goto Exit;
+	}
+
+	if (len == 3 && !strncmp(buf, "now", len)) {
+		do_auto_sleep();
+		error = 0;
+  goto Exit;
+	}
+
+	if (len == 4 && !strncmp(buf, "now2", len)) {
+		suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = 0;
+  goto Exit;
+	}
+
+	if (len == 4 && !strncmp(buf, "auto", len)) {
+		static int acpi_ready = 0;
+		if (!acpi_ready) {
+			int error;
+			int state = PM_SUSPEND_MEM;
+
+			if (suspend_ops->begin) {
+				error = suspend_ops->begin(state);
+				if (error)
+					return error;
+			}
+
+			if (suspend_ops->prepare) {
+				error = suspend_ops->prepare();
+				if (error)
+					return error;
+			}
+			acpi_ready = 1;
+		}
+		atomic_dec(&cpu_needed);
+		printk("CPU needed now = %d\n", atomic_read(&cpu_needed));
+		error = 0;
+  goto Exit;
+	}
+
 	/* First, check if we are requested to hibernate */
 	if (len == 4 && !strncmp(buf, "disk", len)) {
 		error = hibernate();
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 700f44e..fa93da8 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -1,3 +1,6 @@
+#ifndef KERNEL_POWER_POWER_H
+#define KERNEL_POWER_POWER_H
+
 #include <linux/suspend.h>
 #include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
@@ -225,3 +228,4 @@ static inline void suspend_thaw_processe
 {
 }
 #endif
+#endif
diff --git a/kernel/power/sleepy.c b/kernel/power/sleepy.c
new file mode 100644
index 0000000..45a178c
--- /dev/null
+++ b/kernel/power/sleepy.c
@@ -0,0 +1,27 @@
+/*
+ * Copyright (c) 2007 Pavel Machek <pavel@suse.cz>
+ * 
+ * This file is released under the GPLv2
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/suspend.h>
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/cpu.h>
+#include <linux/resume-trace.h>
+#include <linux/freezer.h>
+#include <linux/vmstat.h>
+#include <linux/syscalls.h>
+#include <linux/rtc.h>
+#include <linux/kthread.h>
+
+#include <asm/percpu.h>
+
+#include "power.h"
+
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index d3d94c1..0fab3ca 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -287,3 +287,87 @@ static int __init init_timer_list_procfs
 	return 0;
 }
 __initcall(init_timer_list_procfs);
+
+/*
+ * Sleepy linux support
+ */
+
+#include <linux/suspend.h>
+#include <asm/atomic.h>
+
+atomic_t cpu_needed = ATOMIC_INIT(1);
+
+static s64
+detect_active_timers(struct hrtimer_clock_base *base, s64 first_timer)
+{
+	struct hrtimer *timer, tmp;
+	unsigned long next = 0, i;
+	struct rb_node *curr;
+	unsigned long flags;
+
+next_one:
+	i = 0;
+	spin_lock_irqsave(&base->cpu_base->lock, flags);
+
+	curr = base->first;
+	/*
+	 * Crude but we have to do this O(N*N) thing, because
+	 * we have to unlock the base when printing:
+	 */
+	while (curr && i < next) {
+		curr = rb_next(curr);
+		i++;
+	}
+
+	if (curr) {
+		timer = rb_entry(curr, struct hrtimer, node);
+		tmp = *timer;
+		spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+
+//		printk("[%Ld]", ktime_to_ns(tmp.expires));
+		first_timer = min_t(s64, first_timer, ktime_to_ns(tmp.expires));
+
+		next++;
+		goto next_one;
+	}
+	spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+	return first_timer;
+}
+
+void detect_idle(void)
+{
+	int i;
+	s64 first_timer = (3600ULL*NSEC_PER_SEC);
+	int cpu;
+	s64 now;
+
+
+	/*
+	 * Other CPUs could be non-idle, leading to nastiness:
+	 *
+	 * 1) they could be running timer code, and we would mistakenly call them idle
+	 *
+	 * 2) we can't sleep in SMP mode, anyway
+	 */
+	if (num_online_cpus() != 1)
+		return;
+
+	if (atomic_read(&cpu_needed) > 1)
+		return;
+
+	for_each_online_cpu(cpu) {
+		struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
+		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+//			printk("_");
+			first_timer = detect_active_timers(cpu_base->clock_base + i, first_timer);
+		}
+	}
+	now = ktime_to_ns(ktime_get());
+	if (first_timer > (now + 3ULL*NSEC_PER_SEC)) {
+		long long seconds = ((long long) first_timer - (long long) now);
+
+		do_div(seconds, NSEC_PER_SEC);
+		printk("nohz: Ready for ~ %Ld msec (%Ld sec) wait, %d\n", (long long) first_timer - (long long) now, seconds, atomic_read(&cpu_needed));
+		enter_auto_sleep(seconds-1);
+	}
+}
diff --git a/mm/slab.c b/mm/slab.c
index 473e6c2..87b7f06 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -944,7 +944,7 @@ static void __cpuinit start_cpu_timer(in
 		init_reap_node(cpu);
 		INIT_DELAYED_WORK(reap_work, cache_reap);
 		schedule_delayed_work_on(cpu, reap_work,
-					__round_jiffies_relative(HZ, cpu));
+					 __round_jiffies_relative(HZ*10000, cpu)); /* FIXME !*/
 	}
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 422d960..ce25ad1 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -793,7 +793,7 @@ #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
-int sysctl_stat_interval __read_mostly = HZ;
+int sysctl_stat_interval __read_mostly = 10000 * HZ;
 
 static void vmstat_update(struct work_struct *w)
 {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
