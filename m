Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbYEaAFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbYEaAFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYEaADg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:03:36 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:59053
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756607AbYEaADf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:03:35 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 5] xen: Avoid allocations causing swap activity on the
	resume path
X-Mercurial-Node: c692f3a12da1e99a4a435faba6794e56674ed26f
Message-Id: <c692f3a12da1e99a4a43.1212191405@localhost>
In-Reply-To: <patchbomb.1212191400@localhost>
Date: Sat, 31 May 2008 00:50:05 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Jeff Garzik <jgarzik.pobox.com@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Avoid allocations causing swap activity on the resume path by allowing
such allocations to access the emergency pools otherwise a
save/restore/migration of a guest which is low on memory can
deadlock.

[ linux-2.6.18-xen changesets e8b49cfbdac, fdb998e79aba ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 drivers/block/xen-blkfront.c       |    5 +++--
 drivers/net/xen-netfront.c         |    4 ++--
 drivers/xen/xenbus/xenbus_client.c |    2 +-
 drivers/xen/xenbus/xenbus_xs.c     |   10 +++++-----
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -584,7 +584,7 @@
 
 	info->ring_ref = GRANT_INVALID_REF;
 
-	sring = (struct blkif_sring *)__get_free_page(GFP_KERNEL);
+	sring = (struct blkif_sring *)__get_free_page(GFP_KERNEL | __GFP_HIGH);
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
@@ -741,7 +741,8 @@
 	int j;
 
 	/* Stage 1: Make a safe copy of the shadow state. */
-	copy = kmalloc(sizeof(info->shadow), GFP_KERNEL);
+	copy = kmalloc(sizeof(info->shadow),
+		       GFP_KERNEL | __GFP_NOFAIL | __GFP_HIGH);
 	if (!copy)
 		return -ENOMEM;
 	memcpy(copy, info->shadow, sizeof(info->shadow));
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1324,7 +1324,7 @@
 		goto fail;
 	}
 
-	txs = (struct xen_netif_tx_sring *)get_zeroed_page(GFP_KERNEL);
+	txs = (struct xen_netif_tx_sring *)get_zeroed_page(GFP_KERNEL | __GFP_HIGH);
 	if (!txs) {
 		err = -ENOMEM;
 		xenbus_dev_fatal(dev, err, "allocating tx ring page");
@@ -1340,7 +1340,7 @@
 	}
 
 	info->tx_ring_ref = err;
-	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_KERNEL);
+	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_KERNEL | __GFP_HIGH);
 	if (!rxs) {
 		err = -ENOMEM;
 		xenbus_dev_fatal(dev, err, "allocating rx ring page");
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -117,7 +117,7 @@
 	char *path;
 
 	va_start(ap, pathfmt);
-	path = kvasprintf(GFP_KERNEL, pathfmt, ap);
+	path = kvasprintf(GFP_KERNEL | __GFP_HIGH, pathfmt, ap);
 	va_end(ap);
 
 	if (!path) {
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -283,9 +283,9 @@
 	char *buffer;
 
 	if (strlen(name) == 0)
-		buffer = kasprintf(GFP_KERNEL, "%s", dir);
+		buffer = kasprintf(GFP_KERNEL | __GFP_HIGH, "%s", dir);
 	else
-		buffer = kasprintf(GFP_KERNEL, "%s/%s", dir, name);
+		buffer = kasprintf(GFP_KERNEL | __GFP_HIGH, "%s/%s", dir, name);
 	return (!buffer) ? ERR_PTR(-ENOMEM) : buffer;
 }
 
@@ -297,7 +297,7 @@
 	*num = count_strings(strings, len);
 
 	/* Transfer to one big alloc for easy freeing. */
-	ret = kmalloc(*num * sizeof(char *) + len, GFP_KERNEL);
+	ret = kmalloc(*num * sizeof(char *) + len, GFP_KERNEL | __GFP_HIGH);
 	if (!ret) {
 		kfree(strings);
 		return ERR_PTR(-ENOMEM);
@@ -751,7 +751,7 @@
 	}
 
 
-	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg = kmalloc(sizeof(*msg), GFP_KERNEL | __GFP_HIGH);
 	if (msg == NULL) {
 		err = -ENOMEM;
 		goto out;
@@ -763,7 +763,7 @@
 		goto out;
 	}
 
-	body = kmalloc(msg->hdr.len + 1, GFP_KERNEL);
+	body = kmalloc(msg->hdr.len + 1, GFP_KERNEL | __GFP_HIGH);
 	if (body == NULL) {
 		kfree(msg);
 		err = -ENOMEM;


