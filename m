Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbYEWBJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbYEWBJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758109AbYEWBJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:09:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934AbYEWBJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:09:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] snapshot: Push BKL down into ioctl handlers
Date: Fri, 23 May 2008 03:09:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
References: <20080522222500.0f5873ff@core>
In-Reply-To: <20080522222500.0f5873ff@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805230309.53136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of May 2008, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index f5512cb..658262b 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -23,6 +23,7 @@
>  #include <linux/console.h>
>  #include <linux/cpu.h>
>  #include <linux/freezer.h>
> +#include <linux/smp_lock.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -164,8 +165,8 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
>  	return res;
>  }
>  
> -static int snapshot_ioctl(struct inode *inode, struct file *filp,
> -                          unsigned int cmd, unsigned long arg)
> +static long snapshot_ioctl(struct file *filp, unsigned int cmd,
> +							unsigned long arg)
>  {
>  	int error = 0;
>  	struct snapshot_data *data;
> @@ -181,6 +182,8 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
>  
>  	data = filp->private_data;
>  
> +	lock_kernel();
> +

Hm, well, I admit I'm a bit ignorant as far as the chardev locking is
concerned, but can you please tell me why would that be wrong if we didn't call
lock_kernel() here at all?

>  	switch (cmd) {
>  
>  	case SNAPSHOT_FREEZE:
> @@ -389,7 +392,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
>  		error = -ENOTTY;
>  
>  	}
> -
> +	unlock_kernel();
>  	return error;
>  }
>  
> @@ -399,7 +402,7 @@ static const struct file_operations snapshot_fops = {
>  	.read = snapshot_read,
>  	.write = snapshot_write,
>  	.llseek = no_llseek,
> -	.ioctl = snapshot_ioctl,
> +	.unlocked_ioctl = snapshot_ioctl,
>  };
>  
>  static struct miscdevice snapshot_device = {

Thanks,
Rafael
