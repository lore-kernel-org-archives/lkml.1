Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbXLUHjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbXLUHjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXLUHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:39:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:37935 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbXLUHjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:39:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,193,1196668800"; 
   d="scan'208";a="244169267"
Subject: [PATCH 0/3 -mm] kexec jump -v8
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Dec 2007 15:33:19 +0800
Message-Id: <1198222399.1965.15.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 21 Dec 2007 07:38:18.0283 (UTC) FILETIME=[742C7FB0:01C843A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset provides an enhancement to kexec/kdump. It implements
the following features:

- Backup/restore memory used both by the original kernel and the
  kexeced kernel.

- Jumping between the original kernel and the kexeced kernel.

- Read/write memory image of the kexeced kernel in the original kernel
  and write memory image of the original kernel in the kexeced
  kernel. This can be used as a communication method between the
  kexeced kernel and the original kernel.


The features of this patchset can be used as follow:

- Kernel/system debug through making system snapshot. You can make
  system snapshot, jump back, do some thing and make another system
  snapshot.

- A simple hibernation implementation without ACPI support. You can
  kexec a hibernating kernel, save the memory image of original system
  and shutdown the system. When resuming, you boot a resuming kernel
  in memory range of kexeced kernel, restore the memory image of
  original system and jump back.

- Cooperative multi-kernel/system. With kexec jump, you can switch
  between several kernels/systems quickly without boot process except
  the first time. This appears like swap a whole kernel/system out/in.

- A general method to call program in physical mode. This can be used
  to invoke some BIOS code under Linux.

- The basis of a full kexec based hibernation implementation with ACPI
  support. The full kexec based hibernation implementation is provided
  in another patchset named kexec based hibernation.


Now, only the i386 architecture is supported. The patchset is based on
Linux kernel 2.6.24-rc5-mm1, and has been tested on IBM T42 with ACPI
on and off.


The following user-space tools can be used with kexec jump.

1. kexec-tools needs to be patched to support kexec jump. The patches
   and the precompiled kexec can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v8/kexec-tools/kexec-tools-src_git_kh8.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v8/kexec-tools/kexec-tools-patches_git_kh8.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v8/kexec-tools/kexec_git_kh8

2. makedumpfile with patches are used as memory image saving tool, it
   can exclude free pages from original kernel memory image file. The
   patches and the precompiled makedumpfile can be download from the
   following URL:
       source: http://khibernation.sourceforge.net/download/release_v8/makedumpfile/makedumpfile-src_cvs_kh8.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v8/makedumpfile/makedumpfile-patches_cvs_kh8.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v8/makedumpfile/makedumpfile_cvs_kh8

3. A simplest memory image restoring tool named "krestore" is
   implemented. It can be downloaded from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v8/krestore/krestore-src_cvs_kh8.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v8/krestore/krestore_cvs_kh8

An initramfs image can be used as the root file system of kexeced
kernel. An initramfs image built with "BuildRoot" can be downloaded
from the following URL:
    initramfs image: http://khibernation.sourceforge.net/download/release_v8/initramfs/rootfs_cvs_kh8.gz
All user space tools above are included in the initramfs image.


Usage example of jumping between original and kexeced kernel:

1. Compile and install patched kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PM=y

2. Build an initramfs image contains kexec-tool, or download the
   pre-built initramfs image, called rootfs.gz in following text.

3. Boot kernel compiled in step 1.

4. Load kernel compiled in step 1 with /sbin/kexec. If You want to use
   "krestore" tool, the --elf64-core-headers should be specified in
   command line of /sbin/kexec. The shell command line can be as
   follow:

   /sbin/kexec --load-jump-back /boot/bzImage --mem-min=0x100000
     --mem-max=0xffffff --elf64-core-headers --initrd=rootfs.gz

5. Boot the kexeced kernel with following shell command line:

   /sbin/kexec -e

6. The kexeced kernel will boot as normal kexec. In kexeced kernel the
   memory image of original kernel can read via /proc/vmcore or
   /dev/oldmem, and can be written via /dev/oldmem. You can
   save/restore/modify it as you want to.

7. Prepare jumping back from kexeced kernel with following shell
   command lines:

   jump_back_entry=`cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '='`
   /sbin/kexec --load-jump-back-helper=$jump_back_entry

8. Jump back to the original kernel with following shell command line:

   /sbin/kexec -e

9. Now, you are in the original kernel again. You can read/write the
   memory image of kexeced kernel via /proc/kimgcore.

10. You can jump between the original kernel and kexeced kernel as you
    want to via the following shell command line:

    /sbin/kexec -e


Known issues:

- The suspend/resume callback of device drivers are used to put
  devices into quiescent state. This will unnecessarily (possibly
  harmfully) put devices into low power state. This is intended to be
  solved by separating device quiesce/unquiesce callback from the
  device suspend/resume callback.


ChangeLog:

v8:

- Split kexec jump patchset from kexec based hibernation patchset.

- Add writing support to kimgcore. This can be used as a communication
  method between kexeced kernel and original kernel.

- Merge various KEXEC_PRESERVE_* flags into one KEXEC_PRESERVE_CONTEXT
  because there is no need for such subtle control.

- Delete variable argument based "kernel to kernel" communication
  mechanism from basic kexec jump patchset.

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

