Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYINPcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYINPcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYINPcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:32:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:40258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbYINPcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:32:07 -0400
Date: Sun, 14 Sep 2008 08:32:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: greg@kroah.com
Subject: [PATCH] device model: Do a quickcheck for driver binding before
 doing an expensive check
Message-ID: <20080914083206.0f42b2a7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] device model: Do a quickcheck for driver binding before doing an expensive check

This patch adds a quick check for the driver<->device match before taking
the locks and doin gthe expensive checks. Taking the lock hurts in asynchronous
boot context where the device lock gets hit; one of the init functions takes
the lock and goes to do an expensive hardware init; the other init functions
walk the same PCI list and get stuck on the lock as a result.

For the common case, we can know there's no chance whatsoever of a match
if the device isn't in the drivers ID table... so this patch does that check
as a best-effort-avoid-the-lock approach.

Bootcharts for before and after can be seen at
http://www.fenrus.org/before.svg
http://www.fenrus.org/after.svg

Note the long time "agp_ali_init" takes in the first graph; my laptop doesn't
even have an ALI chip in it!
(the bootgraphs look a bit dissimilar, but that's the point, the first one has a bunch
of arbitrary delays in it that cause it to look very different)

This reduces my kernel boot time by about 20%

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
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
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
