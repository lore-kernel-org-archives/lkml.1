Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZGSQNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZGSQNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 12:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbZGSQNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 12:13:08 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58057 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbZGSQNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 12:13:07 -0400
Date: Sun, 19 Jul 2009 18:13:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 10/10, corrected diffstat] drivers/net: Move a dereference
 below a NULL test
Message-ID: <Pine.LNX.4.64.0907191812010.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereferences should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  BUG_ON (E == NULL||...);
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/ibm_newemac/rgmii.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ibm_newemac/rgmii.c b/drivers/net/ibm_newemac/rgmii.c
index 1d5379d..8d76cb8 100644
--- a/drivers/net/ibm_newemac/rgmii.c
+++ b/drivers/net/ibm_newemac/rgmii.c
@@ -188,11 +188,12 @@ void rgmii_put_mdio(struct of_device *ofdev, int input)
 void rgmii_detach(struct of_device *ofdev, int input)
 {
 	struct rgmii_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct rgmii_regs __iomem *p = dev->base;
-
-	mutex_lock(&dev->lock);
+	struct rgmii_regs __iomem *p;
 
 	BUG_ON(!dev || dev->users == 0);
+	p = dev->base;
+
+	mutex_lock(&dev->lock);
 
 	RGMII_DBG(dev, "detach(%d)" NL, input);
 
