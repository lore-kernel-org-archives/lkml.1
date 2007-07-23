Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbXGWI6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbXGWI6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXGWI4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:56:42 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40343 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934AbXGWI4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:56:39 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 23 Jul 2007 10:59:23 +0200
Message-Id: <1185181163.29337.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 Documentation/feature-removal-schedule.txt |   16 --
 arch/s390/appldata/appldata_base.c         |   12 +-
 arch/s390/kernel/compat_wrapper.S          |   10 +
 arch/s390/kernel/head.S                    |    1 +
 arch/s390/kernel/smp.c                     |   30 ++--
 arch/s390/kernel/sys_s390.c                |   20 +++
 arch/s390/kernel/syscalls.S                |    2 +-
 arch/s390/kernel/vmlinux.lds.S             |    1 +
 arch/s390/kernel/vtime.c                   |    2 +-
 arch/s390/mm/vmem.c                        |    6 +-
 drivers/s390/char/Kconfig                  |   12 +-
 drivers/s390/char/raw3270.c                |    6 +-
 drivers/s390/char/sclp_vt220.c             |    3 +-
 drivers/s390/cio/css.c                     |    2 +-
 drivers/s390/cio/css.h                     |    1 -
 drivers/s390/cio/device_ops.c              |  257 ----------------------------
 include/asm-s390/ccwdev.h                  |    5 -
 include/asm-s390/s390_ext.h                |    2 +
 include/asm-s390/smp.h                     |   11 +-
 include/asm-s390/unistd.h                  |    2 +-
 net/iucv/iucv.c                            |   15 +-
 21 files changed, 75 insertions(+), 341 deletions(-)

Christian Borntraeger (1):
      [S390] add types.h include to s390_ext.h

Cornelia Huck (3):
      [S390] cio: css_sch_device_register() can be made static.
      [S390] cio: Remove remains of _ccw_device_get_device_number().
      [S390] cio: Remove deprecated rdc/rcd.

Heiko Carstens (4):
      [S390] Convert to smp_call_function_single.
      [S390] Improve __smp_call_function_map.
      [S390] sclp: kill unused SCLP config option.
      [S390] Get rid of new section mismatch warnings.

Martin Schwidefsky (1):
      [S390] Wire up sys_fallocate.

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c175eed..a43d287 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -211,22 +211,6 @@ Who:	Richard Purdie <rpurdie@rpsys.net>
 
 ---------------------------
 
-What:	read_dev_chars(), read_conf_data{,_lpm}() (s390 common I/O layer)
-When:	December 2007
-Why:	These functions are a leftover from 2.4 times. They have several
-	problems:
-	- Duplication of checks that are done in the device driver's
-	  interrupt handler
-	- common I/O layer can't do device specific error recovery
-	- device driver can't be notified for conditions happening during
-	  execution of the function
-	Device drivers should issue the read device characteristics and read
-	configuration data ccws and do the appropriate error handling
-	themselves.
-Who:	Cornelia Huck <cornelia.huck@de.ibm.com>
-
----------------------------
-
 What:	i2c-ixp2000, i2c-ixp4xx and scx200_i2c drivers
 When:	September 2007
 Why:	Obsolete. The new i2c-gpio driver replaces all hardware-specific
diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 6ffbab7..62391fb 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -173,7 +173,7 @@ int appldata_diag(char record_nr, u16 function, unsigned long buffer,
 /*
  * appldata_mod_vtimer_wrap()
  *
- * wrapper function for mod_virt_timer(), because smp_call_function_on()
+ * wrapper function for mod_virt_timer(), because smp_call_function_single()
  * accepts only one parameter.
  */
 static void __appldata_mod_vtimer_wrap(void *p) {
@@ -208,9 +208,9 @@ __appldata_vtimer_setup(int cmd)
 					  num_online_cpus()) * TOD_MICRO;
 		for_each_online_cpu(i) {
 			per_cpu(appldata_timer, i).expires = per_cpu_interval;
-			smp_call_function_on(add_virt_timer_periodic,
-					     &per_cpu(appldata_timer, i),
-					     0, 1, i);
+			smp_call_function_single(i, add_virt_timer_periodic,
+						 &per_cpu(appldata_timer, i),
+						 0, 1);
 		}
 		appldata_timer_active = 1;
 		P_INFO("Monitoring timer started.\n");
@@ -236,8 +236,8 @@ __appldata_vtimer_setup(int cmd)
 			} args;
 			args.timer = &per_cpu(appldata_timer, i);
 			args.expires = per_cpu_interval;
-			smp_call_function_on(__appldata_mod_vtimer_wrap,
-					     &args, 0, 1, i);
+			smp_call_function_single(i, __appldata_mod_vtimer_wrap,
+						 &args, 0, 1);
 		}
 	}
 }
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index acc4154..6ee1bed 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1710,3 +1710,13 @@ compat_sys_timerfd_wrapper:
 sys_eventfd_wrapper:
 	llgfr	%r2,%r2			# unsigned int
 	jg	sys_eventfd
+
+	.globl	sys_fallocate_wrapper
+sys_fallocate_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	sllg	%r4,%r4,32		# get high word of 64bit loff_t
+	lr	%r4,%r5			# get low word of 64bit loff_t
+	sllg	%r5,%r6,32		# get high word of 64bit loff_t
+	l	%r5,164(%r15)		# get low word of 64bit loff_t
+	jg	sys_fallocate
diff --git a/arch/s390/kernel/head.S b/arch/s390/kernel/head.S
index 8f8c802..83477c7 100644
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -35,6 +35,7 @@
 #define ARCH_OFFSET	0
 #endif
 
+.section ".text.head","ax"
 #ifndef CONFIG_IPL
 	.org   0
 	.long  0x00080000,0x80000000+startup	# Just a restart PSW
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 182c085..03674fb 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -120,7 +120,7 @@ static void __smp_call_function_map(void (*func) (void *info), void *info,
 	if (wait)
 		data.finished = CPU_MASK_NONE;
 
-	spin_lock_bh(&call_lock);
+	spin_lock(&call_lock);
 	call_data = &data;
 
 	for_each_cpu_mask(cpu, map)
@@ -129,18 +129,16 @@ static void __smp_call_function_map(void (*func) (void *info), void *info,
 	/* Wait for response */
 	while (!cpus_equal(map, data.started))
 		cpu_relax();
-
 	if (wait)
 		while (!cpus_equal(map, data.finished))
 			cpu_relax();
-
-	spin_unlock_bh(&call_lock);
-
+	spin_unlock(&call_lock);
 out:
-	local_irq_disable();
-	if (local)
+	if (local) {
+		local_irq_disable();
 		func(info);
-	local_irq_enable();
+		local_irq_enable();
+	}
 }
 
 /*
@@ -170,30 +168,28 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 EXPORT_SYMBOL(smp_call_function);
 
 /*
- * smp_call_function_on:
+ * smp_call_function_single:
+ * @cpu: the CPU where func should run
  * @func: the function to run; this must be fast and non-blocking
  * @info: an arbitrary pointer to pass to the function
  * @nonatomic: unused
  * @wait: if true, wait (atomically) until function has completed on other CPUs
- * @cpu: the CPU where func should run
  *
  * Run a function on one processor.
  *
  * You must not call this function with disabled interrupts, from a
  * hardware interrupt handler or from a bottom half.
  */
-int smp_call_function_on(void (*func) (void *info), void *info, int nonatomic,
-			 int wait, int cpu)
+int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
+			     int nonatomic, int wait)
 {
-	cpumask_t map = CPU_MASK_NONE;
-
 	preempt_disable();
-	cpu_set(cpu, map);
-	__smp_call_function_map(func, info, nonatomic, wait, map);
+	__smp_call_function_map(func, info, nonatomic, wait,
+				cpumask_of_cpu(cpu));
 	preempt_enable();
 	return 0;
 }
-EXPORT_SYMBOL(smp_call_function_on);
+EXPORT_SYMBOL(smp_call_function_single);
 
 static void do_send_stop(void)
 {
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index 1c90c7e..13e27bd 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -265,3 +265,23 @@ s390_fadvise64_64(struct fadvise64_64_args __user *args)
 		return -EFAULT;
 	return sys_fadvise64_64(a.fd, a.offset, a.len, a.advice);
 }
+
+#ifndef CONFIG_64BIT
+/*
+ * This is a wrapper to call sys_fallocate(). For 31 bit s390 the last
+ * 64 bit argument "len" is split into the upper and lower 32 bits. The
+ * system call wrapper in the user space loads the value to %r6/%r7.
+ * The code in entry.S keeps the values in %r2 - %r6 where they are and
+ * stores %r7 to 96(%r15). But the standard C linkage requires that
+ * the whole 64 bit value for len is stored on the stack and doesn't
+ * use %r6 at all. So s390_fallocate has to convert the arguments from
+ *   %r2: fd, %r3: mode, %r4/%r5: offset, %r6/96(%r15)-99(%r15): len
+ * to
+ *   %r2: fd, %r3: mode, %r4/%r5: offset, 96(%r15)-103(%r15): len
+ */
+asmlinkage long s390_fallocate(int fd, int mode, loff_t offset,
+			       u32 len_high, u32 len_low)
+{
+	return sys_fallocate(fd, mode, offset, ((u64)len_high << 32) | len_low);
+}
+#endif
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 738feb4..9e26ed9 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -322,7 +322,7 @@ NI_SYSCALL							/* 310 sys_move_pages */
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
 SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
 SYSCALL(sys_utimes,sys_utimes,compat_sys_utimes_wrapper)
-NI_SYSCALL							/* 314 sys_fallocate */
+SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
 SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
 SYSCALL(sys_timerfd,sys_timerfd,compat_sys_timerfd_wrapper)
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 6ab7d4e..b4622a3 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -21,6 +21,7 @@ SECTIONS
   . = 0x00000000;
   _text = .;			/* Text and read-only data */
   .text : {
+	*(.text.head)
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index b6ed143..84ff78d 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -415,7 +415,7 @@ EXPORT_SYMBOL(add_virt_timer_periodic);
 
 /*
  * If we change a pending timer the function must be called on the CPU
- * where the timer is running on, e.g. by smp_call_function_on()
+ * where the timer is running on, e.g. by smp_call_function_single()
  *
  * The original mod_timer adds the timer if it is not pending. For compatibility
  * we do the same. The timer will be added on the current CPU as a oneshot timer.
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 92a5651..fd594d5 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -29,8 +29,8 @@ struct memory_segment {
 
 static LIST_HEAD(mem_segs);
 
-void memmap_init(unsigned long size, int nid, unsigned long zone,
-		 unsigned long start_pfn)
+void __meminit memmap_init(unsigned long size, int nid, unsigned long zone,
+			   unsigned long start_pfn)
 {
 	struct page *start, *end;
 	struct page *map_start, *map_end;
@@ -66,7 +66,7 @@ void memmap_init(unsigned long size, int nid, unsigned long zone,
 	}
 }
 
-static inline void *vmem_alloc_pages(unsigned int order)
+static void __init_refok *vmem_alloc_pages(unsigned int order)
 {
 	if (slab_is_available())
 		return (void *)__get_free_pages(GFP_KERNEL, order);
diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
index 3f36cb3..6430338 100644
--- a/drivers/s390/char/Kconfig
+++ b/drivers/s390/char/Kconfig
@@ -44,15 +44,9 @@ config CCW_CONSOLE
 	depends on TN3215_CONSOLE || TN3270_CONSOLE
 	default y
 
-config SCLP
-	bool "Support for SCLP"
-	depends on S390
-	help
-	  Include support for the SCLP interface to the service element.
-
 config SCLP_TTY
 	bool "Support for SCLP line mode terminal"
-	depends on SCLP
+	depends on S390
 	help
 	  Include support for IBM SCLP line-mode terminals.
 
@@ -65,7 +59,7 @@ config SCLP_CONSOLE
 
 config SCLP_VT220_TTY
 	bool "Support for SCLP VT220-compatible terminal"
-	depends on SCLP
+	depends on S390
 	help
 	  Include support for an IBM SCLP VT220-compatible terminal.
 
@@ -78,7 +72,7 @@ config SCLP_VT220_CONSOLE
 
 config SCLP_CPI
 	tristate "Control-Program Identification"
-	depends on SCLP
+	depends on S390
 	help
 	  This option enables the hardware console interface for system
 	  identification. This is commonly used for workload management and
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 743944a..4f2f81b 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -147,8 +147,7 @@ raw3270_request_alloc(size_t size)
  * Allocate a new 3270 ccw request from bootmem. Only works very
  * early in the boot process. Only con3270.c should be using this.
  */
-struct raw3270_request *
-raw3270_request_alloc_bootmem(size_t size)
+struct raw3270_request __init *raw3270_request_alloc_bootmem(size_t size)
 {
 	struct raw3270_request *rq;
 
@@ -848,8 +847,7 @@ raw3270_setup_device(struct ccw_device *cdev, struct raw3270 *rp, char *ascebc)
 /*
  * Setup 3270 device configured as console.
  */
-struct raw3270 *
-raw3270_setup_console(struct ccw_device *cdev)
+struct raw3270 __init *raw3270_setup_console(struct ccw_device *cdev)
 {
 	struct raw3270 *rp;
 	char *ascebc;
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 7263347..36fed66 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -621,8 +621,7 @@ sclp_vt220_flush_buffer(struct tty_struct *tty)
 /*
  * Initialize all relevant components and register driver with system.
  */
-static int
-__sclp_vt220_init(int early)
+static int __init_refok __sclp_vt220_init(int early)
 {
 	void *page;
 	int i;
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index dfca0ef..eb08d63 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -109,7 +109,7 @@ css_subchannel_release(struct device *dev)
 	}
 }
 
-int css_sch_device_register(struct subchannel *sch)
+static int css_sch_device_register(struct subchannel *sch)
 {
 	int ret;
 
diff --git a/drivers/s390/cio/css.h b/drivers/s390/cio/css.h
index ed79775..5d65e83 100644
--- a/drivers/s390/cio/css.h
+++ b/drivers/s390/cio/css.h
@@ -139,7 +139,6 @@ struct css_driver {
  */
 extern struct bus_type css_bus_type;
 
-extern int css_sch_device_register(struct subchannel *);
 extern void css_sch_device_unregister(struct subchannel *);
 extern struct subchannel * get_subchannel_by_schid(struct subchannel_id);
 extern int css_init_done;
diff --git a/drivers/s390/cio/device_ops.c b/drivers/s390/cio/device_ops.c
index a5d263f..14eba85 100644
--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -288,253 +288,6 @@ ccw_device_get_path_mask(struct ccw_device *cdev)
 		return sch->lpm;
 }
 
-static void
-ccw_device_wake_up(struct ccw_device *cdev, unsigned long ip, struct irb *irb)
-{
-	if (!ip)
-		/* unsolicited interrupt */
-		return;
-
-	/* Abuse intparm for error reporting. */
-	if (IS_ERR(irb))
-		cdev->private->intparm = -EIO;
-	else if (irb->scsw.cc == 1)
-		/* Retry for deferred condition code. */
-		cdev->private->intparm = -EAGAIN;
-	else if ((irb->scsw.dstat !=
-		  (DEV_STAT_CHN_END|DEV_STAT_DEV_END)) ||
-		 (irb->scsw.cstat != 0)) {
-		/*
-		 * We didn't get channel end / device end. Check if path
-		 * verification has been started; we can retry after it has
-		 * finished. We also retry unit checks except for command reject
-		 * or intervention required. Also check for long busy
-		 * conditions.
-		 */
-		 if (cdev->private->flags.doverify ||
-			 cdev->private->state == DEV_STATE_VERIFY)
-			 cdev->private->intparm = -EAGAIN;
-		else if ((irb->scsw.dstat & DEV_STAT_UNIT_CHECK) &&
-			 !(irb->ecw[0] &
-			   (SNS0_CMD_REJECT | SNS0_INTERVENTION_REQ)))
-			cdev->private->intparm = -EAGAIN;
-		else if ((irb->scsw.dstat & DEV_STAT_ATTENTION) &&
-			 (irb->scsw.dstat & DEV_STAT_DEV_END) &&
-			 (irb->scsw.dstat & DEV_STAT_UNIT_EXCEP))
-			cdev->private->intparm = -EAGAIN;
-		 else
-			 cdev->private->intparm = -EIO;
-			 
-	} else
-		cdev->private->intparm = 0;
-	wake_up(&cdev->private->wait_q);
-}
-
-static int
-__ccw_device_retry_loop(struct ccw_device *cdev, struct ccw1 *ccw, long magic, __u8 lpm)
-{
-	int ret;
-	struct subchannel *sch;
-
-	sch = to_subchannel(cdev->dev.parent);
-	do {
-		ccw_device_set_timeout(cdev, 60 * HZ);
-		ret = cio_start (sch, ccw, lpm);
-		if (ret != 0)
-			ccw_device_set_timeout(cdev, 0);
-		if (ret == -EBUSY) {
-			/* Try again later. */
-			spin_unlock_irq(sch->lock);
-			msleep(10);
-			spin_lock_irq(sch->lock);
-			continue;
-		}
-		if (ret != 0)
-			/* Non-retryable error. */
-			break;
-		/* Wait for end of request. */
-		cdev->private->intparm = magic;
-		spin_unlock_irq(sch->lock);
-		wait_event(cdev->private->wait_q,
-			   (cdev->private->intparm == -EIO) ||
-			   (cdev->private->intparm == -EAGAIN) ||
-			   (cdev->private->intparm == 0));
-		spin_lock_irq(sch->lock);
-		/* Check at least for channel end / device end */
-		if (cdev->private->intparm == -EIO) {
-			/* Non-retryable error. */
-			ret = -EIO;
-			break;
-		}
-		if (cdev->private->intparm == 0)
-			/* Success. */
-			break;
-		/* Try again later. */
-		spin_unlock_irq(sch->lock);
-		msleep(10);
-		spin_lock_irq(sch->lock);
-	} while (1);
-
-	return ret;
-}
-
-/**
- * read_dev_chars() - read device characteristics
- * @param cdev   target ccw device
- * @param buffer pointer to buffer for rdc data
- * @param length size of rdc data
- * @returns 0 for success, negative error value on failure
- *
- * Context:
- *   called for online device, lock not held
- **/
-int
-read_dev_chars (struct ccw_device *cdev, void **buffer, int length)
-{
-	void (*handler)(struct ccw_device *, unsigned long, struct irb *);
-	struct subchannel *sch;
-	int ret;
-	struct ccw1 *rdc_ccw;
-
-	if (!cdev)
-		return -ENODEV;
-	if (!buffer || !length)
-		return -EINVAL;
-	sch = to_subchannel(cdev->dev.parent);
-
-	CIO_TRACE_EVENT (4, "rddevch");
-	CIO_TRACE_EVENT (4, sch->dev.bus_id);
-
-	rdc_ccw = kzalloc(sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
-	if (!rdc_ccw)
-		return -ENOMEM;
-	rdc_ccw->cmd_code = CCW_CMD_RDC;
-	rdc_ccw->count = length;
-	rdc_ccw->flags = CCW_FLAG_SLI;
-	ret = set_normalized_cda (rdc_ccw, (*buffer));
-	if (ret != 0) {
-		kfree(rdc_ccw);
-		return ret;
-	}
-
-	spin_lock_irq(sch->lock);
-	/* Save interrupt handler. */
-	handler = cdev->handler;
-	/* Temporarily install own handler. */
-	cdev->handler = ccw_device_wake_up;
-	if (cdev->private->state != DEV_STATE_ONLINE)
-		ret = -ENODEV;
-	else if (((sch->schib.scsw.stctl & SCSW_STCTL_PRIM_STATUS) &&
-		  !(sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS)) ||
-		 cdev->private->flags.doverify)
-		ret = -EBUSY;
-	else
-		/* 0x00D9C4C3 == ebcdic "RDC" */
-		ret = __ccw_device_retry_loop(cdev, rdc_ccw, 0x00D9C4C3, 0);
-
-	/* Restore interrupt handler. */
-	cdev->handler = handler;
-	spin_unlock_irq(sch->lock);
-
-	clear_normalized_cda (rdc_ccw);
-	kfree(rdc_ccw);
-
-	return ret;
-}
-
-/*
- *  Read Configuration data using path mask
- */
-int
-read_conf_data_lpm (struct ccw_device *cdev, void **buffer, int *length, __u8 lpm)
-{
-	void (*handler)(struct ccw_device *, unsigned long, struct irb *);
-	struct subchannel *sch;
-	struct ciw *ciw;
-	char *rcd_buf;
-	int ret;
-	struct ccw1 *rcd_ccw;
-
-	if (!cdev)
-		return -ENODEV;
-	if (!buffer || !length)
-		return -EINVAL;
-	sch = to_subchannel(cdev->dev.parent);
-
-	CIO_TRACE_EVENT (4, "rdconf");
-	CIO_TRACE_EVENT (4, sch->dev.bus_id);
-
-	/*
-	 * scan for RCD command in extended SenseID data
-	 */
-	ciw = ccw_device_get_ciw(cdev, CIW_TYPE_RCD);
-	if (!ciw || ciw->cmd == 0)
-		return -EOPNOTSUPP;
-
-	/* Adjust requested path mask to excluded varied off paths. */
-	if (lpm) {
-		lpm &= sch->opm;
-		if (lpm == 0)
-			return -EACCES;
-	}
-
-	rcd_ccw = kzalloc(sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
-	if (!rcd_ccw)
-		return -ENOMEM;
-	rcd_buf = kzalloc(ciw->count, GFP_KERNEL | GFP_DMA);
- 	if (!rcd_buf) {
-		kfree(rcd_ccw);
-		return -ENOMEM;
-	}
-	rcd_ccw->cmd_code = ciw->cmd;
-	rcd_ccw->cda = (__u32) __pa (rcd_buf);
-	rcd_ccw->count = ciw->count;
-	rcd_ccw->flags = CCW_FLAG_SLI;
-
-	spin_lock_irq(sch->lock);
-	/* Save interrupt handler. */
-	handler = cdev->handler;
-	/* Temporarily install own handler. */
-	cdev->handler = ccw_device_wake_up;
-	if (cdev->private->state != DEV_STATE_ONLINE)
-		ret = -ENODEV;
-	else if (((sch->schib.scsw.stctl & SCSW_STCTL_PRIM_STATUS) &&
-		  !(sch->schib.scsw.stctl & SCSW_STCTL_SEC_STATUS)) ||
-		 cdev->private->flags.doverify)
-		ret = -EBUSY;
-	else
-		/* 0x00D9C3C4 == ebcdic "RCD" */
-		ret = __ccw_device_retry_loop(cdev, rcd_ccw, 0x00D9C3C4, lpm);
-
-	/* Restore interrupt handler. */
-	cdev->handler = handler;
-	spin_unlock_irq(sch->lock);
-
- 	/*
- 	 * on success we update the user input parms
- 	 */
- 	if (ret) {
- 		kfree (rcd_buf);
- 		*buffer = NULL;
- 		*length = 0;
- 	} else {
-		*length = ciw->count;
-		*buffer = rcd_buf;
-	}
-	kfree(rcd_ccw);
-
-	return ret;
-}
-
-/*
- *  Read Configuration data
- */
-int
-read_conf_data (struct ccw_device *cdev, void **buffer, int *length)
-{
-	return read_conf_data_lpm (cdev, buffer, length, 0);
-}
-
 /*
  * Try to break the lock on a boxed device.
  */
@@ -635,12 +388,6 @@ _ccw_device_get_subchannel_number(struct ccw_device *cdev)
 	return cdev->private->schid.sch_no;
 }
 
-int
-_ccw_device_get_device_number(struct ccw_device *cdev)
-{
-	return cdev->private->dev_id.devno;
-}
-
 
 MODULE_LICENSE("GPL");
 EXPORT_SYMBOL(ccw_device_set_options_mask);
@@ -655,9 +402,5 @@ EXPORT_SYMBOL(ccw_device_start_timeout_key);
 EXPORT_SYMBOL(ccw_device_start_key);
 EXPORT_SYMBOL(ccw_device_get_ciw);
 EXPORT_SYMBOL(ccw_device_get_path_mask);
-EXPORT_SYMBOL(read_conf_data);
-EXPORT_SYMBOL(read_dev_chars);
 EXPORT_SYMBOL(_ccw_device_get_subchannel_number);
-EXPORT_SYMBOL(_ccw_device_get_device_number);
 EXPORT_SYMBOL_GPL(ccw_device_get_chp_desc);
-EXPORT_SYMBOL_GPL(read_conf_data_lpm);
diff --git a/include/asm-s390/ccwdev.h b/include/asm-s390/ccwdev.h
index 4c2e171..1aeda27 100644
--- a/include/asm-s390/ccwdev.h
+++ b/include/asm-s390/ccwdev.h
@@ -165,11 +165,6 @@ extern int ccw_device_resume(struct ccw_device *);
 extern int ccw_device_halt(struct ccw_device *, unsigned long);
 extern int ccw_device_clear(struct ccw_device *, unsigned long);
 
-extern int __deprecated read_dev_chars(struct ccw_device *cdev, void **buffer, int length);
-extern int __deprecated read_conf_data(struct ccw_device *cdev, void **buffer, int *length);
-extern int __deprecated read_conf_data_lpm(struct ccw_device *cdev, void **buffer,
-			      int *length, __u8 lpm);
-
 extern int ccw_device_set_online(struct ccw_device *cdev);
 extern int ccw_device_set_offline(struct ccw_device *cdev);
 
diff --git a/include/asm-s390/s390_ext.h b/include/asm-s390/s390_ext.h
index df9b101..1e72362 100644
--- a/include/asm-s390/s390_ext.h
+++ b/include/asm-s390/s390_ext.h
@@ -10,6 +10,8 @@
  *               Martin Schwidefsky (schwidefsky@de.ibm.com)
  */
 
+#include <linux/types.h>
+
 typedef void (*ext_int_handler_t)(__u16 code);
 
 /*
diff --git a/include/asm-s390/smp.h b/include/asm-s390/smp.h
index 76e424f..07708c0 100644
--- a/include/asm-s390/smp.h
+++ b/include/asm-s390/smp.h
@@ -36,8 +36,7 @@ extern void machine_halt_smp(void);
 extern void machine_power_off_smp(void);
 
 extern void smp_setup_cpu_possible_map(void);
-extern int smp_call_function_on(void (*func) (void *info), void *info,
-				int nonatomic, int wait, int cpu);
+
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
 /*
@@ -96,14 +95,6 @@ extern int __cpu_up (unsigned int cpu);
 #endif
 
 #ifndef CONFIG_SMP
-static inline int
-smp_call_function_on(void (*func) (void *info), void *info,
-		     int nonatomic, int wait, int cpu)
-{
-	func(info);
-	return 0;
-}
-
 static inline void smp_send_stop(void)
 {
 	/* Disable all interrupts/machine checks */
diff --git a/include/asm-s390/unistd.h b/include/asm-s390/unistd.h
index 790c1c5..f04acb2 100644
--- a/include/asm-s390/unistd.h
+++ b/include/asm-s390/unistd.h
@@ -251,7 +251,7 @@
 #define __NR_getcpu		311
 #define __NR_epoll_pwait	312
 #define __NR_utimes		313
-/* Number 314 is reserved for new sys_fallocate */
+#define __NR_fallocate		314
 #define __NR_utimensat		315
 #define __NR_signalfd		316
 #define __NR_timerfd		317
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index ad5150b..983058d 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -479,7 +479,8 @@ static void iucv_setmask_mp(void)
 		/* Enable all cpus with a declared buffer. */
 		if (cpu_isset(cpu, iucv_buffer_cpumask) &&
 		    !cpu_isset(cpu, iucv_irq_cpumask))
-			smp_call_function_on(iucv_allow_cpu, NULL, 0, 1, cpu);
+			smp_call_function_single(cpu, iucv_allow_cpu,
+						 NULL, 0, 1);
 	preempt_enable();
 }
 
@@ -497,7 +498,7 @@ static void iucv_setmask_up(void)
 	cpumask = iucv_irq_cpumask;
 	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
 	for_each_cpu_mask(cpu, cpumask)
-		smp_call_function_on(iucv_block_cpu, NULL, 0, 1, cpu);
+		smp_call_function_single(cpu, iucv_block_cpu, NULL, 0, 1);
 }
 
 /**
@@ -522,7 +523,7 @@ static int iucv_enable(void)
 	rc = -EIO;
 	preempt_disable();
 	for_each_online_cpu(cpu)
-		smp_call_function_on(iucv_declare_cpu, NULL, 0, 1, cpu);
+		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 0, 1);
 	preempt_enable();
 	if (cpus_empty(iucv_buffer_cpumask))
 		/* No cpu could declare an iucv buffer. */
@@ -578,7 +579,7 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		smp_call_function_on(iucv_declare_cpu, NULL, 0, 1, cpu);
+		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 0, 1);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -587,10 +588,10 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 		if (cpus_empty(cpumask))
 			/* Can't offline last IUCV enabled cpu. */
 			return NOTIFY_BAD;
-		smp_call_function_on(iucv_retrieve_cpu, NULL, 0, 1, cpu);
+		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 0, 1);
 		if (cpus_empty(iucv_irq_cpumask))
-			smp_call_function_on(iucv_allow_cpu, NULL, 0, 1,
-					     first_cpu(iucv_buffer_cpumask));
+			smp_call_function_single(first_cpu(iucv_buffer_cpumask),
+						 iucv_allow_cpu, NULL, 0, 1);
 		break;
 	}
 	return NOTIFY_OK;


