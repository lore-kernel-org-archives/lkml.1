Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYBYNhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYBYNhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 08:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYBYNhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 08:37:00 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:35732 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbYBYNg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 08:36:59 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] Misc, phantom, fix poll
Date: Mon, 25 Feb 2008 14:36:17 +0100
Message-Id: <1203946577-13984-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1203946577-13984-1-git-send-email-jirislaby@gmail.com>
References: <1203946577-13984-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return ERR even if there are pending data, but hw is not running. Do not
decrement count in poll, do it in ioctl, where data are actually read.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/misc/phantom.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 5447a60..71d1c84 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -169,6 +169,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		for (i = 0; i < m; i++)
 			if (rs.mask & BIT(i))
 				rs.values[i] = ioread32(dev->iaddr + i);
+		atomic_set(&dev->counter, 0);
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
 
 		if (copy_to_user(argp, &rs, sizeof(rs)))
@@ -254,11 +255,12 @@ static unsigned int phantom_poll(struct file *file, poll_table *wait)
 
 	pr_debug("phantom_poll: %d\n", atomic_read(&dev->counter));
 	poll_wait(file, &dev->wait, wait);
-	if (atomic_read(&dev->counter)) {
+
+	if (!(dev->status & PHB_RUNNING))
+		mask = POLLERR;
+	else if (atomic_read(&dev->counter))
 		mask = POLLIN | POLLRDNORM;
-		atomic_dec(&dev->counter);
-	} else if ((dev->status & PHB_RUNNING) == 0)
-		mask = POLLIN | POLLRDNORM | POLLERR;
+
 	pr_debug("phantom_poll end: %x/%d\n", mask, atomic_read(&dev->counter));
 
 	return mask;
-- 
1.5.4.1

