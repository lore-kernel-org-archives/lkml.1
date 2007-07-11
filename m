Return-Path: <linux-kernel-owner+w=401wt.eu-S1765629AbXGKTVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765629AbXGKTVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763413AbXGKTTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38241 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608AbXGKTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:11 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: x86 setup code rewrite in C - revised
Date: Wed, 11 Jul 2007 12:18:25 -0700
Message-Id: <1184181538674-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set replaces the x86 setup code, which is currently all in
assembly, with a version written in C, using the ".code16gcc" feature
of binutils (which has been present since at least 2001.)

The new code is vastly easier to read, and, I hope, debug.  It should
be noted that I found a fair number of minor bugs while going through
this code, and have attempted to correct them.

In the process of doing so, it introduces several cleanups, in
particular:

- Obsoletes the hd_info field in the boot_params structure; they are
  only ever used for ST-506 (pre-IDE) drives and are pretty much
  guaranteed to be wrong on current BIOSes;
- Unifies the CPU feature bits between i386 and x86-64.  In the
  future, it should be possible to use arch/i386/boot/cpucheck.c to do
  the post-invocation CPU check currently done in
  arch/x86_64/kernel/trampoline.S, although this patch set doesn't
  introduce that change.
- boot_params is now a proper structure.

This patchset incorporates all feedback received by 2007-07-11 12:00 PDT.

 arch/i386/boot/bootsect.S                     |   98 -
 arch/i386/boot/edd.S                          |  231 --
 arch/i386/boot/setup.S                        | 1075 -------------
 arch/i386/boot/video.S                        | 2043 --------------------------
 arch/i386/kernel/verify_cpu.S                 |   94 -
 arch/x86_64/boot/bootsect.S                   |   98 -
 arch/x86_64/boot/install.sh                   |    2 
 arch/x86_64/boot/mtools.conf.in               |   17 
 arch/x86_64/boot/setup.S                      |  826 ----------
 arch/x86_64/boot/tools/build.c                |  185 --
 b/Documentation/i386/zero-page.txt            |    1 
 b/MAINTAINERS                                 |    4 
 b/arch/i386/Kconfig.cpu                       |    6 
 b/arch/i386/boot/Makefile                     |   48 
 b/arch/i386/boot/a20.c                        |  161 ++
 b/arch/i386/boot/apm.c                        |   97 +
 b/arch/i386/boot/bitops.h                     |   45 
 b/arch/i386/boot/boot.h                       |  296 +++
 b/arch/i386/boot/cmdline.c                    |   97 +
 b/arch/i386/boot/code16gcc.h                  |   15 
 b/arch/i386/boot/compressed/Makefile          |    7 
 b/arch/i386/boot/compressed/head.S            |    6 
 b/arch/i386/boot/copy.S                       |  101 +
 b/arch/i386/boot/cpu.c                        |   69 
 b/arch/i386/boot/cpucheck.c                   |  267 +++
 b/arch/i386/boot/edd.c                        |  196 ++
 b/arch/i386/boot/header.S                     |  283 +++
 b/arch/i386/boot/main.c                       |  161 ++
 b/arch/i386/boot/mca.c                        |   43 
 b/arch/i386/boot/memory.c                     |   99 +
 b/arch/i386/boot/pm.c                         |  170 ++
 b/arch/i386/boot/pmjump.S                     |   54 
 b/arch/i386/boot/printf.c                     |  307 +++
 b/arch/i386/boot/setup.ld                     |   54 
 b/arch/i386/boot/string.c                     |   52 
 b/arch/i386/boot/tools/build.c                |  160 --
 b/arch/i386/boot/tty.c                        |  112 +
 b/arch/i386/boot/version.c                    |   23 
 b/arch/i386/boot/vesa.h                       |   79 +
 b/arch/i386/boot/video-bios.c                 |  125 +
 b/arch/i386/boot/video-vesa.c                 |  284 +++
 b/arch/i386/boot/video-vga.c                  |  260 +++
 b/arch/i386/boot/video.c                      |  456 +++++
 b/arch/i386/boot/video.h                      |  145 +
 b/arch/i386/boot/voyager.c                    |   46 
 b/arch/i386/kernel/cpu/Makefile               |    2 
 b/arch/i386/kernel/cpu/addon_cpuid_features.c |   50 
 b/arch/i386/kernel/cpu/common.c               |    2 
 b/arch/i386/kernel/cpu/proc.c                 |   21 
 b/arch/i386/kernel/e820.c                     |    2 
 b/arch/i386/kernel/setup.c                    |   12 
 b/arch/x86_64/Kconfig                         |    4 
 b/arch/x86_64/boot/Makefile                   |  136 -
 b/arch/x86_64/boot/compressed/Makefile        |    9 
 b/arch/x86_64/boot/compressed/head.S          |    6 
 b/arch/x86_64/kernel/Makefile                 |    2 
 b/arch/x86_64/kernel/setup.c                  |   21 
 b/arch/x86_64/kernel/verify_cpu.S             |   22 
 b/drivers/ide/legacy/hd.c                     |   73 
 b/include/asm-i386/boot.h                     |    6 
 b/include/asm-i386/bootparam.h                |   85 +
 b/include/asm-i386/cpufeature.h               |   26 
 b/include/asm-i386/e820.h                     |   14 
 b/include/asm-i386/processor.h                |    1 
 b/include/asm-i386/required-features.h        |   39 
 b/include/asm-i386/setup.h                    |   10 
 b/include/asm-x86_64/alternative.h            |   68 
 b/include/asm-x86_64/boot.h                   |   16 
 b/include/asm-x86_64/bootparam.h              |    1 
 b/include/asm-x86_64/cpufeature.h             |  115 -
 b/include/asm-x86_64/e820.h                   |    4 
 b/include/asm-x86_64/processor.h              |    3 
 b/include/asm-x86_64/required-features.h      |   46 
 b/include/asm-x86_64/segment.h                |    8 
 b/include/linux/edd.h                         |    4 
 b/include/linux/screen_info.h                 |    9 
 76 files changed, 4606 insertions(+), 5209 deletions(-)
