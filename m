Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYJMULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYJMULk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYJMUGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:06:11 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:53408 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbYJMUFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:05:44 -0400
Message-Id: <20081013195923.281385923@mail.of.borg>
References: <20081013195846.674654386@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 21:59:04 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
Subject: [patch 18/18] arch/m68k/mm/kmap.c: introduce missing kfree
Content-Disposition: inline; filename=m68k-arch-m68k-mm-kmap-c-introduce-missing-kfree.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
..
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
..>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/kmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -66,8 +66,10 @@ static struct vm_struct *get_io_area(uns
 	for (p = &iolist; (tmp = *p) ; p = &tmp->next) {
 		if (size + addr < (unsigned long)tmp->addr)
 			break;
-		if (addr > KMAP_END-size)
+		if (addr > KMAP_END-size) {
+			kfree(area);
 			return NULL;
+		}
 		addr = tmp->size + (unsigned long)tmp->addr;
 	}
 	area->addr = (void *)addr;

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

