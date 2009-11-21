Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZKUVSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZKUVSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 16:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZKUVSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 16:18:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:48338 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbZKUVSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 16:18:40 -0500
Date: Sat, 21 Nov 2009 22:18:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/regulator: use PTR_ERR to get error code
Message-ID: <Pine.LNX.4.64.0911212218210.28848@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

IS_ERR returns only 1 or 0.  The callsite of setup_regulators expects a
negative integer in an error case.  Thus, PTR_ERR has to be used to extract
it.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E1;
@@

*E = IS_ERR(...)
 ... when != E = E1
*return E;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/regulator/lp3971.c          |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 7803a32..76d08c2 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -446,8 +446,8 @@ static int setup_regulators(struct lp3971 *lp3971,
 		lp3971->rdev[i] = regulator_register(&regulators[id],
 			lp3971->dev, pdata->regulators[i].initdata, lp3971);
 
-		err = IS_ERR(lp3971->rdev[i]);
-		if (err) {
+		if (IS_ERR(lp3971->rdev[i])) {
+			err = PTR_ERR(lp3971->rdev[i]);
 			dev_err(lp3971->dev, "regulator init failed: %d\n",
 				err);
 			goto error;
