Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbYBUIPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbYBUIPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYBUIPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:15:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:65398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbYBUIPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:15:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,385,1199692800"; 
   d="scan'208";a="258867115"
Subject: [PATCH 1/2] x86 : add init BSS sections
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Feb 2008 16:15:21 +0800
Message-Id: <1203581721.4707.19.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 21 Feb 2008 08:14:02.0437 (UTC) FILETIME=[B7CCEF50:01C87461]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Init BSS sections are added for uninitialized init DATA sections to
reduce kernel image size.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/head64.c         |    2 ++
 arch/x86/kernel/head_32.S        |    5 +++++
 arch/x86/kernel/vmlinux_32.lds.S |    9 +++++++--
 arch/x86/kernel/vmlinux_64.lds.S |   24 ++++++++++++++----------
 include/asm-generic/sections.h   |    1 +
 include/linux/init.h             |    1 +
 6 files changed, 30 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,10 +189,15 @@ SECTIONS
 	__per_cpu_end = .;
   }
   . = ALIGN(PAGE_SIZE);
-  /* freed after init ends here */
 
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-	__init_end = .;
+	__init_bss_start = .;
+	*(.bss.init.page_aligned)
+	*(.bss.init)
+	. = ALIGN(4);
+	__init_bss_stop = .;
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;			/* freed after init ends here */
 	__bss_start = .;		/* BSS */
 	*(.bss.page_aligned)
 	*(.bss)
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -150,6 +150,12 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);
   __smp_alt_end = .;
 
+  . = ALIGN(PAGE_SIZE);
+  __nosave_begin = .;
+  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
+  . = ALIGN(PAGE_SIZE);
+  __nosave_end = .;
+
   . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
@@ -219,17 +225,15 @@ SECTIONS
 
   PERCPU(PAGE_SIZE)
 
-  . = ALIGN(PAGE_SIZE);
-  __init_end = .;
-
-  . = ALIGN(PAGE_SIZE);
-  __nosave_begin = .;
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
-  . = ALIGN(PAGE_SIZE);
-  __nosave_end = .;
-
-  __bss_start = .;		/* BSS */
+  . = ALIGN(PAGE_SIZE);		/* BSS */
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
+	__init_bss_start = .;
+	*(.bss.init.page_aligned)
+	*(.bss.init)
+	__init_bss_stop = .;
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;
+	__bss_start = .;
 	*(.bss.page_aligned)
 	*(.bss)
 	}
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -105,6 +105,11 @@ ENTRY(startup_32)
  */
 	cld
 	xorl %eax,%eax
+	movl $pa(__init_bss_start),%edi
+	movl $pa(__init_bss_stop), %ecx
+	subl %edi,%ecx
+	shrl $2,%ecx
+	rep ; stosl
 	movl $pa(__bss_start),%edi
 	movl $pa(__bss_stop),%ecx
 	subl %edi,%ecx
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -5,6 +5,7 @@
 
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
+extern char __init_bss_start[], __init_bss_stop[];
 extern char __bss_start[], __bss_stop[];
 extern char __init_begin[], __init_end[];
 extern char _sinittext[], _einittext[];
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -34,6 +34,8 @@ static void __init zap_identity_mappings
    yet. */
 static void __init clear_bss(void)
 {
+	memset(__init_bss_start, 0, (unsigned long) __init_bss_stop -
+	       (unsigned long) __init_bss_start);
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
 }
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -43,6 +43,7 @@
 #define __init		__section(.init.text) __cold
 #define __initdata	__section(.init.data)
 #define __initconst	__section(.init.rodata)
+#define __initbss	__section(.bss.init)
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
 

