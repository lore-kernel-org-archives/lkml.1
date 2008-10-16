Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYJPR0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYJPR0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756380AbYJPROr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:47 -0400
Received: from kroah.org ([198.145.64.141]:46999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756360AbYJPROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/46] device model: Do a quickcheck for driver binding before doing an expensive check
Date: Thu, 16 Oct 2008 10:10:30 -0700
Message-Id: <1224177047-11859-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

This patch adds a quick check for the driver<->device match before
taking the locks and doin gthe expensive checks. Taking the lock hurts
in asynchronous boot context where the device lock gets hit; one of the
init functions takes the lock and goes to do an expensive hardware init;
the other init functions walk the same PCI list and get stuck on the
lock as a result.

For the common case, we can know there's no chance whatsoever of a match
if the device isn't in the drivers ID table... so this patch does that
check as a best-effort-avoid-the-lock approach.

Bootcharts for before and after can be seen at
http://www.fenrus.org/before.svg
http://www.fenrus.org/after.svg

Note the long time "agp_ali_init" takes in the first graph; my laptop
doesn't even have an ALI chip in it!  (the bootgraphs look a bit
dissimilar, but that's the point, the first one has a bunch of arbitrary
delays in it that cause it to look very different)

This reduces my kernel boot time by about 20%

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 3ac443b..20febc0 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -257,6 +257,9 @@ static int __driver_attach(struct device *dev, void *data)
 	 * is an error.
 	 */
 
+	if (drv->bus->match && !drv->bus->match(dev, drv))
+		return 0;
+
 	if (dev->parent)	/* Needed for USB */
 		down(&dev->parent->sem);
 	down(&dev->sem);
-- 
1.6.0.2

