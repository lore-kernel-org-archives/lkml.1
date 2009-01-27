Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbZA0Wfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbZA0Wfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZA0Wfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:35:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:38417 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752309AbZA0Wf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:35:29 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18X+Pw1GskXPFA92zh63W7vB2CawqH6FjeBu/a9Vh
	UqAXWt3G/K9FOh
Message-ID: <497F8C35.8030601@gmx.de>
Date: Tue, 27 Jan 2009 23:35:33 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-parisc@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Grant Grundler <grundler@parisc-linux.org>
CC: David Miller <davem@davemloft.net>, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
References: <1232496257.3123.19.camel@localhost.localdomain> <20090120.163203.199590606.davem@davemloft.net> <4976D937.5040704@gmx.de> <200901210924.23484.arnd@arndb.de>
In-Reply-To: <200901210924.23484.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 21 January 2009, Helge Deller wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>>> On parisc, there is a major confusion in this area, at some point, all
>>>> checks for __LP64__ got replaced with CONFIG_64BIT there. While I have
>>>> not understood what the problem with __LP64__ was, the check for
>>>> CONFIG_64BIT on parisc user space looks very wrong.
>> I think the parisc mess is my fault. I once replaced the __LP64__ by 
>> CONFIG_64BIT and forgot that some files are exported to userspace.
>> I'll clean that up and send patches.
> 
> I have a patch set that introduces a lot more asm-generic headers where
> I also need a generic way to check for this. The approach I chose
> here was to check "#if __BITS_PER_LONG == 64" for anything that is
> exported to user space. Maybe you can #define this in asm/types.h
> and use this check in the parisc headers as well.

As per your suggestion, the patch below fixes the problem that the 
CONFIG_64BIT kernel config option is exported to userspace on parisc by mistake.
Tested on 32- and 64-bit parisc kernel builds and with "make headers_check".

arch/parisc/include/asm/:
 assembly.h    |   20 +++++++++++---------
 msgbuf.h      |    8 +++++---
 pdc.h         |   12 +++++-------
 posix_types.h |    4 +++-
 sembuf.h      |    4 ++--
 shmbuf.h      |   13 +++++++------
 signal.h      |    2 +-
 swab.h        |    2 +-
 types.h       |   10 ++++++++++
 9 files changed, 45 insertions(+), 30 deletions(-)

--------------------
parisc: do not export kernel config options to userspace in asm/ header files

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/include/asm/assembly.h b/arch/parisc/include/asm/assembly.h
index ab7cc37..b950843 100644
--- a/arch/parisc/include/asm/assembly.h
+++ b/arch/parisc/include/asm/assembly.h
@@ -21,9 +21,11 @@
 #ifndef _PARISC_ASSEMBLY_H
 #define _PARISC_ASSEMBLY_H
 
+#include <asm/types.h>
+
 #define CALLEE_FLOAT_FRAME_SIZE	80
 
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 #define LDREG	ldd
 #define STREG	std
 #define LDREGX  ldd,s
@@ -37,7 +39,7 @@
 #define FRAME_SIZE	128
 #define CALLEE_REG_FRAME_SIZE	144
 #define ASM_ULONG_INSN	.dword
-#else	/* CONFIG_64BIT */
+#else	/* __BITS_PER_LONG == 64 */
 #define LDREG	ldw
 #define STREG	stw
 #define LDREGX  ldwx,s
@@ -58,7 +60,7 @@
 #ifdef CONFIG_PA20
 #define LDCW		ldcw,co
 #define BL		b,l
-# ifdef CONFIG_64BIT
+# if __BITS_PER_LONG == 64
 #  define LEVEL		2.0w
 # else
 #  define LEVEL		2.0
@@ -71,7 +73,7 @@
 
 #ifdef __ASSEMBLY__
 
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 /* the 64-bit pa gnu assembler unfortunately defaults to .level 1.1 or 2.0 so
  * work around that for now... */
 	.level 2.0w
@@ -162,7 +164,7 @@
 	.endm
 
 	.macro loadgp
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 	ldil		L%__gp, %r27
 	ldo		R%__gp(%r27), %r27
 #else
@@ -340,7 +342,7 @@
 	fldd,mb	-8(%r30),   %fr12
 	.endm
 
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 	.macro	callee_save
 	std,ma	  %r3,	 CALLEE_REG_FRAME_SIZE(%r30)
 	mfctl	  %cr27, %r3
@@ -383,7 +385,7 @@
 	ldd,mb	-CALLEE_REG_FRAME_SIZE(%r30),    %r3
 	.endm
 
-#else /* ! CONFIG_64BIT */
+#else /* ! __BITS_PER_LONG == 64 */
 
 	.macro	callee_save
 	stw,ma	 %r3,	CALLEE_REG_FRAME_SIZE(%r30)
@@ -426,7 +428,7 @@
 	mtctl	%r3, %cr27
 	ldw,mb	-CALLEE_REG_FRAME_SIZE(%r30),   %r3
 	.endm
-#endif /* ! CONFIG_64BIT */
+#endif /* ! __BITS_PER_LONG == 64 */
 
 	.macro	save_specials	regs
 
@@ -447,7 +449,7 @@
 	mtctl	 %r0,	%cr18
 	SAVE_CR  (%cr18, PT_IAOQ1(\regs))
 
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 	/* cr11 (sar) is a funny one.  5 bits on PA1.1 and 6 bit on PA2.0
 	 * For PA2.0 mtsar or mtctl always write 6 bits, but mfctl only
 	 * reads 5 bits.  Use mfctl,w to read all six bits.  Otherwise
diff --git a/arch/parisc/include/asm/msgbuf.h b/arch/parisc/include/asm/msgbuf.h
index fe88f26..a4520f5 100644
--- a/arch/parisc/include/asm/msgbuf.h
+++ b/arch/parisc/include/asm/msgbuf.h
@@ -1,6 +1,8 @@
 #ifndef _PARISC_MSGBUF_H
 #define _PARISC_MSGBUF_H
 
+#include <linux/types.h>
+
 /* 
  * The msqid64_ds structure for parisc architecture, copied from sparc.
  * Note extra padding because this structure is passed back and forth
@@ -13,15 +15,15 @@
 
 struct msqid64_ds {
 	struct ipc64_perm msg_perm;
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int   __pad1;
 #endif
 	__kernel_time_t msg_stime;	/* last msgsnd time */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int   __pad2;
 #endif
 	__kernel_time_t msg_rtime;	/* last msgrcv time */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int   __pad3;
 #endif
 	__kernel_time_t msg_ctime;	/* last change time */
diff --git a/arch/parisc/include/asm/pdc.h b/arch/parisc/include/asm/pdc.h
index c584b00..f118764 100644
--- a/arch/parisc/include/asm/pdc.h
+++ b/arch/parisc/include/asm/pdc.h
@@ -336,10 +336,11 @@
 #define NUM_PDC_RESULT	32
 
 #if !defined(__ASSEMBLY__)
-#ifdef __KERNEL__
 
 #include <linux/types.h>
 
+#ifdef __KERNEL__
+
 extern int pdc_type;
 
 /* Values for pdc_type */
@@ -374,7 +375,7 @@ struct pdc_model {		/* for PDC_MODEL */
 
 struct pdc_cache_cf {		/* for PDC_CACHE  (I/D-caches) */
     unsigned long
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 		cc_padW:32,
 #endif
 		cc_alias: 4,	/* alias boundaries for virtual addresses   */
@@ -390,7 +391,7 @@ struct pdc_cache_cf {		/* for PDC_CACHE  (I/D-caches) */
 
 struct pdc_tlb_cf {		/* for PDC_CACHE (I/D-TLB's) */
     unsigned long tc_pad0:12,	/* reserved */
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 		tc_padW:32,
 #endif
 		tc_sh	: 2,	/* 0 = separate I/D-TLB, else shared I/D-TLB */
@@ -478,7 +479,6 @@ struct pdc_btlb_info {	/* PDC_BLOCK_TLB, return of PDC_BTLB_INFO */
 
 #endif /* !CONFIG_PA20 */
 
-#ifdef CONFIG_64BIT
 struct pdc_memory_table_raddr { /* PDC_MEM/PDC_MEM_TABLE (return info) */
 	unsigned long entries_returned;
 	unsigned long entries_total;
@@ -489,7 +489,6 @@ struct pdc_memory_table {       /* PDC_MEM/PDC_MEM_TABLE (arguments) */
 	unsigned int  pages;
 	unsigned int  reserved;
 };
-#endif /* CONFIG_64BIT */
 
 struct pdc_system_map_mod_info { /* PDC_SYSTEM_MAP/FIND_MODULE */
 	unsigned long mod_addr;
@@ -636,10 +635,9 @@ int pdc_get_initiator(struct hardware_path *, struct pdc_initiator *);
 int pdc_tod_read(struct pdc_tod *tod);
 int pdc_tod_set(unsigned long sec, unsigned long usec);
 
-#ifdef CONFIG_64BIT
+/* pdc_mem_mem_table - only available on 64bit */
 int pdc_mem_mem_table(struct pdc_memory_table_raddr *r_addr,
 		struct pdc_memory_table *tbl, unsigned long entries);
-#endif
 
 void set_firmware_width(void);
 void set_firmware_width_unlocked(void);
diff --git a/arch/parisc/include/asm/posix_types.h b/arch/parisc/include/asm/posix_types.h
index 00da29a..6946cdc 100644
--- a/arch/parisc/include/asm/posix_types.h
+++ b/arch/parisc/include/asm/posix_types.h
@@ -1,6 +1,8 @@
 #ifndef __ARCH_PARISC_POSIX_TYPES_H
 #define __ARCH_PARISC_POSIX_TYPES_H
 
+#include <asm/types.h>
+
 /*
  * This file is generally used by user-level software, so you need to
  * be a little careful about namespace pollution etc.  Also, we cannot
@@ -20,7 +22,7 @@ typedef int			__kernel_timer_t;
 typedef int			__kernel_clockid_t;
 typedef int			__kernel_daddr_t;
 /* Note these change from narrow to wide kernels */
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 typedef unsigned long		__kernel_size_t;
 typedef long			__kernel_ssize_t;
 typedef long			__kernel_ptrdiff_t;
diff --git a/arch/parisc/include/asm/sembuf.h b/arch/parisc/include/asm/sembuf.h
index 1e59ffd..d27e904 100644
--- a/arch/parisc/include/asm/sembuf.h
+++ b/arch/parisc/include/asm/sembuf.h
@@ -13,11 +13,11 @@
 
 struct semid64_ds {
 	struct ipc64_perm sem_perm;		/* permissions .. see ipc.h */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int	__pad1;
 #endif
 	__kernel_time_t	sem_otime;		/* last semop time */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int	__pad2;
 #endif
 	__kernel_time_t	sem_ctime;		/* last change time */
diff --git a/arch/parisc/include/asm/shmbuf.h b/arch/parisc/include/asm/shmbuf.h
index 0a3eada..d133bf4 100644
--- a/arch/parisc/include/asm/shmbuf.h
+++ b/arch/parisc/include/asm/shmbuf.h
@@ -1,6 +1,8 @@
 #ifndef _PARISC_SHMBUF_H
 #define _PARISC_SHMBUF_H
 
+#include <linux/types.h>
+
 /* 
  * The shmid64_ds structure for parisc architecture.
  * Note extra padding because this structure is passed back and forth
@@ -13,19 +15,19 @@
 
 struct shmid64_ds {
 	struct ipc64_perm	shm_perm;	/* operation perms */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int		__pad1;
 #endif
 	__kernel_time_t		shm_atime;	/* last attach time */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int		__pad2;
 #endif
 	__kernel_time_t		shm_dtime;	/* last detach time */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int		__pad3;
 #endif
 	__kernel_time_t		shm_ctime;	/* last change time */
-#ifndef CONFIG_64BIT
+#if __BITS_PER_LONG == 32
 	unsigned int		__pad4;
 #endif
 	size_t			shm_segsz;	/* size of segment (bytes) */
@@ -36,13 +38,12 @@ struct shmid64_ds {
 	unsigned int		__unused2;
 };
 
-#ifdef CONFIG_64BIT
+
 /* The 'unsigned int' (formerly 'unsigned long') data types below will
  * ensure that a 32-bit app calling shmctl(*,IPC_INFO,*) will work on
  * a wide kernel, but if some of these values are meant to contain pointers
  * they may need to be 'long long' instead. -PB XXX FIXME
  */
-#endif
 struct shminfo64 {
 	unsigned int	shmmax;
 	unsigned int	shmmin;
diff --git a/arch/parisc/include/asm/signal.h b/arch/parisc/include/asm/signal.h
index c203563..3de6265 100644
--- a/arch/parisc/include/asm/signal.h
+++ b/arch/parisc/include/asm/signal.h
@@ -105,7 +105,7 @@
 struct siginfo;
 
 /* Type of a signal handler.  */
-#ifdef CONFIG_64BIT
+#if __BITS_PER_LONG == 64
 /* function pointers on 64-bit parisc are pointers to little structs and the
  * compiler doesn't support code which changes or tests the address of
  * the function in the little struct.  This is really ugly -PB
diff --git a/arch/parisc/include/asm/swab.h b/arch/parisc/include/asm/swab.h
index 3ff16c5..e78403b 100644
--- a/arch/parisc/include/asm/swab.h
+++ b/arch/parisc/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _PARISC_SWAB_H
 #define _PARISC_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #define __SWAB_64_THRU_32__
diff --git a/arch/parisc/include/asm/types.h b/arch/parisc/include/asm/types.h
index 7f5a39b..14bb5bd 100644
--- a/arch/parisc/include/asm/types.h
+++ b/arch/parisc/include/asm/types.h
@@ -9,6 +9,14 @@ typedef unsigned short umode_t;
 
 #endif /* __ASSEMBLY__ */
 
+#ifndef __KERNEL__
+#ifdef __LP64__
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif /* __LP64__ */
+#endif /* __KERNEL__ */
+
 /*
  * These aren't exported outside the kernel to avoid name space clashes
  */
@@ -22,6 +30,8 @@ typedef unsigned short umode_t;
 #define SHIFT_PER_LONG 5
 #endif
 
+#define __BITS_PER_LONG	BITS_PER_LONG
+
 #ifndef __ASSEMBLY__
 
 /* Dma addresses are 32-bits wide.  */
