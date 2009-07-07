Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZGGDta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZGGDta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 23:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbZGGDtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 23:49:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53786 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbZGGDtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 23:49:22 -0400
Date: Tue, 7 Jul 2009 13:49:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: linux-next: block tree build failure
Message-Id: <20090707134908.e81b1556.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

fs/sync.c: In function 'sys_sync':
fs/sync.c:121: error: implicit declaration of function 'wakeup_pdflush'

Caused by commit 1728603e84b339be5d5abd392ed3ec5936253863 ("writeback:
switch to per-bdi threads for flushing data") from the block tree
interacting with commit 3beab0b42413e83a7907db7176b54c840fc75a81
("sys_sync(): fix 16% performance regression in ffsb create_4k test")
from Linus' tree.

I added the following patch as part of the block tree merge for today.  I
have no idea if it is correct.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 7 Jul 2009 13:34:26 +1000
Subject: [PATCH] block: pdflush fixup

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 3422ba6..bf03fc7 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -118,7 +118,7 @@ restart:
  */
 SYSCALL_DEFINE0(sync)
 {
-	wakeup_pdflush(0);
+	wakeup_flusher_threads(0);
 	sync_filesystems(0);
 	sync_filesystems(1);
 	if (unlikely(laptop_mode))
-- 
1.6.3.3

