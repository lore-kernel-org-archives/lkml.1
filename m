Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbZJJRFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbZJJRFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762000AbZJJRFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:05:16 -0400
Received: from bamako.nerim.net ([62.4.17.28]:52859 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761999AbZJJRFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:05:15 -0400
Date: Sat, 10 Oct 2009 19:04:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 23/28] i2c: Remove big kernel lock from i2cdev_open
Message-ID: <20091010190436.1a48f98e@hyperion.delvare>
In-Reply-To: <20091010153350.006406413@linutronix.de>
References: <20091010153314.827301943@linutronix.de>
	<20091010153350.006406413@linutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, 10 Oct 2009 15:37:17 -0000, Thomas Gleixner wrote:
> The BKL is held over a kmalloc so cannot protect anything beyond that.
> The two calls before the kmalloc have their own locking.
> Improve device open function by removing the now unnecessary ret variable
> 
> Signed-off-by: Vincent Sanders <vince@simtec.co.uk>
> LKML-Reference: <1255175172-2666-1-git-send-email-vince@simtec.co.uk>
> Cc: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/i2c/i2c-dev.c |   22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> Index: linux-2.6-tip/drivers/i2c/i2c-dev.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/i2c/i2c-dev.c
> +++ linux-2.6-tip/drivers/i2c/i2c-dev.c
> @@ -34,7 +34,6 @@
>  #include <linux/list.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-dev.h>
> -#include <linux/smp_lock.h>
>  #include <linux/jiffies.h>
>  #include <asm/uaccess.h>
>  
> @@ -445,20 +444,14 @@ static int i2cdev_open(struct inode *ino
>  	struct i2c_client *client;
>  	struct i2c_adapter *adap;
>  	struct i2c_dev *i2c_dev;
> -	int ret = 0;
>  
> -	lock_kernel();
>  	i2c_dev = i2c_dev_get_by_minor(minor);
> -	if (!i2c_dev) {
> -		ret = -ENODEV;
> -		goto out;
> -	}
> +	if (!i2c_dev)
> +		return -ENODEV;
>  
>  	adap = i2c_get_adapter(i2c_dev->adap->nr);
> -	if (!adap) {
> -		ret = -ENODEV;
> -		goto out;
> -	}
> +	if (!adap)
> +		return -ENODEV;
>  
>  	/* This creates an anonymous i2c_client, which may later be
>  	 * pointed to some address using I2C_SLAVE or I2C_SLAVE_FORCE.
> @@ -470,8 +463,7 @@ static int i2cdev_open(struct inode *ino
>  	client = kzalloc(sizeof(*client), GFP_KERNEL);
>  	if (!client) {
>  		i2c_put_adapter(adap);
> -		ret = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>  	}
>  	snprintf(client->name, I2C_NAME_SIZE, "i2c-dev %d", adap->nr);
>  	client->driver = &i2cdev_driver;
> @@ -479,9 +471,7 @@ static int i2cdev_open(struct inode *ino
>  	client->adapter = adap;
>  	file->private_data = client;
>  
> -out:
> -	unlock_kernel();
> -	return ret;
> +	return 0;
>  }
>  
>  static int i2cdev_release(struct inode *inode, struct file *file)
> 

Looks good to me:

Acked-by: Jean Delvare <khali@linux-fr.org>

Do you want me to pick this patch in my i2c tree, or will you take care
of pushing it upstream? If you're not going to push it quickly, I'd
prefer the first solution, to avoid conflicts.

(As a side note, i2c-dev would deserve a partial rewrite as it doesn't
integrate into the standard device driver model, and certainly has a
number of race conditions. But this is well beyond the scope of your
patch.)

Thanks,
-- 
Jean Delvare
