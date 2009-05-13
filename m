Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbZEMIVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbZEMIVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbZEMIVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:21:05 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53835 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbZEMIVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:21:01 -0400
Message-ID: <4A0A82ED.2040906@in.ibm.com>
Date: Wed, 13 May 2009 13:51:01 +0530
From: "B. N. Poornima" <poornima@in.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH]Fix potential Divide by Zero error in ext2_get_inode()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Found a line of code in ext2_get_inode function of inode.c in the ext2 
filesystem that has the potential of hitting the divide by 0 error.
*************************************************
 block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
*************************************************
There is no checking done here to verify if EXT2_INODES_PER_GROUP() 
returns 0. This could result in divide by zero error and panic the system.
Below is the patch, built against 2.6.30-rc5,  to correct the same:

Signed-off-by: B N Poornima <poornima@in.ibm.com>

Index: linux-2.6.30-rc5/fs/ext2/inode.c
===================================================================
--- linux-2.6.30-rc5.orig/fs/ext2/inode.c       2009-05-09 
05:44:14.000000000 +0530
+++ linux-2.6.30-rc5/fs/ext2/inode.c    2009-05-12 19:14:42.873991280 +0530
@@ -1138,6 +1138,7 @@
        unsigned long block_group;
        unsigned long block;
        unsigned long offset;
+       unsigned long inodes_per_group;
        struct ext2_group_desc * gdp;

        *p = NULL;
@@ -1145,7 +1146,10 @@
            ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
                goto Einval;

-       block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
+       inodes_per_group = EXT2_INODES_PER_GROUP(sb);
+       if (!inodes_per_group)
+               goto Einval1;
+       block_group = (ino - 1) / inodes_per_group;
        gdp = ext2_get_group_desc(sb, block_group, NULL);
        if (!gdp)
                goto Egdp;
@@ -1166,6 +1170,11 @@
        ext2_error(sb, "ext2_get_inode", "bad inode number: %lu",
                   (unsigned long) ino);
        return ERR_PTR(-EINVAL);
+
+Einval1:
+       printk(KERN_ERR "Ext2-fs: Filesystem corrupted. Wrong inodes per 
group: %lu, run e2fsck\n", (unsigned long)inodes_per_group);
+       return ERR_PTR(-EINVAL);
+
 Eio:
        ext2_error(sb, "ext2_get_inode",
                   "unable to read inode block - inode=%lu, block=%lu",

                                                           




