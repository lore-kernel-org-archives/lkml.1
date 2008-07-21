Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbYGUH6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbYGUH6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbYGUH6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:58:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60144 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757897AbYGUH6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:58:13 -0400
Date: Mon, 21 Jul 2008 09:58:11 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: yi.zhu@intel.com, jketreno@linux.intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/7] drivers/net/wireless/ipw2100.c: Release mutex in error
 handling code
Message-ID: <Pine.LNX.4.64.0807210957490.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -6442,6 +6442,7 @@ static int ipw2100_resume(struct pci_dev
 	if (err) {
 		printk(KERN_ERR "%s: pci_enable_device failed on resume\n",
 		       dev->name);
+		mutex_unlock(&priv->action_mutex);
 		return err;
 	}
 	pci_restore_state(pci_dev);
@@ -7146,7 +7147,7 @@ static int ipw2100_wx_get_rate(struct ne
 	err = ipw2100_get_ordinal(priv, IPW_ORD_CURRENT_TX_RATE, &val, &len);
 	if (err) {
 		IPW_DEBUG_WX("failed querying ordinals.\n");
-		return err;
+		goto done;
 	}
 
 	switch (val & TX_RATE_MASK) {
