Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZGLWqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZGLWqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZGLWqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:30 -0400
Received: from kroah.org ([198.145.64.141]:33487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZGLWqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/9] devres: WARN() and return, don't crash on device_del() of uninitialized device
Date: Sun, 12 Jul 2009 15:45:58 -0700
Message-Id: <1247438766-17266-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

I just debugged an obscure crash caused by a device_del() of a all NULL'd
out struct device (in usb-serial) and found that a patch like this one would
have saved me time (in addition to improved chances of a bug report from
users hitting similar driver bugs).

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devres.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e8beb8e..05dd307 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -428,6 +428,9 @@ int devres_release_all(struct device *dev)
 {
 	unsigned long flags;
 
+	/* Looks like an uninitialized device structure */
+	if (WARN_ON(dev->devres_head.next == NULL))
+		return -ENODEV;
 	spin_lock_irqsave(&dev->devres_lock, flags);
 	return release_nodes(dev, dev->devres_head.next, &dev->devres_head,
 			     flags);
-- 
1.6.3.2

