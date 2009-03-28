Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZC1Rov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZC1Rov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZC1Rol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:44:41 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:36800 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZC1Rol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ekwLGqpb81x29p0/ppZeUO868pLhXsXdAmPAmIuYqRNrW6rm7LGt1xt8/+hYjG6QCo
         sBX4g8Dqz3qX0A3bf3VAN42AxN0IN6RJzHxqDQQ6VnlyH4WDnR79zD0VHcVkhs6wpIpH
         LqPoQ7ZL9rx4EeXTrHwKn0RpdD5ZhnxAzEXcA=
Message-ID: <49CE61F8.5090303@gmail.com>
Date: Sat, 28 Mar 2009 18:44:24 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com,
       Christoph Hellwig <hch@lst.de>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] mtd: fix use after free in register_mtd_blktrans
References: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
In-Reply-To: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
> for when we dereference
> freed memory.
> 
> (...)
> drivers/mtd/mtd_blkdevs.c +389 register_mtd_blktrans(49) '*tr->blkcore_priv'
> (...)

Fix:
---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] mtd: fix use after free in register_mtd_blktrans

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 1409f01..4109e0b 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -382,11 +382,12 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	tr->blkcore_priv->thread = kthread_run(mtd_blktrans_thread, tr,
 			"%sd", tr->name);
 	if (IS_ERR(tr->blkcore_priv->thread)) {
+		int ret = PTR_ERR(tr->blkcore_priv->thread);
 		blk_cleanup_queue(tr->blkcore_priv->rq);
 		unregister_blkdev(tr->major, tr->name);
 		kfree(tr->blkcore_priv);
 		mutex_unlock(&mtd_table_mutex);
-		return PTR_ERR(tr->blkcore_priv->thread);
+		return ret;
 	}
 
 	INIT_LIST_HEAD(&tr->devs);
-- 
1.6.0.6

