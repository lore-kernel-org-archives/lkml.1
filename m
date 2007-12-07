Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbXLGHyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbXLGHyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbXLGHyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:54:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:53438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbXLGHyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:54:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,265,1194249600"; 
   d="scan'208";a="423054518"
Subject: [PATCH 0/4 -mm] kexec based hibernation -v7
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Dec 2007 15:53:25 +0000
Message-Id: <1197042805.24045.60.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 07 Dec 2007 07:53:52.0733 (UTC) FILETIME=[4F5DC0D0:01C838A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

khibernation - kexec based hibernation


Kexec base hibernation has some potential advantages over u/swsusp and
TuxOnIce (suspend2). Some of them are as follow:

1. The hibernation image size can exceed half of memory size
   easily. This is possible with TuxOnIce, but impossible with
   u/swsusp.

2. It is possible to eliminate freezer from kexec based hibernation
   implementation, after corresponding changes to device drivers are
   done.

3. Based on kexec/kdump implementation, the kernel code needed is
   less.


Now, only the i386 architecture is supported. The patchset is based on
Linux kernel 2.6.24-rc4-mm1, and has been tested on IBM T42 with ACPI
on and off.


The following user-space tools are needed to implement hibernation and
resume.

1. kexec-tools needs to be patched to support khibernation. The patches
   and the precompiled kexec can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v7/kexec-tools/kexec-tools-src_git_kh7.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v7/kexec-tools/kexec-tools-patches_git_kh7.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v7/kexec-tools/kexec_git_kh7

2. makedumpfile with patches are used as memory image saving tool, it
   can exclude free pages from hibernation image file. The patches and
   the precompiled makedumpfile can be download from the following
   URL:
       source: http://khibernation.sourceforge.net/download/release_v7/makedumpfile/makedumpfile-src_cvs_kh7.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v7/makedumpfile/makedumpfile-patches_cvs_kh7.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v7/makedumpfile/makedumpfile_cvs_kh7

3. A simplest memory image restoring tool named "krestore" is
   implemented. It can be downloaded from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v7/krestore/krestore-src_cvs_kh7.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v7/krestore/krestore_cvs_kh7

4. A simplest jumping back image (hibernation image is a kind of
   jumping back image) parameter dump tool name "kjump_back_param" is
   implemented. It can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v7/kjump_back_param/kjump_back_param-src_cvs_kh7.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v7/kjump_back_param/kjump_back_param_cvs_kh7


An initramfs image is used as the root file system of
hibernating/resuming kernel. So, all user space tools above are needed
in initramfs. An initramfs image built with "BuildRoot" can be
downloaded from the following URL:
    initramfs image: http://khibernation.sourceforge.net/download/release_v7/initramfs/rootfs_cvs_kh7.gz


Usage:

1. Compile and install patched kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y # only needed by kexeced kernel to save/restore memory image
CONFIG_PM=y
CONFIG_HIBERNATION=y

2. Build an initramfs image contains all needed user space tools. Or,
   download the pre-built initramfs image.

3. Prepare a raw partition (without file system, called hibernating
   partition in following text) used to store memory image of
   hibernated kernel. Caution!!! The contents of the partition will be
   overwritten during hibernating.

4. Build a memory image of hibernating kernel. This memory image need
   only to be built once unless the hardware configuration is changed.

   4.1. Boot kernel compiled for normal usage (kernel A).

   4.2. Load kernel compiled for hibernating/resuming usage (kernel B)
        with kexec, the same kernel as that of 4 can be used if
        CONFIG_RELOCATABLE=y and CONFIG_CRASH_DUMP=y are selected.

        The --elf64-core-headers should be specified in command line
        of kexec, because only the 64bit ELF is supported by krestore
        tool. The "go_to_hibernate" should be specified in kernel
        command line to trigger the hibernating automatically. The
        major and minor device number of hibernating partition should
        be specified in kernel command line through "khdev=<ma>:<mi>".

        For example, the shell command line can be as follow:

        kexec --load-jump-back /boot/bzImage --mem-min=0x100000
        --mem-max=0xffffff --elf64-core-headers --append="khdev=3:7 go_to_hibernate"

   4.3. Jump to the hibernating kernel (kernel B) with following shell
       	command line:

       	kexec -e

   4.4. After normal boot process, the hibernation kernel will jump
   	back to hibernated kernel automatically. Then, the memory
   	image of hibernating kernel can be built with following shell
   	command line.

	cp /proc/kimgcore .

5. Boot kernel compiled for normal usage (kernel A).

6. Load the memory image of hibernating kernel with following shell
   command line:

   kexec -l --args-none --flags=0x3e kimgcore

7. Start the real hibernating process with following shell command line:

   kexec -e -c 0x6b630001

   The hibernating kernel will write the memory image of hibernated
   kernel and go to ACPI S4 state automatically.

8. Boot kernel (kernel C) compiled for hibernating/resuming usage in
   memory range of kernel B.

   The "go_to_resume" should be specified in kernel command line to
   trigger the resuming process automatically. For example, the
   following kernel command line parameters can be used:

   memmap=exactmap memmap=640K@0K memmap=15M@1M mem=16M go_to_resume khdev=3:7

   The initramfs should be used too. In GRUB, this can be specified
   with following grub command:

   initrd /boot/rootfs.gz

   The resuming kernel will restore the memory image of hibernated
   kernel and jump back to hibernated kernel automatically.


Known issues:

- The suspend/resume callback of device drivers are used to put
  devices into quiescent state. This will unnecessarily (possibly
  harmfully) put devices into low power state. This is intended to be
  solved by separating device quiesce/unquiesce callback from the
  device suspend/resume callback.

- The memory image of hibernated kernel must be saved in a separate
  partition not used by hibernated kernel. This is planned to be
  solved through making hibernating/resuming kernel write the memory
  image to a file in partition used by hibernated kernel through block
  list instead.

- The hibernating/resuming code are duplicated with current u/swsusp
  code. They will be merged when kexec based hibernation goes more
  stable.

- The setup of hibernate/resume is fairly complex. I will continue
  working on simplifying.


TODO:

- Write the memory image to a file through block list instead of
  ordinary file system operating.

- Merge duplicated code between kexec based hibernation and u/swsusp.

- Simplify hibernate/resume setup.

- Resume from hibernation with bootloader.


ChangeLog:

v7:

- Add an interface to dump the loaded kexec_image, which may contains
  the memory image of kexeced system. This is used to accelerate kexec
  based hibernation.

- Refactor kexec jump to be a command driven programming model.

- Adjust ACPI support to mimic the ACPI support of u/swsusp.

- Use kexec_lock to do synchronization.

v6:

- Add ACPI support.

- Refactor kexec jump to be a general facility to call real mode code.

v5:

- A flag (KEXEC_JUMP_BACK) is added to indicate the loaded kernel
  image is used for jumping back. The reboot command for jumping back
  is removed. This interface is more stable (proposed by Eric
  Biederman).

- NX bit handling support for kexec is added.

- Merge machine_kexec and machine_kexec_jump, remove NO_RET attribute
  from machine_kexec.

- Passing jump back entry to kexeced kernel via kernel command line
  (parsed by user space tool via /proc/cmdline instead of
  kernel). Original corresponding boot parameter and sysfs code is
  removed.

v4:

- Two reboot command are merged back to one because the underlying
  implementation is same.

- Jumping without reserving memory is implemented. As a side effect,
  two direction jumping is implemented.

- A jump back protocol is defined and documented. The original kernel
  and kexeced kernel are more independent from each other.

- The CPU state save/restore code are merged into relocate_kernel.S.

v3:

- The reboot command LINUX_REBOOT_CMD_KJUMP is split into to two
  reboot command to reflect the different function.

- Document is added for added kernel parameters.

- /sys/kernel/kexec_jump_buf_pfn is made writable, it is used for
  memory image restoring.

- Console restoring after jumping back is implemented.

- Writing support is added for /dev/oldmem, to restore memory contents
  of hibernated system.

v2:

- The kexec jump implementation is put into the kexec/kdump framework
  instead of software suspend framework. The device and CPU state
  save/restore code of software suspend is called when needed.

- The same code path is used for both kexec a new kernel and jump back
  to original kernel.

Best Regards,
Huang Ying
