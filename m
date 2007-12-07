Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbXLGRyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbXLGRyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbXLGRu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:50:28 -0500
Received: from www2.coile-labs.com ([65.14.39.133]:21125 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756465AbXLGRu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:50:27 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 13/13] make error messages more specific
Date: Fri,  7 Dec 2007 12:48:11 -0500
Message-Id: <1197049691-27462-13-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
References: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pointed out that the "too many targets" message in patch
2 could be printed for failing GFP_ATOMIC allocations.  This patch
makes the messages more specific.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index bcea36c..1e37cf6 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -957,15 +957,17 @@ addtgt(struct aoedev *d, char *addr, ulong nframes)
 	for (; tt < te && *tt; tt++)
 		;
 
-	if (tt == te)
+	if (tt == te) {
+		printk(KERN_INFO
+			"aoe: device addtgt failure; too many targets\n");
 		return NULL;
-
+	}
 	t = kcalloc(1, sizeof *t, GFP_ATOMIC);
-	if (!t)
-		return NULL;
 	f = kcalloc(nframes, sizeof *f, GFP_ATOMIC);
-	if (!f) {
+	if (!t || !f) {
+		kfree(f);
 		kfree(t);
+		printk(KERN_INFO "aoe: cannot allocate memory to add target\n");
 		return NULL;
 	}
 
@@ -1029,9 +1031,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	if (!t) {
 		t = addtgt(d, h->src, n);
 		if (!t) {
-			printk(KERN_INFO
-				"aoe: device addtgt failure; "
-				"too many targets?\n");
 			spin_unlock_irqrestore(&d->lock, flags);
 			return;
 		}
-- 
1.5.3.4

