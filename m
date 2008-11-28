Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbYK1NsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbYK1NsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYK1NsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:48:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbYK1NsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:48:12 -0500
Date: Fri, 28 Nov 2008 14:47:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081128134754.GA30140@elte.hu>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org> <20081126201054.GB2624@localhost> <20081127134121.GA22736@elte.hu> <20081127141637.GQ6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127141637.GQ6703@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > But it gets worse than that: checking for _TIF_SYSCALL_TRACE is 
> > completely unnecessary here because we clear that flag for every 
> 
> That's true. I found your 2005 changeset which did that, [...]

that's irrelevant, because all the necessary TIF_ flag processing is 
already done in ret_from_sys_call.

The unnecessary TIF_SYSCALL_TRACE code in the 64-bit ret_from_fork was 
apparently added by you in 2002:

  +ENTRY(ret_from_fork)
  +       movq %rbx, %rdi
  +       call schedule_tail
  +       GET_THREAD_INFO(%rcx)
  +       bt $TIF_SYSCALL_TRACE,threadinfo_flags(%rcx)
  +       jc rff_trace

when you added it to x86_64 via the changeset quoted below.

at that time the 32-bit code (from which you copied the x86_64 tree, 
creating the whole split x86 trees approach) had this simple and 
straightforward ret_from_fork implementation:

  ENTRY(ret_from_fork)
  #if CONFIG_SMP
        pushl %ebx
        call SYMBOL_NAME(schedule_tail)
        addl $4, %esp
  #endif
        GET_THREAD_INFO(%ebx)
        jmp syscall_exit

so by all means the rff_trace/rff_action hack came from you.

	Ingo

------------------>
>From 0457d99a336be658cea1a5bdb689de5adb3b382d Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@muc.de>
Date: Tue, 12 Feb 2002 20:17:35 -0800
Subject: [PATCH] [PATCH] x86_64 merge: arch + asm

This adds the x86_64 arch and asm directories and a Documentation/x86_64.

It took a bit longer because I first had to make preemption and thread_info
work and also found some other bugs while doing this. The port has been
tested for a long time on UP.

I'm not sure what I should describe.  A lot is based on i386 with
a lot of cleanups. I wrote a paper about it for last year's OLS that describes
most of the changes (ftp://ftp.firstfloor.org/pub/ak/x86_64.ps.gz). It is
a bit outdated now, but should give a good overview.

It currently has a completely cut'n'pasted from others+hacked 32bit
emulation. I hope to clean that up in the future by merging the generic
core of this with other 64bit archs.

Thanks,
-Andi
---
 Documentation/x86_64/mm.txt             |  148 ++
 arch/x86_64/Config.help                 |  531 +++++
 arch/x86_64/Makefile                    |  130 ++
 arch/x86_64/boot/Makefile               |   92 +
 arch/x86_64/boot/bootsect.S             |  416 ++++
 arch/x86_64/boot/compressed/Makefile    |   43 +
 arch/x86_64/boot/compressed/head.S      |  142 ++
 arch/x86_64/boot/compressed/misc.c      |  431 ++++
 arch/x86_64/boot/compressed/miscsetup.h |   39 +
 arch/x86_64/boot/install.sh             |   39 +
 arch/x86_64/boot/setup.S                |  955 ++++++++
 arch/x86_64/boot/tools/build.c          |  189 ++
 arch/x86_64/boot/video.S                | 1934 ++++++++++++++++
 arch/x86_64/config.in                   |  240 ++
 arch/x86_64/defconfig                   |  568 +++++
 arch/x86_64/ia32/Makefile               |   18 +
 arch/x86_64/ia32/ia32_binfmt.c          |  165 ++
 arch/x86_64/ia32/ia32_ioctl.c           | 3843 +++++++++++++++++++++++++++++++
 arch/x86_64/ia32/ia32_signal.c          |  489 ++++
 arch/x86_64/ia32/ia32entry.S            |  365 +++
 arch/x86_64/ia32/ptrace32.c             |  312 +++
 arch/x86_64/ia32/socket32.c             |  686 ++++++
 arch/x86_64/ia32/sys_ia32.c             | 2788 ++++++++++++++++++++++
 arch/x86_64/kernel/Makefile             |   38 +
 arch/x86_64/kernel/apic.c               | 1160 ++++++++++
 arch/x86_64/kernel/bluesmoke.c          |  174 ++
 arch/x86_64/kernel/cpuid.c              |  177 ++
 arch/x86_64/kernel/early_printk.c       |   77 +
 arch/x86_64/kernel/entry.S              |  640 +++++
 arch/x86_64/kernel/head.S               |  342 +++
 arch/x86_64/kernel/head64.c             |   85 +
 arch/x86_64/kernel/i387.c               |  439 ++++
 arch/x86_64/kernel/i8259.c              |  485 ++++
 arch/x86_64/kernel/init_task.c          |   42 +
 arch/x86_64/kernel/io_apic.c            | 1617 +++++++++++++
 arch/x86_64/kernel/ioport.c             |  114 +
 arch/x86_64/kernel/irq.c                | 1198 ++++++++++
 arch/x86_64/kernel/ldt.c                |  177 ++
 arch/x86_64/kernel/mpparse.c            |  670 ++++++
 arch/x86_64/kernel/msr.c                |  279 +++
 arch/x86_64/kernel/mtrr.c               | 2310 +++++++++++++++++++
 arch/x86_64/kernel/nmi.c                |  272 +++
 arch/x86_64/kernel/pci-dma.c            |   33 +
 arch/x86_64/kernel/pci-irq.c            |  753 ++++++
 arch/x86_64/kernel/pci-pc.c             |  438 ++++
 arch/x86_64/kernel/pci-x86_64.c         |  384 +++
 arch/x86_64/kernel/pci-x86_64.h         |   72 +
 arch/x86_64/kernel/process.c            |  756 ++++++
 arch/x86_64/kernel/ptrace.c             |  435 ++++
 arch/x86_64/kernel/semaphore.c          |  225 ++
 arch/x86_64/kernel/setup.c              | 1128 +++++++++
 arch/x86_64/kernel/setup64.c            |  142 ++
 arch/x86_64/kernel/signal.c             |  591 +++++
 arch/x86_64/kernel/smp.c                |  584 +++++
 arch/x86_64/kernel/smpboot.c            | 1023 ++++++++
 arch/x86_64/kernel/sys_x86_64.c         |  113 +
 arch/x86_64/kernel/syscall.c            |   25 +
 arch/x86_64/kernel/time.c               |  494 ++++
 arch/x86_64/kernel/trampoline.S         |   72 +
 arch/x86_64/kernel/traps.c              |  771 +++++++
 arch/x86_64/kernel/vsyscall.c           |  190 ++
 arch/x86_64/kernel/x8664_ksyms.c        |  162 ++
 arch/x86_64/lib/Makefile                |   17 +
 arch/x86_64/lib/checksum_copy.S         |  142 ++
 arch/x86_64/lib/dec_and_lock.c          |   40 +
 arch/x86_64/lib/delay.c                 |   45 +
 arch/x86_64/lib/generic-checksum.c      |  124 +
 arch/x86_64/lib/getuser.S               |   90 +
 arch/x86_64/lib/iodebug.c               |   11 +
 arch/x86_64/lib/mmx.c                   |  377 +++
 arch/x86_64/lib/old-checksum.c          |   33 +
 arch/x86_64/lib/putuser.S               |   88 +
 arch/x86_64/lib/rwsem_thunk.S           |   27 +
 arch/x86_64/lib/usercopy.c              |  147 ++
 arch/x86_64/mm/Makefile                 |   13 +
 arch/x86_64/mm/extable.c                |   62 +
 arch/x86_64/mm/fault.c                  |  324 +++
 arch/x86_64/mm/init.c                   |  387 ++++
 arch/x86_64/mm/ioremap.c                |  163 ++
 arch/x86_64/tools/Makefile              |   31 +
 arch/x86_64/tools/offset.c              |   70 +
 arch/x86_64/tools/offset.sed            |    7 +
 arch/x86_64/vmlinux.lds                 |  112 +
 include/asm-x86_64/a.out.h              |   30 +
 include/asm-x86_64/apic.h               |  103 +
 include/asm-x86_64/apicdef.h            |  363 +++
 include/asm-x86_64/atomic.h             |  206 ++
 include/asm-x86_64/bitops.h             |  465 ++++
 include/asm-x86_64/boot.h               |   15 +
 include/asm-x86_64/bootsetup.h          |   34 +
 include/asm-x86_64/bugs.h               |   42 +
 include/asm-x86_64/byteorder.h          |   32 +
 include/asm-x86_64/cache.h              |   13 +
 include/asm-x86_64/calling.h            |  100 +
 include/asm-x86_64/checksum.h           |  158 ++
 include/asm-x86_64/cpufeature.h         |   73 +
 include/asm-x86_64/current.h            |   29 +
 include/asm-x86_64/debugreg.h           |   65 +
 include/asm-x86_64/delay.h              |   20 +
 include/asm-x86_64/desc.h               |  187 ++
 include/asm-x86_64/div64.h              |   14 +
 include/asm-x86_64/dma.h                |  298 +++
 include/asm-x86_64/e820.h               |   40 +
 include/asm-x86_64/elf.h                |  120 +
 include/asm-x86_64/errno.h              |  132 ++
 include/asm-x86_64/fcntl.h              |   79 +
 include/asm-x86_64/fixmap.h             |  105 +
 include/asm-x86_64/floppy.h             |  286 +++
 include/asm-x86_64/hardirq.h            |   93 +
 include/asm-x86_64/hdreg.h              |   12 +
 include/asm-x86_64/hw_irq.h             |  210 ++
 include/asm-x86_64/i387.h               |   87 +
 include/asm-x86_64/ia32.h               |  274 +++
 include/asm-x86_64/ia32_unistd.h        |  251 ++
 include/asm-x86_64/ide.h                |  128 +
 include/asm-x86_64/init.h               |    1 +
 include/asm-x86_64/io.h                 |  270 +++
 include/asm-x86_64/io_apic.h            |  148 ++
 include/asm-x86_64/ioctl.h              |   75 +
 include/asm-x86_64/ioctls.h             |   82 +
 include/asm-x86_64/ipc.h                |   32 +
 include/asm-x86_64/ipcbuf.h             |   29 +
 include/asm-x86_64/irq.h                |   35 +
 include/asm-x86_64/kdebug.h             |   23 +
 include/asm-x86_64/keyboard.h           |   71 +
 include/asm-x86_64/kmap_types.h         |   14 +
 include/asm-x86_64/ldt.h                |   37 +
 include/asm-x86_64/linux_logo.h         |   29 +
 include/asm-x86_64/locks.h              |  135 ++
 include/asm-x86_64/mc146818rtc.h        |   29 +
 include/asm-x86_64/mman.h               |   39 +
 include/asm-x86_64/mmu.h                |   13 +
 include/asm-x86_64/mmu_context.h        |   95 +
 include/asm-x86_64/mmx.h                |   14 +
 include/asm-x86_64/module.h             |   12 +
 include/asm-x86_64/mpspec.h             |  188 ++
 include/asm-x86_64/msgbuf.h             |   27 +
 include/asm-x86_64/msr.h                |  140 ++
 include/asm-x86_64/mtrr.h               |  127 +
 include/asm-x86_64/namei.h              |   17 +
 include/asm-x86_64/page.h               |  118 +
 include/asm-x86_64/param.h              |   24 +
 include/asm-x86_64/parport.h            |   18 +
 include/asm-x86_64/pci.h                |  273 +++
 include/asm-x86_64/pda.h                |   79 +
 include/asm-x86_64/pgalloc.h            |  258 +++
 include/asm-x86_64/pgtable.h            |  399 ++++
 include/asm-x86_64/poll.h               |   25 +
 include/asm-x86_64/posix_types.h        |  116 +
 include/asm-x86_64/prctl.h              |   10 +
 include/asm-x86_64/processor.h          |  463 ++++
 include/asm-x86_64/ptrace.h             |  114 +
 include/asm-x86_64/resource.h           |   47 +
 include/asm-x86_64/rwlock.h             |   84 +
 include/asm-x86_64/rwsem.h              |  217 ++
 include/asm-x86_64/scatterlist.h        |   13 +
 include/asm-x86_64/segment.h            |   19 +
 include/asm-x86_64/semaphore.h          |  216 ++
 include/asm-x86_64/sembuf.h             |   25 +
 include/asm-x86_64/serial.h             |  133 ++
 include/asm-x86_64/setup.h              |   10 +
 include/asm-x86_64/shmbuf.h             |   38 +
 include/asm-x86_64/shmparam.h           |    6 +
 include/asm-x86_64/sigcontext.h         |   97 +
 include/asm-x86_64/siginfo.h            |  232 ++
 include/asm-x86_64/signal.h             |  205 ++
 include/asm-x86_64/smp.h                |   98 +
 include/asm-x86_64/smplock.h            |   95 +
 include/asm-x86_64/socket.h             |   64 +
 include/asm-x86_64/socket32.h           |   70 +
 include/asm-x86_64/sockios.h            |   12 +
 include/asm-x86_64/softirq.h            |   34 +
 include/asm-x86_64/spinlock.h           |  181 ++
 include/asm-x86_64/stat.h               |   27 +
 include/asm-x86_64/statfs.h             |   25 +
 include/asm-x86_64/string.h             |   38 +
 include/asm-x86_64/system.h             |  283 +++
 include/asm-x86_64/termbits.h           |  172 ++
 include/asm-x86_64/termios.h            |  106 +
 include/asm-x86_64/thread_info.h        |  116 +
 include/asm-x86_64/timex.h              |   51 +
 include/asm-x86_64/tlb.h                |    1 +
 include/asm-x86_64/types.h              |   47 +
 include/asm-x86_64/uaccess.h            |  373 +++
 include/asm-x86_64/ucontext.h           |   12 +
 include/asm-x86_64/unaligned.h          |   37 +
 include/asm-x86_64/unistd.h             |  653 ++++++
 include/asm-x86_64/user.h               |  113 +
 include/asm-x86_64/user32.h             |   58 +
 include/asm-x86_64/vga.h                |   20 +
 include/asm-x86_64/vsyscall.h           |   48 +
 include/asm-x86_64/xor.h                |  859 +++++++
 192 files changed, 48138 insertions(+), 0 deletions(-)

