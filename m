Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYKNSFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYKNSFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYKNSFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:05:35 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59097 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYKNSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:05:34 -0500
Date: Fri, 14 Nov 2008 19:05:31 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: srostedt@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] kernel/trace/trace.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0811141904580.10023@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

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
 kernel/trace/trace.c          |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 697eda3..d86e325 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1936,6 +1936,7 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
 	mutex_unlock(&trace_types_lock);
+	kfree(iter);
 
 	return ERR_PTR(-ENOMEM);
 }
