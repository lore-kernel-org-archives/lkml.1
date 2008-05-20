Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYETJHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYETJHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761534AbYETJGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:06:53 -0400
Received: from gw.goop.org ([64.81.55.164]:44045 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761032AbYETJGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:06:51 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 8] x86: fix warning on 32-bit non-PAE
X-Mercurial-Node: 87931b0e60bf1ad01a8cac199d27b1dfadc94e62
Message-Id: <87931b0e60bf1ad01a8c.1211268378@localhost>
In-Reply-To: <patchbomb.1211268376@localhost>
Date: Tue, 20 May 2008 08:26:18 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
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


