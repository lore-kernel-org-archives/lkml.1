Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYEWJG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYEWJG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYEWJGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:06:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:33261 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752321AbYEWJGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:06:17 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 23 May 2008 11:06:16 +0200
From: "Randolf Pohl" <randolf.pohl@gmx.de>
Message-ID: <20080523090616.68380@gmx.net>
MIME-Version: 1.0
Subject: Re: [PATCH] lcd: Push the BKL down into the driver ioctl handler
To: linux-kernel@vger.kernel.org
X-Authenticated: #47769897
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18c544Sh+ocq54g1xE2xRoZIpCUsqWC1sbLY3nuTy
 9Wuv5JkRHMvl5rIMIi2Nfnl/eFTvSTXKCxAg== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: OrAOfYppbmwoe1ubsDVLYJJPUzc4cpHr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


unlock_kernel() before return:

> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff --git a/drivers/char/lcd.c b/drivers/char/lcd.c
> index 4fe9206..1690cfb 100644
> --- a/drivers/char/lcd.c
> +++ b/drivers/char/lcd.c

[...]

> @@ -399,17 +408,15 @@ static int lcd_ioctl(struct inode *inode, struct file *file,
> 			if (__copy_to_user
> 			    ((struct lcd_display *) arg, &button_display,
> 			     sizeof(struct lcd_display)))
> -			      return -EFAULT;
> +			      ret = -EFAULT;
> 			break;
> 		}
>  
> 	default:
> -	      return -EINVAL;
> -
> +	      ret = -ENOTTY;
> 	}
> -
> -       return 0;
> -
> +       lock_kernel();

Shouldn't this be unlock_kernel();

> +       return ret;
>  }
>  
>  static int lcd_open(struct inode *inode, struct file *file)
> @@ -462,7 +469,7 @@ static ssize_t lcd_read(struct file *file, char *buf,
>  
>  static const struct file_operations lcd_fops = {
> 	.read = lcd_read,
> -       .ioctl = lcd_ioctl,
> +       .unlocked_ioctl = lcd_ioctl,
> 	.open = lcd_open,
>  };


Cheers,

R.
-- 
GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/?mc=sv_ext_mf@gmx
