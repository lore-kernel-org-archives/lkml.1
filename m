Return-Path: <linux-kernel-owner+w=401wt.eu-S935875AbXGYTaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935875AbXGYTaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763206AbXGYTaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:30:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbXGYTaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:30:24 -0400
Date: Wed, 25 Jul 2007 12:25:46 -0700
Message-Id: <200707251925.l6PJPkvj026348@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [GIT PULL] x86setup fixes for 2.6.23-rc2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (4):
      [x86 setup] APM: BX should be zero when disconnecting
      [x86 setup] Fix typos in struct efi_info
      [x86 setup] Make struct ist_info cross-architecture, and use in setup code
      [x86 setup] Make struct apm_bios_info cross-architecture

Mikael Pettersson (1):
      [x86 setup] APM detection logic bug fix

 arch/i386/boot/apm.c         |    7 ++++---
 arch/i386/boot/main.c        |   16 ++++++++--------
 include/asm-i386/bootparam.h |    9 +++++----
 include/asm-i386/ist.h       |   10 ++++++----
 include/asm-x86_64/ist.h     |    1 +
 include/linux/apm_bios.h     |   20 +++++++++++---------
 6 files changed, 35 insertions(+), 28 deletions(-)
 create mode 100644 include/asm-x86_64/ist.h

[Full changelog with diffs follows]

commit 4bf3b0bc3e98f77de88b336fd8d673649601b557
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Jul 25 11:06:02 2007 -0700

    [x86 setup] Make struct apm_bios_info cross-architecture
    
    struct apm_bios_info uses "unsigned short" and "unsigned long"
    to mean u16 and u32 respectively.  Correct.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/include/linux/apm_bios.h b/include/linux/apm_bios.h
index 290aef3..5f921c8 100644
--- a/include/linux/apm_bios.h
+++ b/include/linux/apm_bios.h
@@ -21,20 +21,22 @@ typedef unsigned short	apm_eventinfo_t;
 
 #ifdef __KERNEL__
 
+#include <linux/types.h>
+
 #define APM_CS		(GDT_ENTRY_APMBIOS_BASE * 8)
 #define APM_CS_16	(APM_CS + 8)
 #define APM_DS		(APM_CS_16 + 8)
 
 struct apm_bios_info {
-	unsigned short	version;
-	unsigned short	cseg;
-	unsigned long	offset;
-	unsigned short	cseg_16;
-	unsigned short	dseg;
-	unsigned short	flags;
-	unsigned short	cseg_len;
-	unsigned short	cseg_16_len;
-	unsigned short	dseg_len;
+	u16	version;
+	u16	cseg;
+	u32	offset;
+	u16	cseg_16;
+	u16	dseg;
+	u16	flags;
+	u16	cseg_len;
+	u16	cseg_16_len;
+	u16	dseg_len;
 };
 
 /* Results of APM Installation Check */

commit 238b706da1c6ebacc55986ac8668f3ede4621f2c
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Jul 18 17:19:30 2007 -0700

    [x86 setup] Make struct ist_info cross-architecture, and use in setup code
    
    Make "struct ist_info" valid on both i386 and x86-64, and use the
    structure by name in the setup code.  Additionally, "Intel SpeedStep
    IST" is redundant, refer to it as IST consistently.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/main.c b/arch/i386/boot/main.c
index 7f01f96..0eeef39 100644
--- a/arch/i386/boot/main.c
+++ b/arch/i386/boot/main.c
@@ -73,15 +73,15 @@ static void keyboard_set_repeat(void)
 }
 
 /*
- * Get Intel SpeedStep IST information.
+ * Get Intel SpeedStep (IST) information.
  */
-static void query_speedstep_ist(void)
+static void query_ist(void)
 {
 	asm("int $0x15"
-	    : "=a" (boot_params.speedstep_info[0]),
-	      "=b" (boot_params.speedstep_info[1]),
-	      "=c" (boot_params.speedstep_info[2]),
-	      "=d" (boot_params.speedstep_info[3])
+	    : "=a" (boot_params.ist_info.signature),
+	      "=b" (boot_params.ist_info.command),
+	      "=c" (boot_params.ist_info.event),
+	      "=d" (boot_params.ist_info.perf_level)
 	    : "a" (0x0000e980),	 /* IST Support */
 	      "d" (0x47534943)); /* Request value */
 }
@@ -144,8 +144,8 @@ void main(void)
 	query_voyager();
 #endif
 
-	/* Query SpeedStep IST information */
-	query_speedstep_ist();
+	/* Query Intel SpeedStep (IST) information */
+	query_ist();
 
 	/* Query APM information */
 #if defined(CONFIG_APM) || defined(CONFIG_APM_MODULE)
diff --git a/include/asm-i386/bootparam.h b/include/asm-i386/bootparam.h
index 211f3f9..b91b017 100644
--- a/include/asm-i386/bootparam.h
+++ b/include/asm-i386/bootparam.h
@@ -4,8 +4,9 @@
 #include <linux/types.h>
 #include <linux/screen_info.h>
 #include <linux/apm_bios.h>
-#include <asm/e820.h>
 #include <linux/edd.h>
+#include <asm/e820.h>
+#include <asm/ist.h>
 #include <video/edid.h>
 
 struct setup_header {
@@ -59,7 +60,7 @@ struct boot_params {
 	struct screen_info screen_info;			/* 0x000 */
 	struct apm_bios_info apm_bios_info;		/* 0x040 */
 	u8  _pad2[12];					/* 0x054 */
-	u32 speedstep_info[4];				/* 0x060 */
+	struct ist_info ist_info;			/* 0x060 */
 	u8  _pad3[16];					/* 0x070 */
 	u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
 	u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
diff --git a/include/asm-i386/ist.h b/include/asm-i386/ist.h
index d13d1e6..ef2003e 100644
--- a/include/asm-i386/ist.h
+++ b/include/asm-i386/ist.h
@@ -19,11 +19,13 @@
 
 #ifdef __KERNEL__
 
+#include <linux/types.h>
+
 struct ist_info {
-	unsigned long	signature;
-	unsigned long	command;
-	unsigned long	event;
-	unsigned long	perf_level;
+	u32 signature;
+	u32 command;
+	u32 event;
+	u32 perf_level;
 };
 
 extern struct ist_info ist_info;
diff --git a/include/asm-x86_64/ist.h b/include/asm-x86_64/ist.h
new file mode 100644
index 0000000..338857e
--- /dev/null
+++ b/include/asm-x86_64/ist.h
@@ -0,0 +1 @@
+#include <asm-i386/ist.h>

commit f77b1ab383c8745447a3385e25729b92f2ec58a4
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Wed Jul 18 17:16:19 2007 -0700

    [x86 setup] Fix typos in struct efi_info
    
    Fix missing letters in the structure members of struct efi_info.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/include/asm-i386/bootparam.h b/include/asm-i386/bootparam.h
index 427d865..211f3f9 100644
--- a/include/asm-i386/bootparam.h
+++ b/include/asm-i386/bootparam.h
@@ -48,9 +48,9 @@ struct efi_info {
 	u32 _pad1;
 	u32 efi_systab;
 	u32 efi_memdesc_size;
-	u32 efi_memdec_version;
+	u32 efi_memdesc_version;
 	u32 efi_memmap;
-	u32 fi_memmap_size;
+	u32 efi_memmap_size;
 	u32 _pad2[2];
 };
 

commit 1a13286b104faeeb4f4bc3bfbf4d4fcdcd2569ed
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Mon Jul 23 15:37:14 2007 -0700

    [x86 setup] APM: BX should be zero when disconnecting
    
    For APM calls, BX contains the device index, which is zero for
    the system BIOS.  Disconnect requres BX = 0.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/apm.c b/arch/i386/boot/apm.c
index 8be3f56..eab50c5 100644
--- a/arch/i386/boot/apm.c
+++ b/arch/i386/boot/apm.c
@@ -45,9 +45,10 @@ int query_apm_bios(void)
 
 	/* Disconnect first, just in case */
 	ax = 0x5304;
+	bx = 0;
 	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
-		     : "+a" (ax)
-		     : : "ebx", "ecx", "edx", "esi", "edi");
+		     : "+a" (ax), "+b" (bx)
+		     : : "ecx", "edx", "esi", "edi");
 
 	/* Paranoia */
 	ebx = esi = 0;

commit 1514ab09edb071345fe17cd230c97f9e72c9478e
Author: Mikael Pettersson <mikpe@it.uu.se>
Date:   Tue Jul 24 00:25:59 2007 +0200

    [x86 setup] APM detection logic bug fix
    
    Starting with kernel 2.6.23-rc1, the i386 APM driver fails
    on several of my machines with the message:
    
    apm: BIOS not found
    
    This happens because of a bug in the i386 boot code rewrite
    from assembler to C. The original assembly code had the
    following code in its APM BIOS presence test (boot/setup.S):
    
    	andw	$0x02, %cx			# Is 32 bit supported?
    	je	done_apm_bios			# No 32-bit, no (good) APM BIOS
    
    That is, the code bails out if bit 2 is zero.
    
    In the new C version, this is coded as (boot/apm.c):
    
    	if (cx & 0x02)		/* 32 bits supported? */
    		return -1;
    
    Here we see that the test has been accidentally inverted.
    
    The fix is to negate the test. I've verified that this
    allows the APM driver to work again on my affected machines.
    
    Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/apm.c b/arch/i386/boot/apm.c
index a34087c..8be3f56 100644
--- a/arch/i386/boot/apm.c
+++ b/arch/i386/boot/apm.c
@@ -40,7 +40,7 @@ int query_apm_bios(void)
 	if (bx != 0x504d)	/* "PM" signature */
 		return -1;
 
-	if (cx & 0x02)		/* 32 bits supported? */
+	if (!(cx & 0x02))		/* 32 bits supported? */
 		return -1;
 
 	/* Disconnect first, just in case */
