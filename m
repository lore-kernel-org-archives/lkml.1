Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbXKELju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbXKELju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXKELjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:39:42 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:14109 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbXKELjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:39:41 -0500
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 05 Nov 2007 12:39:40 +0100
Message-Id: <1194262780.3117.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/kernel/early.c     |    4 +++-
 arch/s390/kernel/process.c   |    8 ++++++--
 arch/s390/kernel/smp.c       |    6 +++---
 arch/s390/kernel/time.c      |    2 +-
 drivers/s390/block/dcssblk.c |    9 +++++++--
 drivers/s390/cio/cmf.c       |    4 ++--
 drivers/s390/cio/device.c    |    2 +-
 drivers/s390/net/smsgiucv.c  |    4 ++++
 8 files changed, 27 insertions(+), 12 deletions(-)

Christian Borntraeger (2):
      [S390] Fix smsgiucv init on no iucv machines
      [S390] tod clock: announce clocksource as perfect

Gerald Schaefer (1):
      [S390] device_schedule_callback() for dcssblk.

Heiko Carstens (4):
      [S390] cio: use INIT_WORK to initialize struct work.
      [S390] Fix compile on !CONFIG_SMP.
      [S390] Fix memory detection.
      [S390] Rename "idle_time" attribute to "idle_time_us".

Roel Kluin (1):
      [S390] Fix priority mistakes in drivers/s390/cio/cmf.c

diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index e6289ee..8bf4ae1 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -200,11 +200,13 @@ static noinline __init void find_memory_chunks(unsigned long memsize)
 		cc = __tprot(addr);
 		while (cc == old_cc) {
 			addr += CHUNK_INCR;
-			cc = __tprot(addr);
+			if (addr >= memsize)
+				break;
 #ifndef CONFIG_64BIT
 			if (addr == ADDR2G)
 				break;
 #endif
+			cc = __tprot(addr);
 		}
 
 		if (old_addr != addr &&
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 96492cf..29f7884 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -92,6 +92,7 @@ EXPORT_SYMBOL(unregister_idle_notifier);
 
 void do_monitor_call(struct pt_regs *regs, long interruption_code)
 {
+#ifdef CONFIG_SMP
 	struct s390_idle_data *idle;
 
 	idle = &__get_cpu_var(s390_idle);
@@ -99,7 +100,7 @@ void do_monitor_call(struct pt_regs *regs, long interruption_code)
 	idle->idle_time += get_clock() - idle->idle_enter;
 	idle->in_idle = 0;
 	spin_unlock(&idle->lock);
-
+#endif
 	/* disable monitor call class 0 */
 	__ctl_clear_bit(8, 15);
 
@@ -114,7 +115,9 @@ extern void s390_handle_mcck(void);
 static void default_idle(void)
 {
 	int cpu, rc;
+#ifdef CONFIG_SMP
 	struct s390_idle_data *idle;
+#endif
 
 	/* CPU is going idle. */
 	cpu = smp_processor_id();
@@ -151,13 +154,14 @@ static void default_idle(void)
 		s390_handle_mcck();
 		return;
 	}
-
+#ifdef CONFIG_SMP
 	idle = &__get_cpu_var(s390_idle);
 	spin_lock(&idle->lock);
 	idle->idle_count++;
 	idle->in_idle = 1;
 	idle->idle_enter = get_clock();
 	spin_unlock(&idle->lock);
+#endif
 	trace_hardirqs_on();
 	/* Wait for external, I/O or machine check interrupt. */
 	__load_psw_mask(psw_kernel_bits | PSW_MASK_WAIT |
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 1d97fe1..b05ae85 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -788,14 +788,14 @@ static ssize_t show_idle_time(struct sys_device *dev, char *buf)
 	}
 	new_time = idle->idle_time;
 	spin_unlock_irq(&idle->lock);
-	return sprintf(buf, "%llu us\n", new_time >> 12);
+	return sprintf(buf, "%llu\n", new_time >> 12);
 }
-static SYSDEV_ATTR(idle_time, 0444, show_idle_time, NULL);
+static SYSDEV_ATTR(idle_time_us, 0444, show_idle_time, NULL);
 
 static struct attribute *cpu_attrs[] = {
 	&attr_capability.attr,
 	&attr_idle_count.attr,
-	&attr_idle_time.attr,
+	&attr_idle_time_us.attr,
 	NULL,
 };
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 48dae49..a963fe8 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -307,7 +307,7 @@ static cycle_t read_tod_clock(void)
 
 static struct clocksource clocksource_tod = {
 	.name		= "tod",
-	.rating		= 100,
+	.rating		= 400,
 	.read		= read_tod_clock,
 	.mask		= -1ULL,
 	.mult		= 1000,
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 859f870..5e083d1 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -193,6 +193,12 @@ dcssblk_segment_warn(int rc, char* seg_name)
 	}
 }
 
+static void dcssblk_unregister_callback(struct device *dev)
+{
+	device_unregister(dev);
+	put_device(dev);
+}
+
 /*
  * device attribute for switching shared/nonshared (exclusive)
  * operation (show + store)
@@ -276,8 +282,7 @@ removeseg:
 	blk_cleanup_queue(dev_info->dcssblk_queue);
 	dev_info->gd->queue = NULL;
 	put_disk(dev_info->gd);
-	device_unregister(dev);
-	put_device(dev);
+	rc = device_schedule_callback(dev, dcssblk_unregister_callback);
 out:
 	up_write(&dcssblk_devices_sem);
 	return rc;
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 725b0dd..f4c132a 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -343,10 +343,10 @@ static int cmf_copy_block(struct ccw_device *cdev)
 
 	if (sch->schib.scsw.fctl & SCSW_FCTL_START_FUNC) {
 		/* Don't copy if a start function is in progress. */
-		if ((!sch->schib.scsw.actl & SCSW_ACTL_SUSPENDED) &&
+		if ((!(sch->schib.scsw.actl & SCSW_ACTL_SUSPENDED)) &&
 		    (sch->schib.scsw.actl &
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT)) &&
-		    (!sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS))
+		    (!(sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS)))
 			return -EBUSY;
 	}
 	cmb_data = cdev->private->cmb;
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 7ee57f0..74f6b53 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -738,7 +738,7 @@ static int io_subchannel_initialize_dev(struct subchannel *sch,
 	atomic_set(&cdev->private->onoff, 0);
 	cdev->dev.parent = &sch->dev;
 	cdev->dev.release = ccw_device_release;
-	INIT_LIST_HEAD(&cdev->private->kick_work.entry);
+	INIT_WORK(&cdev->private->kick_work, NULL);
 	cdev->dev.groups = ccwdev_attr_groups;
 	/* Do first half of device_register. */
 	device_initialize(&cdev->dev);
diff --git a/drivers/s390/net/smsgiucv.c b/drivers/s390/net/smsgiucv.c
index 3ccca58..47bb47b 100644
--- a/drivers/s390/net/smsgiucv.c
+++ b/drivers/s390/net/smsgiucv.c
@@ -148,6 +148,10 @@ static int __init smsg_init(void)
 {
 	int rc;
 
+	if (!MACHINE_IS_VM) {
+		rc = -EPROTONOSUPPORT;
+		goto out;
+	}
 	rc = driver_register(&smsg_driver);
 	if (rc != 0)
 		goto out;


