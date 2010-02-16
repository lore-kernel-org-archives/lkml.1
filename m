Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab0BPWpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:45:22 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60201 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab0BPWpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:45:14 -0500
From: Serge Hallyn <serue@us.ibm.com>
To: serue@us.ibm.com
Cc: Greg KH <greg@kroah.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>
Subject: [PATCH 8/8] p9auth: don't trim entries on write-only open
Date: Tue, 16 Feb 2010 16:45:01 -0600
Message-Id: <1266360301-30081-8-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

If we want to support an admin clearing all entries, let's
not do it through some subtle hidden channel, but rather
implement a 'CLEAR' command to /dev/caphash, which requires
privilege to use.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
cc: rsc@swtch.com
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: ericvh@gmail.com
Cc: devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org
Cc: Ron Minnich <rminnich@gmail.com>
---
 drivers/staging/p9auth/p9auth.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index 6012bd9..06128c3 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -146,13 +146,6 @@ static int cap_open(struct inode *inode, struct file *filp)
 	dev = container_of(inode->i_cdev, struct cap_dev, cdev);
 	filp->private_data = dev;
 
-	/* trim to 0 the length of the device if open was write-only */
-	if ((filp->f_flags & O_ACCMODE) == O_WRONLY) {
-		if (down_interruptible(&dev->sem))
-			return -ERESTARTSYS;
-		cap_trim(dev);
-		up(&dev->sem);
-	}
 	/* initialise the head if it is NULL */
 	if (dev->head == NULL) {
 		dev->head = kmalloc(sizeof(struct cap_node), GFP_KERNEL);
-- 
1.6.1

