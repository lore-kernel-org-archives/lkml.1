Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbXIMX2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbXIMX2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbXIMX1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:27:45 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:47092 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756943AbXIMX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:27:44 -0400
Date: Fri, 14 Sep 2007 01:28:56 +0200
From: aherrman@arcor.de
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Commit 02a5e0acb3cb85d80d0fe834e366d38a92bbaa22 might break kernel build
Message-ID: <20070913232856.GE5764@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Due to commit 02a5e0acb3cb85d80d0fe834e366d38a92bbaa22
kernel build is broken if (CONFIG_COMPAT && ! CONFIG_BLOCK):

  CC      fs/compat_ioctl.o
In file included from include/linux/raid/md_k.h:19,
                 from include/linux/raid/md.h:54,
                 from fs/compat_ioctl.c:25:
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:40: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:48: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h:51: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:64: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_merge_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:78: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:90: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h:94: error: dereferencing pointer to incomplete type
make[1]: *** [fs/compat_ioctl.o] Error 1
make: *** [fs] Error 2


So either revert that commit or better apply the attached patch to fix it.


Regards,

Andreas

--
Fix kernel compilation if CONFIG_COMPAT is selected but CONFIG_BLOCK is not.
This is needed due to commit

    02a5e0acb3cb85d80d0fe834e366d38a92bbaa22

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/md/dm-bio-list.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-bio-list.h b/drivers/md/dm-bio-list.h
index 16ee3b0..3f7b827 100644
--- a/drivers/md/dm-bio-list.h
+++ b/drivers/md/dm-bio-list.h
@@ -9,6 +9,8 @@
 
 #include <linux/bio.h>
 
+#ifdef CONFIG_BLOCK
+
 struct bio_list {
 	struct bio *head;
 	struct bio *tail;
@@ -106,4 +108,5 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	return bio;
 }
 
+#endif /* CONFIG_BLOCK */
 #endif
-- 
1.5.3


