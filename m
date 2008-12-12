Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbYLLFV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbYLLFV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbYLLFV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:21:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:37936 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555AbYLLFV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:21:28 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in ioctl
Date: Fri, 12 Dec 2008 14:16:57 +0900
Message-Id: <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current memory copy function of nilfs2 ioctl has following
problems:

(1) It tries to allocate 128KB size of memory even for small objects.

(2) Though the function repeatedly tries large memory allocations
    while reducing the size, GFP_NOWAIT flag is not specified.
    This increases the possibility of system memory shortage.

(3) During the retries of (2), verbose warnings are printed
    because _GFP_NOWARN flag is not used for the kmalloc calls.

This will fix these problems.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 35ba60e..5ba6e4e 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -51,13 +51,20 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	for (ksize = KMALLOC_SIZE_MAX; ksize >= KMALLOC_SIZE_MIN; ksize /= 2) {
-		buf = kmalloc(ksize, GFP_NOFS);
-		if (buf != NULL)
-			break;
+	ksize = min_t(unsigned long, argv->v_nmembs * argv->v_size,
+		      KMALLOC_SIZE_MAX);
+	while (ksize >= KMALLOC_SIZE_MIN) {
+		buf = kmalloc(ksize, GFP_NOWAIT | __GFP_NOWARN);
+		if (buf)
+			goto allocated;
+		ksize >>= 1;
 	}
-	if (ksize < KMALLOC_SIZE_MIN)
+	ksize = max_t(size_t, ksize, argv->v_size);
+	buf = kmalloc(ksize, GFP_NOFS);
+	if (unlikely(!buf))
 		return -ENOMEM;
+
+ allocated:
 	maxmembs = ksize / argv->v_size;
 
 	ret = 0;
-- 
1.5.6.5

