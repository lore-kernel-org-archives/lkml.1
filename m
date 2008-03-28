Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYC1T0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYC1T0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYC1T0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:26:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24483 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYC1T0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NVD/YCLL1EoJH3TFwusV84bDdgOtZsrNqHpBFHLiH0IpEutGjrGUj1XEsuxKdLfwMYZBcC0E4Pdinv1brcTj9TzF70VyjFw0lrCM3uJ/zSLHq1gy4Dc7oH11IQ2UAZuGlLxH925/I+GJmsPDPBcxKo2jWgORxVAqblvhag9XUq8=
From: Mike Snitzer <snitzer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: nbd-general@lists.sourceforge.net, Mike Snitzer <snitzer@gmail.com>,
       Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] nbd: prevent sock_xmit from attempting to use a NULL socket
Date: Fri, 28 Mar 2008 15:26:40 -0400
Message-Id: <1206732400-23715-1-git-send-email-snitzer@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NBD does not protect the nbd_device's socket from becoming NULL during receives.

This closes a race with the NBD_CLEAR_SOCK ioctl (nbd-client -d) setting
the nbd_device's socket to NULL right before NBD calls sock_xmit.

Signed-off-by: Mike Snitzer <snitzer@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
---
 drivers/block/nbd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b53fdb0..bd3c50b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -153,6 +153,12 @@ static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
 	struct kvec iov;
 	sigset_t blocked, oldset;
 
+	if (unlikely(!sock)) {
+		printk(KERN_ERR "%s: Attempted %s on closed socket in sock_xmit\n",
+		       lo->disk->disk_name, (send ? "send" : "recv"));
+		return -EINVAL;
+	}
+
 	/* Allow interception of SIGKILL only
 	 * Don't allow other signals to interrupt the transmission */
 	siginitsetinv(&blocked, sigmask(SIGKILL));
-- 
1.5.3.4

