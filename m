Return-Path: <linux-kernel-owner+w=401wt.eu-S933732AbYDQQJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732AbYDQQJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760472AbYDQQJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:09:29 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:43708 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbYDQQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:09:29 -0400
Message-ID: <4807762A.9090202@tiscali.nl>
Date: Thu, 17 Apr 2008 18:09:14 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: alex@clusterfs.com, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com
CC: linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mballoc: fix hot spins after err_freebuddy and err_freemeta
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4_mb_init_backend() has a variable i of type ext4_group_t. which is typedefined
in include/linux/ext4_fs_i.h:34 to unsigned long. Since unsigned, i >= 0 is always
true, so fix hot spins after err_freebuddy and err_freemeta.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ef97f19..afba9b8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2618,14 +2618,14 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	return 0;
 
 err_freebuddy:
-	while (i >= 0) {
+	do {
 		kfree(ext4_get_group_info(sb, i));
-		i--;
-	}
-	i = num_meta_group_infos;
+	} while (i-- != 0);
+	i = num_meta_group_infos - 1;
 err_freemeta:
-	while (--i >= 0)
+	do {
 		kfree(sbi->s_group_info[i]);
+	} while (i-- != 0);
 	iput(sbi->s_buddy_cache);
 err_freesgi:
 	kfree(sbi->s_group_info);
