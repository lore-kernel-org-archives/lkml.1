Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYKLPth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYKLPth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYKLPt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:49:29 -0500
Received: from www.tglx.de ([62.245.132.106]:39795 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYKLPt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:49:28 -0500
Date: Wed, 12 Nov 2008 16:49:20 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Neil Armstrong <narmstrong@neotion.com>
Cc: hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio: add ioctl callback
Message-ID: <20081112154919.GC2891@local>
References: <491AF8D1.4060106@neotion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491AF8D1.4060106@neotion.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 04:40:01PM +0100, Neil Armstrong wrote:
> Add an ioctl callback for uio devices.

Hi Neil,
sorry, but we don't want to have ioctl() for UIO. UIO devices should be
completely controllable through their mapped memory. Additional
functions can be added by creating custom sysfs files. To switch the
interrupt on and off, we have the irqcontrol hook in the write()
function. I cannot imagine a case where ioctl() could be useful.

You didn't mention why you want ioctl(). If you tell us the problem, we
can probably find a solution that uses the standard UIO interface.

Thanks,
Hans

> 
> Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
> ---
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 2d2440c..38044fb 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -385,6 +385,18 @@ static unsigned int uio_poll(struct file *filep,
> poll_table *wait)
>      return 0;
>  }
>  
> +static int uio_ioctl(struct inode *inode, struct file *filep,
> +            unsigned int cmd, unsigned long arg)
> +{
> +    struct uio_listener *listener = filep->private_data;
> +    struct uio_device *idev = listener->dev;
> +
> +    if (idev->info->ioctl)
> +        return idev->info->ioctl(idev->info, cmd, arg);
> +
> +    return -ENOSYS;
> +}
> +
>  static ssize_t uio_read(struct file *filep, char __user *buf,
>              size_t count, loff_t *ppos)
>  {
> @@ -590,6 +602,7 @@ static const struct file_operations uio_fops = {
>      .mmap        = uio_mmap,
>      .poll        = uio_poll,
>      .fasync        = uio_fasync,
> +    .ioctl        = uio_ioctl,
>  };
>  
>  static int uio_major_init(void)
> diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
> index cdf338d..e44e89b 100644
> --- a/include/linux/uio_driver.h
> +++ b/include/linux/uio_driver.h
> @@ -68,6 +68,8 @@ struct uio_info {
>      int (*open)(struct uio_info *info, struct inode *inode);
>      int (*release)(struct uio_info *info, struct inode *inode);
>      int (*irqcontrol)(struct uio_info *info, s32 irq_on);
> +    int (*ioctl)(struct uio_info *info, unsigned int cmd,
> +            unsigned long arg);
>  };
>  
>  extern int __must_check

> begin:vcard
> fn:Neil Armstrong
> n:Armstrong;Neil
> org:Neotion;Neotion Sophia Antipolis
> adr:;;;Sophia Antipolis;;;France
> email;internet:narmstrong@neotion.com
> title:Embedded Linux Software Engineer
> tel;cell:0667474169
> note:PGP 0x1166F485
> x-mozilla-html:FALSE
> url:http://www.neotion.com
> version:2.1
> end:vcard
> 

