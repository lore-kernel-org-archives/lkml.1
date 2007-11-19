Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbXKSHBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbXKSHBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 02:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXKSHAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 02:00:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:27414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbXKSHAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 02:00:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,435,1188802800"; 
   d="scan'208";a="234776730"
Subject: [PATCH 0/3 -mm] kexec based hibernation -v6
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Nov 2007 15:02:38 +0800
Message-Id: <1195455758.10291.23.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 19 Nov 2007 06:58:46.0524 (UTC) FILETIME=[A146CBC0:01C82A79]
Sender: linux-kernel-owner@vger.kernel.org
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
Linux kernel 2.6.24-rc2-mm1, and has been tested on IBM T42 with ACPI
on and off.


The following user-space tools are needed to implement hibernation and
resume.

1. kexec-tools needs to be patched to support khibernation. The patches
   and the precompiled kexec can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v6/kexec-tools/kexec-tools-src_git_kh6.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v6/kexec-tools/kexec-tools-patches_git_kh6.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v6/kexec-tools/kexec_git_kh6

2. makedumpfile with patches are used as memory image saving tool, it
   can exclude free pages from hibernation image file. The patches and
   the precompiled makedumpfile can be download from the following
   URL:
       source: http://khibernation.sourceforge.net/download/release_v6/makedumpfile/makedumpfile-src_cvs_kh6.tar.bz2
       patches: http://khibernation.sourceforge.net/download/release_v6/makedumpfile/makedumpfile-patches_cvs_kh6.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v6/makedumpfile/makedumpfile_cvs_kh6

3. A simplest memory image restoring tool named "krestore" is
   implemented. It can be downloaded from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v6/krestore/krestore-src_cvs_kh6.tar.bz2
       binary: http://khibernation.sourceforge.net/download/release_v6/krestore/krestore_cvs_kh6

4. A simplest jumping back image (hibernation image is a kind of
   jumping back image) parameter dump tool name "kjump_back_param" is
   implemented. It can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v6/kjump_back_param/kjump_back_param-src_cvs_kh6.tar.bz2
       source: http://khibernation.sourceforge.net/download/release_v6/kjump_back_param/kjump_back_param_cvs_kh6


Usage:

1. Compile and install patched kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y # only needed by kexeced kernel to save/restore memory image
CONFIG_PM=y
CONFIG_HIBERNATION=y

2. Download, compile and install needed user-space tools. You can
   download the git/cvs version and apply the patches, or download the
   source tar ball directly. Required user-space tool include
   kexec-tools, makedumpfile, krestore and kjump_back_param.

3. Prepare 2 root partition used by kernel A and kernel B/C, referred
   to as /dev/hda, /dev/hdb in following text. This is not strictly
   necessary, I use this setup for testing during development.

4. Boot kernel compiled for normal usage (kernel A).

5. Load kernel compiled for hibernating/resuming usage (kernel B) with
   kexec, the same kernel as that of 4 can be used if
   CONFIG_RELOCATABLE=y and CONFIG_CRASH_DUMP=y are selected.

   The --elf64-core-headers should be specified in command line of
   kexec, because only the 64bit ELF is supported by krestore tool.

   For example, the shell command line can be as follow:

   kexec --load-jump-back /boot/bzImage --mem-min=0x100000 --mem-max=0xffffff
       --elf64-core-headers --append="root=/dev/hdb single"

6. Jump to the hibernating kernel (kernel B) with following shell
   command line:

   kexec -e

7. In the hibernating kernel (kernel B), jump back to hibernated
   kernel (kernel A) with following shell command line:

   cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '=' -f 2 > kexec_jump_back_entry
   kexec --load-jump-back-helper --jump-back-entry=`cat kexec_jump_back_entry`
   kexec -e

   In step 6 and 7, the hibernating kernel (kernel B) is booted
   without disturbing the ACPI state.

8. In the to be hibernated kernel (kernel A), start the real
   hibernating process with following shell command line:

   kexec --hibernate

   The to be hibernated kernel will execute necessary ACPI methods and
   jump to hibernating kernel (kernel B) again.

9. In the hibernating kernel (kernel B), the memory image of
   hibernated kernel (kernel A) can be saved as follow:

   kjump_back_param -j `cat kexec_jump_back_entry` /proc/vmcore > jump_back_param
   grep arg2 jump_back_param | cut -d '=' -f 2 > backup_pages_map_root_entry
   vmcoreinfo_addr=`grep arg3 jump_back_param | cut -d '=' -f 2`
   vmcoreinfo_size=`grep arg4 jump_back_param | cut -d '=' -f 2`
   ./makedumpfile -D -E -d 16 -o $vmcoreinfo_size@$vmcoreinfo_addr -j `cat kexec_jump_back_entry` -M `cat backup_pages_map_root_entry` /proc/vmcore dump.elf

10. Entering ACPI S4 state with following command line:

    kexec -e -c 0x6b630002

    The hibernating kernel (kernel B) will jump back to hibernated
    kernel again with a special command (0x6b630002: hibernate shut
    down), and the hibernated kernel (kernel A) will entering ACPI S4
    state.

11. Boot kernel (kernel C) compiled for hibernating/resuming usage on
    the root file system /dev/hdb in memory range of kernel B.

    For example, the following kernel command line parameters can be
    used:

    root=/dev/hdb single memmap=exactmap memmap=640K@0K memmap=15M@1M

12. In resuming kernel (kernel C), the memory image of kernel A can be
    restored as follow:

    krestore dump.elf

13. Resume the hibernated kernel (kernel A)

    kexec --load-jump-back-helper --jump-back-entry=`cat kexec_jump_back_entry`
    kexec --resume

    The resuming kernel (kernel C) will jump back to hibernating
    kernel (kernel A), and necessary ACPI methods will be executed.


Known issues:

- The suspend/resume callback of device drivers are used to put
  devices into quiescent state. This will unnecessarily (possibly
  harmfully) put devices into low power state. This is intended to be
  solved by separating device quiesce/unquiesce callback from the
  device suspend/resume callback.

- The memory image of hibernated kernel must be saved in a separate
  partition not used by hibernated kernel. This is planned to be
  solved through make hibernating/resuming kernel work on initramfs
  and write the memory image to a file in partition used by hibernated
  kernel through block list instead of ordinary file system operating.

- The setup of hibernate/resume is fairly complex. I will continue
  working on simplifying.


TODO:

- Implement sys_kexec_store, that is, store the memory image of
  kexeced kernel.

- Write the memory image to a file through block list instead of
  ordinary file system operating.

- Simplify hibernate/resume setup.

- Resume from hibernation with bootloader.


ChangeLog:

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
