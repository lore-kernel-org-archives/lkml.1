Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXITFcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXITFcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 01:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbXITFcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 01:32:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:15525 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbXITFcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 01:32:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,276,1186383600"; 
   d="scan'208";a="299061558"
Subject: [RFC][PATCH 0/2 -mm] kexec based hibernation -v3
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Sep 2007 13:34:00 +0800
Message-Id: <1190266440.21818.16.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 20 Sep 2007 05:32:02.0160 (UTC) FILETIME=[9272DF00:01C7FB47]
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


This patch set implements the kexec based hibernation. The kernel
functionality added are as follow:

1. Jumping between the kexeced kernel and the original kernel. This is
   used by hibernation to save/load necessary state in original kernel
   and jumping back to original kernel after restore the memory of
   original kernel.

2. Add writing support to /dev/oldmem. This is used by hibernation to
   restore the memory of original kernel.


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
       source: http://khibernation.sourceforge.net/download/release_20070920/kexec-tools/kexec-tools-src_20070920.tar.gz
       patches: http://khibernation.sourceforge.net/download/release_20070920/kexec-tools/kexec-tools-patches_20070920.tar.gz
       binary: http://khibernation.sourceforge.net/download/release_20070920/kexec-tools/kexec_20070920.tar.gz

2. Memory image saving tool. Currently, the memory image saving is
   done through: "cp /proc/vmcore <image file>". This will save all
   memory pages of original kernel including the free pages. Maybe the
   crash dump tool "makedumpfile" can be used for this, but it has not
   been tested.

3. Memory image restore tool. A simplest memory image restoring tool
   named "krestore" is implemented. It can be downloaded from the
   following URL:
       source: http://khibernation.sourceforge.net/download/release_20070920/krestore/krestore-src_20070920.tar.gz
       binary: http://khibernation.sourceforge.net/download/release_20070920/krestore/krestore_20070920.tar.gz


Known issues:

1. The CONFIG_ACPI must be turned off to make kexec jump work. Because
   ACPI will put devices into low power state, the kexeced kernel can
   not be booted properly under it. This constrains can be eliminated
   by separating the suspend method and hibernate method of the
   devices as proposed earlier in the LKML.

2. The setup of hibernation/restore is fairly complex. I will continue
   working on simplifying.

3. Memory pages including free pages of kernel A are saved. I think
   the "makedumpfile" tool can be used to exclude "free pages", but I
   have not tested it.


Now, only the i386 architecture is supported. The patch is based on
Linux kernel 2.6.23-rc6-mm1, and has been tested on my IBM T42.


Usage:

1. Compile kernel with following options selected:

CONFIG_X86_32=y
CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y # only needed by kexeced kernel to save/restore memory image
CONFIG_PM=y
CONFIG_KEXEC_JUMP=y

2. Download the kexec-tools-testing git tree, apply the kexec-tools
   kjump patches (or download the source tar ball directly) and
   compile.

3. Download and compile the krestore tool.

4. Prepare 2 root partition used by kernel A and kernel B/C, referred
   as /dev/hda, /dev/hdb in following text. This is not strictly
   necessary, I use this scheme for testing during development.

5. Boot kernel compiled for normal usage (kernal A).

6. Load kernel compiled for hibernating/restore usage (kernel B) with
   kexec, the same kernel as that of 5 can be used if
   CONFIG_RELOCATABLE=y and CONFIG_CRASH_DUMP=y are selected.

   The --elf64-core-headers should be specified in command line of
   kexec, because only the 64bit ELF is supported by krestore tool.

   For example, the shell command line can be as follow:

   kexec -p -n /boot/bzImage --mem-min=0x100000 --mem-max=0xffffff
       --elf64-core-headers --append="root=/dev/hdb single"

7. Jump to the hibernating kernel (kernel B) with following shell
   command line:

   kexec -j

8. In the hibernating kernel (kernel B), the memory image of
   hibernated kernel (kernel A) can be saved as follow:

   cp /proc/vmcore .
   cp /sys/kernel/kexec_jump_back_entry .

9. Shutdown or reboot in hibernating kernel (kernel B).

10. Boot kernel (kernel C) compiled for hibernating/restore usage on
    the root file system /dev/hdb in memory range of kernel B.

    For example, the following kernel command line parameters can be
    used:

    root=/dev/hdb single memmap=exactmap memmap=640K@0K memmap=15M@1M

11. In restore kernel (kernel C), the memory image of kernel A can be
    restored as follow:

    cp kexec_jump_back_entry /sys/kernel/kexec_jump_back_entry
    krestore vmcore

12. Jump back to hibernated kernel (kernel A)

    kexec -b

Best Regards,
Huang Ying
