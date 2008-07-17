Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbYGQT1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbYGQT1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbYGQTXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:03 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:35575 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbYGQTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:52 -0400
Message-Id: <20080717191757.865946466@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:34 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
Subject: [patch 27/29] arch/m68k/mm/sun3mmu.c: Eliminate NULL test and memset after alloc_bootmem
Content-Disposition: inline; filename=m68k-sun3-eliminate-NULL-test-and-memset-after-alloc_bootmem.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
.. when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
.. when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/sun3mmu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/m68k/mm/sun3mmu.c
+++ b/arch/m68k/mm/sun3mmu.c
@@ -53,7 +53,6 @@ void __init paging_init(void)
 	wp_works_ok = 0;
 #endif
 	empty_zero_page = alloc_bootmem_pages(PAGE_SIZE);
-	memset(empty_zero_page, 0, PAGE_SIZE);
 
 	address = PAGE_OFFSET;
 	pg_dir = swapper_pg_dir;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

