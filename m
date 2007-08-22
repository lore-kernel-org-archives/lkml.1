Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbXHVJNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbXHVJNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759197AbXHVIyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:54:06 -0400
Received: from 1wt.eu ([62.212.114.60]:2182 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759173AbXHVIyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:54:05 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084042.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:37 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Joe Jin <joe.jin@oracle.com>,
       Zach Brown <zach.brown@oracle.com>,
       gurudas pai <gurudas.pai@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 53/58] direct-io: fix error-path crashes
Content-Disposition: inline; filename=0053-direct-io-fix-error-path-crashes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Need to initialize map_bh.b_state to zero.  Otherwise, in case of a faulty
user-buffer its possible to go into dio_zero_block() and submit a page by
mistake - since it checks for buffer_new().

http://marc.info/?l=linux-kernel&m=118551339032528&w=2

akpm: Linus had a (better) patch to just do a kzalloc() in there, but it got
lost.  Probably this version is better for -stable anwyay.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Joe Jin <joe.jin@oracle.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Cc: gurudas pai <gurudas.pai@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/direct-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index d9d0833..0286993 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -978,6 +978,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	dio->get_block = get_block;
 	dio->end_io = end_io;
 	dio->map_bh.b_private = NULL;
+	dio->map_bh.b_state = 0;
 	dio->final_block_in_bio = -1;
 	dio->next_block_for_io = -1;
 
-- 
1.5.2.5

-- 
