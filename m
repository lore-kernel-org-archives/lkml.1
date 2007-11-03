Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbXKCWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbXKCWLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 18:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXKCWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 18:11:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:62669 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbXKCWLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 18:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:sender;
        b=BAg2Em6h5M8v96e7TMBPWWqDjnDQi/99H2Y37oNuCVhUuJld4rQV8O3cbFd2tvTmPPQejP3blvdorFErXxVn6r5fcDdUeA6TJAag/psIYC/V9Q5ZeeD5R/A5Uu9e1X8kImPLZHVGgSx2qZBpthj8rO/P+7ndtXPs3izbPO4k3Uk=
From: Michael Marineau <mike@marineau.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Michael Marineau <mike@marineau.org>
Subject: [PATCH] tmpfs: fix mounts when size is less than the page size
Date: Sat,  3 Nov 2007 15:11:42 -0700
Message-Id: <11941279021705-git-send-email-mike@marineau.org>
X-Mailer: git-send-email 1.5.1.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When tmpfs is mounted with a size less than one page the number of blocks
is set to 0 which makes the tmpfs mount unlimited. This can lead to a quick
and surprising death is someone typos a tmpfs mount command and writes to much.

tmpfs can still be mounted as unlimited if size or nr_blocks is exactly 0.

Signed-off-by: Michael Marineau <mike@marineau.org>
---
 mm/shmem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 253d205..66b07f2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2138,6 +2138,8 @@ static int shmem_parse_options(char *options, int *mode, uid_t *uid,
 			if (*rest)
 				goto bad_val;
 			*blocks = size >> PAGE_CACHE_SHIFT;
+			if (size && blocks == 0)
+				blocks = 1;
 		} else if (!strcmp(this_char,"nr_blocks")) {
 			*blocks = memparse(value,&rest);
 			if (*rest)
-- 
1.5.1.6

