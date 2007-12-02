Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXLBL7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXLBL7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 06:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXLBL7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 06:59:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:16017 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXLBL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 06:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=B1LzlSmQUsUtGnMnUxFELRd6Uu742ICXB9puG1vBZWofrpr2SSSLg+VrgRoZRrLjeczwuSlbtSKIy6OEOMxPJ5LU17+Ub1bHZUlpon4EebkNqKdEoZ0WT3zxv7Mna+sXG7sPnd+V//9p34iYYi2ScegzSEsJso917Up9GHY+Dt4=
From: Denis Cheng <crquan@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm/backing-dev.c: fix percpu_counter_destroy call bug in bdi_init
Date: Sun,  2 Dec 2007 19:59:07 +0800
Message-Id: <1196596747-5932-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this call should use the array index j, not i:

	--- mm/backing-dev.c.orig	2007-12-02 19:42:57.000000000 +0800
	+++ mm/backing-dev.c	2007-12-02 19:43:14.000000000 +0800
	@@ -22,7 +22,7 @@ int bdi_init(struct backing_dev_info *bd
		if (err) {
	 err:
			for (j = 0; j < i; j++)
	-			percpu_counter_destroy(&bdi->bdi_stat[i]);
	+			percpu_counter_destroy(&bdi->bdi_stat[j]);
		}

		return err;

but with this approach, just one int i is enough, int j is not needed.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 mm/backing-dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b0ceb29..e8644b1 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -7,7 +7,7 @@
 
 int bdi_init(struct backing_dev_info *bdi)
 {
-	int i, j;
+	int i;
 	int err;
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
@@ -21,7 +21,7 @@ int bdi_init(struct backing_dev_info *bdi)
 
 	if (err) {
 err:
-		for (j = 0; j < i; j++)
+		while (i--)
 			percpu_counter_destroy(&bdi->bdi_stat[i]);
 	}
 
-- 
1.5.3.4

