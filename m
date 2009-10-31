Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbZJaQDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbZJaQDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 12:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZJaQDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 12:03:34 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:59280 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZJaQDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 12:03:33 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Sat, 31 Oct 2009 17:03:23 +0100
Message-Id: <1257005003-9889-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] pps: locking scheme fix up for PPS_GETPARAMS.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Tested-by: Reg Clemens <clemens@dwf.com>
---
 drivers/pps/pps.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index fea17e7..ca5183b 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -71,9 +71,14 @@ static long pps_cdev_ioctl(struct file *file,
 	case PPS_GETPARAMS:
 		pr_debug("PPS_GETPARAMS: source %d\n", pps->id);
 
-		/* Return current parameters */
-		err = copy_to_user(uarg, &pps->params,
-						sizeof(struct pps_kparams));
+		spin_lock_irq(&pps->lock);
+
+		/* Get the current parameters */
+		params = pps->params;
+
+		spin_unlock_irq(&pps->lock);
+
+		err = copy_to_user(uarg, &params, sizeof(struct pps_kparams));
 		if (err)
 			return -EFAULT;
 
-- 
1.6.3.3

