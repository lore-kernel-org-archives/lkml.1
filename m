Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbXHETTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbXHETTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXHETT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:19:27 -0400
Received: from 1wt.eu ([62.212.114.60]:1181 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbXHETT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:19:26 -0400
Date: Sun, 5 Aug 2007 21:17:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Axel Reinhold <axel@freakout.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and -march=c3
Message-ID: <20070805191748.GA5524@1wt.eu>
References: <200708050856.l758u4ou031651@bongo.freakout.de> <20070805154337.GA4716@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805154337.GA4716@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 05:43:37PM +0200, Willy Tarreau wrote:
> On Sun, Aug 05, 2007 at 10:56:04AM +0200, Axel Reinhold wrote:
> > i found a bug in linux-2.4.35.
> > 
> > the bug produces a crashing kernel when compiled
> > with gcc >=4.2.0 and VIA C3 optimized -march=c3
> > (CONFIG_MCYRIXIII=y)
> > 
> > this issue was first discussed on the gcc bugzilla:
> >  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=32264
> > 
> > and tracked down to the include/asm-i386/hw_irq.h
> > module with the help of the gcc guys:
> > 
> > (pluto at agmk dot net) wrote:
> > >yup, i see something new :)
> > >
> > >please look at line 12137 of i8259.i:
> > >
> > >__attribute__((regparm(0))) void call_do_IRQ(void); __asm__(...
> > >
> > >as you can see there is a semicolon after call_do_IRQ(void)
> > >and following asm statement isn't treated as a function body.
> > >in this way -O1 -f{no-}unit-at-a-time accidentally produces
> > >different code. it's not a gcc bug.
> > >
> > >linux-2.4.35/include/asm-i386/hw_irq.h
> > >contains these evil macros.
> > 
> > is there a chance to fix this?
> > these macros a far beyond my capabilities to fix.
> 
> Axel,
> 
> I've reproduced it and posted the following explanation to GCC's
> bugzilla ; I think I can provide you with a simple fix very soon.

OK Axel,

I have a fix now. Three good news :

  - there were other symbols which were affected by -fno-unit-at-a-time under
    gcc-4.2

  - gcc-4.1 was also slightly affected but it was not very serious, since the
    difference only lie in data <-> rodata

  - vmlinux is smaller by 65 kB on my machine with both gcc-4.1 and gcc-4.2,
    and bzImage is smaller by 7 kB. gcc-4.2's bzImage was 2.5 kB larger and
    is now 100 bytes smaller.

The fix simply consists in removing -fno-unit-at-a-time with gcc-4, as is
done in 2.6. This was added for gcc-3.4 and is not appropriate for 4.x.

Here's the list of the other affected symbols. First column is the type of
the symbol and second one is the symbol name. It's a diff -y of the symbols
between vmlinux build with both gcc versions :

    2.4.35 + gcc-4.2.1        |     2.4.35-git + gcc-4.2.1
d IRQ0x00_interrupt	      |	t IRQ0x00_interrupt
d IRQ0x01_interrupt	      |	t IRQ0x01_interrupt
d IRQ0x02_interrupt	      |	t IRQ0x02_interrupt
d IRQ0x03_interrupt	      |	t IRQ0x03_interrupt
d IRQ0x04_interrupt	      |	t IRQ0x04_interrupt
d IRQ0x05_interrupt	      |	t IRQ0x05_interrupt
d IRQ0x06_interrupt	      |	t IRQ0x06_interrupt
d IRQ0x07_interrupt	      |	t IRQ0x07_interrupt
d IRQ0x08_interrupt	      |	t IRQ0x08_interrupt
d IRQ0x09_interrupt	      |	t IRQ0x09_interrupt
d IRQ0x0a_interrupt	      |	t IRQ0x0a_interrupt
d IRQ0x0b_interrupt	      |	t IRQ0x0b_interrupt
d IRQ0x0c_interrupt	      |	t IRQ0x0c_interrupt
d IRQ0x0d_interrupt	      |	t IRQ0x0d_interrupt
d IRQ0x0e_interrupt	      |	t IRQ0x0e_interrupt
d IRQ0x0f_interrupt	      |	t IRQ0x0f_interrupt
d IRQ0x10_interrupt	      |	t IRQ0x10_interrupt
d IRQ0x11_interrupt	      |	t IRQ0x11_interrupt
d IRQ0x12_interrupt	      |	t IRQ0x12_interrupt
d IRQ0x13_interrupt	      |	t IRQ0x13_interrupt
d IRQ0x14_interrupt	      |	t IRQ0x14_interrupt
d IRQ0x15_interrupt	      |	t IRQ0x15_interrupt
d IRQ0x16_interrupt	      |	t IRQ0x16_interrupt
d IRQ0x17_interrupt	      |	t IRQ0x17_interrupt
d IRQ0x18_interrupt	      |	t IRQ0x18_interrupt
d IRQ0x19_interrupt	      |	t IRQ0x19_interrupt
d IRQ0x1a_interrupt	      |	t IRQ0x1a_interrupt
d IRQ0x1b_interrupt	      |	t IRQ0x1b_interrupt
d IRQ0x1c_interrupt	      |	t IRQ0x1c_interrupt
d IRQ0x1d_interrupt	      |	t IRQ0x1d_interrupt
d IRQ0x1e_interrupt	      |	t IRQ0x1e_interrupt
d IRQ0x1f_interrupt	      |	t IRQ0x1f_interrupt
d IRQ0x20_interrupt	      |	t IRQ0x20_interrupt
d IRQ0x21_interrupt	      |	t IRQ0x21_interrupt
d IRQ0x22_interrupt	      |	t IRQ0x22_interrupt
d IRQ0x23_interrupt	      |	t IRQ0x23_interrupt
d IRQ0x24_interrupt	      |	t IRQ0x24_interrupt
d IRQ0x25_interrupt	      |	t IRQ0x25_interrupt
d IRQ0x26_interrupt	      |	t IRQ0x26_interrupt
d IRQ0x27_interrupt	      |	t IRQ0x27_interrupt
d IRQ0x28_interrupt	      |	t IRQ0x28_interrupt
d IRQ0x29_interrupt	      |	t IRQ0x29_interrupt
d IRQ0x2a_interrupt	      |	t IRQ0x2a_interrupt
d IRQ0x2b_interrupt	      |	t IRQ0x2b_interrupt
d IRQ0x2c_interrupt	      |	t IRQ0x2c_interrupt
d IRQ0x2d_interrupt	      |	t IRQ0x2d_interrupt
d IRQ0x2e_interrupt	      |	t IRQ0x2e_interrupt
d IRQ0x2f_interrupt	      |	t IRQ0x2f_interrupt
d IRQ0x30_interrupt	      |	t IRQ0x30_interrupt
d IRQ0x31_interrupt	      |	t IRQ0x31_interrupt
d IRQ0x32_interrupt	      |	t IRQ0x32_interrupt
d IRQ0x33_interrupt	      |	t IRQ0x33_interrupt
d IRQ0x34_interrupt	      |	t IRQ0x34_interrupt
d IRQ0x35_interrupt	      |	t IRQ0x35_interrupt
d IRQ0x36_interrupt	      |	t IRQ0x36_interrupt
d IRQ0x37_interrupt	      |	t IRQ0x37_interrupt
d IRQ0x38_interrupt	      |	t IRQ0x38_interrupt
d IRQ0x39_interrupt	      |	t IRQ0x39_interrupt
d IRQ0x3a_interrupt	      |	t IRQ0x3a_interrupt
d IRQ0x3b_interrupt	      |	t IRQ0x3b_interrupt
d IRQ0x3c_interrupt	      |	t IRQ0x3c_interrupt
d IRQ0x3d_interrupt	      |	t IRQ0x3d_interrupt
d IRQ0x3e_interrupt	      |	t IRQ0x3e_interrupt
d IRQ0x3f_interrupt	      |	t IRQ0x3f_interrupt
d IRQ0x40_interrupt	      |	t IRQ0x40_interrupt
d IRQ0x41_interrupt	      |	t IRQ0x41_interrupt
d IRQ0x42_interrupt	      |	t IRQ0x42_interrupt
d IRQ0x43_interrupt	      |	t IRQ0x43_interrupt
d IRQ0x44_interrupt	      |	t IRQ0x44_interrupt
d IRQ0x45_interrupt	      |	t IRQ0x45_interrupt
d IRQ0x46_interrupt	      |	t IRQ0x46_interrupt
d IRQ0x47_interrupt	      |	t IRQ0x47_interrupt
d IRQ0x48_interrupt	      |	t IRQ0x48_interrupt
d IRQ0x49_interrupt	      |	t IRQ0x49_interrupt
d IRQ0x4a_interrupt	      |	t IRQ0x4a_interrupt
d IRQ0x4b_interrupt	      |	t IRQ0x4b_interrupt
d IRQ0x4c_interrupt	      |	t IRQ0x4c_interrupt
d IRQ0x4d_interrupt	      |	t IRQ0x4d_interrupt
d IRQ0x4e_interrupt	      |	t IRQ0x4e_interrupt
d IRQ0x4f_interrupt	      |	t IRQ0x4f_interrupt
d IRQ0x50_interrupt	      |	t IRQ0x50_interrupt
d IRQ0x51_interrupt	      |	t IRQ0x51_interrupt
d IRQ0x52_interrupt	      |	t IRQ0x52_interrupt
d IRQ0x53_interrupt	      |	t IRQ0x53_interrupt
d IRQ0x54_interrupt	      |	t IRQ0x54_interrupt
d IRQ0x55_interrupt	      |	t IRQ0x55_interrupt
d IRQ0x56_interrupt	      |	t IRQ0x56_interrupt
d IRQ0x57_interrupt	      |	t IRQ0x57_interrupt
d IRQ0x58_interrupt	      |	t IRQ0x58_interrupt
d IRQ0x59_interrupt	      |	t IRQ0x59_interrupt
d IRQ0x5a_interrupt	      |	t IRQ0x5a_interrupt
d IRQ0x5b_interrupt	      |	t IRQ0x5b_interrupt
d IRQ0x5c_interrupt	      |	t IRQ0x5c_interrupt
d IRQ0x5d_interrupt	      |	t IRQ0x5d_interrupt
d IRQ0x5e_interrupt	      |	t IRQ0x5e_interrupt
d IRQ0x5f_interrupt	      |	t IRQ0x5f_interrupt
d IRQ0x60_interrupt	      |	t IRQ0x60_interrupt
d IRQ0x61_interrupt	      |	t IRQ0x61_interrupt
d IRQ0x62_interrupt	      |	t IRQ0x62_interrupt
d IRQ0x63_interrupt	      |	t IRQ0x63_interrupt
d IRQ0x64_interrupt	      |	t IRQ0x64_interrupt
d IRQ0x65_interrupt	      |	t IRQ0x65_interrupt
d IRQ0x66_interrupt	      |	t IRQ0x66_interrupt
d IRQ0x67_interrupt	      |	t IRQ0x67_interrupt
d IRQ0x68_interrupt	      |	t IRQ0x68_interrupt
d IRQ0x69_interrupt	      |	t IRQ0x69_interrupt
d IRQ0x6a_interrupt	      |	t IRQ0x6a_interrupt
d IRQ0x6b_interrupt	      |	t IRQ0x6b_interrupt
d IRQ0x6c_interrupt	      |	t IRQ0x6c_interrupt
d IRQ0x6d_interrupt	      |	t IRQ0x6d_interrupt
d IRQ0x6e_interrupt	      |	t IRQ0x6e_interrupt
d IRQ0x6f_interrupt	      |	t IRQ0x6f_interrupt
d IRQ0x70_interrupt	      |	t IRQ0x70_interrupt
d IRQ0x71_interrupt	      |	t IRQ0x71_interrupt
d IRQ0x72_interrupt	      |	t IRQ0x72_interrupt
d IRQ0x73_interrupt	      |	t IRQ0x73_interrupt
d IRQ0x74_interrupt	      |	t IRQ0x74_interrupt
d IRQ0x75_interrupt	      |	t IRQ0x75_interrupt
d IRQ0x76_interrupt	      |	t IRQ0x76_interrupt
d IRQ0x77_interrupt	      |	t IRQ0x77_interrupt
d IRQ0x78_interrupt	      |	t IRQ0x78_interrupt
d IRQ0x79_interrupt	      |	t IRQ0x79_interrupt
d IRQ0x7a_interrupt	      |	t IRQ0x7a_interrupt
d IRQ0x7b_interrupt	      |	t IRQ0x7b_interrupt
d IRQ0x7c_interrupt	      |	t IRQ0x7c_interrupt
d IRQ0x7d_interrupt	      |	t IRQ0x7d_interrupt
d IRQ0x7e_interrupt	      |	t IRQ0x7e_interrupt
d IRQ0x7f_interrupt	      |	t IRQ0x7f_interrupt
d IRQ0x80_interrupt	      |	t IRQ0x80_interrupt
d IRQ0x81_interrupt	      |	t IRQ0x81_interrupt
d IRQ0x82_interrupt	      |	t IRQ0x82_interrupt
d IRQ0x83_interrupt	      |	t IRQ0x83_interrupt
d IRQ0x84_interrupt	      |	t IRQ0x84_interrupt
d IRQ0x85_interrupt	      |	t IRQ0x85_interrupt
d IRQ0x86_interrupt	      |	t IRQ0x86_interrupt
d IRQ0x87_interrupt	      |	t IRQ0x87_interrupt
d IRQ0x88_interrupt	      |	t IRQ0x88_interrupt
d IRQ0x89_interrupt	      |	t IRQ0x89_interrupt
d IRQ0x8a_interrupt	      |	t IRQ0x8a_interrupt
d IRQ0x8b_interrupt	      |	t IRQ0x8b_interrupt
d IRQ0x8c_interrupt	      |	t IRQ0x8c_interrupt
d IRQ0x8d_interrupt	      |	t IRQ0x8d_interrupt
d IRQ0x8e_interrupt	      |	t IRQ0x8e_interrupt
d IRQ0x8f_interrupt	      |	t IRQ0x8f_interrupt
d IRQ0x90_interrupt	      |	t IRQ0x90_interrupt
d IRQ0x91_interrupt	      |	t IRQ0x91_interrupt
d IRQ0x92_interrupt	      |	t IRQ0x92_interrupt
d IRQ0x93_interrupt	      |	t IRQ0x93_interrupt
d IRQ0x94_interrupt	      |	t IRQ0x94_interrupt
d IRQ0x95_interrupt	      |	t IRQ0x95_interrupt
d IRQ0x96_interrupt	      |	t IRQ0x96_interrupt
d IRQ0x97_interrupt	      |	t IRQ0x97_interrupt
d IRQ0x98_interrupt	      |	t IRQ0x98_interrupt
d IRQ0x99_interrupt	      |	t IRQ0x99_interrupt
d IRQ0x9a_interrupt	      |	t IRQ0x9a_interrupt
d IRQ0x9b_interrupt	      |	t IRQ0x9b_interrupt
d IRQ0x9c_interrupt	      |	t IRQ0x9c_interrupt
d IRQ0x9d_interrupt	      |	t IRQ0x9d_interrupt
d IRQ0x9e_interrupt	      |	t IRQ0x9e_interrupt
d IRQ0x9f_interrupt	      |	t IRQ0x9f_interrupt
d IRQ0xa0_interrupt	      |	t IRQ0xa0_interrupt
d IRQ0xa1_interrupt	      |	t IRQ0xa1_interrupt
d IRQ0xa2_interrupt	      |	t IRQ0xa2_interrupt
d IRQ0xa3_interrupt	      |	t IRQ0xa3_interrupt
d IRQ0xa4_interrupt	      |	t IRQ0xa4_interrupt
d IRQ0xa5_interrupt	      |	t IRQ0xa5_interrupt
d IRQ0xa6_interrupt	      |	t IRQ0xa6_interrupt
d IRQ0xa7_interrupt	      |	t IRQ0xa7_interrupt
d IRQ0xa8_interrupt	      |	t IRQ0xa8_interrupt
d IRQ0xa9_interrupt	      |	t IRQ0xa9_interrupt
d IRQ0xaa_interrupt	      |	t IRQ0xaa_interrupt
d IRQ0xab_interrupt	      |	t IRQ0xab_interrupt
d IRQ0xac_interrupt	      |	t IRQ0xac_interrupt
d IRQ0xad_interrupt	      |	t IRQ0xad_interrupt
d IRQ0xae_interrupt	      |	t IRQ0xae_interrupt
d IRQ0xaf_interrupt	      |	t IRQ0xaf_interrupt
d IRQ0xb0_interrupt	      |	t IRQ0xb0_interrupt
d IRQ0xb1_interrupt	      |	t IRQ0xb1_interrupt
d IRQ0xb2_interrupt	      |	t IRQ0xb2_interrupt
d IRQ0xb3_interrupt	      |	t IRQ0xb3_interrupt
d IRQ0xb4_interrupt	      |	t IRQ0xb4_interrupt
d IRQ0xb5_interrupt	      |	t IRQ0xb5_interrupt
d IRQ0xb6_interrupt	      |	t IRQ0xb6_interrupt
d IRQ0xb7_interrupt	      |	t IRQ0xb7_interrupt
d IRQ0xb8_interrupt	      |	t IRQ0xb8_interrupt
d IRQ0xb9_interrupt	      |	t IRQ0xb9_interrupt
d IRQ0xba_interrupt	      |	t IRQ0xba_interrupt
d IRQ0xbb_interrupt	      |	t IRQ0xbb_interrupt
d IRQ0xbc_interrupt	      |	t IRQ0xbc_interrupt
d IRQ0xbd_interrupt	      |	t IRQ0xbd_interrupt
d IRQ0xbe_interrupt	      |	t IRQ0xbe_interrupt
d IRQ0xbf_interrupt	      |	t IRQ0xbf_interrupt
d IRQ0xc0_interrupt	      |	t IRQ0xc0_interrupt
d IRQ0xc1_interrupt	      |	t IRQ0xc1_interrupt
d IRQ0xc2_interrupt	      |	t IRQ0xc2_interrupt
d IRQ0xc3_interrupt	      |	t IRQ0xc3_interrupt
d IRQ0xc4_interrupt	      |	t IRQ0xc4_interrupt
d IRQ0xc5_interrupt	      |	t IRQ0xc5_interrupt
d IRQ0xc6_interrupt	      |	t IRQ0xc6_interrupt
d IRQ0xc7_interrupt	      |	t IRQ0xc7_interrupt
d IRQ0xc8_interrupt	      |	t IRQ0xc8_interrupt
d IRQ0xc9_interrupt	      |	t IRQ0xc9_interrupt
d IRQ0xca_interrupt	      |	t IRQ0xca_interrupt
d IRQ0xcb_interrupt	      |	t IRQ0xcb_interrupt
d IRQ0xcc_interrupt	      |	t IRQ0xcc_interrupt
d IRQ0xcd_interrupt	      |	t IRQ0xcd_interrupt
d IRQ0xce_interrupt	      |	t IRQ0xce_interrupt
d IRQ0xcf_interrupt	      |	t IRQ0xcf_interrupt
d IRQ0xd0_interrupt	      |	t IRQ0xd0_interrupt
d IRQ0xd1_interrupt	      |	t IRQ0xd1_interrupt
d IRQ0xd2_interrupt	      |	t IRQ0xd2_interrupt
d IRQ0xd3_interrupt	      |	t IRQ0xd3_interrupt
d IRQ0xd4_interrupt	      |	t IRQ0xd4_interrupt
d IRQ0xd5_interrupt	      |	t IRQ0xd5_interrupt
d IRQ0xd6_interrupt	      |	t IRQ0xd6_interrupt
d IRQ0xd7_interrupt	      |	t IRQ0xd7_interrupt
d IRQ0xd8_interrupt	      |	t IRQ0xd8_interrupt
d IRQ0xd9_interrupt	      |	t IRQ0xd9_interrupt
d IRQ0xda_interrupt	      |	t IRQ0xda_interrupt
d IRQ0xdb_interrupt	      |	t IRQ0xdb_interrupt
d IRQ0xdc_interrupt	      |	t IRQ0xdc_interrupt
d IRQ0xdd_interrupt	      |	t IRQ0xdd_interrupt
d IRQ0xde_interrupt	      |	t IRQ0xde_interrupt
d IRQ0xdf_interrupt	      |	t IRQ0xdf_interrupt
d apic_timer_interrupt	      |	t apic_timer_interrupt
d call_apic_timer_interrupt   |	t call_apic_timer_interrupt
d call_call_function_interrup |	t call_call_function_interrup
d call_do_IRQ		      |	t call_do_IRQ
d call_error_interrupt	      |	t call_error_interrupt
d call_function_interrupt     |	t call_function_interrupt
d call_invalidate_interrupt   |	t call_invalidate_interrupt
d call_reschedule_interrupt   |	t call_reschedule_interrupt
d call_spurious_interrupt     |	t call_spurious_interrupt
d common_interrupt	      |	t common_interrupt
d error_interrupt	      |	t error_interrupt
d invalidate_interrupt	      |	t invalidate_interrupt
d reschedule_interrupt	      |	t reschedule_interrupt

I also noticed a few drivers which do not build with gcc-4.2 (eg: wdt83627).
I'll have to adress this later.

Anyway, could you please try the appended patch ? At least it works for me,
and I expect it to fix your problem too :

willy@pcw:~$ cat /proc/version 
Linux version 2.4.35 (willy@pcw) (gcc version 4.2.1) #1 SMP Sun Aug 5 20:55:56 CEST 2007

Thanks,
Willy


>From fff3b8ca17220353262127bb4045a8edd53e6e8c Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Sun, 5 Aug 2007 18:37:07 +0200
Subject: [PATCH] fix incorrect use of -fno-unit-at-a-time on GCC >= 4

Axel Reinhold reported wrong code being emitted for arch/i386/kernel/i8259.c
using gcc-4.2, while the same code with gcc-4.1 was valid. The problem was
tracked down to gcc-4.2 messing up with sections with this option which is
already deprecated for gcc 4.x, and the asm statements were incorrectly
assigned to section .data. It was also possible to trick gcc-4.1 into the
same error by simply declaring an array before any asm statement.

The correct fix is to remove -fno-unit-at-a-time with gcc >= 4, which is
also what has been done in 2.6. In anticipation of such other problems with
gcc 4.x, a new function "if_gcc4" has been added to the main Makefile.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 Makefile           |    1 +
 arch/i386/Makefile |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e44ff6b..29db08b 100644
--- a/Makefile
+++ b/Makefile
@@ -100,6 +100,7 @@ endif
 AFLAGS := -D__ASSEMBLY__ $(CPPFLAGS)
 
 check_gcc = $(shell if $(CC) $(1) -S -o /dev/null -xc /dev/null > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi)
+if_gcc4 = $(shell if echo __GNUC__ | $(CC) -E -xc - | grep -q '^4$$' > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi)
 
 # disable pointer signedness warnings in gcc 4.0
 CFLAGS += $(call check_gcc,-Wno-pointer-sign,)
diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index 8f93efd..8ba6bd0 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -92,9 +92,9 @@ ifdef CONFIG_MVIAC3_2
 CFLAGS += $(call check_gcc,-march=c3-2,-march=i686)
 endif
 
-# Disable unit-at-a-time mode, it makes gcc use a lot more stack
-# due to the lack of sharing of stacklots.
-CFLAGS += $(call check_gcc,-fno-unit-at-a-time,)
+# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
+# a lot more stack due to the lack of sharing of stacklots.
+CFLAGS += $(call if_gcc4,,$(call check_gcc,-fno-unit-at-a-time,))
 
 HEAD := arch/i386/kernel/head.o arch/i386/kernel/init_task.o
 
-- 
1.5.2.4



