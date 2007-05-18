Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbXERKmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbXERKmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbXERKmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:42:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35152 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbXERKmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:42:00 -0400
Date: Fri, 18 May 2007 12:42:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/14] all-archs: consolidate .data section definition in asm-generic
Message-ID: <20070518104257.GA13811@uranus.ravnborg.org>
References: <20070518065257.GE12284@uranus.ravnborg.org> <20070518.001604.23011298.davem@davemloft.net> <20070518094231.GA13390@uranus.ravnborg.org> <20070518.032126.93383845.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518.032126.93383845.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 03:21:26AM -0700, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 18 May 2007 11:42:31 +0200
> 
> > On Fri, May 18, 2007 at 12:16:04AM -0700, David Miller wrote:
> > > 
> > > Looking at these patches reminds me of a quirk in the generic
> > > RODATA definition:
> > > 
> > > >  #define RODATA								\
> > > >  	. = ALIGN(4096);						\
> > > >  	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
> > > 
> > > It uses ALIGN(4096) which is likely supposed to be something
> > > like ALIGN(PAGE_SIZE).  Perhaps we should handle this by
> > > definiting a LD_PAGE_SIZE at the top of vmlinux.ld.S files
> > > that need a value other than 4096, and define the default of
> > > 4096 in asm-generic/vmlinux.lds.h?
> > 
> > I would much rather use PAGE_SIZE direct since we have access to that symbol.
> 
> I completely agree, that seems to be what platforms which have
> a configurable page size such as powerpc, ia64, etc. are already
> using in their vmlinux.lds.S files, and I'll likely follow suit on
> sparc64. :-)

If you hold of a bit I would like to use sparc64 as template for
a bit more consolidation.
Most likely I will try to consolidate vmlinux.lds for sparc64 and ARM
at the same time and then take the other arch's one by one.

In the process the vmlinux.lds will start to use a consistent
indenting like the following.

Sample diff only on top of -linus.
I will redo it when I have my current patch-set applied.

	Sam

diff --git a/arch/sparc64/kernel/vmlinux.lds.S b/arch/sparc64/kernel/vmlinux.lds.S
index 13fa2a2..e9469ea 100644
--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -9,105 +9,149 @@ ENTRY(_start)
 jiffies = jiffies_64;
 SECTIONS
 {
-  swapper_low_pmd_dir = 0x0000000000402000;
-  . = 0x4000;
-  .text 0x0000000000404000 :
-  {
-    _text = .;
-    *(.text)
-    SCHED_TEXT
-    LOCK_TEXT
-    KPROBES_TEXT
-    *(.gnu.warning)
-  } =0
-  _etext = .;
-  PROVIDE (etext = .);
-
-  RODATA
-
-  .data    :
-  {
-    *(.data)
-    CONSTRUCTORS
-  }
-  .data1   : { *(.data1) }
-  . = ALIGN(64);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-  . = ALIGN(64);
-  .data.read_mostly : { *(.data.read_mostly) }
-  _edata  =  .;
-  PROVIDE (edata = .);
-  .fixup   : { *(.fixup) }
-
-  . = ALIGN(16);
-  __start___ex_table = .;
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
-
-  . = ALIGN(8192);
-  __init_begin = .;
-  .init.text : { 
-	_sinittext = .;
-	*(.init.text)
-	_einittext = .;
-  }
-  .init.data : { *(.init.data) }
-  . = ALIGN(16);
-  __setup_start = .;
-  .init.setup : { *(.init.setup) }
-  __setup_end = .;
-  __initcall_start = .;
-  .initcall.init : {
-	INITCALLS
-  }
-  __initcall_end = .;
-  __con_initcall_start = .;
-  .con_initcall.init : { *(.con_initcall.init) }
-  __con_initcall_end = .;
-  SECURITY_INIT
-  . = ALIGN(4);
-  __tsb_ldquad_phys_patch = .;
-  .tsb_ldquad_phys_patch : { *(.tsb_ldquad_phys_patch) }
-  __tsb_ldquad_phys_patch_end = .;
-  __tsb_phys_patch = .;
-  .tsb_phys_patch : { *(.tsb_phys_patch) }
-  __tsb_phys_patch_end = .;
-  __cpuid_patch = .;
-  .cpuid_patch : { *(.cpuid_patch) }
-  __cpuid_patch_end = .;
-  __sun4v_1insn_patch = .;
-  .sun4v_1insn_patch : { *(.sun4v_1insn_patch) }
-  __sun4v_1insn_patch_end = .;
-  __sun4v_2insn_patch = .;
-  .sun4v_2insn_patch : { *(.sun4v_2insn_patch) }
-  __sun4v_2insn_patch_end = .;
+	swapper_low_pmd_dir = 0x0000000000402000;
+	. = 0x4000;
+	.text 0x0000000000404000 : {
+		_text = .;
+		*(.text)
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		*(.gnu.warning)
+	} =0
+	_etext = .;
+	PROVIDE (etext = .);
+
+	RODATA
+
+	.data : {
+		*(.data)
+		CONSTRUCTORS
+	}
+	.data1 : {
+		*(.data1)
+	}
+
+	. = ALIGN(64);
+	.data.cacheline_aligned : {
+		*(.data.cacheline_aligned)
+	}
+
+	. = ALIGN(64);
+	.data.read_mostly : {
+		*(.data.read_mostly)
+	}
+	_edata  =  .;
+	PROVIDE (edata = .);
+	.fixup : {
+		*(.fixup)
+	}
+
+	. = ALIGN(16);
+	__start___ex_table = .;
+	__ex_table : {
+		*(__ex_table)
+	}
+	__stop___ex_table = .;
+
+	. = ALIGN(8192);
+	__init_begin = .;
+	.init.text : {
+		_sinittext = .;
+		*(.init.text)
+		_einittext = .;
+	}
+
+	.init.data : {
+		*(.init.data)
+	}
+
+	. = ALIGN(16);
+	__setup_start = .;
+	.init.setup : {
+		*(.init.setup)
+	}
+	__setup_end = .;
+
+	__initcall_start = .;
+	.initcall.init : {
+		INITCALLS
+	}
+	__initcall_end = .;
+
+	__con_initcall_start = .;
+	.con_initcall.init : {
+		*(.con_initcall.init)
+	}
+	__con_initcall_end = .;
+	SECURITY_INIT
+
+	. = ALIGN(4);
+	__tsb_ldquad_phys_patch = .;
+	.tsb_ldquad_phys_patch : {
+		*(.tsb_ldquad_phys_patch)
+	}
+	__tsb_ldquad_phys_patch_end = .;
+
+	__tsb_phys_patch = .;
+	.tsb_phys_patch : {
+		*(.tsb_phys_patch)
+	}
+	__tsb_phys_patch_end = .;
+
+	__cpuid_patch = .;
+	.cpuid_patch : {
+		*(.cpuid_patch)
+	}
+	__cpuid_patch_end = .;
+
+	__sun4v_1insn_patch = .;
+	.sun4v_1insn_patch : {
+		*(.sun4v_1insn_patch)
+	}
+	__sun4v_1insn_patch_end = .;
+	__sun4v_2insn_patch = .;
+	.sun4v_2insn_patch : {
+		*(.sun4v_2insn_patch)
+	}
+	__sun4v_2insn_patch_end = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(8192); 
-  __initramfs_start = .;
-  .init.ramfs : { *(.init.ramfs) }
-  __initramfs_end = .;
+	. = ALIGN(8192); 
+	__initramfs_start = .;
+	.init.ramfs : {
+		*(.init.ramfs)
+	}
+	__initramfs_end = .;
 #endif
 
-  . = ALIGN(8192);
-  __per_cpu_start = .;
-  .data.percpu  : { *(.data.percpu) }
-  __per_cpu_end = .;
-  . = ALIGN(8192);
-  __init_end = .;
-  __bss_start = .;
-  .sbss      : { *(.sbss) *(.scommon) }
-  .bss       :
-  {
-   *(.dynbss)
-   *(.bss)
-   *(COMMON)
-  }
-  _end = . ;
-  PROVIDE (end = .);
-  /DISCARD/ : { *(.exit.text) *(.exit.data) *(.exitcall.exit) }
-
-  STABS_DEBUG
-
-  DWARF_DEBUG
+	. = ALIGN(8192);
+	__per_cpu_start = .;
+	.data.percpu  : {
+		*(.data.percpu)
+	}
+	__per_cpu_end = .;
+	. = ALIGN(8192);
+	__init_end = .;
+	__bss_start = .;
+	.sbss : {
+		*(.sbss)
+		*(.scommon)
+	}
+	.bss : {
+		*(.dynbss)
+		*(.bss)
+		*(COMMON)
+	}
+	_end = . ;
+	PROVIDE (end = .);
+
+	/DISCARD/ : {
+		*(.exit.text)
+		*(.exit.data)
+		*(.exitcall.exit)
+	}
+
+	STABS_DEBUG
+	DWARF_DEBUG
 }
