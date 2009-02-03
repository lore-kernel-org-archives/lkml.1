Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZBCCRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZBCCRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZBCCRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:17:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:45687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZBCCRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:17:23 -0500
Message-ID: <4987A8F3.1010702@kernel.org>
Date: Mon, 02 Feb 2009 18:16:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix kexec with vmlinux
References: <49878B88.8050602@kernel.org>
In-Reply-To: <49878B88.8050602@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix regression with kexec with vmlinux

split data.init into data.init, percpu, data.init2 sections
instead of let data.init wrap percpu secion.

so kexec loading will be happy that there will not have overlapping.

before patch have
Elf file type is EXEC (Executable file)
Entry point 0x200000
There are 6 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000200000 0xffffffff80200000 0x0000000000200000
                 0x0000000000ca6000 0x0000000000ca6000  R E    200000
  LOAD           0x0000000000ea6000 0xffffffff80ea6000 0x0000000000ea6000
                 0x000000000014dfe0 0x000000000014dfe0  RWE    200000
  LOAD           0x0000000001000000 0xffffffffff600000 0x0000000000ff4000
                 0x0000000000000888 0x0000000000000888  RWE    200000
  LOAD           0x00000000011f6000 0xffffffff80ff6000 0x0000000000ff6000
                 0x0000000000073086 0x0000000000a2d938  RWE    200000
  LOAD           0x0000000001400000 0x0000000000000000 0x000000000106a000
                 0x00000000001d2ce0 0x00000000001d2ce0  RWE    200000
  NOTE           0x00000000009e2c1c 0xffffffff809e2c1c 0x00000000009e2c1c
                 0x0000000000000024 0x0000000000000024         4

 Section to Segment mapping:
  Segment Sections...
   00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata __param 
   01     .data .init.rodata .data.cacheline_aligned .data.read_mostly 
   02     .vsyscall_0 .vsyscall_fn .vsyscall_gtod_data .vsyscall_1 .vsyscall_2 .vgetcpu_mode .jiffies 
   03     .data.init_task .smp_locks .init.text .init.data .init.setup .initcall.init .con_initcall.init .x86_cpu_dev.init .altinstructions .altinstr_replacement .exit.text .init.ramfs .bss 
   04     .data.percpu 
   05     .notes 


after patch got

Elf file type is EXEC (Executable file)
Entry point 0x200000
There are 7 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000200000 0xffffffff80200000 0x0000000000200000
                 0x0000000000ca6000 0x0000000000ca6000  R E    200000
  LOAD           0x0000000000ea6000 0xffffffff80ea6000 0x0000000000ea6000
                 0x000000000014dfe0 0x000000000014dfe0  RWE    200000
  LOAD           0x0000000001000000 0xffffffffff600000 0x0000000000ff4000
                 0x0000000000000888 0x0000000000000888  RWE    200000
  LOAD           0x00000000011f6000 0xffffffff80ff6000 0x0000000000ff6000
                 0x0000000000073086 0x0000000000073086  RWE    200000
  LOAD           0x0000000001400000 0x0000000000000000 0x000000000106a000
                 0x00000000001d2ce0 0x00000000001d2ce0  RWE    200000
  LOAD           0x000000000163d000 0xffffffff8123d000 0x000000000123d000
                 0x0000000000000000 0x00000000007e6938  RWE    200000
  NOTE           0x00000000009e2c1c 0xffffffff809e2c1c 0x00000000009e2c1c
                 0x0000000000000024 0x0000000000000024         4

 Section to Segment mapping:
  Segment Sections...
   00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata __param 
   01     .data .init.rodata .data.cacheline_aligned .data.read_mostly 
   02     .vsyscall_0 .vsyscall_fn .vsyscall_gtod_data .vsyscall_1 .vsyscall_2 .vgetcpu_mode .jiffies 
   03     .data.init_task .smp_locks .init.text .init.data .init.setup .initcall.init .con_initcall.init .x86_cpu_dev.init .altinstructions .altinstr_replacement .exit.text .init.ramfs 
   04     .data.percpu 
   05     .bss 
   06     .notes 

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/vmlinux_64.lds.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
@@ -22,6 +22,7 @@ PHDRS {
 #ifdef CONFIG_SMP
 	percpu PT_LOAD FLAGS(7);	/* RWE */
 #endif
+	data.init2 PT_LOAD FLAGS(7);	/* RWE */
 	note PT_NOTE FLAGS(0);	/* ___ */
 }
 SECTIONS
@@ -215,7 +216,7 @@ SECTIONS
   /*
    * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
    * output PHDR, so the next output section - __data_nosave - should
-   * switch it back to data.init.  Also, pda should be at the head of
+   * start another section data.init2.  Also, pda should be at the head of
    * percpu area.  Preallocate it and define the percpu offset symbol
    * so that it can be accessed as a percpu variable.
    */
@@ -232,7 +233,7 @@ SECTIONS
   __nosave_begin = .;
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
       *(.data.nosave)
-  } :data.init	/* switch back to data.init, see PERCPU_VADDR() above */
+  } :data.init2 /* use another section data.init2, see PERCPU_VADDR() above */
   . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
