Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYDXEeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYDXEeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYDXEeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:34:04 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:45953 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYDXEeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:34:03 -0400
Date: Thu, 24 Apr 2008 14:34:01 +1000
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Silence 'ignoring return value' warnings in drivers/video/aty/radeon_base.c
Message-ID: <20080424043400.GS20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernel builds warn about:
drivers/video/aty/radeon_base.c: In function 'radeonfb_pci_register':
drivers/video/aty/radeon_base.c:2334: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result
drivers/video/aty/radeon_base.c:2336: warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result

Do minimal checking of these functions and issue a warning if either
fails.  They don't seem to be critical..

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 drivers/video/aty/radeon_base.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 62867cb..a99f8b6 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -2158,6 +2158,7 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	struct fb_info *info;
 	struct radeonfb_info *rinfo;
 	int ret;
+	int err = 0;
 
 	RTRACE("radeonfb_pci_register BEGIN\n");
 	
@@ -2331,9 +2332,12 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 
 	/* Register some sysfs stuff (should be done better) */
 	if (rinfo->mon1_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
 	if (rinfo->mon2_EDID)
-		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+		err |= sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+	if (err)
+		pr_warning("%s() Creating sysfs files failed, continuing\n",
+		           __func__);
 
 	/* save current mode regs before we switch into the new one
 	 * so we can restore this upon __exit
-- 
1.5.5.1


Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

