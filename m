Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbYEWKYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbYEWKYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYEWKYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:24:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:41707 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbYEWKYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:24:44 -0400
Message-ID: <48369B0D.7050309@s5r6.in-berlin.de>
Date: Fri, 23 May 2008 12:23:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] raw1394: Push the BKL down into the driver ioctls
References: <20080522223351.22e09d20@core>
In-Reply-To: <20080522223351.22e09d20@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Actually in this case wrap the function for now.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Can an .unlocked_ioctl() preempt another .unlocked_ioctl() to the very
same instance of struct file?

If not, we can immediately remove lock_kernel() from raw1394.

If yes, we need to serialize do_raw1394_ioctl against itself or come up
with another protection against concurrent fi->iso_state switches before
we can remove lock_kernel().  And if a .write() can preempt another
.write() to the same instance of struct file, raw1394_write() already
has a problem with concurrent fi->state switches.

I have another minor comment below:

> diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
> index ec2a0ad..8ec0278 100644
> --- a/drivers/ieee1394/raw1394.c
> +++ b/drivers/ieee1394/raw1394.c
> @@ -2549,8 +2549,8 @@ static int raw1394_mmap(struct file *file, struct vm_area_struct *vma)
>  }
>  
>  /* ioctl is only used for rawiso operations */
> -static int raw1394_ioctl(struct inode *inode, struct file *file,
> -			 unsigned int cmd, unsigned long arg)
> +static long do_raw1394_ioctl(struct file *file, unsigned int cmd,
> +							unsigned long arg)
>  {
>  	struct file_info *fi = file->private_data;
>  	void __user *argp = (void __user *)arg;
> @@ -2656,6 +2656,16 @@ static int raw1394_ioctl(struct inode *inode, struct file *file,
>  	return -EINVAL;
>  }
>  
> +static long raw1394_ioctl(struct file *file, unsigned int cmd,
> +							unsigned long arg)
> +{
> +	long ret;
> +	lock_kernel();
> +	ret = do_raw1394_ioctl(file, cmd, arg);
> +	unlock_kernel();
> +	return ret;
> +}
> +
>  #ifdef CONFIG_COMPAT
>  struct raw1394_iso_packets32 {
>          __u32 n_packets;
> @@ -2690,7 +2700,7 @@ static long raw1394_iso_xmit_recv_packets32(struct file *file, unsigned int cmd,
>  	    !copy_from_user(&infos32, &arg->infos, sizeof infos32)) {
>  		infos = compat_ptr(infos32);
>  		if (!copy_to_user(&dst->infos, &infos, sizeof infos))
> -			err = raw1394_ioctl(NULL, file, cmd, (unsigned long)dst);
> +			err = do_raw1394_ioctl(file, cmd, (unsigned long)dst);
>  	}
>  	return err;
>  }

The same s/raw1394_ioctl/do_raw1394_ioctl/ should be done in
raw1394_compat_ioctl().  But I suppose it doesn't really matter because
lock_kernel() is allowed to nest.

> @@ -2984,7 +2994,7 @@ static const struct file_operations raw1394_fops = {
>  	.read = raw1394_read,
>  	.write = raw1394_write,
>  	.mmap = raw1394_mmap,
> -	.ioctl = raw1394_ioctl,
> +	.unlocked_ioctl = raw1394_ioctl,
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl = raw1394_compat_ioctl,
>  #endif

-- 
Stefan Richter
-=====-==--- -=-= =-===
http://arcgraph.de/sr/
