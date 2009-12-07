Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZLGAND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZLGAND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZLGAM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:59 -0500
Received: from kroah.org ([198.145.64.141]:34301 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758375AbZLGAMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:45 2009
Message-Id: <20091207000645.465147414@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rodolfo Giometti <giometti@linux.it>
Subject: [032/119] pps: locking scheme fix up for PPS_GETPARAMS
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=pps-locking-scheme-fix-up-for-pps_getparams.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rodolfo Giometti <giometti@linux.it>

commit cbf83cc5a29dba480cf1ba1c5e3417a0d4a31410 upstream.

Userland programs may read/write PPS parameters at same time and these
operations may corrupt PPS data.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Tested-by: Reg Clemens <clemens@dwf.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pps/pps.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -71,9 +71,14 @@ static long pps_cdev_ioctl(struct file *
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
 


