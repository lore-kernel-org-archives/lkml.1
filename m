Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXGPTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXGPTmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXGPTmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:42:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:41891 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbXGPTme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:42:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dmPx+NmoXTVU6J2+sgzXnOA/bAUOWsMovs7/vPraeYmU+F1GIZoid8CmE+DoQdjpOzFv1HrsfyEk/JE4wALq0BZ9XH+ra5zZREWXr67i4Mgn2FYWRiue2NXtqPrS6MFp0QN26OBVfj1P81zTWEemXhZ+MaonpV6fDueRX7/rdvA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: dm-devel@redhat.com
Subject: [PATCH] Fix memory leak in dm_create_persistent() when starting metadata update thread fails.
Date: Mon, 16 Jul 2007 21:41:43 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707162141.44229.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If, in dm_create_persistent(), the call to 
create_singlethread_workqueue() fails then we'll return without 
freeing the memory allocated to 'ps', thus leaking 
sizeof(struct pstore) bytes.
This patch fixes the leak.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com
---

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 3d65917..8fe81e1 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -623,6 +623,7 @@ int dm_create_persistent(struct exception_store *store)
 
 	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
 	if (!ps->metadata_wq) {
+		kfree(ps);
 		DMERR("couldn't start header metadata update thread");
 		return -ENOMEM;
 	}


