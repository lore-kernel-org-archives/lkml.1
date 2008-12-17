Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752158AbYLQRDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYLQRDY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYLQRDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:03:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49644 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYLQRDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:03:00 -0500
Date: Wed, 17 Dec 2008 17:02:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, geert@linux-m68k.org, dhowells@redhat.com,
        gerg@uclinux.org
Subject: Re: [PATCH] get rid of the last symlink in uml build
Message-ID: <20081217170257.GE28946@ZenIV.linux.org.uk>
References: <20081217061250.GX28946@ZenIV.linux.org.uk> <20081217072620.GA3551@uranus.ravnborg.org> <20081217083734.GA28946@ZenIV.linux.org.uk> <20081217085539.GA4152@uranus.ravnborg.org> <20081217091058.GB28946@ZenIV.linux.org.uk> <20081217112723.GA5027@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217112723.GA5027@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	BTW, after taking a look at the remaing asm-*...

* frv, m32r and h8300 should be as trivial as git mv
* m68k has a bit of extra PITA - we need to clean up two non-trivial
  includes from m68knommu (pci.h and setup.h) first, then it's a matter
  of git mv, adding arch/m68k/include to search path on m68knommu and
  removal of dummy headers from the latter.
* xtensa is already moved in linux-next
* arm seems to be lacking the final push for few remaining headers; presumably
  will happen eventually
* mn10300 is playing with symlinks - the last one to do that for headers,
  AFAICS.

I've thrown together a patch series on top of linux-next doing m68k and
mn10300.  *WARNING* - it's completely untested, basically about half an
hour diversion from sifting through the mailbox for missed VFS patches.
And that half and hour did *not* include anything resembling building
the resulting tree.  So take that with a trainload of salt.

Patches (in mbox format; easier to deal with for massive moves) follow.
Have fun.  If that actually works and if frv/m32r/h8300 are as trivial
as they seem to be, we should be able to get it down to include/asm-arm
remnants and nothing else.

			Al, disappearing back into the VFS slush pile...

>From 1f9c061a93d36ca999981c337871173b13b420a9 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 17 Dec 2008 11:32:23 -0500
Subject: [PATCH] preparation to m68k header move

sort out two non-trivial include from m68knommu to m68k headers

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68knommu/include/asm/pci.h   |    8 +++++++-
 arch/m68knommu/include/asm/setup.h |    9 ---------
 include/asm-m68k/setup.h           |    4 ++++
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/m68knommu/include/asm/pci.h b/arch/m68knommu/include/asm/pci.h
index a13f3cc..ad8bd5e 100644
--- a/arch/m68knommu/include/asm/pci.h
+++ b/arch/m68knommu/include/asm/pci.h
@@ -1,7 +1,13 @@
 #ifndef M68KNOMMU_PCI_H
 #define	M68KNOMMU_PCI_H
 
-#include <asm-m68k/pci.h>
+#include <asm-generic/pci-dma-compat.h>
+
+/* The PCI address space does equal the physical memory
+ * address space.  The networking and block device layers use
+ * this boolean for bounce buffer decisions.
+ */
+#define PCI_DMA_BUS_IS_PHYS	(1)
 
 #ifdef CONFIG_COMEMPCI
 /*
diff --git a/arch/m68knommu/include/asm/setup.h b/arch/m68knommu/include/asm/setup.h
index fb86bb2..ff4565e 100644
--- a/arch/m68knommu/include/asm/setup.h
+++ b/arch/m68knommu/include/asm/setup.h
@@ -1,10 +1 @@
-#ifdef __KERNEL__
-
 #include <asm-m68k/setup.h>
-
-/* We have a bigger command line buffer. */
-#undef COMMAND_LINE_SIZE
-
-#endif  /*  __KERNEL__  */
-
-#define COMMAND_LINE_SIZE	512
diff --git a/include/asm-m68k/setup.h b/include/asm-m68k/setup.h
index 4dfb395..1029d59 100644
--- a/include/asm-m68k/setup.h
+++ b/include/asm-m68k/setup.h
@@ -41,7 +41,11 @@
 #define MACH_Q40     10
 #define MACH_SUN3X   11
 
+#ifdef CONFIG_MMU
 #define COMMAND_LINE_SIZE 256
+#else
+#define COMMAND_LINE_SIZE 512
+#endif
 
 #ifdef __KERNEL__
 
-- 
1.5.6.5


>From 98f1fb88e6984ebfc6a151f41b8db78e7db0f1e0 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 17 Dec 2008 11:38:53 -0500
Subject: [PATCH] move m68k headers

move m68k headers, tell m68knommu to add arch/m68k/include to its
search path and kill the files in arch/m68knommu/include/asm that
become useless after that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 {include => arch/m68k/include}/asm-m68k/Kbuild     |    0 
 .../m68k/include}/asm-m68k/a.out-core.h            |    0 
 {include => arch/m68k/include}/asm-m68k/a.out.h    |    0 
 {include => arch/m68k/include}/asm-m68k/adb_iop.h  |    0 
 {include => arch/m68k/include}/asm-m68k/amigahw.h  |    0 
 .../m68k/include}/asm-m68k/amigaints.h             |    0 
 {include => arch/m68k/include}/asm-m68k/amigayle.h |    0 
 .../m68k/include}/asm-m68k/amipcmcia.h             |    0 
 .../m68k/include}/asm-m68k/apollodma.h             |    0 
 {include => arch/m68k/include}/asm-m68k/apollohw.h |    0 
 {include => arch/m68k/include}/asm-m68k/atafd.h    |    0 
 {include => arch/m68k/include}/asm-m68k/atafdreg.h |    0 
 .../m68k/include}/asm-m68k/atari_joystick.h        |    0 
 .../m68k/include}/asm-m68k/atari_stdma.h           |    0 
 .../m68k/include}/asm-m68k/atari_stram.h           |    0 
 {include => arch/m68k/include}/asm-m68k/atarihw.h  |    0 
 .../m68k/include}/asm-m68k/atariints.h             |    0 
 {include => arch/m68k/include}/asm-m68k/atarikb.h  |    0 
 {include => arch/m68k/include}/asm-m68k/atomic.h   |    0 
 {include => arch/m68k/include}/asm-m68k/auxvec.h   |    0 
 {include => arch/m68k/include}/asm-m68k/bitops.h   |    0 
 {include => arch/m68k/include}/asm-m68k/blinken.h  |    0 
 {include => arch/m68k/include}/asm-m68k/bootinfo.h |    0 
 {include => arch/m68k/include}/asm-m68k/bug.h      |    0 
 {include => arch/m68k/include}/asm-m68k/bugs.h     |    0 
 .../m68k/include}/asm-m68k/bvme6000hw.h            |    0 
 .../m68k/include}/asm-m68k/byteorder.h             |    0 
 {include => arch/m68k/include}/asm-m68k/cache.h    |    0 
 {include => arch/m68k/include}/asm-m68k/cachectl.h |    0 
 .../m68k/include}/asm-m68k/cacheflush.h            |    0 
 {include => arch/m68k/include}/asm-m68k/checksum.h |    0 
 {include => arch/m68k/include}/asm-m68k/contregs.h |    0 
 {include => arch/m68k/include}/asm-m68k/cputime.h  |    0 
 {include => arch/m68k/include}/asm-m68k/current.h  |    0 
 {include => arch/m68k/include}/asm-m68k/delay.h    |    0 
 {include => arch/m68k/include}/asm-m68k/device.h   |    0 
 {include => arch/m68k/include}/asm-m68k/div64.h    |    0 
 .../m68k/include}/asm-m68k/dma-mapping.h           |    0 
 {include => arch/m68k/include}/asm-m68k/dma.h      |    0 
 {include => arch/m68k/include}/asm-m68k/dsp56k.h   |    0 
 {include => arch/m68k/include}/asm-m68k/dvma.h     |    0 
 {include => arch/m68k/include}/asm-m68k/elf.h      |    0 
 .../m68k/include}/asm-m68k/emergency-restart.h     |    0 
 {include => arch/m68k/include}/asm-m68k/entry.h    |    0 
 {include => arch/m68k/include}/asm-m68k/errno.h    |    0 
 {include => arch/m68k/include}/asm-m68k/fb.h       |    0 
 {include => arch/m68k/include}/asm-m68k/fbio.h     |    0 
 {include => arch/m68k/include}/asm-m68k/fcntl.h    |    0 
 {include => arch/m68k/include}/asm-m68k/floppy.h   |    0 
 {include => arch/m68k/include}/asm-m68k/fpu.h      |    0 
 {include => arch/m68k/include}/asm-m68k/futex.h    |    0 
 {include => arch/m68k/include}/asm-m68k/hardirq.h  |    0 
 {include => arch/m68k/include}/asm-m68k/hp300hw.h  |    0 
 {include => arch/m68k/include}/asm-m68k/hw_irq.h   |    0 
 {include => arch/m68k/include}/asm-m68k/hwtest.h   |    0 
 {include => arch/m68k/include}/asm-m68k/ide.h      |    0 
 {include => arch/m68k/include}/asm-m68k/idprom.h   |    0 
 {include => arch/m68k/include}/asm-m68k/intersil.h |    0 
 {include => arch/m68k/include}/asm-m68k/io.h       |    0 
 {include => arch/m68k/include}/asm-m68k/ioctl.h    |    0 
 {include => arch/m68k/include}/asm-m68k/ioctls.h   |    0 
 {include => arch/m68k/include}/asm-m68k/ipcbuf.h   |    0 
 {include => arch/m68k/include}/asm-m68k/irq.h      |    0 
 {include => arch/m68k/include}/asm-m68k/irq_regs.h |    0 
 {include => arch/m68k/include}/asm-m68k/kdebug.h   |    0 
 .../m68k/include}/asm-m68k/kmap_types.h            |    0 
 {include => arch/m68k/include}/asm-m68k/linkage.h  |    0 
 {include => arch/m68k/include}/asm-m68k/local.h    |    0 
 {include => arch/m68k/include}/asm-m68k/mac_asc.h  |    0 
 .../m68k/include}/asm-m68k/mac_baboon.h            |    0 
 {include => arch/m68k/include}/asm-m68k/mac_iop.h  |    0 
 .../m68k/include}/asm-m68k/mac_mouse.h             |    0 
 {include => arch/m68k/include}/asm-m68k/mac_oss.h  |    0 
 {include => arch/m68k/include}/asm-m68k/mac_psc.h  |    0 
 {include => arch/m68k/include}/asm-m68k/mac_via.h  |    0 
 {include => arch/m68k/include}/asm-m68k/machdep.h  |    0 
 {include => arch/m68k/include}/asm-m68k/machines.h |    0 
 {include => arch/m68k/include}/asm-m68k/machw.h    |    0 
 .../m68k/include}/asm-m68k/macintosh.h             |    0 
 {include => arch/m68k/include}/asm-m68k/macints.h  |    0 
 {include => arch/m68k/include}/asm-m68k/math-emu.h |    0 
 .../m68k/include}/asm-m68k/mc146818rtc.h           |    0 
 {include => arch/m68k/include}/asm-m68k/md.h       |    0 
 {include => arch/m68k/include}/asm-m68k/mman.h     |    0 
 {include => arch/m68k/include}/asm-m68k/mmu.h      |    0 
 .../m68k/include}/asm-m68k/mmu_context.h           |    0 
 {include => arch/m68k/include}/asm-m68k/mmzone.h   |    0 
 {include => arch/m68k/include}/asm-m68k/module.h   |    0 
 .../m68k/include}/asm-m68k/motorola_pgalloc.h      |    0 
 .../m68k/include}/asm-m68k/motorola_pgtable.h      |    0 
 {include => arch/m68k/include}/asm-m68k/movs.h     |    0 
 {include => arch/m68k/include}/asm-m68k/msgbuf.h   |    0 
 {include => arch/m68k/include}/asm-m68k/mutex.h    |    0 
 .../m68k/include}/asm-m68k/mvme147hw.h             |    0 
 .../m68k/include}/asm-m68k/mvme16xhw.h             |    0 
 {include => arch/m68k/include}/asm-m68k/nubus.h    |    0 
 {include => arch/m68k/include}/asm-m68k/openprom.h |    0 
 {include => arch/m68k/include}/asm-m68k/oplib.h    |    0 
 {include => arch/m68k/include}/asm-m68k/page.h     |    0 
 .../m68k/include}/asm-m68k/page_offset.h           |    0 
 {include => arch/m68k/include}/asm-m68k/param.h    |    0 
 {include => arch/m68k/include}/asm-m68k/parport.h  |    0 
 {include => arch/m68k/include}/asm-m68k/pci.h      |    0 
 {include => arch/m68k/include}/asm-m68k/percpu.h   |    0 
 {include => arch/m68k/include}/asm-m68k/pgalloc.h  |    0 
 {include => arch/m68k/include}/asm-m68k/pgtable.h  |    0 
 {include => arch/m68k/include}/asm-m68k/poll.h     |    0 
 .../m68k/include}/asm-m68k/posix_types.h           |    0 
 .../m68k/include}/asm-m68k/processor.h             |    0 
 {include => arch/m68k/include}/asm-m68k/ptrace.h   |    0 
 .../m68k/include}/asm-m68k/q40_master.h            |    0 
 {include => arch/m68k/include}/asm-m68k/q40ints.h  |    0 
 {include => arch/m68k/include}/asm-m68k/raw_io.h   |    0 
 {include => arch/m68k/include}/asm-m68k/resource.h |    0 
 {include => arch/m68k/include}/asm-m68k/rtc.h      |    0 
 {include => arch/m68k/include}/asm-m68k/sbus.h     |    0 
 .../m68k/include}/asm-m68k/scatterlist.h           |    0 
 {include => arch/m68k/include}/asm-m68k/sections.h |    0 
 {include => arch/m68k/include}/asm-m68k/segment.h  |    0 
 {include => arch/m68k/include}/asm-m68k/sembuf.h   |    0 
 {include => arch/m68k/include}/asm-m68k/serial.h   |    0 
 {include => arch/m68k/include}/asm-m68k/setup.h    |    0 
 {include => arch/m68k/include}/asm-m68k/shm.h      |    0 
 {include => arch/m68k/include}/asm-m68k/shmbuf.h   |    0 
 {include => arch/m68k/include}/asm-m68k/shmparam.h |    0 
 .../m68k/include}/asm-m68k/sigcontext.h            |    0 
 {include => arch/m68k/include}/asm-m68k/siginfo.h  |    0 
 {include => arch/m68k/include}/asm-m68k/signal.h   |    0 
 {include => arch/m68k/include}/asm-m68k/socket.h   |    0 
 {include => arch/m68k/include}/asm-m68k/sockios.h  |    0 
 {include => arch/m68k/include}/asm-m68k/spinlock.h |    0 
 {include => arch/m68k/include}/asm-m68k/stat.h     |    0 
 {include => arch/m68k/include}/asm-m68k/statfs.h   |    0 
 {include => arch/m68k/include}/asm-m68k/string.h   |    0 
 .../m68k/include}/asm-m68k/sun3-head.h             |    0 
 .../m68k/include}/asm-m68k/sun3_pgalloc.h          |    0 
 .../m68k/include}/asm-m68k/sun3_pgtable.h          |    0 
 {include => arch/m68k/include}/asm-m68k/sun3ints.h |    0 
 {include => arch/m68k/include}/asm-m68k/sun3mmu.h  |    0 
 {include => arch/m68k/include}/asm-m68k/sun3x.h    |    0 
 .../m68k/include}/asm-m68k/sun3xflop.h             |    0 
 .../m68k/include}/asm-m68k/sun3xprom.h             |    0 
 {include => arch/m68k/include}/asm-m68k/suspend.h  |    0 
 {include => arch/m68k/include}/asm-m68k/system.h   |    0 
 {include => arch/m68k/include}/asm-m68k/termbits.h |    0 
 {include => arch/m68k/include}/asm-m68k/termios.h  |    0 
 .../m68k/include}/asm-m68k/thread_info.h           |    0 
 {include => arch/m68k/include}/asm-m68k/timex.h    |    0 
 {include => arch/m68k/include}/asm-m68k/tlb.h      |    0 
 {include => arch/m68k/include}/asm-m68k/tlbflush.h |    0 
 {include => arch/m68k/include}/asm-m68k/topology.h |    0 
 {include => arch/m68k/include}/asm-m68k/traps.h    |    0 
 {include => arch/m68k/include}/asm-m68k/types.h    |    0 
 {include => arch/m68k/include}/asm-m68k/uaccess.h  |    0 
 {include => arch/m68k/include}/asm-m68k/ucontext.h |    0 
 .../m68k/include}/asm-m68k/unaligned.h             |    0 
 {include => arch/m68k/include}/asm-m68k/unistd.h   |    0 
 {include => arch/m68k/include}/asm-m68k/user.h     |    0 
 .../m68k/include}/asm-m68k/virtconvert.h           |    0 
 {include => arch/m68k/include}/asm-m68k/xor.h      |    0 
 {include => arch/m68k/include}/asm-m68k/zorro.h    |    0 
 arch/m68knommu/Makefile                            |    2 ++
 arch/m68knommu/include/asm/cachectl.h              |    1 -
 arch/m68knommu/include/asm/errno.h                 |    1 -
 arch/m68knommu/include/asm/fcntl.h                 |    1 -
 arch/m68knommu/include/asm/hwtest.h                |    1 -
 arch/m68knommu/include/asm/ioctls.h                |    1 -
 arch/m68knommu/include/asm/ipcbuf.h                |    1 -
 arch/m68knommu/include/asm/linkage.h               |    1 -
 arch/m68knommu/include/asm/math-emu.h              |    1 -
 arch/m68knommu/include/asm/md.h                    |    1 -
 arch/m68knommu/include/asm/mman.h                  |    1 -
 arch/m68knommu/include/asm/movs.h                  |    1 -
 arch/m68knommu/include/asm/msgbuf.h                |    1 -
 arch/m68knommu/include/asm/openprom.h              |    1 -
 arch/m68knommu/include/asm/oplib.h                 |    1 -
 arch/m68knommu/include/asm/poll.h                  |    1 -
 arch/m68knommu/include/asm/posix_types.h           |    1 -
 arch/m68knommu/include/asm/resource.h              |    1 -
 arch/m68knommu/include/asm/rtc.h                   |    1 -
 arch/m68knommu/include/asm/sembuf.h                |    1 -
 arch/m68knommu/include/asm/setup.h                 |    1 -
 arch/m68knommu/include/asm/shm.h                   |    1 -
 arch/m68knommu/include/asm/shmbuf.h                |    1 -
 arch/m68knommu/include/asm/shmparam.h              |    1 -
 arch/m68knommu/include/asm/socket.h                |    1 -
 arch/m68knommu/include/asm/sockios.h               |    1 -
 arch/m68knommu/include/asm/spinlock.h              |    1 -
 arch/m68knommu/include/asm/stat.h                  |    1 -
 arch/m68knommu/include/asm/statfs.h                |    1 -
 arch/m68knommu/include/asm/termbits.h              |    1 -
 arch/m68knommu/include/asm/termios.h               |    1 -
 arch/m68knommu/include/asm/tlb.h                   |    1 -
 arch/m68knommu/include/asm/types.h                 |    1 -
 arch/m68knommu/include/asm/user.h                  |    1 -
 195 files changed, 2 insertions(+), 33 deletions(-)
 rename {include => arch/m68k/include}/asm-m68k/Kbuild (100%)
 rename {include => arch/m68k/include}/asm-m68k/a.out-core.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/a.out.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/adb_iop.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/amigahw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/amigaints.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/amigayle.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/amipcmcia.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/apollodma.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/apollohw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atafd.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atafdreg.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atari_joystick.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atari_stdma.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atari_stram.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atarihw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atariints.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atarikb.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/atomic.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/auxvec.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/bitops.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/blinken.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/bootinfo.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/bug.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/bugs.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/bvme6000hw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/byteorder.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/cache.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/cachectl.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/cacheflush.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/checksum.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/contregs.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/cputime.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/current.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/delay.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/device.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/div64.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/dma-mapping.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/dma.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/dsp56k.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/dvma.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/elf.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/emergency-restart.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/entry.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/errno.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/fb.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/fbio.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/fcntl.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/floppy.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/fpu.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/futex.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/hardirq.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/hp300hw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/hw_irq.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/hwtest.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/ide.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/idprom.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/intersil.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/io.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/ioctl.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/ioctls.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/ipcbuf.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/irq.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/irq_regs.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/kdebug.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/kmap_types.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/linkage.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/local.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mac_asc.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mac_baboon.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mac_iop.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mac_mouse.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mac_oss.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mac_psc.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mac_via.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/machdep.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/machines.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/machw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/macintosh.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/macints.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/math-emu.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mc146818rtc.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/md.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mman.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mmu.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mmu_context.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mmzone.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/module.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/motorola_pgalloc.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/motorola_pgtable.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/movs.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/msgbuf.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mutex.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mvme147hw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/mvme16xhw.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/nubus.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/openprom.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/oplib.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/page.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/page_offset.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/param.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/parport.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/pci.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/percpu.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/pgalloc.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/pgtable.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/poll.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/posix_types.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/processor.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/ptrace.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/q40_master.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/q40ints.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/raw_io.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/resource.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/rtc.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sbus.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/scatterlist.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sections.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/segment.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sembuf.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/serial.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/setup.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/shm.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/shmbuf.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/shmparam.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sigcontext.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/siginfo.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/signal.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/socket.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sockios.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/spinlock.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/stat.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/statfs.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/string.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3-head.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3_pgalloc.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3_pgtable.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3ints.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3mmu.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3x.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3xflop.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/sun3xprom.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/suspend.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/system.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/termbits.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/termios.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/thread_info.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/timex.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/tlb.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/tlbflush.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/topology.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/traps.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/types.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/uaccess.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/ucontext.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/unaligned.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/unistd.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/user.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/virtconvert.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/xor.h (100%)
 rename {include => arch/m68k/include}/asm-m68k/zorro.h (100%)
 delete mode 100644 arch/m68knommu/include/asm/cachectl.h
 delete mode 100644 arch/m68knommu/include/asm/errno.h
 delete mode 100644 arch/m68knommu/include/asm/fcntl.h
 delete mode 100644 arch/m68knommu/include/asm/hwtest.h
 delete mode 100644 arch/m68knommu/include/asm/ioctls.h
 delete mode 100644 arch/m68knommu/include/asm/ipcbuf.h
 delete mode 100644 arch/m68knommu/include/asm/linkage.h
 delete mode 100644 arch/m68knommu/include/asm/math-emu.h
 delete mode 100644 arch/m68knommu/include/asm/md.h
 delete mode 100644 arch/m68knommu/include/asm/mman.h
 delete mode 100644 arch/m68knommu/include/asm/movs.h
 delete mode 100644 arch/m68knommu/include/asm/msgbuf.h
 delete mode 100644 arch/m68knommu/include/asm/openprom.h
 delete mode 100644 arch/m68knommu/include/asm/oplib.h
 delete mode 100644 arch/m68knommu/include/asm/poll.h
 delete mode 100644 arch/m68knommu/include/asm/posix_types.h
 delete mode 100644 arch/m68knommu/include/asm/resource.h
 delete mode 100644 arch/m68knommu/include/asm/rtc.h
 delete mode 100644 arch/m68knommu/include/asm/sembuf.h
 delete mode 100644 arch/m68knommu/include/asm/setup.h
 delete mode 100644 arch/m68knommu/include/asm/shm.h
 delete mode 100644 arch/m68knommu/include/asm/shmbuf.h
 delete mode 100644 arch/m68knommu/include/asm/shmparam.h
 delete mode 100644 arch/m68knommu/include/asm/socket.h
 delete mode 100644 arch/m68knommu/include/asm/sockios.h
 delete mode 100644 arch/m68knommu/include/asm/spinlock.h
 delete mode 100644 arch/m68knommu/include/asm/stat.h
 delete mode 100644 arch/m68knommu/include/asm/statfs.h
 delete mode 100644 arch/m68knommu/include/asm/termbits.h
 delete mode 100644 arch/m68knommu/include/asm/termios.h
 delete mode 100644 arch/m68knommu/include/asm/tlb.h
 delete mode 100644 arch/m68knommu/include/asm/types.h
 delete mode 100644 arch/m68knommu/include/asm/user.h

diff --git a/include/asm-m68k/Kbuild b/arch/m68k/include/asm-m68k/Kbuild
similarity index 100%
rename from include/asm-m68k/Kbuild
rename to arch/m68k/include/asm-m68k/Kbuild
diff --git a/include/asm-m68k/a.out-core.h b/arch/m68k/include/asm-m68k/a.out-core.h
similarity index 100%
rename from include/asm-m68k/a.out-core.h
rename to arch/m68k/include/asm-m68k/a.out-core.h
diff --git a/include/asm-m68k/a.out.h b/arch/m68k/include/asm-m68k/a.out.h
similarity index 100%
rename from include/asm-m68k/a.out.h
rename to arch/m68k/include/asm-m68k/a.out.h
diff --git a/include/asm-m68k/adb_iop.h b/arch/m68k/include/asm-m68k/adb_iop.h
similarity index 100%
rename from include/asm-m68k/adb_iop.h
rename to arch/m68k/include/asm-m68k/adb_iop.h
diff --git a/include/asm-m68k/amigahw.h b/arch/m68k/include/asm-m68k/amigahw.h
similarity index 100%
rename from include/asm-m68k/amigahw.h
rename to arch/m68k/include/asm-m68k/amigahw.h
diff --git a/include/asm-m68k/amigaints.h b/arch/m68k/include/asm-m68k/amigaints.h
similarity index 100%
rename from include/asm-m68k/amigaints.h
rename to arch/m68k/include/asm-m68k/amigaints.h
diff --git a/include/asm-m68k/amigayle.h b/arch/m68k/include/asm-m68k/amigayle.h
similarity index 100%
rename from include/asm-m68k/amigayle.h
rename to arch/m68k/include/asm-m68k/amigayle.h
diff --git a/include/asm-m68k/amipcmcia.h b/arch/m68k/include/asm-m68k/amipcmcia.h
similarity index 100%
rename from include/asm-m68k/amipcmcia.h
rename to arch/m68k/include/asm-m68k/amipcmcia.h
diff --git a/include/asm-m68k/apollodma.h b/arch/m68k/include/asm-m68k/apollodma.h
similarity index 100%
rename from include/asm-m68k/apollodma.h
rename to arch/m68k/include/asm-m68k/apollodma.h
diff --git a/include/asm-m68k/apollohw.h b/arch/m68k/include/asm-m68k/apollohw.h
similarity index 100%
rename from include/asm-m68k/apollohw.h
rename to arch/m68k/include/asm-m68k/apollohw.h
diff --git a/include/asm-m68k/atafd.h b/arch/m68k/include/asm-m68k/atafd.h
similarity index 100%
rename from include/asm-m68k/atafd.h
rename to arch/m68k/include/asm-m68k/atafd.h
diff --git a/include/asm-m68k/atafdreg.h b/arch/m68k/include/asm-m68k/atafdreg.h
similarity index 100%
rename from include/asm-m68k/atafdreg.h
rename to arch/m68k/include/asm-m68k/atafdreg.h
diff --git a/include/asm-m68k/atari_joystick.h b/arch/m68k/include/asm-m68k/atari_joystick.h
similarity index 100%
rename from include/asm-m68k/atari_joystick.h
rename to arch/m68k/include/asm-m68k/atari_joystick.h
diff --git a/include/asm-m68k/atari_stdma.h b/arch/m68k/include/asm-m68k/atari_stdma.h
similarity index 100%
rename from include/asm-m68k/atari_stdma.h
rename to arch/m68k/include/asm-m68k/atari_stdma.h
diff --git a/include/asm-m68k/atari_stram.h b/arch/m68k/include/asm-m68k/atari_stram.h
similarity index 100%
rename from include/asm-m68k/atari_stram.h
rename to arch/m68k/include/asm-m68k/atari_stram.h
diff --git a/include/asm-m68k/atarihw.h b/arch/m68k/include/asm-m68k/atarihw.h
similarity index 100%
rename from include/asm-m68k/atarihw.h
rename to arch/m68k/include/asm-m68k/atarihw.h
diff --git a/include/asm-m68k/atariints.h b/arch/m68k/include/asm-m68k/atariints.h
similarity index 100%
rename from include/asm-m68k/atariints.h
rename to arch/m68k/include/asm-m68k/atariints.h
diff --git a/include/asm-m68k/atarikb.h b/arch/m68k/include/asm-m68k/atarikb.h
similarity index 100%
rename from include/asm-m68k/atarikb.h
rename to arch/m68k/include/asm-m68k/atarikb.h
diff --git a/include/asm-m68k/atomic.h b/arch/m68k/include/asm-m68k/atomic.h
similarity index 100%
rename from include/asm-m68k/atomic.h
rename to arch/m68k/include/asm-m68k/atomic.h
diff --git a/include/asm-m68k/auxvec.h b/arch/m68k/include/asm-m68k/auxvec.h
similarity index 100%
rename from include/asm-m68k/auxvec.h
rename to arch/m68k/include/asm-m68k/auxvec.h
diff --git a/include/asm-m68k/bitops.h b/arch/m68k/include/asm-m68k/bitops.h
similarity index 100%
rename from include/asm-m68k/bitops.h
rename to arch/m68k/include/asm-m68k/bitops.h
diff --git a/include/asm-m68k/blinken.h b/arch/m68k/include/asm-m68k/blinken.h
similarity index 100%
rename from include/asm-m68k/blinken.h
rename to arch/m68k/include/asm-m68k/blinken.h
diff --git a/include/asm-m68k/bootinfo.h b/arch/m68k/include/asm-m68k/bootinfo.h
similarity index 100%
rename from include/asm-m68k/bootinfo.h
rename to arch/m68k/include/asm-m68k/bootinfo.h
diff --git a/include/asm-m68k/bug.h b/arch/m68k/include/asm-m68k/bug.h
similarity index 100%
rename from include/asm-m68k/bug.h
rename to arch/m68k/include/asm-m68k/bug.h
diff --git a/include/asm-m68k/bugs.h b/arch/m68k/include/asm-m68k/bugs.h
similarity index 100%
rename from include/asm-m68k/bugs.h
rename to arch/m68k/include/asm-m68k/bugs.h
diff --git a/include/asm-m68k/bvme6000hw.h b/arch/m68k/include/asm-m68k/bvme6000hw.h
similarity index 100%
rename from include/asm-m68k/bvme6000hw.h
rename to arch/m68k/include/asm-m68k/bvme6000hw.h
diff --git a/include/asm-m68k/byteorder.h b/arch/m68k/include/asm-m68k/byteorder.h
similarity index 100%
rename from include/asm-m68k/byteorder.h
rename to arch/m68k/include/asm-m68k/byteorder.h
diff --git a/include/asm-m68k/cache.h b/arch/m68k/include/asm-m68k/cache.h
similarity index 100%
rename from include/asm-m68k/cache.h
rename to arch/m68k/include/asm-m68k/cache.h
diff --git a/include/asm-m68k/cachectl.h b/arch/m68k/include/asm-m68k/cachectl.h
similarity index 100%
rename from include/asm-m68k/cachectl.h
rename to arch/m68k/include/asm-m68k/cachectl.h
diff --git a/include/asm-m68k/cacheflush.h b/arch/m68k/include/asm-m68k/cacheflush.h
similarity index 100%
rename from include/asm-m68k/cacheflush.h
rename to arch/m68k/include/asm-m68k/cacheflush.h
diff --git a/include/asm-m68k/checksum.h b/arch/m68k/include/asm-m68k/checksum.h
similarity index 100%
rename from include/asm-m68k/checksum.h
rename to arch/m68k/include/asm-m68k/checksum.h
diff --git a/include/asm-m68k/contregs.h b/arch/m68k/include/asm-m68k/contregs.h
similarity index 100%
rename from include/asm-m68k/contregs.h
rename to arch/m68k/include/asm-m68k/contregs.h
diff --git a/include/asm-m68k/cputime.h b/arch/m68k/include/asm-m68k/cputime.h
similarity index 100%
rename from include/asm-m68k/cputime.h
rename to arch/m68k/include/asm-m68k/cputime.h
diff --git a/include/asm-m68k/current.h b/arch/m68k/include/asm-m68k/current.h
similarity index 100%
rename from include/asm-m68k/current.h
rename to arch/m68k/include/asm-m68k/current.h
diff --git a/include/asm-m68k/delay.h b/arch/m68k/include/asm-m68k/delay.h
similarity index 100%
rename from include/asm-m68k/delay.h
rename to arch/m68k/include/asm-m68k/delay.h
diff --git a/include/asm-m68k/device.h b/arch/m68k/include/asm-m68k/device.h
similarity index 100%
rename from include/asm-m68k/device.h
rename to arch/m68k/include/asm-m68k/device.h
diff --git a/include/asm-m68k/div64.h b/arch/m68k/include/asm-m68k/div64.h
similarity index 100%
rename from include/asm-m68k/div64.h
rename to arch/m68k/include/asm-m68k/div64.h
diff --git a/include/asm-m68k/dma-mapping.h b/arch/m68k/include/asm-m68k/dma-mapping.h
similarity index 100%
rename from include/asm-m68k/dma-mapping.h
rename to arch/m68k/include/asm-m68k/dma-mapping.h
diff --git a/include/asm-m68k/dma.h b/arch/m68k/include/asm-m68k/dma.h
similarity index 100%
rename from include/asm-m68k/dma.h
rename to arch/m68k/include/asm-m68k/dma.h
diff --git a/include/asm-m68k/dsp56k.h b/arch/m68k/include/asm-m68k/dsp56k.h
similarity index 100%
rename from include/asm-m68k/dsp56k.h
rename to arch/m68k/include/asm-m68k/dsp56k.h
diff --git a/include/asm-m68k/dvma.h b/arch/m68k/include/asm-m68k/dvma.h
similarity index 100%
rename from include/asm-m68k/dvma.h
rename to arch/m68k/include/asm-m68k/dvma.h
diff --git a/include/asm-m68k/elf.h b/arch/m68k/include/asm-m68k/elf.h
similarity index 100%
rename from include/asm-m68k/elf.h
rename to arch/m68k/include/asm-m68k/elf.h
diff --git a/include/asm-m68k/emergency-restart.h b/arch/m68k/include/asm-m68k/emergency-restart.h
similarity index 100%
rename from include/asm-m68k/emergency-restart.h
rename to arch/m68k/include/asm-m68k/emergency-restart.h
diff --git a/include/asm-m68k/entry.h b/arch/m68k/include/asm-m68k/entry.h
similarity index 100%
rename from include/asm-m68k/entry.h
rename to arch/m68k/include/asm-m68k/entry.h
diff --git a/include/asm-m68k/errno.h b/arch/m68k/include/asm-m68k/errno.h
similarity index 100%
rename from include/asm-m68k/errno.h
rename to arch/m68k/include/asm-m68k/errno.h
diff --git a/include/asm-m68k/fb.h b/arch/m68k/include/asm-m68k/fb.h
similarity index 100%
rename from include/asm-m68k/fb.h
rename to arch/m68k/include/asm-m68k/fb.h
diff --git a/include/asm-m68k/fbio.h b/arch/m68k/include/asm-m68k/fbio.h
similarity index 100%
rename from include/asm-m68k/fbio.h
rename to arch/m68k/include/asm-m68k/fbio.h
diff --git a/include/asm-m68k/fcntl.h b/arch/m68k/include/asm-m68k/fcntl.h
similarity index 100%
rename from include/asm-m68k/fcntl.h
rename to arch/m68k/include/asm-m68k/fcntl.h
diff --git a/include/asm-m68k/floppy.h b/arch/m68k/include/asm-m68k/floppy.h
similarity index 100%
rename from include/asm-m68k/floppy.h
rename to arch/m68k/include/asm-m68k/floppy.h
diff --git a/include/asm-m68k/fpu.h b/arch/m68k/include/asm-m68k/fpu.h
similarity index 100%
rename from include/asm-m68k/fpu.h
rename to arch/m68k/include/asm-m68k/fpu.h
diff --git a/include/asm-m68k/futex.h b/arch/m68k/include/asm-m68k/futex.h
similarity index 100%
rename from include/asm-m68k/futex.h
rename to arch/m68k/include/asm-m68k/futex.h
diff --git a/include/asm-m68k/hardirq.h b/arch/m68k/include/asm-m68k/hardirq.h
similarity index 100%
rename from include/asm-m68k/hardirq.h
rename to arch/m68k/include/asm-m68k/hardirq.h
diff --git a/include/asm-m68k/hp300hw.h b/arch/m68k/include/asm-m68k/hp300hw.h
similarity index 100%
rename from include/asm-m68k/hp300hw.h
rename to arch/m68k/include/asm-m68k/hp300hw.h
diff --git a/include/asm-m68k/hw_irq.h b/arch/m68k/include/asm-m68k/hw_irq.h
similarity index 100%
rename from include/asm-m68k/hw_irq.h
rename to arch/m68k/include/asm-m68k/hw_irq.h
diff --git a/include/asm-m68k/hwtest.h b/arch/m68k/include/asm-m68k/hwtest.h
similarity index 100%
rename from include/asm-m68k/hwtest.h
rename to arch/m68k/include/asm-m68k/hwtest.h
diff --git a/include/asm-m68k/ide.h b/arch/m68k/include/asm-m68k/ide.h
similarity index 100%
rename from include/asm-m68k/ide.h
rename to arch/m68k/include/asm-m68k/ide.h
diff --git a/include/asm-m68k/idprom.h b/arch/m68k/include/asm-m68k/idprom.h
similarity index 100%
rename from include/asm-m68k/idprom.h
rename to arch/m68k/include/asm-m68k/idprom.h
diff --git a/include/asm-m68k/intersil.h b/arch/m68k/include/asm-m68k/intersil.h
similarity index 100%
rename from include/asm-m68k/intersil.h
rename to arch/m68k/include/asm-m68k/intersil.h
diff --git a/include/asm-m68k/io.h b/arch/m68k/include/asm-m68k/io.h
similarity index 100%
rename from include/asm-m68k/io.h
rename to arch/m68k/include/asm-m68k/io.h
diff --git a/include/asm-m68k/ioctl.h b/arch/m68k/include/asm-m68k/ioctl.h
similarity index 100%
rename from include/asm-m68k/ioctl.h
rename to arch/m68k/include/asm-m68k/ioctl.h
diff --git a/include/asm-m68k/ioctls.h b/arch/m68k/include/asm-m68k/ioctls.h
similarity index 100%
rename from include/asm-m68k/ioctls.h
rename to arch/m68k/include/asm-m68k/ioctls.h
diff --git a/include/asm-m68k/ipcbuf.h b/arch/m68k/include/asm-m68k/ipcbuf.h
similarity index 100%
rename from include/asm-m68k/ipcbuf.h
rename to arch/m68k/include/asm-m68k/ipcbuf.h
diff --git a/include/asm-m68k/irq.h b/arch/m68k/include/asm-m68k/irq.h
similarity index 100%
rename from include/asm-m68k/irq.h
rename to arch/m68k/include/asm-m68k/irq.h
diff --git a/include/asm-m68k/irq_regs.h b/arch/m68k/include/asm-m68k/irq_regs.h
similarity index 100%
rename from include/asm-m68k/irq_regs.h
rename to arch/m68k/include/asm-m68k/irq_regs.h
diff --git a/include/asm-m68k/kdebug.h b/arch/m68k/include/asm-m68k/kdebug.h
similarity index 100%
rename from include/asm-m68k/kdebug.h
rename to arch/m68k/include/asm-m68k/kdebug.h
diff --git a/include/asm-m68k/kmap_types.h b/arch/m68k/include/asm-m68k/kmap_types.h
similarity index 100%
rename from include/asm-m68k/kmap_types.h
rename to arch/m68k/include/asm-m68k/kmap_types.h
diff --git a/include/asm-m68k/linkage.h b/arch/m68k/include/asm-m68k/linkage.h
similarity index 100%
rename from include/asm-m68k/linkage.h
rename to arch/m68k/include/asm-m68k/linkage.h
diff --git a/include/asm-m68k/local.h b/arch/m68k/include/asm-m68k/local.h
similarity index 100%
rename from include/asm-m68k/local.h
rename to arch/m68k/include/asm-m68k/local.h
diff --git a/include/asm-m68k/mac_asc.h b/arch/m68k/include/asm-m68k/mac_asc.h
similarity index 100%
rename from include/asm-m68k/mac_asc.h
rename to arch/m68k/include/asm-m68k/mac_asc.h
diff --git a/include/asm-m68k/mac_baboon.h b/arch/m68k/include/asm-m68k/mac_baboon.h
similarity index 100%
rename from include/asm-m68k/mac_baboon.h
rename to arch/m68k/include/asm-m68k/mac_baboon.h
diff --git a/include/asm-m68k/mac_iop.h b/arch/m68k/include/asm-m68k/mac_iop.h
similarity index 100%
rename from include/asm-m68k/mac_iop.h
rename to arch/m68k/include/asm-m68k/mac_iop.h
diff --git a/include/asm-m68k/mac_mouse.h b/arch/m68k/include/asm-m68k/mac_mouse.h
similarity index 100%
rename from include/asm-m68k/mac_mouse.h
rename to arch/m68k/include/asm-m68k/mac_mouse.h
diff --git a/include/asm-m68k/mac_oss.h b/arch/m68k/include/asm-m68k/mac_oss.h
similarity index 100%
rename from include/asm-m68k/mac_oss.h
rename to arch/m68k/include/asm-m68k/mac_oss.h
diff --git a/include/asm-m68k/mac_psc.h b/arch/m68k/include/asm-m68k/mac_psc.h
similarity index 100%
rename from include/asm-m68k/mac_psc.h
rename to arch/m68k/include/asm-m68k/mac_psc.h
diff --git a/include/asm-m68k/mac_via.h b/arch/m68k/include/asm-m68k/mac_via.h
similarity index 100%
rename from include/asm-m68k/mac_via.h
rename to arch/m68k/include/asm-m68k/mac_via.h
diff --git a/include/asm-m68k/machdep.h b/arch/m68k/include/asm-m68k/machdep.h
similarity index 100%
rename from include/asm-m68k/machdep.h
rename to arch/m68k/include/asm-m68k/machdep.h
diff --git a/include/asm-m68k/machines.h b/arch/m68k/include/asm-m68k/machines.h
similarity index 100%
rename from include/asm-m68k/machines.h
rename to arch/m68k/include/asm-m68k/machines.h
diff --git a/include/asm-m68k/machw.h b/arch/m68k/include/asm-m68k/machw.h
similarity index 100%
rename from include/asm-m68k/machw.h
rename to arch/m68k/include/asm-m68k/machw.h
diff --git a/include/asm-m68k/macintosh.h b/arch/m68k/include/asm-m68k/macintosh.h
similarity index 100%
rename from include/asm-m68k/macintosh.h
rename to arch/m68k/include/asm-m68k/macintosh.h
diff --git a/include/asm-m68k/macints.h b/arch/m68k/include/asm-m68k/macints.h
similarity index 100%
rename from include/asm-m68k/macints.h
rename to arch/m68k/include/asm-m68k/macints.h
diff --git a/include/asm-m68k/math-emu.h b/arch/m68k/include/asm-m68k/math-emu.h
similarity index 100%
rename from include/asm-m68k/math-emu.h
rename to arch/m68k/include/asm-m68k/math-emu.h
diff --git a/include/asm-m68k/mc146818rtc.h b/arch/m68k/include/asm-m68k/mc146818rtc.h
similarity index 100%
rename from include/asm-m68k/mc146818rtc.h
rename to arch/m68k/include/asm-m68k/mc146818rtc.h
diff --git a/include/asm-m68k/md.h b/arch/m68k/include/asm-m68k/md.h
similarity index 100%
rename from include/asm-m68k/md.h
rename to arch/m68k/include/asm-m68k/md.h
diff --git a/include/asm-m68k/mman.h b/arch/m68k/include/asm-m68k/mman.h
similarity index 100%
rename from include/asm-m68k/mman.h
rename to arch/m68k/include/asm-m68k/mman.h
diff --git a/include/asm-m68k/mmu.h b/arch/m68k/include/asm-m68k/mmu.h
similarity index 100%
rename from include/asm-m68k/mmu.h
rename to arch/m68k/include/asm-m68k/mmu.h
diff --git a/include/asm-m68k/mmu_context.h b/arch/m68k/include/asm-m68k/mmu_context.h
similarity index 100%
rename from include/asm-m68k/mmu_context.h
rename to arch/m68k/include/asm-m68k/mmu_context.h
diff --git a/include/asm-m68k/mmzone.h b/arch/m68k/include/asm-m68k/mmzone.h
similarity index 100%
rename from include/asm-m68k/mmzone.h
rename to arch/m68k/include/asm-m68k/mmzone.h
diff --git a/include/asm-m68k/module.h b/arch/m68k/include/asm-m68k/module.h
similarity index 100%
rename from include/asm-m68k/module.h
rename to arch/m68k/include/asm-m68k/module.h
diff --git a/include/asm-m68k/motorola_pgalloc.h b/arch/m68k/include/asm-m68k/motorola_pgalloc.h
similarity index 100%
rename from include/asm-m68k/motorola_pgalloc.h
rename to arch/m68k/include/asm-m68k/motorola_pgalloc.h
diff --git a/include/asm-m68k/motorola_pgtable.h b/arch/m68k/include/asm-m68k/motorola_pgtable.h
similarity index 100%
rename from include/asm-m68k/motorola_pgtable.h
rename to arch/m68k/include/asm-m68k/motorola_pgtable.h
diff --git a/include/asm-m68k/movs.h b/arch/m68k/include/asm-m68k/movs.h
similarity index 100%
rename from include/asm-m68k/movs.h
rename to arch/m68k/include/asm-m68k/movs.h
diff --git a/include/asm-m68k/msgbuf.h b/arch/m68k/include/asm-m68k/msgbuf.h
similarity index 100%
rename from include/asm-m68k/msgbuf.h
rename to arch/m68k/include/asm-m68k/msgbuf.h
diff --git a/include/asm-m68k/mutex.h b/arch/m68k/include/asm-m68k/mutex.h
similarity index 100%
rename from include/asm-m68k/mutex.h
rename to arch/m68k/include/asm-m68k/mutex.h
diff --git a/include/asm-m68k/mvme147hw.h b/arch/m68k/include/asm-m68k/mvme147hw.h
similarity index 100%
rename from include/asm-m68k/mvme147hw.h
rename to arch/m68k/include/asm-m68k/mvme147hw.h
diff --git a/include/asm-m68k/mvme16xhw.h b/arch/m68k/include/asm-m68k/mvme16xhw.h
similarity index 100%
rename from include/asm-m68k/mvme16xhw.h
rename to arch/m68k/include/asm-m68k/mvme16xhw.h
diff --git a/include/asm-m68k/nubus.h b/arch/m68k/include/asm-m68k/nubus.h
similarity index 100%
rename from include/asm-m68k/nubus.h
rename to arch/m68k/include/asm-m68k/nubus.h
diff --git a/include/asm-m68k/openprom.h b/arch/m68k/include/asm-m68k/openprom.h
similarity index 100%
rename from include/asm-m68k/openprom.h
rename to arch/m68k/include/asm-m68k/openprom.h
diff --git a/include/asm-m68k/oplib.h b/arch/m68k/include/asm-m68k/oplib.h
similarity index 100%
rename from include/asm-m68k/oplib.h
rename to arch/m68k/include/asm-m68k/oplib.h
diff --git a/include/asm-m68k/page.h b/arch/m68k/include/asm-m68k/page.h
similarity index 100%
rename from include/asm-m68k/page.h
rename to arch/m68k/include/asm-m68k/page.h
diff --git a/include/asm-m68k/page_offset.h b/arch/m68k/include/asm-m68k/page_offset.h
similarity index 100%
rename from include/asm-m68k/page_offset.h
rename to arch/m68k/include/asm-m68k/page_offset.h
diff --git a/include/asm-m68k/param.h b/arch/m68k/include/asm-m68k/param.h
similarity index 100%
rename from include/asm-m68k/param.h
rename to arch/m68k/include/asm-m68k/param.h
diff --git a/include/asm-m68k/parport.h b/arch/m68k/include/asm-m68k/parport.h
similarity index 100%
rename from include/asm-m68k/parport.h
rename to arch/m68k/include/asm-m68k/parport.h
diff --git a/include/asm-m68k/pci.h b/arch/m68k/include/asm-m68k/pci.h
similarity index 100%
rename from include/asm-m68k/pci.h
rename to arch/m68k/include/asm-m68k/pci.h
diff --git a/include/asm-m68k/percpu.h b/arch/m68k/include/asm-m68k/percpu.h
similarity index 100%
rename from include/asm-m68k/percpu.h
rename to arch/m68k/include/asm-m68k/percpu.h
diff --git a/include/asm-m68k/pgalloc.h b/arch/m68k/include/asm-m68k/pgalloc.h
similarity index 100%
rename from include/asm-m68k/pgalloc.h
rename to arch/m68k/include/asm-m68k/pgalloc.h
diff --git a/include/asm-m68k/pgtable.h b/arch/m68k/include/asm-m68k/pgtable.h
similarity index 100%
rename from include/asm-m68k/pgtable.h
rename to arch/m68k/include/asm-m68k/pgtable.h
diff --git a/include/asm-m68k/poll.h b/arch/m68k/include/asm-m68k/poll.h
similarity index 100%
rename from include/asm-m68k/poll.h
rename to arch/m68k/include/asm-m68k/poll.h
diff --git a/include/asm-m68k/posix_types.h b/arch/m68k/include/asm-m68k/posix_types.h
similarity index 100%
rename from include/asm-m68k/posix_types.h
rename to arch/m68k/include/asm-m68k/posix_types.h
diff --git a/include/asm-m68k/processor.h b/arch/m68k/include/asm-m68k/processor.h
similarity index 100%
rename from include/asm-m68k/processor.h
rename to arch/m68k/include/asm-m68k/processor.h
diff --git a/include/asm-m68k/ptrace.h b/arch/m68k/include/asm-m68k/ptrace.h
similarity index 100%
rename from include/asm-m68k/ptrace.h
rename to arch/m68k/include/asm-m68k/ptrace.h
diff --git a/include/asm-m68k/q40_master.h b/arch/m68k/include/asm-m68k/q40_master.h
similarity index 100%
rename from include/asm-m68k/q40_master.h
rename to arch/m68k/include/asm-m68k/q40_master.h
diff --git a/include/asm-m68k/q40ints.h b/arch/m68k/include/asm-m68k/q40ints.h
similarity index 100%
rename from include/asm-m68k/q40ints.h
rename to arch/m68k/include/asm-m68k/q40ints.h
diff --git a/include/asm-m68k/raw_io.h b/arch/m68k/include/asm-m68k/raw_io.h
similarity index 100%
rename from include/asm-m68k/raw_io.h
rename to arch/m68k/include/asm-m68k/raw_io.h
diff --git a/include/asm-m68k/resource.h b/arch/m68k/include/asm-m68k/resource.h
similarity index 100%
rename from include/asm-m68k/resource.h
rename to arch/m68k/include/asm-m68k/resource.h
diff --git a/include/asm-m68k/rtc.h b/arch/m68k/include/asm-m68k/rtc.h
similarity index 100%
rename from include/asm-m68k/rtc.h
rename to arch/m68k/include/asm-m68k/rtc.h
diff --git a/include/asm-m68k/sbus.h b/arch/m68k/include/asm-m68k/sbus.h
similarity index 100%
rename from include/asm-m68k/sbus.h
rename to arch/m68k/include/asm-m68k/sbus.h
diff --git a/include/asm-m68k/scatterlist.h b/arch/m68k/include/asm-m68k/scatterlist.h
similarity index 100%
rename from include/asm-m68k/scatterlist.h
rename to arch/m68k/include/asm-m68k/scatterlist.h
diff --git a/include/asm-m68k/sections.h b/arch/m68k/include/asm-m68k/sections.h
similarity index 100%
rename from include/asm-m68k/sections.h
rename to arch/m68k/include/asm-m68k/sections.h
diff --git a/include/asm-m68k/segment.h b/arch/m68k/include/asm-m68k/segment.h
similarity index 100%
rename from include/asm-m68k/segment.h
rename to arch/m68k/include/asm-m68k/segment.h
diff --git a/include/asm-m68k/sembuf.h b/arch/m68k/include/asm-m68k/sembuf.h
similarity index 100%
rename from include/asm-m68k/sembuf.h
rename to arch/m68k/include/asm-m68k/sembuf.h
diff --git a/include/asm-m68k/serial.h b/arch/m68k/include/asm-m68k/serial.h
similarity index 100%
rename from include/asm-m68k/serial.h
rename to arch/m68k/include/asm-m68k/serial.h
diff --git a/include/asm-m68k/setup.h b/arch/m68k/include/asm-m68k/setup.h
similarity index 100%
rename from include/asm-m68k/setup.h
rename to arch/m68k/include/asm-m68k/setup.h
diff --git a/include/asm-m68k/shm.h b/arch/m68k/include/asm-m68k/shm.h
similarity index 100%
rename from include/asm-m68k/shm.h
rename to arch/m68k/include/asm-m68k/shm.h
diff --git a/include/asm-m68k/shmbuf.h b/arch/m68k/include/asm-m68k/shmbuf.h
similarity index 100%
rename from include/asm-m68k/shmbuf.h
rename to arch/m68k/include/asm-m68k/shmbuf.h
diff --git a/include/asm-m68k/shmparam.h b/arch/m68k/include/asm-m68k/shmparam.h
similarity index 100%
rename from include/asm-m68k/shmparam.h
rename to arch/m68k/include/asm-m68k/shmparam.h
diff --git a/include/asm-m68k/sigcontext.h b/arch/m68k/include/asm-m68k/sigcontext.h
similarity index 100%
rename from include/asm-m68k/sigcontext.h
rename to arch/m68k/include/asm-m68k/sigcontext.h
diff --git a/include/asm-m68k/siginfo.h b/arch/m68k/include/asm-m68k/siginfo.h
similarity index 100%
rename from include/asm-m68k/siginfo.h
rename to arch/m68k/include/asm-m68k/siginfo.h
diff --git a/include/asm-m68k/signal.h b/arch/m68k/include/asm-m68k/signal.h
similarity index 100%
rename from include/asm-m68k/signal.h
rename to arch/m68k/include/asm-m68k/signal.h
diff --git a/include/asm-m68k/socket.h b/arch/m68k/include/asm-m68k/socket.h
similarity index 100%
rename from include/asm-m68k/socket.h
rename to arch/m68k/include/asm-m68k/socket.h
diff --git a/include/asm-m68k/sockios.h b/arch/m68k/include/asm-m68k/sockios.h
similarity index 100%
rename from include/asm-m68k/sockios.h
rename to arch/m68k/include/asm-m68k/sockios.h
diff --git a/include/asm-m68k/spinlock.h b/arch/m68k/include/asm-m68k/spinlock.h
similarity index 100%
rename from include/asm-m68k/spinlock.h
rename to arch/m68k/include/asm-m68k/spinlock.h
diff --git a/include/asm-m68k/stat.h b/arch/m68k/include/asm-m68k/stat.h
similarity index 100%
rename from include/asm-m68k/stat.h
rename to arch/m68k/include/asm-m68k/stat.h
diff --git a/include/asm-m68k/statfs.h b/arch/m68k/include/asm-m68k/statfs.h
similarity index 100%
rename from include/asm-m68k/statfs.h
rename to arch/m68k/include/asm-m68k/statfs.h
diff --git a/include/asm-m68k/string.h b/arch/m68k/include/asm-m68k/string.h
similarity index 100%
rename from include/asm-m68k/string.h
rename to arch/m68k/include/asm-m68k/string.h
diff --git a/include/asm-m68k/sun3-head.h b/arch/m68k/include/asm-m68k/sun3-head.h
similarity index 100%
rename from include/asm-m68k/sun3-head.h
rename to arch/m68k/include/asm-m68k/sun3-head.h
diff --git a/include/asm-m68k/sun3_pgalloc.h b/arch/m68k/include/asm-m68k/sun3_pgalloc.h
similarity index 100%
rename from include/asm-m68k/sun3_pgalloc.h
rename to arch/m68k/include/asm-m68k/sun3_pgalloc.h
diff --git a/include/asm-m68k/sun3_pgtable.h b/arch/m68k/include/asm-m68k/sun3_pgtable.h
similarity index 100%
rename from include/asm-m68k/sun3_pgtable.h
rename to arch/m68k/include/asm-m68k/sun3_pgtable.h
diff --git a/include/asm-m68k/sun3ints.h b/arch/m68k/include/asm-m68k/sun3ints.h
similarity index 100%
rename from include/asm-m68k/sun3ints.h
rename to arch/m68k/include/asm-m68k/sun3ints.h
diff --git a/include/asm-m68k/sun3mmu.h b/arch/m68k/include/asm-m68k/sun3mmu.h
similarity index 100%
rename from include/asm-m68k/sun3mmu.h
rename to arch/m68k/include/asm-m68k/sun3mmu.h
diff --git a/include/asm-m68k/sun3x.h b/arch/m68k/include/asm-m68k/sun3x.h
similarity index 100%
rename from include/asm-m68k/sun3x.h
rename to arch/m68k/include/asm-m68k/sun3x.h
diff --git a/include/asm-m68k/sun3xflop.h b/arch/m68k/include/asm-m68k/sun3xflop.h
similarity index 100%
rename from include/asm-m68k/sun3xflop.h
rename to arch/m68k/include/asm-m68k/sun3xflop.h
diff --git a/include/asm-m68k/sun3xprom.h b/arch/m68k/include/asm-m68k/sun3xprom.h
similarity index 100%
rename from include/asm-m68k/sun3xprom.h
rename to arch/m68k/include/asm-m68k/sun3xprom.h
diff --git a/include/asm-m68k/suspend.h b/arch/m68k/include/asm-m68k/suspend.h
similarity index 100%
rename from include/asm-m68k/suspend.h
rename to arch/m68k/include/asm-m68k/suspend.h
diff --git a/include/asm-m68k/system.h b/arch/m68k/include/asm-m68k/system.h
similarity index 100%
rename from include/asm-m68k/system.h
rename to arch/m68k/include/asm-m68k/system.h
diff --git a/include/asm-m68k/termbits.h b/arch/m68k/include/asm-m68k/termbits.h
similarity index 100%
rename from include/asm-m68k/termbits.h
rename to arch/m68k/include/asm-m68k/termbits.h
diff --git a/include/asm-m68k/termios.h b/arch/m68k/include/asm-m68k/termios.h
similarity index 100%
rename from include/asm-m68k/termios.h
rename to arch/m68k/include/asm-m68k/termios.h
diff --git a/include/asm-m68k/thread_info.h b/arch/m68k/include/asm-m68k/thread_info.h
similarity index 100%
rename from include/asm-m68k/thread_info.h
rename to arch/m68k/include/asm-m68k/thread_info.h
diff --git a/include/asm-m68k/timex.h b/arch/m68k/include/asm-m68k/timex.h
similarity index 100%
rename from include/asm-m68k/timex.h
rename to arch/m68k/include/asm-m68k/timex.h
diff --git a/include/asm-m68k/tlb.h b/arch/m68k/include/asm-m68k/tlb.h
similarity index 100%
rename from include/asm-m68k/tlb.h
rename to arch/m68k/include/asm-m68k/tlb.h
diff --git a/include/asm-m68k/tlbflush.h b/arch/m68k/include/asm-m68k/tlbflush.h
similarity index 100%
rename from include/asm-m68k/tlbflush.h
rename to arch/m68k/include/asm-m68k/tlbflush.h
diff --git a/include/asm-m68k/topology.h b/arch/m68k/include/asm-m68k/topology.h
similarity index 100%
rename from include/asm-m68k/topology.h
rename to arch/m68k/include/asm-m68k/topology.h
diff --git a/include/asm-m68k/traps.h b/arch/m68k/include/asm-m68k/traps.h
similarity index 100%
rename from include/asm-m68k/traps.h
rename to arch/m68k/include/asm-m68k/traps.h
diff --git a/include/asm-m68k/types.h b/arch/m68k/include/asm-m68k/types.h
similarity index 100%
rename from include/asm-m68k/types.h
rename to arch/m68k/include/asm-m68k/types.h
diff --git a/include/asm-m68k/uaccess.h b/arch/m68k/include/asm-m68k/uaccess.h
similarity index 100%
rename from include/asm-m68k/uaccess.h
rename to arch/m68k/include/asm-m68k/uaccess.h
diff --git a/include/asm-m68k/ucontext.h b/arch/m68k/include/asm-m68k/ucontext.h
similarity index 100%
rename from include/asm-m68k/ucontext.h
rename to arch/m68k/include/asm-m68k/ucontext.h
diff --git a/include/asm-m68k/unaligned.h b/arch/m68k/include/asm-m68k/unaligned.h
similarity index 100%
rename from include/asm-m68k/unaligned.h
rename to arch/m68k/include/asm-m68k/unaligned.h
diff --git a/include/asm-m68k/unistd.h b/arch/m68k/include/asm-m68k/unistd.h
similarity index 100%
rename from include/asm-m68k/unistd.h
rename to arch/m68k/include/asm-m68k/unistd.h
diff --git a/include/asm-m68k/user.h b/arch/m68k/include/asm-m68k/user.h
similarity index 100%
rename from include/asm-m68k/user.h
rename to arch/m68k/include/asm-m68k/user.h
diff --git a/include/asm-m68k/virtconvert.h b/arch/m68k/include/asm-m68k/virtconvert.h
similarity index 100%
rename from include/asm-m68k/virtconvert.h
rename to arch/m68k/include/asm-m68k/virtconvert.h
diff --git a/include/asm-m68k/xor.h b/arch/m68k/include/asm-m68k/xor.h
similarity index 100%
rename from include/asm-m68k/xor.h
rename to arch/m68k/include/asm-m68k/xor.h
diff --git a/include/asm-m68k/zorro.h b/arch/m68k/include/asm-m68k/zorro.h
similarity index 100%
rename from include/asm-m68k/zorro.h
rename to arch/m68k/include/asm-m68k/zorro.h
diff --git a/arch/m68knommu/Makefile b/arch/m68knommu/Makefile
index b63bbcf..0c9545c 100644
--- a/arch/m68knommu/Makefile
+++ b/arch/m68knommu/Makefile
@@ -112,6 +112,8 @@ KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += -D__linux__
 KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
 
+KBUILD_CPPFLAGS += -I$(srctree)/arch/m68k/include
+
 head-y := arch/m68knommu/platform/$(cpuclass-y)/head.o
 
 core-y	+= arch/m68knommu/kernel/ \
diff --git a/arch/m68knommu/include/asm/cachectl.h b/arch/m68knommu/include/asm/cachectl.h
deleted file mode 100644
index bcf5a6a..0000000
--- a/arch/m68knommu/include/asm/cachectl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/cachectl.h>
diff --git a/arch/m68knommu/include/asm/errno.h b/arch/m68knommu/include/asm/errno.h
deleted file mode 100644
index 7e8c22b..0000000
--- a/arch/m68knommu/include/asm/errno.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/errno.h>
diff --git a/arch/m68knommu/include/asm/fcntl.h b/arch/m68knommu/include/asm/fcntl.h
deleted file mode 100644
index f6a552c..0000000
--- a/arch/m68knommu/include/asm/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/fcntl.h>
diff --git a/arch/m68knommu/include/asm/hwtest.h b/arch/m68knommu/include/asm/hwtest.h
deleted file mode 100644
index 700626a..0000000
--- a/arch/m68knommu/include/asm/hwtest.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/hwtest.h>
diff --git a/arch/m68knommu/include/asm/ioctls.h b/arch/m68knommu/include/asm/ioctls.h
deleted file mode 100644
index 0b1eb4d..0000000
--- a/arch/m68knommu/include/asm/ioctls.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/ioctls.h>
diff --git a/arch/m68knommu/include/asm/ipcbuf.h b/arch/m68knommu/include/asm/ipcbuf.h
deleted file mode 100644
index e4a7be6..0000000
--- a/arch/m68knommu/include/asm/ipcbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/ipcbuf.h>
diff --git a/arch/m68knommu/include/asm/linkage.h b/arch/m68knommu/include/asm/linkage.h
deleted file mode 100644
index c288a19..0000000
--- a/arch/m68knommu/include/asm/linkage.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/linkage.h>
diff --git a/arch/m68knommu/include/asm/math-emu.h b/arch/m68knommu/include/asm/math-emu.h
deleted file mode 100644
index 7e70905..0000000
--- a/arch/m68knommu/include/asm/math-emu.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/math-emu.h>
diff --git a/arch/m68knommu/include/asm/md.h b/arch/m68knommu/include/asm/md.h
deleted file mode 100644
index d810c78..0000000
--- a/arch/m68knommu/include/asm/md.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/md.h>
diff --git a/arch/m68knommu/include/asm/mman.h b/arch/m68knommu/include/asm/mman.h
deleted file mode 100644
index 4846c68..0000000
--- a/arch/m68knommu/include/asm/mman.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/mman.h>
diff --git a/arch/m68knommu/include/asm/movs.h b/arch/m68knommu/include/asm/movs.h
deleted file mode 100644
index 81a1677..0000000
--- a/arch/m68knommu/include/asm/movs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/movs.h>
diff --git a/arch/m68knommu/include/asm/msgbuf.h b/arch/m68knommu/include/asm/msgbuf.h
deleted file mode 100644
index bdfadec..0000000
--- a/arch/m68knommu/include/asm/msgbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/msgbuf.h>
diff --git a/arch/m68knommu/include/asm/openprom.h b/arch/m68knommu/include/asm/openprom.h
deleted file mode 100644
index fdba795..0000000
--- a/arch/m68knommu/include/asm/openprom.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/openprom.h>
diff --git a/arch/m68knommu/include/asm/oplib.h b/arch/m68knommu/include/asm/oplib.h
deleted file mode 100644
index ce079dc..0000000
--- a/arch/m68knommu/include/asm/oplib.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/oplib.h>
diff --git a/arch/m68knommu/include/asm/poll.h b/arch/m68knommu/include/asm/poll.h
deleted file mode 100644
index ee1b6cb..0000000
--- a/arch/m68knommu/include/asm/poll.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/poll.h>
diff --git a/arch/m68knommu/include/asm/posix_types.h b/arch/m68knommu/include/asm/posix_types.h
deleted file mode 100644
index 6205fb9..0000000
--- a/arch/m68knommu/include/asm/posix_types.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/posix_types.h>
diff --git a/arch/m68knommu/include/asm/resource.h b/arch/m68knommu/include/asm/resource.h
deleted file mode 100644
index 7fa63d5..0000000
--- a/arch/m68knommu/include/asm/resource.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/resource.h>
diff --git a/arch/m68knommu/include/asm/rtc.h b/arch/m68knommu/include/asm/rtc.h
deleted file mode 100644
index eaf18ec..0000000
--- a/arch/m68knommu/include/asm/rtc.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/rtc.h>
diff --git a/arch/m68knommu/include/asm/sembuf.h b/arch/m68knommu/include/asm/sembuf.h
deleted file mode 100644
index 3a634f9..0000000
--- a/arch/m68knommu/include/asm/sembuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/sembuf.h>
diff --git a/arch/m68knommu/include/asm/setup.h b/arch/m68knommu/include/asm/setup.h
deleted file mode 100644
index ff4565e..0000000
--- a/arch/m68knommu/include/asm/setup.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/setup.h>
diff --git a/arch/m68knommu/include/asm/shm.h b/arch/m68knommu/include/asm/shm.h
deleted file mode 100644
index cc8e522..0000000
--- a/arch/m68knommu/include/asm/shm.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/shm.h>
diff --git a/arch/m68knommu/include/asm/shmbuf.h b/arch/m68knommu/include/asm/shmbuf.h
deleted file mode 100644
index bc34cf8..0000000
--- a/arch/m68knommu/include/asm/shmbuf.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/shmbuf.h>
diff --git a/arch/m68knommu/include/asm/shmparam.h b/arch/m68knommu/include/asm/shmparam.h
deleted file mode 100644
index d7ee696..0000000
--- a/arch/m68knommu/include/asm/shmparam.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/shmparam.h>
diff --git a/arch/m68knommu/include/asm/socket.h b/arch/m68knommu/include/asm/socket.h
deleted file mode 100644
index ac5478b..0000000
--- a/arch/m68knommu/include/asm/socket.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/socket.h>
diff --git a/arch/m68knommu/include/asm/sockios.h b/arch/m68knommu/include/asm/sockios.h
deleted file mode 100644
index dcc6a89..0000000
--- a/arch/m68knommu/include/asm/sockios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/sockios.h>
diff --git a/arch/m68knommu/include/asm/spinlock.h b/arch/m68knommu/include/asm/spinlock.h
deleted file mode 100644
index 6bb1f06..0000000
--- a/arch/m68knommu/include/asm/spinlock.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/spinlock.h>
diff --git a/arch/m68knommu/include/asm/stat.h b/arch/m68knommu/include/asm/stat.h
deleted file mode 100644
index 3d4b260..0000000
--- a/arch/m68knommu/include/asm/stat.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/stat.h>
diff --git a/arch/m68knommu/include/asm/statfs.h b/arch/m68knommu/include/asm/statfs.h
deleted file mode 100644
index 2ce99ea..0000000
--- a/arch/m68knommu/include/asm/statfs.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/statfs.h>
diff --git a/arch/m68knommu/include/asm/termbits.h b/arch/m68knommu/include/asm/termbits.h
deleted file mode 100644
index 05dd6bc..0000000
--- a/arch/m68knommu/include/asm/termbits.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/termbits.h>
diff --git a/arch/m68knommu/include/asm/termios.h b/arch/m68knommu/include/asm/termios.h
deleted file mode 100644
index e733788..0000000
--- a/arch/m68knommu/include/asm/termios.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/termios.h>
diff --git a/arch/m68knommu/include/asm/tlb.h b/arch/m68knommu/include/asm/tlb.h
deleted file mode 100644
index 77a7c51..0000000
--- a/arch/m68knommu/include/asm/tlb.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/tlb.h>
diff --git a/arch/m68knommu/include/asm/types.h b/arch/m68knommu/include/asm/types.h
deleted file mode 100644
index 031238c..0000000
--- a/arch/m68knommu/include/asm/types.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/types.h>
diff --git a/arch/m68knommu/include/asm/user.h b/arch/m68knommu/include/asm/user.h
deleted file mode 100644
index a5a555b..0000000
--- a/arch/m68knommu/include/asm/user.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-m68k/user.h>
-- 
1.5.6.5


>From 3bdb637d5728407a3d724368078d381590098b6b Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 17 Dec 2008 11:42:48 -0500
Subject: [PATCH] mn10300 header move, part 1

move headers, kill proc and unit symlinks

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/Makefile                              |   41 +-------------------
 .../mn10300/include/asm}/.gitignore                |    0 
 .../mn10300/include/asm}/Kbuild                    |    0 
 .../mn10300/include/asm}/atomic.h                  |    0 
 .../mn10300/include/asm}/auxvec.h                  |    0 
 .../mn10300/include/asm}/bitops.h                  |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/bug.h |    0 
 .../mn10300/include/asm}/bugs.h                    |    0 
 .../mn10300/include/asm}/busctl-regs.h             |    0 
 .../mn10300/include/asm}/byteorder.h               |    0 
 .../mn10300/include/asm}/cache.h                   |    0 
 .../mn10300/include/asm}/cacheflush.h              |    0 
 .../mn10300/include/asm}/checksum.h                |    0 
 .../mn10300/include/asm}/cpu-regs.h                |    0 
 .../mn10300/include/asm}/cputime.h                 |    0 
 .../mn10300/include/asm}/current.h                 |    0 
 .../mn10300/include/asm}/delay.h                   |    0 
 .../mn10300/include/asm}/device.h                  |    0 
 .../mn10300/include/asm}/div64.h                   |    0 
 .../mn10300/include/asm}/dma-mapping.h             |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/dma.h |    0 
 .../mn10300/include/asm}/dmactl-regs.h             |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/elf.h |    0 
 .../mn10300/include/asm}/emergency-restart.h       |    0 
 .../mn10300/include/asm}/errno.h                   |    0 
 .../mn10300/include/asm}/exceptions.h              |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/fb.h  |    0 
 .../mn10300/include/asm}/fcntl.h                   |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/fpu.h |    0 
 .../mn10300/include/asm}/frame.inc                 |    0 
 .../mn10300/include/asm}/futex.h                   |    0 
 .../mn10300/include/asm}/gdb-stub.h                |    0 
 .../mn10300/include/asm}/hardirq.h                 |    0 
 .../mn10300/include/asm}/highmem.h                 |    0 
 .../mn10300/include/asm}/hw_irq.h                  |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/ide.h |    0 
 .../mn10300/include/asm}/intctl-regs.h             |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/io.h  |    0 
 .../mn10300/include/asm}/ioctl.h                   |    0 
 .../mn10300/include/asm}/ioctls.h                  |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/ipc.h |    0 
 .../mn10300/include/asm}/ipcbuf.h                  |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/irq.h |    0 
 .../mn10300/include/asm}/irq_regs.h                |    0 
 .../mn10300/include/asm}/kdebug.h                  |    0 
 .../mn10300/include/asm}/kmap_types.h              |    0 
 .../mn10300/include/asm}/kprobes.h                 |    0 
 .../mn10300/include/asm}/linkage.h                 |    0 
 .../mn10300/include/asm}/local.h                   |    0 
 .../mn10300/include/asm}/mc146818rtc.h             |    0 
 .../mn10300/include/asm}/mman.h                    |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/mmu.h |    0 
 .../mn10300/include/asm}/mmu_context.h             |    0 
 .../mn10300/include/asm}/module.h                  |    0 
 .../mn10300/include/asm}/msgbuf.h                  |    0 
 .../mn10300/include/asm}/mutex.h                   |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/nmi.h |    0 
 .../mn10300/include/asm}/page.h                    |    0 
 .../mn10300/include/asm}/page_offset.h             |    0 
 .../mn10300/include/asm}/param.h                   |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/pci.h |    0 
 .../mn10300/include/asm}/percpu.h                  |    0 
 .../mn10300/include/asm}/pgalloc.h                 |    0 
 .../mn10300/include/asm}/pgtable.h                 |    0 
 .../mn10300/include/asm}/pio-regs.h                |    0 
 .../mn10300/include/asm}/poll.h                    |    0 
 .../mn10300/include/asm}/posix_types.h             |    0 
 .../mn10300/include/asm}/processor.h               |    0 
 .../mn10300/include/asm}/ptrace.h                  |    0 
 .../mn10300/include/asm}/reset-regs.h              |    0 
 .../mn10300/include/asm}/resource.h                |    0 
 .../mn10300/include/asm}/rtc-regs.h                |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/rtc.h |    0 
 .../mn10300/include/asm}/scatterlist.h             |    0 
 .../mn10300/include/asm}/sections.h                |    0 
 .../mn10300/include/asm}/sembuf.h                  |    0 
 .../mn10300/include/asm}/serial-regs.h             |    0 
 .../mn10300/include/asm}/serial.h                  |    0 
 .../mn10300/include/asm}/setup.h                   |    0 
 .../mn10300/include/asm}/shmbuf.h                  |    0 
 .../mn10300/include/asm}/shmparam.h                |    0 
 .../mn10300/include/asm}/sigcontext.h              |    0 
 .../mn10300/include/asm}/siginfo.h                 |    0 
 .../mn10300/include/asm}/signal.h                  |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/smp.h |    0 
 .../mn10300/include/asm}/socket.h                  |    0 
 .../mn10300/include/asm}/sockios.h                 |    0 
 .../mn10300/include/asm}/spinlock.h                |    0 
 .../mn10300/include/asm}/stat.h                    |    0 
 .../mn10300/include/asm}/statfs.h                  |    0 
 .../mn10300/include/asm}/string.h                  |    0 
 .../mn10300/include/asm}/system.h                  |    0 
 .../mn10300/include/asm}/termbits.h                |    0 
 .../mn10300/include/asm}/termios.h                 |    0 
 .../mn10300/include/asm}/thread_info.h             |    0 
 .../mn10300/include/asm}/timer-regs.h              |    0 
 .../mn10300/include/asm}/timex.h                   |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/tlb.h |    0 
 .../mn10300/include/asm}/tlbflush.h                |    0 
 .../mn10300/include/asm}/topology.h                |    0 
 .../mn10300/include/asm}/types.h                   |    0 
 .../mn10300/include/asm}/uaccess.h                 |    0 
 .../mn10300/include/asm}/ucontext.h                |    0 
 .../mn10300/include/asm}/unaligned.h               |    0 
 .../mn10300/include/asm}/unistd.h                  |    0 
 .../mn10300/include/asm}/user.h                    |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/vga.h |    0 
 .../asm-mn10300 => arch/mn10300/include/asm}/xor.h |    0 
 .../mn10300/proc-mn103e010/asm/proc}/cache.h       |    0 
 .../mn10300/proc-mn103e010/asm/proc}/clock.h       |    0 
 .../mn10300/proc-mn103e010/asm/proc}/irq.h         |    0 
 .../mn10300/proc-mn103e010/asm/proc}/proc.h        |    0 
 .../mn10300/unit-asb2303/asm/unit}/clock.h         |    0 
 .../mn10300/unit-asb2303/asm/unit}/leds.h          |    0 
 .../mn10300/unit-asb2303/asm/unit}/serial.h        |    0 
 .../mn10300/unit-asb2303/asm/unit}/smc91111.h      |    0 
 .../mn10300/unit-asb2303/asm/unit}/timex.h         |    0 
 .../mn10300/unit-asb2305/asm/unit}/clock.h         |    0 
 .../mn10300/unit-asb2305/asm/unit}/leds.h          |    0 
 .../mn10300/unit-asb2305/asm/unit}/serial.h        |    0 
 .../mn10300/unit-asb2305/asm/unit}/timex.h         |    0 
 121 files changed, 2 insertions(+), 39 deletions(-)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/.gitignore (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/Kbuild (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/atomic.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/auxvec.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/bitops.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/bug.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/bugs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/busctl-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/byteorder.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cache.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cacheflush.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/checksum.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cpu-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cputime.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/current.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/delay.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/device.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/div64.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/dma-mapping.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/dma.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/dmactl-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/elf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/emergency-restart.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/errno.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/exceptions.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/fb.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/fcntl.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/fpu.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/frame.inc (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/futex.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/gdb-stub.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/hardirq.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/highmem.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/hw_irq.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ide.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/intctl-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/io.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ioctl.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ioctls.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ipc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ipcbuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/irq.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/irq_regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/kdebug.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/kmap_types.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/kprobes.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/linkage.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/local.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mman.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mmu.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mmu_context.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/module.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/msgbuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mutex.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/nmi.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/page.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/page_offset.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/param.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pci.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/percpu.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pgalloc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pgtable.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pio-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/poll.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/posix_types.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/processor.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ptrace.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/reset-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/resource.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/rtc-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/rtc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/scatterlist.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sections.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sembuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/serial-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/serial.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/setup.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/shmbuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/shmparam.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sigcontext.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/siginfo.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/signal.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/smp.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/socket.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sockios.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/spinlock.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/stat.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/statfs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/string.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/system.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/termbits.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/termios.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/thread_info.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/timer-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/timex.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/tlb.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/tlbflush.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/topology.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/types.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/uaccess.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ucontext.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/unaligned.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/unistd.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/user.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/vga.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/xor.h (100%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/asm/proc}/cache.h (100%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/asm/proc}/clock.h (100%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/asm/proc}/irq.h (100%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/asm/proc}/proc.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/asm/unit}/clock.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/asm/unit}/leds.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/asm/unit}/serial.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/asm/unit}/smc91111.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/asm/unit}/timex.h (100%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/asm/unit}/clock.h (100%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/asm/unit}/leds.h (100%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/asm/unit}/serial.h (100%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/asm/unit}/timex.h (100%)

diff --git a/arch/mn10300/Makefile b/arch/mn10300/Makefile
index 6673a28..bc525b9 100644
--- a/arch/mn10300/Makefile
+++ b/arch/mn10300/Makefile
@@ -94,42 +94,5 @@ ifdef CONFIG_DEBUG_INFO
 KBUILD_AFLAGS	+= -Wa,--gdwarf2
 endif
 
-###################################################################################################
-#
-# juggle some symlinks in the MN10300 asm include dir
-#
-#	Update machine proc and unit symlinks if something which affects
-#	them changed.  We use .proc / .unit to indicate when they were
-#	updated last, otherwise make uses the target directory mtime.
-#
-###################################################################################################
-
-# processor specific definitions
-include/asm-mn10300/.proc: $(wildcard include/config/proc/*.h) include/config/auto.conf
-	@echo '  SYMLINK include/asm-mn10300/proc -> include/asm-mn10300/proc-$(PROCESSOR)'
-ifneq ($(KBUILD_SRC),)
-	$(Q)mkdir -p include/asm-mn10300
-	$(Q)ln -fsn $(srctree)/include/asm-mn10300/proc-$(PROCESSOR) include/asm-mn10300/proc
-else
-	$(Q)ln -fsn proc-$(PROCESSOR) include/asm-mn10300/proc
-endif
-	@touch $@
-
-CLEAN_FILES += include/asm-mn10300/proc include/asm-mn10300/.proc
-
-prepare: include/asm-mn10300/.proc
-
-# unit specific definitions
-include/asm-mn10300/.unit: $(wildcard include/config/unit/*.h) include/config/auto.conf
-	@echo '  SYMLINK include/asm-mn10300/unit -> include/asm-mn10300/unit-$(UNIT)'
-ifneq ($(KBUILD_SRC),)
-	$(Q)mkdir -p include/asm-mn10300
-	$(Q)ln -fsn $(srctree)/include/asm-mn10300/unit-$(UNIT) include/asm-mn10300/unit
-else
-	$(Q)ln -fsn unit-$(UNIT) include/asm-mn10300/unit
-endif
-	@touch $@
-
-CLEAN_FILES += include/asm-mn10300/unit include/asm-mn10300/.unit
-
-prepare: include/asm-mn10300/.unit
+KBUILD_CPPFLAGS += -I$(srctree)/arch/mn10300/proc-$(PROCESSOR)
+KBUILD_CPPFLAGS += -I$(srctree)/arch/mn10300/unit-$(UNIT)
diff --git a/include/asm-mn10300/.gitignore b/arch/mn10300/include/asm/.gitignore
similarity index 100%
rename from include/asm-mn10300/.gitignore
rename to arch/mn10300/include/asm/.gitignore
diff --git a/include/asm-mn10300/Kbuild b/arch/mn10300/include/asm/Kbuild
similarity index 100%
rename from include/asm-mn10300/Kbuild
rename to arch/mn10300/include/asm/Kbuild
diff --git a/include/asm-mn10300/atomic.h b/arch/mn10300/include/asm/atomic.h
similarity index 100%
rename from include/asm-mn10300/atomic.h
rename to arch/mn10300/include/asm/atomic.h
diff --git a/include/asm-mn10300/auxvec.h b/arch/mn10300/include/asm/auxvec.h
similarity index 100%
rename from include/asm-mn10300/auxvec.h
rename to arch/mn10300/include/asm/auxvec.h
diff --git a/include/asm-mn10300/bitops.h b/arch/mn10300/include/asm/bitops.h
similarity index 100%
rename from include/asm-mn10300/bitops.h
rename to arch/mn10300/include/asm/bitops.h
diff --git a/include/asm-mn10300/bug.h b/arch/mn10300/include/asm/bug.h
similarity index 100%
rename from include/asm-mn10300/bug.h
rename to arch/mn10300/include/asm/bug.h
diff --git a/include/asm-mn10300/bugs.h b/arch/mn10300/include/asm/bugs.h
similarity index 100%
rename from include/asm-mn10300/bugs.h
rename to arch/mn10300/include/asm/bugs.h
diff --git a/include/asm-mn10300/busctl-regs.h b/arch/mn10300/include/asm/busctl-regs.h
similarity index 100%
rename from include/asm-mn10300/busctl-regs.h
rename to arch/mn10300/include/asm/busctl-regs.h
diff --git a/include/asm-mn10300/byteorder.h b/arch/mn10300/include/asm/byteorder.h
similarity index 100%
rename from include/asm-mn10300/byteorder.h
rename to arch/mn10300/include/asm/byteorder.h
diff --git a/include/asm-mn10300/cache.h b/arch/mn10300/include/asm/cache.h
similarity index 100%
rename from include/asm-mn10300/cache.h
rename to arch/mn10300/include/asm/cache.h
diff --git a/include/asm-mn10300/cacheflush.h b/arch/mn10300/include/asm/cacheflush.h
similarity index 100%
rename from include/asm-mn10300/cacheflush.h
rename to arch/mn10300/include/asm/cacheflush.h
diff --git a/include/asm-mn10300/checksum.h b/arch/mn10300/include/asm/checksum.h
similarity index 100%
rename from include/asm-mn10300/checksum.h
rename to arch/mn10300/include/asm/checksum.h
diff --git a/include/asm-mn10300/cpu-regs.h b/arch/mn10300/include/asm/cpu-regs.h
similarity index 100%
rename from include/asm-mn10300/cpu-regs.h
rename to arch/mn10300/include/asm/cpu-regs.h
diff --git a/include/asm-mn10300/cputime.h b/arch/mn10300/include/asm/cputime.h
similarity index 100%
rename from include/asm-mn10300/cputime.h
rename to arch/mn10300/include/asm/cputime.h
diff --git a/include/asm-mn10300/current.h b/arch/mn10300/include/asm/current.h
similarity index 100%
rename from include/asm-mn10300/current.h
rename to arch/mn10300/include/asm/current.h
diff --git a/include/asm-mn10300/delay.h b/arch/mn10300/include/asm/delay.h
similarity index 100%
rename from include/asm-mn10300/delay.h
rename to arch/mn10300/include/asm/delay.h
diff --git a/include/asm-mn10300/device.h b/arch/mn10300/include/asm/device.h
similarity index 100%
rename from include/asm-mn10300/device.h
rename to arch/mn10300/include/asm/device.h
diff --git a/include/asm-mn10300/div64.h b/arch/mn10300/include/asm/div64.h
similarity index 100%
rename from include/asm-mn10300/div64.h
rename to arch/mn10300/include/asm/div64.h
diff --git a/include/asm-mn10300/dma-mapping.h b/arch/mn10300/include/asm/dma-mapping.h
similarity index 100%
rename from include/asm-mn10300/dma-mapping.h
rename to arch/mn10300/include/asm/dma-mapping.h
diff --git a/include/asm-mn10300/dma.h b/arch/mn10300/include/asm/dma.h
similarity index 100%
rename from include/asm-mn10300/dma.h
rename to arch/mn10300/include/asm/dma.h
diff --git a/include/asm-mn10300/dmactl-regs.h b/arch/mn10300/include/asm/dmactl-regs.h
similarity index 100%
rename from include/asm-mn10300/dmactl-regs.h
rename to arch/mn10300/include/asm/dmactl-regs.h
diff --git a/include/asm-mn10300/elf.h b/arch/mn10300/include/asm/elf.h
similarity index 100%
rename from include/asm-mn10300/elf.h
rename to arch/mn10300/include/asm/elf.h
diff --git a/include/asm-mn10300/emergency-restart.h b/arch/mn10300/include/asm/emergency-restart.h
similarity index 100%
rename from include/asm-mn10300/emergency-restart.h
rename to arch/mn10300/include/asm/emergency-restart.h
diff --git a/include/asm-mn10300/errno.h b/arch/mn10300/include/asm/errno.h
similarity index 100%
rename from include/asm-mn10300/errno.h
rename to arch/mn10300/include/asm/errno.h
diff --git a/include/asm-mn10300/exceptions.h b/arch/mn10300/include/asm/exceptions.h
similarity index 100%
rename from include/asm-mn10300/exceptions.h
rename to arch/mn10300/include/asm/exceptions.h
diff --git a/include/asm-mn10300/fb.h b/arch/mn10300/include/asm/fb.h
similarity index 100%
rename from include/asm-mn10300/fb.h
rename to arch/mn10300/include/asm/fb.h
diff --git a/include/asm-mn10300/fcntl.h b/arch/mn10300/include/asm/fcntl.h
similarity index 100%
rename from include/asm-mn10300/fcntl.h
rename to arch/mn10300/include/asm/fcntl.h
diff --git a/include/asm-mn10300/fpu.h b/arch/mn10300/include/asm/fpu.h
similarity index 100%
rename from include/asm-mn10300/fpu.h
rename to arch/mn10300/include/asm/fpu.h
diff --git a/include/asm-mn10300/frame.inc b/arch/mn10300/include/asm/frame.inc
similarity index 100%
rename from include/asm-mn10300/frame.inc
rename to arch/mn10300/include/asm/frame.inc
diff --git a/include/asm-mn10300/futex.h b/arch/mn10300/include/asm/futex.h
similarity index 100%
rename from include/asm-mn10300/futex.h
rename to arch/mn10300/include/asm/futex.h
diff --git a/include/asm-mn10300/gdb-stub.h b/arch/mn10300/include/asm/gdb-stub.h
similarity index 100%
rename from include/asm-mn10300/gdb-stub.h
rename to arch/mn10300/include/asm/gdb-stub.h
diff --git a/include/asm-mn10300/hardirq.h b/arch/mn10300/include/asm/hardirq.h
similarity index 100%
rename from include/asm-mn10300/hardirq.h
rename to arch/mn10300/include/asm/hardirq.h
diff --git a/include/asm-mn10300/highmem.h b/arch/mn10300/include/asm/highmem.h
similarity index 100%
rename from include/asm-mn10300/highmem.h
rename to arch/mn10300/include/asm/highmem.h
diff --git a/include/asm-mn10300/hw_irq.h b/arch/mn10300/include/asm/hw_irq.h
similarity index 100%
rename from include/asm-mn10300/hw_irq.h
rename to arch/mn10300/include/asm/hw_irq.h
diff --git a/include/asm-mn10300/ide.h b/arch/mn10300/include/asm/ide.h
similarity index 100%
rename from include/asm-mn10300/ide.h
rename to arch/mn10300/include/asm/ide.h
diff --git a/include/asm-mn10300/intctl-regs.h b/arch/mn10300/include/asm/intctl-regs.h
similarity index 100%
rename from include/asm-mn10300/intctl-regs.h
rename to arch/mn10300/include/asm/intctl-regs.h
diff --git a/include/asm-mn10300/io.h b/arch/mn10300/include/asm/io.h
similarity index 100%
rename from include/asm-mn10300/io.h
rename to arch/mn10300/include/asm/io.h
diff --git a/include/asm-mn10300/ioctl.h b/arch/mn10300/include/asm/ioctl.h
similarity index 100%
rename from include/asm-mn10300/ioctl.h
rename to arch/mn10300/include/asm/ioctl.h
diff --git a/include/asm-mn10300/ioctls.h b/arch/mn10300/include/asm/ioctls.h
similarity index 100%
rename from include/asm-mn10300/ioctls.h
rename to arch/mn10300/include/asm/ioctls.h
diff --git a/include/asm-mn10300/ipc.h b/arch/mn10300/include/asm/ipc.h
similarity index 100%
rename from include/asm-mn10300/ipc.h
rename to arch/mn10300/include/asm/ipc.h
diff --git a/include/asm-mn10300/ipcbuf.h b/arch/mn10300/include/asm/ipcbuf.h
similarity index 100%
rename from include/asm-mn10300/ipcbuf.h
rename to arch/mn10300/include/asm/ipcbuf.h
diff --git a/include/asm-mn10300/irq.h b/arch/mn10300/include/asm/irq.h
similarity index 100%
rename from include/asm-mn10300/irq.h
rename to arch/mn10300/include/asm/irq.h
diff --git a/include/asm-mn10300/irq_regs.h b/arch/mn10300/include/asm/irq_regs.h
similarity index 100%
rename from include/asm-mn10300/irq_regs.h
rename to arch/mn10300/include/asm/irq_regs.h
diff --git a/include/asm-mn10300/kdebug.h b/arch/mn10300/include/asm/kdebug.h
similarity index 100%
rename from include/asm-mn10300/kdebug.h
rename to arch/mn10300/include/asm/kdebug.h
diff --git a/include/asm-mn10300/kmap_types.h b/arch/mn10300/include/asm/kmap_types.h
similarity index 100%
rename from include/asm-mn10300/kmap_types.h
rename to arch/mn10300/include/asm/kmap_types.h
diff --git a/include/asm-mn10300/kprobes.h b/arch/mn10300/include/asm/kprobes.h
similarity index 100%
rename from include/asm-mn10300/kprobes.h
rename to arch/mn10300/include/asm/kprobes.h
diff --git a/include/asm-mn10300/linkage.h b/arch/mn10300/include/asm/linkage.h
similarity index 100%
rename from include/asm-mn10300/linkage.h
rename to arch/mn10300/include/asm/linkage.h
diff --git a/include/asm-mn10300/local.h b/arch/mn10300/include/asm/local.h
similarity index 100%
rename from include/asm-mn10300/local.h
rename to arch/mn10300/include/asm/local.h
diff --git a/include/asm-mn10300/mc146818rtc.h b/arch/mn10300/include/asm/mc146818rtc.h
similarity index 100%
rename from include/asm-mn10300/mc146818rtc.h
rename to arch/mn10300/include/asm/mc146818rtc.h
diff --git a/include/asm-mn10300/mman.h b/arch/mn10300/include/asm/mman.h
similarity index 100%
rename from include/asm-mn10300/mman.h
rename to arch/mn10300/include/asm/mman.h
diff --git a/include/asm-mn10300/mmu.h b/arch/mn10300/include/asm/mmu.h
similarity index 100%
rename from include/asm-mn10300/mmu.h
rename to arch/mn10300/include/asm/mmu.h
diff --git a/include/asm-mn10300/mmu_context.h b/arch/mn10300/include/asm/mmu_context.h
similarity index 100%
rename from include/asm-mn10300/mmu_context.h
rename to arch/mn10300/include/asm/mmu_context.h
diff --git a/include/asm-mn10300/module.h b/arch/mn10300/include/asm/module.h
similarity index 100%
rename from include/asm-mn10300/module.h
rename to arch/mn10300/include/asm/module.h
diff --git a/include/asm-mn10300/msgbuf.h b/arch/mn10300/include/asm/msgbuf.h
similarity index 100%
rename from include/asm-mn10300/msgbuf.h
rename to arch/mn10300/include/asm/msgbuf.h
diff --git a/include/asm-mn10300/mutex.h b/arch/mn10300/include/asm/mutex.h
similarity index 100%
rename from include/asm-mn10300/mutex.h
rename to arch/mn10300/include/asm/mutex.h
diff --git a/include/asm-mn10300/nmi.h b/arch/mn10300/include/asm/nmi.h
similarity index 100%
rename from include/asm-mn10300/nmi.h
rename to arch/mn10300/include/asm/nmi.h
diff --git a/include/asm-mn10300/page.h b/arch/mn10300/include/asm/page.h
similarity index 100%
rename from include/asm-mn10300/page.h
rename to arch/mn10300/include/asm/page.h
diff --git a/include/asm-mn10300/page_offset.h b/arch/mn10300/include/asm/page_offset.h
similarity index 100%
rename from include/asm-mn10300/page_offset.h
rename to arch/mn10300/include/asm/page_offset.h
diff --git a/include/asm-mn10300/param.h b/arch/mn10300/include/asm/param.h
similarity index 100%
rename from include/asm-mn10300/param.h
rename to arch/mn10300/include/asm/param.h
diff --git a/include/asm-mn10300/pci.h b/arch/mn10300/include/asm/pci.h
similarity index 100%
rename from include/asm-mn10300/pci.h
rename to arch/mn10300/include/asm/pci.h
diff --git a/include/asm-mn10300/percpu.h b/arch/mn10300/include/asm/percpu.h
similarity index 100%
rename from include/asm-mn10300/percpu.h
rename to arch/mn10300/include/asm/percpu.h
diff --git a/include/asm-mn10300/pgalloc.h b/arch/mn10300/include/asm/pgalloc.h
similarity index 100%
rename from include/asm-mn10300/pgalloc.h
rename to arch/mn10300/include/asm/pgalloc.h
diff --git a/include/asm-mn10300/pgtable.h b/arch/mn10300/include/asm/pgtable.h
similarity index 100%
rename from include/asm-mn10300/pgtable.h
rename to arch/mn10300/include/asm/pgtable.h
diff --git a/include/asm-mn10300/pio-regs.h b/arch/mn10300/include/asm/pio-regs.h
similarity index 100%
rename from include/asm-mn10300/pio-regs.h
rename to arch/mn10300/include/asm/pio-regs.h
diff --git a/include/asm-mn10300/poll.h b/arch/mn10300/include/asm/poll.h
similarity index 100%
rename from include/asm-mn10300/poll.h
rename to arch/mn10300/include/asm/poll.h
diff --git a/include/asm-mn10300/posix_types.h b/arch/mn10300/include/asm/posix_types.h
similarity index 100%
rename from include/asm-mn10300/posix_types.h
rename to arch/mn10300/include/asm/posix_types.h
diff --git a/include/asm-mn10300/processor.h b/arch/mn10300/include/asm/processor.h
similarity index 100%
rename from include/asm-mn10300/processor.h
rename to arch/mn10300/include/asm/processor.h
diff --git a/include/asm-mn10300/ptrace.h b/arch/mn10300/include/asm/ptrace.h
similarity index 100%
rename from include/asm-mn10300/ptrace.h
rename to arch/mn10300/include/asm/ptrace.h
diff --git a/include/asm-mn10300/reset-regs.h b/arch/mn10300/include/asm/reset-regs.h
similarity index 100%
rename from include/asm-mn10300/reset-regs.h
rename to arch/mn10300/include/asm/reset-regs.h
diff --git a/include/asm-mn10300/resource.h b/arch/mn10300/include/asm/resource.h
similarity index 100%
rename from include/asm-mn10300/resource.h
rename to arch/mn10300/include/asm/resource.h
diff --git a/include/asm-mn10300/rtc-regs.h b/arch/mn10300/include/asm/rtc-regs.h
similarity index 100%
rename from include/asm-mn10300/rtc-regs.h
rename to arch/mn10300/include/asm/rtc-regs.h
diff --git a/include/asm-mn10300/rtc.h b/arch/mn10300/include/asm/rtc.h
similarity index 100%
rename from include/asm-mn10300/rtc.h
rename to arch/mn10300/include/asm/rtc.h
diff --git a/include/asm-mn10300/scatterlist.h b/arch/mn10300/include/asm/scatterlist.h
similarity index 100%
rename from include/asm-mn10300/scatterlist.h
rename to arch/mn10300/include/asm/scatterlist.h
diff --git a/include/asm-mn10300/sections.h b/arch/mn10300/include/asm/sections.h
similarity index 100%
rename from include/asm-mn10300/sections.h
rename to arch/mn10300/include/asm/sections.h
diff --git a/include/asm-mn10300/sembuf.h b/arch/mn10300/include/asm/sembuf.h
similarity index 100%
rename from include/asm-mn10300/sembuf.h
rename to arch/mn10300/include/asm/sembuf.h
diff --git a/include/asm-mn10300/serial-regs.h b/arch/mn10300/include/asm/serial-regs.h
similarity index 100%
rename from include/asm-mn10300/serial-regs.h
rename to arch/mn10300/include/asm/serial-regs.h
diff --git a/include/asm-mn10300/serial.h b/arch/mn10300/include/asm/serial.h
similarity index 100%
rename from include/asm-mn10300/serial.h
rename to arch/mn10300/include/asm/serial.h
diff --git a/include/asm-mn10300/setup.h b/arch/mn10300/include/asm/setup.h
similarity index 100%
rename from include/asm-mn10300/setup.h
rename to arch/mn10300/include/asm/setup.h
diff --git a/include/asm-mn10300/shmbuf.h b/arch/mn10300/include/asm/shmbuf.h
similarity index 100%
rename from include/asm-mn10300/shmbuf.h
rename to arch/mn10300/include/asm/shmbuf.h
diff --git a/include/asm-mn10300/shmparam.h b/arch/mn10300/include/asm/shmparam.h
similarity index 100%
rename from include/asm-mn10300/shmparam.h
rename to arch/mn10300/include/asm/shmparam.h
diff --git a/include/asm-mn10300/sigcontext.h b/arch/mn10300/include/asm/sigcontext.h
similarity index 100%
rename from include/asm-mn10300/sigcontext.h
rename to arch/mn10300/include/asm/sigcontext.h
diff --git a/include/asm-mn10300/siginfo.h b/arch/mn10300/include/asm/siginfo.h
similarity index 100%
rename from include/asm-mn10300/siginfo.h
rename to arch/mn10300/include/asm/siginfo.h
diff --git a/include/asm-mn10300/signal.h b/arch/mn10300/include/asm/signal.h
similarity index 100%
rename from include/asm-mn10300/signal.h
rename to arch/mn10300/include/asm/signal.h
diff --git a/include/asm-mn10300/smp.h b/arch/mn10300/include/asm/smp.h
similarity index 100%
rename from include/asm-mn10300/smp.h
rename to arch/mn10300/include/asm/smp.h
diff --git a/include/asm-mn10300/socket.h b/arch/mn10300/include/asm/socket.h
similarity index 100%
rename from include/asm-mn10300/socket.h
rename to arch/mn10300/include/asm/socket.h
diff --git a/include/asm-mn10300/sockios.h b/arch/mn10300/include/asm/sockios.h
similarity index 100%
rename from include/asm-mn10300/sockios.h
rename to arch/mn10300/include/asm/sockios.h
diff --git a/include/asm-mn10300/spinlock.h b/arch/mn10300/include/asm/spinlock.h
similarity index 100%
rename from include/asm-mn10300/spinlock.h
rename to arch/mn10300/include/asm/spinlock.h
diff --git a/include/asm-mn10300/stat.h b/arch/mn10300/include/asm/stat.h
similarity index 100%
rename from include/asm-mn10300/stat.h
rename to arch/mn10300/include/asm/stat.h
diff --git a/include/asm-mn10300/statfs.h b/arch/mn10300/include/asm/statfs.h
similarity index 100%
rename from include/asm-mn10300/statfs.h
rename to arch/mn10300/include/asm/statfs.h
diff --git a/include/asm-mn10300/string.h b/arch/mn10300/include/asm/string.h
similarity index 100%
rename from include/asm-mn10300/string.h
rename to arch/mn10300/include/asm/string.h
diff --git a/include/asm-mn10300/system.h b/arch/mn10300/include/asm/system.h
similarity index 100%
rename from include/asm-mn10300/system.h
rename to arch/mn10300/include/asm/system.h
diff --git a/include/asm-mn10300/termbits.h b/arch/mn10300/include/asm/termbits.h
similarity index 100%
rename from include/asm-mn10300/termbits.h
rename to arch/mn10300/include/asm/termbits.h
diff --git a/include/asm-mn10300/termios.h b/arch/mn10300/include/asm/termios.h
similarity index 100%
rename from include/asm-mn10300/termios.h
rename to arch/mn10300/include/asm/termios.h
diff --git a/include/asm-mn10300/thread_info.h b/arch/mn10300/include/asm/thread_info.h
similarity index 100%
rename from include/asm-mn10300/thread_info.h
rename to arch/mn10300/include/asm/thread_info.h
diff --git a/include/asm-mn10300/timer-regs.h b/arch/mn10300/include/asm/timer-regs.h
similarity index 100%
rename from include/asm-mn10300/timer-regs.h
rename to arch/mn10300/include/asm/timer-regs.h
diff --git a/include/asm-mn10300/timex.h b/arch/mn10300/include/asm/timex.h
similarity index 100%
rename from include/asm-mn10300/timex.h
rename to arch/mn10300/include/asm/timex.h
diff --git a/include/asm-mn10300/tlb.h b/arch/mn10300/include/asm/tlb.h
similarity index 100%
rename from include/asm-mn10300/tlb.h
rename to arch/mn10300/include/asm/tlb.h
diff --git a/include/asm-mn10300/tlbflush.h b/arch/mn10300/include/asm/tlbflush.h
similarity index 100%
rename from include/asm-mn10300/tlbflush.h
rename to arch/mn10300/include/asm/tlbflush.h
diff --git a/include/asm-mn10300/topology.h b/arch/mn10300/include/asm/topology.h
similarity index 100%
rename from include/asm-mn10300/topology.h
rename to arch/mn10300/include/asm/topology.h
diff --git a/include/asm-mn10300/types.h b/arch/mn10300/include/asm/types.h
similarity index 100%
rename from include/asm-mn10300/types.h
rename to arch/mn10300/include/asm/types.h
diff --git a/include/asm-mn10300/uaccess.h b/arch/mn10300/include/asm/uaccess.h
similarity index 100%
rename from include/asm-mn10300/uaccess.h
rename to arch/mn10300/include/asm/uaccess.h
diff --git a/include/asm-mn10300/ucontext.h b/arch/mn10300/include/asm/ucontext.h
similarity index 100%
rename from include/asm-mn10300/ucontext.h
rename to arch/mn10300/include/asm/ucontext.h
diff --git a/include/asm-mn10300/unaligned.h b/arch/mn10300/include/asm/unaligned.h
similarity index 100%
rename from include/asm-mn10300/unaligned.h
rename to arch/mn10300/include/asm/unaligned.h
diff --git a/include/asm-mn10300/unistd.h b/arch/mn10300/include/asm/unistd.h
similarity index 100%
rename from include/asm-mn10300/unistd.h
rename to arch/mn10300/include/asm/unistd.h
diff --git a/include/asm-mn10300/user.h b/arch/mn10300/include/asm/user.h
similarity index 100%
rename from include/asm-mn10300/user.h
rename to arch/mn10300/include/asm/user.h
diff --git a/include/asm-mn10300/vga.h b/arch/mn10300/include/asm/vga.h
similarity index 100%
rename from include/asm-mn10300/vga.h
rename to arch/mn10300/include/asm/vga.h
diff --git a/include/asm-mn10300/xor.h b/arch/mn10300/include/asm/xor.h
similarity index 100%
rename from include/asm-mn10300/xor.h
rename to arch/mn10300/include/asm/xor.h
diff --git a/include/asm-mn10300/proc-mn103e010/cache.h b/arch/mn10300/proc-mn103e010/asm/proc/cache.h
similarity index 100%
rename from include/asm-mn10300/proc-mn103e010/cache.h
rename to arch/mn10300/proc-mn103e010/asm/proc/cache.h
diff --git a/include/asm-mn10300/proc-mn103e010/clock.h b/arch/mn10300/proc-mn103e010/asm/proc/clock.h
similarity index 100%
rename from include/asm-mn10300/proc-mn103e010/clock.h
rename to arch/mn10300/proc-mn103e010/asm/proc/clock.h
diff --git a/include/asm-mn10300/proc-mn103e010/irq.h b/arch/mn10300/proc-mn103e010/asm/proc/irq.h
similarity index 100%
rename from include/asm-mn10300/proc-mn103e010/irq.h
rename to arch/mn10300/proc-mn103e010/asm/proc/irq.h
diff --git a/include/asm-mn10300/proc-mn103e010/proc.h b/arch/mn10300/proc-mn103e010/asm/proc/proc.h
similarity index 100%
rename from include/asm-mn10300/proc-mn103e010/proc.h
rename to arch/mn10300/proc-mn103e010/asm/proc/proc.h
diff --git a/include/asm-mn10300/unit-asb2303/clock.h b/arch/mn10300/unit-asb2303/asm/unit/clock.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2303/clock.h
rename to arch/mn10300/unit-asb2303/asm/unit/clock.h
diff --git a/include/asm-mn10300/unit-asb2303/leds.h b/arch/mn10300/unit-asb2303/asm/unit/leds.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2303/leds.h
rename to arch/mn10300/unit-asb2303/asm/unit/leds.h
diff --git a/include/asm-mn10300/unit-asb2303/serial.h b/arch/mn10300/unit-asb2303/asm/unit/serial.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2303/serial.h
rename to arch/mn10300/unit-asb2303/asm/unit/serial.h
diff --git a/include/asm-mn10300/unit-asb2303/smc91111.h b/arch/mn10300/unit-asb2303/asm/unit/smc91111.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2303/smc91111.h
rename to arch/mn10300/unit-asb2303/asm/unit/smc91111.h
diff --git a/include/asm-mn10300/unit-asb2303/timex.h b/arch/mn10300/unit-asb2303/asm/unit/timex.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2303/timex.h
rename to arch/mn10300/unit-asb2303/asm/unit/timex.h
diff --git a/include/asm-mn10300/unit-asb2305/clock.h b/arch/mn10300/unit-asb2305/asm/unit/clock.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2305/clock.h
rename to arch/mn10300/unit-asb2305/asm/unit/clock.h
diff --git a/include/asm-mn10300/unit-asb2305/leds.h b/arch/mn10300/unit-asb2305/asm/unit/leds.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2305/leds.h
rename to arch/mn10300/unit-asb2305/asm/unit/leds.h
diff --git a/include/asm-mn10300/unit-asb2305/serial.h b/arch/mn10300/unit-asb2305/asm/unit/serial.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2305/serial.h
rename to arch/mn10300/unit-asb2305/asm/unit/serial.h
diff --git a/include/asm-mn10300/unit-asb2305/timex.h b/arch/mn10300/unit-asb2305/asm/unit/timex.h
similarity index 100%
rename from include/asm-mn10300/unit-asb2305/timex.h
rename to arch/mn10300/unit-asb2305/asm/unit/timex.h
-- 
1.5.6.5


>From 70db157f6f52d0fccde164fb8ebf9f30d9c51b2e Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 17 Dec 2008 11:46:02 -0500
Subject: [PATCH] mn10300 header move, part 2

switch asm/proc to proc, asm/unit to unit and move directories one level
towards root

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/include/asm/cache.h                   |    2 +-
 arch/mn10300/include/asm/irq.h                     |    2 +-
 arch/mn10300/include/asm/serial.h                  |    2 +-
 arch/mn10300/include/asm/timex.h                   |    2 +-
 arch/mn10300/kernel/entry.S                        |    2 +-
 arch/mn10300/kernel/gdb-io-serial-low.S            |    2 +-
 arch/mn10300/kernel/gdb-io-serial.c                |    2 +-
 arch/mn10300/kernel/gdb-io-ttysm-low.S             |    2 +-
 arch/mn10300/kernel/gdb-io-ttysm.c                 |    2 +-
 arch/mn10300/kernel/gdb-stub.c                     |    4 ++--
 arch/mn10300/kernel/head.S                         |    2 +-
 arch/mn10300/kernel/mn10300-serial-low.S           |    4 ++--
 arch/mn10300/kernel/mn10300-serial.c               |    2 +-
 arch/mn10300/kernel/mn10300-watchdog.c             |    2 +-
 arch/mn10300/kernel/setup.c                        |    2 +-
 arch/mn10300/kernel/traps.c                        |    2 +-
 arch/mn10300/proc-mn103e010/{asm => }/proc/cache.h |    0 
 arch/mn10300/proc-mn103e010/{asm => }/proc/clock.h |    2 +-
 arch/mn10300/proc-mn103e010/{asm => }/proc/irq.h   |    0 
 arch/mn10300/proc-mn103e010/{asm => }/proc/proc.h  |    0 
 arch/mn10300/unit-asb2303/leds.c                   |    2 +-
 arch/mn10300/unit-asb2303/smc91111.c               |    2 +-
 arch/mn10300/unit-asb2303/{asm => }/unit/clock.h   |    0 
 arch/mn10300/unit-asb2303/{asm => }/unit/leds.h    |    0 
 arch/mn10300/unit-asb2303/{asm => }/unit/serial.h  |    2 +-
 .../mn10300/unit-asb2303/{asm => }/unit/smc91111.h |    0 
 arch/mn10300/unit-asb2303/{asm => }/unit/timex.h   |    2 +-
 arch/mn10300/unit-asb2305/leds.c                   |    2 +-
 arch/mn10300/unit-asb2305/unit-init.c              |    2 +-
 arch/mn10300/unit-asb2305/{asm => }/unit/clock.h   |    0 
 arch/mn10300/unit-asb2305/{asm => }/unit/leds.h    |    0 
 arch/mn10300/unit-asb2305/{asm => }/unit/serial.h  |    2 +-
 arch/mn10300/unit-asb2305/{asm => }/unit/timex.h   |    2 +-
 drivers/net/smc91x.h                               |    2 +-
 34 files changed, 28 insertions(+), 28 deletions(-)
 rename arch/mn10300/proc-mn103e010/{asm => }/proc/cache.h (100%)
 rename arch/mn10300/proc-mn103e010/{asm => }/proc/clock.h (94%)
 rename arch/mn10300/proc-mn103e010/{asm => }/proc/irq.h (100%)
 rename arch/mn10300/proc-mn103e010/{asm => }/proc/proc.h (100%)
 rename arch/mn10300/unit-asb2303/{asm => }/unit/clock.h (100%)
 rename arch/mn10300/unit-asb2303/{asm => }/unit/leds.h (100%)
 rename arch/mn10300/unit-asb2303/{asm => }/unit/serial.h (99%)
 rename arch/mn10300/unit-asb2303/{asm => }/unit/smc91111.h (100%)
 rename arch/mn10300/unit-asb2303/{asm => }/unit/timex.h (98%)
 rename arch/mn10300/unit-asb2305/{asm => }/unit/clock.h (100%)
 rename arch/mn10300/unit-asb2305/{asm => }/unit/leds.h (100%)
 rename arch/mn10300/unit-asb2305/{asm => }/unit/serial.h (99%)
 rename arch/mn10300/unit-asb2305/{asm => }/unit/timex.h (98%)

diff --git a/arch/mn10300/include/asm/cache.h b/arch/mn10300/include/asm/cache.h
index 9e01122..e03cfa2 100644
--- a/arch/mn10300/include/asm/cache.h
+++ b/arch/mn10300/include/asm/cache.h
@@ -13,7 +13,7 @@
 #define _ASM_CACHE_H
 
 #include <asm/cpu-regs.h>
-#include <asm/proc/cache.h>
+#include <proc/cache.h>
 
 #ifndef __ASSEMBLY__
 #define L1_CACHE_DISPARITY	(L1_CACHE_NENTRIES * L1_CACHE_BYTES)
diff --git a/arch/mn10300/include/asm/irq.h b/arch/mn10300/include/asm/irq.h
index 53b3801..25c045d 100644
--- a/arch/mn10300/include/asm/irq.h
+++ b/arch/mn10300/include/asm/irq.h
@@ -16,7 +16,7 @@
 
 #include <asm/intctl-regs.h>
 #include <asm/reset-regs.h>
-#include <asm/proc/irq.h>
+#include <proc/irq.h>
 
 /* this number is used when no interrupt has been assigned */
 #define NO_IRQ		INT_MAX
diff --git a/arch/mn10300/include/asm/serial.h b/arch/mn10300/include/asm/serial.h
index 99785a9..a29445c 100644
--- a/arch/mn10300/include/asm/serial.h
+++ b/arch/mn10300/include/asm/serial.h
@@ -33,4 +33,4 @@
 #define RS_TABLE_SIZE
 #endif
 
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
diff --git a/arch/mn10300/include/asm/timex.h b/arch/mn10300/include/asm/timex.h
index 3944277..8d031f9 100644
--- a/arch/mn10300/include/asm/timex.h
+++ b/arch/mn10300/include/asm/timex.h
@@ -12,7 +12,7 @@
 #define _ASM_TIMEX_H
 
 #include <asm/hardirq.h>
-#include <asm/unit/timex.h>
+#include <unit/timex.h>
 
 #define TICK_SIZE (tick_nsec / 1000)
 
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 62fba8a..af6eb00 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -20,7 +20,7 @@
 #include <asm/intctl-regs.h>
 #include <asm/busctl-regs.h>
 #include <asm/timer-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/errno.h>
diff --git a/arch/mn10300/kernel/gdb-io-serial-low.S b/arch/mn10300/kernel/gdb-io-serial-low.S
index c68dcd0..4998b24 100644
--- a/arch/mn10300/kernel/gdb-io-serial-low.S
+++ b/arch/mn10300/kernel/gdb-io-serial-low.S
@@ -18,7 +18,7 @@
 #include <asm/thread_info.h>
 #include <asm/frame.inc>
 #include <asm/intctl-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 	.text
 
diff --git a/arch/mn10300/kernel/gdb-io-serial.c b/arch/mn10300/kernel/gdb-io-serial.c
index 11584c5..ae663dc 100644
--- a/arch/mn10300/kernel/gdb-io-serial.c
+++ b/arch/mn10300/kernel/gdb-io-serial.c
@@ -22,7 +22,7 @@
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <asm/serial-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 /*
  * initialise the GDB stub
diff --git a/arch/mn10300/kernel/gdb-io-ttysm-low.S b/arch/mn10300/kernel/gdb-io-ttysm-low.S
index 677c787..060b7cc 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm-low.S
+++ b/arch/mn10300/kernel/gdb-io-ttysm-low.S
@@ -18,7 +18,7 @@
 #include <asm/cpu-regs.h>
 #include <asm/frame.inc>
 #include <asm/intctl-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 #include "mn10300-serial.h"
 
 	.text
diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
index e94c25e..a560bbc 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ b/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -20,7 +20,7 @@
 #include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
-#include <asm/unit/clock.h>
+#include <unit/clock.h>
 #include "mn10300-serial.h"
 
 #if defined(CONFIG_GDBSTUB_ON_TTYSM0)
diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 0ea7482..41b1170 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -136,8 +136,8 @@
 #include <asm/cacheflush.h>
 #include <asm/serial-regs.h>
 #include <asm/busctl-regs.h>
-#include <asm/unit/leds.h>
-#include <asm/unit/serial.h>
+#include <unit/leds.h>
+#include <unit/serial.h>
 
 /* define to use F7F7 rather than FF which is subverted by JTAG debugger */
 #undef GDBSTUB_USE_F7F7_AS_BREAKPOINT
diff --git a/arch/mn10300/kernel/head.S b/arch/mn10300/kernel/head.S
index 606bd8c..8a8309f 100644
--- a/arch/mn10300/kernel/head.S
+++ b/arch/mn10300/kernel/head.S
@@ -17,7 +17,7 @@
 #include <asm/pgtable.h>
 #include <asm/frame.inc>
 #include <asm/param.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 	.section .text.head,"ax"
 
diff --git a/arch/mn10300/kernel/mn10300-serial-low.S b/arch/mn10300/kernel/mn10300-serial-low.S
index ef3f4c1..2244853 100644
--- a/arch/mn10300/kernel/mn10300-serial-low.S
+++ b/arch/mn10300/kernel/mn10300-serial-low.S
@@ -18,8 +18,8 @@
 #include <asm/cpu-regs.h>
 #include <asm/frame.inc>
 #include <asm/timer-regs.h>
-#include <asm/proc/cache.h>
-#include <asm/unit/timex.h>
+#include <proc/cache.h>
+#include <unit/timex.h>
 #include "mn10300-serial.h"
 
 #define	SCxCTR	0x00
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 59b9c4b..2fd5966 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -41,7 +41,7 @@ static const char serial_revdate[] = "2007-11-06";
 #include <asm/irq.h>
 #include <asm/bitops.h>
 #include <asm/serial-regs.h>
-#include <asm/unit/timex.h>
+#include <unit/timex.h>
 #include "mn10300-serial.h"
 
 static inline __attribute__((format(printf, 1, 2)))
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index 10811e9..8003e8b 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -25,7 +25,7 @@
 #include <asm/div64.h>
 #include <asm/smp.h>
 #include <asm/gdb-stub.h>
-#include <asm/proc/clock.h>
+#include <proc/clock.h>
 
 static DEFINE_SPINLOCK(watchdog_print_lock);
 static unsigned int watchdog;
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index e1d88ab..71414e1 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -30,7 +30,7 @@
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-#include <asm/proc/proc.h>
+#include <proc/proc.h>
 #include <asm/busctl-regs.h>
 #include <asm/fpu.h>
 #include <asm/sections.h>
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index fcb9a03..681ad8c 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -37,7 +37,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpu-regs.h>
 #include <asm/busctl-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 #include <asm/fpu.h>
 #include <asm/gdb-stub.h>
 #include <asm/sections.h>
diff --git a/arch/mn10300/proc-mn103e010/asm/proc/cache.h b/arch/mn10300/proc-mn103e010/proc/cache.h
similarity index 100%
rename from arch/mn10300/proc-mn103e010/asm/proc/cache.h
rename to arch/mn10300/proc-mn103e010/proc/cache.h
diff --git a/arch/mn10300/proc-mn103e010/asm/proc/clock.h b/arch/mn10300/proc-mn103e010/proc/clock.h
similarity index 94%
rename from arch/mn10300/proc-mn103e010/asm/proc/clock.h
rename to arch/mn10300/proc-mn103e010/proc/clock.h
index caf9983..aa23e14 100644
--- a/arch/mn10300/proc-mn103e010/asm/proc/clock.h
+++ b/arch/mn10300/proc-mn103e010/proc/clock.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_PROC_CLOCK_H
 #define _ASM_PROC_CLOCK_H
 
-#include <asm/unit/clock.h>
+#include <unit/clock.h>
 
 #define MN10300_WDCLK		MN10300_IOCLK
 
diff --git a/arch/mn10300/proc-mn103e010/asm/proc/irq.h b/arch/mn10300/proc-mn103e010/proc/irq.h
similarity index 100%
rename from arch/mn10300/proc-mn103e010/asm/proc/irq.h
rename to arch/mn10300/proc-mn103e010/proc/irq.h
diff --git a/arch/mn10300/proc-mn103e010/asm/proc/proc.h b/arch/mn10300/proc-mn103e010/proc/proc.h
similarity index 100%
rename from arch/mn10300/proc-mn103e010/asm/proc/proc.h
rename to arch/mn10300/proc-mn103e010/proc/proc.h
diff --git a/arch/mn10300/unit-asb2303/leds.c b/arch/mn10300/unit-asb2303/leds.c
index cd4bc78..c038393 100644
--- a/arch/mn10300/unit-asb2303/leds.c
+++ b/arch/mn10300/unit-asb2303/leds.c
@@ -16,7 +16,7 @@
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
 #include <asm/rtc-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 
 #if 0
 static const u8 asb2303_led_hex_tbl[16] = {
diff --git a/arch/mn10300/unit-asb2303/smc91111.c b/arch/mn10300/unit-asb2303/smc91111.c
index 30875dd..43c2464 100644
--- a/arch/mn10300/unit-asb2303/smc91111.c
+++ b/arch/mn10300/unit-asb2303/smc91111.c
@@ -18,7 +18,7 @@
 #include <asm/timex.h>
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
-#include <asm/unit/smc91111.h>
+#include <unit/smc91111.h>
 
 static struct resource smc91c111_resources[] = {
 	[0] = {
diff --git a/arch/mn10300/unit-asb2303/asm/unit/clock.h b/arch/mn10300/unit-asb2303/unit/clock.h
similarity index 100%
rename from arch/mn10300/unit-asb2303/asm/unit/clock.h
rename to arch/mn10300/unit-asb2303/unit/clock.h
diff --git a/arch/mn10300/unit-asb2303/asm/unit/leds.h b/arch/mn10300/unit-asb2303/unit/leds.h
similarity index 100%
rename from arch/mn10300/unit-asb2303/asm/unit/leds.h
rename to arch/mn10300/unit-asb2303/unit/leds.h
diff --git a/arch/mn10300/unit-asb2303/asm/unit/serial.h b/arch/mn10300/unit-asb2303/unit/serial.h
similarity index 99%
rename from arch/mn10300/unit-asb2303/asm/unit/serial.h
rename to arch/mn10300/unit-asb2303/unit/serial.h
index 0d55cf5..047566c 100644
--- a/arch/mn10300/unit-asb2303/asm/unit/serial.h
+++ b/arch/mn10300/unit-asb2303/unit/serial.h
@@ -13,7 +13,7 @@
 #define _ASM_UNIT_SERIAL_H
 
 #include <asm/cpu-regs.h>
-#include <asm/proc/irq.h>
+#include <proc/irq.h>
 #include <linux/serial_reg.h>
 
 #define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
diff --git a/arch/mn10300/unit-asb2303/asm/unit/smc91111.h b/arch/mn10300/unit-asb2303/unit/smc91111.h
similarity index 100%
rename from arch/mn10300/unit-asb2303/asm/unit/smc91111.h
rename to arch/mn10300/unit-asb2303/unit/smc91111.h
diff --git a/arch/mn10300/unit-asb2303/asm/unit/timex.h b/arch/mn10300/unit-asb2303/unit/timex.h
similarity index 98%
rename from arch/mn10300/unit-asb2303/asm/unit/timex.h
rename to arch/mn10300/unit-asb2303/unit/timex.h
index 7e54b0c..f206b63 100644
--- a/arch/mn10300/unit-asb2303/asm/unit/timex.h
+++ b/arch/mn10300/unit-asb2303/unit/timex.h
@@ -16,7 +16,7 @@
 #endif /* __ASSEMBLY__ */
 
 #include <asm/timer-regs.h>
-#include <asm/unit/clock.h>
+#include <unit/clock.h>
 
 /*
  * jiffies counter specifications
diff --git a/arch/mn10300/unit-asb2305/leds.c b/arch/mn10300/unit-asb2305/leds.c
index e99dcc9..d345ff9 100644
--- a/arch/mn10300/unit-asb2305/leds.c
+++ b/arch/mn10300/unit-asb2305/leds.c
@@ -15,7 +15,7 @@
 #include <asm/processor.h>
 #include <asm/cpu/intctl-regs.h>
 #include <asm/cpu/rtc-regs.h>
-#include <asm/unit/leds.h>
+#include <unit/leds.h>
 
 static const u8 asb2305_led_hex_tbl[16] = {
 	0x80, 0xf2, 0x48, 0x60, 0x32, 0x24, 0x04, 0xf0,
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index 72812a9..1c452cc 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -18,7 +18,7 @@
 #include <asm/cpu/intctl-regs.h>
 #include <asm/cpu/rtc-regs.h>
 #include <asm/cpu/serial-regs.h>
-#include <asm/unit/serial.h>
+#include <unit/serial.h>
 
 /*
  * initialise some of the unit hardware before gdbstub is set up
diff --git a/arch/mn10300/unit-asb2305/asm/unit/clock.h b/arch/mn10300/unit-asb2305/unit/clock.h
similarity index 100%
rename from arch/mn10300/unit-asb2305/asm/unit/clock.h
rename to arch/mn10300/unit-asb2305/unit/clock.h
diff --git a/arch/mn10300/unit-asb2305/asm/unit/leds.h b/arch/mn10300/unit-asb2305/unit/leds.h
similarity index 100%
rename from arch/mn10300/unit-asb2305/asm/unit/leds.h
rename to arch/mn10300/unit-asb2305/unit/leds.h
diff --git a/arch/mn10300/unit-asb2305/asm/unit/serial.h b/arch/mn10300/unit-asb2305/unit/serial.h
similarity index 99%
rename from arch/mn10300/unit-asb2305/asm/unit/serial.h
rename to arch/mn10300/unit-asb2305/unit/serial.h
index 73d31d6..3bfc909 100644
--- a/arch/mn10300/unit-asb2305/asm/unit/serial.h
+++ b/arch/mn10300/unit-asb2305/unit/serial.h
@@ -12,7 +12,7 @@
 #define _ASM_UNIT_SERIAL_H
 
 #include <asm/cpu/cpu-regs.h>
-#include <asm/proc/irq.h>
+#include <proc/irq.h>
 #include <linux/serial_reg.h>
 
 #define SERIAL_PORT0_BASE_ADDRESS	0xA6FB0000
diff --git a/arch/mn10300/unit-asb2305/asm/unit/timex.h b/arch/mn10300/unit-asb2305/unit/timex.h
similarity index 98%
rename from arch/mn10300/unit-asb2305/asm/unit/timex.h
rename to arch/mn10300/unit-asb2305/unit/timex.h
index 10e1bfe..a71c49a 100644
--- a/arch/mn10300/unit-asb2305/asm/unit/timex.h
+++ b/arch/mn10300/unit-asb2305/unit/timex.h
@@ -16,7 +16,7 @@
 #endif /* __ASSEMBLY__ */
 
 #include <asm/cpu/timer-regs.h>
-#include <asm/unit/clock.h>
+#include <unit/clock.h>
 
 /*
  * jiffies counter specifications
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index c4ccd12..7f3ab61 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -400,7 +400,7 @@ static inline void LPD7_SMC_outsw (unsigned char* a, int r,
  * MN10300/AM33 configuration
  */
 
-#include <asm/unit/smc91111.h>
+#include <unit/smc91111.h>
 
 #else
 
-- 
1.5.6.5


>From 2aa45bcd0ce13686ca00c77479a941eb69098e83 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 17 Dec 2008 11:50:25 -0500
Subject: [PATCH] fix several bogus includes on mn10300 abs2305

asm/cpu never existed for mn10300; the files they are looking for are in
asm.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/unit-asb2305/leds.c        |    4 ++--
 arch/mn10300/unit-asb2305/unit-init.c   |    6 +++---
 arch/mn10300/unit-asb2305/unit/serial.h |    2 +-
 arch/mn10300/unit-asb2305/unit/timex.h  |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mn10300/unit-asb2305/leds.c b/arch/mn10300/unit-asb2305/leds.c
index d345ff9..6f8de99 100644
--- a/arch/mn10300/unit-asb2305/leds.c
+++ b/arch/mn10300/unit-asb2305/leds.c
@@ -13,8 +13,8 @@
 #include <linux/init.h>
 #include <asm/io.h>
 #include <asm/processor.h>
-#include <asm/cpu/intctl-regs.h>
-#include <asm/cpu/rtc-regs.h>
+#include <asm/intctl-regs.h>
+#include <asm/rtc-regs.h>
 #include <unit/leds.h>
 
 static const u8 asb2305_led_hex_tbl[16] = {
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index 1c452cc..3d78ae5 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -15,9 +15,9 @@
 #include <asm/io.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
-#include <asm/cpu/intctl-regs.h>
-#include <asm/cpu/rtc-regs.h>
-#include <asm/cpu/serial-regs.h>
+#include <asm/intctl-regs.h>
+#include <asm/rtc-regs.h>
+#include <asm/serial-regs.h>
 #include <unit/serial.h>
 
 /*
diff --git a/arch/mn10300/unit-asb2305/unit/serial.h b/arch/mn10300/unit-asb2305/unit/serial.h
index 3bfc909..8086cc0 100644
--- a/arch/mn10300/unit-asb2305/unit/serial.h
+++ b/arch/mn10300/unit-asb2305/unit/serial.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_UNIT_SERIAL_H
 #define _ASM_UNIT_SERIAL_H
 
-#include <asm/cpu/cpu-regs.h>
+#include <asm/cpu-regs.h>
 #include <proc/irq.h>
 #include <linux/serial_reg.h>
 
diff --git a/arch/mn10300/unit-asb2305/unit/timex.h b/arch/mn10300/unit-asb2305/unit/timex.h
index a71c49a..d1c72d5 100644
--- a/arch/mn10300/unit-asb2305/unit/timex.h
+++ b/arch/mn10300/unit-asb2305/unit/timex.h
@@ -15,7 +15,7 @@
 #include <linux/irq.h>
 #endif /* __ASSEMBLY__ */
 
-#include <asm/cpu/timer-regs.h>
+#include <asm/timer-regs.h>
 #include <unit/clock.h>
 
 /*
-- 
1.5.6.5

