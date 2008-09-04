Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYIDAcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYIDAcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYIDAc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:32:27 -0400
Received: from ozlabs.org ([203.10.76.45]:60975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYIDAc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:32:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18623.11411.543366.29200@cargo.ozlabs.ibm.com>
Date: Thu, 4 Sep 2008 10:32:19 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get 6 commits that fix various regressions, build problems and
serious bugs on powerpc.  I have included the full commit messages
below.

Thanks,
Paul.

 arch/powerpc/Makefile                    |    5 +++++
 arch/powerpc/include/asm/pgtable-ppc64.h |    6 ++----
 arch/powerpc/kernel/Makefile             |    7 ++++---
 arch/powerpc/kernel/align.c              |    2 +-
 arch/powerpc/kernel/idle_6xx.S           |    2 +-
 arch/powerpc/kernel/idle_e500.S          |    3 ++-
 arch/powerpc/kernel/vmlinux.lds.S        |    7 ++++---
 arch/powerpc/mm/hash_utils_64.c          |   18 +++++++++++-------
 arch/powerpc/platforms/powermac/Makefile |    2 +-
 lib/Kconfig.debug                        |    6 +++---
 10 files changed, 34 insertions(+), 24 deletions(-)

commit 7888bc2b4778fda267a6e6422c4497dba865a47a
Author: Kumar Gala <galak@kernel.crashing.org>
Date:   Tue Aug 26 12:08:56 2008 +1000

    powerpc: Fix for getting CPU number in power_save_ppc32_restore()
    
    The calculation to get TI_CPU based off of SPRG3 was just plain wrong,
    meaning that we were getting garbage for the CPU number on 6xx/G3/G4
    based SMP boxes in this code.
    
    Just offset off the stack pointer (to get to thread_info) like all the
    other references to TI_CPU do.
    
    This was pointed out by Chen Gong <G.Chen@freescale.com>
    
    [paulus@samba.org - use rlwinm r12,r11,... instead of
     rlwinm r12,r1,...; tophys()]
    
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 94ee815c05c9387931e549d83312d30009ed86e9
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Wed Sep 3 13:12:05 2008 +1000

    powerpc: Fix build error with 64K pages and !hugetlbfs
    
    HAVE_ARCH_UNMAPPED_AREA and HAVE_ARCH_UNMAPPED_AREA_TOPDOWN must
    be defined whenever CONFIG_PPC_MM_SLICES is enabled, not just when
    CONFIG_HUGETLB_PAGE is.  They used to be always defined together but
    this is no longer the case since 3a8247cc2c856930f34eafce33f6a039227ee175
    ("powerpc: Only demote individual slices rather than whole process").
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 7563dc64585324f443f5ac107eb6d89ee813a2d2
Author: Tony Breeds <tony@bakeyournoodle.com>
Date:   Tue Sep 2 16:50:38 2008 +1000

    powerpc: Work around gcc's -fno-omit-frame-pointer bug
    
    This bug is causing random crashes
    (http://bugzilla.kernel.org/show_bug.cgi?id=11414).
    
    -fno-omit-frame-pointer is only needed on powerpc when -pg is also
    supplied, and there is a gcc bug that causes incorrect code generation
    on 32-bit powerpc when -fno-omit-frame-pointer is used---it uses stack
    locations below the stack pointer, which is not allowed by the ABI
    because those locations can and sometimes do get corrupted by an
    interrupt.
    
    This ensures that CONFIG_FRAME_POINTER is only selected by ftrace.
    When CONFIG_FTRACE is enabled we also pass -mno-sched-epilog to work
    around the gcc codegen bug.
    
    Patch based on work by:
    	Andreas Schwab <schwab@suse.de>
    	Segher Boessenkool <segher@kernel.crashing.org>
    
    Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 303996dace16894710a5291327eeb79afdb8ed12
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue Sep 2 15:04:09 2008 +1000

    powerpc: Make sure _etext is after all kernel text
    
    This makes core_kernel_text() (and therefore kernel_text_address())
    return the correct result.  Currently all the __devinit routines (at
    least) will not be considered to be kernel text.
    
    This is just a quick fix for 2.6.27 - hopefully we will be able to fix
    this better in 2.6.28.
    
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 9e88ba4e45ecad2425c4cc4e0861a26f4e36c6da
Author: Paul Mackerras <paulus@samba.org>
Date:   Sat Aug 30 11:26:27 2008 +1000

    powerpc: Only make kernel text pages of linear mapping executable
    
    Commit bc033b63bbfeb6c4b4eb0a1d083c650e4a0d2af8 ("powerpc/mm: Fix
    attribute confusion with htab_bolt_mapping()") moved the check for
    whether we should make pages of the linear mapping executable from
    htab_bolt_mapping into its callers, including htab_initialize.
    A side-effect of this is that the decision is now made once for
    each contiguous section in the LMB array rather than for each page
    individually.  This can often mean that the whole of the linear
    mapping ends up being executable.
    
    This reverts to the previous behaviour, where individual pages are
    checked for being part of the kernel text or not, by moving the check
    back down into htab_bolt_mapping.
    
    Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

commit 78fbc824ed8225edd80cdc57771d5ca4f7aae95e
Author: Michael Neuling <mikey@neuling.org>
Date:   Thu Aug 28 14:57:39 2008 +1000

    powerpc: Fix uninitialised variable in VSX alignment code
    
    This fixes an uninitialised variable in the VSX alignment code.  It can
    cause warnings from GCC (noticed with gcc-4.1.1).  Gcc is actually
    correct in this instance, and this bug could cause the alignment
    interrupt handler to send a SIGSEGV to the process on a legitimate
    access.
    
    Signed-off-by: Michael Neuling <mikey@neuling.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
