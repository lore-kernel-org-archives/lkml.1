Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZCDN3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZCDN3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbZCDN3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:29:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:43818 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZCDN3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:29:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ZL+tNy6JxjIfMXpY7amT/qg2/urWUkqWEARPgw/gUEEk+nYpIxE3u7hnJqJ6WpaqF+
         6iF8sSLikV1Ss5JpAUWvwD5Ssbwt7jTc87jC4aKSbMismR7Fc44ZuFn8wx3jXkgOrw0s
         IFiE6DodOPHJw2WiIT47owA/db+CN1MiYTZTs=
Message-ID: <49AE8227.9050703@gmail.com>
Date: Wed, 04 Mar 2009 14:29:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] loop: don't increment p->offset with (size_t) -EINVAL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upon a 'transfer error block' size is set to -EINVAL, but this becomes positive
since size is unsigned: p->offset still gets incremented.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index edbaac6..bf03455 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -392,8 +392,7 @@ lo_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct loop_device *lo = p->lo;
 	struct page *page = buf->page;
 	sector_t IV;
-	size_t size;
-	int ret;
+	int size, ret;
 
 	ret = buf->ops->confirm(pipe, buf);
 	if (unlikely(ret))
