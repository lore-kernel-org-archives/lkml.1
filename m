Return-Path: <linux-kernel-owner+w=401wt.eu-S936444AbYEVJhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936444AbYEVJhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933984AbYEVJhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:37:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:55064 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935175AbYEVJhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:37:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,524,1204531200"; 
   d="scan'208";a="250643718"
Subject: [PATCH 2/2] kexec jump -v10: save/restore device state
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 22 May 2008 17:38:19 +0800
Message-Id: <1211449099.12819.15.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 22 May 2008 09:37:25.0834 (UTC) FILETIME=[71A5FAA0:01C8BBEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements devices state save/restore before after kexec.


This patch together with features in kexec_jump patch can be used for
following:

- A simple hibernation implementation without ACPI support. You can
  kexec a hibernating kernel, save the memory image of original system
  and shutdown the system. When resuming, you restore the memory image
  of original system via ordinary kexec load then jump back.

- Kernel/system debug through making system snapshot. You can make
  system snapshot, jump back, do some thing and make another system
  snapshot.

- Cooperative multi-kernel/system. With kexec jump, you can switch
  between several kernels/systems quickly without boot process except
  the first time. This appears like swap a whole kernel/system out/in.

- A general method to call program in physical mode (paging turning
  off). This can be used to invoke BIOS code under Linux.


The following user-space tools can be used with kexec jump:

- kexec-tools needs to be patched to support kexec jump. The patches
  and the precompiled kexec can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-src_git_kh10.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec-tools-patches_git_kh10.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v10/kexec-tools/kexec_git_kh10

- makedumpfile with patches are used as memory image saving tool, it
  can exclude free pages from original kernel memory image file. The
  patches and the precompiled makedumpfile can be download from the
  following URL:
       source: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile-src_cvs_kh10.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile-patches_cvs_kh10.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v10/makedumpfile/makedumpfile_cvs_kh10

- An initramfs image can be used as the root file system of kexeced
  kernel. An initramfs image built with "BuildRoot" can be downloaded
  from the following URL:
       initramfs image: http://khibernation.sourceforge.net/download/release_v10/initramfs/rootfs_cvs_kh10.gz
  All user space tools above are included in the initramfs image.


Usage example of simple hibernation:

1. Compile and install patched kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PM=y

2. Build an initramfs image contains kexec-tool and makedumpfile, or
   download the pre-built initramfs image, called rootfs.gz in
   following text.

3. Prepare a partition to save memory image of original kernel, called
   hibernating partition in following text.

4. Boot kernel compiled in step 1 (kernel A).

5. In the kernel A, load kernel compiled in step 1 (kernel B) with
   /sbin/kexec. The shell command line can be as follow:

   /sbin/kexec --load-preserve-context /boot/bzImage --mem-min=0x100000
     --mem-max=0xffffff --initrd=rootfs.gz

6. Boot the kernel B with following shell command line:

   /sbin/kexec -e

7. The kernel B will boot as normal kexec. In kernel B the memory
   image of kernel A can be saved into hibernating partition as
   follow:

   jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
   echo $jump_back_entry > kexec_jump_back_entry
   cp /proc/vmcore dump.elf

   Then you can shutdown the machine as normal.

8. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
   root file system.

9. In kernel C, load the memory image of kernel A as follow:

   /sbin/kexec -l --args-none --entry=`cat kexec_jump_back_entry` dump.elf

10. Jump back to the kernel A as follow:

   /sbin/kexec -e

   Then, kernel A is resumed.


Implementation point:

To support jumping between two kernels, before jumping to (executing)
the new kernel and jumping back to the original kernel, the devices
are put into quiescent state, and the state of devices and CPU is
saved. After jumping back from kexeced kernel and jumping to the new
kernel, the state of devices and CPU are restored accordingly. The
devices/CPU state save/restore code of software suspend is called to
implement corresponding function.


Known issues:

- Can not work with the new devices hibernation operations in
  2.6.26-rc2-mm1 so far. Working on this now.

- APIC is not put into legacy mode during kexec, so kexec may failed
  (no IRQ) if APIC is not put into legacy mode.

- The suspend/resume callback of device drivers are used to put
  devices into quiescent state. This will unnecessarily (possibly
  harmfully) put devices into low power state. This is intended to be
  solved by separating device quiesce/unquiesce callback from the
  device suspend/resume callback.

- Because the segment number supported by sys_kexec_load is limited,
  hibernation image with many segments may not be load. This is
  planned to be eliminated by adding a new flag to sys_kexec_load to
  make a image can be loaded with multiple sys_kexec_load invoking.


ChangeLog:

v10:

- Split from original kexec_jump patch.


Now, only the i386 architecture is supported. The patchset is based on
Linux kernel 2.6.26-rc3, and has been tested on IBM T42 with ACPI on
and off.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/linux/suspend.h |    2 ++
 kernel/kexec.c          |   43 ++++++++++++++++++++++++++++++++++++++++++-
 kernel/power/power.h    |    2 --
 3 files changed, 44 insertions(+), 3 deletions(-)

--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -25,6 +25,10 @@
 #include <linux/utsname.h>
 #include <linux/numa.h>
 #include <linux/suspend.h>
+#include <linux/freezer.h>
+#include <linux/pm.h>
+#include <linux/cpu.h>
+#include <linux/console.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1427,8 +1431,34 @@ module_init(crash_save_vmcoreinfo_init)
 
 int kexec_jump(struct kimage *image)
 {
+	int error = 0;
+
+	mutex_lock(&pm_mutex);
 	if (image->preserve_context) {
+		pm_prepare_console();
+		error = freeze_processes();
+		if (error) {
+			error = -EBUSY;
+			goto Exit;
+		}
+		suspend_console();
+		error = device_suspend(PMSG_FREEZE);
+		if (error)
+			goto Resume_console;
+		error = disable_nonboot_cpus();
+		if (error)
+			goto Resume_devices;
 		local_irq_disable();
+		/* At this point, device_suspend() has been called,
+		 * but *not* device_power_down(). We *must*
+		 * device_power_down() now.  Otherwise, drivers for
+		 * some devices (e.g. interrupt controllers) become
+		 * desynchronized with the actual state of the
+		 * hardware at resume time, and evil weirdness ensues.
+		 */
+		error = device_power_down(PMSG_FREEZE);
+		if (error)
+			goto Enable_irqs;
 		save_processor_state();
 	}
 
@@ -1436,7 +1466,18 @@ int kexec_jump(struct kimage *image)
 
 	if (image->preserve_context) {
 		restore_processor_state();
+		device_power_up();
+ Enable_irqs:
 		local_irq_enable();
+		enable_nonboot_cpus();
+ Resume_devices:
+		device_resume();
+ Resume_console:
+		resume_console();
+		thaw_processes();
+ Exit:
+		pm_restore_console();
 	}
-	return 0;
+	mutex_unlock(&pm_mutex);
+	return error;
 }
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -53,8 +53,6 @@ extern int hibernation_platform_enter(vo
 
 extern int pfn_is_nosave(unsigned long);
 
-extern struct mutex pm_mutex;
-
 #define power_attr(_name) \
 static struct kobj_attribute _name##_attr = {	\
 	.attr	= {				\
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -266,4 +266,6 @@ static inline void register_nosave_regio
 }
 #endif
 
+extern struct mutex pm_mutex;
+
 #endif /* _LINUX_SUSPEND_H */

