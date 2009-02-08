Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZBHVqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZBHVqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZBHVqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:46:25 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55197 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbZBHVqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:46:24 -0500
Date: Sun, 8 Feb 2009 22:46:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jmorris@namei.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 6/6] kernel/cred.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0902082245540.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.
To avoid adding more #ifdefs, the allocation is just moved below the error
handling code.

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
 kernel/cred.c   |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 3a03918..62e909b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -219,18 +219,20 @@ struct cred *prepare_usermodehelper_creds(void)
 #endif
 	struct cred *new;
 
-#ifdef CONFIG_KEYS
-	tgcred = kzalloc(sizeof(*new->tgcred), GFP_ATOMIC);
-	if (!tgcred)
-		return NULL;
-#endif
-
 	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
 	if (!new)
 		return NULL;
 
 	memcpy(new, &init_cred, sizeof(struct cred));
 
+#ifdef CONFIG_KEYS
+	tgcred = kzalloc(sizeof(*new->tgcred), GFP_ATOMIC);
+	if (!tgcred) {
+		kmem_cache_free(cred_jar, new);
+		return NULL;
+	}
+#endif
+
 	atomic_set(&new->usage, 1);
 	get_group_info(new->group_info);
 	get_uid(new->user);
