Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZALXzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZALXzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZALXzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:55:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731AbZALXzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:55:06 -0500
Date: Mon, 12 Jan 2009 15:54:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: crquan@gmail.com, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Minor kmemleak report via bdev_cache_init
Message-Id: <20090112155458.d254ac5a.akpm@linux-foundation.org>
In-Reply-To: <1231266334.21895.25.camel@pc1117.cambridge.arm.com>
References: <1231266334.21895.25.camel@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 18:25:34 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> Hi Denis,
> 
> With the commit c2acf7b908217 (fs/block_dev.c: __read_mostly improvement
> and sb_is_blkdev_sb utilization), the bd_mnt is only local and kmemleak
> reports the corresponding vfsmnt structure as unreferenced (together
> with the duplicated name) since it can no longer track a valid pointer
> to it:
> 
> unreferenced object 0xdf813848 (size 128):                                      
>   comm "swapper", pid 0, jiffies 4294937384                                     
>   backtrace:                                                                    
>     [<c00872c0>] kmemleak_alloc+0x144/0x27c                                     
>     [<c00848c8>] kmem_cache_alloc+0x108/0x13c                                   
>     [<c009fc00>] alloc_vfsmnt+0x20/0x144                                        
>     [<c008bc34>] vfs_kern_mount+0x30/0xac                                       
>     [<c008bccc>] kern_mount_data+0x1c/0x20                                      
>     [<c00104a8>] bdev_cache_init+0x54/0x90                                      
>     [<c000fd7c>] vfs_caches_init+0xfc/0x128                                     
>     [<c0008984>] start_kernel+0x1f8/0x254                                       
> unreferenced object 0xdf8033d0 (size 32):                                       
>   comm "swapper", pid 0, jiffies 4294937384                                     
>   backtrace:                                                                    
>     [<c00872c0>] kmemleak_alloc+0x144/0x27c                                     
>     [<c0085e10>] __kmalloc_track_caller+0x15c/0x194                             
>     [<c0071704>] kstrdup+0x3c/0x58                                              
>     [<c009fc5c>] alloc_vfsmnt+0x7c/0x144                                        
>     [<c008bc34>] vfs_kern_mount+0x30/0xac                                       
>     [<c008bccc>] kern_mount_data+0x1c/0x20                                      
>     [<c00104a8>] bdev_cache_init+0x54/0x90                                      
>     [<c000fd7c>] vfs_caches_init+0xfc/0x128                                     
>     [<c0008984>] start_kernel+0x1f8/0x254                                       
> 
> Can this object be freed (as below) or should I just tell kmemleak to
> ignore it (or is it referenced and that's a kmemleak false positive)?
> 
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 349a26c..78e469c 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -344,6 +344,7 @@ void __init bdev_cache_init(void)
>  	if (IS_ERR(bd_mnt))
>  		panic("Cannot create bdev pseudo-fs");
>  	blockdev_superblock = bd_mnt->mnt_sb;   /* For writeback */
> +	free_vfsmnt(bd_mnt);
>  }
>  

hm, yes, well, we might be able to get away with that - the kernel
holds onto bd_mnt->mnt_sb for internal use for all time, but we don't
directly use that vfsmount for anything after we've constructed
blockdev_superblock.

However there might well be things under blockdev_superblock which point
back at this vfsmount - dunno, I didn't check.


