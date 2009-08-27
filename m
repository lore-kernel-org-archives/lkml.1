Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbZH0LnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbZH0LnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZH0LnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:43:07 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:58887 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZH0LnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:43:05 -0400
Date: Thu, 27 Aug 2009 13:41:57 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k: avoid pgprot_noncached redefinition
Message-ID: <20090827114157.GA8678@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

While compiling m68k with defconfig I get tons if these warnings:

/home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable_mm.h:148:1: warning: "pgprot_noncached" redefined
In file included from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable_mm.h:138,
 from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable.h:4,
 from include/linux/mm.h:38,
 from /home2/heicarst/linux-2.6/arch/m68k/include/asm/atarihw.h:134,
 from arch/m68k/atari/debug.c:20:
include/asm-generic/pgtable.h:133:1: warning: this is the location of the previous definition

Reason for this is that asm-generic/pgtable.h gets included in pgtable_mm.h
before pgprot_noncached gets defined.
So the check "#ifndef pgprot_noncached" in the generic header file is too early.
Solve this by including the generic header file after the arch define.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/m68k/include/asm/pgtable_mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/m68k/include/asm/pgtable_mm.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/pgtable_mm.h
+++ linux-2.6/arch/m68k/include/asm/pgtable_mm.h
@@ -135,7 +135,6 @@ static inline void update_mmu_cache(stru
 #endif
 
 #ifndef __ASSEMBLY__
-#include <asm-generic/pgtable.h>
 
 /*
  * Macro to mark a page protection value as "uncacheable".
@@ -154,6 +153,8 @@ static inline void update_mmu_cache(stru
 	    ? (__pgprot((pgprot_val(prot) & _CACHEMASK040) | _PAGE_NOCACHE_S))	\
 	    : (prot)))
 
+#include <asm-generic/pgtable.h>
+
 #endif /* !__ASSEMBLY__ */
 
 /*
