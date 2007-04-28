Return-Path: <linux-kernel-owner+w=401wt.eu-S1031160AbXD1NkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031160AbXD1NkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031151AbXD1NkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:44517 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbXD1Njp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=k+T8NQpOJ+jIzLPQJBxUeIydVpV9EFTOnRkoiHYHMZky/aejZRPPR3NtapYJwSa6+MYUYBNAd3jHbdSwg8YW5mqDANQSKAB4cP5xe9QdiUu2587BaOMus4RrAkDcEfgdRwG2TCpOTlzA1vIKGpn1jnaz0JhN7NPIr3uWeR7V3I0=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 01/21] idr: fix obscure bug in allocation path
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:38 +0900
Message-Id: <11777675781229-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In sub_alloc(), when bitmap search fails, it goes up one level to
continue search.  This is done by updating the id cursor and searching
the upper level again.  If the cursor was at the end of the upper
level, we need to go further than that.

This wasn't implemented and when that happens the part of the cursor
which indexes into the upper level wraps and sub_alloc() ends up
searching the wrong bitmap.  It allocates id which doesn't match the
actual slot.

This patch fixes this by restarting from the top if the search needs
to go higher than one level.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 lib/idr.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 305117c..7b5a59c 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -100,10 +100,11 @@ static int sub_alloc(struct idr *idp, void *ptr, int *starting_id)
 	int n, m, sh;
 	struct idr_layer *p, *new;
 	struct idr_layer *pa[MAX_LEVEL];
-	int l, id;
+	int l, id, oid;
 	long bm;
 
 	id = *starting_id;
+ restart:
 	p = idp->top;
 	l = idp->layers;
 	pa[l--] = NULL;
@@ -117,12 +118,23 @@ static int sub_alloc(struct idr *idp, void *ptr, int *starting_id)
 		if (m == IDR_SIZE) {
 			/* no space available go back to previous layer. */
 			l++;
+			oid = id;
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
+
+			/* if already at the top layer, we need to grow */
 			if (!(p = pa[l])) {
 				*starting_id = id;
 				return -2;
 			}
-			continue;
+
+			/* If we need to go up one layer, continue the
+			 * loop; otherwise, restart from the top.
+			 */
+			sh = IDR_BITS * (l + 1);
+			if (oid >> sh == id >> sh)
+				continue;
+			else
+				goto restart;
 		}
 		if (m != n) {
 			sh = IDR_BITS*l;
-- 
1.5.0.3


