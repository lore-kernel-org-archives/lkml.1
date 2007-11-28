Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbXK1N44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbXK1N44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbXK1N4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:56:48 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:9223 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXK1N4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=bzm6+OQekyK7YzkIOdKPKx12Xbrmcv5xKvyYPXvxBuErOw80ZzqYiXlqtX3YDTsW3IISOivTuqxfa7N4jcQczyCj1IC71ce6iPdXTU+frU6HLaHoRV8Ammfvb8nCBBb9Wpxb1ZZQP1e/oWobqvffew7DLYgZJceJczentistvbc=
Date: Wed, 28 Nov 2007 08:56:15 -0500
From: "Liam R. Howlett" <howlett@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: willy@linux.intel.com, akpm@linux-foundation.org, mingo@redhat.com
Subject: [Patch 2/2] Kernel: mutex_lock_killable
Message-ID: <20071128135615.GB14479@solidsnake>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex_lock_killable in vfs_readdir
Signed-off-by: Liam R. Howlett <howlett@gmail.com>
Acked-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/readdir.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index efe52e6..4aee2c9 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -30,7 +30,10 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 	if (res)
 		goto out;
 
-	mutex_lock(&inode->i_mutex);
+	res = -EINTR;
+	if (mutex_lock_killable(&inode->i_mutex))
+		goto out;
+
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
 		res = file->f_op->readdir(file, buf, filler);
-- 
1.5.2.5

