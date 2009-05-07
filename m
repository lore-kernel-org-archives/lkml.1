Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbZEGW1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbZEGW1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZEGW1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:08 -0400
Received: from mga06.intel.com ([134.134.136.21]:35559 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbZEGW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470405"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org
Subject: [PATCH 00/14] RFC: x86: relocatable kernel changes
Date: Thu,  7 May 2009 15:26:48 -0700
Message-Id: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is currently in -tip; the goal of it is to make the
semantics of the relocatable kernel fully the same as the
non-relocatable kernel when loaded by a relocating bootloader.  That
means CONFIG_PHYSICAL_START is honored to (a) be able to keep ZONE_DMA
free, and avoid the once-again-increasingly-common 15-16 MB hole
(don't ask me *why* this abortion is cropping up again, but I'm seeing
an increasing number of reports to the effect that it *is*) and (b) make
vmlinux match the runtime code in the normal case.

To deal with that constraint, CONFIG_PHYSICAL_START is taken as a
minimum address for the kernel.  Since a relocating bootloader may
have real reasons to load the kernel lower than that (for example,
because it has detected that it is on a small-memory system), this
adds two new fields to the bzImage header:

	runtime_start	- CONFIG_PHYSICAL_START
	runtime_size	- The contiguous memory space consumed by the kernel

The latter is the union of contiguous memory consumed by the kernel
during decompression and initialization; this is now possible thanks
to Jeremy's .brk patchset.  This isn't the same thing as the amount of
memory the kernel needs, but rather the amount of memory it will
assume that it can use before it starts to be able to read the memory
map.

The runtime_start field can be *written* by the bootloader if the
kernel is relocatable; e.g. by setting it to zero to indicate that the
load address should be used no matter what.

The physical address at which the kernel starts is now:

	align_up(max(load_address, runtime_start), kernel_alignment)

This seems to be the best possible compromise between the current
behaviors for relocatable and non-relocatable kernels.

This patchset also bumps up the default alignment to a PMD boundary (2
MB for x86-64 and PAE; 4 MB for !PAE).  I also change the default
CONFIG_PHYSICAL_START to 16 MB (4 MB for CONFIG_EMBEDDED).

The patchset also includes some plain optimizations.

 Documentation/x86/boot.txt             |   41 +++++++++
 arch/x86/Kconfig                       |   28 ++++--
 arch/x86/boot/Makefile                 |   24 ++++--
 arch/x86/boot/compressed/Makefile      |   51 +++--------
 arch/x86/boot/compressed/head_32.S     |  131 +++++++++++++---------------
 arch/x86/boot/compressed/head_64.S     |  129 ++++++++++++----------------
 arch/x86/boot/compressed/mkpiggy.c     |   97 +++++++++++++++++++++
 arch/x86/boot/compressed/vmlinux.lds.S |    1 +
 arch/x86/boot/compressed/vmlinux.scr   |   10 --
 arch/x86/boot/header.S                 |   21 ++++-
 arch/x86/configs/i386_defconfig        |  148 ++++++++++++++++++++++++-------
 arch/x86/configs/x86_64_defconfig      |  148 ++++++++++++++++++++++++--------
 arch/x86/include/asm/boot.h            |   13 +++-
 arch/x86/include/asm/bootparam.h       |    2 +
 arch/x86/kernel/asm-offsets_32.c       |    1 +
 arch/x86/kernel/asm-offsets_64.c       |    1 +
 scripts/Makefile.lib                   |   11 ++-
 scripts/bin_size                       |    8 ++-
 18 files changed, 575 insertions(+), 290 deletions(-)
