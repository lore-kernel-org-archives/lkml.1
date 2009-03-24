Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbZCXX76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbZCXX76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZCXX7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:59:49 -0400
Received: from vena.lwn.net ([206.168.112.25]:41231 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbZCXX7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:59:48 -0400
Date: Tue, 24 Mar 2009 17:59:34 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, Stoyan Gaydarov <stoyboyker@gmail.com>,
       starvik@axis.com, jesper.nilsson@axis.com, dev-etrax@axis.com
Subject: Re: [PATCH 02/13] [cris/arch-v10] changed ioctls to unlocked
Message-ID: <20090324175934.40a6df28@bike.lwn.net>
In-Reply-To: <1237929168-15341-3-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-3-git-send-email-stoyboyker@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 16:12:37 -0500
stoyboyker@gmail.com wrote:

> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  arch/cris/arch-v10/drivers/ds1302.c      |   59 +++++++++++++++++++++---------
>  arch/cris/arch-v10/drivers/gpio.c        |   28 ++++++++------
>  arch/cris/arch-v10/drivers/pcf8563.c     |   33 +++++++++++++----
>  arch/cris/arch-v10/drivers/sync_serial.c |   18 ++++++---
>  4 files changed, 95 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
> index 77630df..0260599 100644
> --- a/arch/cris/arch-v10/drivers/ds1302.c
> +++ b/arch/cris/arch-v10/drivers/ds1302.c
> @@ -238,21 +238,25 @@ static unsigned char days_in_mo[] =
>  
>  /* ioctl that supports RTC_RD_TIME and RTC_SET_TIME (read and set time/date). */
>  
> -static int
> -rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -	  unsigned long arg) 
> +static long
> +rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> +	lock_kernel();
> +
>  	unsigned long flags;

Define the variable first, please.

>  	switch(cmd) {
>  		case RTC_RD_TIME:	/* read the time/date from RTC	*/
>  		{
>  			struct rtc_time rtc_tm;
> -						
> +
>  			memset(&rtc_tm, 0, sizeof (struct rtc_time));
> -			get_rtc_time(&rtc_tm);						
> -			if (copy_to_user((struct rtc_time*)arg, &rtc_tm, sizeof(struct rtc_time)))
> -				return -EFAULT;	
> +			get_rtc_time(&rtc_tm);
> +			if (copy_to_user((struct rtc_time*)arg, &rtc_tm, sizeof(struct rtc_time))) {
> +				unlock_kernel();
> +				return -EFAULT;
> +			}
> +			unlock_kernel();

Again, please use the more standard idiom:

	retval = -EFAULT;
	goto out;

or some such.  All these middle-of-function returns will bite you.

>  			return 0;
>  		}
>  
> @@ -262,11 +266,15 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  			unsigned char mon, day, hrs, min, sec, leap_yr;
>  			unsigned int yrs;
>  
> -			if (!capable(CAP_SYS_TIME))
> +			if (!capable(CAP_SYS_TIME)) {
> +				unlock_kernel();
>  				return -EPERM;
> +			}
>  
> -			if (copy_from_user(&rtc_tm, (struct rtc_time*)arg, sizeof(struct rtc_time)))
> +			if (copy_from_user(&rtc_tm, (struct rtc_time*)arg, sizeof(struct rtc_time))) {
> +				unlock_kernel();
>  				return -EFAULT;
> +			}
>  
>  			yrs = rtc_tm.tm_year + 1900;
>  			mon = rtc_tm.tm_mon + 1;   /* tm_mon starts at zero */
> @@ -276,19 +284,27 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  			sec = rtc_tm.tm_sec;
>  			
>  			
> -			if ((yrs < 1970) || (yrs > 2069))
> +			if ((yrs < 1970) || (yrs > 2069)) {
> +				unlock_kernel();
>  				return -EINVAL;
> +			}
>  
>  			leap_yr = ((!(yrs % 4) && (yrs % 100)) || !(yrs % 400));
>  
> -			if ((mon > 12) || (day == 0))
> +			if ((mon > 12) || (day == 0)) {
> +				unlock_kernel();
>  				return -EINVAL;
> +			}
>  
> -			if (day > (days_in_mo[mon] + ((mon == 2) && leap_yr)))
> +			if (day > (days_in_mo[mon] + ((mon == 2) && leap_yr))) {
> +				unlock_kernel();
>  				return -EINVAL;
> +			}
>  			
> -			if ((hrs >= 24) || (min >= 60) || (sec >= 60))
> +			if ((hrs >= 24) || (min >= 60) || (sec >= 60)) {
> +				unlock_kernel();
>  				return -EINVAL;
> +			}
>  
>  			if (yrs >= 2000)
>  				yrs -= 2000;	/* RTC (0, 1, ... 69) */
> @@ -316,6 +332,7 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  			 * You need to set that separately with settimeofday
>  			 * or adjtimex.
>  			 */
> +			unlock_kernel();
>  			return 0;
>  		}
>  
> @@ -323,14 +340,19 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  		{
>  			int tcs_val;
>  
> -			if (!capable(CAP_SYS_TIME))
> +			if (!capable(CAP_SYS_TIME)) {
> +				unlock_kernel();
>  				return -EPERM;
> +			}
>  			
> -			if(copy_from_user(&tcs_val, (int*)arg, sizeof(int)))
> +			if(copy_from_user(&tcs_val, (int*)arg, sizeof(int))) {
> +				unlock_kernel();
>  				return -EFAULT;
> +			}
>  
>  			tcs_val = RTC_TCR_PATTERN | (tcs_val & 0x0F);
>  			ds1302_writereg(RTC_TRICKLECHARGER, tcs_val);

This function clearly needs the BKL, incidentally; there doesn't appear to
be any other locking going on.

> +			unlock_kernel();
>  			return 0;
>  		}
>  		case RTC_VL_READ:
> @@ -340,6 +362,7 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  			 */
>  			printk(KERN_WARNING "DS1302: RTC Voltage Low detection"
>  			       " is not supported\n");
> +			unlock_kernel();
>  			return 0;
>  		}
>  		case RTC_VL_CLR:
> @@ -347,9 +370,11 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  			/* TODO:
>  			 * Nothing to do since Voltage Low detection is not supported
>  			 */
> +			unlock_kernel();
>  			return 0;
>  		}
>  		default:
> +			unlock_kernel();
>  			return -ENOIOCTLCMD;
>  	}
>  }
> @@ -375,8 +400,8 @@ print_rtc_status(void)
>  /* The various file operations we support. */
>  
>  static const struct file_operations rtc_fops = {
> -	.owner =	THIS_MODULE,
> -	.ioctl =	rtc_ioctl,
> +	.owner =		THIS_MODULE,
> +	.unlocked_ioctl =	rtc_ioctl,
>  }; 
>  
>  /* Probe for the chip by writing something to its RAM and try reading it back. */
> diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
> index 4b0f65f..2199c08 100644
> --- a/arch/cris/arch-v10/drivers/gpio.c
> +++ b/arch/cris/arch-v10/drivers/gpio.c
> @@ -46,8 +46,8 @@ static char gpio_name[] = "etrax gpio";
>  static wait_queue_head_t *gpio_wq;
>  #endif
>  
> -static int gpio_ioctl(struct inode *inode, struct file *file,
> -	unsigned int cmd, unsigned long arg);
> +static long gpio_ioctl(struct file *file, unsigned int cmd,
> +	unsigned long arg);
>  static ssize_t gpio_write(struct file *file, const char __user *buf,
>  	size_t count, loff_t *off);
>  static int gpio_open(struct inode *inode, struct file *filp);
> @@ -504,17 +504,20 @@ unsigned long inline setget_output(struct gpio_private *priv, unsigned long arg)
>  static int
>  gpio_leds_ioctl(unsigned int cmd, unsigned long arg);
>  
> -static int
> -gpio_ioctl(struct inode *inode, struct file *file,
> -	   unsigned int cmd, unsigned long arg)
> +static long
> +gpio_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> +	lock_kernel();
> +
>  	unsigned long flags;
>  	unsigned long val;
>          int ret = 0;
>  
>  	struct gpio_private *priv = file->private_data;
> -	if (_IOC_TYPE(cmd) != ETRAXGPIO_IOCTYPE)
> +	if (_IOC_TYPE(cmd) != ETRAXGPIO_IOCTYPE) {
> +		unlock_kernel();
>  		return -EINVAL;
> +	}

lock_kernel should happen here.

>  	spin_lock_irqsave(&gpio_lock, flags);

But notice how this function has its own locking?  That, alone, doesn't
tell you that the BKL is not needed, but it's a good sign.

HOWEVER (getting off the topic of this patch, now), further into this
function I see:

	case IO_CLRALARM:
		// clear alarm for bits with 1 in arg
		priv->highalarm &= ~arg;
		priv->lowalarm  &= ~arg;
		{
			/* Must update gpio_some_alarms */
			struct gpio_private *p = alarmlist;
			int some_alarms;
			spin_lock_irq(&gpio_lock);
			p = alarmlist;
			some_alarms = 0;

But it already took gpio_lock!  Somebody needs to tell me how this could
possibly not deadlock.  Maybe this code has never been run on an SMP
system?

Stoyan, as a developer working on locking fixes, you would inspire more
confidence in your work if you would notice things like this.  It's
important to look at what's going on.

> @@ -680,6 +683,7 @@ gpio_ioctl(struct inode *inode, struct file *file,
>  	} /* switch */
>  
>  	spin_unlock_irqrestore(&gpio_lock, flags);
> +	unlock_kernel();
>  	return ret;
>  }
>  
> @@ -713,12 +717,12 @@ gpio_leds_ioctl(unsigned int cmd, unsigned long arg)
>  }
>  
>  static const struct file_operations gpio_fops = {
> -	.owner       = THIS_MODULE,
> -	.poll        = gpio_poll,
> -	.ioctl       = gpio_ioctl,
> -	.write       = gpio_write,
> -	.open        = gpio_open,
> -	.release     = gpio_release,
> +	.owner		= THIS_MODULE,
> +	.poll		= gpio_poll,
> +	.unlocked_ioctl	= gpio_ioctl,
> +	.write		= gpio_write,
> +	.open		= gpio_open,
> +	.release	= gpio_release,
>  };
>  
>  static void ioif_watcher(const unsigned int gpio_in_available,
> diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
> index 1e90c1a..9a2b46e 100644
> --- a/arch/cris/arch-v10/drivers/pcf8563.c
> +++ b/arch/cris/arch-v10/drivers/pcf8563.c
> @@ -53,7 +53,7 @@ static DEFINE_MUTEX(rtc_lock); /* Protect state etc */
>  static const unsigned char days_in_month[] =
>  	{ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
>  
> -int pcf8563_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
> +long pcf8563_ioctl(struct file *, unsigned int, unsigned long);
>  
>  /* Cache VL bit value read at driver init since writing the RTC_SECOND
>   * register clears the VL status.
> @@ -62,7 +62,7 @@ static int voltage_low;
>  
>  static const struct file_operations pcf8563_fops = {
>  	.owner = THIS_MODULE,
> -	.ioctl = pcf8563_ioctl,
> +	.unlocked_ioctl = pcf8563_ioctl,
>  };
>  
>  unsigned char
> @@ -212,8 +212,7 @@ pcf8563_exit(void)
>   * ioctl calls for this driver. Why return -ENOTTY upon error? Because
>   * POSIX says so!
>   */
> -int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
> -	unsigned long arg)
> +long pcf8563_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	/* Some sanity checks. */
>  	if (_IOC_TYPE(cmd) != RTC_MAGIC)
> @@ -222,6 +221,8 @@ int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
>  	if (_IOC_NR(cmd) > RTC_MAX_IOCTL)
>  		return -ENOTTY;
>  
> +	lock_kernel();
> +

This is the right place for lock_kernel().  But...

>  	switch (cmd) {
>  	case RTC_RD_TIME:
>  	{
> @@ -234,11 +235,13 @@ int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
>  		if (copy_to_user((struct rtc_time *) arg, &tm,
>  				 sizeof tm)) {
>  			mutex_unlock(&rtc_lock);
> +			unlock_kernel();

again, we have a driver which appears to be doing its own locking.  The
author was pretty careful to acquire rtc_lock before messing with things.
But...  (skipping a bit) I find:


		mutex_lock(&rtc_lock);

		rtc_write(RTC_YEAR, tm.tm_year);
		rtc_write(RTC_MONTH, tm.tm_mon);
		rtc_write(RTC_WEEKDAY, tm.tm_wday); /* Not coded in BCD. */
		rtc_write(RTC_DAY_OF_MONTH, tm.tm_mday);
		rtc_write(RTC_HOURS, tm.tm_hour);
		rtc_write(RTC_MINUTES, tm.tm_min);
		rtc_write(RTC_SECONDS, tm.tm_sec);

		mutex_unlock(&rtc_lock);

		return 0;
	}

	/* [trimmed by jc] */

	case RTC_VL_CLR:
	{
		/* Clear the VL bit in the seconds register in case
		 * the time has not been set already (which would
		 * have cleared it). This does not really matter
		 * because of the cached voltage_low value but do it
		 * anyway for consistency. */

		int ret = rtc_read(RTC_SECONDS);

		rtc_write(RTC_SECONDS, (ret & 0x7F));

Notice how the first rtc_write(RTC_SECONDS...) is protected by rtc_lock,
but the second is not?  This function appears to be buggy too.  It would be
good to notice things like that.

[...]

>  
> diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
> index 6cc1a03..f66e79b 100644
> --- a/arch/cris/arch-v10/drivers/sync_serial.c
> +++ b/arch/cris/arch-v10/drivers/sync_serial.c
> @@ -158,8 +158,8 @@ static int sync_serial_open(struct inode *inode, struct file *file);
>  static int sync_serial_release(struct inode *inode, struct file *file);
>  static unsigned int sync_serial_poll(struct file *filp, poll_table *wait);
>  
> -static int sync_serial_ioctl(struct inode *inode, struct file *file,
> -	unsigned int cmd, unsigned long arg);
> +static long sync_serial_ioctl(struct file *file, unsigned int cmd,
> +	unsigned long arg);
>  static ssize_t sync_serial_write(struct file *file, const char *buf,
>  	size_t count, loff_t *ppos);
>  static ssize_t sync_serial_read(struct file *file, char *buf,
> @@ -249,7 +249,7 @@ static struct file_operations sync_serial_fops = {
>  	.write   = sync_serial_write,
>  	.read    = sync_serial_read,
>  	.poll    = sync_serial_poll,
> -	.ioctl   = sync_serial_ioctl,
> +	.unlocked_ioctl   = sync_serial_ioctl,
>  	.open    = sync_serial_open,
>  	.release = sync_serial_release
>  };
> @@ -679,17 +679,20 @@ static unsigned int sync_serial_poll(struct file *file, poll_table *wait)
>  	return mask;
>  }
>  
> -static int sync_serial_ioctl(struct inode *inode, struct file *file,
> -		  unsigned int cmd, unsigned long arg)
> +static long sync_serial_ioctl(struct file *file, unsigned int cmd,
> +		  unsigned long arg)
>  {
>  	int return_val = 0;
>  	unsigned long flags;
>  
> +	lock_kernel();
> +
>  	int dev = MINOR(file->f_dentry->d_inode->i_rdev);
>  	struct sync_port *port;

>  	if (dev < 0 || dev >= NUMBER_OF_PORTS || !ports[dev].enabled) {
>  		DEBUG(printk(KERN_DEBUG "Invalid minor %d\n", dev));
> +		unlock_kernel();
>  		return -1;
>  	}

lock_kernel() should move down here.

>  	port = &ports[dev];
> @@ -757,8 +760,10 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
>  		}
>  		break;
>  	case SSP_MODE:
> -		if (arg > 5)
> +		if (arg > 5) {
> +			unlock_kernel();
>  			return -EINVAL;
> +		}
>  		if (arg == MASTER_OUTPUT || arg == SLAVE_OUTPUT)
>  			*R_IRQ_MASK1_CLR = 1 << port->data_avail_bit;
>  		else if (!port->use_dma)
> @@ -954,6 +959,7 @@ static int sync_serial_ioctl(struct inode *inode, struct file *file,
>  		start_dma_in(port);
>  	}
>  	local_irq_restore(flags);
> +	unlock_kernel();

This function appears to be using irq-disabling as its locking.  Hmm.

You missed one:

	case SSP_INBUFCHUNK:
#if 0
		if (arg > port->in_buffer_size/NUM_IN_DESCR)
			return -EINVAL;

Yes, it's in "#if 0", but somebody might uncomment it someday.  If you're
fixing the code, you need to fix *all* the code.

>  	return return_val;
>  }
>  

jon
