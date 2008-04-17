Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbYDQS3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbYDQS3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbYDQS3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:29:43 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:51540 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053AbYDQS3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:29:42 -0400
Message-ID: <480796FE.2010707@tiscali.nl>
Date: Thu, 17 Apr 2008 20:29:18 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: alex@clusterfs.com, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] mballoc: fix hot spins after err_freebuddy and err_freemeta
References: <4807762A.9090202@tiscali.nl> <20080417175843.GA7517@skywalker>
In-Reply-To: <20080417175843.GA7517@skywalker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh Kumar K.V wrote:

> The function needs more changes. For ex:
> 
> 2279     if (meta_group_info[j] == NULL) {
> 2280               printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
> 2281               i--;
> 2282               goto err_freebuddy;
> 2283     }
> 
> That decrement  i--; could result in bad value if i == 0;.

Thanks Aneesh,
---
Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
ext4_mb_init_backend() has a variable i of type ext4_group_t. which is typedefined
in include/linux/ext4_fs_i.h:34 to unsigned long. Since unsigned, i >= 0 is always
true, so fix hot spins after err_freebuddy and err_freemeta.
Also when meta_group_info cannot be allocated prevent a decrement of i when zero.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ef97f19..2c13dca 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2572,8 +2572,13 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
 		if (meta_group_info[j] == NULL) {
 			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
-			i--;
-			goto err_freebuddy;
+			if (i != 0) {
+				i--;
+				goto err_freebuddy;
+			} else {
+				i = num_meta_group_infos - 1;
+				goto err_freemeta;
+			}
 		}
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
@@ -2618,14 +2623,14 @@ static int ext4_mb_init_backend(struct super_block *sb)
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

