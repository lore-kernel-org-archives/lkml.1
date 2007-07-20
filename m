Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXGTWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXGTWA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760551AbXGTV7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:59:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:56595 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761083AbXGTV7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BeJ7xCqmVG+5Nh+yMSChh9g6RJvDXdYATIePGasydSm5P89eGkd0G0indLvWj67MQ6XNx1QLteE2yxMc8dcb1Q2PXFXs5nvNbE9MIifzmzqPKhAZQNjiDRbIQCEyhBVyQIFw07F6GBp+Cag1rmRj5K0SuNMx/+wRc1G9Wbhxr40=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Mike Miller <mike.miller@hp.com>
Subject: [PATCH][cciss] Fix a small memory leak in the cciss driver
Date: Fri, 20 Jul 2007 23:58:37 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       iss_storagedev@hp.com, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202358.37140.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There's a memory leak in the cciss driver.

in alloc_cciss_hba() we may leak sizeof(ctlr_info_t) bytes if a 
call to alloc_disk(1 << NWD_SHIFT) fails.
This patch should fix the issue.

 Spotted by the Coverity checker.
 Compile tested only.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/block/cciss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a2d6612..ef7ba22 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3227,12 +3227,15 @@ static int alloc_cciss_hba(void)
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
 			ctlr_info_t *p;
+
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
 			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
-			if (!p->gendisk[0])
+			if (!p->gendisk[0]) {
+				kfree(p);
 				goto Enomem;
+			}
 			hba[i] = p;
 			return i;
 		}


