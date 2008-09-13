Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbYIMKCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbYIMKCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYIMKCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:02:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:47031 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbYIMKCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DDRzHQxnmiM/6CD0MW83a+nI/16kGoPmAbNQO1o/Br2oBi+yX2ueV6fHypjpjvlnOw
         ZDLhpIpVVrZXdrtVKe3T8UcxgrkOMxzT7SotfNKpi/9k6dIowsvJPSpZSpz6Q0OIw+1R
         JdAbZ1n+n841zSkXjp3EZDH7M2LQyRWqYM9xs=
Date: Sat, 13 Sep 2008 19:02:07 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [PATCH] mmc_block: handle error from mmc_register_driver()
Message-ID: <20080913100206.GA3746@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check error from mmc_register_driver() and properly unwind
block device registration.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
---
 drivers/mmc/card/block.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: 2.6-git/drivers/mmc/card/block.c
===================================================================
--- 2.6-git.orig/drivers/mmc/card/block.c
+++ 2.6-git/drivers/mmc/card/block.c
@@ -615,14 +615,19 @@ static struct mmc_driver mmc_driver = {
 
 static int __init mmc_blk_init(void)
 {
-	int res = -ENOMEM;
+	int res;
 
 	res = register_blkdev(MMC_BLOCK_MAJOR, "mmc");
 	if (res)
 		goto out;
 
-	return mmc_register_driver(&mmc_driver);
+	res = mmc_register_driver(&mmc_driver);
+	if (res)
+		goto out2;
 
+	return 0;
+ out2:
+	unregister_blkdev(MMC_BLOCK_MAJOR, "mmc");
  out:
 	return res;
 }
