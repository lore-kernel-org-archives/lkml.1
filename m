Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZG1P6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZG1P6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZG1P6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:58:39 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49505 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZG1P6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:58:38 -0400
Date: Tue, 28 Jul 2009 17:52:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/9] drivers/staging: correct error-handling code
Message-ID: <Pine.LNX.4.64.0907281752370.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dst_state_alloc returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = dst_state_alloc(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/dst/export.c        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dst/export.c b/drivers/staging/dst/export.c
index 80ae4eb..4fbd848 100644
--- a/drivers/staging/dst/export.c
+++ b/drivers/staging/dst/export.c
@@ -159,7 +159,7 @@ static struct dst_state *dst_accept_client(struct dst_state *st)
 		goto err_out_exit;
 
 	new = dst_state_alloc(st->node);
-	if (!new) {
+	if (IS_ERR(new)) {
 		err = -ENOMEM;
 		goto err_out_release;
 	}
