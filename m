Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbXEULQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbXEULQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXEULPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:15:53 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:31882 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbXEULPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:15:51 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 21 May 2007 13:16:21 +0200
Message-Id: <1179746181.7609.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 Documentation/s390/cds.txt        |   82 ++-----------------------------------
 arch/s390/kernel/compat_wrapper.S |   28 +++++++++++++
 arch/s390/kernel/kprobes.c        |    2 +-
 arch/s390/kernel/syscalls.S       |    5 ++
 arch/s390/mm/init.c               |   38 ++++++++++-------
 include/asm-s390/unistd.h         |   21 +++++++++-
 6 files changed, 80 insertions(+), 96 deletions(-)

Cornelia Huck (1):
      [S390] cio: Update documentation.

Heiko Carstens (4):
      [S390] Wire up sys_utimensat.
      [S390] Wire up signald, timerfd and eventfd syscalls.
      [S390] Make use of kretprobe_assert.
      [S390] More verbose show_mem() like other architectures.

diff --git a/Documentation/s390/cds.txt b/Documentation/s390/cds.txt
index 05a2b4f..58919d6 100644
--- a/Documentation/s390/cds.txt
+++ b/Documentation/s390/cds.txt
@@ -51,13 +51,8 @@ The major changes are:
 * The interrupt handlers must be adapted to use a ccw_device as argument.
   Moreover, they don't return a devstat, but an irb.
 * Before initiating an io, the options must be set via ccw_device_set_options().
-
-read_dev_chars()	
-   read device characteristics
-   
-read_conf_data()
-read_conf_data_lpm()
-   read configuration data.
+* Instead of calling read_dev_chars()/read_conf_data(), the driver issues
+  the channel program and handles the interrupt itself.
 
 ccw_device_get_ciw()
    get commands from extended sense data.
@@ -130,11 +125,6 @@ present their hardware status by the same (shared) IRQ, the operating system
 has to call every single device driver registered on this IRQ in order to
 determine the device driver owning the device that raised the interrupt.
 
-In order not to introduce a new I/O concept to the common Linux code,
-Linux/390 preserves the IRQ concept and semantically maps the ESA/390
-subchannels to Linux as IRQs. This allows Linux/390 to support up to 64k
-different IRQs, uniquely representing a single device each.
-
 Up to kernel 2.4, Linux/390 used to provide interfaces via the IRQ (subchannel).
 For internal use of the common I/O layer, these are still there. However, 
 device drivers should use the new calling interface via the ccw_device only.
@@ -151,9 +141,8 @@ information during their initialization step to recognize the devices they
 support using the information saved in the struct ccw_device given to them.
 This methods implies that Linux/390 doesn't require to probe for free (not
 armed) interrupt request lines (IRQs) to drive its devices with. Where
-applicable, the device drivers can use the read_dev_chars() to retrieve device
-characteristics. This can be done without having to request device ownership
-previously.
+applicable, the device drivers can use issue the READ DEVICE CHARACTERISTICS
+ccw to retrieve device characteristics in its online routine.
 
 In order to allow for easy I/O initiation the CDS layer provides a
 ccw_device_start() interface that takes a device specific channel program (one
@@ -170,69 +159,6 @@ SUBCHANNEL (HSCH) command without having pending I/O requests. This function is
 also covered by ccw_device_halt().
 
 
-read_dev_chars() - Read Device Characteristics
-
-This routine returns the characteristics for the device specified.
-
-The function is meant to be called with the device already enabled; that is,
-at earliest during set_online() processing.
-
-The ccw_device must not be locked prior to calling read_dev_chars().
-
-The function may be called enabled or disabled.
-
-int read_dev_chars(struct ccw_device *cdev, void **buffer, int length );
-
-cdev   - the ccw_device the information is requested for.
-buffer - pointer to a buffer pointer. The buffer pointer itself
-         must contain a valid buffer area.
-length - length of the buffer provided.
-
-The read_dev_chars() function returns :
-
-      0 - successful completion
--ENODEV - cdev invalid
--EINVAL - an invalid parameter was detected, or the function was called early.
--EBUSY  - an irrecoverable I/O error occurred or the device is not
-          operational.
-
-
-read_conf_data(), read_conf_data_lpm() - Read Configuration Data
-
-Retrieve the device dependent configuration data. Please have a look at your 
-device dependent I/O commands for the device specific layout of the node 
-descriptor elements. read_conf_data_lpm() will retrieve the configuration data
-for a specific path.
-
-The function is meant to be called with the device already enabled; that is,
-at earliest during set_online() processing.
-
-The function may be called enabled or disabled, but the device must not be
-locked
-
-int read_conf_data(struct ccw_device, void **buffer, int *length);
-int read_conf_data_lpm(struct ccw_device, void **buffer, int *length, __u8 lpm);
-
-cdev   - the ccw_device the data is requested for.
-buffer - Pointer to a buffer pointer. The read_conf_data() routine
-         will allocate a buffer and initialize the buffer pointer
-         accordingly. It's the device driver's responsibility to
-         release the kernel memory if no longer needed. 
-length - Length of the buffer allocated and retrieved.
-lpm    - Logical path mask to be used for retrieving the data. If
-         zero the data is retrieved on the next path available.
-
-The read_conf_data() function returns :
-          0 - Successful completion
--ENODEV     - cdev invalid.
--EINVAL     - An invalid parameter was detected, or the function was called early.
--EIO        - An irrecoverable I/O error occurred or the device is
-              not operational.
--ENOMEM     - The read_conf_data() routine couldn't obtain storage.
--EOPNOTSUPP - The device doesn't support the read configuration 
-              data command.
-
-
 get_ciw() - get command information word
 
 This call enables a device driver to get information about supported commands
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 32a69a1..acc4154 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1682,3 +1682,31 @@ compat_sys_utimes_wrapper:
 	llgtr	%r2,%r2			# char *
 	llgtr	%r3,%r3			# struct compat_timeval *
 	jg	compat_sys_utimes
+
+	.globl	compat_sys_utimensat_wrapper
+compat_sys_utimensat_wrapper:
+	llgfr	%r2,%r2			# unsigned int
+	llgtr	%r3,%r3			# char *
+	llgtr	%r4,%r4			# struct compat_timespec *
+	lgfr	%r5,%r5			# int
+	jg	compat_sys_utimensat
+
+	.globl	compat_sys_signalfd_wrapper
+compat_sys_signalfd_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# compat_sigset_t *
+	llgfr	%r4,%r4			# compat_size_t
+	jg	compat_sys_signalfd
+
+	.globl	compat_sys_timerfd_wrapper
+compat_sys_timerfd_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	lgfr	%r4,%r4			# int
+	llgtr	%r5,%r5			# struct compat_itimerspec *
+	jg	compat_sys_timerfd
+
+	.globl	sys_eventfd_wrapper
+sys_eventfd_wrapper:
+	llgfr	%r2,%r2			# unsigned int
+	jg	sys_eventfd
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index e39333a..358d2bb 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -413,7 +413,7 @@ static int __kprobes trampoline_probe_handler(struct kprobe *p,
 			break;
 		}
 	}
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	regs->psw.addr = orig_ret_address | PSW_ADDR_AMODE;
 
 	reset_current_kprobe();
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index cd8d321..738feb4 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -322,3 +322,8 @@ NI_SYSCALL							/* 310 sys_move_pages */
 SYSCALL(sys_getcpu,sys_getcpu,sys_getcpu_wrapper)
 SYSCALL(sys_epoll_pwait,sys_epoll_pwait,compat_sys_epoll_pwait_wrapper)
 SYSCALL(sys_utimes,sys_utimes,compat_sys_utimes_wrapper)
+NI_SYSCALL							/* 314 sys_fallocate */
+SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
+SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
+SYSCALL(sys_timerfd,sys_timerfd,compat_sys_timerfd_wrapper)
+SYSCALL(sys_eventfd,sys_eventfd,sys_eventfd_wrapper)
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 916b72a..9098531 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -61,30 +61,38 @@ void diag10(unsigned long addr)
 
 void show_mem(void)
 {
-        int i, total = 0, reserved = 0;
-        int shared = 0, cached = 0;
+	int i, total = 0, reserved = 0;
+	int shared = 0, cached = 0;
 	struct page *page;
 
-        printk("Mem-info:\n");
-        show_free_areas();
-        printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
-        i = max_mapnr;
-        while (i-- > 0) {
+	printk("Mem-info:\n");
+	show_free_areas();
+	printk("Free swap:       %6ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
+	i = max_mapnr;
+	while (i-- > 0) {
 		if (!pfn_valid(i))
 			continue;
 		page = pfn_to_page(i);
-                total++;
+		total++;
 		if (PageReserved(page))
-                        reserved++;
+			reserved++;
 		else if (PageSwapCache(page))
-                        cached++;
+			cached++;
 		else if (page_count(page))
 			shared += page_count(page) - 1;
-        }
-        printk("%d pages of RAM\n",total);
-        printk("%d reserved pages\n",reserved);
-        printk("%d pages shared\n",shared);
-        printk("%d pages swap cached\n",cached);
+	}
+	printk("%d pages of RAM\n", total);
+	printk("%d reserved pages\n", reserved);
+	printk("%d pages shared\n", shared);
+	printk("%d pages swap cached\n", cached);
+
+	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
+	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
+	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
+	printk("%lu pages slab\n",
+	       global_page_state(NR_SLAB_RECLAIMABLE) +
+	       global_page_state(NR_SLAB_UNRECLAIMABLE));
+	printk("%lu pages pagetables\n", global_page_state(NR_PAGETABLE));
 }
 
 static void __init setup_ro_region(void)
diff --git a/include/asm-s390/unistd.h b/include/asm-s390/unistd.h
index 5c6f00d..790c1c5 100644
--- a/include/asm-s390/unistd.h
+++ b/include/asm-s390/unistd.h
@@ -251,8 +251,12 @@
 #define __NR_getcpu		311
 #define __NR_epoll_pwait	312
 #define __NR_utimes		313
-
-#define NR_syscalls 314
+/* Number 314 is reserved for new sys_fallocate */
+#define __NR_utimensat		315
+#define __NR_signalfd		316
+#define __NR_timerfd		317
+#define __NR_eventfd		318
+#define NR_syscalls 319
 
 /* 
  * There are some system calls that are not present on 64 bit, some
@@ -346,6 +350,19 @@
 
 #ifdef __KERNEL__
 
+#ifndef CONFIG_64BIT
+#define __IGNORE_select
+#else
+#define __IGNORE_time
+#endif
+
+/* Ignore NUMA system calls. Not wired up on s390. */
+#define __IGNORE_mbind
+#define __IGNORE_get_mempolicy
+#define __IGNORE_set_mempolicy
+#define __IGNORE_migrate_pages
+#define __IGNORE_move_pages
+
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM


