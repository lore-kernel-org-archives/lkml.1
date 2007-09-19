Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbXISQ3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbXISQ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXISQ3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:29:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38153 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXISQ3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:29:34 -0400
Date: Wed, 19 Sep 2007 17:29:32 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
       linuxppc-dev@ozlabs.org
Subject: 2.6.23-rc6-mm1: kgdb support on ppc64 utterly broken
Message-ID: <20070919162932.GH14817@skynet.ie>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070918174408.GC1804@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070918174408.GC1804@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/09/07 18:44), Mel Gorman didst pronounce:
> Hi Andrew,
> 
> IA64 failed to build in kgdb with the messages
> 

ppc64 kgdb support is also broken but in a much more fundamental manner.
allmodconfig shows up

In file included from include/linux/kgdb.h:22,
                 from arch/powerpc/kernel/legacy_serial.c:15:
include/asm/kgdb.h:34: error: 'debugger' redeclared as different kind of symbol
include/asm/system.h:85: error: previous definition of 'debugger' was here
include/asm/kgdb.h:35: error: 'debugger_bpt' redeclared as different kind of symbol
include/asm/system.h:87: error: previous definition of 'debugger_bpt' was here
include/asm/kgdb.h:36: error: 'debugger_sstep' redeclared as different kind of symbol
include/asm/system.h:88: error: previous definition of 'debugger_sstep' was here
include/asm/kgdb.h:37: error: 'debugger_iabr_match' redeclared as different kind of symbol
include/asm/system.h:89: error: previous definition of 'debugger_iabr_match' was here
include/asm/kgdb.h:38: error: 'debugger_dabr_match' redeclared as different kind of symbol
include/asm/system.h:90: error: previous definition of 'debugger_dabr_match' was here
include/asm/kgdb.h:39: error: 'debugger_fault_handler' redeclared as different kind of symbol
include/asm/system.h:91: error: previous definition of 'debugger_fault_handler' was here
In file included from arch/powerpc/kernel/legacy_serial.c:15:
include/linux/kgdb.h:69: error: `BREAK_INSTR_SIZE' undeclared here (not in a function)
make[1]: *** [arch/powerpc/kernel/legacy_serial.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

I cleared the redeclarations up and put in some defines but there is
much more fundamental breakage like

kernel/kgdb.c:122: error: `BUFMAX' undeclared here (not in a function)
kernel/kgdb.c:128: error: `NUMCRITREGBYTES' undeclared here (not in a function)
kernel/kgdb.c: In function `write_mem_msg':
kernel/kgdb.c:554: error: `CACHE_FLUSH_IS_SAFE' undeclared (first use in this function)
kernel/kgdb.c:554: error: (Each undeclared identifier is reported only once
kernel/kgdb.c:554: error: for each function it appears in.)
kernel/kgdb.c: In function `getthread':
kernel/kgdb.c:615: error: implicit declaration of function `kgdb_get_shadow_thread'
kernel/kgdb.c:616: warning: return makes pointer from integer without a cast
kernel/kgdb.c: In function `kgdb_activate_sw_breakpoints':
kernel/kgdb.c:719: error: `CACHE_FLUSH_IS_SAFE' undeclared (first use in this function)
kernel/kgdb.c: In function `kgdb_deactivate_sw_breakpoints':
kernel/kgdb.c:784: error: `CACHE_FLUSH_IS_SAFE' undeclared (first use in this function)
kernel/kgdb.c: In function `kgdb_handle_exception':
kernel/kgdb.c:956: error: implicit declaration of function `kgdb_skipexception'
kernel/kgdb.c:1036: error: implicit declaration of function `kgdb_disable_hw_debug'
kernel/kgdb.c:1072: error: implicit declaration of function `kgdb_post_master_code'
kernel/kgdb.c:1153: error: implicit declaration of function `kgdb_shadow_regs'
kernel/kgdb.c:1156: warning: assignment makes pointer from integer without a cast
kernel/kgdb.c:1333: error: implicit declaration of function `kgdb_shadowinfo'
kernel/kgdb.c: In function `breakpoint':
kernel/kgdb.c:1891: error: implicit declaration of function `BREAKPOINT'
kernel/kgdb.c: At top level:
kernel/kgdb.c:122: error: storage size of `remcom_in_buffer' isn't known
kernel/kgdb.c:123: error: storage size of `remcom_out_buffer' isn't known
kernel/kgdb.c:129: error: storage size of `kgdb_fault_jmp_regs' isn't known
kernel/kgdb.c:853: error: storage size of `gdbmsgbuf' isn't known
kernel/kgdb.c:122: warning: 'remcom_in_buffer' defined but not used
kernel/kgdb.c:123: warning: 'remcom_out_buffer' defined but not used
kernel/kgdb.c:853: warning: 'gdbmsgbuf' defined but not used
make[1]: *** [kernel/kgdb.o] Error 1
make: *** [kernel] Error 2

Even with the defines fixed up, I don't know what to do about
kgdb_skipexception() and friends because frankly I don't know what I'm
doing with kgdb. linuxppc-dev added to cc list this time in case they have
something useful.

The best I was able to come up with as a candidate fix was to disable
kgdb on ppc64 altogether. This is a cop-out, not a fix, sorry.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 Kconfig.kgdb |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc6-mm1-020_fix_acpi/lib/Kconfig.kgdb linux-2.6.23-rc6-mm1-025_fix_ppc64_kgdb/lib/Kconfig.kgdb
--- linux-2.6.23-rc6-mm1-020_fix_acpi/lib/Kconfig.kgdb	2007-09-18 11:29:30.000000000 +0100
+++ linux-2.6.23-rc6-mm1-025_fix_ppc64_kgdb/lib/Kconfig.kgdb	2007-09-19 15:54:23.000000000 +0100
@@ -14,7 +14,7 @@ config KGDB
 	bool "KGDB: kernel debugging with remote gdb"
 	select WANT_EXTRA_DEBUG_INFORMATION
 	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
-	depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64 || PPC)
+	depends on DEBUG_KERNEL && (ARM || X86 || MIPS || (SUPERH && !SUPERH64) || IA64)
 	help
 	  If you say Y here, it will be possible to remotely debug the
 	  kernel using gdb.  Documentation of kernel debugger is available

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
