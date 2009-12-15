Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbZLOWrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbZLOWrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932748AbZLOWrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:47:18 -0500
Received: from ozlabs.org ([203.10.76.45]:51135 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbZLOWrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:47:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module changes
Date: Wed, 16 Dec 2009 09:17:12 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
       wenji.huang@oracle.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912160917.12351.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3ea6b3d0e6d0ffd91c0f8cadeb69b7133c038b32:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-udf-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git module

Alan Jenkins (3):
      ARM: use unified discard definition in linker script
      ARM: unexport symbols used to implement floating point emulation
      module: make MODULE_SYMBOL_PREFIX into a CONFIG option

Michal Marek (1):
      modpost: fix segfault with short symbol names

Rusty Russell (2):
      x86: don't export inline function
      module: handle ppc64 relocating kcrctabs when CONFIG_RELOCATABLE=y

Stephen Rothwell (1):
      sparc64: don't export static inline pci_ functions

Wenji Huang (1):
      Kbuild: clear marker out of modpost

 arch/arm/kernel/armksyms.c         |   20 ----
 arch/arm/kernel/vmlinux.lds.S      |   13 ++-
 arch/blackfin/Kconfig              |    4 +
 arch/blackfin/include/asm/module.h |    2 -
 arch/blackfin/kernel/vmlinux.lds.S |    2 -
 arch/h8300/Kconfig                 |    4 +
 arch/h8300/include/asm/module.h    |    2 -
 arch/h8300/kernel/vmlinux.lds.S    |    1 -
 arch/powerpc/include/asm/module.h  |    5 +
 arch/powerpc/kernel/vmlinux.lds.S  |    3 +
 arch/sparc/kernel/pci.c            |    1 -
 arch/sparc/kernel/sparc_ksyms_64.c |   12 ---
 arch/x86/kernel/x8664_ksyms_64.c   |    4 +-
 include/asm-generic/vmlinux.lds.h  |    8 +-
 include/linux/module.h             |    6 +-
 kernel/module.c                    |   28 ++++--
 scripts/Makefile.lib               |    5 +
 scripts/mod/Makefile               |    2 +-
 scripts/mod/mk_elfconfig.c         |    9 --
 scripts/mod/modpost.c              |  177 ++---------------------------------
 scripts/mod/modpost.h              |    3 -
 21 files changed, 75 insertions(+), 236 deletions(-)

commit 1abff64d49ae24a77ae1e191fa58b725c5991c7e
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu Nov 12 19:26:14 2009 +1100

    sparc64: don't export static inline pci_ functions
    
    Exporting an inline function breaks the new assembler-based alphabetical
    sorted symbol list.
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 arch/sparc/kernel/pci.c            |    1 -
 arch/sparc/kernel/sparc_ksyms_64.c |   12 ------------
 2 files changed, 0 insertions(+), 13 deletions(-)

commit e6428047725d72d63c1d9c4ba852e635e3ffe52a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 15 16:28:13 2009 -0600

    x86: don't export inline function
    
    For CONFIG_PARAVIRT, load_gs_index is an inline function (it's #defined
    to native_load_gs_index otherwise).
    
    Exporting an inline function breaks the new assembler-based alphabetical
    sorted symbol list:
    
    Today's linux-next build (x86_64 allmodconfig) failed like this:
    
    	.tmp_exports-asm.o: In function `__ksymtab_load_gs_index':
    	(__ksymtab_sorted+0x5b40): undefined reference to `load_gs_index'
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    To: x86@kernel.org
    Cc: alan-jenkins@tuffmail.co.uk

 arch/x86/kernel/x8664_ksyms_64.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

commit e3f28c1333acfe9e4109b836bc15caf794e94d09
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Sat Nov 7 21:03:52 2009 +0000

    ARM: use unified discard definition in linker script
    
    Commit 023bf6f "linker script: unify usage of discard definition"
    changed the linker scripts for all architectures except for ARM.
    I can find no discussion about this ommision, so here are the changes
    for ARM.
    
    These changes are exactly parallel to the ia64 case.
    
    "ia64 is notable because it first throws away some ia64 specific
     subsections and then include the rest of the sections into the final
     image, so those sections must be discarded before the inclusion."
    
    Not boot-tested.  In build testing, the modified linker script generated
    an identical vmlinux file.
    
    [I would like to be able to rely on this unified discard definition.
     I want to sort the kernel symbol tables to allow faster symbol
     resolution during module loading. The simplest way appears to be
     to generate sorted versions from vmlinux.o, link them in to vmlinux,
     _and discard the original unsorted tables_.
    
     This work is driven by my x86 netbook, but it is implemented at a
     generic level. It is possible it will benefit some ARM systems also.]
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Acked-by-without-testing: Tejun Heo <tj@kernel.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 arch/arm/kernel/vmlinux.lds.S |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

commit 3e7b19efe621bcf8bfef896c9c4cc5c99c52c3ec
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Sat Nov 7 21:03:53 2009 +0000

    ARM: unexport symbols used to implement floating point emulation
    
    The Kconfigs for in-tree floating point emulation do not allow building
    as modules. That leaves the Acorn FPEmulator module. I found two public
    releases of this as a binary module for 2.1 and 2.2 kernels, optimized
    for ARMV4.[1] If there is a resurgence of interest in this, the symbols
    can always be re-exported.
    
    This allows the EXPORT_SYMBOL_ALIAS() hack to be removed. The ulterior
    motive here is that EXPORT_SYMBOL_ALIAS() makes it harder to sort the
    resulting kernel symbol tables.  Sorted symbol tables will allow faster
    symbol resolution during module loading.
    
    Note that fp_send_sigs() and fp_printk() are simply aliases for existing
    exports and add no obvious value.  Similarly fp_enter could easily be
    renamed to kern_fp_enter at the point of definition. Therefore removing
    EXPORT_SYMBOL_ALIAS will not serve as a material obstacle to re-adding
    the exports should they be desired in future.
    
    Build tested only.
    
    [1] http://ftp.arm.linux.org.uk/pub/linux/arm/fpemulator/
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    CC: Russell King <linux@arm.linux.org.uk>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 arch/arm/kernel/armksyms.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

commit 9e1b9b80721661bd63b3662453767b22cd614fe7
Author: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date:   Sat Nov 7 21:03:54 2009 +0000

    module: make MODULE_SYMBOL_PREFIX into a CONFIG option
    
    The next commit will require the use of MODULE_SYMBOL_PREFIX in
    .tmp_exports-asm.S.  Currently it is mixed in with C structure
    definitions in "asm/module.h".  Move the definition of this arch option
    into Kconfig, so it can be easily accessed by any code.
    
    This also lets modpost.c use the same definition.  Previously modpost
    relied on a hardcoded list of architectures in mk_elfconfig.c.
    
    A build test for blackfin, one of the two MODULE_SYMBOL_PREFIX archs,
    showed the generated code was unchanged.  vmlinux was identical save
    for build ids, and an apparently randomized suffix on a single "__key"
    symbol in the kallsyms data).
    
    Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
    Acked-by: Mike Frysinger <vapier@gentoo.org> (blackfin)
    CC: Sam Ravnborg <sam@ravnborg.org>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 arch/blackfin/Kconfig              |    4 ++++
 arch/blackfin/include/asm/module.h |    2 --
 arch/blackfin/kernel/vmlinux.lds.S |    2 --
 arch/h8300/Kconfig                 |    4 ++++
 arch/h8300/include/asm/module.h    |    2 --
 arch/h8300/kernel/vmlinux.lds.S    |    1 -
 include/asm-generic/vmlinux.lds.h  |    8 ++++++--
 include/linux/module.h             |    6 ++++--
 scripts/Makefile.lib               |    5 +++++
 scripts/mod/Makefile               |    2 +-
 scripts/mod/mk_elfconfig.c         |    9 ---------
 scripts/mod/modpost.c              |    9 +++++++++
 12 files changed, 33 insertions(+), 21 deletions(-)

commit a8773769d1a1e08d0ca15f890515401ab3860637
Author: Wenji Huang <wenji.huang@oracle.com>
Date:   Mon Nov 16 13:49:55 2009 +0800

    Kbuild: clear marker out of modpost
    
    Remove the unnecessary functions and variables.
    
    Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
    Signed-off-by: Michal Marek <mmarek@suse.cz>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 scripts/mod/modpost.c |  164 -------------------------------------------------
 scripts/mod/modpost.h |    3 -
 2 files changed, 0 insertions(+), 167 deletions(-)

commit d4703aefdbc8f9f347f6dcefcddd791294314eb7
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Dec 15 16:28:32 2009 -0600

    module: handle ppc64 relocating kcrctabs when CONFIG_RELOCATABLE=y
    
    powerpc applies relocations to the kcrctab.  They're absolute symbols,
    but it's not completely unreasonable: other archs may too, but the
    relocation is often 0.
    
    http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-November/077972.html
    
    Inspired-by: Neil Horman <nhorman@tuxdriver.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Tested-by: Neil Horman <nhorman@tuxdriver.com>
    Acked-by: Paul Mackerras <paulus@samba.org>

 arch/powerpc/include/asm/module.h |    5 +++++
 arch/powerpc/kernel/vmlinux.lds.S |    3 +++
 kernel/module.c                   |   28 +++++++++++++++++++++-------
 3 files changed, 29 insertions(+), 7 deletions(-)

commit 8d99513c1b76cfd0b2dcf061c5136cb1061e6b37
Author: Michal Marek <mmarek@suse.cz>
Date:   Sat Dec 12 12:02:24 2009 +0100

    modpost: fix segfault with short symbol names
    
    memcmp() is wrong here, the symbol name can be shorter than KSYMTAB_PFX
    or CRC_PFX.
    
    Signed-off-by: Michal Marek <mmarek@suse.cz>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 scripts/mod/modpost.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
