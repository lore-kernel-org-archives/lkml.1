Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbZDONYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbZDONYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZDONYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:24:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35350 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428AbZDONYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:24:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090415120307.GB17775@elte.hu>
References: <20090415120307.GB17775@elte.hu> <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com> <14172.1239795632@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Wed, 15 Apr 2009 14:20:59 +0100
Message-ID: <1488.1239801659@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Ingo Molnar <mingo@elte.hu> wrote:

> > The problem is mainly one of #include recursion.  There's way too 
> > much of it.
> 
> that should be mapped and eliminated then.

Indeed.  My suggestion was intended for after elimination to discourage it
from returning.

> There is absolutely _nothing_ wrong about defining structures in a 
> hierarchical way! For example task_struct does have to combine a lot 
> of derived types. It can use types directly and indirectly as well. 
> Hierarchical data structures are _good_.

Indeed.  I didn't say you shouldn't include one header file from another, just
that you shouldn't have a cycle of header files that include one another.

> The solution to this is the creation of a separate data versus 
> method include file hiearchy: for example mm_types.h and 
> spinlock_types.h.

That's what I've been doing - but it's not as simple as just splitting each
header file in to two, however.

> There's three too 'thick' headers: linux/percpu.h, linux/prefetch.h 
> and asm/processor.h.

Yes, I noticed.

linux/percpu.h needs to be split three ways for instance: definitions, access
methods, and alocators.

linux/prefetch.h isn't too bad: what it needs is the prefetch stuff splitting
out of asm/processor.h into asm/prefetch.h.

> Please create include/linux/percpu_types.h for basic data types and 
> simple, self-sufficient primitives. Also have an 
> include/linux/percpu_api.h or include/linux/percpu.h include file 
> for convenience/speedup inlines. The latter will only be included in 
> .c files, where 'combination' of type spaces is not a problem.

Not so.  The problem is that various header files make use of per-cpu variable
accessors (asm/current.h and asm/thread_info.h to name a couple) to build
inline asm.

Anyway, here are a pair of patches on top of the one I've already sent to
Linus.  The second breaks a number of header files into pieces and rearranges
the percpu headers to put the DECLARE and DEFINE macros together.

The first patch could potentially be applied immediately.  It adds #inclusions
and forward refs that are required to iron out compile errors from the second
patch.

Note that these only work for the configuration I routinely use on my x86_64
test machine.  It will break all other arches and many other i386 and x86_64
configurations.

David


--=-=-=
Content-Type: message/rfc822
Content-Disposition: attachment; filename=08-percpu-add-headers.diff

From: David Howells <dhowells@redhat.com>
Subject: [PATCH] PERCPU: Add #inclusions and forward type declarations to support rearrangement

Add #inclusions and forward type declarations to a number of files to support
future rearrangement of the header files.

Signed-off-by: Daivd Howells <dhowells@redhat.com>
---

 arch/x86/ia32/ia32entry.S           |    2 ++
 arch/x86/include/asm/uaccess.h      |    1 +
 arch/x86/include/asm/vmware.h       |    2 ++
 arch/x86/kernel/alternative.c       |    1 +
 arch/x86/kernel/apic/nmi.c          |    1 +
 arch/x86/kernel/cpu/mcheck/mce_64.c |    1 +
 arch/x86/kernel/cpu/vmware.c        |    1 +
 arch/x86/kernel/head64.c            |    1 +
 arch/x86/kernel/hpet.c              |    1 +
 arch/x86/kernel/i387.c              |    1 +
 arch/x86/kernel/tsc.c               |    1 +
 arch/x86/lib/copy_user_64.S         |    1 +
 arch/x86/lib/putuser.S              |    1 +
 arch/x86/mm/pat.c                   |    1 +
 arch/x86/vdso/vma.c                 |    1 +
 drivers/base/bus.c                  |    1 +
 drivers/base/devres.c               |    1 +
 drivers/base/driver.c               |    1 +
 drivers/base/firmware_class.c       |    1 +
 drivers/base/iommu.c                |    1 +
 drivers/base/module.c               |    1 +
 drivers/char/pty.c                  |    1 +
 drivers/char/tty_audit.c            |    1 +
 drivers/cpufreq/cpufreq_stats.c     |    1 +
 drivers/cpuidle/sysfs.c             |    1 +
 drivers/firmware/dmi-id.c           |    1 +
 drivers/firmware/memmap.c           |    1 +
 drivers/i2c/i2c-boardinfo.c         |    1 +
 drivers/input/ff-core.c             |    1 +
 drivers/input/ff-memless.c          |    1 +
 drivers/input/serio/i8042.c         |    1 +
 drivers/power/power_supply_sysfs.c  |    1 +
 drivers/rtc/class.c                 |    1 +
 drivers/serial/8250.c               |    1 +
 drivers/thermal/thermal_sys.c       |    1 +
 drivers/usb/core/driver.c           |    1 +
 drivers/usb/core/endpoint.c         |    1 +
 drivers/usb/core/file.c             |    1 +
 drivers/video/fb_ddc.c              |    1 +
 drivers/video/fbcvt.c               |    1 +
 drivers/video/fbsysfs.c             |    1 +
 drivers/video/modedb.c              |    1 +
 drivers/video/output.c              |    1 +
 fs/eventfd.c                        |    1 +
 fs/ext3/balloc.c                    |    1 +
 fs/fscache/operation.c              |    1 +
 fs/fscache/page.c                   |    1 +
 fs/libfs.c                          |    4 ++--
 fs/open.c                           |    1 +
 fs/ramfs/inode.c                    |    1 +
 fs/signalfd.c                       |    1 +
 fs/sync.c                           |    1 +
 fs/sysfs/inode.c                    |    1 +
 fs/sysfs/mount.c                    |    1 +
 fs/timerfd.c                        |    1 +
 include/linux/fsnotify.h            |    1 +
 include/linux/jbd.h                 |    1 +
 include/linux/security.h            |    1 +
 kernel/async.c                      |    1 +
 kernel/power/snapshot.c             |    1 +
 kernel/power/swsusp.c               |    1 +
 kernel/sched_cpupri.c               |    1 +
 kernel/time/timecompare.c           |    1 +
 kernel/timer.c                      |    1 +
 lib/kasprintf.c                     |    1 +
 lib/kref.c                          |    1 +
 lib/scatterlist.c                   |    1 +
 mm/sparse-vmemmap.c                 |    1 +
 mm/sparse.c                         |    1 +
 net/sunrpc/xdr.c                    |    1 +
 security/device_cgroup.c            |    1 +
 71 files changed, 74 insertions(+), 2 deletions(-)


diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a505202..a925f1a 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -13,7 +13,9 @@
 #include <asm/thread_info.h>	
 #include <asm/segment.h>
 #include <asm/irqflags.h>
+#include <asm/page_types.h>
 #include <linux/linkage.h>
+#include <linux/percpu.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index b685ece..dc52199 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -8,6 +8,7 @@
 #include <linux/thread_info.h>
 #include <linux/prefetch.h>
 #include <linux/string.h>
+#include <linux/cache.h>
 #include <asm/asm.h>
 #include <asm/page.h>
 
diff --git a/arch/x86/include/asm/vmware.h b/arch/x86/include/asm/vmware.h
index c11b7e1..86784ce 100644
--- a/arch/x86/include/asm/vmware.h
+++ b/arch/x86/include/asm/vmware.h
@@ -20,6 +20,8 @@
 #ifndef ASM_X86__VMWARE_H
 #define ASM_X86__VMWARE_H
 
+struct cpuinfo_x86;
+
 extern unsigned long vmware_get_tsc_khz(void);
 extern int vmware_platform(void);
 extern void vmware_set_feature_bits(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f576587..e970115 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
+#include <linux/slab.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index d6bd624..623f2d7 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -26,6 +26,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
 #include <linux/smp.h>
+#include <linux/slab.h>
 
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 863f895..10069cf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -29,6 +29,7 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/ratelimit.h>
+#include <linux/slab.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 284c399..d5ef0f2 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -24,6 +24,7 @@
 #include <linux/dmi.h>
 #include <asm/div64.h>
 #include <asm/vmware.h>
+#include <asm/processor.h>
 
 #define CPUID_VMWARE_INFO_LEAF	0x40000000
 #define VMWARE_HYPERVISOR_MAGIC	0x564D5868
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 70eaa85..f930b8e 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -25,6 +25,7 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
+#include <asm/fixmap.h>
 
 static void __init zap_identity_mappings(void)
 {
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 648b3a2..4c91d21 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -9,6 +9,7 @@
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include <asm/fixmap.h>
 #include <asm/i8253.h>
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index f2f8540..9002480 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/regset.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <asm/sigcontext.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7a567eb..57a213e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -16,6 +16,7 @@
 #include <asm/time.h>
 #include <asm/delay.h>
 #include <asm/hypervisor.h>
+#include <asm/apic.h>
 
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index f118c11..8079b5b 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -15,6 +15,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/cpufeature.h>
+#include <asm/page_types.h>
 
 	.macro ALTERNATIVE_JUMP feature,orig,alt
 0:
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 36b0d15..794f14a 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -13,6 +13,7 @@
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
 #include <asm/thread_info.h>
+#include <asm/page_types.h>
 #include <asm/errno.h>
 #include <asm/asm.h>
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index c009a24..6774611 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -15,6 +15,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7133cdf..2e23126 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index dc030f1..277ea9a 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include "base.h"
 #include "power/power.h"
 
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e8beb8e..5c30ea3 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -9,6 +9,7 @@
 
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "base.h"
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index c51f11b..8b7a352 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include "base.h"
 
 static struct device *next_device(struct klist_iter *i)
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d3a59c6..0f27d76 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
+#include <linux/slab.h>
 
 #include <linux/firmware.h>
 #include "base.h"
diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 9f0e672..09e7b37 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
+#include <linux/slab.h>
 
 static struct iommu_ops *iommu_ops;
 
diff --git a/drivers/base/module.c b/drivers/base/module.c
index 103be9c..f1fcd61 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include "base.h"
 
 static char *make_driver_name(struct device_driver *drv)
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 31038a0..e8726fb 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -27,6 +27,7 @@
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/devpts_fs.h>
+#include <linux/slab.h>
 
 #include <asm/system.h>
 
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 55ba6f1..572490c 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -11,6 +11,7 @@
 
 #include <linux/audit.h>
 #include <linux/tty.h>
+#include <linux/slab.h>
 
 struct tty_audit_buf {
 	atomic_t count;
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5a62d67..51e478a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -19,6 +19,7 @@
 #include <linux/kobject.h>
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
+#include <linux/slab.h>
 #include <asm/cputime.h>
 
 static spinlock_t cpufreq_stats_lock;
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 97b0038..d31990d 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/cpuidle.h>
 #include <linux/sysfs.h>
 #include <linux/cpu.h>
+#include <linux/slab.h>
 
 #include "cpuidle.h"
 
diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index 5a76d05..157c75c 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 
 struct dmi_device_attribute{
 	struct device_attribute dev_attr;
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 05aa2d4..bdac4cf 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/bootmem.h>
+#include <linux/slab.h>
 
 /*
  * Data types ------------------------------------------------------------------
diff --git a/drivers/i2c/i2c-boardinfo.c b/drivers/i2c/i2c-boardinfo.c
index ffb35f0..663e7ac 100644
--- a/drivers/i2c/i2c-boardinfo.c
+++ b/drivers/i2c/i2c-boardinfo.c
@@ -18,6 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "i2c-core.h"
 
diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 72c63e5..cf0d9c9 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 /*
  * Check that the effect_id is a valid effect and whether the user
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index bc4e40f..1867f73 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -30,6 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
+#include <linux/slab.h>
 
 #include "fixp-arith.h"
 
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 170f71e..d2afa04 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -20,6 +20,7 @@
 #include <linux/rcupdate.h>
 #include <linux/platform_device.h>
 #include <linux/i8042.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index da73591..d71d521 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -13,6 +13,7 @@
 
 #include <linux/ctype.h>
 #include <linux/power_supply.h>
+#include <linux/slab.h>
 
 #include "power_supply.h"
 
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index be5a6b7..b5b338f 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -15,6 +15,7 @@
 #include <linux/rtc.h>
 #include <linux/kdev_t.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 
 #include "rtc-core.h"
 
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 23b981e..b35d5cb 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -38,6 +38,7 @@
 #include <linux/serial_8250.h>
 #include <linux/nmi.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index d0b093b..b82f33e 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -31,6 +31,7 @@
 #include <linux/thermal.h>
 #include <linux/spinlock.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 
 MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index d0a21a5..5c6cefb 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -26,6 +26,7 @@
 #include <linux/usb.h>
 #include <linux/usb/quirks.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include "hcd.h"
 #include "usb.h"
 
diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index 40dee2a..8746c0f 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/idr.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 #include "usb.h"
 
 #define MAX_ENDPOINT_MINORS (64*128*32)
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 997e659..90e007d 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -20,6 +20,7 @@
 #include <linux/rwsem.h>
 #include <linux/smp_lock.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 
 #include "usb.h"
 
diff --git a/drivers/video/fb_ddc.c b/drivers/video/fb_ddc.c
index 0cf96eb..4a874c8 100644
--- a/drivers/video/fb_ddc.c
+++ b/drivers/video/fb_ddc.c
@@ -12,6 +12,7 @@
 #include <linux/device.h>
 #include <linux/fb.h>
 #include <linux/i2c-algo-bit.h>
+#include <linux/slab.h>
 
 #include "edid.h"
 
diff --git a/drivers/video/fbcvt.c b/drivers/video/fbcvt.c
index 0847c5e..7293eac 100644
--- a/drivers/video/fbcvt.c
+++ b/drivers/video/fbcvt.c
@@ -13,6 +13,7 @@
  *
  */
 #include <linux/fb.h>
+#include <linux/slab.h>
 
 #define FB_CVT_CELLSIZE               8
 #define FB_CVT_GTF_C                 40
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index d4a2c11..ea5f0a5 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -19,6 +19,7 @@
 #include <linux/fb.h>
 #include <linux/console.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #define FB_SYSFS_FLAG_ATTR 1
 
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index 1618624..9afc652 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/fb.h>
+#include <linux/slab.h>
 
 #undef DEBUG
 
diff --git a/drivers/video/output.c b/drivers/video/output.c
index 5e6439a..b92e0ad 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -25,6 +25,7 @@
 #include <linux/video_output.h>
 #include <linux/err.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 
 
 MODULE_DESCRIPTION("Display Output Switcher Lowlevel Control Abstraction");
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2a701d5..77d3345 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -16,6 +16,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/eventfd.h>
 #include <linux/syscalls.h>
+#include <linux/slab.h>
 
 struct eventfd_ctx {
 	wait_queue_head_t wqh;
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 225202d..46bf683 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -19,6 +19,7 @@
 #include <linux/ext3_jbd.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index e7f8d53..6939263 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -13,6 +13,7 @@
 
 #define FSCACHE_DEBUG_LEVEL OPERATION
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "internal.h"
 
 atomic_t fscache_op_debug_id;
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 2568e0e..9e965c2 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -14,6 +14,7 @@
 #include <linux/fscache-cache.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <linux/slab.h>
 #include "internal.h"
 
 /*
diff --git a/fs/libfs.c b/fs/libfs.c
index cd22319..76ca633 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -9,8 +9,8 @@
 #include <linux/vfs.h>
 #include <linux/mutex.h>
 #include <linux/exportfs.h>
-
-#include <asm/uaccess.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
 
 int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		   struct kstat *stat)
diff --git a/fs/open.c b/fs/open.c
index 377eb25..c1966d4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,7 @@
 #include <linux/audit.h>
 #include <linux/falloc.h>
 #include <linux/fs_struct.h>
+#include <linux/slab.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index 3a6b193..3a58e02 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -34,6 +34,7 @@
 #include <linux/ramfs.h>
 #include <linux/sched.h>
 #include <linux/parser.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index b07565c..3f8800f 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -28,6 +28,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
+#include <linux/slab.h>
 
 struct signalfd_ctx {
 	sigset_t sigmask;
diff --git a/fs/sync.c b/fs/sync.c
index 7abc65f..36ef011 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 555f0ff..1fb257d 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -18,6 +18,7 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4974995..57a7717 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/magic.h>
+#include <linux/slab.h>
 
 #include "sysfs.h"
 
diff --git a/fs/timerfd.c b/fs/timerfd.c
index b042bd7..7805b03 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -21,6 +21,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
 #include <linux/syscalls.h>
+#include <linux/slab.h>
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 00fbd5b..b9a9c2e 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -14,6 +14,7 @@
 #include <linux/dnotify.h>
 #include <linux/inotify.h>
 #include <linux/audit.h>
+#include <linux/slab.h>
 
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 53ae439..80838d5 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/lockdep.h>
+#include <linux/slab.h>
 
 #define journal_oom_retry 1
 
diff --git a/include/linux/security.h b/include/linux/security.h
index d5fd616..108d241 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -33,6 +33,7 @@
 #include <linux/key.h>
 #include <linux/xfrm.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <net/flow.h>
 
 /* Maximum number of letters for an LSM name string */
diff --git a/kernel/async.c b/kernel/async.c
index 968ef94..6a8c141 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -56,6 +56,7 @@ asynchronous and synchronous parts of the kernel.
 #include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 33e2e4a..4f8d8f8 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -26,6 +26,7 @@
 #include <linux/console.h>
 #include <linux/highmem.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff --git a/kernel/power/swsusp.c b/kernel/power/swsusp.c
index 78c3504..6dcbf16 100644
--- a/kernel/power/swsusp.c
+++ b/kernel/power/swsusp.c
@@ -52,6 +52,7 @@
 #include <linux/time.h>
 #include <linux/rbtree.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include "power.h"
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index cdd3c89..4551352 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -27,6 +27,7 @@
  *  of the License.
  */
 
+#include <linux/gfp.h>
 #include "sched_cpupri.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
index 71e7f1a..018e126 100644
--- a/kernel/time/timecompare.c
+++ b/kernel/time/timecompare.c
@@ -20,6 +20,7 @@
 #include <linux/timecompare.h>
 #include <linux/module.h>
 #include <linux/math64.h>
+#include <linux/slab.h>
 
 /*
  * fixed point arithmetic scale factor for skew
diff --git a/kernel/timer.c b/kernel/timer.c
index cffffad..c34955a 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff --git a/lib/kasprintf.c b/lib/kasprintf.c
index c5ff1fd..638c809 100644
--- a/lib/kasprintf.c
+++ b/lib/kasprintf.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 /* Simplified asprintf. */
 char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
diff --git a/lib/kref.c b/lib/kref.c
index 9ecd6e8..6d19f69 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -13,6 +13,7 @@
 
 #include <linux/kref.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 /**
  * kref_set - initialize object and set refcount to requested number.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b7b449d..368b3f7 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
+#include <linux/slab.h>
 
 /**
  * sg_next - return the next scatterlist entry in a list
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index a13ea64..3bc8ccc 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -25,6 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/mm/sparse.c b/mm/sparse.c
index da432d9..b1574e7 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 #include "internal.h"
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 406e26d..faf7085 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/msg_prot.h>
 
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 5fda7df..417ae2f 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -12,6 +12,7 @@
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #define ACC_MKNOD 1
 #define ACC_READ  2

--=-=-=
Content-Type: message/rfc822
Content-Disposition: attachment; filename=09-move-declare-cpu.diff

From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Move DECLARE_/DEFINE_PER_CPU*() to before the #inclusion of <asm/percpu.h>

Move DECLARE_/DEFINE_PER_CPU*() to before the #inclusion of <asm/percpu.h> in
linux/percpu.h.  This puts the DECLARE and DEFINE macros together.

The declarations have to be before the #inclusion of <asm/percpu.h> because
some asm/percpu.h's declare such variables - something that is probably done in
the wrong place.

To make this work, this patch also has to rearrange and split a number of
header files to eliminate circular references.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/include/asm/percpu.h         |    6 -
 arch/x86/include/asm/alternative.h      |    4 +
 arch/x86/include/asm/apic-defs.h        |   14 +++
 arch/x86/include/asm/apic.h             |    5 -
 arch/x86/include/asm/current.h          |    3 -
 arch/x86/include/asm/irq_regs.h         |    2 
 arch/x86/include/asm/mm_types.h         |   12 ++
 arch/x86/include/asm/percpu-defs.h      |   67 +++++++++++++
 arch/x86/include/asm/percpu.h           |   66 ------------
 arch/x86/include/asm/prefetch.h         |   49 +++++++++
 arch/x86/include/asm/processor.h        |   49 ---------
 arch/x86/include/asm/smp.h              |   12 +-
 arch/x86/include/asm/stackprotector.h   |    2 
 arch/x86/include/asm/thread_info-defs.h |  165 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/thread_info.h      |  166 ++-----------------------------
 arch/x86/kernel/acpi/cstate.c           |    1 
 drivers/net/loopback.c                  |    1 
 fs/nfs/iostat.h                         |    1 
 include/asm-generic/percpu-defs.h       |   33 ++++++
 include/asm-generic/percpu.h            |   46 ---------
 include/linux/completion-defs.h         |   30 ++++++
 include/linux/completion.h              |   18 ---
 include/linux/fs.h                      |    2 
 include/linux/genhd.h                   |    1 
 include/linux/gfp.h                     |   10 +-
 include/linux/mmzone.h                  |    6 +
 include/linux/percpu-alloc.h            |   42 ++++++++
 include/linux/percpu-defs.h             |   79 +++++++++++++++
 include/linux/percpu.h                  |   52 +---------
 include/linux/preempt.h                 |    2 
 include/linux/prefetch.h                |    3 -
 include/linux/rcupdate.h                |    2 
 include/linux/seqlock-defs.h            |   37 +++++++
 include/linux/seqlock.h                 |   20 ++--
 include/linux/spinlock.h                |    1 
 include/linux/thread_info-defs.h        |   54 ++++++++++
 include/linux/thread_info.h             |   44 --------
 include/linux/wait-defs.h               |   25 +++++
 include/linux/wait.h                    |   21 ----
 kernel/module.c                         |    1 
 kernel/srcu.c                           |    2 
 kernel/stop_machine.c                   |    1 
 kernel/workqueue.c                      |    1 
 lib/percpu_counter.c                    |    1 
 net/core/neighbour.c                    |    1 
 net/ipv4/af_inet.c                      |    1 
 46 files changed, 684 insertions(+), 477 deletions(-)
 create mode 100644 arch/x86/include/asm/apic-defs.h
 create mode 100644 arch/x86/include/asm/mm_types.h
 create mode 100644 arch/x86/include/asm/percpu-defs.h
 create mode 100644 arch/x86/include/asm/prefetch.h
 create mode 100644 arch/x86/include/asm/thread_info-defs.h
 create mode 100644 include/asm-generic/percpu-defs.h
 create mode 100644 include/linux/completion-defs.h
 create mode 100644 include/linux/percpu-alloc.h
 create mode 100644 include/linux/percpu-defs.h
 create mode 100644 include/linux/seqlock-defs.h
 create mode 100644 include/linux/thread_info-defs.h
 create mode 100644 include/linux/wait-defs.h


diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index e9e0bb5..896c578 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -3,12 +3,6 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
-/*
- * Determine the real variable name from the name visible in the
- * kernel sources.
- */
-#define per_cpu_var(var) per_cpu__##var
-
 #ifdef CONFIG_SMP
 
 /*
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index f6aa18e..83a97dd 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_ALTERNATIVE_H
 #define _ASM_X86_ALTERNATIVE_H
 
+#ifndef __ASSEMBLER__
+
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <asm/asm.h>
@@ -180,4 +182,6 @@ extern void add_nops(void *insns, unsigned int len);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 
+#endif /* !__ASSEMBLER__ */
+
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/include/asm/apic-defs.h b/arch/x86/include/asm/apic-defs.h
new file mode 100644
index 0000000..3f0261d
--- /dev/null
+++ b/arch/x86/include/asm/apic-defs.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_APIC_DEFS_H
+#define _ASM_X86_APIC_DEFS_H
+
+#include <linux/percpu-defs.h>
+
+#ifdef CONFIG_X86_64
+DECLARE_PER_CPU(int, x2apic_extra_bits);
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+#endif
+
+#endif /* _ASM_X86_APIC_DEFS_H */
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..e40c194 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -4,7 +4,9 @@
 #include <linux/cpumask.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
+#include <linux/percpu.h>
 
+#include <asm/apic-defs.h>
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
@@ -432,7 +434,6 @@ extern int default_acpi_madt_oem_check(char *, char *);
 extern void apic_send_IPI_self(int vector);
 
 extern struct apic apic_x2apic_uv_x;
-DECLARE_PER_CPU(int, x2apic_extra_bits);
 
 extern int default_cpu_present_to_apicid(int mps_cpu);
 extern int default_check_phys_apicid_present(int boot_cpu_physical_apicid);
@@ -463,8 +464,6 @@ static inline const struct cpumask *default_target_cpus(void)
 #endif
 }
 
-DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
-
 
 static inline unsigned int read_apic_id(void)
 {
diff --git a/arch/x86/include/asm/current.h b/arch/x86/include/asm/current.h
index c68c361..11b7123 100644
--- a/arch/x86/include/asm/current.h
+++ b/arch/x86/include/asm/current.h
@@ -2,9 +2,10 @@
 #define _ASM_X86_CURRENT_H
 
 #include <linux/compiler.h>
-#include <asm/percpu.h>
 
 #ifndef __ASSEMBLY__
+#include <linux/percpu.h>
+
 struct task_struct;
 
 DECLARE_PER_CPU(struct task_struct *, current_task);
diff --git a/arch/x86/include/asm/irq_regs.h b/arch/x86/include/asm/irq_regs.h
index 7784322..2c5fee5 100644
--- a/arch/x86/include/asm/irq_regs.h
+++ b/arch/x86/include/asm/irq_regs.h
@@ -7,7 +7,7 @@
 #ifndef _ASM_X86_IRQ_REGS_H
 #define _ASM_X86_IRQ_REGS_H
 
-#include <asm/percpu.h>
+#include <linux/percpu-defs.h>
 
 #define ARCH_HAS_OWN_IRQ_REGS
 
diff --git a/arch/x86/include/asm/mm_types.h b/arch/x86/include/asm/mm_types.h
new file mode 100644
index 0000000..09f9742
--- /dev/null
+++ b/arch/x86/include/asm/mm_types.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_X86_MM_TYPES_H
+#define _ASM_X86_MM_TYPES_H
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long		seg;
+} mm_segment_t;
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_X86_MM_TYPES_H */
diff --git a/arch/x86/include/asm/percpu-defs.h b/arch/x86/include/asm/percpu-defs.h
new file mode 100644
index 0000000..801217d
--- /dev/null
+++ b/arch/x86/include/asm/percpu-defs.h
@@ -0,0 +1,67 @@
+#ifndef _ASM_X86_PERCPU_DEFS_H
+#define _ASM_X86_PERCPU_DEFS_H
+
+#include <asm-generic/percpu-defs.h>
+
+#ifdef CONFIG_X86_64_SMP
+#define init_per_cpu_var(var)  init_per_cpu__##var
+#else
+#define init_per_cpu_var(var)  per_cpu_var(var)
+#endif
+
+/*
+ * Initialized pointers to per-cpu variables needed for the boot
+ * processor need to use these macros to get the proper address
+ * offset from __per_cpu_load on SMP.
+ *
+ * There also must be an entry in vmlinux_64.lds.S
+ */
+#define DECLARE_INIT_PER_CPU(var) \
+       extern typeof(per_cpu_var(var)) init_per_cpu_var(var)
+
+#ifdef CONFIG_SMP
+
+/*
+ * Define the "EARLY_PER_CPU" macros.  These are used for some per_cpu
+ * variables that are initialized and accessed before there are per_cpu
+ * areas allocated.
+ */
+
+#define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)			\
+	DEFINE_PER_CPU(_type, _name) = _initvalue;			\
+	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\
+				{ [0 ... NR_CPUS-1] = _initvalue };	\
+	__typeof__(_type) *_name##_early_ptr __refdata = _name##_early_map
+
+#define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
+	EXPORT_PER_CPU_SYMBOL(_name)
+
+#define DECLARE_EARLY_PER_CPU(_type, _name)			\
+	DECLARE_PER_CPU(_type, _name);				\
+	extern __typeof__(_type) *_name##_early_ptr;		\
+	extern __typeof__(_type)  _name##_early_map[]
+
+#define	early_per_cpu_ptr(_name) (_name##_early_ptr)
+#define	early_per_cpu_map(_name, _idx) (_name##_early_map[_idx])
+#define	early_per_cpu(_name, _cpu) 				\
+	*(early_per_cpu_ptr(_name) ?				\
+		&early_per_cpu_ptr(_name)[_cpu] :		\
+		&per_cpu(_name, _cpu))
+
+#else	/* !CONFIG_SMP */
+#define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)		\
+	DEFINE_PER_CPU(_type, _name) = _initvalue
+
+#define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
+	EXPORT_PER_CPU_SYMBOL(_name)
+
+#define DECLARE_EARLY_PER_CPU(_type, _name)			\
+	DECLARE_PER_CPU(_type, _name)
+
+#define	early_per_cpu(_name, _cpu) per_cpu(_name, _cpu)
+#define	early_per_cpu_ptr(_name) NULL
+/* no early_per_cpu_map() */
+
+#endif	/* !CONFIG_SMP */
+
+#endif /* _ASM_X86_PERCPU_DEFS_H */
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index aee103b..60b461f 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -9,8 +9,6 @@
 #define __percpu_mov_op		movl
 #endif
 
-#ifdef __ASSEMBLY__
-
 /*
  * PER_CPU finds an address of a per-cpu variable.
  *
@@ -40,7 +38,8 @@
 #define INIT_PER_CPU_VAR(var)  per_cpu__##var
 #endif
 
-#else /* ...!ASSEMBLY */
+
+#ifndef __ASSEMBLY__
 
 #include <linux/stringify.h>
 
@@ -51,22 +50,6 @@
 #define __percpu_arg(x)		"%" #x
 #endif
 
-/*
- * Initialized pointers to per-cpu variables needed for the boot
- * processor need to use these macros to get the proper address
- * offset from __per_cpu_load on SMP.
- *
- * There also must be an entry in vmlinux_64.lds.S
- */
-#define DECLARE_INIT_PER_CPU(var) \
-       extern typeof(per_cpu_var(var)) init_per_cpu_var(var)
-
-#ifdef CONFIG_X86_64_SMP
-#define init_per_cpu_var(var)  init_per_cpu__##var
-#else
-#define init_per_cpu_var(var)  per_cpu_var(var)
-#endif
-
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
@@ -157,49 +140,4 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
 #endif /* !__ASSEMBLY__ */
 
-#ifdef CONFIG_SMP
-
-/*
- * Define the "EARLY_PER_CPU" macros.  These are used for some per_cpu
- * variables that are initialized and accessed before there are per_cpu
- * areas allocated.
- */
-
-#define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)			\
-	DEFINE_PER_CPU(_type, _name) = _initvalue;			\
-	__typeof__(_type) _name##_early_map[NR_CPUS] __initdata =	\
-				{ [0 ... NR_CPUS-1] = _initvalue };	\
-	__typeof__(_type) *_name##_early_ptr __refdata = _name##_early_map
-
-#define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
-	EXPORT_PER_CPU_SYMBOL(_name)
-
-#define DECLARE_EARLY_PER_CPU(_type, _name)			\
-	DECLARE_PER_CPU(_type, _name);				\
-	extern __typeof__(_type) *_name##_early_ptr;		\
-	extern __typeof__(_type)  _name##_early_map[]
-
-#define	early_per_cpu_ptr(_name) (_name##_early_ptr)
-#define	early_per_cpu_map(_name, _idx) (_name##_early_map[_idx])
-#define	early_per_cpu(_name, _cpu) 				\
-	*(early_per_cpu_ptr(_name) ?				\
-		&early_per_cpu_ptr(_name)[_cpu] :		\
-		&per_cpu(_name, _cpu))
-
-#else	/* !CONFIG_SMP */
-#define	DEFINE_EARLY_PER_CPU(_type, _name, _initvalue)		\
-	DEFINE_PER_CPU(_type, _name) = _initvalue
-
-#define EXPORT_EARLY_PER_CPU_SYMBOL(_name)			\
-	EXPORT_PER_CPU_SYMBOL(_name)
-
-#define DECLARE_EARLY_PER_CPU(_type, _name)			\
-	DECLARE_PER_CPU(_type, _name)
-
-#define	early_per_cpu(_name, _cpu) per_cpu(_name, _cpu)
-#define	early_per_cpu_ptr(_name) NULL
-/* no early_per_cpu_map() */
-
-#endif	/* !CONFIG_SMP */
-
 #endif /* _ASM_X86_PERCPU_H */
diff --git a/arch/x86/include/asm/prefetch.h b/arch/x86/include/asm/prefetch.h
new file mode 100644
index 0000000..ae17dd6
--- /dev/null
+++ b/arch/x86/include/asm/prefetch.h
@@ -0,0 +1,49 @@
+#ifndef _ASM_X86_PREFETCH_H
+#define _ASM_X86_PREFETCH_H
+
+#include <asm/alternative.h>
+
+#define ARCH_HAS_PREFETCHW
+#define ARCH_HAS_SPINLOCK_PREFETCH
+
+#ifdef CONFIG_X86_32
+# define BASE_PREFETCH		ASM_NOP4
+# define ARCH_HAS_PREFETCH
+#else
+# define BASE_PREFETCH		"prefetcht0 (%1)"
+#endif
+
+/*
+ * Prefetch instructions for Pentium III (+) and AMD Athlon (+)
+ *
+ * It's not worth to care about 3dnow prefetches for the K6
+ * because they are microcoded there and very slow.
+ */
+static inline void prefetch(const void *x)
+{
+	alternative_input(BASE_PREFETCH,
+			  "prefetchnta (%1)",
+			  X86_FEATURE_XMM,
+			  "r" (x));
+}
+
+/*
+ * 3dnow prefetch to get an exclusive cache line.
+ * Useful for spinlocks to avoid one state transition in the
+ * cache coherency protocol:
+ */
+static inline void prefetchw(const void *x)
+{
+	alternative_input(BASE_PREFETCH,
+			  "prefetchw (%1)",
+			  X86_FEATURE_3DNOW,
+			  "r" (x));
+}
+
+static inline void spin_lock_prefetch(const void *x)
+{
+	prefetchw(x);
+}
+
+
+#endif /* _ASM_X86_PREFETCH_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..15ba82c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -7,21 +7,21 @@
 struct task_struct;
 struct mm_struct;
 
+#include <linux/percpu-defs.h>
 #include <asm/vm86.h>
 #include <asm/math_emu.h>
 #include <asm/segment.h>
 #include <asm/types.h>
 #include <asm/sigcontext.h>
-#include <asm/current.h>
 #include <asm/cpufeature.h>
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable_types.h>
-#include <asm/percpu.h>
 #include <asm/msr.h>
 #include <asm/desc_defs.h>
 #include <asm/nops.h>
 #include <asm/ds.h>
+#include <asm/prefetch.h>
 
 #include <linux/personality.h>
 #include <linux/cpumask.h>
@@ -615,10 +615,6 @@ static inline void clear_in_cr4(unsigned long mask)
 	write_cr4(cr4);
 }
 
-typedef struct {
-	unsigned long		seg;
-} mm_segment_t;
-
 
 /*
  * create a kernel thread without removing it from tasklists
@@ -818,47 +814,6 @@ extern int			bootloader_type;
 extern char			ignore_fpu_irq;
 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT 1
-#define ARCH_HAS_PREFETCHW
-#define ARCH_HAS_SPINLOCK_PREFETCH
-
-#ifdef CONFIG_X86_32
-# define BASE_PREFETCH		ASM_NOP4
-# define ARCH_HAS_PREFETCH
-#else
-# define BASE_PREFETCH		"prefetcht0 (%1)"
-#endif
-
-/*
- * Prefetch instructions for Pentium III (+) and AMD Athlon (+)
- *
- * It's not worth to care about 3dnow prefetches for the K6
- * because they are microcoded there and very slow.
- */
-static inline void prefetch(const void *x)
-{
-	alternative_input(BASE_PREFETCH,
-			  "prefetchnta (%1)",
-			  X86_FEATURE_XMM,
-			  "r" (x));
-}
-
-/*
- * 3dnow prefetch to get an exclusive cache line.
- * Useful for spinlocks to avoid one state transition in the
- * cache coherency protocol:
- */
-static inline void prefetchw(const void *x)
-{
-	alternative_input(BASE_PREFETCH,
-			  "prefetchw (%1)",
-			  X86_FEATURE_3DNOW,
-			  "r" (x));
-}
-
-static inline void spin_lock_prefetch(const void *x)
-{
-	prefetchw(x);
-}
 
 #ifdef CONFIG_X86_32
 /*
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19e0d88..9776d86 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -3,14 +3,14 @@
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
 #include <linux/init.h>
-#include <asm/percpu.h>
+#include <linux/percpu-defs.h>
 
 /*
  * We need the APIC definitions automatically as part of 'smp.h'
  */
 #ifdef CONFIG_X86_LOCAL_APIC
 # include <asm/mpspec.h>
-# include <asm/apic.h>
+# include <asm/apic-defs.h>
 # ifdef CONFIG_X86_IO_APIC
 #  include <asm/io_apic.h>
 # endif
@@ -26,6 +26,11 @@ DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
 
+DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
+DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+
+#include <linux/percpu.h>
+
 static inline struct cpumask *cpu_sibling_mask(int cpu)
 {
 	return per_cpu(cpu_sibling_map, cpu);
@@ -36,9 +41,6 @@ static inline struct cpumask *cpu_core_mask(int cpu)
 	return per_cpu(cpu_core_map, cpu);
 }
 
-DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
-DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
-
 /* Static state in head.S used to set up a CPU */
 extern struct {
 	void *sp;
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index c2d742c..8aad2c0 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -37,7 +37,7 @@
 
 #include <asm/tsc.h>
 #include <asm/processor.h>
-#include <asm/percpu.h>
+#include <linux/percpu-defs.h>
 #include <asm/system.h>
 #include <asm/desc.h>
 #include <linux/random.h>
diff --git a/arch/x86/include/asm/thread_info-defs.h b/arch/x86/include/asm/thread_info-defs.h
new file mode 100644
index 0000000..57c662a
--- /dev/null
+++ b/arch/x86/include/asm/thread_info-defs.h
@@ -0,0 +1,165 @@
+/* thread_info.h: low-level thread information
+ *
+ * Copyright (C) 2002  David Howells (dhowells@redhat.com)
+ * - Incorporating suggestions made by Linus Torvalds and Dave Miller
+ */
+
+#ifndef _ASM_X86_THREAD_INFO_DEFS_H
+#define _ASM_X86_THREAD_INFO_DEFS_H
+
+#include <linux/compiler.h>
+#include <asm/types.h>
+#include <asm/mm_types.h>
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ */
+#ifndef __ASSEMBLY__
+struct task_struct;
+struct exec_domain;
+
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	__u32			flags;		/* low level flags */
+	__u32			status;		/* thread synchronous flags */
+	__u32			cpu;		/* current CPU */
+	int			preempt_count;	/* 0 => preemptable,
+						   <0 => BUG */
+	mm_segment_t		addr_limit;
+	struct restart_block    restart_block;
+	void __user		*sysenter_return;
+#ifdef CONFIG_X86_32
+	unsigned long           previous_esp;   /* ESP of the previous stack in
+						   case of nested (IRQ) stacks
+						*/
+	__u8			supervisor_stack[0];
+#endif
+	int			uaccess_err;
+};
+
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= 1,			\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+#else /* !__ASSEMBLY__ */
+
+#include <asm/asm-offsets.h>
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files
+ *   may need to access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ * Warning: layout of LSW is hardcoded in entry.S
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
+#define TIF_IRET		5	/* force IRET */
+#define TIF_SYSCALL_EMU		6	/* syscall emulation active */
+#define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
+#define TIF_SECCOMP		8	/* secure computing */
+#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_NOTSC		16	/* TSC is not accessible in userland */
+#define TIF_IA32		17	/* 32bit process */
+#define TIF_FORK		18	/* ret_from_fork */
+#define TIF_ABI_PENDING		19
+#define TIF_MEMDIE		20
+#define TIF_DEBUG		21	/* uses debug registers */
+#define TIF_IO_BITMAP		22	/* uses I/O bitmap */
+#define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
+#define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
+#define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
+#define TIF_SYSCALL_FTRACE	27	/* for ftrace syscall instrumentation */
+
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_IRET		(1 << TIF_IRET)
+#define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_NOTSC		(1 << TIF_NOTSC)
+#define _TIF_IA32		(1 << TIF_IA32)
+#define _TIF_FORK		(1 << TIF_FORK)
+#define _TIF_ABI_PENDING	(1 << TIF_ABI_PENDING)
+#define _TIF_DEBUG		(1 << TIF_DEBUG)
+#define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
+#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
+#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
+#define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
+
+/* work to do in syscall_trace_enter() */
+#define _TIF_WORK_SYSCALL_ENTRY	\
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_FTRACE |	\
+	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
+
+/* work to do in syscall_trace_leave() */
+#define _TIF_WORK_SYSCALL_EXIT	\
+	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
+	 _TIF_SYSCALL_FTRACE)
+
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK							\
+	(0x0000FFFF &							\
+	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
+	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
+
+/* work to do on any return to user space */
+#define _TIF_ALLWORK_MASK ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_FTRACE)
+
+/* Only used for 64 bit */
+#define _TIF_DO_NOTIFY_MASK						\
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
+
+/* flags to check in __switch_to() */
+#define _TIF_WORK_CTXSW							\
+	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_NOTSC)
+
+#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
+#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
+
+#define PREEMPT_ACTIVE		0x10000000
+
+/*
+ * Thread-synchronous status.
+ *
+ * This is different from the flags in that nobody else
+ * ever touches our thread-synchronous status, so we don't
+ * have to worry about atomic accesses.
+ */
+#define TS_USEDFPU		0x0001	/* FPU was used by this task
+					   this quantum (SMP) */
+#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
+#define TS_POLLING		0x0004	/* true if in idle loop
+					   and not sleeping */
+#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
+#define TS_XSAVE		0x0010	/* Use xsave/xrstor */
+
+#endif /* _ASM_X86_THREAD_INFO_DEFS_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 8820a73..c4716b1 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -8,147 +8,13 @@
 #define _ASM_X86_THREAD_INFO_H
 
 #include <linux/compiler.h>
-#include <asm/page.h>
-#include <asm/types.h>
+#include <asm/thread_info-defs.h>
 
-/*
- * low level task data that entry.S needs immediate access to
- * - this struct should fit entirely inside of one cache line
- * - this struct shares the supervisor stack pages
- */
-#ifndef __ASSEMBLY__
-struct task_struct;
-struct exec_domain;
-#include <asm/processor.h>
+#ifndef __ASSEMBLER__
 #include <asm/ftrace.h>
 #include <asm/atomic.h>
-
-struct thread_info {
-	struct task_struct	*task;		/* main task structure */
-	struct exec_domain	*exec_domain;	/* execution domain */
-	__u32			flags;		/* low level flags */
-	__u32			status;		/* thread synchronous flags */
-	__u32			cpu;		/* current CPU */
-	int			preempt_count;	/* 0 => preemptable,
-						   <0 => BUG */
-	mm_segment_t		addr_limit;
-	struct restart_block    restart_block;
-	void __user		*sysenter_return;
-#ifdef CONFIG_X86_32
-	unsigned long           previous_esp;   /* ESP of the previous stack in
-						   case of nested (IRQ) stacks
-						*/
-	__u8			supervisor_stack[0];
+#include <asm/page_types.h>
 #endif
-	int			uaccess_err;
-};
-
-#define INIT_THREAD_INFO(tsk)			\
-{						\
-	.task		= &tsk,			\
-	.exec_domain	= &default_exec_domain,	\
-	.flags		= 0,			\
-	.cpu		= 0,			\
-	.preempt_count	= 1,			\
-	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
-}
-
-#define init_thread_info	(init_thread_union.thread_info)
-#define init_stack		(init_thread_union.stack)
-
-#else /* !__ASSEMBLY__ */
-
-#include <asm/asm-offsets.h>
-
-#endif
-
-/*
- * thread information flags
- * - these are process state flags that various assembly files
- *   may need to access
- * - pending work-to-be-done flags are in LSW
- * - other flags in MSW
- * Warning: layout of LSW is hardcoded in entry.S
- */
-#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
-#define TIF_IRET		5	/* force IRET */
-#define TIF_SYSCALL_EMU		6	/* syscall emulation active */
-#define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
-#define TIF_SECCOMP		8	/* secure computing */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
-#define TIF_NOTSC		16	/* TSC is not accessible in userland */
-#define TIF_IA32		17	/* 32bit process */
-#define TIF_FORK		18	/* ret_from_fork */
-#define TIF_ABI_PENDING		19
-#define TIF_MEMDIE		20
-#define TIF_DEBUG		21	/* uses debug registers */
-#define TIF_IO_BITMAP		22	/* uses I/O bitmap */
-#define TIF_FREEZE		23	/* is freezing for suspend */
-#define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
-#define TIF_DEBUGCTLMSR		25	/* uses thread_struct.debugctlmsr */
-#define TIF_DS_AREA_MSR		26      /* uses thread_struct.ds_area_msr */
-#define TIF_SYSCALL_FTRACE	27	/* for ftrace syscall instrumentation */
-
-#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
-#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
-#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-#define _TIF_IRET		(1 << TIF_IRET)
-#define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
-#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
-#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
-#define _TIF_NOTSC		(1 << TIF_NOTSC)
-#define _TIF_IA32		(1 << TIF_IA32)
-#define _TIF_FORK		(1 << TIF_FORK)
-#define _TIF_ABI_PENDING	(1 << TIF_ABI_PENDING)
-#define _TIF_DEBUG		(1 << TIF_DEBUG)
-#define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
-#define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
-#define _TIF_DEBUGCTLMSR	(1 << TIF_DEBUGCTLMSR)
-#define _TIF_DS_AREA_MSR	(1 << TIF_DS_AREA_MSR)
-#define _TIF_SYSCALL_FTRACE	(1 << TIF_SYSCALL_FTRACE)
-
-/* work to do in syscall_trace_enter() */
-#define _TIF_WORK_SYSCALL_ENTRY	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_FTRACE |	\
-	 _TIF_SYSCALL_AUDIT | _TIF_SECCOMP | _TIF_SINGLESTEP)
-
-/* work to do in syscall_trace_leave() */
-#define _TIF_WORK_SYSCALL_EXIT	\
-	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | _TIF_SINGLESTEP |	\
-	 _TIF_SYSCALL_FTRACE)
-
-/* work to do on interrupt/exception return */
-#define _TIF_WORK_MASK							\
-	(0x0000FFFF &							\
-	 ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|			\
-	   _TIF_SINGLESTEP|_TIF_SECCOMP|_TIF_SYSCALL_EMU))
-
-/* work to do on any return to user space */
-#define _TIF_ALLWORK_MASK ((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_FTRACE)
-
-/* Only used for 64 bit */
-#define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
-
-/* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_DEBUGCTLMSR|_TIF_DS_AREA_MSR|_TIF_NOTSC)
-
-#define _TIF_WORK_CTXSW_PREV _TIF_WORK_CTXSW
-#define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
-
-#define PREEMPT_ACTIVE		0x10000000
 
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
@@ -165,6 +31,7 @@ struct thread_info {
 #ifdef CONFIG_X86_32
 
 #define STACK_WARN	(THREAD_SIZE/8)
+
 /*
  * macros/functions for gaining access to the thread information structure
  *
@@ -172,7 +39,6 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-
 /* how to get the current stack pointer from C */
 register unsigned long current_stack_pointer asm("esp") __used;
 
@@ -194,17 +60,19 @@ static inline struct thread_info *current_thread_info(void)
 #define GET_THREAD_INFO_WITH_ESP(reg) \
 	andl $-THREAD_SIZE, reg
 
-#endif
+#endif /* !__ASSEMBLY__ */
 
 #else /* X86_32 */
 
-#include <asm/percpu.h>
+#include <linux/percpu-defs.h>
 #define KERNEL_STACK_OFFSET (5*8)
 
 /*
  * macros/functions for gaining access to the thread information structure
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */
+#include <linux/percpu.h>
+
 #ifndef __ASSEMBLY__
 DECLARE_PER_CPU(unsigned long, kernel_stack);
 
@@ -223,28 +91,17 @@ static inline struct thread_info *current_thread_info(void)
 	movq PER_CPU_VAR(kernel_stack),reg ; \
 	subq $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg
 
-#endif
+#endif /* !__ASSEMBLY__ */
 
 #endif /* !X86_32 */
 
 /*
- * Thread-synchronous status.
- *
- * This is different from the flags in that nobody else
- * ever touches our thread-synchronous status, so we don't
- * have to worry about atomic accesses.
+ * Thread-synchronous status accessors
  */
-#define TS_USEDFPU		0x0001	/* FPU was used by this task
-					   this quantum (SMP) */
-#define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-#define TS_POLLING		0x0004	/* true if in idle loop
-					   and not sleeping */
-#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
-#define TS_XSAVE		0x0010	/* Use xsave/xrstor */
+#ifndef __ASSEMBLY__
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
-#ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
 static inline void set_restore_sigmask(void)
 {
@@ -260,4 +117,5 @@ extern void free_thread_info(struct thread_info *ti);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 #define arch_task_cache_init arch_task_cache_init
 #endif
+
 #endif /* _ASM_X86_THREAD_INFO_H */
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index bbbe4bb..73781d8 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include <linux/percpu-alloc.h>
 
 #include <acpi/processor.h>
 #include <asm/acpi.h>
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index b7d438a..f212bad 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -40,6 +40,7 @@
 #include <linux/fcntl.h>
 #include <linux/in.h>
 #include <linux/init.h>
+#include <linux/percpu-alloc.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
diff --git a/fs/nfs/iostat.h b/fs/nfs/iostat.h
index a2ab252..304f668 100644
--- a/fs/nfs/iostat.h
+++ b/fs/nfs/iostat.h
@@ -11,6 +11,7 @@
 #define _NFS_IOSTAT
 
 #include <linux/percpu.h>
+#include <linux/percpu-alloc.h>
 #include <linux/cache.h>
 #include <linux/nfs_iostat.h>
 
diff --git a/include/asm-generic/percpu-defs.h b/include/asm-generic/percpu-defs.h
new file mode 100644
index 0000000..6ed3f57
--- /dev/null
+++ b/include/asm-generic/percpu-defs.h
@@ -0,0 +1,33 @@
+#ifndef _ASM_GENERIC_PERCPU_DEFS_H
+#define _ASM_GENERIC_PERCPU_DEFS_H
+
+
+#ifndef PER_CPU_BASE_SECTION
+#ifdef CONFIG_SMP
+#define PER_CPU_BASE_SECTION ".data.percpu"
+#else
+#define PER_CPU_BASE_SECTION ".data"
+#endif
+#endif
+
+#ifdef CONFIG_SMP
+
+#ifdef MODULE
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#else
+#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
+#endif
+#define PER_CPU_FIRST_SECTION ".first"
+
+#else
+
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_FIRST_SECTION ""
+
+#endif
+
+#ifndef PER_CPU_ATTRIBUTES
+#define PER_CPU_ATTRIBUTES
+#endif
+
+#endif /* _ASM_GENERIC_PERCPU_DEFS_H */
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index af47b9e..8dfca11 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -73,50 +73,4 @@ extern void setup_per_cpu_areas(void);
 
 #endif	/* SMP */
 
-#ifndef PER_CPU_BASE_SECTION
-#ifdef CONFIG_SMP
-#define PER_CPU_BASE_SECTION ".data.percpu"
-#else
-#define PER_CPU_BASE_SECTION ".data"
-#endif
-#endif
-
-#ifdef CONFIG_SMP
-
-#ifdef MODULE
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#else
-#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
-#endif
-#define PER_CPU_FIRST_SECTION ".first"
-
-#else
-
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#define PER_CPU_FIRST_SECTION ""
-
-#endif
-
-#ifndef PER_CPU_ATTRIBUTES
-#define PER_CPU_ATTRIBUTES
-#endif
-
-#define DECLARE_PER_CPU_SECTION(type, name, section)			\
-	extern \
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-
-#define DECLARE_PER_CPU(type, name)					\
-	DECLARE_PER_CPU_SECTION(type, name, "")
-
-#define DECLARE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
-	____cacheline_aligned_in_smp
-
-#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")
-
-#define DECLARE_PER_CPU_FIRST(type, name)				\
-	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/completion-defs.h b/include/linux/completion-defs.h
new file mode 100644
index 0000000..8c10130
--- /dev/null
+++ b/include/linux/completion-defs.h
@@ -0,0 +1,30 @@
+#ifndef __LINUX_COMPLETION_DEFS_H
+#define __LINUX_COMPLETION_DEFS_H
+
+/*
+ * (C) Copyright 2001 Linus Torvalds
+ *
+ * Atomic wait-for-completion handler data structures.
+ * See kernel/sched.c for details.
+ */
+
+#include <linux/wait-defs.h>
+
+/**
+ * struct completion - structure used to maintain state for a "completion"
+ *
+ * This is the opaque structure used to maintain the state for a "completion".
+ * Completions currently use a FIFO to queue threads that have to wait for
+ * the "completion" event.
+ *
+ * See also:  complete(), wait_for_completion() (and friends _timeout,
+ * _interruptible, _interruptible_timeout, and _killable), init_completion(),
+ * and macros DECLARE_COMPLETION(), DECLARE_COMPLETION_ONSTACK(), and
+ * INIT_COMPLETION().
+ */
+struct completion {
+	unsigned int done;
+	wait_queue_head_t wait;
+};
+
+#endif /*  __LINUX_COMPLETION_DEFS_H */
diff --git a/include/linux/completion.h b/include/linux/completion.h
index 4a6b604..a3833cd 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -8,25 +8,9 @@
  * See kernel/sched.c for details.
  */
 
+#include <linux/completion-defs.h>
 #include <linux/wait.h>
 
-/**
- * struct completion - structure used to maintain state for a "completion"
- *
- * This is the opaque structure used to maintain the state for a "completion".
- * Completions currently use a FIFO to queue threads that have to wait for
- * the "completion" event.
- *
- * See also:  complete(), wait_for_completion() (and friends _timeout,
- * _interruptible, _interruptible_timeout, and _killable), init_completion(),
- * and macros DECLARE_COMPLETION(), DECLARE_COMPLETION_ONSTACK(), and
- * INIT_COMPLETION().
- */
-struct completion {
-	unsigned int done;
-	wait_queue_head_t wait;
-};
-
 #define COMPLETION_INITIALIZER(work) \
 	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 562d285..4b8e0d6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -297,7 +297,7 @@ struct inodes_stat_t {
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
-#include <linux/wait.h>
+#include <linux/wait-defs.h>
 #include <linux/types.h>
 #include <linux/kdev_t.h>
 #include <linux/dcache.h>
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 634c530..41dc97c 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kdev_t.h>
 #include <linux/rcupdate.h>
+#include <linux/percpu-alloc.h>
 
 #ifdef CONFIG_BLOCK
 
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0bbc15f..91d78a6 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -1,10 +1,7 @@
 #ifndef __LINUX_GFP_H
 #define __LINUX_GFP_H
 
-#include <linux/mmzone.h>
-#include <linux/stddef.h>
-#include <linux/linkage.h>
-#include <linux/topology.h>
+#include <linux/types.h>
 
 struct vm_area_struct;
 
@@ -99,6 +96,11 @@ struct vm_area_struct;
 /* 4GB DMA on some platforms */
 #define GFP_DMA32	__GFP_DMA32
 
+#include <linux/mmzone.h>
+#include <linux/stddef.h>
+#include <linux/linkage.h>
+#include <linux/topology.h>
+
 /* Convert GFP flags to their corresponding migrate type */
 static inline int allocflags_to_migratetype(gfp_t gfp_flags)
 {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 186ec6a..86d23d2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -4,15 +4,15 @@
 #ifndef __ASSEMBLY__
 #ifndef __GENERATING_BOUNDS_H
 
-#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
 #include <linux/list.h>
-#include <linux/wait.h>
+#include <linux/wait-defs.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
 #include <linux/threads.h>
 #include <linux/numa.h>
 #include <linux/init.h>
-#include <linux/seqlock.h>
+#include <linux/seqlock-defs.h>
 #include <linux/nodemask.h>
 #include <linux/pageblock-flags.h>
 #include <linux/bounds.h>
diff --git a/include/linux/percpu-alloc.h b/include/linux/percpu-alloc.h
new file mode 100644
index 0000000..c75f8ff
--- /dev/null
+++ b/include/linux/percpu-alloc.h
@@ -0,0 +1,42 @@
+#ifndef __LINUX_PERCPU_ALLOC_H
+#define __LINUX_PERCPU_ALLOC_H
+
+#include <linux/percpu.h>
+#include <linux/slab.h> /* For kmalloc() */
+
+#ifdef CONFIG_SMP
+
+#ifdef CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
+
+extern void *__alloc_reserved_percpu(size_t size, size_t align);
+
+#endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
+
+extern void *__alloc_percpu(size_t size, size_t align);
+extern void free_percpu(void *__pdata);
+
+#else /* CONFIG_SMP */
+
+static inline void *__alloc_percpu(size_t size, size_t align)
+{
+	/*
+	 * Can't easily make larger alignment work with kmalloc.  WARN
+	 * on it.  Larger alignment should only be used for module
+	 * percpu sections on SMP for which this path isn't used.
+	 */
+	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
+	return kzalloc(size, GFP_KERNEL);
+}
+
+static inline void free_percpu(void *p)
+{
+	kfree(p);
+}
+
+#endif /* CONFIG_SMP */
+
+#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
+						       __alignof__(type))
+
+
+#endif /* __LINUX_PERCPU_ALLOC_H */
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
new file mode 100644
index 0000000..b99eab5
--- /dev/null
+++ b/include/linux/percpu-defs.h
@@ -0,0 +1,79 @@
+#ifndef _LINUX_PERCPU_DEFS_H
+#define _LINUX_PERCPU_DEFS_H
+
+#include <asm/percpu-defs.h>
+
+/*
+ * Determine the real variable name from the name visible in the
+ * kernel sources.
+ */
+#define per_cpu_var(var) per_cpu__##var
+
+/*
+ * Base implementations of per-CPU variable declarations and definitions, where
+ * the section in which the variable is to be placed is provided by the
+ * 'section' argument.  This may be used to affect the parameters governing the
+ * variable's storage.
+ *
+ * NOTE!  The sections for the DECLARE and for the DEFINE must match, lest
+ * linkage errors occur due the compiler generating the wrong code to access
+ * that section.
+ */
+#define DECLARE_PER_CPU_SECTION(type, name, section)			\
+	extern								\
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+#define DEFINE_PER_CPU_SECTION(type, name, section)			\
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+/*
+ * Variant on the per-CPU variable declaration/definition theme used for
+ * ordinary per-CPU variables.
+ */
+#define DECLARE_PER_CPU(type, name)					\
+	DECLARE_PER_CPU_SECTION(type, name, "")
+
+#define DEFINE_PER_CPU(type, name)					\
+	DEFINE_PER_CPU_SECTION(type, name, "")
+
+/*
+ * Declaration/definition used for per-CPU variables that must come first in
+ * the set of variables.
+ */
+#define DECLARE_PER_CPU_FIRST(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
+
+/*
+ * Declaration/definition used for per-CPU variables that must be cacheline
+ * aligned under SMP conditions and shared (?).
+ */
+#define DECLARE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
+	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
+	____cacheline_aligned_in_smp
+
+/*
+ * Declaration/definition used for per-CPU variables that must be page aligned.
+ */
+#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")
+
+/*
+ * Intermodule exports for per-CPU variables.
+ */
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+
+
+#endif /* _LINUX_PERCPU_DEFS_H */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index f052d81..4cb47c8 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -1,33 +1,16 @@
 #ifndef __LINUX_PERCPU_H
 #define __LINUX_PERCPU_H
 
+#include <linux/percpu-defs.h>
+#ifndef __ASSEMBLER__
 #include <linux/preempt.h>
-#include <linux/slab.h> /* For kmalloc() */
-#include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/pfn.h>
-
+#include <linux/init.h>
+#endif
 #include <asm/percpu.h>
 
-#define DEFINE_PER_CPU_SECTION(type, name, section)			\
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU(type, name)					\
-	DEFINE_PER_CPU_SECTION(type, name, "")
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
-	____cacheline_aligned_in_smp
-
-#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")
-
-#define DEFINE_PER_CPU_FIRST(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
-
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+#ifndef __ASSEMBLER__
 
 /* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
@@ -98,8 +81,6 @@ extern ssize_t __init pcpu_embed_first_chunk(
  */
 #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
 
-extern void *__alloc_reserved_percpu(size_t size, size_t align);
-
 #else /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
 
 struct percpu_data {
@@ -116,34 +97,12 @@ struct percpu_data {
 
 #endif /* CONFIG_HAVE_DYNAMIC_PER_CPU_AREA */
 
-extern void *__alloc_percpu(size_t size, size_t align);
-extern void free_percpu(void *__pdata);
-
 #else /* CONFIG_SMP */
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void *__alloc_percpu(size_t size, size_t align)
-{
-	/*
-	 * Can't easily make larger alignment work with kmalloc.  WARN
-	 * on it.  Larger alignment should only be used for module
-	 * percpu sections on SMP for which this path isn't used.
-	 */
-	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return kzalloc(size, GFP_KERNEL);
-}
-
-static inline void free_percpu(void *p)
-{
-	kfree(p);
-}
-
 #endif /* CONFIG_SMP */
 
-#define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
-						       __alignof__(type))
-
 /*
  * Optional methods for optimized non-lvalue per-cpu variable access.
  *
@@ -196,4 +155,5 @@ do {									\
 # define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
 #endif
 
+#endif /* !__ASSEMBLER__ */
 #endif /* __LINUX_PERCPU_H */
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 72b1a10..a3c0b06 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -6,7 +6,7 @@
  * preempt_count (used for kernel preemption, interrupt count, etc.)
  */
 
-#include <linux/thread_info.h>
+#include <linux/thread_info-defs.h>
 #include <linux/linkage.h>
 #include <linux/list.h>
 
diff --git a/include/linux/prefetch.h b/include/linux/prefetch.h
index af7c36a..cfe920a 100644
--- a/include/linux/prefetch.h
+++ b/include/linux/prefetch.h
@@ -11,8 +11,7 @@
 #define _LINUX_PREFETCH_H
 
 #include <linux/types.h>
-#include <asm/processor.h>
-#include <asm/cache.h>
+#include <asm/prefetch.h>
 
 /*
 	prefetch(x) attempts to pre-emptively get the memory pointed to
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 15fbb3c..f1a6c0e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -39,7 +39,7 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
-#include <linux/completion.h>
+#include <linux/completion-defs.h>
 
 /**
  * struct rcu_head - callback structure for use with RCU
diff --git a/include/linux/seqlock-defs.h b/include/linux/seqlock-defs.h
new file mode 100644
index 0000000..a06a460
--- /dev/null
+++ b/include/linux/seqlock-defs.h
@@ -0,0 +1,37 @@
+/*
+ * Reader/writer consistent mechanism without starving writers. This type of
+ * lock for data where the reader wants a consistent set of information
+ * and is willing to retry if the information changes.  Readers never
+ * block but they may have to retry if a writer is in
+ * progress. Writers do not wait for readers.
+ *
+ * This is not as cache friendly as brlock. Also, this will not work
+ * for data that contains pointers, because any writer could
+ * invalidate a pointer that a reader was following.
+ *
+ * Expected reader usage:
+ * 	do {
+ *	    seq = read_seqbegin(&foo);
+ * 	...
+ *      } while (read_seqretry(&foo, seq));
+ *
+ *
+ * On non-SMP the spin locks disappear but the writer still needs
+ * to increment the sequence variables because an interrupt routine could
+ * change the state of the data.
+ *
+ * Based on x86_64 vsyscall gettimeofday
+ * by Keith Owens and Andrea Arcangeli
+ */
+
+#ifndef __LINUX_SEQLOCK_DEFS_H
+#define __LINUX_SEQLOCK_DEFS_H
+
+#include <linux/spinlock_types.h>
+
+typedef struct {
+	unsigned sequence;
+	spinlock_t lock;
+} seqlock_t;
+
+#endif /* __LINUX_SEQLOCK_DEFS_H */
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 632205c..a19b500 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -1,11 +1,9 @@
-#ifndef __LINUX_SEQLOCK_H
-#define __LINUX_SEQLOCK_H
 /*
  * Reader/writer consistent mechanism without starving writers. This type of
  * lock for data where the reader wants a consistent set of information
  * and is willing to retry if the information changes.  Readers never
  * block but they may have to retry if a writer is in
- * progress. Writers do not wait for readers. 
+ * progress. Writers do not wait for readers.
  *
  * This is not as cache friendly as brlock. Also, this will not work
  * for data that contains pointers, because any writer could
@@ -22,17 +20,16 @@
  * to increment the sequence variables because an interrupt routine could
  * change the state of the data.
  *
- * Based on x86_64 vsyscall gettimeofday 
+ * Based on x86_64 vsyscall gettimeofday
  * by Keith Owens and Andrea Arcangeli
  */
 
-#include <linux/spinlock.h>
-#include <linux/preempt.h>
+#ifndef __LINUX_SEQLOCK_H
+#define __LINUX_SEQLOCK_H
 
-typedef struct {
-	unsigned sequence;
-	spinlock_t lock;
-} seqlock_t;
+#include <linux/seqlock-defs.h>
+#include <linux/preempt.h>
+#include <linux/spinlock.h>
 
 /*
  * These macros triggered gcc-3.x compile-time problems.  We think these are
@@ -53,7 +50,8 @@ typedef struct {
 #define DEFINE_SEQLOCK(x) \
 		seqlock_t x = __SEQLOCK_UNLOCKED(x)
 
-/* Lock out other writers and update the count.
+/*
+ * Lock out other writers and update the count.
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
  */
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 252b245..137dcff 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -50,7 +50,6 @@
 #include <linux/preempt.h>
 #include <linux/linkage.h>
 #include <linux/compiler.h>
-#include <linux/thread_info.h>
 #include <linux/kernel.h>
 #include <linux/stringify.h>
 #include <linux/bottom_half.h>
diff --git a/include/linux/thread_info-defs.h b/include/linux/thread_info-defs.h
new file mode 100644
index 0000000..fe1257e
--- /dev/null
+++ b/include/linux/thread_info-defs.h
@@ -0,0 +1,54 @@
+/* Common low-level thread information definitions
+ *
+ * Copyright (C) 2002  David Howells (dhowells@redhat.com)
+ * - Incorporating suggestions made by Linus Torvalds
+ */
+
+#ifndef _LINUX_THREAD_INFO_DEFS_H
+#define _LINUX_THREAD_INFO_DEFS_H
+
+#include <linux/types.h>
+
+struct timespec;
+struct compat_timespec;
+
+/*
+ * System call restart block.
+ */
+struct restart_block {
+	long (*fn)(struct restart_block *);
+	union {
+		struct {
+			unsigned long arg0, arg1, arg2, arg3;
+		};
+		/* For futex_wait */
+		struct {
+			u32 *uaddr;
+			u32 val;
+			u32 flags;
+			u32 bitset;
+			u64 time;
+		} futex;
+		/* For nanosleep */
+		struct {
+			clockid_t index;
+			struct timespec __user *rmtp;
+#ifdef CONFIG_COMPAT
+			struct compat_timespec __user *compat_rmtp;
+#endif
+			u64 expires;
+		} nanosleep;
+		/* For poll */
+		struct {
+			struct pollfd __user *ufds;
+			int nfds;
+			int has_timeout;
+			unsigned long tv_sec;
+			unsigned long tv_nsec;
+		} poll;
+	};
+};
+
+#include <asm/thread_info-defs.h>
+
+#endif /* _LINUX_THREAD_INFO_DEFS_H */
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e6b820f..e9cc8da 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -7,52 +7,12 @@
 #ifndef _LINUX_THREAD_INFO_H
 #define _LINUX_THREAD_INFO_H
 
-#include <linux/types.h>
-
-struct timespec;
-struct compat_timespec;
-
-/*
- * System call restart block.
- */
-struct restart_block {
-	long (*fn)(struct restart_block *);
-	union {
-		struct {
-			unsigned long arg0, arg1, arg2, arg3;
-		};
-		/* For futex_wait */
-		struct {
-			u32 *uaddr;
-			u32 val;
-			u32 flags;
-			u32 bitset;
-			u64 time;
-		} futex;
-		/* For nanosleep */
-		struct {
-			clockid_t index;
-			struct timespec __user *rmtp;
-#ifdef CONFIG_COMPAT
-			struct compat_timespec __user *compat_rmtp;
-#endif
-			u64 expires;
-		} nanosleep;
-		/* For poll */
-		struct {
-			struct pollfd __user *ufds;
-			int nfds;
-			int has_timeout;
-			unsigned long tv_sec;
-			unsigned long tv_nsec;
-		} poll;
-	};
-};
+#include <linux/thread_info-defs.h>
 
 extern long do_no_restart_syscall(struct restart_block *parm);
 
-#include <linux/bitops.h>
 #include <asm/thread_info.h>
+#include <linux/bitops.h>
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/wait-defs.h b/include/linux/wait-defs.h
new file mode 100644
index 0000000..4d0f312
--- /dev/null
+++ b/include/linux/wait-defs.h
@@ -0,0 +1,25 @@
+#ifndef _LINUX_WAIT_DEFS_H
+#define _LINUX_WAIT_DEFS_H
+
+#include <linux/spinlock_types.h>
+#include <linux/list.h>
+
+struct __wait_queue_head {
+	spinlock_t lock;
+	struct list_head task_list;
+};
+typedef struct __wait_queue_head wait_queue_head_t;
+
+typedef struct __wait_queue wait_queue_t;
+
+typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int sync, void *key);
+
+struct __wait_queue {
+	unsigned int flags;
+#define WQ_FLAG_EXCLUSIVE	0x01
+	void *private;
+	wait_queue_func_t func;
+	struct list_head task_list;
+};
+
+#endif /* _LINUX_WAIT_DEFS_H */
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 5d631c1..8848962 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -21,22 +21,10 @@
 
 #include <linux/list.h>
 #include <linux/stddef.h>
-#include <linux/spinlock.h>
+#include <linux/wait-defs.h>
 #include <asm/system.h>
 #include <asm/current.h>
 
-typedef struct __wait_queue wait_queue_t;
-typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int sync, void *key);
-int default_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
-
-struct __wait_queue {
-	unsigned int flags;
-#define WQ_FLAG_EXCLUSIVE	0x01
-	void *private;
-	wait_queue_func_t func;
-	struct list_head task_list;
-};
-
 struct wait_bit_key {
 	void *flags;
 	int bit_nr;
@@ -47,17 +35,12 @@ struct wait_bit_queue {
 	wait_queue_t wait;
 };
 
-struct __wait_queue_head {
-	spinlock_t lock;
-	struct list_head task_list;
-};
-typedef struct __wait_queue_head wait_queue_head_t;
-
 struct task_struct;
 
 /*
  * Macros for declaration and initialisaton of the datatypes
  */
+extern int default_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
 #define __WAITQUEUE_INITIALIZER(name, tsk) {				\
 	.private	= tsk,						\
diff --git a/kernel/module.c b/kernel/module.c
index e797812..f5c238c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -52,6 +52,7 @@
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/percpu.h>
+#include <linux/percpu-alloc.h>
 
 #if 0
 #define DEBUGP printk
diff --git a/kernel/srcu.c b/kernel/srcu.c
index b0aeeaf..8b50f56 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -26,7 +26,7 @@
 
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/percpu.h>
+#include <linux/percpu-alloc.h>
 #include <linux/preempt.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 912823e..067cdf3 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -9,6 +9,7 @@
 #include <linux/stop_machine.h>
 #include <linux/syscalls.h>
 #include <linux/interrupt.h>
+#include <linux/percpu-alloc.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f71fb2a..d607306 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,6 +33,7 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/percpu-alloc.h>
 #include <trace/workqueue.h>
 
 /*
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index aeaa6d7..e72afc7 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/percpu_counter.h>
+#include <linux/percpu-alloc.h>
 #include <linux/notifier.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index a1cbce7..d45b376 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -35,6 +35,7 @@
 #include <linux/random.h>
 #include <linux/string.h>
 #include <linux/log2.h>
+#include <linux/percpu-alloc.h>
 
 #define NEIGH_DEBUG 1
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 7f03373..16572e0 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -86,6 +86,7 @@
 #include <linux/poll.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/random.h>
+#include <linux/percpu-alloc.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>

--=-=-=--
