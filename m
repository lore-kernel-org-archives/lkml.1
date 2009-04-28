Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZD1JCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZD1JCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZD1JCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:02:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbZD1JCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:02:37 -0400
Date: Tue, 28 Apr 2009 11:02:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       hpa@c2micro.com, tglx@linutronix.de, hpa@linux.intel.com,
       jeremy.fitzhardinge@citrix.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: linker script: avoid ALIGN statements
	inside output sections
Message-ID: <20090428090211.GD26487@elte.hu>
References: <tip-c707f31e2e6af2d37bc742c31be0c7e96946c71f@git.kernel.org> <20090428081455.GA19736@elte.hu> <20090428083804.GB17622@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428083804.GB17622@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Tue, Apr 28, 2009 at 10:14:55AM +0200, Ingo Molnar wrote:
> > 
> > * tip-bot for H. Peter Anvin <hpa@c2micro.com> wrote:
> > 
> > > Commit-ID:  c707f31e2e6af2d37bc742c31be0c7e96946c71f
> > > Gitweb:     http://git.kernel.org/tip/c707f31e2e6af2d37bc742c31be0c7e96946c71f
> > > Author:     H. Peter Anvin <hpa@c2micro.com>
> > > AuthorDate: Mon, 27 Apr 2009 13:09:45 -0700
> > > Committer:  H. Peter Anvin <hpa@c2micro.com>
> > > CommitDate: Mon, 27 Apr 2009 13:09:45 -0700
> > > 
> > > x86: linker script: avoid ALIGN statements inside output sections
> > > 
> > > ALIGN statements inside output sections means that the alignment 
> > > padding ends up part of the section.  This causes real problems 
> > > when the section is otherwise empty.  ALIGN can be done either 
> > > before the output section or as part of the output section header; 
> > > the latter has the advantage that the alignment information is 
> > > propagated into the appropriate ELF headers.
> > > 
> > > Without this patch, we produce invalid kernels in certain 
> > > configurations involving X86_VSMP.
> > > 
> > > Reported-and-tested-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > 
> > > 
> > > ---
> > >  arch/x86/kernel/vmlinux_32.lds.S |   45 +++++++++++++++-----------------
> > >  arch/x86/kernel/vmlinux_64.lds.S |   52 +++++++++++++++++--------------------
> > >  2 files changed, 45 insertions(+), 52 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
> > > index 62ad500..7197db8 100644
> > > --- a/arch/x86/kernel/vmlinux_32.lds.S
> > > +++ b/arch/x86/kernel/vmlinux_32.lds.S
> > > @@ -37,8 +37,7 @@ SECTIONS
> > >    } :text = 0x9090
> > >  
> > >    /* read-only */
> > > -  .text : AT(ADDR(.text) - LOAD_OFFSET) {
> > > -	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
> > > +  .text : AT(ADDR(.text) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
> > >  	*(.text.page_aligned)
> > >  	TEXT_TEXT
> > >  	SCHED_TEXT
> > > @@ -52,8 +51,8 @@ SECTIONS
> > >  
> > >    NOTES :text :note
> > >  
> > > -  . = ALIGN(16);		/* Exception table */
> > > -  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
> > > +  /* Exception table */
> > > +  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) ALIGN(16) {
> > 
> > 
> > this construct breaks older toolchains:
> > 
> > /opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld:arch/x86/kernel/vmlinux.lds:138: 
> > parse error
> > 
> > titan:~/tip> 
> > /opt/crosstool/gcc-4.2.3-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld -v
> > GNU ld version 2.16.1
> > 
> > this is what it does not like:
> > 
> >  __ex_table : AT(ADDR(__ex_table) - 0xffffffff80000000) ALIGN(16) {
> 
> Good to know. I was yesterday wondering why we did not use this. 
> As part of the .lds file cleanups I move ALIGN() out of the output 
> section as this is where it should be.

Below is hpa's fix merged up by me on top of your cleanups. That 
merge-up is incomplete as we lose these fixlets.

And in this form it's visible how we lose those cleanups you did - 
which werent really cleanups ... Please keep such side-effects apart 
from truly mechanic cleanups, whenever possible - it makes life 
really simpler.

	Ingo

diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 6d5a5b0..a297417 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -51,8 +51,7 @@ SECTIONS
 	NOTES :text :note
 
 	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
+	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) ALIGN(16) {
 		__start___ex_table = .;
 		 *(__ex_table)
 		__stop___ex_table = .;
@@ -62,8 +61,10 @@ SECTIONS
 
 	/* Align data segment to page size boundary */
 	. = ALIGN(PAGE_SIZE);
+
 	/* Data */
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+	.data :
+	AT(ADDR(.data) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		DATA_DATA
 		CONSTRUCTORS
 		/* End of data section */
@@ -72,28 +73,28 @@ SECTIONS
 
 
 	.data.cacheline_aligned :
-		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		*(.data.cacheline_aligned)
 	}
 
-	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
+	.data.read_mostly :
+	AT(ADDR(.data.read_mostly) - LOAD_OFFSET)
+	ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES)
+	{
 		*(.data.read_mostly)
 	}
 
-#define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_ADDR	(-10*1024*1024)
+#define VSYSCALL_PHYS_ADDR \
+	((LOADADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_VIRT_ADDR \
+	((ADDR(.data.read_mostly) + SIZEOF(.data.read_mostly) + 4095) & ~(4095))
 
-#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
-#define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
+#define VLOAD_OFFSET	(VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
+#define VLOAD(x)	(ADDR(x) - VLOAD_OFFSET)
 
-#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
-#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
+#define VVIRT_OFFSET	(VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
+#define VVIRT(x)	(ADDR(x) - VVIRT_OFFSET)
 
 	. = VSYSCALL_ADDR;
 	.vsyscall_0 : AT(VSYSCALL_PHYS_ADDR) {
@@ -151,20 +152,19 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-	/* init_task */
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		. = ALIGN(THREAD_SIZE);
+	.data.init_task :
+	AT(ADDR(.data.init_task) - LOAD_OFFSET) ALIGN(THREAD_SIZE) {
 		*(.data.init_task)
-	} :data.init
+	}:data.init
 
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
+	.data.page_aligned :
+	AT(ADDR(.data.page_aligned) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		*(.data.page_aligned)
 	}
 
-	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+	.smp_locks :
+	AT(ADDR(.smp_locks) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		/* might get freed after init */
-		. = ALIGN(PAGE_SIZE);
 		__smp_alt_begin = .;
 		__smp_locks = .;
 		*(.smp_locks)
@@ -173,8 +173,7 @@ SECTIONS
 		__smp_alt_end = .;
 	}
 
-	/* Init code and data */
-	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(PAGE_SIZE);		/* Init code and data */
 	__init_begin = .;	/* paired with __init_end */
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 		_sinittext = .;
@@ -188,8 +187,7 @@ SECTIONS
 		__initdata_end = .;
 	}
 
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		. = ALIGN(16);
+	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) ALIGN(16) {
 		__setup_start = .;
 		*(.init.setup)
 		__setup_end = .;
@@ -200,54 +198,46 @@ SECTIONS
 		INITCALLS
 		__initcall_end = .;
 	}
-
 	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
 		__con_initcall_start = .;
 		*(.con_initcall.init)
 		__con_initcall_end = .;
 	}
-
 	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 		__x86_cpu_dev_start = .;
 		*(.x86_cpu_dev.init)
 		__x86_cpu_dev_end = .;
 	}
-
 	SECURITY_INIT
 
-	. = ALIGN(8);
-	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) ALIGN(8) {
 		__parainstructions = .;
 		*(.parainstructions)
 		__parainstructions_end = .;
 	}
 
-	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
-		. = ALIGN(8);
+	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) ALIGN(8) {
 		__alt_instructions = .;
 		*(.altinstructions)
 		__alt_instructions_end = .;
 	}
-
 	.altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 		*(.altinstr_replacement)
 	}
 
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
-	 *  references from .altinstructions and .eh_frame
+	 * references from .altinstructions and .eh_frame
 	 */
 	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
 		EXIT_TEXT
 	}
-
 	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
 		EXIT_DATA
 	}
 
 #ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
+	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		__initramfs_start = .;
 		*(.init.ramfs)
 		__initramfs_end = .;
@@ -258,8 +248,8 @@ SECTIONS
 	/*
 	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
 	 * output PHDR, so the next output section - __data_nosave - should
-	 * start another section data.init2.  Also, pda should be at the head of
-	 * percpu area.  Preallocate it and define the percpu offset symbol
+	 * start another section data.init2.  Also, pda should be at the head
+	 * of percpu area.  Preallocate it and define the percpu offset symbol
 	 * so that it can be accessed as a percpu variable.
 	 */
 	. = ALIGN(PAGE_SIZE);
@@ -271,32 +261,29 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
 
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		__nosave_begin = .;
 		*(.data.nosave)
 		. = ALIGN(PAGE_SIZE);
 		__nosave_end = .;
-	} :data.init2
 	/* use another section data.init2, see PERCPU_VADDR() above */
+	} :data.init2
 
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		__bss_start = .;		/* BSS */
 		*(.bss.page_aligned)
 		*(.bss)
 		__bss_stop = .;
 	}
 
-	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
+	.brk : AT(ADDR(.brk) - LOAD_OFFSET) ALIGN(PAGE_SIZE) {
 		__brk_base = .;
 		. += 64 * 1024;		/* 64k alignment slop space */
 		*(.brk_reservation)	/* areas brk users have reserved */
 		__brk_limit = .;
 	}
 
-	_end = . ;
+	_end = .;
 
 	/* Sections to be discarded */
 	/DISCARD/ : {
@@ -306,6 +293,7 @@ SECTIONS
 	}
 
 	STABS_DEBUG
+
 	DWARF_DEBUG
 }
 
@@ -325,7 +313,7 @@ ASSERT((_end - _text <= KERNEL_IMAGE_SIZE),
 
 #ifdef CONFIG_SMP
 ASSERT((per_cpu__irq_stack_union == 0),
-        "irq_stack_union is not at start of per-cpu area");
+       "irq_stack_union is not at start of per-cpu area");
 #endif
 
 #ifdef CONFIG_KEXEC
