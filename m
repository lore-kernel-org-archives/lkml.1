Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYBCUML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYBCUML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 15:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYBCUL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 15:11:57 -0500
Received: from ozlabs.org ([203.10.76.45]:57741 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYBCUL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 15:11:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build bug] lguest build failure: drivers/lguest/x86/switcher_32.S:(.text+0x3815f8): undefined reference to `LGUEST_PAGES_regs_trapnum'
Date: Mon, 4 Feb 2008 07:11:10 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080201124520.GA29900@elte.hu> <20080201170551.GA3825@elte.hu>
In-Reply-To: <20080201170551.GA3825@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802040711.11280.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008 04:05:51 Ingo Molnar wrote:
> looks similar to the previous one so i guess my quick fix attempt was a
> bit too quick. Will turn lguest off again. And i'm willing to test
> patches as well :)

Hi Ingo,

   OK, this problem was caused by asm-offsets.c only having the offsets when
lguest *guest* support was set, not lguest host (host support used to imply
guest support, so now they're separate these bugs come out).

Can you throw this patch into your tree for testing?

Thanks,
Rusty.

Lguest guest support and host support are separate config options: they used
to be tied together.  Sort out which parts of asm-offsets are needed for Guest
and Host.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 7d5a5c7a4b95 arch/x86/kernel/asm-offsets_32.c
--- a/arch/x86/kernel/asm-offsets_32.c	Sat Feb 02 23:13:05 2008 +1100
+++ b/arch/x86/kernel/asm-offsets_32.c	Sun Feb 03 10:13:19 2008 +1100
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
+#ifdef CONFIG_LGUEST
+	BLANK();
 	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
 	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
 	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
