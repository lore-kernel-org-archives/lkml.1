Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZAFSZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZAFSZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZAFSZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:25:43 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37828 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbZAFSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:25:42 -0500
Subject: Minor kmemleak report via bdev_cache_init
From: Catalin Marinas <catalin.marinas@arm.com>
To: Denis ChengRq <crquan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 06 Jan 2009 18:25:34 +0000
Message-Id: <1231266334.21895.25.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2009 18:25:34.0980 (UTC) FILETIME=[2A72AC40:01C9702C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

With the commit c2acf7b908217 (fs/block_dev.c: __read_mostly improvement
and sb_is_blkdev_sb utilization), the bd_mnt is only local and kmemleak
reports the corresponding vfsmnt structure as unreferenced (together
with the duplicated name) since it can no longer track a valid pointer
to it:

unreferenced object 0xdf813848 (size 128):                                      
  comm "swapper", pid 0, jiffies 4294937384                                     
  backtrace:                                                                    
    [<c00872c0>] kmemleak_alloc+0x144/0x27c                                     
    [<c00848c8>] kmem_cache_alloc+0x108/0x13c                                   
    [<c009fc00>] alloc_vfsmnt+0x20/0x144                                        
    [<c008bc34>] vfs_kern_mount+0x30/0xac                                       
    [<c008bccc>] kern_mount_data+0x1c/0x20                                      
    [<c00104a8>] bdev_cache_init+0x54/0x90                                      
    [<c000fd7c>] vfs_caches_init+0xfc/0x128                                     
    [<c0008984>] start_kernel+0x1f8/0x254                                       
unreferenced object 0xdf8033d0 (size 32):                                       
  comm "swapper", pid 0, jiffies 4294937384                                     
  backtrace:                                                                    
    [<c00872c0>] kmemleak_alloc+0x144/0x27c                                     
    [<c0085e10>] __kmalloc_track_caller+0x15c/0x194                             
    [<c0071704>] kstrdup+0x3c/0x58                                              
    [<c009fc5c>] alloc_vfsmnt+0x7c/0x144                                        
    [<c008bc34>] vfs_kern_mount+0x30/0xac                                       
    [<c008bccc>] kern_mount_data+0x1c/0x20                                      
    [<c00104a8>] bdev_cache_init+0x54/0x90                                      
    [<c000fd7c>] vfs_caches_init+0xfc/0x128                                     
    [<c0008984>] start_kernel+0x1f8/0x254                                       

Can this object be freed (as below) or should I just tell kmemleak to
ignore it (or is it referenced and that's a kmemleak false positive)?


diff --git a/fs/block_dev.c b/fs/block_dev.c
index 349a26c..78e469c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -344,6 +344,7 @@ void __init bdev_cache_init(void)
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
 	blockdev_superblock = bd_mnt->mnt_sb;   /* For writeback */
+	free_vfsmnt(bd_mnt);
 }
 
 /*


Thanks.

-- 
Catalin

