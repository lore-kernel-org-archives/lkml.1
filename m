Return-Path: <linux-kernel-owner+w=401wt.eu-S1764037AbYEWHgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764037AbYEWHgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYEWHgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:36:01 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39414 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYEWHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:36:00 -0400
Date: Fri, 23 May 2008 09:35:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Push ioctl BKL down into the i2c code
Message-ID: <20080523093545.175c769c@hyperion.delvare>
In-Reply-To: <20080522222327.1af72794@core>
References: <20080522222327.1af72794@core>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, 22 May 2008 22:23:27 +0100, Alan Cox wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>
> 

Description of what the patch does and why it is needed, please. I
can't apply it without that. My first impression is a patch making the
code bigger and more complex with no obvious benefit ;)

Bonus points for a diffstat of the patch.

> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> index d34c14c..16cf0f2 100644
> --- a/drivers/i2c/i2c-dev.c
> +++ b/drivers/i2c/i2c-dev.c
> @@ -34,7 +34,8 @@
>  #include <linux/list.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-dev.h>
> -#include <asm/uaccess.h>
> +#include <linux/smp_lock.h>
> +#include <linux/uaccess.h>
>  
>  static struct i2c_driver i2cdev_driver;
>  
> @@ -266,8 +267,9 @@ static noinline int i2cdev_ioctl_rdrw(struct i2c_client *client,
>  		kfree(rdwr_pa);
>  		return res;
>  	}
> -
> +	lock_kernel();
>  	res = i2c_transfer(client->adapter, rdwr_pa, rdwr_arg.nmsgs);
> +	unlock_kernel();
>  	while (i-- > 0) {
>  		if (res >= 0 && (rdwr_pa[i].flags & I2C_M_RD)) {
>  			if (copy_to_user(data_ptrs[i], rdwr_pa[i].buf,
> @@ -320,11 +322,15 @@ static noinline int i2cdev_ioctl_smbus(struct i2c_client *client,
>  
>  	if ((data_arg.size == I2C_SMBUS_QUICK) ||
>  	    ((data_arg.size == I2C_SMBUS_BYTE) &&
> -	    (data_arg.read_write == I2C_SMBUS_WRITE)))
> +	    (data_arg.read_write == I2C_SMBUS_WRITE))) {
>  		/* These are special: we do not use data */
> -		return i2c_smbus_xfer(client->adapter, client->addr,
> +		lock_kernel();
> +		res =i2c_smbus_xfer(client->adapter, client->addr,

Coding style.

>  				      client->flags, data_arg.read_write,
>  				      data_arg.command, data_arg.size, NULL);
> +		unlock_kernel();
> +		return res;
> +	}
>  
>  	if (data_arg.data == NULL) {
>  		dev_dbg(&client->adapter->dev,
> @@ -355,8 +361,10 @@ static noinline int i2cdev_ioctl_smbus(struct i2c_client *client,
>  		if (data_arg.read_write == I2C_SMBUS_READ)
>  			temp.block[0] = I2C_SMBUS_BLOCK_MAX;
>  	}
> +	lock_kernel();
>  	res = i2c_smbus_xfer(client->adapter, client->addr, client->flags,
>  	      data_arg.read_write, data_arg.command, data_arg.size, &temp);
> +	unlock_kernel();
>  	if (!res && ((data_arg.size == I2C_SMBUS_PROC_CALL) ||
>  		     (data_arg.size == I2C_SMBUS_BLOCK_PROC_CALL) ||
>  		     (data_arg.read_write == I2C_SMBUS_READ))) {
> @@ -366,11 +374,12 @@ static noinline int i2cdev_ioctl_smbus(struct i2c_client *client,
>  	return res;
>  }
>  
> -static int i2cdev_ioctl(struct inode *inode, struct file *file,
> -		unsigned int cmd, unsigned long arg)
> +static long i2cdev_ioctl(struct file *file, unsigned int cmd,
> +						unsigned long arg)
>  {
>  	struct i2c_client *client = (struct i2c_client *)file->private_data;
>  	unsigned long funcs;
> +	int ret = 0;
>  
>  	dev_dbg(&client->adapter->dev, "ioctl, cmd=0x%02x, arg=0x%02lx\n",
>  		cmd, arg);
> @@ -388,28 +397,37 @@ static int i2cdev_ioctl(struct inode *inode, struct file *file,
>  		 * the PEC flag already set, the i2c-dev driver won't see
>  		 * (or use) this setting.
>  		 */
> +		lock_kernel();
>  		if ((arg > 0x3ff) ||
>  		    (((client->flags & I2C_M_TEN) == 0) && arg > 0x7f))
> -			return -EINVAL;
> -		if (cmd == I2C_SLAVE && i2cdev_check_addr(client->adapter, arg))
> -			return -EBUSY;
> -		/* REVISIT: address could become busy later */
> -		client->addr = arg;
> -		return 0;
> +			ret = -EINVAL;
> +		else if (cmd == I2C_SLAVE &&
> +				i2cdev_check_addr(client->adapter, arg))
> +			ret = -EBUSY;
> +		else
> +			/* REVISIT: address could become busy later */
> +			client->addr = arg;

No unlock?

> +		return ret;
>  	case I2C_TENBIT:
> +		lock_kernel();
>  		if (arg)
>  			client->flags |= I2C_M_TEN;
>  		else
>  			client->flags &= ~I2C_M_TEN;
> +		unlock_kernel();
>  		return 0;
>  	case I2C_PEC:
> +		lock_kernel();
>  		if (arg)
>  			client->flags |= I2C_CLIENT_PEC;
>  		else
>  			client->flags &= ~I2C_CLIENT_PEC;
> +		unlock_kernel();
>  		return 0;
>  	case I2C_FUNCS:
> +		lock_kernel();
>  		funcs = i2c_get_functionality(client->adapter);
> +		unlock_kernel();
>  		return put_user(funcs, (unsigned long __user *)arg);
>  
>  	case I2C_RDWR:
> @@ -419,10 +437,14 @@ static int i2cdev_ioctl(struct inode *inode, struct file *file,
>  		return i2cdev_ioctl_smbus(client, arg);
>  
>  	case I2C_RETRIES:
> +		lock_kernel();
>  		client->adapter->retries = arg;
> +		unlock_kernel();
>  		break;
>  	case I2C_TIMEOUT:
> +		lock_kernel();
>  		client->adapter->timeout = arg;
> +		unlock_kernel();
>  		break;
>  	default:
>  		/* NOTE:  returning a fault code here could cause trouble
> @@ -487,7 +509,7 @@ static const struct file_operations i2cdev_fops = {
>  	.llseek		= no_llseek,
>  	.read		= i2cdev_read,
>  	.write		= i2cdev_write,
> -	.ioctl		= i2cdev_ioctl,
> +	.unlocked_ioctl	= i2cdev_ioctl,
>  	.open		= i2cdev_open,
>  	.release	= i2cdev_release,
>  };


-- 
Jean Delvare
