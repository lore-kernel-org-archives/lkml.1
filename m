Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZGKKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZGKKoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZGKKoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 06:44:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24932 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZGKKoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 06:44:04 -0400
Date: Sat, 11 Jul 2009 12:43:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: -tip: block, fuse: Fix build error in fs/fuse/dev.c
Message-ID: <20090711124326.792f3177@hyperion.delvare>
In-Reply-To: <20090711075201.GA6517@elte.hu>
References: <20090711075201.GA6517@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Sat, 11 Jul 2009 09:52:01 +0200, Ingo Molnar wrote:
> Today's upstream tree build (x86, 64-bit, allnoconfig+CONFIG_FUSE) 
> failed with this build error:
> 
>   fs/fuse/dev.c: In function ‘request_end’:
>   fs/fuse/dev.c:290: error: ‘BLK_RW_SYNC’ undeclared (first use in this function)
>   fs/fuse/dev.c:290: error: (Each undeclared identifier is reported only once
>   fs/fuse/dev.c:290: error: for each function it appears in.)
>   fs/fuse/dev.c:291: error: ‘BLK_RW_ASYNC’ undeclared (first use in this function)
> 
> Due to commit:
> 
>   8aa7e84: Fix congestion_wait() sync/async vs read/write confusion
> 
> Creating a dependency of BDI callbacks on the BLK_RW_* constants,
> while those constants are only defined if CONFIG_BLOCK is enabled.
> 
> Fix it the simplest way for now, by moving the definitions early
> in blkdev.h (this cannot break anything), but the real fix would
> be to split up blkdev.h into blkdev-types.h and blkdev-api.h and
> make only the API definitions/declarations dependent on
> CONFIG_BLOCK.
> 
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Miklos Szeredi <mszeredi@suse.cz>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/blkdev.h |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 49ae079..a3cdc6d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1,6 +1,14 @@
>  #ifndef _LINUX_BLKDEV_H
>  #define _LINUX_BLKDEV_H
>  
> +/*
> + * Definitions used on the !CONFIG_BLOCK case too:
> + */
> +enum {
> +	BLK_RW_ASYNC	= 0,
> +	BLK_RW_SYNC	= 1,
> +};
> +
>  #ifdef CONFIG_BLOCK
>  
>  #include <linux/sched.h>
> @@ -70,11 +78,6 @@ enum rq_cmd_type_bits {
>  	REQ_TYPE_ATA_PC,
>  };
>  
> -enum {
> -	BLK_RW_ASYNC	= 0,
> -	BLK_RW_SYNC	= 1,
> -};
> -
>  /*
>   * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
>   * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a

I have hit this build issue as well, but with CONFIG_BLOCK=y, so the
patch above does NOT fix it. The problem I see is that fs/fuse/dev.c
does not include <linux/blkdev.h> so it doesn't get the definitions
regardless of the configuration. Same problem in fs/nfs/write.c. The
patch below fixes it for me:

* * * * *

From: Jean Delvare <khali@linux-fr.org>
Subject: Fix BLK_RW_* build failures

Fix build failures caused by using BLK_RW_* constants without
including <linux/blkdev.h>.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
---
I have included pktcdvd and memcontrol in the patch, they don't build
for my config so I didn't see them fail, but I suspect they would, so
fix them too.

 drivers/block/pktcdvd.c |    1 +
 fs/fuse/dev.c           |    1 +
 fs/nfs/write.c          |    1 +
 mm/memcontrol.c         |    1 +
 4 files changed, 4 insertions(+)

--- linux-2.6.31-rc2.orig/drivers/block/pktcdvd.c	2009-07-11 12:32:46.000000000 +0200
+++ linux-2.6.31-rc2/drivers/block/pktcdvd.c	2009-07-11 12:33:02.000000000 +0200
@@ -62,6 +62,7 @@
 #include <scsi/scsi.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/blkdev.h>
 
 #include <asm/uaccess.h>
 
--- linux-2.6.31-rc2.orig/fs/fuse/dev.c	2009-07-11 12:32:46.000000000 +0200
+++ linux-2.6.31-rc2/fs/fuse/dev.c	2009-07-11 12:33:02.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/slab.h>
+#include <linux/blkdev.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 
--- linux-2.6.31-rc2.orig/fs/nfs/write.c	2009-07-11 12:32:46.000000000 +0200
+++ linux-2.6.31-rc2/fs/nfs/write.c	2009-07-11 12:33:02.000000000 +0200
@@ -19,6 +19,7 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs_page.h>
 #include <linux/backing-dev.h>
+#include <linux/blkdev.h>
 
 #include <asm/uaccess.h>
 
--- linux-2.6.31-rc2.orig/mm/memcontrol.c	2009-07-11 12:32:46.000000000 +0200
+++ linux-2.6.31-rc2/mm/memcontrol.c	2009-07-11 12:33:02.000000000 +0200
@@ -37,6 +37,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
+#include <linux/blkdev.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>


-- 
Jean Delvare
