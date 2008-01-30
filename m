Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYA3BQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYA3BQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYA3BQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:16:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbYA3BQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:16:14 -0500
Date: Wed, 30 Jan 2008 02:15:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080130011550.GA31853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest x86 git tree from:

    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Find the shortlog attached below.

Most of the changes we have described here:

    http://lkml.org/lkml/2008/1/21/230

It's not a small merge, it consists of 908 commits from 96 individual 
arch/x86 developers (!):

    671 files changed, 42791 insertions(+), 38967 deletions(-)

so here are a few highlevel comments as well, in addition to the 
shortlog:

- a number of core files are changed as well: most notably percpu,
  debugging details, timers, the firewire remote debugging patch and ...
  the KGDB remote debugging stub in kernel/kgdb.c.

- we tested KGDB to be merge-worthy within the x86 architecture (the 
  only supported architecture for now) and it's better to have 
  kernel/kgdb.c than arch/x86/kernel/kgdb.c. The code is reasonably 
  clean and the user-space exposure is small - the only real exposure is 
  the decades-old remote GDB protocol. We are happy to fix up any 
  further cleanliness comments that people might have - but we really 
  wanted to start somewhere and get this thing moving. As an added 
  bonus: finally a kernel debugger that can be read without puking too
  much ;-) [anyone remember KDB?]

- the core timer and genirq changes are pushed via x86.git for 
  convenience reasons, we tested them inside x86.git for a long time.

- the module loader bits have been seen and acked by Rusty - work is 
  going on in parallel to make those bits cleaner, but they are no 
  merge-stopper for him now.

- the ptrace/regset bits from Roland are tied to x86 regset support and 
  affect no other architecture. (but they enable easy regset merging for 
  other architectures in the future)

- the lockbreak cleanup patches are tied to the ticket spinlocks and big 
  ticket spinlocks - hence the changes to fs/*.

- the changes to agp drivers are mechanic, due to the CPA API cleanups 
  and fixes. Behavior is not supposed to change, a number of drivers 
  were tested in that category and no breakage is known at the moment. 
  (see further below about the CPA changes)

- a sizable portion of the queue is the 120 patches strong CPA/ioremap 
  rewrite. Tons of bugs fixed and we now think it's a dependable basis. 
  Because this is the riskiest item we've placed it near the end of our
  queue, in a way that makes it easy to revert/mute the riskiest (or
  all) aspects of these changes. [ NOTE: these CPA fixes, due to their 
  intrusiveness are not backmergable into v2.6.24. Sorry about that, but
  pushing 100+ patches into stable is just not realistic. ]

- the PAT patches are not included yet - they were breaking too many 
  boxes and were exposing too many hardware details that we are 
  neither handling right nor do we have them all mapped yet to a 
  sufficient degree. Also, the basic CPA machinery has to be dependable 
  before we can start putting in the hard cache attribute constraints 
  that PAT requires. The CPA changes are fully compatible with all known 
  driver details and there's no known breakage at the moment.

- there's full 64-bit paravirt support now - but no hypervisor bindings 
  yet. These might show up a bit later as they are rather isolated (in 
  fact i'd expect them to show up real soon ;) - important was to get 
  the core changes cleaned up, integrated and tested.

- PIE/brk randomization. Not a single regression happened due to this so 
  far (and it's been in x86.git for months) - it seems exec-shield has
  rooted out stuff years ago - but we'll see. Details in the patch. It's 
  easily revertable in any case.

- new debugging feature: init memory permanently unmapped from the 
  direct mappings, to catch __init section bugs faster. This could 
  trigger in other subsystems. Right now dependent on 
  CONFIG_DEBUG_PAGEALLOC=y.

- if we forgot to mention any important item it's due to sheer
  exhaustion :-/ Please ask and we'll explain anything that is missing.

the x86.git queue has been built and booted on 32-bit and 64-bit x86, 
allnoconfig and allyesconfig [the new CONFIG_SIS190 gigabit driver in 
-git has been disabled because it has build failures], including a real 
legacy i386 DX 33 MHz system which successfully booted x86.git today.

In the past few weeks tens of thousands of random x86.git bzImages were 
successfully built and booted on a number of (commodity) 32-bit and 
64-bit testsystems - and there has been a fair amount of test exposure 
on -mm as well. We expect the x86.git changes to be pretty robust - if 
any problems there are they should be under more specialized conditions. 
(or due to very recent changes that we kept at the tail of the commit 
list) Famous last words? :)

	Ingo, Thomas

------------------>
Aaron Durbin (1):
      x86: add ACPI reboot option

Abhishek Sagar (2):
      x86: kprobes change kprobe_handler flow
      x86: fix singlestep handling in reenter_kprobe

Adrian Bunk (8):
      x86: unexport __{read,write}_lock_failed
      x86 e820_64.c: make 2 functions static
      x86 mce_64.c: make struct mcelog static
      x86: nmi_64.c: make code static
      x86: pci-calgary_64.c: make a variable static
      x86: pci-dma_64.c: cleanups
      x86: remove -maccumulate-outgoing-args on 32-bit
      x86: default to PCI=y

Alan Cox (3):
      x86: isolate PIC/PIT in/out calls
      x86: serverworks: IRQ routing needs no _p
      x86: reboot: remove inb_p usage

Alistair John Strachan (1):
      x86: force enable HPET on (some?) ICH9 boards

Ananth N Mavinakayanahalli (1):
      x86: kprobes: add kprobes smoke tests that run on boot

Andi Kleen (49):
      clocksource: make clocksource watchdog cycle through online CPUs
      x86: untable __init references between IO data
      x86: make ptrace.h safe to include from assembler code
      x86: implement support to synchronize RDTSC through MFENCE on AMD CPUs
      x86: Implement support to synchronize RDTSC with LFENCE on Intel CPUs
      x86: move nop declarations into separate include file
      x86: introduce rdtsc_barrier()
      x86: remove get_cycles_sync
      x86: remove the now unused X86_FEATURE_SYNC_RDTSC
      x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection
      x86: allow TSC clock source on AMD Fam10h and some cleanup
      x86: remove explicit C3 TSC check on 64bit
      x86: don't disable TSC in any C states on AMD Fam10h
      genirq: turn irq debugging options into module params
      x86: add /proc/irq/*/spurious to dump the spurious irq debugging state
      x86: remove CPU capabitilites printks on 32-bit
      x86: document fdimage/isoimage completely in make help
      x86: compile apm and voyager module only when selected in Kconfig
      x86: Set CFQ as default in 32-bit defconfig
      x86: mark memory_setup __init
      x86: move MWAIT idle check to generic CPU initialization on 32-bit
      x86: use the correct cpuid method to detect MWAIT support for C states
      x86: use shorter addresses in i386 segfault printks
      x86: replace hard coded reservations in 64-bit early boot code with dynamic table
      x86: optimize lock prefix switching to run less frequently
      x86: don't disable the APIC if it hasn't been mapped yet
      x86: print which shared library/executable faulted in segfault etc. messages v3
      x86: add framework to disable CPUID bits on the command line
      x86: convert some existing cpuid disable options to new generic bitmap
      x86: don't disable RDTSC in userland for 32bit notsc
      x86: convert TSC disabling to generic cpuid disable bitmap
      x86: add noclflush option
      x86: add generic clearcpuid=... option
      x86: remove iBCS support
      c_p_a(): do a simple self test at boot
      x86: clean up pte_exec
      x86: add pte accessors for the global bit
      x86: c_p_a(), add simple self test at boot
      x86: cpa: use wbinvd() macro instead of inline assembly in 64bit c_p_a()
      x86: cpa: remove unnecessary masking of address
      x86: shrink __PAGE_KERNEL/__PAGE_KERNEL_EXEC on non PAE kernels
      x86: add pte_pgprot to 32-bit
      x86: don't drop NX bit in pte modifier functions on 32-bit
      x86: fix c_p_a() boot crash
      x86: c_p_a() fix: reorder TLB / cache flushes to follow Intel recommendation
      x86: c_p_a() make it more robust against use of PAT bits
      x86: introduce canon_pgprot()
      x86: remove set_kernel_exec()
      x86: fix early_ioremap() on 64-bit

Andreas Herrmann (1):
      x86: fix detection of CONSTANT_TSC bit for AMD CPUs

Andreas Herrmann3 (1):
      x86: fix cpu MHz reporting for AMD family 0x11

Andres Salomon (1):
      x86: GEODE: update GPIO API to support setting multiple GPIOs at once

Andrew Morton (9):
      x86: kmap_atomic() debugging
      x86: PIE executable randomization, checkpatch fixes
      x86: PIE executable randomization, uninlining
      x86: __vdso_getcpu() warning fix
      x86: arch/x86/kernel/cpu/mcheck/ checkpatch fixes
      x86: arch/x86/kernel/cpu/mcheck/k7.c checkpatch fixes
      x86: arch/x86/math-emu/errors.c: fix printk warnings
      git-x86: drivers/pnp/pnpbios/bioscalls.c build fix
      arch/x86/mm/numa_64.c: section fix

Arjan van de Ven (20):
      debug: move WARN_ON() out of line
      debug: add the end-of-trace marker and the module list to
      x86: fix 32-bit FRAME_POINTER chasing code
      x86: add the capability to print fuzzy backtraces
      x86: improve the 32 bit Frame Pointer backtracer to also use the traditional backtrace
      x86: pull bp calculation earlier into the backtrace path
      x86: turn 64 bit x86 HANDLE_STACK into print_context_stack like 32 bit has
      x86: use the stack frames to get exact stack-traces for CONFIG_FRAMEPOINTER on x86-64
      x86: add a simple backtrace test module
      x86: add the "print code before the trapping instruction" feature to 64 bit
      x86: make printk_address regs->ip always reliable
      x86: turn the check_exec function into function that
      x86: a new API for drivers/etc to control cache and other page attributes
      x86: convert CPA users to the new set_page_ API
      x86: deprecate change_page_attr() for drivers
      x86: make various pageattr.c functions static
      x86: fix pageattr-selftest
      x86: make sure initmem is writable
      x86: add testcases for RODATA and NX protections/attributes
      x86: move misplaced rodata check call

Atsushi Nemoto (1):
      clocksource: make CLOCKSOURCE_MASK bullet-proof

Balaji Rao (2):
      x86: assign IRQs to HPET timers
      x86: assign IRQs to HPET timers, fix

Benjamin LaHaise (1):
      x86: fix synchronize_rcu(): high latency on idle system

Bernhard Kaindl (1):
      x86: early boot debugging via FireWire (ohci1394_dma=early)

Bernhard Walle (3):
      x86: remove extern declarations for code, data, bss resources
      x86, rtc: make CONFIG_HPET_EMULATE_RTC usable from modules
      rtc: use the IRQ callback interface in (old) RTC driver

Borislav Petkov (1):
      x86: vmlinux_32.lds.S: remove repeated comment from the x86-32 linker script

Carlos R. Mafra (2):
      x86: fix style errors in nmi_int.c
      x86: clean up k8topology.c

Chris Wright (2):
      x86: fix ioport unification on 32-bit
      x86: refactor ioport unification

Christoph Lameter (1):
      x86: 64-bit, make sparsemem vmemmap the only memory model

Cyrill Gorcunov (6):
      x86: remove dead code in ia32-emu
      x86: clean up include/asm-x86/pda.h
      x86: cleanup i387_32.c according to checkpatch
      x86: coding style cleanup for kernel/bootflag.c
      x86: get rid of checkpatch.pl complains on apm_32.c
      x86: use KSYM_NAME_LEN

Daniel Walker (1):
      mcheck mce_64: mce_read_sem to mutex

Dave Jones (2):
      x86: remove more bogus filenames in comments.
      x86: use CR0 defines.

Dmitri Vorobiev (1):
      x86_32: remove the useless NR_syscalls macro

Eduardo Habkost (3):
      x86: include/asm-x86/paravirt.h: x86_64 mmu operations
      x86: don't set pagetable_setup_{start,done} hooks on 64-bit
      x86: fill in missing pv_mmu_ops entries for PAGETABLE_LEVELS >= 3

Eduardo Pereira Habkost (2):
      x86: allow enabling PARAVIRT without any guest implementation
      x86: remove depends on X86_32 from PARAVIRT & PARAVIRT_GUEST

Eric Dumazet (1):
      x86: make arch/x86/kernel/acpi/wakeup_32.S use a separate

Florian Fainelli (4):
      x86: add generic GPIO support to x86
      pci: add PCI identifiers for the RDC devices
      x86: add support for the RDC R-321x SoC
      x86: add the RDC machine specific reboot fixup

Gary Hade (1):
      PCI: remove default PCI expansion ROM memory allocation

Geert Uytterhoeven (1):
      time: fold __get_realtime_clock_ts() into getnstimeofday()

Glauber de Oliveira Costa (97):
      x86: irqflags consolidation
      x86: consolidate spinlock.h
      x86: wipe out traditional opt from x86_64 Makefile
      x86: unify msr smp funcs
      x86: allow sched clock to be overridden by paravirt
      x86: split get_cycles_sync
      x86: unify cpuid functions
      x86: introduce native_read_tscp
      x86: change rdpmc interface
      x86: change write msr functions interface
      x86: make fixups wordsize agnostic
      x86: integrate 32-bit and 64-bit code in msr.h
      x86: remove volatile keyword from clflush.
      x86: put together equal pieces of system.h
      x86: unify load_segment macro
      x86: unify paravirt parts of system.h
      x86: remove unused macro
      x86: unify smp parts of system.h
      x86: move switch_to macro to system.h
      x86: unify system.h
      x86: put get_kernel_rpl in a common location
      x86: unify common parts of segment.h
      x86: remove arch specific segment headers
      x86: export math_state_restore
      x86: export cpu_gdt_descr
      x86: turn priviled operation into a macro in head_64.S
      x86: prepare time related functions for paravirt
      x86: tweak io_64.h for paravirt.
      x86: prepare 64-bit architecture initialization for paravirt
      x86: unify desc_struct
      x86: unify struct desc_ptr
      x86: change gdt acessor macro name
      x86: removed unused variable
      x86: introduce gate_desc type.
      x86: change write_idt_entry signature
      x86: introduce ldt_desc type.
      x86: modify write_ldt function
      x86: introduce fill_ldt
      x86: provide tss_desc
      x86: change write_gdt_entry signature.
      x86: change write_ldt_entry signature
      x86: move constants to desc_defs.h
      x86: unify non-paravirt parts of desc.h
      x86: use the same data type for tls_array.
      x86: modify get_desc_base
      x86: unify paravirt pieces of descriptor handling
      x86: move _set_gate and its users to a common location
      x86: unify set_tss_desc
      x86: avoid ifdefs in desc.h, getting rid of pack_ldt and pack_tss
      x86: move tsc definitions to were they belong
      x86: get rid of _MASK flags
      x86: move desc_empty to where they belong
      x86: move load_cr3 to a common place.
      x86: unify paravirt pieces of processor.h
      x86: move the definition of set_iopl_mask to common header
      x86: unify common parts of processor.h
      x86: unify current_text_addr
      x86: unify tss_struct
      x86: provide 64-bit with a load_sp0 function.
      x86: unify thread struct.
      x86: unify TASK_ALIGN definitions
      x86: change bitwise operations to get a void parameter.
      x86: unify x86_cpuinfo struct.
      x86: remove legacy stuff from processor_64.h
      x86: unify mm_segment_t definition
      x86: move definitions to processor.h
      x86: unify prefetch operations
      x86: unify asm nops
      x86: move i387 definitions to processor.h
      x86: remove __init modifier from header declaration
      x86: finish processor.h integration
      x86: change paravirt_32.c name
      x86: adjust PVOP_CALL/VCALL macros for 64-bit
      x86: cleanup write_tsc
      x86: provide paravirtualized hook for rdtscp
      x86: change assembly definition of paravirt_patch_site
      x86: adjust assembly macros on 64-bit as well.
      x86: change irq functions to accomodate 64-bit
      x86: add macro for privileged 64-bit operation
      x86: adds paravirt hook for swapgs
      x86: replace privileged instructions with paravirt macros
      x86: cleanup CLI_STRING, STI_STRING and friends
      x86: add CLBR_ defines for 64-bit
      x86: move patching code to arch-specific file.
      x86: patching functions on 64-bit
      replace x86_read/write_per_cpu with a common function.
      x86: add stringify header
      x86: provide a native_init_IRQ function on 64-bit
      x86: put generic mm_hooks include into PARAVIRT
      x86: puts read and write cr8 into pv_cpu_ops
      x86: provide read and write cr8 paravirt hooks
      x86: fill pv_cpu_ops structure with cr8 fields
      x86: add asm_offset PARAVIRT constants
      x86: provide __parainstructions section
      x86: change function orders in paravirt.h
      x86: export check_tsc_unstable
      x86: export __supported_pte_mask

Greg KH (1):
      kobj: fix threshold_init_device/kobject_uevent_env oops

Guillaume Chazarain (1):
      x86: scale cyc_2_nsec according to CPU frequency

H. Peter Anvin (21):
      x86: add <asm/asm.h>
      x86: unify asm/cpufeature.h
      x86: prepare merger of <asm/alternative_{32,64}.h>
      x86: actually merge <asm/alternative.h>
      x86: rename the struct pt_regs members for 32/64-bit consistency
      x86: use generic register names in struct user_regs_struct
      x86: use generic register names in struct sigcontext
      x86: use generic register name in the thread and tss structures
      i386: handle an initrd in highmem (version 2)
      x86: <asm/segment.h>: boot GDT entries are 32/64-independent
      x86 setup: make PM transition more paranoid; cleanup 32-bit entry
      x86 setup: initialize LDTR and TR to make life easier to Intel VT
      x86 setup: use X86_CR0_PE macro instead of hard-coded constant
      x86 setup: display VESA graphics modes in vga=ask menu
      x86 setup: fix constraints in segment accessor functions
      x86 setup: OK -> ok (no need to scream)
      x86 setup: add missing prototype; formatting fix
      x86 setup: add note to use edd=off on EDD probing hangs
      x86 setup: push video mode setup as late as possible
      x86 setup: guard the heap against invalid stack setups
      x86 setup: correct the base in the GDT_ENTRY() macro

Harvey Harrison (56):
      x86: use def_bool where possible
      x86: use def_bool where possible in Kconfig.cpu
      x86: unify include/asm-x86/linkage_[32|64].h
      x86: unify mmap_{32|64}.c
      UML: remove remaining FASTCALL uses
      x86: remove last users of FASTCALL
      core: remove last users of empty FASTCALL macro
      x86: remove all definitions with fastcall
      x86: remove fastcall from include/asm-x86
      x86: clean up local_{32|64}.h
      x86: fix asm memory constraints in local_64.h
      x86: introduce asm helpers in local_{32|64}.h
      x86: unify local_{32|64}.h
      x86: local.h fix checkpatch warnings
      x86: unify kexec_{32|64}.h
      x86: unify extable_{32|64}.c
      x86: use helper in fault_64.c
      x86: kprobes leftover cleanups
      x86: unify module_{32|64}.h
      x86: add reenter_kprobe helper
      x86: introduce REX prefix helper for kprobes
      x86: kprobes remove fix_riprel #ifdef
      x86: cosmetic fixes fault_{32|64}.c
      x86: kprobes change kprobe_handler flow
      x86: fault_32.c cleanup
      x86: begin fault_{32|64}.c unification
      x86: introduce force_sig_info_fault helper to X86_64
      x86: introduce __die helper to X86_32
      x86: more users of PF_ constants in fault_32|64.c
      x86: use fixup_exception() in traps_64.c
      x86: move get_segment_eip() to step.c
      x86: trivial whitespace in kprobes.c
      x86: use wrmsrl in kprobes.c, step.c
      x86: common x86_32|64 naming
      x86: remove last user of get_segment_eip
      x86: do_page_fault small unification
      x86: last of trivial fault_32|64.c unification
      x86: function ifdefs in fault_32|64.c
      x86: unify pt_regs accessors ptrace.h
      x86: clean up ptrace.h
      x86: rename stack_pointer to kernel_trap_sp
      x86: unify printk strings in fault_32|64.c
      x86: use v8086_mode helper, trivial unification
      x86: add vdso32-int80-syms.lds to .gitignore
      x86: update reliability argument to printk_address
      x86: make printk_address available on X86_32
      x86: add dump_pagetable helper to X86_32
      x86: add is_f00f_bug helper to fault_32|64.c
      x86: add is_errata100 helper to fault_32|64.c
      x86: introduce show_fault_oops helper to fault_32|64.c
      x86: unify page fault oops printing
      x86: unify fault_32|64.c by ifdef'd function bodies
      x86: unify fault_32|64.c with ifdefs
      x86: unify fault_32|64.c
      x86: remove nx_enabled from fault.c
      x86: shrink some ifdefs in fault.c

Hiroshi Shimamoto (11):
      x86: enable irq in default_idle on 64-bit
      x86: io_apic_64.c: remove unused config check
      x86: clean up nmi_32/64.c
      x86: clean up process_32/64.c
      x86: clean up apic_32/64.c
      x86: clean up apic_32.c, take 2
      x86: move out tick_nohz_stop_sched_tick() call from the loop
      x86: kdump failure
      x86: move warning message of polling idle and HT enabled
      x86: move select_idle_routine() call after detect_ht()
      x86: remove struct cpu_model_info

Huang, Ying (17):
      x86: EFI runtime service support
      x86: EFI runtime service support: EFI runtime services
      x86: EFI runtime service support: document for EFI runtime services
      x86: EFI runtime service support: remove duplicated code from efi_32.c
      x86 boot: use E820 memory map on EFI 32 platform
      x86: 32-bit EFI runtime service support: fixes in sync with 64-bit support
      x86 boot : export boot_params via debugfs for debugging
      i386 boot: replace boot_ioremap with enhanced bt_ioremap - enhance bt_ioremap
      x86: replace boot_ioremap() with enhanced bt_ioremap() - remove boot_ioremap()
      x86 32-bit boot: rename bt_ioremap() to early_ioremap()
      x86: early_ioremap_reset fix
      x86: make early_ioremap_debug early_param
      x86: fix some bugs about EFI runtime code mapping
      x86: fix NX bit handling in change_page_attr()
      x86: ioremap_nocache fix
      x86: use reboot_type on EFI 32
      x86: fixes some bugs about EFI memory map handling

Ian Campbell (11):
      x86_32: remove unnecessary use of %ebx as the boot cpu flag
      x86_32: always run the full set of paging state.
      x86: unify whitespace and comments in arch/x86/boot/compressed/vmlinux_??.lds
      x86: unify whitespace in arch/x86/boot/compressed/vmlinux_??.scr
      x86: switch to .rodata.compressed in arch/x86/boot/compressed/vmlinux_??.scr
      x86: unify arch/x86/boot/compressed/vmlinux_??.scr
      x86: unify strings in arch/x86/boot/compressed/misc_??.c
      x86: unify whitespace and comments in arch/x86/boot/compressed/misc_??.c
      x86: unify headers in arch/x86/boot/compressed/misc_??.c
      x86: unify variable names in arch/x86/boot/compressed/misc_??.c
      x86: unify arch/x86/boot/compressed/misc_??.c

Ingo Molnar (124):
      x86: offer is_hpet_enabled() on !CONFIG_HPET_TIMER too
      x86: make clockevents more robust
      x86: various changes and cleanups to in_p/out_p delay details
      x86: make io_delay=0xed the default
      x86: add DMI quirk for io-delay hangs on Compaq Presario V6000 laptops
      x86: idle wakeup event in the HLT loop
      x86: clean up arch/x86/kernel/aperture_64.c
      x86: clean up arch/x86/kernel/aperture_64.c printk()s
      x86: mach-voyager, lindent
      x86: lindent arch/i386/math-emu
      x86: lindent arch/i386/math-emu, cleanup
      x86: code cleanups in arch/x86/kernel/pci-gart_64.c
      x86: clean up drivers/char/rtc.c
      x86: avoid build warning
      x86: dummy placeholder for acpi/reboot.h
      x86: replace outb_p() with udelay(2) in drivers/input/mouse/pc110pad.c
      x86: remove unused include/asm-x86/processor_32/64.h
      x86: add some pirq debugging
      x86: hlt on early crash
      x86: debug: double-check the empty zero page
      x86: lfence fix
      x86: move native_read_tsc() offline
      x86: map vsyscalls early enough
      x86: read_tsc sync
      x86: fix sched_clock()
      x86: page.h: move and unify types for pagetable entry, #1
      x86: page.h: move and unify types for pagetable entry, #2
      x86: page.h: move and unify types for pagetable entry, #3
      x86: page.h: move and unify types for pagetable entry, #4
      x86: page.h: move and unify types for pagetable entry, #5
      x86: page.h: move and unify types for pagetable entry, #6
      x86: clean up include/asm-x86/calling.h
      x86: clean up arch/x86/mm/fault_64.c
      x86: migration helpers for KVM
      x86: add PWT to NOCACHE flags
      x86/pgtable: fix constant sign extension problem
      x86/pgtable: unify pagetable accessors, #1
      x86/pgtable: unify pagetable accessors, #2
      x86/pgtable: unify pagetable accessors, #3
      x86/pgtable: unify pagetable accessors, #4
      x86/pgtable: unify pagetable accessors, #5
      x86: unify pgtable accessors which use, #2
      x86: fix pte_modify() bug
      x86: fix UML and -regparm=3
      x86: make early printk selectable on 64-bit as well
      x86: smp_scan_config() debugging printouts
      x86: pat: e820 cleanup
      x86: fix DMI ioremap leak
      x86: early fault debugging improvement
      x86: add debug of invalid per_cpu map accesses
      x86: check_tsc_warp() slowness fix
      x86: add warning to check_tsc_warp()
      x86: fix up alternatives with lockdep enabled
      genirq: stackdump after the "Trying to free already-free IRQ" message
      x86: get_cycles() fix
      x86: clean up paging_init()
      x86: fix DEBUG_RODATA kconfig text
      x86: improve MTRR trimming messages
      kgdb: cleanup header section
      pid: add pid_max prototype
      kgdb: eliminate KGDB_WRITE_TEST
      kgdb: eliminate KGDB_READ_TEST
      kgdb: cleanups
      kgdb: cleanups
      x86: change ioremap() to default to uncached
      x86: clean up arch/x86/mm/pageattr_32.c
      x86: clean up arch/x86/mm/pageattr_64.c
      x86: return the page table level in lookup_address()
      x86: clean up arch/x86/mm/pageattr-test.c
      x86: enhance early_ioremap()
      x86: increase the number of boot-mappings
      x86: add debug warnings to early_ioremap()
      x86: early_ioremap(), debugging
      x86: add early_ioremap() leak detection
      x86: fix early_ioremap()/btmap
      x86: fix EISA ioremap
      x86: early_ioremap_init(), enhance warnings
      x86: fix more non-global TLB flushes
      x86: simplify the 32-bit cpa code
      x86: simplify 32-bit cpa largepage splitting
      x86: further cpa largepage-split cleanups
      x86: cpa self-test fixes
      x86: simplify cpa largepage split, #3
      x86: cpa: simplify locking
      x86: do not PSE on CONFIG_DEBUG_PAGEALLOC=y
      x86: cpa self-test, WARN_ON()
      x86: prepare for the unification of the cpa code
      x86: prepare for the unification of the cpa code
      x86: simplify pageattr_64.c
      x86: unify header part of pageattr_64.c
      x86: clean up and simplify 64-bit split_large_page()
      x86: introduce native_set_pte_atomic() on 64-bit too
      x86: simplify __change_page_attr()
      x86: change 64-bit __change_page_attr() to struct page
      x86: change 64-bit pageattr to use set_pte_atomic()
      x86: 64-bit pageattr.c, prepare for unification
      x86: 64-bit, add the new split_large_page() function
      x86: clean up differences between 64-bit and 32-bit
      x86: return -EINVAL in __change_page_attr(), instead of 0
      x86: add kernel_map_pages() to 64-bit
      x86: enable DEBUG_PAGEALLOC on 64-bit
      x86: backmerge 64-bit details into 32-bit pageattr.c
      x86: prepare for pageattr.c unification
      x86: unify pageattr_32.c and pageattr_64.c
      x86: re-add clflush_cache_range()
      x86: clean up arch/x86/mm/pageattr.c
      x86: keep the BIOS area executable
      x86: change cpa to pfn based
      x86: add PAGE_KERNEL_EXEC_NOCACHE
      x86: cpa: make self-test depend on DEBUG_KERNEL
      x86: cpa: move clflush_cache_range()
      x86: cpa: set_memory_notpresent()
      x86: remove flush_agp_mappings()
      x86: cpa: fix loop
      x86: ioremap KERN_INFO
      x86: fix clflush_page_range logic
      x86: init memory debugging
      x86: enable CONFIG_DEBUG_PAGEALLOC more widely
      x86: rodata config hookup
      x86: cpa: fix the self-test
      x86: make ioremap() UC by default
      x86: arch/x86/mm/init_64.c printk fixes
      x86: arch/x86/mm/init_32.c cleanup
      x86: arch/x86/mm/init_32.c printk fixes

Jan Beulich (9):
      i386: hard_{en,dis}able_TSC can be static
      x86-64: make pda's cpunumber and nodenumber unsigned
      x86-64: honor notify_die() returning NOTIFY_STOP
      x86: move to .rodata/.init.data
      x86: make __{save,restore}_processor_state static
      x86: adjust enable_NMI_through_LVT0()
      x86: also define AT_VECTOR_SIZE_ARCH
      x86-64: clean up linker script
      x86: adjust/fix LDT handling for Xen

Jan Engelhardt (2):
      x86: remove unneded casts
      x86: constify function pointer tables

Jan Kiszka (3):
      KGDB: various refactorings
      KGDB: various refactorings, #2
      KGDB: refactor kconfig menu

Jason Wessel (9):
      kgdb: core-lite
      x86: kgdb, clocksource_watchdog
      x86: kgdb, softlockup
      x86: kgdb, 8250
      x86: kgdb, lite
      x86: kgdb, sysrq_bugfix
      x86: kgdb, modules
      x86: kgdb, asm_debug
      KGDB: core code cleanups

Jeff Dike (2):
      UML: change sigcontext fields to match x86
      uml: add asm-um/asm.h

Jeremy Fitzhardinge (45):
      x86: partial unification of asm-x86/bitops.h
      x86: clean up bitops-related warnings
      x86: add set/clear_cpu_cap operations
      x86: kill mk_pte_huge
      x86: clean up mm/init_32.c
      x86: page.h: unify constants
      x86: page.h: unify page copying and clearing
      x86: add _AT() macro to conditionally cast
      x86: page.h: move and unify types for pagetable entry
      x86: page.h: move pa and va related things
      x86: page.h: move remaining bits and pieces
      x86: page.h: move things back to their own files
      x86/efi: fix improper use of lvalue
      x86: move all asm/pgtable constants into one place
      x86: avoid name conflict for Voyager leave_mm
      x86/pgtable: unify pagetable accessors, #6
      x86: mask NX from pte_pfn
      x86: unify pgtable accessors which use
      x86: page.h: make pte_t a union to always include
      x86/vmi: fix compilation as a result of pte_t changes
      x86: pgtable: unify pte accessors
      x86: fix warning
      x86: unify zero_page definition
      x86: unify paravirt pagetable accessors
      xen: mask out PWT too
      x86/pgtable: explain constant sign extension problem
      add native_pud_val and _pmd_val for 2 and 3
      x86/paravirt: rearrange common mmu_ops
      x86/paravirt: common implementation for pte value ops
      x86/paravirt: common implementation for pgd value ops
      x86/paravirt: common implementation for pmd value ops
      x86/paravirt: make set_pte operations common
      x86/paravirt: make set_pmd operation common
      x86/paravirt: make set_pud operation common
      xen: fix mismerge in masking pte flags
      x86: add mm parameter to paravirt_alloc_pd
      x86: demacro asm-x86/pgalloc_32.h
      xen: deal with pmd being allocated/freed
      x86: preallocate pmds at pgd creation time
      x86: allocate and initialize unshared pmds
      x86: ignore spurious faults
      x86: don't special-case pmd allocations as much
      x86: defer cr3 reload when doing pud_clear()
      x86: use the same pgd_list for PAE and 64-bit
      x86: fix early_ioremap pagetable ops

Jesse Barnes (1):
      x86, 32-bit: trim memory not covered by wb mtrrs

Jiri Kosina (2):
      x86: randomize brk
      x86: PIE executable randomization

Joachim Deguara (1):
      x86: add PCI IDs to k8topology_64.c

Joe Perches (1):
      arch/x86/: spelling fixes

Joerg Roedel (4):
      x86: define all _PAGE_* in terms of _PAGE_BIT_* on 64-bit
      x86: use __PAGE_KERNEL* instead of _KERNPG_TABLE
      x86: some whitespace cleanups in paging code
      x86: use __PAGE_KERNEL_EXEC in ioremap_64.c

John Reiser (1):
      x86: add ENDPROC() markers

Julia Lawall (3):
      arch/x86/ia32: use time_before, time_before_eq, etc.
      arch/x86/kernel/apm_32.c: use time_before, time_before_eq,
      arch/x86/kernel/io_apic_{64,32}.c: use time_before

Kyle McMartin (1):
      x86: 64-bit, remove redundant cpu_has_ definitions

Len Brown (1):
      x86: 32-bit IOAPIC: de-fang IRQ compression

Lucas Woods (1):
      x86: remove duplicate includes

Markus Metzger (10):
      x86, ptrace: support for branch trace store(BTS)
      x86, ptrace: remove bad comment
      x86, ptrace: use jiffies for BTS timestamps
      x86, ptrace: change BTS GET ptrace interface
      x86, ptrace: new ptrace BTS API
      x86, ptrace: rlimit BTS buffer allocation
      x86, ptrace: support 32bit-cross-64bit BTS recording
      x86, ptrace: add buffer size checks
      x86, ptrace: overflow signal API
      x86, ptrace: add bts_struct size to status command

Masami Hiramatsu (6):
      x86: kprobe-booster for x86-64
      x86: return probe-booster for x86-64
      x86: prepare kprobes code for x86 unification
      x86: kprobes code for x86 unification
      x86: fix kprobe_handler reenable preemption
      x86: move deeply indented code to reenter_kprobe

Mathieu Desnoyers (1):
      x86: fall back on interrupt disable in cmpxchg8b on 80386 and 80486

Mel Gorman (3):
      x86: make NUMA work on 32-bit again
      x86: make NUMA work on 32-bit
      x86: relax restrictions on setting CONFIG_NUMA on x86, #2

Michael Opdenacker (1):
      x86: fix unconditional arch/x86/kernel/pcspeaker.o compiling

Miguel Boton (1):
      x86: reboot_{32|64}.c unification

Mike Galbraith (1):
      x86: fix: s2ram + P4 + tsc = annoyance

Mike Travis (5):
      x86: prevent dereferencing non-allocated per_cpu variables
      x86: reduce memory and intra-node effects
      x86: fix early NUMA-id access
      x86: fix early cpu_to_node panic from nr_free_zone_pages
      x86/non-x86: percpu, node ids, apic ids x86.git fixup

Min Zhang (1):
      arch/x86/kernel/cpu/mcheck/p4.c: cleanups

Minoru Usui (1):
      x86: fix NUMA emulation on 64-bit

Neil Horman (2):
      x86, kexec: force x86 arches to boot kdump kernels on boot cpu
      x86: clean up arch/x86/kernel/early-quirks.c

Nick Piggin (4):
      spinlock: lockbreak cleanup
      x86: FIFO ticket spinlocks
      x86: reduce CONFIG_X86_PPRO_FENCE bloat
      x86: big ticket locks

Nikanth Karthikesan (1):
      x86: change x86 machine check handler to use unlocked_ioctl instead

Olof Johansson (1):
      debug: introduce __WARN()

Paolo Ciarrocchi (2):
      x86: coding style fixes in arch/x86/ia32/audit.c
      x86: coding style fixes in arch/x86/pci/fixup.c

Parag Warudkar (3):
      clocksource.c: use init_timer_deferrable for clocksource_watchdog
      x86: fix DMI out of memory problems
      x86: fix dmi_alloc() to not advance alloc index in case of

Paul Jimenez (2):
      x86: make i8259_64 more _32-like
      x86: mtrr use type bool [RESEND AGAIN]

Pavel Machek (4):
      time: clean hungarian notation from timers
      time: timer cleanups
      time: more timer related cleanups
      x86: unify arch/x86/kernel/acpi/sleep*.c

Quentin Barnes (1):
      x86: code clarification patch to Kprobes arch code

Rafael J. Wysocki (1):
      x86: hibernation: document __save_processor_state() on x86

Ralf Baechle (1):
      mips, x86: optimize the i8259 code a bit

Randy Dunlap (3):
      x86: bitops_32.h style cleanups
      x64/page.h: convert some macros to inlines
      x86: discover_ebda section mismatch

Rene Herman (1):
      x86: provide a DMI based port 0x80 I/O delay override.

Robert Richter (1):
      x86: extended interrupt LVT support for AMD Barcelona

Roland McGrath (101):
      x86: protect against sigaltstack wraparound
      x86 vDSO: generate vdso-syms.lds
      x86 vDSO: use vdso-syms.lds
      x86 vDSO: remove vdso-syms.o
      x86 vDSO: new layout
      x86 vDSO: harmonize asm-offsets
      x86 vDSO: arch/x86/vdso/vdso32
      x86 vDSO: vdso32 build
      x86 vDSO: i386 vdso32
      x86 vDSO: absolute relocs
      x86 vDSO: i386 vdso32 install
      x86 vDSO: vdso32 setup
      x86 vDSO: ia32_sysenter_target
      x86 vDSO: ia32 sysenter_return
      x86 vDSO: ia32 vdso32-syscall build
      x86 vDSO: consolidate vdso32
      x86 vDSO: ia32 vsyscall removal
      x86 vDSO: reorder vdso32 code
      x86 vDSO: makefile cleanup
      x86 vDSO: canonicalize sysenter .eh_frame
      x86: get_desc_base
      x86: use get_desc_base
      x86: ptrace fs/gs_base
      x86: desc_empty
      x86: tls32 moved
      x86: TLS cleanup
      ptrace: arch_has_single_step
      x86: segment selector macros
      x86: remove TRAP_FLAG
      x86: arch_has_single_step
      x86: single_step moved
      x86: single_step segment macros
      x86: single_step 0xf0
      x86: single_step: share code
      x86 single_step: TIF_FORCED_TF
      ptrace: generic resume
      x86-64: ptrace generic resume
      x86-32: ptrace generic resume
      powerpc: arch_has_single_step
      powerpc: ptrace generic resume
      x86-32 ptrace: use task_pt_regs
      x86-64 ptrace: use task_pt_regs
      x86: x86-64 ptrace debugreg cleanup
      x86: x86-64 ia32 ptrace debugreg cleanup
      x86: x86-32 ptrace debugreg cleanup
      ptrace: arch_has_block_step
      ptrace: generic PTRACE_SINGLEBLOCK
      x86: debugctlmsr constants
      x86: debugctlmsr kconfig
      x86: debugctlmsr context switch
      x86: debugctlmsr arch_has_block_step
      x86: debugctlmsr kprobes
      x86: PTRACE_SINGLEBLOCK
      x86: setup64 eflags constants
      x86: eflags enum
      x86: x86-64 ia32 ptrace pt_regs cleanup
      x86: x86-64 ptrace whitespace
      x86: x86-32 ptrace whitespace
      x86: x86-64 ptrace get/putreg current task
      x86: x86-32 ptrace get/putreg current task
      x86: x86-64 ia32 ptrace get/putreg32 current task
      x86: x86-32 thread_struct.debugreg
      x86: ptrace_32 renamed
      x86: ptrace FLAG_MASK cleanup
      x86: x86 ptrace getreg/putreg cleanup
      x86: x86 ptrace getreg/putreg merge
      x86: x86 ptrace arch merge
      x86: x86 ptrace merge syscall trace
      x86: x86 ia32 ptrace getreg/putreg merge
      x86: x86 ia32 ptrace arch merge
      x86: x86 ptrace merge complete
      x86: x86 ptrace merge removals
      x86: user_regset header
      elf core dump: notes reorg
      elf core dump: notes user_regset
      x86: user_regset helpers
      x86: compat_binfmt_elf
      x86: compat_binfmt_elf Kconfig
      x86: user_regset user-copy helpers
      x86: ptrace_request peekdata/pokedata
      x86: compat_ptrace_request
      x86: compat_sys_ptrace
      x86: x86-64 wired cpu_has macros
      x86: x86 i387 unify structs
      x86: x86 i387 header cleanup
      x86: x86 user_regset math_emu
      x86: i387 renaming
      x86: x86 i387 user_regset
      x86: x86 i387 cleanup
      x86: x86 TLS desc_struct cleanup
      x86: x86 user_regset TLS
      x86: x86 user_regset general regs
      x86: x86 user_regset_view
      x86: x86 CORE_DUMP_USE_REGSET
      x86: x86 ptrace user_regset
      x86: x86 user_regset cleanup
      x86: compat_binfmt_elf
      x86: x86 ia32_binfmt removal
      x86: x86 core dump TLS
      x86: x86 ptrace generic requests
      x86: early_idt_handler improvements, 64-bit

Sam Ravnborg (20):
      x86: fix make mrproper
      x86: unification of arch/x86/Makefiles
      x86: share more options between 32 and 64 bit build
      x86: biarch support for 32 bit builds beautified
      x86: teach vdso to clean
      x86: unify arch/x86/kernel/Makefile(s)
      x86: unify arch/x86/boot/compressed/Makefile(s)
      x86: unify arch/x86/lib/Makefile(s)
      x86: gitignore arch/x86/vdso files
      xen: fix section usage in xen-head.S and setup.c
      x86: fix Section mismatch: reference to .init.text:lguest_entry
      x86: fix section mismatch warning in mcheck/mce_64.c
      x86: fix section mismatch warning in mcheck/mce_amd_64.c
      x86: fix section mismatch warning in process_*.c
      x86: fix section mismatch warning in acpi/boot.c
      x86: fix section mismatch warning in early-quirks.c
      x86: fix section mismatch warning in srat_64.c
      x86: fix section mismatch warning in topology.c
      x86: fix section mismatch warning in setup_64.c
      x86: fix usage of .section .sched.text in assembler code

Siddha, Suresh B (1):
      x86: set strong uncacheable where UC is really desired

Steven Rostedt (1):
      x86: remove unused tsk_thread from asm-offsets_64.c

Thomas Gleixner (116):
      timer: clean up tick-broadcast.c
      x86: restrict PIT clocksource usage
      clocksource: add unregister function to disable unusable clocksources
      x86: unregister PIT clocksource when PIT is disabled
      x86: clean up arch/x86/ia32/fpu32.c
      x86: clean up arch/x86/ia32/aout32.c
      x86: clean up arch/x86/ia32/ia32_signal.c
      x86: clean up arch/x86/ia32/ipc32.c
      x86: clean up arch/x86/ia32/ptrace32.c
      x86: clean up arch/x86/ia32/sys_ia32.c
      x86: clean up arch/x86/ia32/syscall32.c
      x86: clean up arch/x86/ia32/mmap32.c
      x86: clean up arch/x86/kernel/e820_64.c
      x86: clean up arch/x86/kernel/ldt_32/64.c
      x86: clean up include/asm-x86/desc_64.h
      x86: introduce ldt_write accessor
      x86: prepare arch/x86/kernel/ldt_32/64.c for merging
      x86: merge arch/x86/kernel/ldt_32/64.c
      x86: unify include/asm-x86/apicdef_32/64.h
      x86: prepare unification of include/asm-x86/apic_32/64.h
      x86: rename get_maxlvt to lapic_get_maxlvt
      x86: use u32 for safe_apic_wait_icr_idle()
      x86: use u32 for some lapic functions
      x86: merge apic_32/64.h
      x86: remove duplicated declarations
      x86: move acpi and pci declarations
      x86: make early_indentify_cpu static
      x86: move idle related declarations
      x86: move k8 related declarations
      x86: move debug related declarations to kdebug.h
      x86: move mce related declarations
      x86: move numa related declarations
      x86: move page related declaration
      x86: move pda related declaration
      x86: move tsc related declarations
      x86: move pmtmr related declarations
      x86: remove obsolete nohpet declaration
      x86: remove duplicate start_kernel declaration
      x86: remove obsolte declarations from proto.h
      x86: move ioapic code where it belongs
      x86: move ack_bad_irq into irq code
      x86: make smp_local_timer_interrupt() static
      x86: prepare merging arch/x86/kernel/apic_32/64.c
      x86: prepare merging futex_32/64.h
      x86: merge futex_32/64.h
      x86: merge include/asm-x86/dma.h
      x86: merge include/asm-x86/scatterlist.h
      x86: simplify set_bitmap in ioport_32.c
      x86: clean up ioport_32.c
      x86: clean up arch/x86/kernel/vsmp_64.c
      x86: clean up arch/x86/mm/mmap_32/64.c
      x86: remove the duplicated arch/x86/ia32/mmap32.c
      x86: unify mc146818rtc.h - prepare for sharing rtc code
      x86: isolate the rtc code for sharing
      x86: share rtc code
      x86: clean up arch/x86/kernel/time_64.c includes
      x86: smp_64.c: remove unused exports and cleanup while at it
      x86: nuke a ton of dead hpet code
      x86: remove dead code and exports
      x86: nuke a ton of unused exports
      x86: move 8259 defines to i8259.h
      x86: fix asm constraints in spinlock_32/64.h
      x86: use immediates instead of RW_LOCK_BIAS_STR
      x86: spinlock_32/64 match the jump labels and symbols
      x86: spinlock_32/64 substitute types and instructions
      x86: merge spinlock.h variants
      x86: cleanup tlbflush.h variants
      x86: merge tlbflush.h variants
      x86: cleanup mpspec variants
      x86: merge mpspec variants
      x86: cleanup smp.h variants
      x86: cleanup acpi_32/64.h
      x86: merge acpi_32/64.h
      x86: put all kern_addr_valid() incarnations to pgtable.h
      x86: merge include/asm-x86/sparsemem.h
      x86: merge include/asm-x86/sparsemem.h
      x86: cleanup numa_64.c
      x86: fixup numa 64 namespace
      x86: adjust numa 32 namespace
      x86: consolidate toloplogy_32/64.h
      x86: merge topology.h variants
      x86: merge resume-trace.h variants
      x86: cleanup kernel/setup_64.c
      x86: sanity check APIC timer frequency
      x86: preset apic clockevents multiplicator
      x86: cleanup boot_ioremap_32.c
      x86: clean up lookup_address() declarations
      x86: add PG_LEVEL enum
      x86: fix ioremap pgprot inconsistency
      x86: fix ioremap pgprot inconsistency
      x86: style cleanup of ioremap code
      x86: cleanup ioremap includes
      x86: introduce max_pfn_mapped
      x86: make c_p_a unconditional in ioremap
      x86: switch to change_page_attr_addr in ioremap_32.c
      x86: __iomem annotations
      x86: use remove_vm_are in ioremap_32 error path
      x86: unify ioremap
      x86: unify ioremap_32 and _64
      x86: move page_is_ram() function
      x86: fix the missing BIOS area check in page_is_ram
      x86: fix ioremap RAM check
      x86: fix ioremap API
      x86: cpa: convert ioremap to new API
      x86: cpa: move flush to cpa
      x86: cpa: fix split thinko
      x86: cpa: clean up change_page_attr_set/clear()
      x86: cpa move the flush into set and clear functions
      x86: cpa create set_and_clr function
      x86: cpa use the new set_clr function
      x86: cpa: implement clflush optimization
      x86: cpa: rename global_flush_tlb() to cpa_flush_all()
      x86: clflush_page_range needs mfence
      x86: optimize clflush
      x86: cpa cleanup the 64-bit alias math
      x86: unify ioremap

Venki Pallipadi (2):
      time: track accurate idle time with tick_sched.idle_sleeptime
      x86: voluntary leave_mm before entering ACPI C3

Vladimir Berezniker (1):
      x86: sanitize user specified e820 memmap values

WANG Cong (1):
      git-x86: unbreak UML

Willy Tarreau (1):
      x86: GEODE add the "mfgptfix" boot time option to fix MFGPT timers

Yi Yang (1):
      cpufreq: fix obvious condition statement error

Yinghai Lu (22):
      x86: clear IO_APIC before enabing apic error vector.
      x86: store core id bits in cpuinfo_x8
      x86: use core id bits for apicid_to_node initialization
      x86: set cpu_index to nr_cpus instead of 0
      x86: do not set boot cpu in cpu_online_map at x86_64_start_kernel()
      x86: not clear empty_zero_page again
      x86: cleanup setup_node_zones called by paging_init()
      x86: disable the GART early, 64-bit
      x86: only call early_init_amd one time
      x86: msr for AMD Fam 10h mmio
      x86: checking aperture report for node instead
      x86: only support sparsemem
      x86_32: trim memory by updating e820
      x86: left over fix for leak of early_ioremp in dmi_scan
      x86: remove duplicated line about
      x86: should use array directly for early_ptr
      x86: not set boot cpu in cpu_present_map again
      x86: not set boot cpu in cpu_online_map in smp_prepare_boot_cpu()
      x86: change aper valid checking sequence
      x86: fix recursion in arch/x86/kernel/cpu/mcheck/mce_amd_64.c
      x86: fix overlap between pagetable with bss section
      x86: fix nodemap_size according to nodeid bits

clameter@sgi.com (1):
      x86: clean up stack allocation and free

devzero@web.de (2):
      x86 setup: early cmdline parser handle boolean options
      x86 setup: be more verbose when probing EDD

john stultz (1):
      NTP: correct inconsistent ntp interval/tick_length usage

mboton@gmail.com (1):
      x86: ioport_{32|64}.c unification

travis@sgi.com (21):
      percpu: use a kconfig variable to signal arch specific percpu setup
      percpu: move arch XX_PER_CPU_XX definitions into linux/percpu.h
      percpu: make the asm-generic/percpu.h more "generic"
      x86_32: use generic percpu.h
      x86: use generic percpu on 64-bit
      x86: unify percpu.h
      x86: change size of APICIDs from u8 to u16
      x86: change size of node ids from u8 to u16
      x86: change NR_CPUS arrays in powernow-k8
      x86: change NR_CPUS arrays in smpboot_64
      x86: change NR_CPUS arrays in topology
      x86: cleanup x86_cpu_to_apicid references
      x86: change NR_CPUS arrays in numa_64
      x86: change NR_CPUS arrays in acpi-cpufreq
      x86: change bios_cpu_apicid to percpu data variable
      x86: fixup NR-CPUS patch for numa
      x86: change NR_CPUS arrays in numa_64 fixup
      x86: change bios_cpu_apicid to percpu data variable fixup
      x86: add debug of invalid per_cpu map accesses
      x86: change size of node ids from u8 to s16
      x86: early cpu_to_node fix in numa_64.c

 arch/x86/Makefile_32                          |  175 -
 arch/x86/Makefile_64                          |  144 -
 arch/x86/boot/compressed/Makefile_32          |   50 
 arch/x86/boot/compressed/Makefile_64          |   30 
 arch/x86/boot/compressed/misc_32.c            |  382 ---
 arch/x86/boot/compressed/misc_64.c            |  371 ---
 arch/x86/boot/compressed/vmlinux_32.scr       |   10 
 arch/x86/boot/compressed/vmlinux_64.scr       |   10 
 arch/x86/ia32/fpu32.c                         |  183 -
 arch/x86/ia32/ia32_binfmt.c                   |  285 --
 arch/x86/ia32/mmap32.c                        |   79 
 arch/x86/ia32/ptrace32.c                      |  404 ---
 arch/x86/ia32/syscall32.c                     |   83 
 arch/x86/ia32/syscall32_syscall.S             |   17 
 arch/x86/ia32/tls32.c                         |  163 -
 arch/x86/ia32/vsyscall-sigreturn.S            |  143 -
 arch/x86/ia32/vsyscall-syscall.S              |   69 
 arch/x86/ia32/vsyscall-sysenter.S             |   95 
 arch/x86/ia32/vsyscall.lds                    |   80 
 arch/x86/kernel/Makefile_32                   |   88 
 arch/x86/kernel/Makefile_64                   |   45 
 arch/x86/kernel/acpi/sleep_64.c               |  117 -
 arch/x86/kernel/i387_32.c                     |  544 ----
 arch/x86/kernel/i387_64.c                     |  150 -
 arch/x86/kernel/ioport_32.c                   |  151 -
 arch/x86/kernel/ioport_64.c                   |  117 -
 arch/x86/kernel/kprobes_32.c                  |  756 ------
 arch/x86/kernel/kprobes_64.c                  |  749 ------
 arch/x86/kernel/ldt_32.c                      |  248 --
 arch/x86/kernel/ldt_64.c                      |  250 --
 arch/x86/kernel/paravirt_32.c                 |  472 ----
 arch/x86/kernel/ptrace_32.c                   |  717 ------
 arch/x86/kernel/ptrace_64.c                   |  621 -----
 arch/x86/kernel/reboot_32.c                   |  413 ---
 arch/x86/kernel/reboot_64.c                   |  176 -
 arch/x86/kernel/sysenter_32.c                 |  346 ---
 arch/x86/kernel/vsyscall-int80_32.S           |   53 
 arch/x86/kernel/vsyscall-note_32.S            |   45 
 arch/x86/kernel/vsyscall-sigreturn_32.S       |  143 -
 arch/x86/kernel/vsyscall-sysenter_32.S        |  122 -
 arch/x86/kernel/vsyscall_32.S                 |   15 
 arch/x86/kernel/vsyscall_32.lds.S             |   67 
 arch/x86/lib/Makefile_32                      |   11 
 arch/x86/lib/Makefile_64                      |   13 
 arch/x86/mm/boot_ioremap_32.c                 |  100 
 arch/x86/mm/extable_32.c                      |   35 
 arch/x86/mm/extable_64.c                      |   34 
 arch/x86/mm/fault_32.c                        |  659 -----
 arch/x86/mm/fault_64.c                        |  623 -----
 arch/x86/mm/ioremap_32.c                      |  274 --
 arch/x86/mm/ioremap_64.c                      |  210 -
 arch/x86/mm/mmap_32.c                         |   77 
 arch/x86/mm/mmap_64.c                         |   29 
 arch/x86/mm/pageattr_32.c                     |  278 --
 arch/x86/mm/pageattr_64.c                     |  255 --
 arch/x86/vdso/vdso-start.S                    |    2 
 arch/x86/vdso/voffset.h                       |    1 
 b/Documentation/DocBook/Makefile              |    2 
 b/Documentation/DocBook/kgdb.tmpl             |  236 ++
 b/Documentation/debugging-via-ohci1394.txt    |  179 +
 b/Documentation/kernel-parameters.txt         |   51 
 b/Documentation/x86_64/boot-options.txt       |    8 
 b/Documentation/x86_64/uefi.txt               |    9 
 b/MAINTAINERS                                 |    9 
 b/Makefile                                    |    8 
 b/arch/arm/Kconfig                            |    5 
 b/arch/ia64/Kconfig                           |    8 
 b/arch/ia64/ia32/binfmt_elf32.c               |    3 
 b/arch/ia64/kernel/module.c                   |    2 
 b/arch/m32r/Kconfig                           |    5 
 b/arch/mips/Kconfig                           |    5 
 b/arch/mips/kernel/i8253.c                    |   12 
 b/arch/parisc/Kconfig                         |    5 
 b/arch/powerpc/Kconfig                        |    8 
 b/arch/powerpc/kernel/ptrace.c                |   52 
 b/arch/sparc64/Kconfig                        |    8 
 b/arch/um/kernel/ksyms.c                      |    4 
 b/arch/um/sys-i386/signal.c                   |   50 
 b/arch/um/sys-x86_64/signal.c                 |   70 
 b/arch/x86/Kconfig                            |  311 +-
 b/arch/x86/Kconfig.cpu                        |   65 
 b/arch/x86/Kconfig.debug                      |  129 +
 b/arch/x86/Makefile                           |  247 ++
 b/arch/x86/boot/Makefile                      |   10 
 b/arch/x86/boot/apm.c                         |    3 
 b/arch/x86/boot/boot.h                        |   17 
 b/arch/x86/boot/cmdline.c                     |   65 
 b/arch/x86/boot/compressed/Makefile           |   62 
 b/arch/x86/boot/compressed/misc.c             |  413 +++
 b/arch/x86/boot/compressed/relocs.c           |    7 
 b/arch/x86/boot/compressed/vmlinux.scr        |   10 
 b/arch/x86/boot/compressed/vmlinux_32.lds     |   10 
 b/arch/x86/boot/compressed/vmlinux_64.lds     |   12 
 b/arch/x86/boot/edd.c                         |   13 
 b/arch/x86/boot/header.S                      |    5 
 b/arch/x86/boot/main.c                        |   31 
 b/arch/x86/boot/pm.c                          |    6 
 b/arch/x86/boot/pmjump.S                      |   54 
 b/arch/x86/boot/video-bios.c                  |    3 
 b/arch/x86/boot/video-vesa.c                  |   26 
 b/arch/x86/boot/video-vga.c                   |   20 
 b/arch/x86/boot/video.c                       |   33 
 b/arch/x86/boot/video.h                       |    3 
 b/arch/x86/boot/voyager.c                     |    4 
 b/arch/x86/configs/i386_defconfig             |    4 
 b/arch/x86/configs/x86_64_defconfig           |    9 
 b/arch/x86/ia32/Makefile                      |   41 
 b/arch/x86/ia32/audit.c                       |    2 
 b/arch/x86/ia32/ia32_aout.c                   |  246 +-
 b/arch/x86/ia32/ia32_signal.c                 |  472 ++--
 b/arch/x86/ia32/ia32entry.S                   |   11 
 b/arch/x86/ia32/ipc32.c                       |   30 
 b/arch/x86/ia32/sys_ia32.c                    |  504 ++--
 b/arch/x86/kernel/Makefile                    |   97 
 b/arch/x86/kernel/acpi/Makefile               |    2 
 b/arch/x86/kernel/acpi/sleep.c                |   87 
 b/arch/x86/kernel/acpi/sleep_32.c             |   70 
 b/arch/x86/kernel/acpi/wakeup_32.S            |    2 
 b/arch/x86/kernel/acpi/wakeup_64.S            |   32 
 b/arch/x86/kernel/alternative.c               |   40 
 b/arch/x86/kernel/aperture_64.c               |  374 ++-
 b/arch/x86/kernel/apic_32.c                   |  156 -
 b/arch/x86/kernel/apic_64.c                   | 1257 +++++------
 b/arch/x86/kernel/apm_32.c                    |  379 +--
 b/arch/x86/kernel/asm-offsets_32.c            |   65 
 b/arch/x86/kernel/asm-offsets_64.c            |   56 
 b/arch/x86/kernel/bootflag.c                  |   50 
 b/arch/x86/kernel/bugs_64.c                   |    1 
 b/arch/x86/kernel/cpu/addon_cpuid_features.c  |    2 
 b/arch/x86/kernel/cpu/amd.c                   |   23 
 b/arch/x86/kernel/cpu/bugs.c                  |    5 
 b/arch/x86/kernel/cpu/common.c                |  179 -
 b/arch/x86/kernel/cpu/cpu.h                   |    3 
 b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c  |   25 
 b/arch/x86/kernel/cpu/cpufreq/longhaul.c      |    2 
 b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c   |   12 
 b/arch/x86/kernel/cpu/cyrix.c                 |    6 
 b/arch/x86/kernel/cpu/intel.c                 |   39 
 b/arch/x86/kernel/cpu/mcheck/k7.c             |   25 
 b/arch/x86/kernel/cpu/mcheck/mce.h            |    2 
 b/arch/x86/kernel/cpu/mcheck/mce_32.c         |    4 
 b/arch/x86/kernel/cpu/mcheck/mce_64.c         |   45 
 b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c     |   21 
 b/arch/x86/kernel/cpu/mcheck/p4.c             |   35 
 b/arch/x86/kernel/cpu/mcheck/p5.c             |    2 
 b/arch/x86/kernel/cpu/mcheck/p6.c             |   23 
 b/arch/x86/kernel/cpu/mcheck/winchip.c        |    2 
 b/arch/x86/kernel/cpu/mtrr/amd.c              |    2 
 b/arch/x86/kernel/cpu/mtrr/cyrix.c            |    3 
 b/arch/x86/kernel/cpu/mtrr/generic.c          |   27 
 b/arch/x86/kernel/cpu/mtrr/if.c               |   23 
 b/arch/x86/kernel/cpu/mtrr/main.c             |  147 +
 b/arch/x86/kernel/cpu/mtrr/mtrr.h             |    9 
 b/arch/x86/kernel/cpu/mtrr/state.c            |    3 
 b/arch/x86/kernel/cpu/perfctr-watchdog.c      |    1 
 b/arch/x86/kernel/cpu/proc.c                  |    2 
 b/arch/x86/kernel/cpuid.c                     |    2 
 b/arch/x86/kernel/doublefault_32.c            |   19 
 b/arch/x86/kernel/ds.c                        |  464 ++++
 b/arch/x86/kernel/e820_32.c                   |  241 --
 b/arch/x86/kernel/e820_64.c                   |  428 ++-
 b/arch/x86/kernel/early-quirks.c              |  127 -
 b/arch/x86/kernel/efi.c                       |  512 ++++
 b/arch/x86/kernel/efi_32.c                    |  618 -----
 b/arch/x86/kernel/efi_64.c                    |  134 +
 b/arch/x86/kernel/efi_stub_64.S               |  109 
 b/arch/x86/kernel/entry_32.S                  |   26 
 b/arch/x86/kernel/entry_64.S                  |  101 
 b/arch/x86/kernel/genapic_64.c                |   15 
 b/arch/x86/kernel/geode_32.c                  |   48 
 b/arch/x86/kernel/head64.c                    |   63 
 b/arch/x86/kernel/head_32.S                   |   17 
 b/arch/x86/kernel/head_64.S                   |   48 
 b/arch/x86/kernel/hpet.c                      |   60 
 b/arch/x86/kernel/i386_ksyms_32.c             |    7 
 b/arch/x86/kernel/i387.c                      |  479 ++++
 b/arch/x86/kernel/i8253.c                     |   72 
 b/arch/x86/kernel/i8259_32.c                  |   24 
 b/arch/x86/kernel/i8259_64.c                  |  160 -
 b/arch/x86/kernel/init_task.c                 |    1 
 b/arch/x86/kernel/io_apic_32.c                |   13 
 b/arch/x86/kernel/io_apic_64.c                |  112 -
 b/arch/x86/kernel/io_delay.c                  |  114 +
 b/arch/x86/kernel/ioport.c                    |  154 +
 b/arch/x86/kernel/irq_32.c                    |   22 
 b/arch/x86/kernel/irq_64.c                    |   30 
 b/arch/x86/kernel/kdebugfs.c                  |   65 
 b/arch/x86/kernel/kgdb-jmp_32.S               |   74 
 b/arch/x86/kernel/kgdb-jmp_64.S               |   65 
 b/arch/x86/kernel/kgdb.c                      |  533 ++++
 b/arch/x86/kernel/kprobes.c                   | 1066 +++++++++
 b/arch/x86/kernel/ldt.c                       |  260 ++
 b/arch/x86/kernel/machine_kexec_32.c          |    4 
 b/arch/x86/kernel/machine_kexec_64.c          |    5 
 b/arch/x86/kernel/mfgpt_32.c                  |   15 
 b/arch/x86/kernel/microcode.c                 |   12 
 b/arch/x86/kernel/mpparse_32.c                |   39 
 b/arch/x86/kernel/mpparse_64.c                |   28 
 b/arch/x86/kernel/nmi_32.c                    |   14 
 b/arch/x86/kernel/nmi_64.c                    |   99 
 b/arch/x86/kernel/numaq_32.c                  |    2 
 b/arch/x86/kernel/paravirt.c                  |  440 +++
 b/arch/x86/kernel/paravirt_patch_32.c         |   49 
 b/arch/x86/kernel/paravirt_patch_64.c         |   57 
 b/arch/x86/kernel/pci-calgary_64.c            |    5 
 b/arch/x86/kernel/pci-dma_64.c                |    3 
 b/arch/x86/kernel/pci-gart_64.c               |  510 ++--
 b/arch/x86/kernel/pci-swiotlb_64.c            |    1 
 b/arch/x86/kernel/pmtimer_64.c                |    4 
 b/arch/x86/kernel/process_32.c                |  419 +--
 b/arch/x86/kernel/process_64.c                |  342 +--
 b/arch/x86/kernel/ptrace.c                    | 1545 +++++++++++++
 b/arch/x86/kernel/quirks.c                    |    2 
 b/arch/x86/kernel/reboot.c                    |  451 ++++
 b/arch/x86/kernel/reboot_fixups_32.c          |   14 
 b/arch/x86/kernel/rtc.c                       |  204 +
 b/arch/x86/kernel/setup64.c                   |   59 
 b/arch/x86/kernel/setup_32.c                  |  287 ++
 b/arch/x86/kernel/setup_64.c                  |  555 ++---
 b/arch/x86/kernel/signal_32.c                 |  225 +-
 b/arch/x86/kernel/signal_64.c                 |  133 -
 b/arch/x86/kernel/smp_32.c                    |   15 
 b/arch/x86/kernel/smp_64.c                    |   91 
 b/arch/x86/kernel/smpboot_32.c                |   61 
 b/arch/x86/kernel/smpboot_64.c                |   79 
 b/arch/x86/kernel/smpcommon_32.c              |    7 
 b/arch/x86/kernel/srat_32.c                   |    8 
 b/arch/x86/kernel/stacktrace.c                |   12 
 b/arch/x86/kernel/step.c                      |  203 +
 b/arch/x86/kernel/suspend_64.c                |   30 
 b/arch/x86/kernel/suspend_asm_64.S            |   32 
 b/arch/x86/kernel/sys_x86_64.c                |   98 
 b/arch/x86/kernel/test_nx.c                   |  176 +
 b/arch/x86/kernel/test_rodata.c               |   86 
 b/arch/x86/kernel/time_32.c                   |  114 -
 b/arch/x86/kernel/time_64.c                   |  187 -
 b/arch/x86/kernel/tls.c                       |  213 +
 b/arch/x86/kernel/tls.h                       |   21 
 b/arch/x86/kernel/topology.c                  |   23 
 b/arch/x86/kernel/traps_32.c                  |  350 +--
 b/arch/x86/kernel/traps_64.c                  |  374 +--
 b/arch/x86/kernel/tsc_32.c                    |   62 
 b/arch/x86/kernel/tsc_64.c                    |  100 
 b/arch/x86/kernel/tsc_sync.c                  |   30 
 b/arch/x86/kernel/vm86_32.c                   |  115 -
 b/arch/x86/kernel/vmi_32.c                    |  126 -
 b/arch/x86/kernel/vmiclock_32.c               |    3 
 b/arch/x86/kernel/vmlinux_32.lds.S            |    8 
 b/arch/x86/kernel/vmlinux_64.lds.S            |   23 
 b/arch/x86/kernel/vsmp_64.c                   |   11 
 b/arch/x86/kernel/vsyscall_64.c               |   11 
 b/arch/x86/kernel/x8664_ksyms_64.c            |   13 
 b/arch/x86/lguest/Kconfig                     |    1 
 b/arch/x86/lguest/boot.c                      |   51 
 b/arch/x86/lib/Makefile                       |   26 
 b/arch/x86/lib/memcpy_32.c                    |    4 
 b/arch/x86/lib/memmove_64.c                   |    4 
 b/arch/x86/lib/semaphore_32.S                 |   22 
 b/arch/x86/lib/thunk_64.S                     |    2 
 b/arch/x86/mach-rdc321x/Makefile              |    5 
 b/arch/x86/mach-rdc321x/gpio.c                |   91 
 b/arch/x86/mach-rdc321x/platform.c            |   68 
 b/arch/x86/mach-rdc321x/wdt.c                 |  275 ++
 b/arch/x86/mach-visws/mpparse.c               |   16 
 b/arch/x86/mach-voyager/setup.c               |   34 
 b/arch/x86/mach-voyager/voyager_basic.c       |  132 -
 b/arch/x86/mach-voyager/voyager_cat.c         |  601 ++---
 b/arch/x86/mach-voyager/voyager_smp.c         |  690 ++----
 b/arch/x86/mach-voyager/voyager_thread.c      |   52 
 b/arch/x86/math-emu/errors.c                  |  882 +++----
 b/arch/x86/math-emu/exception.h               |    9 
 b/arch/x86/math-emu/fpu_arith.c               |  150 -
 b/arch/x86/math-emu/fpu_asm.h                 |    1 
 b/arch/x86/math-emu/fpu_aux.c                 |  211 -
 b/arch/x86/math-emu/fpu_emu.h                 |   67 
 b/arch/x86/math-emu/fpu_entry.c               | 1230 +++++------
 b/arch/x86/math-emu/fpu_etc.c                 |  185 -
 b/arch/x86/math-emu/fpu_proto.h               |   28 
 b/arch/x86/math-emu/fpu_tags.c                |   94 
 b/arch/x86/math-emu/fpu_trig.c                | 2884 ++++++++++++--------------
 b/arch/x86/math-emu/get_address.c             |  650 ++---
 b/arch/x86/math-emu/load_store.c              |  448 ++--
 b/arch/x86/math-emu/poly.h                    |   69 
 b/arch/x86/math-emu/poly_2xm1.c               |  199 -
 b/arch/x86/math-emu/poly_atan.c               |  353 +--
 b/arch/x86/math-emu/poly_l2.c                 |  376 +--
 b/arch/x86/math-emu/poly_sin.c                |  597 ++---
 b/arch/x86/math-emu/poly_tan.c                |  338 +--
 b/arch/x86/math-emu/reg_add_sub.c             |  563 ++---
 b/arch/x86/math-emu/reg_compare.c             |  567 ++---
 b/arch/x86/math-emu/reg_constant.c            |   73 
 b/arch/x86/math-emu/reg_convert.c             |   57 
 b/arch/x86/math-emu/reg_divide.c              |  301 +-
 b/arch/x86/math-emu/reg_ld_str.c              | 2147 ++++++++-----------
 b/arch/x86/math-emu/reg_mul.c                 |  163 -
 b/arch/x86/math-emu/status_w.h                |    8 
 b/arch/x86/mm/Makefile_32                     |    3 
 b/arch/x86/mm/Makefile_64                     |    3 
 b/arch/x86/mm/discontig_32.c                  |  110 
 b/arch/x86/mm/extable.c                       |   62 
 b/arch/x86/mm/fault.c                         |  986 ++++++++
 b/arch/x86/mm/highmem_32.c                    |   47 
 b/arch/x86/mm/hugetlbpage.c                   |    3 
 b/arch/x86/mm/init_32.c                       |  425 +--
 b/arch/x86/mm/init_64.c                       |  418 ++-
 b/arch/x86/mm/ioremap.c                       |  501 ++++
 b/arch/x86/mm/k8topology_64.c                 |  173 -
 b/arch/x86/mm/mmap.c                          |  123 +
 b/arch/x86/mm/numa_64.c                       |  274 +-
 b/arch/x86/mm/pageattr-test.c                 |  224 ++
 b/arch/x86/mm/pageattr.c                      |  564 +++++
 b/arch/x86/mm/pgtable_32.c                    |  145 -
 b/arch/x86/mm/srat_64.c                       |   95 
 b/arch/x86/oprofile/backtrace.c               |   12 
 b/arch/x86/oprofile/nmi_int.c                 |  212 -
 b/arch/x86/pci/common.c                       |   17 
 b/arch/x86/pci/fixup.c                        |   30 
 b/arch/x86/pci/irq.c                          |   20 
 b/arch/x86/power/cpu.c                        |   18 
 b/arch/x86/vdso/.gitignore                    |    5 
 b/arch/x86/vdso/Makefile                      |  132 -
 b/arch/x86/vdso/vclock_gettime.c              |    1 
 b/arch/x86/vdso/vdso-layout.lds.S             |   64 
 b/arch/x86/vdso/vdso.lds.S                    |   94 
 b/arch/x86/vdso/vdso32-setup.c                |  444 ++++
 b/arch/x86/vdso/vdso32.S                      |   19 
 b/arch/x86/vdso/vdso32/.gitignore             |    1 
 b/arch/x86/vdso/vdso32/int80.S                |   56 
 b/arch/x86/vdso/vdso32/note.S                 |   44 
 b/arch/x86/vdso/vdso32/sigreturn.S            |  144 +
 b/arch/x86/vdso/vdso32/syscall.S              |   77 
 b/arch/x86/vdso/vdso32/sysenter.S             |  116 +
 b/arch/x86/vdso/vdso32/vdso32.lds.S           |   37 
 b/arch/x86/vdso/vgetcpu.c                     |    4 
 b/arch/x86/vdso/vma.c                         |   18 
 b/arch/x86/xen/Kconfig                        |    1 
 b/arch/x86/xen/enlighten.c                    |  102 
 b/arch/x86/xen/events.c                       |    4 
 b/arch/x86/xen/mmu.c                          |   23 
 b/arch/x86/xen/setup.c                        |    9 
 b/arch/x86/xen/smp.c                          |    8 
 b/arch/x86/xen/time.c                         |    2 
 b/arch/x86/xen/xen-head.S                     |    6 
 b/drivers/Makefile                            |    2 
 b/drivers/acpi/processor_idle.c               |   34 
 b/drivers/char/agp/ali-agp.c                  |    2 
 b/drivers/char/agp/backend.c                  |    3 
 b/drivers/char/agp/generic.c                  |    3 
 b/drivers/char/agp/i460-agp.c                 |    2 
 b/drivers/char/agp/intel-agp.c                |   11 
 b/drivers/char/hpet.c                         |  126 -
 b/drivers/char/keyboard.c                     |    1 
 b/drivers/char/rtc.c                          |  253 +-
 b/drivers/cpufreq/cpufreq.c                   |    2 
 b/drivers/firmware/dmi_scan.c                 |   26 
 b/drivers/ieee1394/Makefile                   |    1 
 b/drivers/ieee1394/init_ohci1394_dma.c        |  285 ++
 b/drivers/input/mouse/pc110pad.c              |    7 
 b/drivers/kvm/svm.c                           |    2 
 b/drivers/kvm/vmx.c                           |    8 
 b/drivers/lguest/x86/core.c                   |    4 
 b/drivers/pnp/pnpbios/bioscalls.c             |    5 
 b/drivers/serial/8250.c                       |   52 
 b/drivers/serial/8250_kgdb.c                  |  558 +++++
 b/drivers/serial/Kconfig                      |    2 
 b/drivers/serial/Makefile                     |    1 
 b/drivers/serial/serial_core.c                |   24 
 b/drivers/video/vermilion/vermilion.c         |   15 
 b/fs/Kconfig.binfmt                           |    4 
 b/fs/Makefile                                 |    1 
 b/fs/aio.c                                    |    2 
 b/fs/binfmt_elf.c                             |  677 ++++--
 b/fs/compat_binfmt_elf.c                      |  131 +
 b/fs/jbd/checkpoint.c                         |    3 
 b/fs/jbd/commit.c                             |    2 
 b/fs/jbd2/checkpoint.c                        |    3 
 b/fs/jbd2/commit.c                            |    2 
 b/include/acpi/reboot.h                       |    9 
 b/include/asm-alpha/agp.h                     |    1 
 b/include/asm-generic/bug.h                   |   17 
 b/include/asm-generic/kgdb.h                  |  105 
 b/include/asm-generic/percpu.h                |   97 
 b/include/asm-generic/tlb.h                   |    1 
 b/include/asm-generic/vmlinux.lds.h           |    1 
 b/include/asm-ia64/acpi.h                     |    2 
 b/include/asm-ia64/agp.h                      |    1 
 b/include/asm-ia64/percpu.h                   |   24 
 b/include/asm-m32r/signal.h                   |    2 
 b/include/asm-parisc/agp.h                    |    1 
 b/include/asm-powerpc/agp.h                   |    1 
 b/include/asm-powerpc/percpu.h                |   17 
 b/include/asm-powerpc/ptrace.h                |    7 
 b/include/asm-s390/percpu.h                   |   20 
 b/include/asm-sparc64/agp.h                   |    1 
 b/include/asm-sparc64/percpu.h                |   16 
 b/include/asm-um/asm.h                        |    6 
 b/include/asm-um/linkage.h                    |    1 
 b/include/asm-um/nops.h                       |    6 
 b/include/asm-x86/Kbuild                      |    4 
 b/include/asm-x86/acpi.h                      |  151 +
 b/include/asm-x86/agp.h                       |    9 
 b/include/asm-x86/alternative.h               |  162 +
 b/include/asm-x86/apic.h                      |  141 +
 b/include/asm-x86/apicdef.h                   |  412 +++
 b/include/asm-x86/arch_hooks.h                |    5 
 b/include/asm-x86/asm.h                       |   32 
 b/include/asm-x86/bitops.h                    |  316 ++
 b/include/asm-x86/bitops_32.h                 |  324 --
 b/include/asm-x86/bitops_64.h                 |  297 --
 b/include/asm-x86/bootparam.h                 |    5 
 b/include/asm-x86/bug.h                       |    3 
 b/include/asm-x86/bugs.h                      |    3 
 b/include/asm-x86/cacheflush.h                |   35 
 b/include/asm-x86/calling.h                   |  194 -
 b/include/asm-x86/checksum_64.h               |    2 
 b/include/asm-x86/cmpxchg_32.h                |  122 -
 b/include/asm-x86/compat.h                    |    2 
 b/include/asm-x86/cpu.h                       |    2 
 b/include/asm-x86/cpufeature.h                |  208 +
 b/include/asm-x86/desc.h                      |  380 +++
 b/include/asm-x86/desc_64.h                   |  203 -
 b/include/asm-x86/desc_defs.h                 |   47 
 b/include/asm-x86/dma.h                       |  318 ++
 b/include/asm-x86/dmi.h                       |   10 
 b/include/asm-x86/ds.h                        |   72 
 b/include/asm-x86/e820.h                      |    6 
 b/include/asm-x86/e820_32.h                   |    9 
 b/include/asm-x86/e820_64.h                   |   16 
 b/include/asm-x86/efi.h                       |   97 
 b/include/asm-x86/elf.h                       |  212 +
 b/include/asm-x86/emergency-restart.h         |   12 
 b/include/asm-x86/fixmap_32.h                 |   24 
 b/include/asm-x86/fixmap_64.h                 |    6 
 b/include/asm-x86/futex.h                     |  138 +
 b/include/asm-x86/gart.h                      |    5 
 b/include/asm-x86/geode.h                     |   12 
 b/include/asm-x86/gpio.h                      |    6 
 b/include/asm-x86/hpet.h                      |    8 
 b/include/asm-x86/hw_irq_32.h                 |   16 
 b/include/asm-x86/hw_irq_64.h                 |    2 
 b/include/asm-x86/i387.h                      |  361 +++
 b/include/asm-x86/i8253.h                     |    3 
 b/include/asm-x86/i8259.h                     |   20 
 b/include/asm-x86/ia32.h                      |    6 
 b/include/asm-x86/ia32_unistd.h               |    2 
 b/include/asm-x86/ide.h                       |    2 
 b/include/asm-x86/idle.h                      |    1 
 b/include/asm-x86/io_32.h                     |   35 
 b/include/asm-x86/io_64.h                     |   57 
 b/include/asm-x86/io_apic.h                   |  158 +
 b/include/asm-x86/irqflags.h                  |  246 ++
 b/include/asm-x86/k8.h                        |    1 
 b/include/asm-x86/kdebug.h                    |   11 
 b/include/asm-x86/kexec.h                     |  169 +
 b/include/asm-x86/kgdb.h                      |   86 
 b/include/asm-x86/kprobes.h                   |  103 
 b/include/asm-x86/lguest.h                    |   14 
 b/include/asm-x86/linkage.h                   |   26 
 b/include/asm-x86/local.h                     |  243 ++
 b/include/asm-x86/mach-bigsmp/mach_apic.h     |   12 
 b/include/asm-x86/mach-default/apm.h          |    2 
 b/include/asm-x86/mach-default/mach_apic.h    |   18 
 b/include/asm-x86/mach-default/mach_timer.h   |    2 
 b/include/asm-x86/mach-default/mach_traps.h   |    2 
 b/include/asm-x86/mach-es7000/mach_apic.h     |   10 
 b/include/asm-x86/mach-generic/gpio.h         |   15 
 b/include/asm-x86/mach-numaq/mach_apic.h      |   10 
 b/include/asm-x86/mach-rdc321x/gpio.h         |   56 
 b/include/asm-x86/mach-rdc321x/rdc321x_defs.h |    6 
 b/include/asm-x86/mach-summit/mach_apic.h     |   18 
 b/include/asm-x86/math_emu.h                  |    5 
 b/include/asm-x86/mc146818rtc.h               |  101 
 b/include/asm-x86/mce.h                       |   18 
 b/include/asm-x86/mmu.h                       |    8 
 b/include/asm-x86/mmu_context_32.h            |    2 
 b/include/asm-x86/mmu_context_64.h            |   13 
 b/include/asm-x86/mmzone_32.h                 |    3 
 b/include/asm-x86/mmzone_64.h                 |   12 
 b/include/asm-x86/module.h                    |   81 
 b/include/asm-x86/mpspec.h                    |  116 +
 b/include/asm-x86/mpspec_def.h                |   87 
 b/include/asm-x86/msr-index.h                 |   15 
 b/include/asm-x86/msr.h                       |  299 --
 b/include/asm-x86/mtrr.h                      |   14 
 b/include/asm-x86/mutex_32.h                  |    7 
 b/include/asm-x86/nmi_32.h                    |    3 
 b/include/asm-x86/nmi_64.h                    |    5 
 b/include/asm-x86/nops.h                      |   90 
 b/include/asm-x86/numa_32.h                   |   14 
 b/include/asm-x86/numa_64.h                   |   12 
 b/include/asm-x86/page.h                      |  190 +
 b/include/asm-x86/page_32.h                   |  247 --
 b/include/asm-x86/page_64.h                   |  110 
 b/include/asm-x86/paravirt.h                  |  615 +++--
 b/include/asm-x86/pci.h                       |   17 
 b/include/asm-x86/pci_64.h                    |    1 
 b/include/asm-x86/pda.h                       |   73 
 b/include/asm-x86/percpu.h                    |  145 +
 b/include/asm-x86/pgalloc_32.h                |   85 
 b/include/asm-x86/pgtable-2level.h            |   45 
 b/include/asm-x86/pgtable-3level.h            |   88 
 b/include/asm-x86/pgtable.h                   |  359 +++
 b/include/asm-x86/pgtable_32.h                |  291 --
 b/include/asm-x86/pgtable_64.h                |  260 --
 b/include/asm-x86/processor.h                 |  841 +++++++
 b/include/asm-x86/proto.h                     |   69 
 b/include/asm-x86/ptrace-abi.h                |   62 
 b/include/asm-x86/ptrace.h                    |  220 +
 b/include/asm-x86/resume-trace.h              |   23 
 b/include/asm-x86/rio.h                       |    4 
 b/include/asm-x86/rwlock.h                    |    1 
 b/include/asm-x86/rwsem.h                     |   14 
 b/include/asm-x86/scatterlist.h               |   34 
 b/include/asm-x86/segment.h                   |  203 +
 b/include/asm-x86/semaphore_32.h              |    8 
 b/include/asm-x86/setup.h                     |   11 
 b/include/asm-x86/sigcontext.h                |   42 
 b/include/asm-x86/sigcontext32.h              |   22 
 b/include/asm-x86/signal.h                    |   11 
 b/include/asm-x86/smp_32.h                    |  119 -
 b/include/asm-x86/smp_64.h                    |  137 -
 b/include/asm-x86/sparsemem.h                 |   35 
 b/include/asm-x86/spinlock.h                  |  295 ++
 b/include/asm-x86/spinlock_types.h            |    2 
 b/include/asm-x86/stacktrace.h                |    5 
 b/include/asm-x86/suspend_32.h                |    4 
 b/include/asm-x86/suspend_64.h                |   11 
 b/include/asm-x86/system.h                    |  418 +++
 b/include/asm-x86/system_64.h                 |  163 -
 b/include/asm-x86/thread_info_32.h            |   16 
 b/include/asm-x86/thread_info_64.h            |   34 
 b/include/asm-x86/time.h                      |   26 
 b/include/asm-x86/timer.h                     |   23 
 b/include/asm-x86/timex.h                     |    2 
 b/include/asm-x86/tlbflush.h                  |  157 +
 b/include/asm-x86/topology.h                  |  187 +
 b/include/asm-x86/tsc.h                       |   40 
 b/include/asm-x86/uaccess_64.h                |    2 
 b/include/asm-x86/unistd_32.h                 |    2 
 b/include/asm-x86/user_32.h                   |   24 
 b/include/asm-x86/user_64.h                   |   41 
 b/include/asm-x86/vdso.h                      |   28 
 b/include/asm-x86/vsyscall.h                  |    2 
 b/include/asm-x86/xor_32.h                    |    2 
 b/include/asm-x86/xor_64.h                    |    2 
 b/include/linux/acpi_pmtmr.h                  |    2 
 b/include/linux/clocksource.h                 |    4 
 b/include/linux/compat.h                      |   15 
 b/include/linux/const.h                       |    5 
 b/include/linux/cpumask.h                     |    4 
 b/include/linux/elf.h                         |    1 
 b/include/linux/hpet.h                        |    5 
 b/include/linux/init_ohci1394_dma.h           |    4 
 b/include/linux/ioport.h                      |    2 
 b/include/linux/kernel.h                      |    3 
 b/include/linux/kgdb.h                        |  301 ++
 b/include/linux/kprobes.h                     |   10 
 b/include/linux/linkage.h                     |    8 
 b/include/linux/mm.h                          |   15 
 b/include/linux/module.h                      |   16 
 b/include/linux/pci_ids.h                     |    7 
 b/include/linux/percpu.h                      |   24 
 b/include/linux/pid.h                         |    2 
 b/include/linux/ptrace.h                      |   75 
 b/include/linux/regset.h                      |  368 +++
 b/include/linux/sched.h                       |   21 
 b/include/linux/serial_8250.h                 |    2 
 b/include/linux/smp.h                         |    2 
 b/include/linux/spinlock.h                    |    6 
 b/include/linux/spinlock_types.h              |    4 
 b/include/linux/spinlock_up.h                 |    2 
 b/include/linux/suspend.h                     |    3 
 b/include/linux/swap.h                        |    1 
 b/include/linux/thread_info.h                 |   10 
 b/include/linux/tick.h                        |    6 
 b/include/linux/timer.h                       |    6 
 b/include/linux/uaccess.h                     |   30 
 b/include/xen/page.h                          |    6 
 b/init/main.c                                 |   25 
 b/kernel/Makefile                             |    3 
 b/kernel/backtracetest.c                      |   48 
 b/kernel/irq/manage.c                         |    3 
 b/kernel/irq/proc.c                           |   21 
 b/kernel/irq/spurious.c                       |    5 
 b/kernel/kgdb.c                               | 2306 ++++++++++++++++++++
 b/kernel/kprobes.c                            |    2 
 b/kernel/module.c                             |   66 
 b/kernel/panic.c                              |   29 
 b/kernel/printk.c                             |    7 
 b/kernel/ptrace.c                             |  165 +
 b/kernel/sched.c                              |   20 
 b/kernel/signal.c                             |    4 
 b/kernel/softirq.c                            |   11 
 b/kernel/softlockup.c                         |   11 
 b/kernel/spinlock.c                           |    3 
 b/kernel/sysctl.c                             |   11 
 b/kernel/test_kprobes.c                       |  216 +
 b/kernel/time/clockevents.c                   |   13 
 b/kernel/time/clocksource.c                   |   43 
 b/kernel/time/tick-broadcast.c                |    7 
 b/kernel/time/tick-internal.h                 |    2 
 b/kernel/time/tick-sched.c                    |   76 
 b/kernel/time/timekeeping.c                   |   28 
 b/kernel/time/timer_stats.c                   |    2 
 b/kernel/timer.c                              |   82 
 b/lib/Kconfig.debug                           |   54 
 b/lib/Kconfig.kgdb                            |   88 
 b/lib/rwsem.c                                 |    8 
 b/mm/memory.c                                 |   39 
 b/mm/mmap.c                                   |    3 
 b/net/sunrpc/svc.c                            |    1 
 b/sound/pci/intel8x0.c                        |    8 
 include/asm-x86/acpi_32.h                     |  143 -
 include/asm-x86/acpi_64.h                     |  153 -
 include/asm-x86/alternative_32.h              |  154 -
 include/asm-x86/alternative_64.h              |  159 -
 include/asm-x86/apic_32.h                     |  127 -
 include/asm-x86/apic_64.h                     |  102 
 include/asm-x86/apicdef_32.h                  |  375 ---
 include/asm-x86/apicdef_64.h                  |  392 ---
 include/asm-x86/cpufeature_32.h               |  176 -
 include/asm-x86/cpufeature_64.h               |   30 
 include/asm-x86/desc_32.h                     |  244 --
 include/asm-x86/dma_32.h                      |  297 --
 include/asm-x86/dma_64.h                      |  304 --
 include/asm-x86/fpu32.h                       |   10 
 include/asm-x86/futex_32.h                    |  135 -
 include/asm-x86/futex_64.h                    |  125 -
 include/asm-x86/i387_32.h                     |  151 -
 include/asm-x86/i387_64.h                     |  214 -
 include/asm-x86/io_apic_32.h                  |  155 -
 include/asm-x86/io_apic_64.h                  |  138 -
 include/asm-x86/irqflags_32.h                 |  197 -
 include/asm-x86/irqflags_64.h                 |  176 -
 include/asm-x86/kexec_32.h                    |   99 
 include/asm-x86/kexec_64.h                    |   94 
 include/asm-x86/kprobes_32.h                  |   94 
 include/asm-x86/kprobes_64.h                  |   90 
 include/asm-x86/linkage_32.h                  |   15 
 include/asm-x86/linkage_64.h                  |    6 
 include/asm-x86/local_32.h                    |  233 --
 include/asm-x86/local_64.h                    |  222 --
 include/asm-x86/mach-default/io_ports.h       |   25 
 include/asm-x86/mach-default/mach_time.h      |  111 -
 include/asm-x86/mc146818rtc_32.h              |   97 
 include/asm-x86/mc146818rtc_64.h              |   29 
 include/asm-x86/mmsegment.h                   |    8 
 include/asm-x86/module_32.h                   |   75 
 include/asm-x86/module_64.h                   |   10 
 include/asm-x86/mpspec_32.h                   |   81 
 include/asm-x86/mpspec_64.h                   |  233 --
 include/asm-x86/percpu_32.h                   |  154 -
 include/asm-x86/percpu_64.h                   |   68 
 include/asm-x86/processor_32.h                |  786 -------
 include/asm-x86/processor_64.h                |  452 ----
 include/asm-x86/resume-trace_32.h             |   13 
 include/asm-x86/resume-trace_64.h             |   13 
 include/asm-x86/scatterlist_32.h              |   28 
 include/asm-x86/scatterlist_64.h              |   29 
 include/asm-x86/segment_32.h                  |  148 -
 include/asm-x86/segment_64.h                  |   53 
 include/asm-x86/sparsemem_32.h                |   31 
 include/asm-x86/sparsemem_64.h                |   26 
 include/asm-x86/spinlock_32.h                 |  221 -
 include/asm-x86/spinlock_64.h                 |  167 -
 include/asm-x86/system_32.h                   |  320 --
 include/asm-x86/tlbflush_32.h                 |  168 -
 include/asm-x86/tlbflush_64.h                 |  100 
 include/asm-x86/topology_32.h                 |  121 -
 include/asm-x86/topology_64.h                 |   71 
 include/asm-x86/vsyscall32.h                  |   20 
 671 files changed, 42791 insertions(+), 38967 deletions(-)

