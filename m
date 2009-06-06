Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbZFFOnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbZFFOnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZFFOnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:43:01 -0400
Received: from verein.lst.de ([213.95.11.210]:47790 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbZFFOnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:43:00 -0400
Date: Sat, 6 Jun 2009 16:42:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Roland McGrath <roland@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/17] tracehook & user_regset for ARM
Message-ID: <20090606144243.GA8582@lst.de>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell, did you manage to take a look at this?

On Fri, Apr 24, 2009 at 05:06:34PM -0700, Roland McGrath wrote:
> The various things listed under CONFIG_HAVE_ARCH_TRACEHOOK (arch/Kconfig)
> are what each arch wants to do nowadays to fit with the generic code for
> user debugging, core dumping, etc.  The "big machine" arch's have done this
> since 2.6.28 or earlier.  
> 
> Christoph suggested helping ARM with the work would be a good way to
> encourage all the "little machine" arch maintainers to catch up soon.  
> (Of the "little machine" and oddball arch's, so far only sh has it.)
> 
> The following patches bring ARM up to speed with HAVE_ARCH_TRACEHOOK (just
> about).  There are so many patches because I sliced them into many small
> changes.  Each patch is pretty short (some of them very tiny).  The overall
> diffstat from the whole series is attached in the "pull request" below.
> 
> This series is relative to ~2.6.30-rc3 (0c8454f).  I expect it rebases
> easily to whatever tree you might want to queue it on.
> 
> The immediate user-visible effects of the series are to enable the
> /proc/pid/syscall feature, and to add VFP, WMMX, Crunch, and $tp register
> data to core dumps.
> 
> AFAIK only the asm/syscall.h patch still needs work.  The preliminary
> version is only buggy in the way that /proc/pid/syscall will give bogus
> answers for a task not really in a syscall, or for the non-EABI entry
> styles.  It's not unsafe or anything.  It needs some attention from folks
> who really know ARM to fill in the truly proper version of syscall_get_nr().
> 
> I only know how to run and test one ABI flavor, and only in qemu.  I used
> versatile_defconfig and ran it in qemu-system-arm -M versatilepb using NFS
> root with the userland binaries from Fedora ARM.  
> 
> I don't know how to simulate hardware that has iWMMXt or Crunch, nor if my
> ARM userland handles those kernel configurations.  So I've only
> (cross-)compile-tested the iWMMXt and Crunch code.  (It is however the
> simplest of the user_regset code and pretty easy to eyeball-review.)
> 
> My testing is quite minimal.  Booted, nothing went wrong, simple strace
> uses still look sane, "cat /proc/self/syscall" looks right, core dump
> contents look right.  (Not knowing the arch at all, I don't actually know
> how to put anything in the FPA or VFP registers so as to notice they are
> right rather than just the right number of zeros.)  The userland I have
> does not have gdb (and qemu would take a week to build and run the gdb
> testsuite if it did), so I didn't try to test any ptrace use beyond what
> strace does.
> 
> 
> Thanks,
> Roland
> 
> ---
> 
> The following changes since commit 0c8454f56623505a99463405fd7d5664adfbb094:
>   Rafael J. Wysocki (1):
>         PM/Hibernate: Fix waiting for image device to appear on resume
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git arm/tracehook
> 
> Roland McGrath (17):
>       arm: arch_ptrace clean-up
>       arm: arch_ptrace indentation
>       arm: tracehook_report_syscall
>       arm: tracehook_signal_handler
>       arm: TIF_NOTIFY_RESUME
>       arm: user_regset: general regs
>       arm: user_regset: FPU regs
>       arm: CORE_DUMP_USE_REGSET
>       arm: user_regset: VFP regs
>       arm: user_regset: VFP in core dumps
>       arm: user_regset: iWMMXt regs
>       arm: user_regset: iWMMXt in core dumps
>       arm: user_regset: Crunch regs
>       arm: user_regset: Crunch in core dumps
>       arm: user_regset: thread pointer in core dumps
>       arm: asm/syscall.h (unfinished)
>       arm: HAVE_ARCH_TRACEHOOK
> 
>  arch/arm/Kconfig                   |    1 +
>  arch/arm/include/asm/elf.h         |    1 +
>  arch/arm/include/asm/ptrace.h      |    4 +-
>  arch/arm/include/asm/syscall.h     |   65 +++++
>  arch/arm/include/asm/thread_info.h |    4 +
>  arch/arm/kernel/entry-common.S     |    2 +-
>  arch/arm/kernel/ptrace.c           |  526 ++++++++++++++++++++++++------------
>  arch/arm/kernel/signal.c           |    7 +
>  include/linux/elf.h                |    3 +
>  9 files changed, 433 insertions(+), 180 deletions(-)
>  create mode 100644 arch/arm/include/asm/syscall.h
---end quoted text---
