Return-Path: <linux-kernel-owner+w=401wt.eu-S1761612AbXGaWmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbXGaWmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXGaWmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:42:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54563 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbXGaWmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:42:24 -0400
Date: Tue, 31 Jul 2007 15:42:12 -0700
Message-Id: <200707312242.l6VMgCNO026473@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Additional x86 setup fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

Two patches are cosmetic; the EDD issue can cause crashes when booting
from CD-ROM on some systems.

H. Peter Anvin (2):
      [x86 setup] Newline after setup signature failure message
      [x86 setup] EDD: Fix the computation of the MBR sector buffer

Randy Dunlap (1):
      x86 boot code comments typos

 arch/i386/boot/code16gcc.h  |    2 +-
 arch/i386/boot/edd.c        |    5 +++--
 arch/i386/boot/header.S     |    4 ++--
 arch/i386/boot/pm.c         |    2 +-
 arch/i386/boot/video-bios.c |    2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

[Full descriptions and diffs follow.]

commit ff659d13ed91dd0b237064aba91a5259f827aeb3
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Tue Jul 31 16:17:13 2007 -0400

    [x86 setup] EDD: Fix the computation of the MBR sector buffer
    
    Some BIOSes require that sector buffers not cross 64K
    boundaries.  As a result, we compute a dynamic address on the
    setup heap.  Unfortunately, this address computation was just
    totally wrong.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/edd.c b/arch/i386/boot/edd.c
index 25a2824..77d92da 100644
--- a/arch/i386/boot/edd.c
+++ b/arch/i386/boot/edd.c
@@ -72,17 +72,18 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei)
 	u32 mbrsig;
 	u32 buf_base, mbr_base;
 	extern char _end[];
-	static char mbr_buf[1024];
 
 	sector_size = ei->params.bytes_per_sector;
 	if (!sector_size)
 		sector_size = 512; /* Best available guess */
 
+	/* Produce a naturally aligned buffer on the heap */
 	buf_base = (ds() << 4) + (u32)&_end;
 	mbr_base = (buf_base+sector_size-1) & ~(sector_size-1);
-	mbrbuf_ptr = mbr_buf + (mbr_base-buf_base);
+	mbrbuf_ptr = _end + (mbr_base-buf_base);
 	mbrbuf_end = mbrbuf_ptr + sector_size;
 
+	/* Make sure we actually have space on the heap... */
 	if (!(boot_params.hdr.loadflags & CAN_USE_HEAP))
 		return 0;
 	if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)

commit 8b608d2f5a1b3552363a3161566645a409ff8530
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Jul 26 16:10:22 2007 -0700

    [x86 setup] Newline after setup signature failure message
    
    End the "No setup signature found..." with a newline (the puts
    routine will automatically add a carriage return.)
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/header.S b/arch/i386/boot/header.S
index 32ce54a..7f4a2c5 100644
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -280,4 +280,4 @@ die:
 	.section ".initdata", "a"
 setup_corrupt:
 	.byte	7
-	.string	"No setup signature found..."
+	.string	"No setup signature found...\n"

commit 8218d029c58b89837a24b4e1362c33d0ba7450b5
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Thu Jul 26 10:10:35 2007 -0700

    x86 boot code comments typos
    
    Fix comments typos in new x86 boot code.
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/code16gcc.h b/arch/i386/boot/code16gcc.h
index 3bd8480..d93e480 100644
--- a/arch/i386/boot/code16gcc.h
+++ b/arch/i386/boot/code16gcc.h
@@ -2,7 +2,7 @@
  * code16gcc.h
  *
  * This file is -include'd when compiling 16-bit C code.
- * Note: this asm() needs to be emitted before gcc omits any code.
+ * Note: this asm() needs to be emitted before gcc emits any code.
  * Depending on gcc version, this requires -fno-unit-at-a-time or
  * -fno-toplevel-reorder.
  *
diff --git a/arch/i386/boot/header.S b/arch/i386/boot/header.S
index 6b9923f..32ce54a 100644
--- a/arch/i386/boot/header.S
+++ b/arch/i386/boot/header.S
@@ -225,7 +225,7 @@ start_of_setup:
 	int	$0x13
 #endif
 
-# We will have entired with %cs = %ds+0x20, normalize %cs so
+# We will have entered with %cs = %ds+0x20, normalize %cs so
 # it is on par with the other segments.
 	pushw	%ds
 	pushw	$setup2
diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
index 1df025c..6be9ca8 100644
--- a/arch/i386/boot/pm.c
+++ b/arch/i386/boot/pm.c
@@ -80,7 +80,7 @@ static void move_kernel_around(void)
  */
 static void mask_all_interrupts(void)
 {
-	outb(0xff, 0xa1);	/* Mask all interrupts on the seconday PIC */
+	outb(0xff, 0xa1);	/* Mask all interrupts on the secondary PIC */
 	io_delay();
 	outb(0xfb, 0x21);	/* Mask all but cascade on the primary PIC */
 	io_delay();
diff --git a/arch/i386/boot/video-bios.c b/arch/i386/boot/video-bios.c
index afea46c..68e65d9 100644
--- a/arch/i386/boot/video-bios.c
+++ b/arch/i386/boot/video-bios.c
@@ -44,7 +44,7 @@ static int set_bios_mode(u8 mode)
 		     : "+a" (ax)
 		     : : "ebx", "ecx", "edx", "esi", "edi");
 
-	do_restore = 1;		/* Assume video contents was lost */
+	do_restore = 1;		/* Assume video contents were lost */
 	new_mode = ax & 0x7f;	/* Not all BIOSes are clean with the top bit */
 
 	if (new_mode == mode)
