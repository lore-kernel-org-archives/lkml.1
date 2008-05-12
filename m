Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYELNio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYELNio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYELNid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:38:33 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44154 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYELNib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:38:31 -0400
Date: Mon, 12 May 2008 15:38:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: pantelis.antoniou@gmail.com, vbordug@ru.mvista.com,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/6] drivers/net/fs_enet: remove null pointer dereference
Message-ID: <Pine.LNX.4.64.0805121537590.3694@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The following code appears in the function fs_init_instance in the file drivers/net/fs_enet/fs_enet-main.c.

	if (fep->ops == NULL) {
		printk(KERN_ERR DRV_MODULE_NAME
		       ": %s No matching ops found (%d).\n",
		       ndev->name, fpi->fs_no);
		err = -EINVAL;
		goto err;
	}

This code implies that at the point of err, fep->ops can be NULL, so an
extra test is needed before dereferencing this value.


This problem was found using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
--- a/drivers/net/fs_enet/fs_enet-main.c	2008-04-27 11:41:11.000000000 +0200
+++ b/drivers/net/fs_enet/fs_enet-main.c	2008-05-12 09:41:52.000000000 +0200
@@ -1093,7 +1093,7 @@ err:
 		if (registered)
 			unregister_netdev(ndev);
 
-		if (fep != NULL) {
+		if (fep && fep->ops) {
 			(*fep->ops->free_bd)(ndev);
 			(*fep->ops->cleanup_data)(ndev);
 		}
