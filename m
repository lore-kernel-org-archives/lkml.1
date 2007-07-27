Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbXG0DgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbXG0DgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 23:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXG0DgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 23:36:10 -0400
Received: from ozlabs.org ([203.10.76.45]:48529 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759120AbXG0DgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 23:36:08 -0400
Subject: [PATCH] Fix lguest bzImage loading with CONFIG_RELOCATABLE=y
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lguest <lguest@ozlabs.org>, Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 13:35:43 +1000
Message-Id: <1185507343.12151.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Yeh sent his crashing .config: bzImages made with
CONFIG_RELOCATABLE=y put the relocs where the BSS is expected, and we
crash with unusual results such as:

	lguest: unhandled trap 14 at 0xc0122ae1 (0xa9)

Relying on BSS being zero was merely laziness on my part.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r cf2bfb364110 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Fri Jul 27 13:04:22 2007 +1000
+++ b/drivers/lguest/lguest.c	Fri Jul 27 13:15:22 2007 +1000
@@ -1039,6 +1039,11 @@ __init void lguest_init(void *boot)
 	 * the normal data segment to get through booting. */
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_DS) : "memory");
 
+	/* Clear the part of the kernel data which is expected to be zero.
+	 * Normally it will be anyway, but if we're loading from a bzImage with
+	 * CONFIG_RELOCATALE=y, the relocations will be sitting here. */
+	memset(__bss_start, 0, __bss_stop - __bss_start);
+
 	/* The Host uses the top of the Guest's virtual address space for the
 	 * Host<->Guest Switcher, and it tells us how much it needs in
 	 * lguest_data.reserve_mem, set up on the LGUEST_INIT hypercall. */


