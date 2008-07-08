Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYGHUJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYGHUJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYGHUI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:08:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36056 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYGHUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:08:57 -0400
Date: Tue, 8 Jul 2008 21:08:42 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ds1620: Push BKL down
Message-ID: <20080708200841.GB31327@flint.arm.linux.org.uk>
References: <20080522213529.1423c01f@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522213529.1423c01f@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:35:29PM +0100, Alan Cox wrote:
> Push down the BKL and correct the ioctl return for unknown ioctls.

In principle, no issues with the patch, and I'd ack it.  However, I've
made some comments about whether the BKL is needed in all these places.
Whether your intention is just to push the BKL down or to actually
eliminate it will of course determine whether you want to delete those.

> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
> index 334ad5b..6db699d 100644
> --- a/drivers/char/ds1620.c
> +++ b/drivers/char/ds1620.c
> @@ -8,10 +8,11 @@
>  #include <linux/proc_fs.h>
>  #include <linux/capability.h>
>  #include <linux/init.h>
> +#include <linux/smp_lock.h>
> +#include <linux/uaccess.h>
>  
>  #include <asm/hardware.h>
>  #include <asm/mach-types.h>
> -#include <asm/uaccess.h>
>  #include <asm/therm.h>
>  
>  #ifdef CONFIG_PROC_FS
> @@ -225,8 +226,8 @@ ds1620_read(struct file *file, char __user *buf, size_t count, loff_t *ptr)
>  	return 1;
>  }
>  
> -static int
> -ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
> +static long ds1620_ioctl(struct file *file, unsigned int cmd,
> +							unsigned long arg)
>  {
>  	struct therm therm;
>  	union {
> @@ -254,13 +255,16 @@ ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned
>  
>  		therm.lo <<= 1;
>  		therm.hi <<= 1;
> -
> +		lock_kernel();
>  		ds1620_write_state(&therm);
> +		unlock_kernel();
>  		break;
>  
>  	case CMD_GET_THERMOSTATE:
>  	case CMD_GET_THERMOSTATE2:
> +		lock_kernel();
>  		ds1620_read_state(&therm);
> +		unlock_kernel();

These two should stay since there's no other protection against reading half
the state in one thread while another writes the state (where state is
the high/low trip points for the fan speed.)

>  
>  		therm.lo >>= 1;
>  		therm.hi >>= 1;
> @@ -276,20 +280,25 @@ ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned
>  
>  	case CMD_GET_TEMPERATURE:
>  	case CMD_GET_TEMPERATURE2:
> +		lock_kernel();
>  		i = cvt_9_to_int(ds1620_in(THERM_READ_TEMP, 9));
>  
>  		if (cmd == CMD_GET_TEMPERATURE)
>  			i >>= 1;
> -
> +		unlock_kernel();

ds1620_in() is protected by a spinlock internally, and cvt_9_to_int
is just a conversion function, so not required.

>  		return put_user(i, uarg.i) ? -EFAULT : 0;
>  
>  	case CMD_GET_STATUS:
> +		lock_kernel();
>  		i = ds1620_in(THERM_READ_CONFIG, 8) & 0xe3;
> +		unlock_kernel();

ds1620_in() is protected by a spinlock internally, so not required.

>  
>  		return put_user(i, uarg.i) ? -EFAULT : 0;
>  
>  	case CMD_GET_FAN:
> +		lock_kernel();
>  		i = netwinder_get_fan();
> +		unnlock_kernel();

Not required - netwinder_get_fan() essentially just reads a pair of
GPIO registers and reports the state of the GPIO.

>  
>  		return put_user(i, uarg.i) ? -EFAULT : 0;
>  
> @@ -299,14 +308,14 @@ ds1620_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned
>  
>  		if (get_user(i, uarg.i))
>  			return -EFAULT;
> -
> +		lock_kernel();
>  		netwinder_set_fan(i);
> +		unlock_kernel();

Not needed - the internals of netwinder_set_fan() takes a spinlock.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
