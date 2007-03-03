Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXCCSDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXCCSDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 13:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030353AbXCCSDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 13:03:22 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4921 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030346AbXCCSDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 13:03:20 -0500
Date: Sat, 3 Mar 2007 18:03:00 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.cm>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-ID: <20070303180300.GA10382@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Roland McGrath <roland@redhat.cm>, linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302110420.GA2824@flint.arm.linux.org.uk> <20070302030833.4aea2574.akpm@linux-foundation.org> <20070302111030.GB2824@flint.arm.linux.org.uk> <20070302031540.6aab5eac.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20070302031540.6aab5eac.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 02, 2007 at 03:15:40AM -0800, Andrew Morton wrote:
> It's a complete rewrite of the ptrace code.  Quite heroic, really.
> 
> Lots of documentation at http://people.redhat.com/roland/utrace/

Here's some comments on it:

1. support for changing the syscall number.  From the changes which
   Roland has done in arch/arm/kernel/ptrace.c, it seems that we are
   no longer allowed to change the syscall number.  Why is this?

   We need to support a special "SET_SYSCALL" call which is passed the
   new syscall number.  This needs to be passed to the child, and
   when the child returns from syscall_trace(), it needs to return this
   new data as the system call number.

2. tracehook_abort_syscall can not be supported on ARM - syscall numbers
   aren't (always) passed through the register set.

3. single step support.  no idea how to do this with utrace; the
   documentation seems to imply that utrace will not support software-
   based single stepping when it involves modifying the text, and that
   it can continue to be supported via the ptrace compatibility.

   Since this is the only way to do single stepping on ARM, this means
   that we need to support ptrace indefinitely.

So, as I see it, supporting utrace on ARM would be a major backwards
step as things stand at the moment - no single stepping, and no ability
to modify syscalls.  Unfortunately, not having the single step ability
makes debugging pretty much useless, so this is something which must
be supported.

Finally, there's quite a bit of cleanup work which needs to be done for
utrace - namely removing all the pesky linux/ptrace.h includes scattered
throughout the tree.  This is by far the biggest problem I've faced in
trying to tackle utrace soo far.

Attached are two patches (yes yes, but they're not for applying, only
for reading - ergo no signoffs).  The first removes a whole wodge of
linux/ptrace.h includes.  The second is the preliminary, completely
untested ARM utrace support - in particular look for the FIXMEs.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="remove-linux_ptrace_h.diff"

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index fe3f059..798bbfc 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/ptrace.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
diff --git a/arch/arm/common/via82c505.c b/arch/arm/common/via82c505.c
index ba2e629..79a8206 100644
--- a/arch/arm/common/via82c505.c
+++ b/arch/arm/common/via82c505.c
@@ -1,6 +1,5 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/ptrace.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/init.h>
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index a72b82e..11dcd52 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -27,7 +27,6 @@
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/smp.h>
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 782af3c..8afd83d 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -16,7 +16,6 @@
 #include <linux/mm.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/a.out.h>
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index ba1c188..6055ab4 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -16,7 +16,6 @@
 #include <linux/signal.h>
 #include <linux/spinlock.h>
 #include <linux/personality.h>
-#include <linux/ptrace.h>
 #include <linux/kallsyms.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index 1463330..d0dc51e 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -10,7 +10,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/ptrace.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
diff --git a/arch/arm/mach-integrator/pci.c b/arch/arm/mach-integrator/pci.c
index 394ec92..af7d3ff 100644
--- a/arch/arm/mach-integrator/pci.c
+++ b/arch/arm/mach-integrator/pci.c
@@ -23,7 +23,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/ptrace.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index fb8c6d9..af9ebcc 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -22,7 +22,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
diff --git a/arch/arm/mach-lh7a40x/irq-lh7a400.c b/arch/arm/mach-lh7a40x/irq-lh7a400.c
index 0b938e8..9472bbe 100644
--- a/arch/arm/mach-lh7a40x/irq-lh7a400.c
+++ b/arch/arm/mach-lh7a40x/irq-lh7a400.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/ptrace.h>
 
 #include <asm/hardware.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-lh7a40x/irq-lh7a404.c b/arch/arm/mach-lh7a40x/irq-lh7a404.c
index 5760f8c..9b28389 100644
--- a/arch/arm/mach-lh7a40x/irq-lh7a404.c
+++ b/arch/arm/mach-lh7a40x/irq-lh7a404.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/ptrace.h>
 
 #include <asm/hardware.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-lh7a40x/irq-lpd7a40x.c b/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
index 15b9577..66e1ed3 100644
--- a/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
+++ b/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/ptrace.h>
 
 #include <asm/hardware.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-omap1/irq.c b/arch/arm/mach-omap1/irq.c
index 6383a12..2015d2c 100644
--- a/arch/arm/mach-omap1/irq.c
+++ b/arch/arm/mach-omap1/irq.c
@@ -40,7 +40,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/ptrace.h>
 
 #include <asm/hardware.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index a302ab0..4619d5f 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
-#include <linux/ptrace.h>
 
 #include <asm/hardware.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-s3c2410/bast-irq.c b/arch/arm/mach-s3c2410/bast-irq.c
index daeba42..76a7cb1 100644
--- a/arch/arm/mach-s3c2410/bast-irq.c
+++ b/arch/arm/mach-s3c2410/bast-irq.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-s3c2410/irq.c b/arch/arm/mach-s3c2410/irq.c
index 53cbdaa..f5c5c53 100644
--- a/arch/arm/mach-s3c2410/irq.c
+++ b/arch/arm/mach-s3c2410/irq.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/plat-s3c24xx/cpu.h>
diff --git a/arch/arm/mach-s3c2412/irq.c b/arch/arm/mach-s3c2412/irq.c
index e89dbdc..f0d6682 100644
--- a/arch/arm/mach-s3c2412/irq.c
+++ b/arch/arm/mach-s3c2412/irq.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/hardware.h>
diff --git a/arch/arm/mach-s3c2440/irq.c b/arch/arm/mach-s3c2440/irq.c
index 1069d13..a87608b 100644
--- a/arch/arm/mach-s3c2440/irq.c
+++ b/arch/arm/mach-s3c2440/irq.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/hardware.h>
diff --git a/arch/arm/mach-s3c2443/irq.c b/arch/arm/mach-s3c2443/irq.c
index 7a45b6d..a5dea6d 100644
--- a/arch/arm/mach-s3c2443/irq.c
+++ b/arch/arm/mach-s3c2443/irq.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/hardware.h>
diff --git a/arch/arm/mach-sa1100/irq.c b/arch/arm/mach-sa1100/irq.c
index 5642aec..edf3347 100644
--- a/arch/arm/mach-sa1100/irq.c
+++ b/arch/arm/mach-sa1100/irq.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/hardware.h>
diff --git a/arch/arm/mach-sa1100/neponset.c b/arch/arm/mach-sa1100/neponset.c
index 075d4d1..d7c038a 100644
--- a/arch/arm/mach-sa1100/neponset.c
+++ b/arch/arm/mach-sa1100/neponset.c
@@ -4,7 +4,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/ptrace.h>
 #include <linux/tty.h>
 #include <linux/ioport.h>
 #include <linux/serial_core.h>
diff --git a/arch/arm/mach-shark/irq.c b/arch/arm/mach-shark/irq.c
index 00a6c14..5b0c6af 100644
--- a/arch/arm/mach-shark/irq.c
+++ b/arch/arm/mach-shark/irq.c
@@ -10,7 +10,6 @@
 
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/ptrace.h>
 #include <linux/interrupt.h>
 
 #include <asm/irq.h>
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 5cd0b5d..ba58223 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -16,7 +16,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/pci.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index aa109f0..19ca333 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -15,7 +15,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/string.h>
-#include <linux/ptrace.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index fa2d107..5d9ce7d 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -10,7 +10,6 @@
  */
 #include <linux/module.h>
 #include <linux/signal.h>
-#include <linux/ptrace.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 7760193..c0ad7c0 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -9,7 +9,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/ptrace.h>
 #include <linux/swap.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 4f2fd55..4ad9cb1 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 #include <linux/err.h>
 #include <linux/clk.h>
diff --git a/arch/arm/plat-s3c24xx/irq.c b/arch/arm/plat-s3c24xx/irq.c
index ce18639..8fbc884 100644
--- a/arch/arm/plat-s3c24xx/irq.c
+++ b/arch/arm/plat-s3c24xx/irq.c
@@ -54,7 +54,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/hardware.h>
diff --git a/arch/arm/plat-s3c24xx/s3c244x-irq.c b/arch/arm/plat-s3c24xx/s3c244x-irq.c
index a0e39d8..2dbb260 100644
--- a/arch/arm/plat-s3c24xx/s3c244x-irq.c
+++ b/arch/arm/plat-s3c24xx/s3c244x-irq.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
-#include <linux/ptrace.h>
 #include <linux/sysdev.h>
 
 #include <asm/hardware.h>
diff --git a/drivers/ide/legacy/ide-cs.c b/drivers/ide/legacy/ide-cs.c
index a5023cd..beceab4 100644
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index c153b64..21458df 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -8,7 +8,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index d88e9b2..accae19 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a8c2bfe..a4f3e59 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -28,7 +28,6 @@
 #include <linux/smp_lock.h>
 
 #include <linux/sched.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index f123553..dbf81c6 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/net/wireless/arlan.h b/drivers/net/wireless/arlan.h
index 3ed1df7..c68215f 100644
--- a/drivers/net/wireless/arlan.h
+++ b/drivers/net/wireless/arlan.h
@@ -10,7 +10,6 @@
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>	/* For the statistics structure. */
 #include <linux/if_arp.h>	/* For ARPHRD_ETHER */
-#include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 23eba69..5bbca6e 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -42,7 +42,6 @@
 #include <linux/init.h>
 
 #include <linux/kernel.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index 12617cd..6d97791 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -35,7 +35,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/netwave_cs.c b/drivers/net/wireless/netwave_cs.c
index a009ab5..f0fbdc3 100644
--- a/drivers/net/wireless/netwave_cs.c
+++ b/drivers/net/wireless/netwave_cs.c
@@ -43,7 +43,6 @@
 #include <linux/types.h>
 #include <linux/fcntl.h>
 #include <linux/interrupt.h>
-#include <linux/ptrace.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
 #include <linux/slab.h>
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 47b2ccb..7071e11 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/net/wireless/wavelan.p.h b/drivers/net/wireless/wavelan.p.h
index fe24281..ff9058e 100644
--- a/drivers/net/wireless/wavelan.p.h
+++ b/drivers/net/wireless/wavelan.p.h
@@ -368,7 +368,6 @@
 #include	<linux/fcntl.h>
 #include	<linux/interrupt.h>
 #include	<linux/stat.h>
-#include	<linux/ptrace.h>
 #include	<linux/ioport.h>
 #include	<linux/in.h>
 #include	<linux/string.h>
diff --git a/drivers/net/wireless/wavelan_cs.p.h b/drivers/net/wireless/wavelan_cs.p.h
index 4d1c490..7411f39 100644
--- a/drivers/net/wireless/wavelan_cs.p.h
+++ b/drivers/net/wireless/wavelan_cs.p.h
@@ -415,7 +415,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sched.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>
diff --git a/drivers/serial/serial_cs.c b/drivers/serial/serial_cs.c
index 6b76bab..a7e7b70 100644
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -35,7 +35,6 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/timer.h>

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="utrace-arm.diff"

diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index bb28087..64072ea 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_PCI)		+= bios32.o isa.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
+obj-$(CONFIG_UTRACE)		+= utrace.o
 
 obj-$(CONFIG_CRUNCH)		+= crunch.o crunch-bits.o
 AFLAGS_crunch-bits.o		:= -Wa,-mcpu=ep9312
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index b145c7e..0eb9478 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
+#include <linux/tracehook.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/security.h>
@@ -26,6 +27,7 @@
 #include <asm/traps.h>
 
 #include "ptrace.h"
+#include "utrace.h"
 
 #define REG_PC	15
 #define REG_PSR	16
@@ -456,14 +458,22 @@ void ptrace_cancel_bpt(struct task_struct *child)
 }
 
 /*
+ * make sure single-step breakpoint is gone.
+ */
+static inline void ptrace_disable_singlestep(struct task_struct *task)
+{
+#if 0
+	task->ptrace &= ~PT_SINGLESTEP;
+	ptrace_cancel_bpt(task);
+#endif
+}
+
+/*
  * Called by kernel/ptrace.c when detaching..
- *
- * Make sure the single step bit is not set.
  */
 void ptrace_disable(struct task_struct *child)
 {
-	child->ptrace &= ~PT_SINGLESTEP;
-	ptrace_cancel_bpt(child);
+	ptrace_disable_singlestep(child);
 }
 
 /*
@@ -514,191 +524,73 @@ static int __init ptrace_break_init(void)
 
 core_initcall(ptrace_break_init);
 
-/*
- * Read the word at offset "off" into the "struct user".  We
- * actually access the pt_regs stored on the kernel stack.
- */
-static int ptrace_read_user(struct task_struct *tsk, unsigned long off,
-			    unsigned long __user *ret)
-{
-	unsigned long tmp;
-
-	if (off & 3 || off >= sizeof(struct user))
-		return -EIO;
-
-	tmp = 0;
-	if (off < sizeof(struct pt_regs))
-		tmp = get_user_reg(tsk, off >> 2);
-
-	return put_user(tmp, ret);
-}
-
-/*
- * Write the word at offset "off" into "struct user".  We
- * actually access the pt_regs stored on the kernel stack.
- */
-static int ptrace_write_user(struct task_struct *tsk, unsigned long off,
-			     unsigned long val)
-{
-	if (off & 3 || off >= sizeof(struct user))
-		return -EIO;
-
-	if (off >= sizeof(struct pt_regs))
-		return 0;
-
-	return put_user_reg(tsk, off >> 2, val);
-}
-
-/*
- * Get all user integer registers.
- */
-static int ptrace_getregs(struct task_struct *tsk, void __user *uregs)
-{
-	struct pt_regs *regs = task_pt_regs(tsk);
-
-	return copy_to_user(uregs, regs, sizeof(struct pt_regs)) ? -EFAULT : 0;
-}
+static const struct ptrace_layout_segment arm_uarea[] = {
+	{
+		.start	= 0,
+		.end	= sizeof(struct pt_regs),
+		.regset	= REGSET_ARM,
+		.offset	= 0,
+	},
+	{
+		.start	= 0,
+		.end	= 0,
+		.regset	= -1,
+		.offset	= 0,
+	}
+};
 
-/*
- * Set all user integer registers.
- */
-static int ptrace_setregs(struct task_struct *tsk, void __user *uregs)
+int arch_ptrace(long *req, struct task_struct *child,
+		struct utrace_attached_engine *engine,
+		unsigned long addr, unsigned long data, long *val)
 {
-	struct pt_regs newregs;
+	long request = *req;
 	int ret;
 
-	ret = -EFAULT;
-	if (copy_from_user(&newregs, uregs, sizeof(struct pt_regs)) == 0) {
-		struct pt_regs *regs = task_pt_regs(tsk);
-
-		ret = -EINVAL;
-		if (valid_user_regs(&newregs)) {
-			*regs = newregs;
-			ret = 0;
-		}
-	}
-
-	return ret;
-}
+	switch (request) {
+	case PTRACE_PEEKUSR:
+		ret = ptrace_peekusr(child, engine, arm_uarea, addr, data);
+		break;
+	case PTRACE_POKEUSR:
+		ret = ptrace_pokeusr(child, engine, arm_uarea, addr, data);
+		break;
 
-/*
- * Get the child FPU state.
- */
-static int ptrace_getfpregs(struct task_struct *tsk, void __user *ufp)
-{
-	return copy_to_user(ufp, &task_thread_info(tsk)->fpstate,
-			    sizeof(struct user_fp)) ? -EFAULT : 0;
-}
+	case PTRACE_GETREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_ARM, 0);
+		break;
+	case PTRACE_SETREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_ARM, 1);
+		break;
 
-/*
- * Set the child FPU state.
- */
-static int ptrace_setfpregs(struct task_struct *tsk, void __user *ufp)
-{
-	struct thread_info *thread = task_thread_info(tsk);
-	thread->used_cp[1] = thread->used_cp[2] = 1;
-	return copy_from_user(&thread->fpstate, ufp,
-			      sizeof(struct user_fp)) ? -EFAULT : 0;
-}
+	case PTRACE_GETFPREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_FPA, 0);
+		break;
+	case PTRACE_SETFPREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_FPA, 1);
+		break;
 
 #ifdef CONFIG_IWMMXT
-
-/*
- * Get the child iWMMXt state.
- */
-static int ptrace_getwmmxregs(struct task_struct *tsk, void __user *ufp)
-{
-	struct thread_info *thread = task_thread_info(tsk);
-
-	if (!test_ti_thread_flag(thread, TIF_USING_IWMMXT))
-		return -ENODATA;
-	iwmmxt_task_disable(thread);  /* force it to ram */
-	return copy_to_user(ufp, &thread->fpstate.iwmmxt, IWMMXT_SIZE)
-		? -EFAULT : 0;
-}
-
-/*
- * Set the child iWMMXt state.
- */
-static int ptrace_setwmmxregs(struct task_struct *tsk, void __user *ufp)
-{
-	struct thread_info *thread = task_thread_info(tsk);
-
-	if (!test_ti_thread_flag(thread, TIF_USING_IWMMXT))
-		return -EACCES;
-	iwmmxt_task_release(thread);  /* force a reload */
-	return copy_from_user(&thread->fpstate.iwmmxt, ufp, IWMMXT_SIZE)
-		? -EFAULT : 0;
-}
-
+	case PTRACE_GETWMMXREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_IWMMXT, 0);
+		break;
+	case PTRACE_SETWMMXREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_IWMMXT, 1);
+		break;
 #endif
-
 #ifdef CONFIG_CRUNCH
-/*
- * Get the child Crunch state.
- */
-static int ptrace_getcrunchregs(struct task_struct *tsk, void __user *ufp)
-{
-	struct thread_info *thread = task_thread_info(tsk);
-
-	crunch_task_disable(thread);  /* force it to ram */
-	return copy_to_user(ufp, &thread->crunchstate, CRUNCH_SIZE)
-		? -EFAULT : 0;
-}
-
-/*
- * Set the child Crunch state.
- */
-static int ptrace_setcrunchregs(struct task_struct *tsk, void __user *ufp)
-{
-	struct thread_info *thread = task_thread_info(tsk);
-
-	crunch_task_release(thread);  /* force a reload */
-	return copy_from_user(&thread->crunchstate, ufp, CRUNCH_SIZE)
-		? -EFAULT : 0;
-}
+	case PTRACE_GETCRUNCHREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_CRUNCH, 0);
+		break;
+	case PTRACE_SETCRUNCHREGS:
+		ret = ptrace_whole_regset(child, engine, data, REGSET_CRUNCH, 1);
+		break;
 #endif
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
-{
-	unsigned long tmp;
-	int ret;
-
-	switch (request) {
-		/*
-		 * read word at location "addr" in the child process.
-		 */
-		case PTRACE_PEEKTEXT:
-		case PTRACE_PEEKDATA:
-			ret = access_process_vm(child, addr, &tmp,
-						sizeof(unsigned long), 0);
-			if (ret == sizeof(unsigned long))
-				ret = put_user(tmp, (unsigned long __user *) data);
-			else
-				ret = -EIO;
-			break;
-
-		case PTRACE_PEEKUSR:
-			ret = ptrace_read_user(child, addr, (unsigned long __user *)data);
-			break;
-
-		/*
-		 * write the word at location addr.
-		 */
-		case PTRACE_POKETEXT:
-		case PTRACE_POKEDATA:
-			ret = access_process_vm(child, addr, &data,
-						sizeof(unsigned long), 1);
-			if (ret == sizeof(unsigned long))
-				ret = 0;
-			else
-				ret = -EIO;
-			break;
-
-		case PTRACE_POKEUSR:
-			ret = ptrace_write_user(child, addr, data);
-			break;
+	case PTRACE_GET_THREAD_AREA:
+		ret = put_user(task_thread_info(child)->tp_value,
+			       (unsigned long __user *) data);
+		break;
 
+#if 0
 		/*
 		 * continue/restart and stop at next (return from) syscall
 		 */
@@ -712,9 +604,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			else
 				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 			child->exit_code = data;
-			/* make sure single-step breakpoint is gone. */
-			child->ptrace &= ~PT_SINGLESTEP;
-			ptrace_cancel_bpt(child);
+			ptrace_disable_singlestep(child);
 			wake_up_process(child);
 			ret = 0;
 			break;
@@ -725,9 +615,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		 * exit.
 		 */
 		case PTRACE_KILL:
-			/* make sure single-step breakpoint is gone. */
-			child->ptrace &= ~PT_SINGLESTEP;
-			ptrace_cancel_bpt(child);
+			ptrace_disable_singlestep(child);
 			if (child->exit_state != EXIT_ZOMBIE) {
 				child->exit_code = SIGKILL;
 				wake_up_process(child);
@@ -750,59 +638,16 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			ret = 0;
 			break;
 
-		case PTRACE_DETACH:
-			ret = ptrace_detach(child, data);
-			break;
-
-		case PTRACE_GETREGS:
-			ret = ptrace_getregs(child, (void __user *)data);
-			break;
-
-		case PTRACE_SETREGS:
-			ret = ptrace_setregs(child, (void __user *)data);
-			break;
-
-		case PTRACE_GETFPREGS:
-			ret = ptrace_getfpregs(child, (void __user *)data);
-			break;
-		
-		case PTRACE_SETFPREGS:
-			ret = ptrace_setfpregs(child, (void __user *)data);
-			break;
-
-#ifdef CONFIG_IWMMXT
-		case PTRACE_GETWMMXREGS:
-			ret = ptrace_getwmmxregs(child, (void __user *)data);
-			break;
-
-		case PTRACE_SETWMMXREGS:
-			ret = ptrace_setwmmxregs(child, (void __user *)data);
-			break;
-#endif
-
-		case PTRACE_GET_THREAD_AREA:
-			ret = put_user(task_thread_info(child)->tp_value,
-				       (unsigned long __user *) data);
-			break;
-
-		case PTRACE_SET_SYSCALL:
-			ret = 0;
-			child->ptrace_message = data;
-			break;
-
-#ifdef CONFIG_CRUNCH
-		case PTRACE_GETCRUNCHREGS:
-			ret = ptrace_getcrunchregs(child, (void __user *)data);
-			break;
-
-		case PTRACE_SETCRUNCHREGS:
-			ret = ptrace_setcrunchregs(child, (void __user *)data);
-			break;
+	/* FIXME: Sorry, utrace can't support this */
+	case PTRACE_SET_SYSCALL:
+		ret = 0;
+		child->ptrace_message = data;
+		break;
 #endif
 
-		default:
-			ret = ptrace_request(child, request, addr, data);
-			break;
+	default:
+		ret = -ENOSYS;
+		break;
 	}
 
 	return ret;
@@ -820,7 +665,13 @@ asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 		ip = regs->ARM_ip;
 		regs->ARM_ip = why;
 
+		/*
+		 * FIXME: Save scno so arch_ptrace can change the system call number
+		 */
 		tracehook_report_syscall(regs, why);
+		/*
+		 * FIXME: Set scno from something to indicate the new syscall number
+		 */
 
 		regs->ARM_ip = ip;
 	}
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 3843d3b..cd5c584 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -9,7 +9,9 @@
  */
 #include <linux/errno.h>
 #include <linux/signal.h>
+#include <linux/sched.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/personality.h>
 #include <linux/freezer.h>
 
@@ -262,6 +264,33 @@ static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 	return err;
 }
 
+static inline void single_step_trap(struct task_struct *task)
+{
+#if 0
+	/* Send SIGTRAP if we're single-stepping */
+	if (task->ptrace & PT_SINGLESTEP) {
+		ptrace_cancel_bpt(task);
+		send_sig(SIGTRAP, task, 1);
+	}
+#endif
+}
+
+static inline void single_step_clear(struct task_struct *task)
+{
+#if 0
+	if (task->ptrace & PT_SINGLESTEP)
+		ptrace_cancel_bpt(task);
+#endif
+}
+
+static inline void single_step_set(struct task_struct *task)
+{
+#if 0
+	if (task->ptrace & PT_SINGLESTEP)
+		ptrace_set_bpt(task);
+#endif
+}
+
 asmlinkage int sys_sigreturn(struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
@@ -285,11 +314,7 @@ asmlinkage int sys_sigreturn(struct pt_regs *regs)
 	if (restore_sigframe(regs, frame))
 		goto badframe;
 
-	/* Send SIGTRAP if we're single-stepping */
-	if (current->ptrace & PT_SINGLESTEP) {
-		ptrace_cancel_bpt(current);
-		send_sig(SIGTRAP, current, 1);
-	}
+	single_step_trap(current);
 
 	return regs->ARM_r0;
 
@@ -324,11 +349,7 @@ asmlinkage int sys_rt_sigreturn(struct pt_regs *regs)
 	if (do_sigaltstack(&frame->sig.uc.uc_stack, NULL, regs->ARM_sp) == -EFAULT)
 		goto badframe;
 
-	/* Send SIGTRAP if we're single-stepping */
-	if (current->ptrace & PT_SINGLESTEP) {
-		ptrace_cancel_bpt(current);
-		send_sig(SIGTRAP, current, 1);
-	}
+	single_step_trap(current);
 
 	return regs->ARM_r0;
 
@@ -615,6 +636,8 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
 	recalc_sigpending();
 	spin_unlock_irq(&tsk->sighand->siglock);
 
+	tracehook_report_handle_signal(sig, ka, oldset, regs);
+	single_step_set(tsk);
 }
 
 /*
@@ -644,14 +667,11 @@ static int do_signal(sigset_t *oldset, struct pt_regs *regs, int syscall)
 	if (try_to_freeze())
 		goto no_signal;
 
-	if (current->ptrace & PT_SINGLESTEP)
-		ptrace_cancel_bpt(current);
+	single_step_clear(current);
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		handle_signal(signr, &ka, &info, oldset, regs, syscall);
-		if (current->ptrace & PT_SINGLESTEP)
-			ptrace_set_bpt(current);
 		return 1;
 	}
 
@@ -705,8 +725,7 @@ static int do_signal(sigset_t *oldset, struct pt_regs *regs, int syscall)
 			restart_syscall(regs);
 		}
 	}
-	if (current->ptrace & PT_SINGLESTEP)
-		ptrace_set_bpt(current);
+	single_step_set(current);
 	return 0;
 }
 
--- /dev/null	2007-03-03 11:02:56.785804854 +0000
+++ b/arch/arm/kernel/utrace.c	2007-03-03 17:21:14.000000000 +0000
@@ -0,0 +1,151 @@
+#include <linux/module.h>
+#include <linux/tracehook.h>
+#include <linux/sched.h>
+
+#include "utrace.h"
+
+static int
+getregs_arm(struct task_struct *task, const struct utrace_regset *set,
+	    unsigned int pos, unsigned int count, void *kbuf, void __user *ubuf)
+{
+	void *regs = task_pt_regs(task)->uregs;
+	return utrace_regset_copyout(&pos, &count, &kbuf, &ubuf, regs, 0, -1);
+}
+
+static int
+setregs_arm(struct task_struct *task, const struct utrace_regset *set,
+	    unsigned int pos, unsigned int count, const void *kbuf,
+	    const void __user *ubuf)
+{
+	struct pt_regs newregs, *regs = task_pt_regs(task);
+	int ret;
+
+	newregs = *regs;
+	ret = utrace_regset_copyin(&pos, &count, &kbuf, &ubuf, newregs.uregs,
+				   0, -1);
+	if (ret >= 0) {
+		if (valid_user_regs(&newregs))
+			*regs = newregs;
+		else
+			ret = -EINVAL;
+	}
+	return ret;
+}
+
+static int
+getregs_fpa(struct task_struct *task, const struct utrace_regset *set,
+	    unsigned int pos, unsigned int count, void *kbuf, void __user *ubuf)
+{
+	struct thread_info *thread = task_thread_info(task);
+	return utrace_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&thread->fpstate, 0, -1);
+}
+
+static int
+setregs_fpa(struct task_struct *task, const struct utrace_regset *set,
+	    unsigned int pos, unsigned int count, const void *kbuf,
+	    const void __user *ubuf)
+{
+	struct thread_info *thread = task_thread_info(task);
+	thread->used_cp[1] = thread->used_cp[2] = 1;
+	return utrace_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&thread->fpstate, 0, -1);
+}
+
+#ifdef CONFIG_IWMMXT
+static int
+getregs_iwmmxt(struct task_struct *task, const struct utrace_regset *set,
+	       unsigned int pos, unsigned int count, void *kbuf,
+	       void __user *ubuf)
+{
+	struct thread_info *thread = task_thread_info(task);
+
+	if (!test_ti_thread_flag(thread, TIF_USING_IWMMXT))
+		return 0;
+
+	iwmmxt_task_disable(thread);	/* force it to ram */
+	return utrace_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&thread->fpstate.iwmmxt, 0, -1);
+}
+
+static int
+setregs_iwmmxt(struct task_struct *task, const struct utrace_regset *set,
+	       unsigned int pos, unsigned int count, const void *kbuf,
+	       const void __user *ubuf)
+{
+	struct thread_info *thread = task_thread_info(task);
+
+	if (!test_ti_thread_flag(thread, TIF_USING_IWMMXT))
+		return 0;
+
+	iwmmxt_task_release(thread);	/* force a reload */
+	return utrace_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&thread->crunchstate, 0, -1);
+}
+#endif
+
+#ifdef CONFIG_CRUNCH
+static int
+getregs_fpa(struct task_struct *task, const struct utrace_regset *set,
+	    unsigned int pos, unsigned int count, void *kbuf, void __user *ubuf)
+{
+	struct thread_info *thread = task_thread_info(task);
+	crunch_task_disable(thread);
+	return utrace_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				&thread->crunchstate, 0, -1);
+}
+
+static int
+setregs_fpa(struct task_struct *task, const struct utrace_regset *set,
+	    unsigned int pos, unsigned int count, const void *kbuf,
+	    const void __user *ubuf)
+{
+	struct thread_info *thread = task_thread_info(task);
+	crunch_task_release(thread);
+	return utrace_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				&thread->crunchstate, 0, -1);
+}
+#endif
+
+static const struct utrace_regset native_regsets[] = {
+	[REGSET_ARM] = {
+		.n	= sizeof(struct pt_regs) / sizeof(u32),
+		.size	= sizeof(u32),
+		.align	= sizeof(u32),
+		.get	= getregs_arm,
+		.set	= setregs_arm,
+	},
+	[REGSET_FPA] = {
+		.n	= sizeof(struct user_fp),
+		.size	= sizeof(u8),
+		.align	= sizeof(u32),
+		.get	= getregs_fpa,
+		.set	= setregs_fpa,
+	},
+#ifdef CONFIG_IWMMXT
+	[REGSET_IWMMX] = {
+		.n	= IWMMXT_SIZE,
+		.size	= sizeof(u8),
+		.align	= sizeof(u32),
+		.get	= getregs_iwmmxt,
+		.set	= setregs_iwmmxt,
+	},
+#endif
+#ifdef CONFIG_CRUNCH
+	[REGSET_CRUNCH] = {
+		.n	= CRUNCH_SIZE,
+		.size	= sizeof(u8),
+		.align	= sizeof(u32),
+		.get	= getregs_crunch,
+		.set	= setregs_crunch,
+	},
+#endif
+};
+
+const struct utrace_regset_view utrace_arm_native = {
+	.name		= "arm",
+	.e_machine	= EM_ARM,
+	.regsets	= native_regsets,
+	.n		= ARRAY_SIZE(native_regsets),
+};
+EXPORT_SYMBOL_GPL(utrace_arm_native);
--- /dev/null	2007-03-03 11:02:56.785804854 +0000
+++ b/arch/arm/kernel/utrace.h	2007-03-03 16:42:49.000000000 +0000
@@ -0,0 +1,4 @@
+#define REGSET_ARM	0
+#define REGSET_FPA	1
+#define REGSET_IWMMX	2
+#define REGSET_CRUNCH	3
--- /dev/null	2007-03-03 11:02:56.785804854 +0000
+++ b/include/asm-arm/tracehook.h	2007-03-03 17:41:21.000000000 +0000
@@ -0,0 +1,26 @@
+#ifndef ASMARM_TRACEHOOK_H
+#define ASMARM_TRACEHOOK_H
+
+static inline void tracehook_enable_syscall_trace(struct task_struct *task)
+{
+	set_tsk_thread_flag(task, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_disable_syscall_trace(struct task_struct *task)
+{
+	clear_tsk_thread_flag(task, TIF_SYSCALL_TRACE);
+}
+
+static inline void tracehook_abort_syscall(struct pt_regs *regs)
+{
+	/* FIXME: Sorry, ARM can't support this */
+}
+
+static inline const
+struct utrace_regset_view *utrace_native_view(struct task_struct *task)
+{
+	extern const struct utrace_regset_view utrace_arm_native;
+	return &utrace_arm_native;
+}
+
+#endif

--y0ulUmNC+osPPQO6--
