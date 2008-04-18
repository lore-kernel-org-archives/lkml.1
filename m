Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYDRMNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYDRMNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYDRMNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:13:38 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:43170 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYDRMNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:13:37 -0400
Message-ID: <48089060.70603@tiscali.nl>
Date: Fri, 18 Apr 2008 14:13:20 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: alex@clusterfs.com, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, linux-ext4@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mballoc: fix hot spins after err_freebuddy and	err_freemeta
References: <4807762A.9090202@tiscali.nl> <20080417175843.GA7517@skywalker> <480796FE.2010707@tiscali.nl> <20080418051414.GA10568@skywalker> <20080418052103.GB10568@skywalker>
In-Reply-To: <20080418052103.GB10568@skywalker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh Kumar K.V wrote:
> On Fri, Apr 18, 2008 at 10:44:14AM +0530, Aneesh Kumar K.V wrote:
>> On Thu, Apr 17, 2008 at 08:29:18PM +0200, Roel Kluin wrote:
>>> Aneesh Kumar K.V wrote:
>>>
>>>> The function needs more changes. For ex:
>>>>
>>>> 2279     if (meta_group_info[j] == NULL) {
>>>> 2280               printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
>>>> 2281               i--;
>>>> 2282               goto err_freebuddy;
>>>> 2283     }
>>>>
>>>> That decrement  i--; could result in bad value if i == 0;.

>> Won't this also have a memory corruption ?  Let's say we fail in the first
>> loop itslef. That's with i = 0, and since we are using kmalloc.
>> we may find sbi->s_group_info[0] having some random values. So the
>> kfree can crash. Why not a simple change like below ?
>>
> 
> Updated one.
> 

Won't this work as well?
---
In ext4_mb_init_backend() 'i' is of type ext4_group_t. Since unsigned, i >= 0 is
always true, so fix hot spins after err_freebuddy: and -meta: and prevent
decrements when zero.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ef97f19..054cd33 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2572,13 +2572,13 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
 		if (meta_group_info[j] == NULL) {
 			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
-			i--;
 			goto err_freebuddy;
 		}
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
 			printk(KERN_ERR
 				"EXT4-fs: can't read descriptor %lu\n", i);
+			i++;
 			goto err_freebuddy;
 		}
 		memset(meta_group_info[j], 0, len);
@@ -2618,13 +2618,11 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	return 0;
 
 err_freebuddy:
-	while (i >= 0) {
+	while (i-- > 0)
 		kfree(ext4_get_group_info(sb, i));
-		i--;
-	}
 	i = num_meta_group_infos;
 err_freemeta:
-	while (--i >= 0)
+	while (i-- > 0)
 		kfree(sbi->s_group_info[i]);
 	iput(sbi->s_buddy_cache);
 err_freesgi:
