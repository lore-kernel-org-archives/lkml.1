Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZLTTjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZLTTjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZLTTjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:39:06 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:36565 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZLTTjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:39:05 -0500
Date: Sun, 20 Dec 2009 20:39:00 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] kernel/cred.c: Use kmem_cache_free
Message-ID: <Pine.LNX.4.64.0912202038380.29948@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Free memory allocated using kmem_cache_zalloc using kmem_cache_free rather
than kfree.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E,c;
@@

 x = \(kmem_cache_alloc\|kmem_cache_zalloc\|kmem_cache_alloc_node\)(c,...)
 ... when != x = E
     when != &x
?-kfree(x)
+kmem_cache_free(c,x)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 kernel/cred.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/kernel/cred.c b/kernel/cred.c
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -224,7 +224,7 @@ struct cred *cred_alloc_blank(void)
 #ifdef CONFIG_KEYS
 	new->tgcred = kzalloc(sizeof(*new->tgcred), GFP_KERNEL);
 	if (!new->tgcred) {
-		kfree(new);
+		kmem_cache_free(cred_jar, new);
 		return NULL;
 	}
 	atomic_set(&new->tgcred->usage, 1);
