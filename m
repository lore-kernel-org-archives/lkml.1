Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbXILUqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbXILUqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760016AbXILUqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:46:15 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:38293 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbXILUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=PrWqNM9ntCzrwUX6dOisDacVNV/CEt6jwA0kjOVMjlryzffYbG4Z5DnrWKq6JSoMqY/SoAz75EbTrhDWryGYrdj920SEqV+exyuPR22Gr2kxfHTbKxUFnXMVyheklpC03kjHp0Ih/yMkkmjOZsyucJbZGVekj0FkWuvYGPkwOeA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/2] section garbage collection for i386 - BONUS TRACK
Date: Wed, 12 Sep 2007 21:45:51 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709122124.21164.vda.linux@googlemail.com> <200709122130.48889.vda.linux@googlemail.com>
In-Reply-To: <200709122130.48889.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AAF6G1n/fGwpLP+"
Message-Id: <200709122145.52026.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_AAF6G1n/fGwpLP+
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Sam,

This patch makes i386 vmlinux linker script simpler
by minimizing number of generated sections.

For example, these sections:

 21 .init.text    000204a0  78701000  00701000  00502000  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 22 .init.data    000268db  787214a0  007214a0  005224a0  2**3
                  CONTENTS, ALLOC, LOAD, DATA
 23 .init.setup   00000654  78747d80  00747d80  00548d80  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 24 .initcall.init 000004c4  787483d4  007483d4  005493d4  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 25 .con_initcall.init 00000008  78748898  00748898  00549898  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 26 .altinstructions 00009c23  787488a0  007488a0  005498a0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 27 .altinstr_replacement 000027de  787524c3  007524c3  005534c3  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 28 .exit.text    00000f31  78754ca4  00754ca4  00555ca4  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 29 .init.ramfs   00000086  78756000  00756000  00557000  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA

code, data, data, data, rodata, code, code, data... -
doesn't look clean.

Can more sanely be grouped like this:

 15 .init.text    00023baf  78701000  00701000  00502000  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 16 .init.rodata  00009ca8  78725000  00725000  00526000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 17 .init.data    00027408  7872eca8  0072eca8  0052fca8  2**3
                  CONTENTS, ALLOC, LOAD, DATA

All in all, we have 20 sections instead of 32, and it still boots okay.


Full listing:


Before:

$ objdump -h
linux-2.6.23-rc4.gc6.t/vmlinux:     file format elf32-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .head.text    00000379  78200000  00200000  00001000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 .text         003646da  78200380  00200380  00001380  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 __ex_table    00000ee8  78564a60  00564a60  00365a60  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  3 .notes        00000024  78565948  00565948  00366948  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  4 .rodata       000e85fe  78566000  00566000  00367000  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  5 .pci_fixup    00000700  7864e600  0064e600  0044f600  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  6 __ksymtab     000057a0  7864ed00  0064ed00  0044fd00  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  7 __ksymtab_gpl 00001ac0  786544a0  006544a0  004554a0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  8 __ksymtab_gpl_future 00000018  78655f60  00655f60  00456f60  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  9 __kcrctab     00002bd0  78655f78  00655f78  00456f78  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 10 __kcrctab_gpl 00000d60  78658b48  00658b48  00459b48  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 11 __kcrctab_gpl_future 0000000c  786598a8  006598a8  0045a8a8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 12 __ksymtab_strings 00010d8b  786598b4  006598b4  0045a8b4  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 13 __param       00001838  7866a640  0066a640  0046b640  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 14 .data         0007fe99  7866c000  0066c000  0046d000  2**7
                  CONTENTS, ALLOC, LOAD, DATA
 15 .data_nosave  00001000  786ec000  006ec000  004ed000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
 16 .page_aligned.data 00000800  786ed000  006ed000  004ee000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 17 .cacheline_aligned.data 0000a000  786ed800  006ed800  004ee800  2**7
                  CONTENTS, ALLOC, LOAD, DATA
 18 .read_mostly.data 000020d0  786f7800  006f7800  004f8800  2**7
                  CONTENTS, ALLOC, LOAD, DATA
 19 .init_task.data 00002000  786fa000  006fa000  004fb000  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 20 .smp_locks    00004798  786fc000  006fc000  004fd000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 21 .init.text    000204a0  78701000  00701000  00502000  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 22 .init.data    000268db  787214a0  007214a0  005224a0  2**3
                  CONTENTS, ALLOC, LOAD, DATA
 23 .init.setup   00000654  78747d80  00747d80  00548d80  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 24 .initcall.init 000004c4  787483d4  007483d4  005493d4  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 25 .con_initcall.init 00000008  78748898  00748898  00549898  2**2
                  CONTENTS, ALLOC, LOAD, DATA
 26 .altinstructions 00009c23  787488a0  007488a0  005498a0  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 27 .altinstr_replacement 000027de  787524c3  007524c3  005534c3  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 28 .exit.text    00000f31  78754ca4  00754ca4  00555ca4  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 29 .init.ramfs   00000086  78756000  00756000  00557000  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 30 .percpu.data  00005f38  78757000  00757000  00558000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
 31 .bss          00047000  7875d000  0075d000  0055df38  2**12
                  ALLOC
 32 .comment      00005004  00000000  00000000  0055df38  2**0
                  CONTENTS, READONLY


After:

linux-2.6.23-rc4.gc7.t/vmlinux:     file format elf32-i386

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         00364a5a  78200000  00200000  00001000  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  1 __ex_table    00000ee8  78564a60  00564a60  00365a60  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  2 .notes        00000024  78565948  00565948  00366948  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  3 .rodata       000e8602  78566000  00566000  00367000  2**3
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .pci_fixup    00000700  7864e604  0064e604  0044f604  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  5 __ksymtab     000057a0  7864ed04  0064ed04  0044fd04  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  6 __ksymtab_gpl 00001ac0  786544a4  006544a4  004554a4  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  7 __ksymtab_gpl_future 00000018  78655f64  00655f64  00456f64  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  8 __kcrctab     00002bd0  78655f7c  00655f7c  00456f7c  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  9 __kcrctab_gpl 00000d60  78658b4c  00658b4c  00459b4c  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 10 __kcrctab_gpl_future 0000000c  786598ac  006598ac  0045a8ac  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 11 __ksymtab_strings 00010d8b  786598b8  006598b8  0045a8b8  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 12 __param       00001838  7866a644  0066a644  0046b644  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 13 .data         0008f7d0  7866c000  0066c000  0046d000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
 14 .smp_locks    00004798  786fc000  006fc000  004fd000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 15 .init.text    00023baf  78701000  00701000  00502000  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
 16 .init.rodata  00009ca8  78725000  00725000  00526000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
 17 .init.data    00027408  7872eca8  0072eca8  0052fca8  2**3
                  CONTENTS, ALLOC, LOAD, DATA
 18 .percpu.data  00005f38  78757000  00757000  00558000  2**12
                  CONTENTS, ALLOC, LOAD, DATA
 19 .bss          00047000  7875d000  0075d000  0055df38  2**12
                  ALLOC
 20 .comment      00005004  00000000  00000000  0055df38  2**0
                  CONTENTS, READONLY

Patch is run-tested.

It's purely cleanup work, it's not bringing any noticeable
size wins (well, maybe statistically it will have a bit less
alignment padding because I placed together a few page-aligned
chunks, but that's all).

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_AAF6G1n/fGwpLP+
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-rc4.7.i386part2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.7.i386part2.patch"

diff -urpN linux-2.6.23-rc4.gc6/arch/i386/kernel/vmlinux.lds.S linux-2.6.23-rc4.gc7/arch/i386/kernel/vmlinux.lds.S
--- linux-2.6.23-rc4.gc6/arch/i386/kernel/vmlinux.lds.S	2007-09-12 19:51:42.000000000 +0100
+++ linux-2.6.23-rc4.gc7/arch/i386/kernel/vmlinux.lds.S	2007-09-12 21:10:38.000000000 +0100
@@ -6,7 +6,19 @@
  * at run time. Absolute symbols are not relocated. If symbol value should
  * change if kernel is relocated, make the symbol section relative
  * by putting it inside the section definition.
+ *
+ * Try to avoid creating output sections needlessly.
+ * Group pieces with same attributes (ro/rw, code/data,
+ * persistent/discarded-after-init) together in one section.
+ *
+ * Statistically, padding is smaller if input sections
+ * within output section are sorted by alignment in descending order.
+ *
+ * If you need to ALIGN a section, putting ALIGN immediately before section
+ * can result in smaller on-disk image than when you put it immeadiately
+ * after section's opening '{'.
  */
+
 #define LOAD_OFFSET __PAGE_OFFSET
 
 #include <asm-generic/vmlinux.lds.h>
@@ -18,6 +30,7 @@
 OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
+
 jiffies = jiffies_64;
 
 PHDRS {
@@ -30,13 +43,11 @@ SECTIONS
   . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
   phys_startup_32 = startup_32 - LOAD_OFFSET;
 
-  .head.text : AT(ADDR(.head.text) - LOAD_OFFSET) {
-  	_text = .;			/* Text and read-only data */
-	KEEP(*(.head.text))
-  } :text = 0x9090
-
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
+	_text = .;			/* Text and read-only data */
+	KEEP(*(.head.text))
+
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
@@ -54,6 +65,7 @@ SECTIONS
   	__stop___ex_table = .;
   }
 
+  /* Hm? NOTES end up marked as CODE in vmlinux, but they are not. FIXME */
   NOTES :text :note
 
   BUG_TABLE :text
@@ -69,45 +81,39 @@ SECTIONS
   RODATA
 
   /* writeable */
-  . = ALIGN(4096);
+  . = ALIGN(THREAD_SIZE); /* at least 4k */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
-	DATA_DATA
-	CONSTRUCTORS
-  } :data
+	/* init_task */
+	*(.init_task.data)
 
-  . = ALIGN(4096);
-  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+	. = ALIGN(4096);
+	*(.page_aligned.data)
+
+  	. = ALIGN(4096);
   	__nosave_begin = .;
 	/* No need to KEEP */
 	*(.nosave.data)
   	. = ALIGN(4096);
   	__nosave_end = .;
-  }
 
-  . = ALIGN(4096);
-  .page_aligned.data : AT(ADDR(.page_aligned.data) - LOAD_OFFSET) {
-	*(.page_aligned.data)
+	/* The IDT has to be page-aligned because of F0 0F bug */
 	*(.idt.data)
-  }
 
-  . = ALIGN(32);
-  .cacheline_aligned.data : AT(ADDR(.cacheline_aligned.data) - LOAD_OFFSET) {
+	DATA_DATA
+	CONSTRUCTORS
+
+	. = ALIGN(32);
 	*(.cacheline_aligned.data)
-  }
 
-  /* rarely changed data like cpu maps */
-  . = ALIGN(32);
-  .read_mostly.data : AT(ADDR(.read_mostly.data) - LOAD_OFFSET) {
+	/* rarely changed data like cpu maps */
+	. = ALIGN(32);
 	*(.read_mostly.data)
-	_edata = .;		/* End of data section */
-  }
 
-  . = ALIGN(THREAD_SIZE);	/* init_task */
-  .init_task.data : AT(ADDR(.init_task.data) - LOAD_OFFSET) {
-	*(.init_task.data)
-  }
+	_edata = .;
+  } :data
+
+  /* Might get freed after init */
 
-  /* might get freed after init */
   . = ALIGN(4096);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
@@ -116,75 +122,80 @@ SECTIONS
   }
 
   /* Will be freed after init */
-  /* Init code and data */
+
   . = ALIGN(4096);
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
   	__init_begin = .;
 	_sinittext = .;
 	*(.init.text)
 	_einittext = .;
+
+	/* No need to KEEP - referenced by .altinstructions */
+	*(.altinstr_replacement)
+
+	/* .exit.text is discarded at runtime, not link time, to deal with references
+	   from .altinstructions and .eh_frame */
+	*(.exit.text)
+  }
+
+  /* ro, code */
+  SECURITY_INIT
+
+#if defined(CONFIG_BLK_DEV_INITRD)
+  /* ALIGN outside section may make on-disk image smaller */
+  . = ALIGN(4096);
+#endif
+  .init.rodata : AT(ADDR(.init.rodata) - LOAD_OFFSET) {
+#if defined(CONFIG_BLK_DEV_INITRD)
+	__initramfs_start = .;
+	KEEP(*(.init.ramfs))
+	__initramfs_end = .;
+#endif
+	. = ALIGN(4);
+  	__alt_instructions = .;
+	KEEP(*(.altinstructions))
+	__alt_instructions_end = .;
+
+	. = ALIGN(4);
+  	__parainstructions = .;
+	KEEP(*(.parainstructions))
+  	__parainstructions_end = .;
   }
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) { *(.init.data) }
-  . = ALIGN(16);
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
+
+  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+	*(.init.data)
+
+	. = ALIGN(16);
   	__setup_start = .;
 	/* __setup_param() macro produces these,
 	 * obsolete_checksetup() processes them */
 	KEEP(*(.init.setup))
   	__setup_end = .;
-   }
-  .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
+
   	__initcall_start = .;
 	INITCALLS
   	__initcall_end = .;
-  }
-  .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
+
   	__con_initcall_start = .;
 	KEEP(*(.con_initcall.init))
   	__con_initcall_end = .;
-  }
-  SECURITY_INIT
-  . = ALIGN(4);
-  .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-  	__alt_instructions = .;
-	KEEP(*(.altinstructions))
-	__alt_instructions_end = .;
-  }
-  .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
-	/* No need to KEEP - referenced by .altinstructions */
-	*(.altinstr_replacement)
-  }
-  . = ALIGN(4);
-  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-  	__parainstructions = .;
-	KEEP(*(.parainstructions))
-  	__parainstructions_end = .;
-  }
-  /* .exit.text is discarded at runtime, not link time, to deal with references
-     from .altinstructions and .eh_frame */
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) { *(.exit.data) }
 
-#if defined(CONFIG_BLK_DEV_INITRD)
-  . = ALIGN(4096);
-  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-	__initramfs_start = .;
-	KEEP(*(.init.ramfs))
-	__initramfs_end = .;
+	/* TODO: can .exit.data be discarded at link time? */
+	*(.exit.data)
   }
-#endif
 
   . = ALIGN(4096);
   .percpu.data : AT(ADDR(.percpu.data) - LOAD_OFFSET) {
 	__per_cpu_start = .;
-	*(.percpu.data)
+	*(SORT_BY_ALIGNMENT(.percpu.data))
+	/* Dont move in front of .percpu.data, .percpu.data contains page-aligned stuff */
 	*(.percpu.shared_aligned.data)
 	__per_cpu_end = .;
   }
-  . = ALIGN(4096);
 
   /* End of "freed after init" portion */
 	
+  . = ALIGN(4096);
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */

--Boundary-00=_AAF6G1n/fGwpLP+--
