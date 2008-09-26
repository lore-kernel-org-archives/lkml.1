Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYIZXSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYIZXSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 19:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYIZXSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 19:18:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39762 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYIZXS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 19:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tMfOiJiPmfL86A5ijRur4CLaPmnvCi3GNyUtKPUSlAJFoJBhDqtFSJ/AZ11LXJUJNs
         VZYVbJiD2bqreZeY3Zko0w3UfdRRVyg/pPSboiMj9e1Q12FDdajxuKUkzPkS8Ny4Bw0T
         6ebdTmTPlNPIPggpS7KnOXn54l6slmZ4/hQ/Q=
Date: Sat, 27 Sep 2008 03:20:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Tainted cleanup
Message-ID: <20080926232046.GA16089@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* extrace tainted code in separate place: kernel/tainted.c and
  include/linux/tainted.h .
  
  The former won't mess with panic code, the latter won't add useless
  stuff to kernel.h which is very often included header.

* export tainted.h to userspace

  taint values are userspace-visible via kernel.tainted sysctl,
  a program in theory can monitor its value for oopses, warnings et al
  which is more reliable than printk ring-buffer.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/traps.c                |    1 
 arch/arm/kernel/process.c                |    1 
 arch/arm/kernel/traps.c                  |    1 
 arch/avr32/kernel/process.c              |    1 
 arch/avr32/kernel/traps.c                |    1 
 arch/blackfin/kernel/traps.c             |    1 
 arch/ia64/kernel/process.c               |    1 
 arch/ia64/kernel/traps.c                 |    1 
 arch/m68k/kernel/process.c               |    1 
 arch/m68k/kernel/traps.c                 |    1 
 arch/m68knommu/kernel/process.c          |    1 
 arch/m68knommu/kernel/traps.c            |    1 
 arch/mips/kernel/traps.c                 |    1 
 arch/mips/sgi-ip27/ip27-nmi.c            |    1 
 arch/parisc/kernel/traps.c               |    1 
 arch/powerpc/kernel/process.c            |    1 
 arch/powerpc/kernel/traps.c              |    1 
 arch/s390/kernel/traps.c                 |    1 
 arch/sh/kernel/process_32.c              |    1 
 arch/sh/kernel/traps_32.c                |    1 
 arch/sparc/kernel/process.c              |    1 
 arch/sparc/kernel/traps.c                |    1 
 arch/sparc64/kernel/process.c            |    1 
 arch/sparc64/kernel/setup.c              |    1 
 arch/sparc64/kernel/traps.c              |    1 
 arch/um/sys-i386/sysrq.c                 |    1 
 arch/um/sys-x86_64/sysrq.c               |    1 
 arch/x86/kernel/cpu/mcheck/k7.c          |    1 
 arch/x86/kernel/cpu/mcheck/mce_64.c      |    1 
 arch/x86/kernel/cpu/mcheck/non-fatal.c   |    1 
 arch/x86/kernel/cpu/mcheck/p4.c          |    1 
 arch/x86/kernel/cpu/mcheck/p5.c          |    1 
 arch/x86/kernel/cpu/mcheck/p6.c          |    1 
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    1 
 arch/x86/kernel/cpu/mcheck/winchip.c     |    1 
 arch/x86/kernel/process_32.c             |    1 
 arch/x86/kernel/process_64.c             |    1 
 arch/x86/kernel/smpboot.c                |    1 
 arch/x86/kernel/traps_32.c               |    1 
 arch/x86/kernel/traps_64.c               |    1 
 arch/xtensa/kernel/traps.c               |    1 
 drivers/acpi/osl.c                       |    1 
 include/linux/Kbuild                     |    1 
 include/linux/kernel.h                   |   14 --------
 include/linux/tainted.h                  |   21 +++++++++++++
 kernel/Makefile                          |    1 
 kernel/module.c                          |    1 
 kernel/panic.c                           |   46 -----------------------------
 kernel/softlockup.c                      |    1 
 kernel/sysctl.c                          |    1 
 kernel/tainted.c                         |   49 +++++++++++++++++++++++++++++++
 lib/bug.c                                |    1 
 mm/page_alloc.c                          |    1 
 53 files changed, 120 insertions(+), 59 deletions(-)

--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -11,6 +11,7 @@
 #include <linux/jiffies.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/tainted.h>
 #include <linux/tty.h>
 #include <linux/delay.h>
 #include <linux/smp_lock.h>
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -26,6 +26,7 @@
 #include <linux/cpu.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
+#include <linux/tainted.h>
 #include <linux/tick.h>
 #include <linux/utsname.h>
 
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/signal.h>
 #include <linux/spinlock.h>
+#include <linux/tainted.h>
 #include <linux/personality.h>
 #include <linux/kallsyms.h>
 #include <linux/delay.h>
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/ptrace.h>
 #include <linux/reboot.h>
+#include <linux/tainted.h>
 #include <linux/tick.h>
 #include <linux/uaccess.h>
 #include <linux/unistd.h>
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
+#include <linux/tainted.h>
 #include <linux/uaccess.h>
 
 #include <asm/addrspace.h>
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/fs.h>
+#include <linux/tainted.h>
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
 #include <asm/blackfin.h>
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
+#include <linux/tainted.h>
 #include <linux/thread_info.h>
 #include <linux/unistd.h>
 #include <linux/efi.h>
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/tainted.h>
 #include <linux/tty.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 #include <linux/module.h>       /* for EXPORT_SYMBOL */
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -19,6 +19,7 @@
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/stddef.h>
+#include <linux/tainted.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/user.h>
 #include <linux/string.h>
+#include <linux/tainted.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <linux/ptrace.h>
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -24,6 +24,7 @@
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
+#include <linux/tainted.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
--- a/arch/m68knommu/kernel/traps.c
+++ b/arch/m68knommu/kernel/traps.c
@@ -25,6 +25,7 @@
 #include <linux/a.out.h>
 #include <linux/user.h>
 #include <linux/string.h>
+#include <linux/tainted.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <linux/ptrace.h>
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
+#include <linux/tainted.h>
 #include <linux/kallsyms.h>
 #include <linux/bootmem.h>
 #include <linux/interrupt.h>
--- a/arch/mips/sgi-ip27/ip27-nmi.c
+++ b/arch/mips/sgi-ip27/ip27-nmi.c
@@ -3,6 +3,7 @@
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 #include <asm/atomic.h>
 #include <asm/sn/types.h>
 #include <asm/sn/addrs.h>
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/spinlock.h>
+#include <linux/tainted.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/console.h>
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
+#include <linux/tainted.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -22,6 +22,7 @@
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
+#include <linux/tainted.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
+#include <linux/tainted.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -16,6 +16,7 @@
 #include <linux/kallsyms.h>
 #include <linux/kexec.h>
 #include <linux/kdebug.h>
+#include <linux/tainted.h>
 #include <linux/tick.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -15,6 +15,7 @@
 #include <linux/ptrace.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/tainted.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/io.h>
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
--- a/arch/sparc/kernel/traps.c
+++ b/arch/sparc/kernel/traps.c
@@ -14,6 +14,7 @@
 #include <linux/signal.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/tainted.h>
 #include <linux/kdebug.h>
 
 #include <asm/delay.h>
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -21,6 +21,7 @@
 #include <linux/stddef.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
+#include <linux/tainted.h>
 #include <linux/user.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
--- a/arch/sparc64/kernel/setup.c
+++ b/arch/sparc64/kernel/setup.c
@@ -13,6 +13,7 @@
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
+#include <linux/tainted.h>
 #include <asm/smp.h>
 #include <linux/user.h>
 #include <linux/screen_info.h>
--- a/arch/sparc64/kernel/traps.c
+++ b/arch/sparc64/kernel/traps.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/kdebug.h>
--- a/arch/um/sys-i386/sysrq.c
+++ b/arch/um/sys-i386/sysrq.c
@@ -6,6 +6,7 @@
 #include "linux/kernel.h"
 #include "linux/smp.h"
 #include "linux/sched.h"
+#include "linux/tainted.h"
 #include "linux/kallsyms.h"
 #include "asm/ptrace.h"
 #include "sysrq.h"
--- a/arch/um/sys-x86_64/sysrq.c
+++ b/arch/um/sys-x86_64/sysrq.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/tainted.h>
 #include <linux/utsname.h>
 #include <asm/current.h>
 #include <asm/ptrace.h>
--- a/arch/x86/kernel/cpu/mcheck/k7.c
+++ b/arch/x86/kernel/cpu/mcheck/k7.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
+#include <linux/tainted.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
 #include <linux/sysdev.h>
--- a/arch/x86/kernel/cpu/mcheck/non-fatal.c
+++ b/arch/x86/kernel/cpu/mcheck/non-fatal.c
@@ -14,6 +14,7 @@
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 #include <linux/module.h>
 
 #include <asm/processor.h>
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/smp.h>
+#include <linux/tainted.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -20,6 +20,7 @@
 #include <asm/cpu.h>
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
+#include <linux/tainted.h>
 #include <asm/therm_throt.h>
 
 /* How long to wait between reporting thermal events */
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/tainted.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/stddef.h>
 #include <linux/slab.h>
+#include <linux/tainted.h>
 #include <linux/vmalloc.h>
 #include <linux/user.h>
 #include <linux/interrupt.h>
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -25,6 +25,7 @@
 #include <linux/elfcore.h>
 #include <linux/smp.h>
 #include <linux/slab.h>
+#include <linux/tainted.h>
 #include <linux/user.h>
 #include <linux/interrupt.h>
 #include <linux/utsname.h>
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -43,6 +43,7 @@
 #include <linux/smp.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/tainted.h>
 #include <linux/percpu.h>
 #include <linux/bootmem.h>
 #include <linux/err.h>
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/string.h>
+#include <linux/tainted.h>
 #include <linux/unwind.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/kallsyms.h>
 #include <linux/spinlock.h>
+#include <linux/tainted.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/utsname.h>
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/stringify.h>
+#include <linux/tainted.h>
 #include <linux/kallsyms.h>
 #include <linux/delay.h>
 
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -44,6 +44,7 @@
 #include <linux/list.h>
 #include <linux/jiffies.h>
 #include <linux/semaphore.h>
+#include <linux/tainted.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -338,6 +338,7 @@ unifdef-y += stddef.h
 unifdef-y += string.h
 unifdef-y += synclink.h
 unifdef-y += sysctl.h
+unifdef-y += tainted.h
 unifdef-y += tcp.h
 unifdef-y += time.h
 unifdef-y += timex.h
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -235,9 +235,6 @@ extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
-extern int tainted;
-extern const char *print_tainted(void);
-extern void add_taint(unsigned);
 extern int root_mountflags;
 
 /* Values used for system_state */
@@ -250,17 +247,6 @@ extern enum system_states {
 	SYSTEM_SUSPEND_DISK,
 } system_state;
 
-#define TAINT_PROPRIETARY_MODULE	(1<<0)
-#define TAINT_FORCED_MODULE		(1<<1)
-#define TAINT_UNSAFE_SMP		(1<<2)
-#define TAINT_FORCED_RMMOD		(1<<3)
-#define TAINT_MACHINE_CHECK		(1<<4)
-#define TAINT_BAD_PAGE			(1<<5)
-#define TAINT_USER			(1<<6)
-#define TAINT_DIE			(1<<7)
-#define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
-#define TAINT_WARN			(1<<9)
-
 extern void dump_stack(void) __cold;
 
 enum {
new file mode 100644
--- /dev/null
+++ b/include/linux/tainted.h
@@ -0,0 +1,21 @@
+#ifndef __TAINTED_H
+#define __TAINTED_H
+
+#define TAINT_PROPRIETARY_MODULE	(1<<0)
+#define TAINT_FORCED_MODULE		(1<<1)
+#define TAINT_UNSAFE_SMP		(1<<2)
+#define TAINT_FORCED_RMMOD		(1<<3)
+#define TAINT_MACHINE_CHECK		(1<<4)
+#define TAINT_BAD_PAGE			(1<<5)
+#define TAINT_USER			(1<<6)
+#define TAINT_DIE			(1<<7)
+#define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
+#define TAINT_WARN			(1<<9)
+
+#ifdef __KERNEL__
+extern int tainted;
+const char *print_tainted(void);
+void add_taint(unsigned);
+#endif
+
+#endif
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,6 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
+obj-y	+= tainted.o
 
 CFLAGS_REMOVE_sched.o = -mno-spe
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/kallsyms.h>
 #include <linux/sysfs.h>
+#include <linux/tainted.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/init.h>
 #include <linux/sysrq.h>
+#include <linux/tainted.h>
 #include <linux/interrupt.h>
 #include <linux/nmi.h>
 #include <linux/kexec.h>
@@ -23,7 +24,6 @@
 #include <linux/kallsyms.h>
 
 int panic_on_oops;
-int tainted;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -143,50 +143,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 
 EXPORT_SYMBOL(panic);
 
-/**
- *	print_tainted - return a string to represent the kernel taint state.
- *
- *  'P' - Proprietary module has been loaded.
- *  'F' - Module has been forcibly loaded.
- *  'S' - SMP with CPUs not designed for SMP.
- *  'R' - User forced a module unload.
- *  'M' - System experienced a machine check exception.
- *  'B' - System has hit bad_page.
- *  'U' - Userspace-defined naughtiness.
- *  'A' - ACPI table overridden.
- *  'W' - Taint on warning.
- *
- *	The string is overwritten by the next call to print_taint().
- */
-
-const char *print_tainted(void)
-{
-	static char buf[20];
-	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
-			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
-			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
-			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
-			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
-			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
-			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
-			tainted & TAINT_USER ? 'U' : ' ',
-			tainted & TAINT_DIE ? 'D' : ' ',
-			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
-			tainted & TAINT_WARN ? 'W' : ' ');
-	}
-	else
-		snprintf(buf, sizeof(buf), "Not tainted");
-	return(buf);
-}
-
-void add_taint(unsigned flag)
-{
-	debug_locks = 0; /* can't trust the integrity of the kernel anymore */
-	tainted |= flag;
-}
-EXPORT_SYMBOL(add_taint);
-
 static int __init pause_on_oops_setup(char *str)
 {
 	pause_on_oops = simple_strtoul(str, NULL, 0);
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -16,6 +16,7 @@
 #include <linux/lockdep.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/tainted.h>
 
 #include <asm/irq_regs.h>
 
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
+#include <linux/tainted.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
new file mode 100644
--- /dev/null
+++ b/kernel/tainted.c
@@ -0,0 +1,49 @@
+#include <linux/debug_locks.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/tainted.h>
+
+int tainted;
+
+/**
+ *	print_tainted - return a string to represent the kernel taint state.
+ *
+ *  'P' - Proprietary module has been loaded.
+ *  'F' - Module has been forcibly loaded.
+ *  'S' - SMP with CPUs not designed for SMP.
+ *  'R' - User forced a module unload.
+ *  'M' - System experienced a machine check exception.
+ *  'B' - System has hit bad_page.
+ *  'U' - Userspace-defined naughtiness.
+ *  'A' - ACPI table overridden.
+ *  'W' - Taint on warning.
+ *
+ *	The string is overwritten by the next call to print_taint().
+ */
+const char *print_tainted(void)
+{
+	static char buf[20];
+
+	if (tainted) {
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
+			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
+			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
+			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
+			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',
+			tainted & TAINT_MACHINE_CHECK ? 'M' : ' ',
+			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
+			tainted & TAINT_USER ? 'U' : ' ',
+			tainted & TAINT_DIE ? 'D' : ' ',
+			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
+			tainted & TAINT_WARN ? 'W' : ' ');
+	} else
+		snprintf(buf, sizeof(buf), "Not tainted");
+	return buf;
+}
+
+void add_taint(unsigned flag)
+{
+	debug_locks = 0; /* can't trust the integrity of the kernel anymore */
+	tainted |= flag;
+}
+EXPORT_SYMBOL(add_taint);
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -40,6 +40,7 @@
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/sched.h>
+#include <linux/tainted.h>
 
 extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
+#include <linux/tainted.h>
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
 #include <linux/slab.h>
