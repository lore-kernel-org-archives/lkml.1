Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbXJKCNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbXJKCNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 22:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXJKCMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 22:12:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:52019 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbXJKCMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 22:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,256,1188802800"; 
   d="scan'208";a="169309913"
Subject: [PATCH 0/2 -mm] kexec based hibernation -v5
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Oct 2007 10:13:53 +0800
Message-Id: <1192068833.27482.13.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 11 Oct 2007 02:11:42.0404 (UTC) FILETIME=[10CA6840:01C80BAC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec base hibernation has some potential advantages over uswsusp and
TuxOnIce (suspend2). Some most obvious advantages are:

1. The hibernation image size can exceed half of memory size easily.

2. The hibernation image can be written to and read from almost
   anywhere, such as USB disk, NFS.

3. It is possible to eliminate freezer from kexec based hibernation
   implementation.

4. Based on kexec/kdump implementation, the kernel code needed is
   less.


The hibernation procedure with the patch set is as follow:

1. Boot a kernel A

2. Work under kernel A

3. Kexec another kernel B (crash dump enabled) in kernel A.

4. Save the memory image of kernel A through crash dump (such as "cp
   /proc/vmcore ~"). Save the "jump back entry".

5. Shutdown or reboot


The restore process with the patch set is as follow:

1. Boot a kernel C (crash dump enabled), the memory area used by
   kernel C must be a subset of memory area used by kernel B.

2. Restore the memory image of kernel A through /dev/oldmem. Restore
   the "jump back entry".

3. Jump from kernel C back to kernel A

4. Continue work under kernel A


The following user-space tools are needed to implement hibernation and
restore.

1. kexec-tools needs to be patched to support kexec jump. The patches
   and the precompiled kexec can be download from the following URL:
       source: http://khibernation.sourceforge.net/download/release_v5/kexec-tools/kexec-tools-src_v5.tar.gz
       patches: http://khibernation.sourceforge.net/download/release_v5/kexec-tools/kexec-tools-patches_v5.tar.gz
       binary: http://khibernation.sourceforge.net/download/release_v5/kexec-tools/kexec_v5.tar.gz

2. Memory image saving tool. Currently, the memory image saving is
   done through: "cp /proc/vmcore <image file>". This will save all
   memory pages of original kernel including the free pages. Maybe the
   crash dump tool "makedumpfile" can be used for this, but it has not
   been tested.

3. Memory image restore tool. A simplest memory image restoring tool
   named "krestore" is implemented. It can be downloaded from the
   following URL:
       source: http://khibernation.sourceforge.net/download/release_v5/krestore/krestore-src_v5.tar.gz
       binary: http://khibernation.sourceforge.net/download/release_v5/krestore/krestore_v5.tar.gz


Usage:

1. Compile kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y # only needed by kexeced kernel to save/restore memory image
CONFIG_PM=y

2. Download the kexec-tools-testing git tree, apply the kexec-tools
   kjump patches (or download the source tar ball directly) and
   compile.

3. Download and compile the krestore tool.

4. Prepare 2 root partition used by kernel A and kernel B/C, referred
   as /dev/hda, /dev/hdb in following text. This is not strictly
   necessary, I use this scheme for testing during development.

5. Boot kernel compiled for normal usage (kernel A).

6. Load kernel compiled for hibernating/restore usage (kernel B) with
   kexec, the same kernel as that of 5 can be used if
   CONFIG_RELOCATABLE=y and CONFIG_CRASH_DUMP=y are selected.

   The --elf64-core-headers should be specified in command line of
   kexec, because only the 64bit ELF is supported by krestore tool.

   For example, the shell command line can be as follow:

   kexec --load-jump-back /boot/bzImage --mem-min=0x100000 --mem-max=0xffffff
       --elf64-core-headers --append="root=/dev/hdb single"

7. Jump to the hibernating kernel (kernel B) with following shell
   command line:

   kexec -e

8. In the hibernating kernel (kernel B), the memory image of
   hibernated kernel (kernel A) can be saved as follow:

   cp /proc/vmcore .
   cat /proc/cmdline | tr ' ' '\n' | grep kexec_jump_back_entry | cut -d '=' -f 2 > kexec_jump_back_entry

9. Shutdown or reboot in hibernating kernel (kernel B).

10. Boot kernel (kernel C) compiled for hibernating/restore usage on
    the root file system /dev/hdb in memory range of kernel B.

    For example, the following kernel command line parameters can be
    used:

    root=/dev/hdb single memmap=exactmap memmap=640K@0K memmap=15M@1M

11. In restore kernel (kernel C), the memory image of kernel A can be
    restored as follow:

    krestore vmcore

12. Jump back to hibernated kernel (kernel A)

    kexec -b --jump-back-entry=`cat kexec_jump_back_entry`


Known issues:

- To comply with the ACPI specification, some ACPI methods must be
  invoked before and after hibernation, and machine should be put in
  S4 state instead of shutdown.

- The setup of hibernation/restore is fairly complex. I will continue
  working on simplifying.

- Memory pages including free pages of kernel A are saved. I think the
  "makedumpfile" tool can be used to exclude "free pages", but I have
  not tested it.


Now, only the i386 architecture is supported. The patch set is based
on Linux kernel 2.6.23-rc8-mm2, and has been tested on IBM T42 with
ACPI on and off.


ChangeLog:

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
