Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbXHXWQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbXHXWQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbXHXWQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:16:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892AbXHXWQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:16:11 -0400
Date: Fri, 24 Aug 2007 15:16:07 -0700
Message-Id: <200708242216.l7OMG7cP002212@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 setup: prevent gcc from doing the wrong things
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (2):
      [x86 setup] Volatilize asm() statements
      [x86 setup] Make sure AH=00h when setting a video mode

 arch/i386/boot/boot.h      |   24 ++++++++++++------------
 arch/i386/boot/cpucheck.c  |    3 ++-
 arch/i386/boot/edd.c       |    6 +++---
 arch/i386/boot/tty.c       |   14 +++++++-------
 arch/i386/boot/video-vga.c |   17 +++++++++--------
 5 files changed, 33 insertions(+), 31 deletions(-)

[Log messages and full diffs follow]

commit 71351b98b9be6a867aa00276d67716c0728cfff7
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Aug 23 09:28:42 2007 -0700

    [x86 setup] Make sure AH=00h when setting a video mode
    
    Passing a u8 into a register doesn't mean gcc will zero-extend it.
    Also, don't depend on thhe register not to change.
    
    Per bug report from Saul Tamari.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/video-vga.c b/arch/i386/boot/video-vga.c
index d660e60..aef02f9 100644
--- a/arch/i386/boot/video-vga.c
+++ b/arch/i386/boot/video-vga.c
@@ -73,9 +73,10 @@ static u8 vga_set_basic_mode(void)
 		mode = 3;
 
 	/* Set the mode */
+	ax = mode;
 	asm volatile(INT10
-		     : : "a" (mode)
-		     : "ebx", "ecx", "edx", "esi", "edi");
+		     : "+a" (ax)
+		     : : "ebx", "ecx", "edx", "esi", "edi");
 	do_restore = 1;
 	return mode;
 }

commit b015124e562a040f7faf361c72e8f5f457ac6cf5
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Aug 22 16:28:01 2007 -0700

    [x86 setup] Volatilize asm() statements
    
    asm() statements need to be volatile when:
    
    a. They have side effects (other than value returned).
    b. When the value returned can vary over time.
    c. When they have ordering constraints that cannot be expressed to gcc.
    
    In particular, the keyboard and timer reads were violating constraint (b),
    which resulted in the keyboard/timeout poll getting
    loop-invariant-removed when compiling with gcc 4.2.0.
    
    Thanks to an anonymous bug reporter for pointing this out.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/boot.h b/arch/i386/boot/boot.h
index dec70c9..20bab94 100644
--- a/arch/i386/boot/boot.h
+++ b/arch/i386/boot/boot.h
@@ -87,7 +87,7 @@ static inline void set_fs(u16 seg)
 static inline u16 fs(void)
 {
 	u16 seg;
-	asm("movw %%fs,%0" : "=rm" (seg));
+	asm volatile("movw %%fs,%0" : "=rm" (seg));
 	return seg;
 }
 
@@ -98,7 +98,7 @@ static inline void set_gs(u16 seg)
 static inline u16 gs(void)
 {
 	u16 seg;
-	asm("movw %%gs,%0" : "=rm" (seg));
+	asm volatile("movw %%gs,%0" : "=rm" (seg));
 	return seg;
 }
 
@@ -107,19 +107,19 @@ typedef unsigned int addr_t;
 static inline u8 rdfs8(addr_t addr)
 {
 	u8 v;
-	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
+	asm volatile("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
 	return v;
 }
 static inline u16 rdfs16(addr_t addr)
 {
 	u16 v;
-	asm("movw %%fs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
+	asm volatile("movw %%fs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
 	return v;
 }
 static inline u32 rdfs32(addr_t addr)
 {
 	u32 v;
-	asm("movl %%fs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
+	asm volatile("movl %%fs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
 	return v;
 }
 
@@ -139,19 +139,19 @@ static inline void wrfs32(u32 v, addr_t addr)
 static inline u8 rdgs8(addr_t addr)
 {
 	u8 v;
-	asm("movb %%gs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
+	asm volatile("movb %%gs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
 	return v;
 }
 static inline u16 rdgs16(addr_t addr)
 {
 	u16 v;
-	asm("movw %%gs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
+	asm volatile("movw %%gs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
 	return v;
 }
 static inline u32 rdgs32(addr_t addr)
 {
 	u32 v;
-	asm("movl %%gs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
+	asm volatile("movl %%gs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
 	return v;
 }
 
@@ -180,15 +180,15 @@ static inline int memcmp(const void *s1, const void *s2, size_t len)
 static inline int memcmp_fs(const void *s1, addr_t s2, size_t len)
 {
 	u8 diff;
-	asm("fs; repe; cmpsb; setnz %0"
-	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+	asm volatile("fs; repe; cmpsb; setnz %0"
+		     : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
 	return diff;
 }
 static inline int memcmp_gs(const void *s1, addr_t s2, size_t len)
 {
 	u8 diff;
-	asm("gs; repe; cmpsb; setnz %0"
-	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+	asm volatile("gs; repe; cmpsb; setnz %0"
+		     : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
 	return diff;
 }
 
diff --git a/arch/i386/boot/cpucheck.c b/arch/i386/boot/cpucheck.c
index 991e8ce..e655a89 100644
--- a/arch/i386/boot/cpucheck.c
+++ b/arch/i386/boot/cpucheck.c
@@ -96,7 +96,8 @@ static int has_fpu(void)
 		asm volatile("movl %0,%%cr0" : : "r" (cr0));
 	}
 
-	asm("fninit ; fnstsw %0 ; fnstcw %1" : "+m" (fsw), "+m" (fcw));
+	asm volatile("fninit ; fnstsw %0 ; fnstcw %1"
+		     : "+m" (fsw), "+m" (fcw));
 
 	return fsw == 0 && (fcw & 0x103f) == 0x003f;
 }
diff --git a/arch/i386/boot/edd.c b/arch/i386/boot/edd.c
index 82b5c84..bd138e4 100644
--- a/arch/i386/boot/edd.c
+++ b/arch/i386/boot/edd.c
@@ -30,9 +30,9 @@ static int read_mbr(u8 devno, void *buf)
 	cx = 0x0001;		/* Sector 0-0-1 */
 	dx = devno;
 	bx = (size_t)buf;
-	asm("pushfl; stc; int $0x13; setc %%al; popfl"
-	    : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
-	    : : "esi", "edi", "memory");
+	asm volatile("pushfl; stc; int $0x13; setc %%al; popfl"
+		     : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
+		     : : "esi", "edi", "memory");
 
 	return -(u8)ax;		/* 0 or -1 */
 }
diff --git a/arch/i386/boot/tty.c b/arch/i386/boot/tty.c
index 9c668aa..f3f14bd 100644
--- a/arch/i386/boot/tty.c
+++ b/arch/i386/boot/tty.c
@@ -54,9 +54,9 @@ static u8 gettime(void)
 	u16 ax = 0x0200;
 	u16 cx, dx;
 
-	asm("int $0x1a"
-	    : "+a" (ax), "=c" (cx), "=d" (dx)
-	    : : "ebx", "esi", "edi");
+	asm volatile("int $0x1a"
+		     : "+a" (ax), "=c" (cx), "=d" (dx)
+		     : : "ebx", "esi", "edi");
 
 	return dx >> 8;
 }
@@ -67,7 +67,7 @@ static u8 gettime(void)
 int getchar(void)
 {
 	u16 ax = 0;
-	asm("int $0x16" : "+a" (ax));
+	asm volatile("int $0x16" : "+a" (ax));
 
 	return ax & 0xff;
 }
@@ -75,9 +75,9 @@ int getchar(void)
 static int kbd_pending(void)
 {
 	u8 pending;
-	asm("int $0x16; setnz %0"
-	    : "=rm" (pending)
-	    : "a" (0x0100));
+	asm volatile("int $0x16; setnz %0"
+		     : "=rm" (pending)
+		     : "a" (0x0100));
 	return pending;
 }
 
diff --git a/arch/i386/boot/video-vga.c b/arch/i386/boot/video-vga.c
index 700d09a..d660e60 100644
--- a/arch/i386/boot/video-vga.c
+++ b/arch/i386/boot/video-vga.c
@@ -47,16 +47,16 @@ static u8 vga_set_basic_mode(void)
 
 #ifdef CONFIG_VIDEO_400_HACK
 	if (adapter >= ADAPTER_VGA) {
-		asm(INT10
-		    : : "a" (0x1202), "b" (0x0030)
-		    : "ecx", "edx", "esi", "edi");
+		asm volatile(INT10
+			     : : "a" (0x1202), "b" (0x0030)
+			     : "ecx", "edx", "esi", "edi");
 	}
 #endif
 
 	ax = 0x0f00;
-	asm(INT10
-	    : "+a" (ax)
-	    : : "ebx", "ecx", "edx", "esi", "edi");
+	asm volatile(INT10
+		     : "+a" (ax)
+		     : : "ebx", "ecx", "edx", "esi", "edi");
 
 	mode = (u8)ax;
 
