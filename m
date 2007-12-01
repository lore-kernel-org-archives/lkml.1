Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbXLAEDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbXLAEDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 23:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXLAEDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 23:03:34 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:53885 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXLAEDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 23:03:33 -0500
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 30 Nov 2007 20:03:31 -0800
Message-ID: <adair3jjc30.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Dec 2007 04:03:32.0444 (UTC) FILETIME=[235A81C0:01C833CF]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get two small fixes for 2.6.24:

Jack Morgenstein (1):
      IPoIB: Fix oops if xmit is called when priv->broadcast is NULL

Joachim Fenkes (1):
      IB/ehca: Fix static rate if path faster than link

 drivers/infiniband/hw/ehca/ehca_av.c      |    8 ++++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 453eb99..f7782c8 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -76,8 +76,12 @@ int ehca_calc_ipd(struct ehca_shca *shca, int port,
 
 	link = ib_width_enum_to_int(pa.active_width) * pa.active_speed;
 
-	/* IPD = round((link / path) - 1) */
-	*ipd = ((link + (path >> 1)) / path) - 1;
+	if (path >= link)
+		/* no need to throttle if path faster than link */
+		*ipd = 0;
+	else
+		/* IPD = round((link / path) - 1) */
+		*ipd = ((link + (path >> 1)) / path) - 1;
 
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a03a65e..c9f6077 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -460,6 +460,9 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_path *path;
 
+	if (!priv->broadcast)
+		return NULL;
+
 	path = kzalloc(sizeof *path, GFP_ATOMIC);
 	if (!path)
 		return NULL;
