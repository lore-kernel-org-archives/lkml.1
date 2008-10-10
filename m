Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYJJAdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYJJAdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYJJAdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:33:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYJJAdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:33:02 -0400
Date: Fri, 10 Oct 2008 02:32:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] fastboot tree for v2.6.28
Message-ID: <20081010003241.GA23940@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest fastboot-v28-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git fastboot-v28-for-linus

the (opt-in) fastboot async bootup feature, as described by Arjan in his 
v2.6.28 announcement:

   http://lwn.net/Articles/299591/

tested and maintained in -tip because tip/tracing embedd-merges this 
topic. (for the fastboot tracer)

Thanks,

	Ingo

------------------>
Arjan van de Ven (16):
      fastboot: create a "asynchronous" initlevel
      fastboot: turn the USB hostcontroller initcalls into async initcalls
      fastboot: convert a few non-critical ACPI drivers to async initcalls
      fastboot: hold the BKL over the async init call sequence
      fastboot: sync the async execution before late_initcall and move level 6s (sync) first
      fastboot: make fastboot a config option
      modules: extend initcall_debug functionality to the module loader
      fastboot: retry mounting the root fs if we can't find init
      fastboot: make the raid autodetect code wait for all devices to init
      fastboot: remove "wait for all devices before mounting root" delay
      fastboot: make the RAID autostart code print a message just before waiting
      fastboot: fix blackfin breakage due to vmlinux.lds change
      Add a script to visualize the kernel boot process / time
      fastboot: fix issues and improve output of bootgraph.pl
      use the fancy new printk flags to print the function pointer
      raid: make RAID autodetect default a KConfig option

Arnaud Patard (1):
      fastboot: Fix bootgraph.pl initcall name regexp

Ingo Molnar (2):
      fastboot: fix typo in init/Kconfig text
      warning: fix init do_mounts_md c

KOSAKI Motohiro (1):
      fastboot: fix build error of autodetect_raid()

Li, Shaohua (1):
      fastboot: remove duplicate unpack_to_rootfs()

Steven Noonan (1):
      init/initramfs.c: unused function when compiling without CONFIG_BLK_DEV_RAM


 drivers/acpi/battery.c            |    2 +-
 drivers/acpi/button.c             |    2 +-
 drivers/acpi/thermal.c            |    2 +-
 drivers/md/Kconfig                |   14 ++++
 drivers/pci/pci.c                 |    2 +-
 drivers/usb/host/ehci-hcd.c       |    2 +-
 drivers/usb/host/ohci-hcd.c       |    2 +-
 drivers/usb/host/uhci-hcd.c       |    2 +-
 include/asm-generic/vmlinux.lds.h |    6 +-
 include/linux/init.h              |    8 ++
 init/Kconfig                      |   11 +++
 init/do_mounts.c                  |    2 +
 init/do_mounts_md.c               |   41 ++++++++--
 init/initramfs.c                  |   73 +++++++++++++++----
 init/main.c                       |   84 +++++++++++++++++++--
 scripts/bootgraph.pl              |  147 +++++++++++++++++++++++++++++++++++++
 16 files changed, 361 insertions(+), 39 deletions(-)
 create mode 100644 scripts/bootgraph.pl

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b1c723f..d5d30ca 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -904,5 +904,5 @@ static void __exit acpi_battery_exit(void)
 #endif
 }
 
-module_init(acpi_battery_init);
+module_init_async(acpi_battery_init);
 module_exit(acpi_battery_exit);
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 1dfec41..46b3805 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -545,5 +545,5 @@ static void __exit acpi_button_exit(void)
 	remove_proc_entry(ACPI_BUTTON_CLASS, acpi_root_dir);
 }
 
-module_init(acpi_button_init);
+module_init_async(acpi_button_init);
 module_exit(acpi_button_exit);
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 9127036..c07f9ba 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1876,5 +1876,5 @@ static void __exit acpi_thermal_exit(void)
 	return;
 }
 
-module_init(acpi_thermal_init);
+module_init_async(acpi_thermal_init);
 module_exit(acpi_thermal_exit);
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 07d92c1..8e72c91 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -30,6 +30,20 @@ config BLK_DEV_MD
 
 	  If unsure, say N.
 
+config MD_AUTODETECT
+	bool "Autodetect RAID arrays during kernel boot"
+	depends on BLK_DEV_MD
+	default y
+	---help---
+	  If you say Y here, then the kernel will try to autodetect raid
+	  arrays as part of its boot process. 
+
+	  If you don't use raid and say Y, this autodetection can cause 
+	  a several-second delay in the boot time due to various
+	  synchronisation steps that are part of this step.
+
+	  If unsure, say Y.
+
 config MD_LINEAR
 	tristate "Linear (append) mode"
 	depends on BLK_DEV_MD
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c9884bb..a9301a2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1909,7 +1909,7 @@ static int __devinit pci_setup(char *str)
 }
 early_param("pci", pci_setup);
 
-device_initcall(pci_init);
+device_initcall_sync(pci_init);
 
 EXPORT_SYMBOL(pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_io);
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 8409e07..209f64c 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1107,7 +1107,7 @@ clean0:
 #endif
 	return retval;
 }
-module_init(ehci_hcd_init);
+module_init_async(ehci_hcd_init);
 
 static void __exit ehci_hcd_cleanup(void)
 {
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 8990196..868c509 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1186,7 +1186,7 @@ static int __init ohci_hcd_mod_init(void)
 
 	return retval;
 }
-module_init(ohci_hcd_mod_init);
+module_init_async(ohci_hcd_mod_init);
 
 static void __exit ohci_hcd_mod_exit(void)
 {
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 3a7bfe7..f2a05ac 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -999,7 +999,7 @@ static void __exit uhci_hcd_cleanup(void)
 	kfree(errbuf);
 }
 
-module_init(uhci_hcd_init);
+module_init_async(uhci_hcd_init);
 module_exit(uhci_hcd_cleanup);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index cb752ba..ccabc4e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -376,8 +376,12 @@
   	*(.initcall5.init)						\
   	*(.initcall5s.init)						\
 	*(.initcallrootfs.init)						\
+	*(.initcall6s.init)						\
+	VMLINUX_SYMBOL(__async_initcall_start) = .;			\
+	*(.initcall6a.init)						\
+	VMLINUX_SYMBOL(__async_initcall_end) = .;			\
   	*(.initcall6.init)						\
-  	*(.initcall6s.init)						\
+	VMLINUX_SYMBOL(__device_initcall_end) = .;			\
   	*(.initcall7.init)						\
   	*(.initcall7s.init)
 
diff --git a/include/linux/init.h b/include/linux/init.h
index 93538b6..b6201c0 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -143,6 +143,8 @@ extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
+extern int do_one_initcall(initcall_t fn);
+
 
 /* used by init/main.c */
 void setup_arch(char **);
@@ -197,11 +199,13 @@ extern void (*late_time_init)(void);
 #define fs_initcall_sync(fn)		__define_initcall("5s",fn,5s)
 #define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
 #define device_initcall(fn)		__define_initcall("6",fn,6)
+#define device_initcall_async(fn)	__define_initcall("6a", fn, 6a)
 #define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
 #define late_initcall(fn)		__define_initcall("7",fn,7)
 #define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)
 
 #define __initcall(fn) device_initcall(fn)
+#define __initcall_async(fn) device_initcall_async(fn)
 
 #define __exitcall(fn) \
 	static exitcall_t __exitcall_##fn __exit_call = fn
@@ -257,6 +261,7 @@ void __init parse_early_param(void);
  * be one per module.
  */
 #define module_init(x)	__initcall(x);
+#define module_init_async(x)	__initcall_async(x);
 
 /**
  * module_exit() - driver exit entry point
@@ -279,10 +284,13 @@ void __init parse_early_param(void);
 #define subsys_initcall(fn)		module_init(fn)
 #define fs_initcall(fn)			module_init(fn)
 #define device_initcall(fn)		module_init(fn)
+#define device_initcall_async(fn)	module_init(fn)
 #define late_initcall(fn)		module_init(fn)
 
 #define security_initcall(fn)		module_init(fn)
 
+#define module_init_async(fn)		module_init(fn)
+
 /* Each module must use one module_init(). */
 #define module_init(initfn)					\
 	static inline initcall_t __inittest(void)		\
diff --git a/init/Kconfig b/init/Kconfig
index c11da38..0090c99 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -524,6 +524,17 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say Y.
 
+config FASTBOOT
+	bool "Fast boot support"
+	help
+	  The fastboot option will cause the kernel to try to optimize
+	  for faster boot. 
+
+	  This includes doing some of the device initialization asynchronously
+	  as well as opportunistically trying to mount the root fs early.
+
+	  If unsure, say N.
+
 config SYSCTL
 	bool
 
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 3715feb..d64e01d 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -365,9 +365,11 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
+#ifndef CONFIG_FASTBOOT
 	/* wait for the known devices to complete their probing */
 	while (driver_probe_done() != 0)
 		msleep(100);
+#endif
 
 	md_run_setup();
 
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 693d246..4c87ee1 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -1,5 +1,6 @@
 
 #include <linux/raid/md.h>
+#include <linux/delay.h>
 
 #include "do_mounts.h"
 
@@ -12,7 +13,12 @@
  * The code for that is here.
  */
 
-static int __initdata raid_noautodetect, raid_autopart;
+#ifdef CONFIG_MD_AUTODETECT
+static int __initdata raid_noautodetect;
+#else
+static int __initdata raid_noautodetect=1;
+#endif
+static int __initdata raid_autopart;
 
 static struct {
 	int minor;
@@ -252,6 +258,8 @@ static int __init raid_setup(char *str)
 
 		if (!strncmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
+		if (!strncmp(str, "autodetect", wlen))
+			raid_noautodetect = 0;
 		if (strncmp(str, "partitionable", wlen)==0)
 			raid_autopart = 1;
 		if (strncmp(str, "part", wlen)==0)
@@ -264,17 +272,32 @@ static int __init raid_setup(char *str)
 __setup("raid=", raid_setup);
 __setup("md=", md_setup);
 
+static void autodetect_raid(void)
+{
+	int fd;
+
+	/*
+	 * Since we don't want to detect and use half a raid array, we need to
+	 * wait for the known devices to complete their probing
+	 */
+	printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
+	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
+	while (driver_probe_done() < 0)
+		msleep(100);
+	fd = sys_open("/dev/md0", 0, 0);
+	if (fd >= 0) {
+		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
+		sys_close(fd);
+	}
+}
+
 void __init md_run_setup(void)
 {
 	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
+
 	if (raid_noautodetect)
-		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=noautodetect)\n");
-	else {
-		int fd = sys_open("/dev/md0", 0, 0);
-		if (fd >= 0) {
-			sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-			sys_close(fd);
-		}
-	}
+		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=autodetect will force)\n");
+	else
+		autodetect_raid();
 	md_setup_drive();
 }
diff --git a/init/initramfs.c b/init/initramfs.c
index 644fc01..2f056e2 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -5,6 +5,7 @@
 #include <linux/fcntl.h>
 #include <linux/delay.h>
 #include <linux/string.h>
+#include <linux/dirent.h>
 #include <linux/syscalls.h>
 
 static __initdata char *message;
@@ -121,8 +122,6 @@ static __initdata char *victim;
 static __initdata unsigned count;
 static __initdata loff_t this_header, next_header;
 
-static __initdata int dry_run;
-
 static inline void __init eat(unsigned n)
 {
 	victim += n;
@@ -183,10 +182,6 @@ static int __init do_header(void)
 	parse_header(collected);
 	next_header = this_header + N_ALIGN(name_len) + body_len;
 	next_header = (next_header + 3) & ~3;
-	if (dry_run) {
-		read_into(name_buf, N_ALIGN(name_len), GotName);
-		return 0;
-	}
 	state = SkipIt;
 	if (name_len <= 0 || name_len > PATH_MAX)
 		return 0;
@@ -257,8 +252,6 @@ static int __init do_name(void)
 		free_hash();
 		return 0;
 	}
-	if (dry_run)
-		return 0;
 	clean_path(collected, mode);
 	if (S_ISREG(mode)) {
 		int ml = maybe_link();
@@ -423,10 +416,9 @@ static void __init flush_window(void)
 	outcnt = 0;
 }
 
-static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
+static char * __init unpack_to_rootfs(char *buf, unsigned len)
 {
 	int written;
-	dry_run = check_only;
 	header_buf = kmalloc(110, GFP_KERNEL);
 	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
 	name_buf = kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
@@ -520,10 +512,59 @@ skip:
 	initrd_end = 0;
 }
 
+#ifdef CONFIG_BLK_DEV_RAM
+#define BUF_SIZE 1024
+static void __init clean_rootfs(void)
+{
+	int fd;
+	void *buf;
+	struct linux_dirent64 *dirp;
+	int count;
+
+	fd = sys_open("/", O_RDONLY, 0);
+	WARN_ON(fd < 0);
+	if (fd < 0)
+		return;
+	buf = kzalloc(BUF_SIZE, GFP_KERNEL);
+	WARN_ON(!buf);
+	if (!buf) {
+		sys_close(fd);
+		return;
+	}
+
+	dirp = buf;
+	count = sys_getdents64(fd, dirp, BUF_SIZE);
+	while (count > 0) {
+		while (count > 0) {
+			struct stat st;
+			int ret;
+
+			ret = sys_newlstat(dirp->d_name, &st);
+			WARN_ON_ONCE(ret);
+			if (!ret) {
+				if (S_ISDIR(st.st_mode))
+					sys_rmdir(dirp->d_name);
+				else
+					sys_unlink(dirp->d_name);
+			}
+
+			count -= dirp->d_reclen;
+			dirp = (void *)dirp + dirp->d_reclen;
+		}
+		dirp = buf;
+		memset(buf, 0, BUF_SIZE);
+		count = sys_getdents64(fd, dirp, BUF_SIZE);
+	}
+
+	sys_close(fd);
+	kfree(buf);
+}
+#endif
+
 static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start,
-			 __initramfs_end - __initramfs_start, 0);
+			 __initramfs_end - __initramfs_start);
 	if (err)
 		panic(err);
 	if (initrd_start) {
@@ -531,13 +572,15 @@ static int __init populate_rootfs(void)
 		int fd;
 		printk(KERN_INFO "checking if image is initramfs...");
 		err = unpack_to_rootfs((char *)initrd_start,
-			initrd_end - initrd_start, 1);
+			initrd_end - initrd_start);
 		if (!err) {
 			printk(" it is\n");
-			unpack_to_rootfs((char *)initrd_start,
-				initrd_end - initrd_start, 0);
 			free_initrd();
 			return 0;
+		} else {
+			clean_rootfs();
+			unpack_to_rootfs(__initramfs_start,
+				 __initramfs_end - __initramfs_start);
 		}
 		printk("it isn't (%s); looks like an initrd\n", err);
 		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
@@ -550,7 +593,7 @@ static int __init populate_rootfs(void)
 #else
 		printk(KERN_INFO "Unpacking initramfs...");
 		err = unpack_to_rootfs((char *)initrd_start,
-			initrd_end - initrd_start, 0);
+			initrd_end - initrd_start);
 		if (err)
 			panic(err);
 		printk(" done\n");
diff --git a/init/main.c b/init/main.c
index 3820323..2dc22fa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -708,7 +708,7 @@ int do_one_initcall(initcall_t fn)
 	int result;
 
 	if (initcall_debug) {
-		printk("calling  %pF\n", fn);
+		printk("calling  %pF @ %i\n", fn, task_pid_nr(current));
 		t0 = ktime_get();
 	}
 
@@ -718,9 +718,8 @@ int do_one_initcall(initcall_t fn)
 		t1 = ktime_get();
 		delta = ktime_sub(t1, t0);
 
-		printk("initcall %pF returned %d after %Ld msecs\n",
-			fn, result,
-			(unsigned long long) delta.tv64 >> 20);
+		printk("initcall %pF returned %d after %Ld msecs\n", fn,
+			result, (unsigned long long) delta.tv64 >> 20);
 	}
 
 	msgbuf[0] = 0;
@@ -745,16 +744,68 @@ int do_one_initcall(initcall_t fn)
 
 
 extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
+extern initcall_t __async_initcall_start[], __async_initcall_end[];
+extern initcall_t __device_initcall_end[];
 
-static void __init do_initcalls(void)
+static void __init do_async_initcalls(struct work_struct *dummy)
 {
 	initcall_t *call;
 
-	for (call = __early_initcall_end; call < __initcall_end; call++)
+	/*
+	 * For compatibility with normal init calls... take the BKL
+	 * not pretty, not desirable, but compatibility first
+	 */
+	lock_kernel();
+	for (call = __async_initcall_start; call < __async_initcall_end; call++)
 		do_one_initcall(*call);
+	unlock_kernel();
+}
+
+static struct workqueue_struct *async_init_wq;
 
-	/* Make sure there is no pending stuff from the initcall sequence */
+
+
+static void __init do_initcalls(void)
+{
+	initcall_t *call;
+	static DECLARE_WORK(async_work, do_async_initcalls);
+	/*
+	 * 0 = levels 0 - 6,
+	 * 1 = level 6a,
+	 * 2 = after level 6a,
+	 * 3 = after level 6
+	 */
+	int phase = 0;
+
+	async_init_wq = create_singlethread_workqueue("kasyncinit");
+
+	for (call = __early_initcall_end; call < __initcall_end; call++) {
+		if (phase == 0 && call >= __async_initcall_start) {
+			phase = 1;
+#ifdef CONFIG_FASTBOOT
+			queue_work(async_init_wq, &async_work);
+#else
+			do_async_initcalls(NULL);
+#endif
+		}
+		if (phase == 1 && call >= __async_initcall_end)
+			phase = 2;
+		if (phase == 2 && call >= __device_initcall_end) {
+			phase = 3;
+			/* make sure all async work is done before level 7 */
+			flush_workqueue(async_init_wq);
+		}
+		if (phase != 1)
+			do_one_initcall(*call);
+	}
+
+	/*
+	 * Make sure there is no pending stuff from the initcall sequence,
+	 * including the async initcalls
+	 */
 	flush_scheduled_work();
+	flush_workqueue(async_init_wq);
+	destroy_workqueue(async_init_wq);
 }
 
 /*
@@ -794,6 +845,7 @@ static void run_init_process(char *init_filename)
  */
 static int noinline init_post(void)
 {
+	int retry_count = 1;
 	free_initmem();
 	unlock_kernel();
 	mark_rodata_ro();
@@ -814,6 +866,7 @@ static int noinline init_post(void)
 				ramdisk_execute_command);
 	}
 
+retry:
 	/*
 	 * We try each of these until one succeeds.
 	 *
@@ -826,6 +879,23 @@ static int noinline init_post(void)
 					"defaults...\n", execute_command);
 	}
 	run_init_process("/sbin/init");
+
+	if (retry_count > 0) {
+		retry_count--;
+		/* 
+		 * We haven't found init yet... potentially because the device
+		 * is still being probed. We need to
+		 * - flush keventd and friends
+		 * - wait for the known devices to complete their probing
+		 * - try to mount the root fs again
+		 */
+		flush_scheduled_work();
+		while (driver_probe_done() != 0)
+			msleep(100);
+		prepare_namespace();
+		goto retry;
+	}
+	
 	run_init_process("/etc/init");
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");
diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
new file mode 100644
index 0000000..2243353
--- /dev/null
+++ b/scripts/bootgraph.pl
@@ -0,0 +1,147 @@
+#!/usr/bin/perl
+
+# Copyright 2008, Intel Corporation
+#
+# This file is part of the Linux kernel
+#
+# This program file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License.
+#
+# This program is distributed in the hope that it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+# for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program in a file named COPYING; if not, write to the
+# Free Software Foundation, Inc.,
+# 51 Franklin Street, Fifth Floor,
+# Boston, MA 02110-1301 USA
+#
+# Authors:
+# 	Arjan van de Ven <arjan@linux.intel.com>
+
+
+#
+# This script turns a dmesg output into a SVG graphic that shows which
+# functions take how much time. You can view SVG graphics with various
+# programs, including Inkscape, The Gimp and Firefox.
+#
+#
+# For this script to work, the kernel needs to be compiled with the
+# CONFIG_PRINTK_TIME configuration option enabled, and with
+# "initcall_debug" passed on the kernel command line.
+#
+# usage:
+# 	dmesg | perl scripts/bootgraph.pl > output.svg
+#
+
+my @rows;
+my %start, %end, %row;
+my $done = 0;
+my $rowcount = 0;
+my $maxtime = 0;
+my $firsttime = 100;
+my $count = 0;
+while (<>) {
+	my $line = $_;
+	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_]+)\+/) {
+		my $func = $2;
+		if ($done == 0) {
+			$start{$func} = $1;
+			if ($1 < $firsttime) {
+				$firsttime = $1;
+			}
+		}
+		$row{$func} = 1;
+		if ($line =~ /\@ ([0-9]+)/) {
+			my $pid = $1;
+			if (!defined($rows[$pid])) {
+				$rowcount = $rowcount + 1;
+				$rows[$pid] = $rowcount;
+			}
+			$row{$func} = $rows[$pid];
+		}
+		$count = $count + 1;
+	}
+
+	if ($line =~ /([0-9\.]+)\] initcall ([a-zA-Z0-9\_]+)\+.*returned/) {
+		if ($done == 0) {
+			$end{$2} = $1;
+			$maxtime = $1;
+		}
+	}
+	if ($line =~ /Write protecting the/) {
+		$done = 1;
+	}
+	if ($line =~ /Freeing unused kernel memory/) {
+		$done = 1;
+	}
+}
+
+if ($count == 0) {
+	print "No data found in the dmesg. Make sure that 'printk.time=1' and\n";
+	print "'initcall_debug' are passed on the kernel command line.\n\n";
+	print "Usage: \n";
+	print "      dmesg | perl scripts/bootgraph.pl > output.svg\n\n";
+	exit;
+}
+
+print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
+print "<svg width=\"1000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
+
+my @styles;
+
+$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[8] = "fill:rgb(255,0,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[9] = "fill:rgb(255,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[10] = "fill:rgb(255,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[11] = "fill:rgb(128,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+
+my $mult = 950.0 / ($maxtime - $firsttime);
+my $threshold = ($maxtime - $firsttime) / 60.0;
+my $stylecounter = 0;
+while (($key,$value) = each %start) {
+	my $duration = $end{$key} - $start{$key};
+
+	if ($duration >= $threshold) {
+		my $s, $s2, $e, $y;
+		$s = ($value - $firsttime) * $mult;
+		$s2 = $s + 6;
+		$e = ($end{$key} - $firsttime) * $mult;
+		$w = $e - $s;
+
+		$y = $row{$key} * 150;
+		$y2 = $y + 4;
+
+		$style = $styles[$stylecounter];
+		$stylecounter = $stylecounter + 1;
+		if ($stylecounter > 11) {
+			$stylecounter = 0;
+		};
+
+		print "<rect x=\"$s\" width=\"$w\" y=\"$y\" height=\"145\" style=\"$style\"/>\n";
+		print "<text transform=\"translate($s2,$y2) rotate(90)\">$key</text>\n";
+	}
+}
+
+
+# print the time line on top
+my $time = $firsttime;
+my $step = ($maxtime - $firsttime) / 15;
+while ($time < $maxtime) {
+	my $s2 = ($time - $firsttime) * $mult;
+	my $tm = int($time * 100) / 100.0;
+	print "<text transform=\"translate($s2,89) rotate(90)\">$tm</text>\n";
+	$time = $time + $step;
+}
+
+print "</svg>\n";
