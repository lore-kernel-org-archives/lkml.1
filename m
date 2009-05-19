Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZESJdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZESJdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZESJdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:33:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:33460 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZESJdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:33:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-ide@vger.kernel.org, jens.axboe@oracle.com, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       bzolnier@gmail.com, petkovbb@googlemail.com, zaitcev@redhat.com,
       sshtylyov@ru.mvista.com, Eric.Moore@lsi.com, djwong@us.ibm.com
Cc: Tejun Heo <tj@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/3] bio: always copy back data for copied kernel requests
Date: Tue, 19 May 2009 18:33:06 +0900
Message-Id: <1242725586-13142-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1242725586-13142-1-git-send-email-tj@kernel.org>
References: <1242725586-13142-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 19 May 2009 09:33:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a read bio_copy_kern() request fails, the content of the bounce
buffer is not copied back.  However, as request failure doesn't
necessarily mean complete failure, the buffer state can be useful.
This behavior is also inconsistent with the user map counterpart and
causes the subtle difference between bounced and unbounced IO causes
confusion.

This patch makes bio_copy_kern_endio() ignore @err and always copy
back data on request completion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 fs/bio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 7bbc98f..ee3bc67 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1198,7 +1198,7 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 		char *addr = page_address(bvec->bv_page);
 		int len = bmd->iovecs[i].bv_len;
 
-		if (read && !err)
+		if (read)
 			memcpy(p, addr, len);
 
 		__free_page(bvec->bv_page);
-- 
1.6.0.2

