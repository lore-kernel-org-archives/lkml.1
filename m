Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZDHHZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZDHHZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbZDHHZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:25:13 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:55302 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZDHHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:25:05 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 3/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFB4C04512.1940B13F-ON48257592.0028600F-48257592.0028AAF4@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:22:03 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:22:04,
	Serialize complete at 2009/04/08 ?? 03:22:04
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Liqin <liqin.chen@sunplusct.com>

asm/cputime.h, asm/current.h, asm/delay.h, asm/device.h, asm/div64.h,
asm/dma.h, asm/dma-mapping.h, asm/elf.h, asm/emergency-restart.h, 
asm/errno.h,
asm/fb.h, asm/fcntl.h, asm/fixmap.h, asm/futex.h, asm/hardirq.h, 
asm/hw_irq.h,
asm/ioctl.h, asm/ioctls.h, asm/io.h, asm/ipcbuf.h, asm/irqflags.h, 
asm/irq.h,
asm/irq_regs.h, asm/Kbuild and asm/kdebug.h for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/cputime.h 
linux-2.6-git.new/arch/score/include/asm/cputime.h
--- linux-2.6-git.ori/arch/score/include/asm/cputime.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/cputime.h  2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_CPUTIME_H
+#define __SCORE_CPUTIME_H
+
+#include <asm-generic/cputime.h>
+
+#endif /* __SCORE_CPUTIME_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/current.h 
linux-2.6-git.new/arch/score/include/asm/current.h
--- linux-2.6-git.ori/arch/score/include/asm/current.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/current.h  2009-04-07 
20:18:06.000000000 +0800
@@ -0,0 +1,15 @@
+#ifndef __SCORE_CURRENT_H
+#define __SCORE_CURRENT_H
+
+#include <linux/thread_info.h>
+
+struct task_struct;
+
+static inline struct task_struct *get_current(void)
+{
+       return current_thread_info()->task;
+}
+
+#define current                get_current()
+
+#endif /* __SCORE_CURRENT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/delay.h 
linux-2.6-git.new/arch/score/include/asm/delay.h
--- linux-2.6-git.ori/arch/score/include/asm/delay.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/delay.h    2009-04-03 
16:57:44.000000000 +0800
@@ -0,0 +1,37 @@
+#ifndef __SCORE_DELAY_H
+#define __SCORE_DELAY_H
+
+#include <linux/param.h>
+
+static inline void __delay(unsigned long loops)
+{}
+
+/*
+ * Division by multiplication: you don't have to worry about
+ * loss of precision.
+ *
+ * Use only for very small delays ( < 1 msec).  Should probably use a
+ * lookup table, really, as the multiplications take much too long with
+ * short delays.  This is a "reasonable" implementation, though (and the
+ * first constant multiplications gets optimized away if the delay is
+ * a constant)
+ */
+
+static inline void __udelay(unsigned long usecs, unsigned long lpj)
+{
+       __delay(usecs);
+}
+
+#define __udelay_val   1
+#define udelay(usecs) __udelay((usecs), __udelay_val)
+
+/* make sure "usecs *= ..." in udelay do not overflow. */
+#if HZ >= 1000
+#define MAX_UDELAY_MS  1
+#elif HZ <= 200
+#define MAX_UDELAY_MS  5
+#else
+#define MAX_UDELAY_MS  (1000 / HZ)
+#endif
+
+#endif /* __SCORE_DELAY_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/device.h 
linux-2.6-git.new/arch/score/include/asm/device.h
--- linux-2.6-git.ori/arch/score/include/asm/device.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/device.h   2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,2 @@
+#include <asm-generic/device.h>
+
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/div64.h 
linux-2.6-git.new/arch/score/include/asm/div64.h
--- linux-2.6-git.ori/arch/score/include/asm/div64.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/div64.h    2009-04-03 
16:57:55.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_DIV64_H
+#define __SCORE_DIV64_H
+
+#include <asm-generic/div64.h>
+
+#endif /* __SCORE_DIV64_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/dma.h 
linux-2.6-git.new/arch/score/include/asm/dma.h
--- linux-2.6-git.ori/arch/score/include/asm/dma.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/dma.h      2009-04-08 
09:02:35.000000000 +0800
@@ -0,0 +1,17 @@
+#ifndef __SCORE_DMA_H
+#define __SCORE_DMA_H
+
+#include <linux/spinlock.h>            /* And spinlocks */
+#include <linux/delay.h>
+
+#include <asm/system.h>
+#include <asm/io.h>                    /* need byte IO */
+
+#define MAX_DMA_ADDRESS                (PAGE_OFFSET + 0x01000000)
+
+/* reserve a DMA channel */
+extern int request_dma(unsigned int dmanr, const char *device_id);
+/* release it again */
+extern void free_dma(unsigned int dmanr);
+
+#endif /* __SCORE_DMA_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/dma-mapping.h 
linux-2.6-git.new/arch/score/include/asm/dma-mapping.h
--- linux-2.6-git.ori/arch/score/include/asm/dma-mapping.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/dma-mapping.h      2009-04-03 
16:58:15.000000000 +0800
@@ -0,0 +1,51 @@
+#ifndef __SCORE_DMA_MAPPING_H
+#define __SCORE_DMA_MAPPING_H
+
+#include <asm/scatterlist.h>
+#include <asm/cache.h>
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_noncoherent(struct device *dev, size_t size,
+       void *vaddr, dma_addr_t dma_handle);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_coherent(struct device *dev, size_t size,
+       void *vaddr, dma_addr_t dma_handle);
+
+extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t 
size,
+       enum dma_data_direction direction);
+extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+       size_t size, enum dma_data_direction direction);
+extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int 
nents,
+       enum dma_data_direction direction);
+extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction);
+extern void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+       size_t size, enum dma_data_direction direction);
+extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+       int nhwentries, enum dma_data_direction direction);
+extern void dma_sync_single_for_cpu(struct device *dev, dma_addr_t 
dma_handle,
+       size_t size, enum dma_data_direction direction);
+extern void dma_sync_single_for_device(struct device *dev,
+       dma_addr_t dma_handle, size_t size, enum dma_data_direction 
direction);
+extern void dma_sync_single_range_for_cpu(struct device *dev,
+       dma_addr_t dma_handle, unsigned long offset, size_t size,
+       enum dma_data_direction direction);
+extern void dma_sync_single_range_for_device(struct device *dev,
+       dma_addr_t dma_handle, unsigned long offset, size_t size,
+       enum dma_data_direction direction);
+extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist 
*sg,
+       int nelems, enum dma_data_direction direction);
+extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist 
*sg,
+       int nelems, enum dma_data_direction direction);
+extern int dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
+extern int dma_supported(struct device *dev, u64 mask);
+extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
+extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+       enum dma_data_direction direction);
+
+#endif /* __SCORE_DMA_MAPPING_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/elf.h 
linux-2.6-git.new/arch/score/include/asm/elf.h
--- linux-2.6-git.ori/arch/score/include/asm/elf.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/elf.h      2009-04-07 
20:19:45.000000000 +0800
@@ -0,0 +1,119 @@
+#ifndef __SCORE_ELF_H
+#define __SCORE_ELF_H
+
+/* ELF register definitions */
+#define ELF_NGREG      45
+#define ELF_NFPREG     33
+#define EM_SCORE7      135
+
+/* Relocation types. */
+#define R_SCORE_NONE           0
+#define R_SCORE_HI16           1
+#define R_SCORE_LO16           2
+#define R_SCORE_BCMP           3
+#define R_SCORE_24             4
+#define R_SCORE_PC19           5
+#define R_SCORE16_11           6
+#define R_SCORE16_PC8          7
+#define R_SCORE_ABS32          8
+#define R_SCORE_ABS16          9
+#define R_SCORE_DUMMY2         10
+#define R_SCORE_GP15           11
+#define R_SCORE_GNU_VTINHERIT  12
+#define R_SCORE_GNU_VTENTRY    13
+#define R_SCORE_GOT15          14
+#define R_SCORE_GOT_LO16       15
+#define R_SCORE_CALL15         16
+#define R_SCORE_GPREL32                17
+#define R_SCORE_REL32          18
+#define R_SCORE_DUMMY_HI16     19
+#define R_SCORE_IMM30          20
+#define R_SCORE_IMM32          21
+
+
+typedef unsigned long elf_greg_t;
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef double elf_fpreg_t;
+typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+
+/*
+ * This is used to ensure we don't load something for the wrong 
architecture.
+ */
+#define elf_check_arch(hdr)                            \
+({                                                     \
+       int __res = 1;                                  \
+       struct elfhdr *__h = (hdr);                     \
+                                                       \
+       if (__h->e_ident[EI_CLASS] != ELFCLASS32)       \
+               __res = 0;                              \
+                                                       \
+       __res;                                          \
+})
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS      ELFCLASS32
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_DATA       ELFDATA2LSB
+#define ELF_ARCH       EM_SCORE7
+
+#define SET_PERSONALITY(ex)                                            \
+do {                                                                   \
+       set_personality(PER_LINUX);                                     \
+} while (0)
+
+struct task_struct;
+struct pt_regs;
+
+extern void elf_dump_regs(elf_greg_t *, struct pt_regs *regs);
+extern int dump_task_regs(struct task_struct *, elf_gregset_t *);
+
+#define ELF_CORE_COPY_REGS(elf_regs, regs)             \
+       elf_dump_regs((elf_greg_t *)&(elf_regs), regs);
+#define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk, 
elf_regs)
+
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE      PAGE_SIZE
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  This could be done in userspace,
+   but it's not easy, and we've already done it here.  */
+
+#define ELF_HWCAP      (0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.
+
+   For the moment, we have only optimizations for the Intel generations,
+   but that could change... */
+
+#define ELF_PLATFORM   (NULL)
+
+#define ELF_PLAT_INIT(_r, load_addr)                                   \
+do {                                                                   \
+       _r->regs[1] = _r->regs[2] = _r->regs[3] = _r->regs[4] = 0;      \
+       _r->regs[5] = _r->regs[6] = _r->regs[7] = _r->regs[8] = 0;      \
+       _r->regs[9] = _r->regs[10] = _r->regs[11] = _r->regs[12] = 0;   \
+       _r->regs[13] = _r->regs[14] = _r->regs[15] = _r->regs[16] = 0;  \
+       _r->regs[17] = _r->regs[18] = _r->regs[19] = _r->regs[20] = 0;  \
+       _r->regs[21] = _r->regs[22] = _r->regs[23] = _r->regs[24] = 0;  \
+       _r->regs[25] = _r->regs[26] = _r->regs[27] = _r->regs[28] = 0;  \
+       _r->regs[30] = _r->regs[31] = 0;                                \
+} while (0)
+
+/* This is the location that an ET_DYN program is loaded if exec'ed. 
Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version 
of
+   the loader.  We need to make sure that it is out of the way of the 
program
+   that it will "exec", and that there is sufficient room for the brk. */
+
+#ifndef ELF_ET_DYN_BASE
+#define ELF_ET_DYN_BASE                (TASK_SIZE / 3 * 2)
+#endif
+
+#endif /* __SCORE_ELF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/emergency-restart.h 
linux-2.6-git.new/arch/score/include/asm/emergency-restart.h
--- linux-2.6-git.ori/arch/score/include/asm/emergency-restart.h 
1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/emergency-restart.h 
2009-04-03 16:58:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_EMERGENCY_RESTART_H
+#define __SCORE_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* __SCORE_EMERGENCY_RESTART_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/errno.h 
linux-2.6-git.new/arch/score/include/asm/errno.h
--- linux-2.6-git.ori/arch/score/include/asm/errno.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/errno.h    2009-04-03 
16:58:42.000000000 +0800
@@ -0,0 +1,124 @@
+#ifndef __SCORE_ERRNO_H
+#define __SCORE_ERRNO_H
+
+/*
+ * These error numbers are intended to be SCORE ABI compatible
+ */
+
+#include <asm-generic/errno-base.h>
+
+#define        ENOMSG          35      /* No message of desired type */
+#define        EIDRM           36      /* Identifier removed */
+#define        ECHRNG          37      /* Channel number out of range */
+#define        EL2NSYNC        38      /* Level 2 not synchronized */
+#define        EL3HLT          39      /* Level 3 halted */
+#define        EL3RST          40      /* Level 3 reset */
+#define        ELNRNG          41      /* Link number out of range */
+#define        EUNATCH         42      /* Protocol driver not attached */
+#define        ENOCSI          43      /* No CSI structure available */
+#define        EL2HLT          44      /* Level 2 halted */
+#define        EDEADLK         45      /* Resource deadlock would occur 
*/
+#define        ENOLCK          46      /* No record locks available */
+#define        EBADE           50      /* Invalid exchange */
+#define        EBADR           51      /* Invalid request descriptor */
+#define        EXFULL          52      /* Exchange full */
+#define        ENOANO          53      /* No anode */
+#define        EBADRQC         54      /* Invalid request code */
+#define        EBADSLT         55      /* Invalid slot */
+#define        EDEADLOCK       56      /* File locking deadlock error */
+#define        EBFONT          59      /* Bad font file format */
+#define        ENOSTR          60      /* Device not a stream */
+#define        ENODATA         61      /* No data available */
+#define        ETIME           62      /* Timer expired */
+#define        ENOSR           63      /* Out of streams resources */
+#define        ENONET          64      /* Machine is not on the network 
*/
+#define        ENOPKG          65      /* Package not installed */
+#define        EREMOTE         66      /* Object is remote */
+#define        ENOLINK         67      /* Link has been severed */
+#define        EADV            68      /* Advertise error */
+#define        ESRMNT          69      /* Srmount error */
+#define        ECOMM           70      /* Communication error on send */
+#define        EPROTO          71      /* Protocol error */
+#define        EDOTDOT         73      /* RFS specific error */
+#define        EMULTIHOP       74      /* Multihop attempted */
+#define        EBADMSG         77      /* Not a data message */
+#define        ENAMETOOLONG    78      /* File name too long */
+#define        EOVERFLOW       79      /* Value too large for defined 
data type */
+#define        ENOTUNIQ        80      /* Name not unique on network */
+#define        EBADFD          81      /* File descriptor in bad state */
+#define        EREMCHG         82      /* Remote address changed */
+#define        ELIBACC         83      /* Can not access a needed shared 
library */
+#define        ELIBBAD         84      /* Accessing a corrupted shared 
library */
+#define        ELIBSCN         85      /* .lib section in a.out corrupted 
*/
+#define        ELIBMAX         86      /* Attempting to link in too many 
shared libraries */
+#define        ELIBEXEC        87      /* Cannot exec a shared library 
directly */
+#define        EILSEQ          88      /* Illegal byte sequence */
+#define        ENOSYS          89      /* Function not implemented */
+#define        ELOOP           90      /* Too many symbolic links 
encountered */
+#define        ERESTART        91      /* Interrupted system call should 
be restarted */
+#define        ESTRPIPE        92      /* Streams pipe error */
+#define        ENOTEMPTY       93      /* Directory not empty */
+#define        EUSERS          94      /* Too many users */
+#define        ENOTSOCK        95      /* Socket operation on non-socket 
*/
+#define        EDESTADDRREQ    96      /* Destination address required */
+#define        EMSGSIZE        97      /* Message too long */
+#define        EPROTOTYPE      98      /* Protocol wrong type for socket 
*/
+#define        ENOPROTOOPT     99      /* Protocol not available */
+#define        EPROTONOSUPPORT 120     /* Protocol not supported */
+#define        ESOCKTNOSUPPORT 121     /* Socket type not supported */
+#define        EOPNOTSUPP      122     /* Operation not supported on 
transport endpoint */
+#define        EPFNOSUPPORT    123     /* Protocol family not supported 
*/
+#define        EAFNOSUPPORT    124     /* Address family not supported by 
protocol */
+#define        EADDRINUSE      125     /* Address already in use */
+#define        EADDRNOTAVAIL   126     /* Cannot assign requested address 
*/
+#define        ENETDOWN        127     /* Network is down */
+#define        ENETUNREACH     128     /* Network is unreachable */
+#define        ENETRESET       129     /* Network dropped connection 
because of reset */
+#define        ECONNABORTED    130     /* Software caused connection 
abort */
+#define        ECONNRESET      131     /* Connection reset by peer */
+#define        ENOBUFS         132     /* No buffer space available */
+#define        EISCONN         133     /* Transport endpoint is already 
connected */
+#define        ENOTCONN        134     /* Transport endpoint is not 
connected */
+#define        EUCLEAN         135     /* Structure needs cleaning */
+#define        ENOTNAM         137     /* Not a XENIX named type file */
+#define        ENAVAIL         138     /* No XENIX semaphores available 
*/
+#define        EISNAM          139     /* Is a named type file */
+#define        EREMOTEIO       140     /* Remote I/O error */
+#define        EINIT           141     /* Reserved */
+#define        EREMDEV         142     /* Error 142 */
+#define        ESHUTDOWN       143     /* Cannot send after transport 
endpoint shutdown */
+#define        ETOOMANYREFS    144     /* Too many references: cannot 
splice */
+#define        ETIMEDOUT       145     /* Connection timed out */
+#define        ECONNREFUSED    146     /* Connection refused */
+#define        EHOSTDOWN       147     /* Host is down */
+#define        EHOSTUNREACH    148     /* No route to host */
+#define        EWOULDBLOCK     EAGAIN  /* Operation would block */
+#define        EALREADY        149     /* Operation already in progress 
*/
+#define        EINPROGRESS     150     /* Operation now in progress */
+#define        ESTALE          151     /* Stale NFS file handle */
+#define        ECANCELED       158     /* AIO operation canceled */
+
+/*
+ * These error are Linux extensions.
+ */
+#define        ENOMEDIUM       159     /* No medium found */
+#define        EMEDIUMTYPE     160     /* Wrong medium type */
+#define        ENOKEY          161     /* Required key not available */
+#define        EKEYEXPIRED     162     /* Key has expired */
+#define        EKEYREVOKED     163     /* Key has been revoked */
+#define        EKEYREJECTED    164     /* Key was rejected by service */
+
+/* for robust mutexes */
+#define        EOWNERDEAD      165     /* Owner died */
+#define        ENOTRECOVERABLE 166     /* State not recoverable */
+
+#define EDQUOT         1133    /* Quota exceeded */
+
+#ifdef __KERNEL__
+
+/* The biggest error number defined here or in <linux/errno.h>. */
+#define EMAXERRNO      1133
+
+#endif /* __KERNEL__ */
+
+#endif /* __SCORE_ERRNO_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/fb.h 
linux-2.6-git.new/arch/score/include/asm/fb.h
--- linux-2.6-git.ori/arch/score/include/asm/fb.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/fb.h       2009-04-03 
16:58:55.000000000 +0800
@@ -0,0 +1,18 @@
+#ifndef __SCORE_FB_H_
+#define __SCORE_FB_H_
+
+#include <linux/fb.h>
+#include <linux/fs.h>
+
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct 
*vma,
+                               unsigned long off)
+{}
+
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+       return 0;
+}
+
+#endif /* __SCORE_FB_H_ */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/fcntl.h 
linux-2.6-git.new/arch/score/include/asm/fcntl.h
--- linux-2.6-git.ori/arch/score/include/asm/fcntl.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/fcntl.h    2009-04-03 
16:59:02.000000000 +0800
@@ -0,0 +1,47 @@
+#ifndef __SCORE_FCNTL_H
+#define __SCORE_FCNTL_H
+
+#define O_APPEND       0x0008
+#define O_SYNC         0x0010
+#define O_NONBLOCK     0x0080
+#define O_CREAT                0x0100  /* not fcntl */
+#define O_TRUNC                0x0200  /* not fcntl */
+#define O_EXCL         0x0400  /* not fcntl */
+#define O_NOCTTY       0x0800  /* not fcntl */
+#define FASYNC         0x1000  /* fcntl, for BSD compatibility */
+#define O_LARGEFILE    0x2000  /* allow large file opens */
+#define O_DIRECT       0x8000  /* direct disk access hint */
+
+#define F_GETLK                14
+#define F_SETLK                6
+#define F_SETLKW       7
+
+#define F_SETOWN       24      /* for sockets. */
+#define F_GETOWN       23      /* for sockets. */
+
+#define F_GETLK64      33      /* using 'struct flock64' */
+#define F_SETLK64      34
+#define F_SETLKW64     35
+
+/*
+ * The flavours of struct flock.  "struct flock" is the ABI compliant
+ * variant.  Finally struct flock64 is the LFS variant of struct flock. 
As
+ * a historic accident and inconsistence with the ABI definition it 
doesn't
+ * contain all the same fields as struct flock.
+ */
+
+struct flock {
+       short   l_type;
+       short   l_whence;
+       off_t   l_start;
+       off_t   l_len;
+       long    l_sysid;
+       __kernel_pid_t l_pid;
+       long    pad[4];
+};
+
+#define HAVE_ARCH_STRUCT_FLOCK
+
+#include <asm-generic/fcntl.h>
+
+#endif /* __SCORE_FCNTL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/fixmap.h 
linux-2.6-git.new/arch/score/include/asm/fixmap.h
--- linux-2.6-git.ori/arch/score/include/asm/fixmap.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/fixmap.h   2009-04-08 
09:04:00.000000000 +0800
@@ -0,0 +1,87 @@
+#ifndef __SCORE_FIXMAP_H
+#define __SCORE_FIXMAP_H
+
+#include <asm/page.h>
+
+#define PHY_RAM_BASE           0x00000000
+#define PHY_IO_BASE            0x10000000
+
+#define VIRTUAL_RAM_BASE       0xa0000000
+#define VIRTUAL_IO_BASE                0xb0000000
+
+#define RAM_SPACE_SIZE         0x10000000
+#define IO_SPACE_SIZE          0x10000000
+
+/* Kernel unmapped, cached 512MB  */
+#define KSEG1                  0xa0000000
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process. We allocate these special  addresses
+ * from the end of virtual memory (0xfffff000) backwards.
+ * Also this lets us do fail-safe vmalloc(), we
+ * can guarantee that these special addresses and
+ * vmalloc()-ed addresses never overlap.
+ *
+ * these 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages. (or larger if used with an increment
+ * highger than 1) use fixmap_set(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ * TLB entries of such buffers will not be flushed across
+ * task switches.
+ */
+
+/*
+ * on UP currently we will have no trace of the fixmap mechanizm,
+ * no page table allocations, etc. This might change in the
+ * future, say framebuffers for the console driver(s) could be
+ * fix-mapped?
+ */
+enum fixed_addresses {
+#define FIX_N_COLOURS 8
+       FIX_CMAP_BEGIN,
+       FIX_CMAP_END = FIX_CMAP_BEGIN + FIX_N_COLOURS,
+       __end_of_fixed_addresses
+};
+
+/*
+ * used by vmalloc.c.
+ *
+ * Leave one empty page between vmalloc'ed areas and
+ * the start of the fixmap, and leave one page empty
+ * at the top of mem..
+ */
+#define FIXADDR_TOP    ((unsigned long)(long)(int)0xfefe0000)
+#define FIXADDR_SIZE   (__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START  (FIXADDR_TOP - FIXADDR_SIZE)
+
+#define __fix_to_virt(x)       (FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)       ((FIXADDR_TOP - ((x)&PAGE_MASK)) >> 
PAGE_SHIFT)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without tranlation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static inline unsigned long fix_to_virt(const unsigned int idx)
+{
+       return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+       return __virt_to_fix(vaddr);
+}
+
+/*
+ * Called from pgtable_init()
+ */
+extern void fixrange_init(unsigned long start, unsigned long end,
+                       pgd_t *pgd_base);
+
+#endif
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/futex.h 
linux-2.6-git.new/arch/score/include/asm/futex.h
--- linux-2.6-git.ori/arch/score/include/asm/futex.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/futex.h    2009-04-03 
16:59:26.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_FUTEX_H
+#define __SCORE_FUTEX_H
+
+#include <asm-generic/futex.h>
+
+#endif /* __SCORE_FUTEX_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/hardirq.h 
linux-2.6-git.new/arch/score/include/asm/hardirq.h
--- linux-2.6-git.ori/arch/score/include/asm/hardirq.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/hardirq.h  2009-04-08 
10:11:29.000000000 +0800
@@ -0,0 +1,16 @@
+#ifndef __SCORE_HARDIRQ_H
+#define __SCORE_HARDIRQ_H
+
+#include <linux/threads.h>
+#include <linux/irq.h>
+
+typedef struct {
+       unsigned int __softirq_pending;
+} ____cacheline_aligned irq_cpustat_t;
+
+/* Standard mappings for irq_cpustat_t above */
+#include <linux/irq_cpustat.h>
+
+extern void ack_bad_irq(unsigned int irq);
+
+#endif /* __SCORE_HARDIRQ_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/hw_irq.h 
linux-2.6-git.new/arch/score/include/asm/hw_irq.h
--- linux-2.6-git.ori/arch/score/include/asm/hw_irq.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/hw_irq.h   2009-04-03 
16:59:44.000000000 +0800
@@ -0,0 +1,8 @@
+#ifndef ___SCORE_HW_IRQ_H
+#define ___SCORE_HW_IRQ_H
+
+#include <asm/atomic.h>
+
+extern atomic_t irq_err_count;
+
+#endif /* ___SCORE_HW_IRQ_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ioctl.h 
linux-2.6-git.new/arch/score/include/asm/ioctl.h
--- linux-2.6-git.ori/arch/score/include/asm/ioctl.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ioctl.h    2009-04-03 
17:35:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __SCORE_IOCTL_H
+#define __SCORE_IOCTL_H
+
+#include <asm-generic/ioctl.h>
+
+#endif /* __SCORE_IOCTL_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ioctls.h 
linux-2.6-git.new/arch/score/include/asm/ioctls.h
--- linux-2.6-git.ori/arch/score/include/asm/ioctls.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ioctls.h   2009-04-07 
20:20:31.000000000 +0800
@@ -0,0 +1,87 @@
+#ifndef ___SCORE_SCORE_IOCTLS_H
+#define ___SCORE_SCORE_IOCTLS_H
+
+#include <asm/ioctl.h>
+
+/* 0x54 is just a magic number to make these relatively unique ('T') */
+
+#define TCGETS         0x5401
+#define TCSETS         0x5402 /* Clashes with SNDCTL_TMR_START sound 
ioctl */
+#define TCSETSW                0x5403
+#define TCSETSF                0x5404
+#define TCGETA         0x5405
+#define TCSETA         0x5406
+#define TCSETAW                0x5407
+#define TCSETAF                0x5408
+#define TCSBRK         0x5409
+#define TCXONC         0x540A
+#define TCFLSH         0x540B
+#define TIOCEXCL       0x540C
+#define TIOCNXCL       0x540D
+#define TIOCSCTTY      0x540E
+#define TIOCGPGRP      0x540F
+#define TIOCSPGRP      0x5410
+#define TIOCOUTQ       0x5411
+#define TIOCSTI                0x5412
+#define TIOCGWINSZ     0x5413
+#define TIOCSWINSZ     0x5414
+#define TIOCMGET       0x5415
+#define TIOCMBIS       0x5416
+#define TIOCMBIC       0x5417
+#define TIOCMSET       0x5418
+#define TIOCGSOFTCAR   0x5419
+#define TIOCSSOFTCAR   0x541A
+#define FIONREAD       0x541B
+#define TIOCINQ                FIONREAD
+#define TIOCLINUX      0x541C
+#define TIOCCONS       0x541D
+#define TIOCGSERIAL    0x541E
+#define TIOCSSERIAL    0x541F
+#define TIOCPKT                0x5420
+#define FIONBIO                0x5421
+#define TIOCNOTTY      0x5422
+#define TIOCSETD       0x5423
+#define TIOCGETD       0x5424
+#define TCSBRKP                0x5425  /* Needed for POSIX tcsendbreak() 
*/
+/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
+#define TIOCSBRK       0x5427  /* BSD compatibility */
+#define TIOCCBRK       0x5428  /* BSD compatibility */
+#define TIOCGSID       0x5429  /* Return the session ID of FD */
+#define TCGETS2                _IOR('T', 0x2A, struct termios2)
+#define TCSETS2                _IOW('T', 0x2B, struct termios2)
+#define TCSETSW2       _IOW('T', 0x2C, struct termios2)
+#define TCSETSF2       _IOW('T', 0x2D, struct termios2)
+#define TIOCGPTN       _IOR('T', 0x30, unsigned int) /* Get Pty Number 
(of pty-mux device) */
+#define TIOCSPTLCK     _IOW('T', 0x31, int)    /* Lock/unlock Pty */
+
+#define FIONCLEX       0x5450
+#define FIOCLEX                0x5451
+#define FIOASYNC       0x5452
+#define TIOCSERCONFIG  0x5453
+#define TIOCSERGWILD   0x5454
+#define TIOCSERSWILD   0x5455
+#define TIOCGLCKTRMIOS 0x5456
+#define TIOCSLCKTRMIOS 0x5457
+#define TIOCSERGSTRUCT 0x5458 /* For debugging only */
+#define TIOCSERGETLSR  0x5459 /* Get line status register */
+#define TIOCSERGETMULTI 0x545A /* Get multiport config */
+#define TIOCSERSETMULTI 0x545B /* Set multiport config */
+
+#define TIOCMIWAIT     0x545C  /* wait for a change on serial input 
line(s) */
+#define TIOCGICOUNT    0x545D  /* read serial port inline interrupt 
counts */
+#define TIOCGHAYESESP  0x545E  /* Get Hayes ESP configuration */
+#define TIOCSHAYESESP  0x545F  /* Set Hayes ESP configuration */
+#define FIOQSIZE       0x5460
+
+/* Used for packet mode */
+#define TIOCPKT_DATA            0
+#define TIOCPKT_FLUSHREAD       1
+#define TIOCPKT_FLUSHWRITE      2
+#define TIOCPKT_STOP            4
+#define TIOCPKT_START           8
+#define TIOCPKT_NOSTOP         16
+#define TIOCPKT_DOSTOP         32
+
+#define TIOCSER_TEMT   0x01    /* Transmitter physically empty */
+
+#endif /* ___SCORE_SCORE_IOCTLS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/io.h 
linux-2.6-git.new/arch/score/include/asm/io.h
--- linux-2.6-git.ori/arch/score/include/asm/io.h       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/io.h       2009-04-07 
20:22:48.000000000 +0800
@@ -0,0 +1,196 @@
+#ifndef __SCORE_IO_H
+#define __SCORE_IO_H
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+#include <asm/byteorder.h>
+#include <asm-generic/iomap.h>
+#include <asm/page.h>
+#include <asm/pgtable-bits.h>
+#include <asm/processor.h>
+#include <asm/string.h>
+
+#if defined(CONFIG_SWAP_IO_SPACE) && defined(__SCOREEB__)
+#define __ioswab16(x) swab16(x)
+#define __ioswab32(x) swab32(x)
+#else
+#define __ioswab16(x) (x)
+#define __ioswab32(x) (x)
+#endif
+
+#define readb(addr)            (*(volatile unsigned char *)addr)
+#define readw(addr)            __ioswab16(*(volatile unsigned short 
*)addr)
+#define readl(addr)            __ioswab32(*(volatile unsigned int *)addr)
+#define writeb(b, addr)                (*(volatile unsigned char *)addr = 
(b))
+#define writew(b, addr)                (*(volatile unsigned short *)addr 
= __ioswab16(b))
+#define writel(b, addr)                (*(volatile unsigned int *)addr = 
__ioswab32(b))
+
+#define __raw_readb(addr)      (*(volatile unsigned char *)addr)
+#define __raw_readw(addr)      (*(volatile unsigned short *)addr)
+#define __raw_readl(addr)      (*(volatile unsigned int *)addr)
+#define __raw_readq(addr)      (*(volatile unsigned long long *)addr)
+#define __raw_writeb(b, addr)  (*(volatile unsigned char *)addr = (b))
+#define __raw_writew(b, addr)  (*(volatile unsigned short *)addr = (b))
+#define __raw_writel(b, addr)  (*(volatile unsigned int *)addr = (b))
+#define __raw_writeq(b, addr)  (*(volatile unsigned long long *)addr = 
(b))
+
+#define inb(port)              __inb(port)
+#define inw(port)              __inw(port)
+#define inl(port)              __inl(port)
+#define outb(val, port)                (*(volatile u8 *)port = val)
+#define outw(val, port)                (*(volatile u16 *)port = val)
+#define outl(val, port)                (*(volatile u32 *)port = val)
+
+#define inb_p(port)            __inb_p(port)
+#define inw_p(port)            __inw_p(port)
+#define inl_p(port)            __inl_p(port)
+#define outb_p(val, port)      (*(volatile u8 *)port = val)
+#define outw_p(val, port)      (*(volatile u16 *)port = val)
+#define outl_p(val, port)      (*(volatile u32 *)port = val)
+
+#define insb(port, addr, count)                __insb(port, addr, count)
+#define insw(port, addr, count)                __insw(port, addr, count)
+#define insl(port, addr, count)                __insl(port, addr, count)
+#define outsb(port, addr, count)       __outsb(port, addr, count)
+#define outsw(port, addr, count)       __outsw(port, addr, count)
+#define outsl(port, addr, count)       __outsl(port, addr, count)
+
+static inline unsigned char __inb(unsigned long port)
+{
+       return *(volatile u8 *)(port);
+}
+
+static inline unsigned short __inw(unsigned long port)
+{
+       return *(volatile u16 *)(port);
+}
+
+static inline unsigned int __inl(unsigned long port)
+{
+       return *(volatile u32 *)(port);
+}
+
+static inline unsigned char __inb_p(unsigned long port)
+{
+       u8 __val;
+       __val = *(volatile u8 *)(port);
+       return __val;
+}
+
+static inline unsigned short __inw_p(unsigned long port)
+{
+       u16 __val;
+       __val = *(volatile u16 *)(port);
+       return __val;
+}
+
+static inline unsigned long __inl_p(unsigned long port)
+{
+       u32 __val;
+       __val = *(volatile u32 *)(port);
+       return __val;
+}
+
+static inline void
+__insb(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               *(u8 *)addr = inb(port);
+               addr++;
+       }
+}
+
+static inline void
+__insw(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               *(u16 *)addr = inw(port);
+               addr += 2;
+       }
+}
+
+static inline void
+__insl(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               *(u32 *)addr = inl(port);
+               addr += 4;
+       }
+}
+
+static inline void
+__outsb(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               outb(*(u8 *)addr, port);
+               addr++;
+       }
+}
+
+static inline void
+__outsw(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               outb(*(u16 *)addr, port);
+               addr += 2;
+       }
+}
+
+
+static inline void
+__outsl(unsigned long port, void *addr, unsigned long count)
+{
+       while (count--) {
+               outb(*(u32 *)addr, port);
+               addr += 4;
+       }
+}
+
+#define IO_SPACE_LIMIT 0xffff
+#define xlate_dev_mem_ptr(p)   __va(p)
+#define xlate_dev_kmem_ptr(p)  p
+
+static inline void
+memset_io(volatile void __iomem *addr, unsigned char val, int count)
+{
+       memset((void __force *)addr, val, count);
+}
+
+static inline void
+memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
+{
+       memcpy(dst, (void __force *)src, count);
+}
+
+static inline void
+memcpy_toio(volatile void __iomem *dst, const void *src, int count)
+{
+       memcpy((void __force *)dst, src, count);
+}
+
+#define isa_page_to_bus page_to_phys
+
+/*
+ * However PCI ones are not necessarily 1:1 and therefore these 
interfaces
+ * are forbidden in portable PCI drivers.
+ *
+ * Allow them for x86 for legacy drivers, though.
+ */
+#define virt_to_bus virt_to_phys
+#define bus_to_virt phys_to_virt
+
+/*
+ * Change "struct page" to physical address.
+ */
+#define page_to_phys(page)     ((dma_addr_t)page_to_pfn(page) << 
PAGE_SHIFT)
+
+extern void __iomem *__ioremap(unsigned long offset, unsigned long size, 
unsigned long flags);
+extern void __iounmap(const volatile void __iomem *addr);
+
+#define ioremap(offset, size)          __ioremap((offset), (size), 
_CACHE_UNCACHED)
+#define ioremap_nocache(offset, size)  __ioremap((offset), (size), 
_CACHE_UNCACHED)
+#define iounmap(offset)                        __iounmap(offset)
+
+#endif /* __SCORE_IO_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ipcbuf.h 
linux-2.6-git.new/arch/score/include/asm/ipcbuf.h
--- linux-2.6-git.ori/arch/score/include/asm/ipcbuf.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ipcbuf.h   2009-04-07 
20:23:32.000000000 +0800
@@ -0,0 +1,29 @@
+#ifndef _SCORE_IPCBUF_H
+#define _SCORE_IPCBUF_H
+
+#include <linux/types.h>
+
+/*
+ * The ipc64_perm structure for alpha architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 32-bit seq
+ * - 2 miscellaneous 64-bit values
+ */
+
+struct ipc64_perm {
+       __kernel_key_t  key;
+       __kernel_uid_t  uid;
+       __kernel_gid_t  gid;
+       __kernel_uid_t  cuid;
+       __kernel_gid_t  cgid;
+       __kernel_mode_t mode;
+       __u32 seq;
+       __u32 __pad1;
+       __u32 __unused1;
+       __u32 __unused2;
+};
+
+#endif /* _SCORE_IPCBUF_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/irqflags.h 
linux-2.6-git.new/arch/score/include/asm/irqflags.h
--- linux-2.6-git.ori/arch/score/include/asm/irqflags.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/irqflags.h 2009-04-07 
20:24:34.000000000 +0800
@@ -0,0 +1,111 @@
+#ifndef __SCORE_IRQFLAGS_H
+#define __SCORE_IRQFLAGS_H
+
+#ifndef __ASSEMBLY__
+
+#define raw_local_irq_save(x)                  \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "li     r9, 0xfffffffe;"        \
+               "nop;"                          \
+               "mv     %0, r8;"                \
+               "and    r8, r8, r9;"            \
+               "mtcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               : "=r" (x)                      \
+               :                               \
+               : "r8", "r9"                    \
+               );                              \
+}
+
+#define raw_local_irq_restore(x)               \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               "or     r8, r8, %0;"            \
+               "mtcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               : "r"(x)                        \
+               : "r8", "r9"                    \
+               );                              \
+}
+
+#define raw_local_irq_enable(void)             \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "ori\tr8,0x1;"                  \
+               "mtcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               :                               \
+               : "r8");                        \
+}
+
+#define raw_local_irq_disable(void)            \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "srli\tr8,r8,1;"                \
+               "slli\tr8,r8,1;"                \
+               "mtcr\tr8,cr0;"                 \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               :                               \
+               :                               \
+               : "r8");                        \
+}
+
+#define raw_local_save_flags(x)                        \
+{                                              \
+       __asm__ __volatile__(                   \
+               "mfcr   r8, cr0;"               \
+               "nop;"                          \
+               "nop;"                          \
+               "mv     %0, r8;"                \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "nop;"                          \
+               "ldi    r9, 0x1;"               \
+               "and    %0, %0, r9;"            \
+               : "=r" (x)                      \
+               :                               \
+               : "r8", "r9"                    \
+               );                              \
+}
+
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+       return !(flags & 1);
+}
+
+#endif
+
+#endif /* __SCORE_IRQFLAGS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/irq.h 
linux-2.6-git.new/arch/score/include/asm/irq.h
--- linux-2.6-git.ori/arch/score/include/asm/irq.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/irq.h      2009-04-03 
17:00:22.000000000 +0800
@@ -0,0 +1,34 @@
+#ifndef __SCORE_IRQ_H
+#define __SCORE_IRQ_H
+
+#define EXCEPTION_VECTOR_BASE_ADDR     0xa0000000
+#define VECTOR_ADDRESS_OFFSET_MODE4    0
+#define VECTOR_ADDRESS_OFFSET_MODE16   1
+
+#define DEBUG_VECTOR_SIZE              (0x4)
+#define DEBUG_VECTOR_BASE_ADDR         ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x1fc)
+
+#define GENERAL_VECTOR_SIZE            (0x10)
+#define GENERAL_VECTOR_BASE_ADDR       ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x200)
+
+#define NR_IRQS        64
+#define IRQ_VECTOR_SIZE                        (0x10)
+#define IRQ_VECTOR_BASE_ADDR           ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x210)
+#define IRQ_VECTOR_END_ADDR            ((EXCEPTION_VECTOR_BASE_ADDR) + 
0x5f0)
+
+#define irq_canonicalize(irq)  (irq)
+
+#define P_INT_PNDL             0x95F50000
+#define P_INT_PNDH             0x95F50004
+#define P_INT_PRIORITY_M       0x95F50008
+#define P_INT_PRIORITY_SG0     0x95F50010
+#define P_INT_PRIORITY_SG1     0x95F50014
+#define P_INT_PRIORITY_SG2     0x95F50018
+#define P_INT_PRIORITY_SG3     0x95F5001C
+#define P_INT_MASKL            0x95F50020
+#define P_INT_MASKH            0x95F50024
+
+#define IRQ_TIMER (7)  /* IRQ  number of SPG300 */
+
+extern void interrupt_exception_vector(void);
+#endif /* __SCORE_IRQ_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/irq_regs.h 
linux-2.6-git.new/arch/score/include/asm/irq_regs.h
--- linux-2.6-git.ori/arch/score/include/asm/irq_regs.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/irq_regs.h 2009-04-03 
17:00:34.000000000 +0800
@@ -0,0 +1,11 @@
+#ifndef __SCORE_IRQ_REGS_H
+#define __SCORE_IRQ_REGS_H
+
+#include <linux/thread_info.h>
+
+static inline struct pt_regs *get_irq_regs(void)
+{
+       return current_thread_info()->regs;
+}
+
+#endif /* __SCORE_IRQ_REGS_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/Kbuild 
linux-2.6-git.new/arch/score/include/asm/Kbuild
--- linux-2.6-git.ori/arch/score/include/asm/Kbuild     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/Kbuild     2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,3 @@
+include include/asm-generic/Kbuild.asm
+
+header-y +=
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/kdebug.h 
linux-2.6-git.new/arch/score/include/asm/kdebug.h
--- linux-2.6-git.ori/arch/score/include/asm/kdebug.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/kdebug.h   2009-04-03 
17:00:49.000000000 +0800
@@ -0,0 +1,13 @@
+#ifndef __SCORE_KDEBUG_H
+#define __SCORE_KDEBUG_H
+
+#include <linux/notifier.h>
+
+enum die_val {
+       DIE_OOPS = 1,
+       DIE_FP,
+       DIE_TRAP,
+       DIE_RI,
+};
+
+#endif /* __SCORE_KDEBUG_H */
