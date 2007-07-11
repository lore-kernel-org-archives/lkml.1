Return-Path: <linux-kernel-owner+w=401wt.eu-S964827AbXGKXli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbXGKXli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935079AbXGKXeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:33770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935089AbXGKXeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/61] idr: fix obscure bug in allocation path
Date: Wed, 11 Jul 2007 16:31:38 -0700
Message-Id: <11841968303508-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968271925-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.5.2.2

