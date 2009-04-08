Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbZDHH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbZDHH1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762525AbZDHH1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:27:17 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:55578 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762410AbZDHH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:27:09 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 5/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFF5E28D28.E883ABAB-ON48257592.00289D17-48257592.0028E4C4@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:24:31 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:24:32,
	Serialize complete at 2009/04/08 ?? 03:24:32
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

asm/ptrace.h, asm/resource.h, asm/scatterlist.h, asm/scoreregs.h,
asm/sections.h, asm/sembuf.h, asm/setup.h, asm/shmbuf.h, asm/shmparam.h,
asm/sigcontext.h, asm/siginfo.h, asm/signal.h, asm/socket.h,
asm/sockios.h, asm/statfs.h, asm/stat.h, asm/string.h, asm/swab.h,
asm/system.h and asm/termbits.h for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ptrace.h 
linux-2.6-git.new/arch/score/include/asm/ptrace.h
--- linux-2.6-git.ori/arch/score/include/asm/ptrace.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ptrace.h   2009-04-07 
20:53:50.000000000 +0800
@@ -0,0 +1,89 @@
+#ifndef __SCORE_PTRACE_H
+#define __SCORE_PTRACE_H
+
+#define PC             32
+#define CONDITION      33
+#define ECR            34
+#define EMA            35
+#define CEH            36
+#define CEL            37
+#define COUNTER                38
+#define LDCR           39
+#define STCR           40
+#define PSR            41
+
+#define SINGLESTEP16_INSN      0x7006
+#define SINGLESTEP32_INSN      0x840C8000
+#define BREAKPOINT16_INSN      0x7002          /* work on SPG300 */
+#define BREAKPOINT32_INSN      0x84048000      /* work on SPG300 */
+
+/* Define instruction mask */
+#define INSN32_MASK    0x80008000
+
+#define J32    0x88008000      /* 1_00010_0000000000_1_000000000000000 */
+#define J32M   0xFC008000      /* 1_11111_0000000000_1_000000000000000 */
+
+#define B32    0x90008000      /* 1_00100_0000000000_1_000000000000000 */
+#define B32M   0xFC008000
+#define BL32   0x90008001      /* 1_00100_0000000000_1_000000000000001 */
+#define BL32M  B32
+#define BR32   0x80008008      /* 1_00000_0000000000_1_00000000_000100_0 
*/
+#define BR32M  0xFFE0807E
+#define BRL32  0x80008009      /* 1_00000_0000000000_1_00000000_000100_1 
*/
+#define BRL32M BR32M
+
+#define B32_SET        (J32 | B32 | BL32 | BR32 | BRL32)
+
+#define J16    0x3000          /* 0_011_....... */
+#define J16M   0xF000
+#define B16    0x4000          /* 0_100_....... */
+#define B16M   0xF000
+#define BR16   0x0004          /* 0_000.......0100 */
+#define BR16M  0xF00F
+#define B16_SET (J16 | B16 | BR16)
+
+
+/*
+ * This struct defines the way the registers are stored on the stack 
during a
+ * system call/exception. As usual the registers k0/k1 aren't being 
saved.
+ */
+struct pt_regs {
+       unsigned long pad0[6];
+       unsigned long orig_r4;
+       unsigned long orig_r7;
+       unsigned long regs[32];
+
+       unsigned long cel;
+       unsigned long ceh;
+
+       unsigned long sr0;      /* cnt */
+       unsigned long sr1;      /* lcr */
+       unsigned long sr2;      /* scr */
+
+       unsigned long cp0_epc;
+       unsigned long cp0_ema;
+       unsigned long cp0_psr;
+       unsigned long cp0_ecr;
+       unsigned long cp0_condition;
+
+       long is_syscall;
+};
+
+#ifdef __KERNEL__
+
+#include <linux/linkage.h>
+
+/*
+ * Does the process account for user or for system time?
+ */
+#define user_mode(regs)        ((regs->cp0_psr & 8) == 8)
+
+#define instruction_pointer(regs) (0)
+#define profile_pc(regs) instruction_pointer(regs)
+
+extern asmlinkage void do_syscall_trace(struct pt_regs *regs, int 
entryexit);
+extern int read_tsk_long(struct task_struct *, unsigned long, unsigned 
long *);
+extern void clear_single_step(struct task_struct *);
+#endif
+
+#endif /* __SCORE_PTRACE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/resource.h 
linux-2.6-git.new/arch/score/include/asm/resource.h
--- linux-2.6-git.ori/arch/score/include/asm/resource.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/resource.h 2009-04-03 
17:04:10.000000000 +0800
@@ -0,0 +1,17 @@
+#ifndef __SCORE_RESOURCE_H
+#define __SCORE_RESOURCE_H
+
+/*
+ * These five resource limit IDs have a SCORE/Linux-specific ordering,
+ * the rest comes from the generic header:
+ */
+#define RLIMIT_NOFILE          5       /* max number of open files */
+#define RLIMIT_AS              6       /* address space limit */
+#define RLIMIT_RSS             7       /* max resident set size */
+#define RLIMIT_NPROC           8       /* max number of processes */
+#define RLIMIT_MEMLOCK         9       /* max locked-in-memory address 
space */
+#define RLIM_INFINITY          0x7fffffffUL
+
+#include <asm-generic/resource.h>
+
+#endif /* __SCORE_RESOURCE_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/scatterlist.h 
linux-2.6-git.new/arch/score/include/asm/scatterlist.h
--- linux-2.6-git.ori/arch/score/include/asm/scatterlist.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/scatterlist.h      2009-04-03 
17:04:19.000000000 +0800
@@ -0,0 +1,26 @@
+#ifndef __SCORE_SCATTERLIST_H
+#define __SCORE_SCATTERLIST_H
+
+#include <asm/types.h>
+
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+       unsigned long   sg_magic;
+#endif
+       unsigned long   page_link;
+       unsigned int    offset;
+       dma_addr_t      dma_address;
+       unsigned int    length;
+};
+
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns, or alternatively stop on the first sg_dma_len(sg) which
+ * is 0.
+ */
+#define sg_dma_address(sg)     ((sg)->dma_address)
+#define sg_dma_len(sg)         ((sg)->length)
+
+#endif /* __SCORE_SCATTERLIST_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/scoreregs.h 
linux-2.6-git.new/arch/score/include/asm/scoreregs.h
--- linux-2.6-git.ori/arch/score/include/asm/scoreregs.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/scoreregs.h        2009-04-07 
13:57:22.000000000 +0800
@@ -0,0 +1,51 @@
+#ifndef __SCORE_SCOREREGS_H
+#define __SCORE_SCOREREGS_H
+
+#include <linux/linkage.h>
+
+/* TIMER register */
+#define TIME0BASE              0x96080000
+#define P_TIMER0_CTRL          (TIME0BASE + 0x00)
+#define P_TIMER0_CPP_CTRL      (TIME0BASE + 0x04)
+#define P_TIMER0_PRELOAD       (TIME0BASE + 0x08)
+#define P_TIMER0_CPP_REG       (TIME0BASE + 0x0C)
+#define P_TIMER0_UPCNT         (TIME0BASE + 0x10)
+
+/* Timer Controller Register */
+/* bit 0 Timer enable */
+#define TMR_DISABLE    0x0000
+#define TMR_ENABLE     0x0001
+
+/* bit 1 Interrupt enable */
+#define TMR_IE_DISABLE 0x0000
+#define TMR_IE_ENABLE  0x0002
+
+/* bit 2 Output enable */
+#define TMR_OE_DISABLE 0x0004
+#define TMR_OE_ENABLE  0x0000
+
+/* bit4 Up/Down counting selection */
+#define TMR_UD_DOWN    0x0000
+#define TMR_UD_UP      0x0010
+
+/* bit5 Up/Down counting control selection */
+#define TMR_UDS_UD     0x0000
+#define TMR_UDS_EXTUD  0x0020
+
+/* bit6 Time output mode */
+#define TMR_OM_TOGGLE  0x0000
+#define TMR_OM_PILSE   0x0040
+
+/* bit 8..9 External input active edge selection */
+#define TMR_ES_PE      0x0000
+#define TMR_ES_NE      0x0100
+#define TMR_ES_BOTH    0x0200
+
+/* bit 10..11 Operating mode */
+#define TMR_M_FREE     0x0000 /* free running timer mode */
+#define TMR_M_PERIODIC 0x0400 /* periodic timer mode */
+#define TMR_M_FC       0x0800 /* free running counter mode */
+#define TMR_M_PC       0x0c00 /* periodic counter mode */
+
+#define SYSTEM_CLOCK           (27*1000000/4)          /* 27 MHz */
+#endif /* __SCORE_SCOREREGS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/sections.h 
linux-2.6-git.new/arch/score/include/asm/sections.h
--- linux-2.6-git.ori/arch/score/include/asm/sections.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/sections.h 2009-04-03 
17:04:39.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_SECTIONS_H
+#define __SCORE_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+#endif /* __SCORE_SECTIONS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/sembuf.h 
linux-2.6-git.new/arch/score/include/asm/sembuf.h
--- linux-2.6-git.ori/arch/score/include/asm/sembuf.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/sembuf.h   2009-04-03 
17:21:57.000000000 +0800
@@ -0,0 +1,27 @@
+#ifndef __SCORE_SEMBUF_H
+#define __SCORE_SEMBUF_H
+
+#include <linux/types.h>
+
+/*
+* The semid64_ds structure for SCORE architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct semid64_ds {
+       struct ipc64_perm sem_perm;     /* permissions .. see ipc.h */
+       __kernel_time_t sem_otime;      /* last semop time */
+       u32 __unused1;
+       __kernel_time_t sem_ctime;      /* last change time */
+       u32 __unused2;
+       u32 sem_nsems;  /* no. of semaphores in array */
+       u32 __unused3;
+       u32 __unused4;
+};
+
+#endif /* __SCORE_SEMBUF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/setup.h 
linux-2.6-git.new/arch/score/include/asm/setup.h
--- linux-2.6-git.ori/arch/score/include/asm/setup.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/setup.h    2009-04-07 
20:54:27.000000000 +0800
@@ -0,0 +1,35 @@
+#ifndef __SCORE_SETUP_H
+#define __SCORE_SETUP_H
+
+#define COMMAND_LINE_SIZE      256
+#define MEM_SIZE       0x2000000
+
+#ifdef __KERNEL__
+extern void setup_early_printk(void);
+extern void cpu_cache_init(void);
+extern void tlb_init(void);
+
+extern void handle_nmi(void);
+extern void handle_adelinsn(void);
+extern void handle_adedata(void);
+extern void handle_ibe(void);
+extern void handle_pel(void);
+extern void handle_sys(void);
+extern void handle_ccu(void);
+extern void handle_ri(void);
+extern void handle_tr(void);
+extern void handle_ades(void);
+extern void handle_cee(void);
+extern void handle_cpe(void);
+extern void handle_dve(void);
+extern void handle_dbe(void);
+extern void handle_reserved(void);
+extern void handle_tlb_refill(void);
+extern void handle_tlb_invaild(void);
+extern void handle_mod(void);
+extern void __devinit cpu_cache_init(void);
+extern void debug_exception_vector(void);
+extern void general_exception_vector(void);
+#endif /* __KERNEL__ */
+
+#endif /* __SCORE_SETUP_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/shmbuf.h 
linux-2.6-git.new/arch/score/include/asm/shmbuf.h
--- linux-2.6-git.ori/arch/score/include/asm/shmbuf.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/shmbuf.h   2009-04-03 
17:22:54.000000000 +0800
@@ -0,0 +1,43 @@
+#ifndef __SCORE_SHMBUF_H
+#define __SCORE_SHMBUF_H
+
+#include <linux/types.h>
+
+/*
+ * The shmid64_ds structure for score architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct shmid64_ds {
+       struct ipc64_perm shm_perm;     /* operation perms */
+       size_t shm_segsz;               /* size of segment (bytes) */
+       __kernel_time_t shm_atime;      /* last attach time */
+       __u32 __unused1;
+       __kernel_time_t shm_dtime;      /* last detach time */
+       __u32 __unused2;
+       __kernel_time_t shm_ctime;      /* last change time */
+       __u32 __unused3;
+       __kernel_pid_t shm_cpid;        /* pid of creator */
+       __kernel_pid_t shm_lpid;        /* pid of last operator */
+       __u32 shm_nattch;       /* no. of current attaches */
+       __u32 __unused4;
+       __u32 __unused5;
+};
+
+struct shminfo64 {
+       __u32 shmmax;
+       __u32 shmmin;
+       __u32 shmmni;
+       __u32 shmseg;
+       __u32 shmall;
+       __u32 __unused1;
+       __u32 __unused2;
+       __u32 __unused3;
+       __u32 __unused4;
+};
+#endif                         /* _SCORE_SHMBUF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/shmparam.h 
linux-2.6-git.new/arch/score/include/asm/shmparam.h
--- linux-2.6-git.ori/arch/score/include/asm/shmparam.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/shmparam.h 2009-04-03 
17:05:44.000000000 +0800
@@ -0,0 +1,7 @@
+#ifndef __SCORE_SHMPARAM_H
+#define __SCORE_SHMPARAM_H
+
+#define        __ARCH_FORCE_SHMLBA     1
+#define        SHMLBA                  0x40000         /* attach addr a 
multiple of this */
+
+#endif /* __SCORE_SHMPARAM_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/sigcontext.h 
linux-2.6-git.new/arch/score/include/asm/sigcontext.h
--- linux-2.6-git.ori/arch/score/include/asm/sigcontext.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/sigcontext.h       2009-04-03 
17:05:51.000000000 +0800
@@ -0,0 +1,22 @@
+#ifndef __SCORE_SIGCONTEXT_H
+#define __SCORE_SIGCONTEXT_H
+
+/*
+ * Keep this struct definition in sync with the sigcontext fragment
+ * in arch/score/tools/offset.c
+ */
+struct sigcontext {
+       unsigned int            sc_regmask;
+       unsigned int            sc_psr;
+       unsigned int            sc_condition;
+       unsigned long           sc_pc;
+       unsigned long           sc_regs[32];
+       unsigned int            sc_ssflags;
+       unsigned int            sc_mdceh;
+       unsigned int            sc_mdcel;
+       unsigned int            sc_ecr;
+       unsigned long           sc_ema;
+       unsigned long           sc_sigset[4];
+};
+
+#endif /* __SCORE_SIGCONTEXT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/siginfo.h 
linux-2.6-git.new/arch/score/include/asm/siginfo.h
--- linux-2.6-git.ori/arch/score/include/asm/siginfo.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/siginfo.h  2009-04-07 
20:54:50.000000000 +0800
@@ -0,0 +1,113 @@
+#ifndef __SCORE_SIGINFO_H
+#define __SCORE_SIGINFO_H
+
+#define __ARCH_SIGEV_PREAMBLE_SIZE (sizeof(long) + 2*sizeof(int))
+#undef __ARCH_SI_TRAPNO        /* exception code needs to fill this ... 
*/
+
+#define HAVE_ARCH_SIGINFO_T
+#define HAVE_ARCH_COPY_SIGINFO
+
+struct siginfo;
+
+/*
+ * Careful to keep union _sifields from shifting ...
+ */
+#define __ARCH_SI_PREAMBLE_SIZE (3 * sizeof(int))
+
+#include <asm-generic/siginfo.h>
+
+typedef struct siginfo {
+       int si_signo;
+       int si_code;
+       int si_errno;
+       int __pad0[SI_MAX_SIZE / sizeof(int) - SI_PAD_SIZE - 3];
+
+       union {
+               int _pad[SI_PAD_SIZE];
+
+               /* kill() */
+               struct {
+                       pid_t _pid;             /* sender's pid */
+                       __ARCH_SI_UID_T _uid;   /* sender's uid */
+               } _kill;
+
+               /* POSIX.1b timers */
+               struct {
+                       timer_t _tid;           /* timer id */
+                       int _overrun;           /* overrun count */
+                       char _pad[sizeof(__ARCH_SI_UID_T) - sizeof(int)];
+                       sigval_t _sigval;       /* same as below */
+                       int _sys_private;       /* not to be passed to 
user */
+               } _timer;
+
+               /* POSIX.1b signals */
+               struct {
+                       pid_t _pid;             /* sender's pid */
+                       __ARCH_SI_UID_T _uid;   /* sender's uid */
+                       sigval_t _sigval;
+               } _rt;
+
+               /* SIGCHLD */
+               struct {
+                       pid_t _pid;             /* which child */
+                       __ARCH_SI_UID_T _uid;   /* sender's uid */
+                       int _status;            /* exit code */
+                       clock_t _utime;
+                       clock_t _stime;
+               } _sigchld;
+
+               /* IRIX SIGCHLD */
+               struct {
+                       pid_t _pid;             /* which child */
+                       clock_t _utime;
+                       int _status;            /* exit code */
+                       clock_t _stime;
+               } _irix_sigchld;
+
+               /* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
+               struct {
+                       void __user *_addr; /* faulting insn/memory ref. 
*/
+#ifdef __ARCH_SI_TRAPNO
+                       int _trapno;    /* TRAP # which caused the signal 
*/
+#endif
+               } _sigfault;
+
+               /* SIGPOLL, SIGXFSZ (To do ...) */
+               struct {
+                       __ARCH_SI_BAND_T _band; /* POLL_IN, POLL_OUT, 
POLL_MSG */
+                       int _fd;
+               } _sigpoll;
+       } _sifields;
+} siginfo_t;
+
+/*
+ * si_code values
+ * Again these have been choosen to be IRIX compatible.
+ */
+#undef SI_ASYNCIO
+#undef SI_TIMER
+#undef SI_MESGQ
+#define SI_ASYNCIO     -2      /* sent by AIO completion */
+#define SI_TIMER __SI_CODE(__SI_TIMER, -3) /* sent by timer expiration */
+#define SI_MESGQ __SI_CODE(__SI_MESGQ, -4) /* sent by real time mesq 
state change */
+
+#ifdef __KERNEL__
+
+/*
+ * Duplicated here because of <asm-generic/siginfo.h> braindamage ...
+ */
+#include <linux/string.h>
+
+static inline void copy_siginfo(struct siginfo *to, struct siginfo *from)
+{
+       if (from->si_code < 0)
+               memcpy(to, from, sizeof(*to));
+       else
+               /* _sigchld is currently the largest know union member */
+               memcpy(to, from, 3 * sizeof(int) +
+                                sizeof(from->_sifields._sigchld));
+}
+
+#endif
+
+#endif /* __SCORE_SIGINFO_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/signal.h 
linux-2.6-git.new/arch/score/include/asm/signal.h
--- linux-2.6-git.ori/arch/score/include/asm/signal.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/signal.h   2009-04-07 
20:55:32.000000000 +0800
@@ -0,0 +1,118 @@
+#ifndef __SCORE_SIGNAL_H
+#define __SCORE_SIGNAL_H
+
+#include <linux/types.h>
+
+#define _NSIG          128
+#define _NSIG_BPW      (sizeof(unsigned long) * 8)
+#define _NSIG_WORDS    (_NSIG / _NSIG_BPW)
+
+typedef struct {
+       unsigned long sig[_NSIG_WORDS];
+} sigset_t;
+
+typedef unsigned long old_sigset_t;            /* at least 32 bits */
+
+#define SIGHUP         1       /* Hangup (POSIX). */
+#define SIGINT         2       /* Interrupt (ANSI). */
+#define SIGQUIT                3       /* Quit (POSIX). */
+#define SIGILL         4       /* Illegal instruction (ANSI). */
+#define SIGTRAP                5       /* Trace trap (POSIX). */
+#define SIGIOT         6       /* IOT trap (4.2 BSD). */
+#define SIGABRT                SIGIOT  /* Abort (ANSI). */
+#define SIGEMT         7
+#define SIGFPE         8       /* Floating-point exception (ANSI). */
+#define SIGKILL                9       /* Kill, unblockable (POSIX). */
+#define SIGBUS         10      /* BUS error (4.2 BSD). */
+#define SIGSEGV                11      /* Segmentation violation (ANSI). 
*/
+#define SIGSYS         12
+#define SIGPIPE                13      /* Broken pipe (POSIX). */
+#define SIGALRM                14      /* Alarm clock (POSIX). */
+#define SIGTERM                15      /* Termination (ANSI). */
+#define SIGUSR1                16      /* User-defined signal 1 (POSIX). 
*/
+#define SIGUSR2                17      /* User-defined signal 2 (POSIX). 
*/
+#define SIGCHLD                18      /* Child status has changed 
(POSIX). */
+#define SIGCLD         SIGCHLD /* Same as SIGCHLD (System V). */
+#define SIGPWR         19      /* Power failure restart (System V). */
+#define SIGWINCH       20      /* Window size change (4.3 BSD, Sun). */
+#define SIGURG         21      /* Urgent condition on socket (4.2 BSD). 
*/
+#define SIGIO          22      /* I/O now possible (4.2 BSD). */
+#define SIGPOLL                SIGIO   /* Pollable event occurred (System 
V). */
+#define SIGSTOP                23      /* Stop, unblockable (POSIX). */
+#define SIGTSTP                24      /* Keyboard stop (POSIX). */
+#define SIGCONT                25      /* Continue (POSIX). */
+#define SIGTTIN                26      /* Background read from tty 
(POSIX). */
+#define SIGTTOU                27      /* Background write to tty 
(POSIX). */
+#define SIGVTALRM      28      /* Virtual alarm clock (4.2 BSD). */
+#define SIGPROF                29      /* Profiling alarm clock (4.2 
BSD). */
+#define SIGXCPU                30      /* CPU limit exceeded (4.2 BSD). 
*/
+#define SIGXFSZ                31      /* File size limit exceeded (4.2 
BSD). */
+
+/* These should not be considered constants from userland. */
+#define SIGRTMIN       32
+#define SIGRTMAX       _NSIG
+
+/*
+ * SA_FLAGS values:
+ *
+ * SA_ONSTACK indicates that a registered stack_t will be used.
+ * SA_RESTART flag to get restarting signals (which were the default long 
ago)
+ * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
+ * SA_RESETHAND clears the handler when the signal is delivered.
+ * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
+ * SA_NODEFER prevents the current signal from being masked in the 
handler.
+ *
+ * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
+ * Unix names RESETHAND and NODEFER respectively.
+ */
+#define SA_ONSTACK     0x08000000
+#define SA_RESETHAND   0x80000000
+#define SA_RESTART     0x10000000
+#define SA_SIGINFO     0x00000008
+#define SA_NODEFER     0x40000000
+#define SA_NOCLDWAIT   0x00010000
+#define SA_NOCLDSTOP   0x00000001
+
+#define SA_NOMASK      SA_NODEFER
+#define SA_ONESHOT     SA_RESETHAND
+
+/*
+ * sigaltstack controls
+ */
+#define SS_ONSTACK     1
+#define SS_DISABLE     2
+
+#define MINSIGSTKSZ    2048
+#define SIGSTKSZ       8192
+
+#define SIG_BLOCK      1       /* for blocking signals */
+#define SIG_UNBLOCK    2       /* for unblocking signals */
+#define SIG_SETMASK    3       /* for setting the signal mask */
+
+#include <asm-generic/signal.h>
+
+struct sigaction {
+       unsigned int    sa_flags;
+       __sighandler_t  sa_handler;
+       sigset_t        sa_mask;
+};
+
+struct k_sigaction {
+       struct sigaction sa;
+};
+
+/* IRIX compatible stack_t */
+typedef struct sigaltstack {
+       void __user *ss_sp;
+       size_t ss_size;
+       int ss_flags;
+} stack_t;
+
+#ifdef __KERNEL__
+#include <asm/sigcontext.h>
+
+#define ptrace_signal_deliver(regs, cookie) do {} while (0)
+
+#endif /* __KERNEL__ */
+
+#endif /* __SCORE_SIGNAL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/socket.h 
linux-2.6-git.new/arch/score/include/asm/socket.h
--- linux-2.6-git.ori/arch/score/include/asm/socket.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/socket.h   2009-04-07 
20:56:08.000000000 +0800
@@ -0,0 +1,106 @@
+#ifndef __SCORE_SOCKET_H
+#define __SCORE_SOCKET_H
+
+#include <asm/sockios.h>
+
+/*
+ * For setsockopt(2)
+ *
+ * This defines are ABI conformant as far as Linux supports these ...
+ */
+#define SOL_SOCKET     0xffff
+
+#define SO_DEBUG       0x0001  /* Record debugging information. */
+#define SO_REUSEADDR   0x0004  /* Allow reuse of local addresses. */
+#define SO_KEEPALIVE   0x0008  /* Keep connections alive and send
+                                  SIGPIPE when they die. */
+#define SO_DONTROUTE   0x0010  /* Don't do local routing. */
+#define SO_BROADCAST   0x0020  /* Allow transmission of
+                                  broadcast messages. */
+#define SO_LINGER      0x0080  /* Block on close of a reliable
+                                  socket to transmit pending data. */
+#define SO_OOBINLINE 0x0100    /* Receive out-of-band data in-band. */
+
+#define SO_TYPE                0x1008  /* Compatible name for SO_STYLE. 
*/
+#define SO_STYLE       SO_TYPE /* Synonym */
+#define SO_ERROR       0x1007  /* get error status and clear */
+#define SO_SNDBUF      0x1001  /* Send buffer size. */
+#define SO_RCVBUF      0x1002  /* Receive buffer. */
+#define SO_SNDLOWAT    0x1003  /* send low-water mark */
+#define SO_RCVLOWAT    0x1004  /* receive low-water mark */
+#define SO_SNDTIMEO    0x1005  /* send timeout */
+#define SO_RCVTIMEO    0x1006  /* receive timeout */
+#define SO_ACCEPTCONN  0x1009
+
+/* linux-specific, might as well be the same as on i386 */
+#define SO_NO_CHECK    11
+#define SO_PRIORITY    12
+#define SO_BSDCOMPAT   14
+
+#define SO_PASSCRED    17
+#define SO_PEERCRED    18
+
+/* Security levels - as per NRL IPv6 - don't actually do anything */
+#define SO_SECURITY_AUTHENTICATION             22
+#define SO_SECURITY_ENCRYPTION_TRANSPORT       23
+#define SO_SECURITY_ENCRYPTION_NETWORK         24
+
+#define SO_BINDTODEVICE                25
+
+/* Socket filtering */
+#define SO_ATTACH_FILTER       26
+#define SO_DETACH_FILTER       27
+
+#define SO_PEERNAME            28
+#define SO_TIMESTAMP           29
+#define SCM_TIMESTAMP          SO_TIMESTAMP
+
+#define SO_PEERSEC             30
+#define SO_SNDBUFFORCE         31
+#define SO_RCVBUFFORCE         33
+#define SO_PASSSEC             34
+#define SO_TIMESTAMPNS         35
+#define SCM_TIMESTAMPNS                SO_TIMESTAMPNS
+
+#define SO_MARK                        36
+
+#ifdef __KERNEL__
+
+/** sock_type - Socket types
+ *
+ * Please notice that for binary compat reasons SCORE has to
+ * override the enum sock_type in include/linux/net.h, so
+ * we define ARCH_HAS_SOCKET_TYPES here.
+ *
+ * @SOCK_DGRAM - datagram (conn.less) socket
+ * @SOCK_STREAM - stream (connection) socket
+ * @SOCK_RAW - raw socket
+ * @SOCK_RDM - reliably-delivered message
+ * @SOCK_SEQPACKET - sequential packet socket
+ * @SOCK_PACKET - linux specific way of getting packets at the dev level.
+ *               For writing rarp and other similar things on the user 
level.
+ */
+enum sock_type {
+       SOCK_DGRAM      = 1,
+       SOCK_STREAM     = 2,
+       SOCK_RAW        = 3,
+       SOCK_RDM        = 4,
+       SOCK_SEQPACKET  = 5,
+       SOCK_DCCP       = 6,
+       SOCK_PACKET     = 10,
+};
+
+#define SOCK_MAX (SOCK_PACKET + 1)
+/* Mask which covers at least up to SOCK_MASK-1.  The
+ *  * remaining bits are used as flags. */
+#define SOCK_TYPE_MASK 0xf
+
+/* Flags for socket, socketpair, paccept */
+#define SOCK_CLOEXEC   O_CLOEXEC
+#define SOCK_NONBLOCK  O_NONBLOCK
+
+#define ARCH_HAS_SOCKET_TYPES 1
+
+#endif /* __KERNEL__ */
+
+#endif /* __SCORE_SOCKET_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/sockios.h 
linux-2.6-git.new/arch/score/include/asm/sockios.h
--- linux-2.6-git.ori/arch/score/include/asm/sockios.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/sockios.h  2009-04-03 
17:06:16.000000000 +0800
@@ -0,0 +1,17 @@
+#ifndef __SCORE_SOCKIOS_H
+#define __SCORE_SOCKIOS_H
+
+#include <asm/ioctl.h>
+
+/* Socket-level I/O control calls. */
+#define FIOGETOWN      _IOR('f', 123, int)
+#define FIOSETOWN      _IOW('f', 124, int)
+
+#define SIOCATMARK     _IOR('s', 7, int)
+#define SIOCSPGRP      _IOW('s', 8, pid_t)
+#define SIOCGPGRP      _IOR('s', 9, pid_t)
+
+#define SIOCGSTAMP     0x8906          /* Get stamp (timeval) */
+#define SIOCGSTAMPNS   0x8907          /* Get stamp (timespec) */
+
+#endif /* __SCORE_SOCKIOS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/statfs.h 
linux-2.6-git.new/arch/score/include/asm/statfs.h
--- linux-2.6-git.ori/arch/score/include/asm/statfs.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/statfs.h   2009-04-03 
17:06:23.000000000 +0800
@@ -0,0 +1,49 @@
+#ifndef __SCORE_STATFS_H
+#define __SCORE_STATFS_H
+
+#include <linux/posix_types.h>
+
+#ifndef __KERNEL_STRICT_NAMES
+
+#include <linux/types.h>
+
+typedef __kernel_fsid_t        fsid_t;
+
+#endif
+
+struct statfs {
+       long            f_type;
+#define f_fstyp f_type
+       long            f_bsize;
+       long            f_frsize;       /* Fragment size - unsupported */
+       long            f_blocks;
+       long            f_bfree;
+       long            f_files;
+       long            f_ffree;
+       long            f_bavail;
+
+       /* Linux specials */
+       __kernel_fsid_t f_fsid;
+       long            f_namelen;
+       long            f_spare[6];
+};
+
+/*
+ * Unlike the traditional version the LFAPI version has none of the ABI 
junk
+ */
+struct statfs64 {
+       __u32   f_type;
+       __u32   f_bsize;
+       __u32   f_frsize;       /* Fragment size - unsupported */
+       __u32   __pad;
+       __u64   f_blocks;
+       __u64   f_bfree;
+       __u64   f_files;
+       __u64   f_ffree;
+       __u64   f_bavail;
+       __kernel_fsid_t f_fsid;
+       __u32   f_namelen;
+       __u32   f_spare[6];
+};
+
+#endif /* __SCORE_STATFS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/stat.h 
linux-2.6-git.new/arch/score/include/asm/stat.h
--- linux-2.6-git.ori/arch/score/include/asm/stat.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/stat.h     2009-04-03 
17:06:30.000000000 +0800
@@ -0,0 +1,75 @@
+#ifndef __SCORE_STAT_H
+#define __SCORE_STAT_H
+
+#include <linux/types.h>
+
+struct stat {
+       unsigned        st_dev;
+       long            st_pad1[3];             /* Reserved for network id 
*/
+       ino_t           st_ino;
+       mode_t          st_mode;
+       nlink_t         st_nlink;
+       uid_t           st_uid;
+       gid_t           st_gid;
+       unsigned        st_rdev;
+       long            st_pad2[2];
+       off_t           st_size;
+       long            st_pad3;
+       /*
+        * Actually this should be timestruc_t st_atime, st_mtime and 
st_ctime
+        * but we don't have it under Linux.
+        */
+       time_t          st_atime;
+       long            st_atime_nsec;
+       time_t          st_mtime;
+       long            st_mtime_nsec;
+       time_t          st_ctime;
+       long            st_ctime_nsec;
+       long            st_blksize;
+       long            st_blocks;
+       long            st_pad4[14];
+};
+
+/*
+ * This matches struct stat64 in glibc2.1, hence the absolutely insane
+ * amounts of padding around dev_t's.  The memory layout is the same as 
of
+ * struct stat of the 64-bit kernel.
+ */
+
+struct stat64 {
+       unsigned long   st_dev;
+       unsigned long   st_pad0[3];     /* Reserved for st_dev expansion 
*/
+
+       unsigned long long      st_ino;
+
+       mode_t          st_mode;
+       nlink_t         st_nlink;
+
+       uid_t           st_uid;
+       gid_t           st_gid;
+
+       unsigned long   st_rdev;
+       unsigned long   st_pad1[3];     /* Reserved for st_rdev expansion 
*/
+
+       long long       st_size;
+
+       /*
+        * Actually this should be timestruc_t st_atime, st_mtime and 
st_ctime
+        * but we don't have it under Linux.
+        */
+       time_t          st_atime;
+       unsigned long   st_atime_nsec;  /* Reserved for st_atime expansion 
*/
+
+       time_t          st_mtime;
+       unsigned long   st_mtime_nsec;  /* Reserved for st_mtime expansion 
*/
+
+       time_t          st_ctime;
+       unsigned long   st_ctime_nsec;  /* Reserved for st_ctime expansion 
*/
+
+       unsigned long   st_blksize;
+       unsigned long   st_pad2;
+
+       long long       st_blocks;
+};
+
+#endif /* __SCORE_STAT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/string.h 
linux-2.6-git.new/arch/score/include/asm/string.h
--- linux-2.6-git.ori/arch/score/include/asm/string.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/string.h   2009-04-03 
17:06:37.000000000 +0800
@@ -0,0 +1,8 @@
+#ifndef __SCORE_STRING_H
+#define __SCORE_STRING_H
+
+extern void *memset(void *__s, int __c, size_t __count);
+extern void *memcpy(void *__to, __const__ void *__from, size_t __n);
+extern void *memmove(void *__dest, __const__ void *__src, size_t __n);
+
+#endif /* __SCORE_STRING_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/swab.h 
linux-2.6-git.new/arch/score/include/asm/swab.h
--- linux-2.6-git.ori/arch/score/include/asm/swab.h     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/swab.h     2009-04-07 
20:56:26.000000000 +0800
@@ -0,0 +1,13 @@
+#ifndef __SCORE_SWAB_H
+#define __SCORE_SWAB_H
+
+#include <linux/types.h>
+
+#ifdef __GNUC__
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __SWAB_64_THRU_32__
+#endif
+
+#endif /* __GNUC__ */
+#endif /* __SCORE_SWAB_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/system.h 
linux-2.6-git.new/arch/score/include/asm/system.h
--- linux-2.6-git.ori/arch/score/include/asm/system.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/system.h   2009-04-07 
21:45:47.000000000 +0800
@@ -0,0 +1,94 @@
+#ifndef __SCORE_SYSTEM_H
+#define __SCORE_SYSTEM_H
+
+#include <linux/types.h>
+#include <linux/irqflags.h>
+
+extern void *resume(void *last, void *next, void *next_ti);
+
+struct task_struct;
+
+#define switch_to(prev, next, last)                            \
+do {                                                           \
+       (last) = resume(prev, next, task_thread_info(next));    \
+} while (0)
+
+#define finish_arch_switch(prev)       do {} while (0)
+
+typedef void (*vi_handler_t)(void);
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#define mb()           barrier()
+#define rmb()          barrier()
+#define wmb()          barrier()
+#define smp_mb()       barrier()
+#define smp_rmb()      barrier()
+#define smp_wmb()      barrier()
+
+#define read_barrier_depends()         do {} while (0)
+#define smp_read_barrier_depends()     do {} while (0)
+
+#define set_mb(var, value)             do {var = value; wmb(); } while 
(0)
+
+#define __HAVE_ARCH_CMPXCHG    1
+
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg_local(ptr, o, n) \
+       ((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned 
long)(o),\
+                       (unsigned long)(n), sizeof(*(ptr))))
+
+#ifndef __ASSEMBLY__
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+static inline
+unsigned long __xchg(volatile unsigned long *m, unsigned long val)
+{
+       unsigned long retval;
+       unsigned long flags;
+
+       local_irq_save(flags);
+       retval = *m;
+       *m = val;
+       local_irq_restore(flags);
+       return retval;
+}
+
+#define xchg(ptr, v)                                           \
+       ((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),    \
+                                       (unsigned long)(v)))
+
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+                                       unsigned long old, unsigned long 
new)
+{
+       unsigned long retval;
+       unsigned long flags;
+
+       local_irq_save(flags);
+       retval = *m;
+       if (retval == old)
+               *m = new;
+       local_irq_restore(flags);
+       return retval;
+}
+
+#define cmpxchg(ptr, o, n)                                     \
+       ((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
+                                       (unsigned long)(o),     \
+                                       (unsigned long)(n)))
+
+struct pt_regs;
+
+extern void __die(const char *, struct pt_regs *, const char *,
+       const char *, unsigned long) __attribute__((noreturn));
+extern void __die_if_kernel(const char *, struct pt_regs *, const char *,
+       const char *, unsigned long);
+
+#define die(msg, regs)                                                 \
+       __die(msg, regs, __FILE__ ":", __func__, __LINE__)
+#define die_if_kernel(msg, regs)                                       \
+       __die_if_kernel(msg, regs, __FILE__ ":", __func__, __LINE__)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __SCORE_SYSTEM_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/termbits.h 
linux-2.6-git.new/arch/score/include/asm/termbits.h
--- linux-2.6-git.ori/arch/score/include/asm/termbits.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/termbits.h 2009-04-03 
17:07:16.000000000 +0800
@@ -0,0 +1,195 @@
+#ifndef __SCORE_TERMBITS_H
+#define __SCORE_TERMBITS_H
+
+#include <linux/posix_types.h>
+
+typedef unsigned char  cc_t;
+typedef unsigned int   speed_t;
+typedef unsigned int   tcflag_t;
+
+#define NCCS 19
+struct termios {
+       tcflag_t c_iflag;               /* input mode flags */
+       tcflag_t c_oflag;               /* output mode flags */
+       tcflag_t c_cflag;               /* control mode flags */
+       tcflag_t c_lflag;               /* local mode flags */
+       cc_t c_line;                    /* line discipline */
+       cc_t c_cc[NCCS];                /* control characters */
+};
+
+struct termios2 {
+       tcflag_t c_iflag;               /* input mode flags */
+       tcflag_t c_oflag;               /* output mode flags */
+       tcflag_t c_cflag;               /* control mode flags */
+       tcflag_t c_lflag;               /* local mode flags */
+       cc_t c_line;                    /* line discipline */
+       cc_t c_cc[NCCS];                /* control characters */
+       speed_t c_ispeed;               /* input speed */
+       speed_t c_ospeed;               /* output speed */
+};
+
+struct ktermios {
+       tcflag_t c_iflag;               /* input mode flags */
+       tcflag_t c_oflag;               /* output mode flags */
+       tcflag_t c_cflag;               /* control mode flags */
+       tcflag_t c_lflag;               /* local mode flags */
+       cc_t c_line;                    /* line discipline */
+       cc_t c_cc[NCCS];                /* control characters */
+       speed_t c_ispeed;               /* input speed */
+       speed_t c_ospeed;               /* output speed */
+};
+
+/* c_cc characters */
+#define VINTR  0
+#define VQUIT  1
+#define VERASE 2
+#define VKILL  3
+#define VEOF   4
+#define VTIME  5
+#define VMIN   6
+#define VSWTC  7
+#define VSTART 8
+#define VSTOP  9
+#define VSUSP  10
+#define VEOL   11
+#define VREPRINT       12
+#define VDISCARD       13
+#define VWERASE        14
+#define VLNEXT 15
+#define VEOL2  16
+
+/* c_iflag bits */
+#define IGNBRK 0000001
+#define BRKINT 0000002
+#define IGNPAR 0000004
+#define PARMRK 0000010
+#define INPCK  0000020
+#define ISTRIP 0000040
+#define INLCR  0000100
+#define IGNCR  0000200
+#define ICRNL  0000400
+#define IUCLC  0001000
+#define IXON   0002000
+#define IXANY  0004000
+#define IXOFF  0010000
+#define IMAXBEL        0020000
+#define IUTF8  0040000
+
+/* c_oflag bits */
+#define OPOST  0000001
+#define OLCUC  0000002
+#define ONLCR  0000004
+#define OCRNL  0000010
+#define ONOCR  0000020
+#define ONLRET 0000040
+#define OFILL  0000100
+#define OFDEL  0000200
+#define NLDLY  0000400
+#define NL0    0000000
+#define NL1    0000400
+#define CRDLY  0003000
+#define CR0    0000000
+#define CR1    0001000
+#define CR2    0002000
+#define CR3    0003000
+#define TABDLY 0014000
+#define TAB0   0000000
+#define TAB1   0004000
+#define TAB2   0010000
+#define TAB3   0014000
+#define XTABS  0014000
+#define BSDLY  0020000
+#define BS0    0000000
+#define BS1    0020000
+#define VTDLY  0040000
+#define VT0    0000000
+#define VT1    0040000
+#define FFDLY  0100000
+#define FF0    0000000
+#define FF1    0100000
+
+/* c_cflag bit meaning */
+#define CBAUD  0010017
+#define B0     0000000         /* hang up */
+#define B50    0000001
+#define B75    0000002
+#define B110   0000003
+#define B134   0000004
+#define B150   0000005
+#define B200   0000006
+#define B300   0000007
+#define B600   0000010
+#define B1200  0000011
+#define B1800  0000012
+#define B2400  0000013
+#define B4800  0000014
+#define B9600  0000015
+#define B19200 0000016
+#define B38400 0000017
+#define EXTA   B19200
+#define EXTB   B38400
+#define CSIZE  0000060
+#define CS5    0000000
+#define CS6    0000020
+#define CS7    0000040
+#define CS8    0000060
+#define CSTOPB 0000100
+#define CREAD  0000200
+#define PARENB 0000400
+#define PARODD 0001000
+#define HUPCL  0002000
+#define CLOCAL 0004000
+#define CBAUDEX        0010000
+#define B57600 0010001
+#define B115200        0010002
+#define B230400        0010003
+#define B460800        0010004
+#define B500000        0010005
+#define B576000        0010006
+#define B921600        0010007
+#define B1000000       0010010
+#define B1152000       0010011
+#define B1500000       0010012
+#define B2000000       0010013
+#define B2500000       0010014
+#define B3000000       0010015
+#define B3500000       0010016
+#define B4000000       0010017
+#define CIBAUD 002003600000    /* input baud rate (not used) */
+#define CMSPAR 010000000000    /* mark or space (stick) parity */
+#define CRTSCTS        020000000000    /* flow control */
+
+/* c_lflag bits */
+#define ISIG   0000001
+#define ICANON 0000002
+#define XCASE  0000004
+#define ECHO   0000010
+#define ECHOE  0000020
+#define ECHOK  0000040
+#define ECHONL 0000100
+#define NOFLSH 0000200
+#define TOSTOP 0000400
+#define ECHOCTL        0001000
+#define ECHOPRT        0002000
+#define ECHOKE 0004000
+#define FLUSHO 0010000
+#define PENDIN 0040000
+#define IEXTEN 0100000
+
+/* tcflow() and TCXONC use these */
+#define        TCOOFF          0
+#define        TCOON           1
+#define        TCIOFF          2
+#define        TCION           3
+
+/* tcflush() and TCFLSH use these */
+#define        TCIFLUSH        0
+#define        TCOFLUSH        1
+#define        TCIOFLUSH       2
+
+/* tcsetattr uses these */
+#define        TCSANOW         0
+#define        TCSADRAIN       1
+#define        TCSAFLUSH       2
+
+#endif /* __SCORE_TERMBITS_H */
