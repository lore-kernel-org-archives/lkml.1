Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbYDDNeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYDDNeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYDDNeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:34:05 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:55764 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbYDDNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:34:04 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2008 09:34:04 EDT
From: Dan Noe <dpn@isomerica.net>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Dan Noe <dpn@isomerica.net>
Subject: [PATCH] cxgb3: Fix __must_check warning from call to sysfs_create_group.
Date: Fri,  4 Apr 2008 09:21:53 -0400
Message-Id: <120731531392-git-send-email-dpn@isomerica.net>
X-Mailer: git-send-email 1.5.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the warning:
drivers/net/cxgb3/cxgb3_main.c: In function ‘offload_open’:
drivers/net/cxgb3/cxgb3_main.c:936: warning: ignoring return value of
 ‘sysfs_create_group’, declared with attribute warn_unused_result

Now the return value is checked; if sysfs_create_group() returns failure,
a warning is printed using dev_dbg, and the code continues as before.  Use
of dev_dbg ensures printk is not needlessly included unless desired for
debugging.  The original driver code chose to ignore failure of
sysfs_create_group, and this has not been changed beyond a warning when
DEBUG is enabled.

Signed-off-by: Dan Noe <dpn@isomerica.net>
---
 drivers/net/cxgb3/cxgb3_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Applies against linux-2.6.git.

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index fd2e05b..05e5f59 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -1014,8 +1014,8 @@ static int offload_open(struct net_device *dev)
 		     adapter->port[0]->mtu : 0xffff);
 	init_smt(adapter);
 
-	/* Never mind if the next step fails */
-	sysfs_create_group(&tdev->lldev->dev.kobj, &offload_attr_group);
+	if (sysfs_create_group(&tdev->lldev->dev.kobj, &offload_attr_group))
+		dev_dbg(&dev->dev, "cannot create sysfs group\n");
 
 	/* Call back all registered clients */
 	cxgb3_add_clients(tdev);
-- 
1.5.2.5

