Return-Path: <linux-kernel-owner+w=401wt.eu-S969960AbXFIAER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969960AbXFIAER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968182AbXFIAEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:47916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756558AbXFIAED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Pete Zaitcev <zaitcev@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/9] usblp: Don't let suspend to kill ->used
Date: Fri,  8 Jun 2007 17:03:47 -0700
Message-Id: <1181347441440-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813474343815-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pete Zaitcev <zaitcev@redhat.com>

Suspend destroys refcounting for open/release.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/class/usblp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 7b1edfe..6778f9a 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -347,10 +347,8 @@ static int handle_bidir (struct usblp *usblp)
 	if (usblp->bidir && usblp->used && !usblp->sleeping) {
 		usblp->readcount = 0;
 		usblp->readurb->dev = usblp->dev;
-		if (usb_submit_urb(usblp->readurb, GFP_KERNEL) < 0) {
-			usblp->used = 0;
+		if (usb_submit_urb(usblp->readurb, GFP_KERNEL) < 0)
 			return -EIO;
-		}
 	}
 
 	return 0;
@@ -412,6 +410,7 @@ static int usblp_open(struct inode *inode, struct file *file)
 	usblp->readurb->status = 0;
 
 	if (handle_bidir(usblp) < 0) {
+		usblp->used = 0;
 		file->private_data = NULL;
 		retval = -EIO;
 	}
-- 
1.5.2.1

