Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYIJL62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYIJL62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYIJL5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:57:47 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:53612 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbYIJL5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:57:45 -0400
Date: Wed, 10 Sep 2008 13:57:43 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] arch/x86/kernel/kdebugfs.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0809101357210.15308@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.
Note that at the point of the change, node has not yet been stored in d, so
it is not affected by the existing cleanup code.

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
 arch/x86/kernel/kdebugfs.c    |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index f2d43bc..ff7d3b0 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -139,6 +139,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		if (PageHighMem(pg)) {
 			data = ioremap_cache(pa_data, sizeof(*data));
 			if (!data) {
+				kfree(node);
 				error = -ENXIO;
 				goto err_dir;
 			}
