Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZB1Ne2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZB1Ne2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 08:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZB1NeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 08:34:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47832 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZB1NeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 08:34:17 -0500
Date: Sat, 28 Feb 2009 14:34:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Theodore Ts'o" <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull] x86 fix
Message-ID: <20090228133405.GA17097@elte.hu>
References: <E1LdOqH-0004wg-JB@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LdOqH-0004wg-JB@closure.thunk.org>
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


* Theodore Ts'o <tytso@mit.edu> wrote:

> A recent (probably within the last week) commit seems to have caused
> the i915 driver to need to use two unexported symbols:
> 
> ERROR: "pgprot_writecombine" [drivers/gpu/drm/i915/i915.ko] undefined!
> ERROR: "is_io_mapping_possible" [drivers/gpu/drm/i915/i915.ko] undefined!
> 
> Is the right fix just to export them?  

Yeah. This module build bug got masked by two other PAT patches 
which needed different exports:

 13093cb: gpu/drm, x86, PAT: PAT support for io_mapping_*, export symbols for modules

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: i915 needs pgprot_writecombine() and is_io_mapping_possible()


 arch/x86/mm/iomap_32.c |   15 ++++-----------
 arch/x86/mm/pat.c      |    2 ++
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 6c2b1af..04102d4 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -20,23 +20,16 @@
 #include <asm/pat.h>
 #include <linux/module.h>
 
-#ifdef CONFIG_X86_PAE
-int
-is_io_mapping_possible(resource_size_t base, unsigned long size)
-{
-	return 1;
-}
-#else
-int
-is_io_mapping_possible(resource_size_t base, unsigned long size)
+int is_io_mapping_possible(resource_size_t base, unsigned long size)
 {
+#ifndef CONFIG_X86_PAE
 	/* There is no way to map greater than 1 << 32 address without PAE */
 	if (base + size > 0x100000000ULL)
 		return 0;
-
+#endif
 	return 1;
 }
-#endif
+EXPORT_SYMBOL_GPL(is_io_mapping_possible);
 
 /* Map 'pfn' using fixed map 'type' and protections 'prot'
  */
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index aebbf67..e0ab173 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -11,6 +11,7 @@
 #include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -868,6 +869,7 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
 	else
 		return pgprot_noncached(prot);
 }
+EXPORT_SYMBOL_GPL(pgprot_writecombine);
 
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
