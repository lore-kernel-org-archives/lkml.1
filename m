Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZG1QB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZG1QB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZG1QB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:01:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59003 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbZG1QB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:01:56 -0400
Date: Tue, 28 Jul 2009 17:56:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: avorontsov@ru.mvista.com, linuxppc-dev@ozlabs.org,
       sdhci-devel@lists.ossman.eu, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 8/9] drivers/mmc: correct error-handling code
Message-ID: <Pine.LNX.4.64.0907281755340.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sdhci_alloc_host returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = sdhci_alloc_host(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mmc/host/sdhci-of.c         |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
index d79fa55..fb00bc5 100644
--- a/drivers/mmc/host/sdhci-of.c
+++ b/drivers/mmc/host/sdhci-of.c
@@ -226,7 +226,7 @@ static int __devinit sdhci_of_probe(struct of_device *ofdev,
 		return -ENODEV;
 
 	host = sdhci_alloc_host(&ofdev->dev, sizeof(*of_host));
-	if (!host)
+	if (IS_ERR(host))
 		return -ENOMEM;
 
 	of_host = sdhci_priv(host);
