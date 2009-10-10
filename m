Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbZJJVPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbZJJVPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762124AbZJJVPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:15:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762123AbZJJVPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:15:22 -0400
Date: Sat, 10 Oct 2009 23:14:15 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 22/28] macintosh: Remove BKL from ans-lcd
In-Reply-To: <20091010153349.966159859@linutronix.de>
Message-ID: <alpine.LFD.2.00.0910102309570.3669@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.966159859@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Oct 2009, Thomas Gleixner wrote:

> The ans-lcd driver got the cycle_kernel_lock() in anslcd_open() from
> the BKL pushdown and it still uses the locked ioctl.
> 
> The BKL serialization in this driver is more than obscure and
> definitely does not cover all possible corner cases. Protect the
> access to the hardware with a local mutex and get rid of BKL and
> locked ioctl.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: linuxppc-dev@ozlabs.org
> ---
>  drivers/macintosh/ans-lcd.c |   45 +++++++++++++++++++++++++++-----------------
>  1 file changed, 28 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6-tip/drivers/macintosh/ans-lcd.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/macintosh/ans-lcd.c
> +++ linux-2.6-tip/drivers/macintosh/ans-lcd.c
> @@ -3,7 +3,6 @@
>   */
>  
>  #include <linux/types.h>
> -#include <linux/smp_lock.h>
>  #include <linux/errno.h>
>  #include <linux/kernel.h>
>  #include <linux/miscdevice.h>
> @@ -26,6 +25,7 @@
>  static unsigned long anslcd_short_delay = 80;
>  static unsigned long anslcd_long_delay = 3280;
>  static volatile unsigned char __iomem *anslcd_ptr;
> +static DEFINE_MUTEX(anslcd_mutex);
>  
>  #undef DEBUG
>  
> @@ -65,26 +65,31 @@ anslcd_write( struct file * file, const 
>  
>  	if (!access_ok(VERIFY_READ, buf, count))
>  		return -EFAULT;
> +
> +	mutex_lock(&anslcd_mutex);
>  	for ( i = *ppos; count > 0; ++i, ++p, --count ) 
>  	{
>  		char c;
>  		__get_user(c, p);
>  		anslcd_write_byte_data( c );
>  	}
> +	mutex_unlock(&anslcd_mutex);
>  	*ppos = i;
>  	return p - buf;
>  }
>  
> -static int
> -anslcd_ioctl( struct inode * inode, struct file * file,
> -				unsigned int cmd, unsigned long arg )
> +static long
> +anslcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	char ch, __user *temp;
> +	long ret = 0;
>  
>  #ifdef DEBUG
>  	printk(KERN_DEBUG "LCD: ioctl(%d,%d)\n",cmd,arg);
>  #endif
>  
> +	mutex_lock(&anslcd_mutex);
> +
>  	switch ( cmd )
>  	{
>  	case ANSLCD_CLEAR:
> @@ -93,7 +98,7 @@ anslcd_ioctl( struct inode * inode, stru
>  		anslcd_write_byte_ctrl ( 0x06 );
>  		anslcd_write_byte_ctrl ( 0x01 );
>  		anslcd_write_byte_ctrl ( 0x02 );
> -		return 0;
> +		break;
>  	case ANSLCD_SENDCTRL:
>  		temp = (char __user *) arg;
>  		__get_user(ch, temp);
> @@ -101,33 +106,37 @@ anslcd_ioctl( struct inode * inode, stru
>  			anslcd_write_byte_ctrl ( ch );
>  			__get_user(ch, temp);
>  		}
> -		return 0;
> +		break;
>  	case ANSLCD_SETSHORTDELAY:
>  		if (!capable(CAP_SYS_ADMIN))
> -			return -EACCES;
> -		anslcd_short_delay=arg;
> -		return 0;
> +			ret =-EACCES;
> +		else
> +			anslcd_short_delay=arg;
> +		break;
>  	case ANSLCD_SETLONGDELAY:
>  		if (!capable(CAP_SYS_ADMIN))
> -			return -EACCES;
> -		anslcd_long_delay=arg;
> -		return 0;
> +			ret = -EACCES;
> +		else
> +			anslcd_long_delay=arg;
> +		break;
>  	default:
> -		return -EINVAL;
> +		ret = -EINVAL;
>  	}
> +
> +	mutex_unlock(&anslcd_mutex);
> +	return ret;
>  }
>  
>  static int
>  anslcd_open( struct inode * inode, struct file * file )
>  {
> -	cycle_kernel_lock();
>  	return 0;
>  }
>  
>  const struct file_operations anslcd_fops = {
> -	.write	= anslcd_write,
> -	.ioctl	= anslcd_ioctl,
> -	.open	= anslcd_open,
> +	.write		= anslcd_write,
> +	.unlocked_ioctl	= anslcd_ioctl,
> +	.open		= anslcd_open,
>  };
>  
>  static struct miscdevice anslcd_dev = {
> @@ -168,6 +177,7 @@ anslcd_init(void)
>  	printk(KERN_DEBUG "LCD: init\n");
>  #endif
>  
> +	mutex_lock(&anslcd_mutex);
>  	anslcd_write_byte_ctrl ( 0x38 );
>  	anslcd_write_byte_ctrl ( 0x0c );
>  	anslcd_write_byte_ctrl ( 0x06 );
> @@ -176,6 +186,7 @@ anslcd_init(void)
>  	for(a=0;a<80;a++) {
>  		anslcd_write_byte_data(anslcd_logo[a]);
>  	}
> +	mutex_unlock(&anslcd_mutex);
>  	return 0;
>  }
>  
> 
> 
> 

There were 4 checkpatch errors on this patch, all of the type
ERROR: spaces required around that '=' (ctx:WxO)
#1466: FILE: drivers/macintosh/ans-lcd.c:112:
+			ret =-EACCES;

Cheers

