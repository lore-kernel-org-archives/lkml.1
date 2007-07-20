Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbXGTAjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbXGTAjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbXGTAi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:38:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758077AbXGTAi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:38:58 -0400
Date: Thu, 19 Jul 2007 17:38:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Remove unneded lock_kernel() in driver/block/loop.c
Message-Id: <20070719173843.b9478df5.akpm@linux-foundation.org>
In-Reply-To: <118394622153-git-send-email-diego@woitasen.com.ar>
References: <118394622153-git-send-email-diego@woitasen.com.ar>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  8 Jul 2007 22:57:01 -0300
Diego Woitasen <diego@woitasen.com.ar> wrote:

> 
> Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
> ---
>  drivers/block/loop.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 0ed5470..1cc004e 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1286,7 +1286,6 @@ static long lo_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
>  	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
>  	int err;
>  
> -	lock_kernel();
>  	switch(cmd) {
>  	case LOOP_SET_STATUS:
>  		mutex_lock(&lo->lo_ctl_mutex);
> @@ -1312,7 +1311,6 @@ static long lo_compat_ioctl(struct file *file, unsigned int cmd, unsigned long a
>  		err = -ENOIOCTLCMD;
>  		break;
>  	}
> -	unlock_kernel();
>  	return err;
>  }
>  #endif

I agree.  And that means that we can move lo_ioctl over to being an
unlocked_ioctl handler.


--- a/drivers/block/loop.c~loop-use-unlocked_ioctl
+++ a/drivers/block/loop.c
@@ -1124,12 +1124,14 @@ loop_get_status64(struct loop_device *lo
 	return err;
 }
 
-static int lo_ioctl(struct inode * inode, struct file * file,
-	unsigned int cmd, unsigned long arg)
+static long lo_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
+	struct inode *inode;
+	struct loop_device *lo;
 	int err;
 
+	inode = file->f_mapping->host;
+	lo = inode->i_bdev->bd_disk->private_data;
 	mutex_lock(&lo->lo_ctl_mutex);
 	switch (cmd) {
 	case LOOP_SET_FD:
@@ -1304,7 +1306,7 @@ static long lo_compat_ioctl(struct file 
 		arg = (unsigned long) compat_ptr(arg);
 	case LOOP_SET_FD:
 	case LOOP_CHANGE_FD:
-		err = lo_ioctl(inode, file, cmd, arg);
+		err = lo_ioctl(file, cmd, arg);
 		break;
 	default:
 		err = -ENOIOCTLCMD;
@@ -1340,7 +1342,7 @@ static struct block_device_operations lo
 	.owner =	THIS_MODULE,
 	.open =		lo_open,
 	.release =	lo_release,
-	.ioctl =	lo_ioctl,
+	.unlocked_ioctl = lo_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl =	lo_compat_ioctl,
 #endif
_

