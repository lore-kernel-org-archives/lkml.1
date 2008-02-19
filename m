Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbYBSDqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYBSDqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 22:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYBSDqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 22:46:43 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:42708 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYBSDqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 22:46:42 -0500
Date: Tue, 19 Feb 2008 14:44:04 +1100
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, lguest@ozlabs.org
Subject: [PATCH] Fix building lguest as module.
Message-ID: <20080219034404.GT6887@bakeyournoodle.com>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu> <200802040711.11280.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200802040711.11280.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 07:11:10AM +1100, Rusty Russell wrote:
 
> Lguest guest support and host support are separate config options: they used
> to be tied together.  Sort out which parts of asm-offsets are needed for Guest
> and Host.

<snip> With rusty's patch applied the errors still persist in some
configs.  Please try  the patch below.

Fixes the following errors from modpost when the lguest (host) support is
modular.

ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_regs" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_idt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_guest_gdt" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_sp" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_regs_trapnum" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_guest_idt_desc" [drivers/lguest/lg.ko] undefined!

Lguest guest support and host support are separate config options: they used
to be tied together.  Sort out which parts of asm-offsets are needed for Guest
and Host.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---

Original patch from rusty (http://lkml.org/lkml/2008/2/3/168) didn't completely
fix the problem.  I think this matches the original intent.

Not sure of the right way to attribute this patch, clearlyt it's mostly
Rusty's work.

 arch/x86/kernel/asm-offsets_32.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index afd8446..ae9d289 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -20,10 +20,8 @@
 
 #include <xen/interface/xen.h>
 
-#ifdef CONFIG_LGUEST_GUEST
 #include <linux/lguest.h>
 #include "../../../drivers/lguest/lg.h"
-#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -134,6 +132,10 @@ void foo(void)
 	BLANK();
 	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
 	OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
+#endif
+
+#if defined(CONFIG_LGUEST) || defined(CONFIG_LGUEST_MODULE)
+	BLANK();
 	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
 	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
 	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
-- 
1.5.4.1




Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

