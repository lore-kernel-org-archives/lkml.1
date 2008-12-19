Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYLSRLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYLSRLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYLSRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:11:08 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59682 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYLSRLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:11:06 -0500
Date: Fri, 19 Dec 2008 18:11:01 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dreamfly281@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] drivers/staging/agnx: Move a dereference below a NULL
 test
Message-ID: <Pine.LNX.4.64.0812191810240.11217@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/agnx/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -u -p a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -440,11 +440,12 @@ static struct ieee80211_ops agnx_ops = {
 static void __devexit agnx_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
-	struct agnx_priv *priv = dev->priv;
+	struct agnx_priv *priv;
 	AGNX_TRACE;
 
 	if (!dev)
 		return;
+	priv = dev->priv;
 	ieee80211_unregister_hw(dev);
 	pci_iounmap(pdev, priv->ctl);
 	pci_iounmap(pdev, priv->data);
