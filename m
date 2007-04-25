Return-Path: <linux-kernel-owner+w=401wt.eu-S2992536AbXDYJuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992536AbXDYJuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992533AbXDYJuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:50:10 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:44297 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992529AbXDYJuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:50:07 -0400
X-Greylist: delayed 34068 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2007 05:50:07 EDT
Date: Wed, 25 Apr 2007 09:22:15 +0900
From: Mattia Dongili <malattia@linux.it>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use mutex instead of semaphore in Sony PI driver
Message-ID: <20070425002215.GC4146@inferi.kami.home>
References: <20070424200235.GH6798@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424200235.GH6798@traven>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc6-mm1-4 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 10:02:35PM +0200, Matthias Kaehlcke wrote:
> the Sony Programmable I/O Control driver uses a semaphore as
> mutex. use the mutex API instead of the (binary) semaphore
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com> 

Acked-by: Mattia Dongili <malattia@linux.it>
 
> --
> 
> diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> index 7823757..878d8d0 100644
> --- a/drivers/char/sonypi.c
> +++ b/drivers/char/sonypi.c
> @@ -477,7 +477,7 @@ static struct sonypi_device {
>  	u16 evtype_offset;
>  	int camera_power;
>  	int bluetooth_power;
> -	struct semaphore lock;
> +	struct mutex lock;
>  	struct kfifo *fifo;
>  	spinlock_t fifo_lock;
>  	wait_queue_head_t fifo_proc_list;
> @@ -884,7 +884,7 @@ int sonypi_camera_command(int command, u8 value)
>  	if (!camera)
>  		return -EIO;
>  
> -	down(&sonypi_device.lock);
> +	mutex_lock(&sonypi_device.lock);
>  
>  	switch (command) {
>  	case SONYPI_COMMAND_SETCAMERA:
> @@ -919,7 +919,7 @@ int sonypi_camera_command(int command, u8 value)
>  		       command);
>  		break;
>  	}
> -	up(&sonypi_device.lock);
> +	mutex_unlock(&sonypi_device.lock);
>  	return 0;
>  }
>  
> @@ -938,20 +938,20 @@ static int sonypi_misc_fasync(int fd, struct file *filp, int on)
>  static int sonypi_misc_release(struct inode *inode, struct file *file)
>  {
>  	sonypi_misc_fasync(-1, file, 0);
> -	down(&sonypi_device.lock);
> +	mutex_lock(&sonypi_device.lock);
>  	sonypi_device.open_count--;
> -	up(&sonypi_device.lock);
> +	mutex_unlock(&sonypi_device.lock);
>  	return 0;
>  }
>  
>  static int sonypi_misc_open(struct inode *inode, struct file *file)
>  {
> -	down(&sonypi_device.lock);
> +	mutex_lock(&sonypi_device.lock);
>  	/* Flush input queue on first open */
>  	if (!sonypi_device.open_count)
>  		kfifo_reset(sonypi_device.fifo);
>  	sonypi_device.open_count++;
> -	up(&sonypi_device.lock);
> +	mutex_unlock(&sonypi_device.lock);
>  	return 0;
>  }
>  
> @@ -1001,7 +1001,7 @@ static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
>  	u8 val8;
>  	u16 val16;
>  
> -	down(&sonypi_device.lock);
> +	mutex_lock(&sonypi_device.lock);
>  	switch (cmd) {
>  	case SONYPI_IOCGBRT:
>  		if (sonypi_ec_read(SONYPI_LCD_LIGHT, &val8)) {
> @@ -1101,7 +1101,7 @@ static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
>  	default:
>  		ret = -EINVAL;
>  	}
> -	up(&sonypi_device.lock);
> +	mutex_unlock(&sonypi_device.lock);
>  	return ret;
>  }
>  
> @@ -1330,7 +1330,7 @@ static int __devinit sonypi_probe(struct platform_device *dev)
>  	}
>  
>  	init_waitqueue_head(&sonypi_device.fifo_proc_list);
> -	init_MUTEX(&sonypi_device.lock);
> +	mutex_init(&sonypi_device.lock);
>  	sonypi_device.bluetooth_power = -1;
>  
>  	if ((pcidev = pci_get_device(PCI_VENDOR_ID_INTEL,
> 
> -- 
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
> 
>              If liberty means anything at all, it means the
>            right to tell people what they do not want to hear
>                             (George Orwell)
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> 
-- 
mattia
:wq!
