Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbYIJL65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbYIJL65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYIJL6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:58:09 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53629 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbYIJL6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:58:07 -0400
Date: Wed, 10 Sep 2008 13:58:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] arch/m68k/mm/kmap.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0809101357440.15308@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
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
---
 arch/m68k/mm/kmap.c           |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
index 46b7d60..df620ac 100644
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -66,8 +66,10 @@ static struct vm_struct *get_io_area(unsigned long size)
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
