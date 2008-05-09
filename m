Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYEILK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYEILK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYEILJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:34 -0400
Received: from gw.goop.org ([64.81.55.164]:47563 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbYEILJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 8] x86: fix warning on 32-bit non-PAE
X-Mercurial-Node: 0ac2db3b2eab11e9ab01c8fcd6512efc075214e5
Message-Id: <0ac2db3b2eab11e9ab01.1210330960@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:40 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the warning:

include2/asm/pgtable.h: In function `pte_modify':
include2/asm/pgtable.h:290: warning: left shift count >= width of type

On 32-bit PAE the virtual and physical addresses are both 32-bits,
so it ends up evaluating 1<<32.  Do the shift as a 64-bit shift then
cast to the appropriate size.  This should all be done at compile time,
and so have no effect on generated code.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -29,7 +29,7 @@
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
 
-#define __PHYSICAL_MASK		((((phys_addr_t)1) << __PHYSICAL_MASK_SHIFT) - 1)
+#define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)
 #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
 #ifndef __ASSEMBLY__


