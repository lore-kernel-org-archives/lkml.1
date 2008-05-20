Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbYETWgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbYETWgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934420AbYETWfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:35:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:39660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934411AbYETWfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:35:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Arthur Jones <ajones@riverbed.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 02/13] mm: bdi: fix race in bdi_class device creation
Date: Tue, 20 May 2008 15:34:49 -0700
Message-Id: <1211322900-12705-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_vargs().

Many thanks to Arthur Jones <ajones@riverbed.com> for reporting the bug,
and testing patches out.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arthur Jones <ajones@riverbed.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/backing-dev.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7c4f9e0..f2e574d 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -172,30 +172,22 @@ postcore_initcall(bdi_class_init);
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...)
 {
-	char *name;
 	va_list args;
 	int ret = 0;
 	struct device *dev;
 
 	va_start(args, fmt);
-	name = kvasprintf(GFP_KERNEL, fmt, args);
+	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);
-
-	if (!name)
-		return -ENOMEM;
-
-	dev = device_create(bdi_class, parent, MKDEV(0, 0), name);
 	if (IS_ERR(dev)) {
 		ret = PTR_ERR(dev);
 		goto exit;
 	}
 
 	bdi->dev = dev;
-	dev_set_drvdata(bdi->dev, bdi);
-	bdi_debug_register(bdi, name);
+	bdi_debug_register(bdi, dev_name(dev));
 
 exit:
-	kfree(name);
 	return ret;
 }
 EXPORT_SYMBOL(bdi_register);
-- 
1.5.5.1

