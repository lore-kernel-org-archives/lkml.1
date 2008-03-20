Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbYCTU52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbYCTU52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbYCTU5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:57:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757979AbYCTU5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:57:01 -0400
Date: Thu, 20 Mar 2008 13:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: dwmw2@infradead.org, greg@kroah.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mtd@vger.kernel.org
Subject: Re: [PATCH] 1/2 Maple: Update bus driver to allow support of VMU
 device
Message-Id: <20080320135618.1a283b3e.akpm@linux-foundation.org>
In-Reply-To: <1205880554.6250.25.camel@localhost.localdomain>
References: <1205879413.6250.13.camel@localhost.localdomain>
	<1205880554.6250.25.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 22:49:14 +0000
Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> These patches update the maple bus driver with a semaphore to allow
> other maple drivers to inject arbitrary packets (eg block reads and
> writes) into the maple bus packet stream - so allowing support for the
> VMU (and, eventually, other maple devices).
> 
> The patches also ensure that the maple bus driver properly supports the
> device model through probing.
> 
> ...
>
> @@ -255,12 +267,8 @@ static int attach_matching_maple_driver(struct device_driver *driver,
>  
>  	mdev = devptr;
>  	maple_drv = to_maple_driver(driver);
> -	if (mdev->devinfo.function & be32_to_cpu(maple_drv->function)) {
> -		if (maple_drv->connect(mdev) == 0) {
> -			mdev->driver = maple_drv;
> -			return 1;
> -		}
> -	}
> +	if (mdev->devinfo.function & cpu_to_be32(maple_drv->function))
> +		return 1;
>  	return 0;
>  }
>  
> @@ -268,11 +276,6 @@ static void maple_detach_driver(struct maple_device *mdev)
>  {
>  	if (!mdev)
>  		return;
> -	if (mdev->driver) {
> -		if (mdev->driver->disconnect)
> -			mdev->driver->disconnect(mdev);
> -	}
> -	mdev->driver = NULL;
>  	device_unregister(&mdev->dev);
>  	mdev = NULL;
>  }

there seem to be a lot of changes in here which aren't covered by the
changelog.  But then, it was a rather vague changelog.

> @@ -377,18 +380,20 @@ static int setup_maple_commands(struct device *device, void *ignored)
>  
>  	if ((maple_dev->interval > 0)
>  	    && time_after(jiffies, maple_dev->when)) {
> +		if (down_trylock(&maple_dev->mq->sem))
> +			return 0;
>  		maple_dev->when = jiffies + maple_dev->interval;
>  		maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
>  		maple_dev->mq->sendbuf = &maple_dev->function;
>  		maple_dev->mq->length = 1;
>  		maple_add_packet(maple_dev->mq);
> -		liststatus++;
>  	} else {
>  		if (time_after(jiffies, maple_pnp_time)) {
> +			if (down_trylock(&maple_dev->mq->sem))
> +				return -1;
>  			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
>  			maple_dev->mq->length = 0;
>  			maple_add_packet(maple_dev->mq);
> -			liststatus++;
>  		}
>  	}

urgh, down_trylock().  And a secret, undocumented one too.

A trylock is always an exceptional thing.  How is *any* reader of this code
supposed to work out what the heck it's doing there?  Convert it into
down(), run the code and decrypt the lockdep warnings, I suspect.

<looks>

Nope, I can't see any other lock being held when we call this function.

The trylocks are an utter mystery to me.  Please don't write mysterious
code.

> @@ -398,32 +403,38 @@ static int setup_maple_commands(struct device *device, void *ignored)
>  /* VBLANK bottom half - implemented via workqueue */
>  static void maple_vblank_handler(struct work_struct *work)
>  {
> -	if (!maple_dma_done())
> -		return;
>  	if (!list_empty(&maple_sentq))
>  		return;
> +	if (!maple_dma_done())
> +		return;
>  	ctrl_outl(0, MAPLE_ENABLE);
> -	liststatus = 0;
>  	bus_for_each_dev(&maple_bus_type, NULL, NULL,
>  			 setup_maple_commands);
>  	if (time_after(jiffies, maple_pnp_time))
>  		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
> -	if (liststatus && list_empty(&maple_sentq)) {
> +	mutex_lock(&maple_wlist_lock);
> +	if (!list_empty(&maple_waitq) && list_empty(&maple_sentq)) {
> +		mutex_unlock(&maple_wlist_lock);
> +		mutex_lock(&maple_list_lock);
>  		INIT_LIST_HEAD(&maple_sentq);
> +		mutex_unlock(&maple_list_lock);
>  		maple_send();
> +	} else {
> +		mutex_unlock(&maple_wlist_lock);
>  	}
> +
>  	maplebus_dma_reset();
>  }

This locking looks like a mess.  I'd suggest that maple_list_lock and
maple_wlist_lock now need documentation.  Describe what data they protect
and what their ranking rules are.

>  /* handle devices added via hotplugs - placing them on queue for DEVINFO*/
>  static void maple_map_subunits(struct maple_device *mdev, int submask)
>  {
> -	int retval, k, devcheck;
> +	int retval, k, devcheck, locking;
>  	struct maple_device *mdev_add;
>  	struct maple_device_specify ds;
>  
> +	ds.port = mdev->port;
>  	for (k = 0; k < 5; k++) {
> -		ds.port = mdev->port;
>  		ds.unit = k + 1;
>  		retval =
>  		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
> @@ -437,9 +448,15 @@ static void maple_map_subunits(struct maple_device *mdev, int submask)
>  			mdev_add = maple_alloc_dev(mdev->port, k + 1);
>  			if (!mdev_add)
>  				return;
> +			locking = down_trylock(&mdev_add->mq->sem);
> +			if (locking) {
> +				up(&mdev_add->mq->sem);
> +				down_interruptible(&mdev_add->mq->sem);
> +			}

What the heck is that trying to do?!?!?!

And it's buggy.  The return value of down_interruptible() is ignored, so
the driver has lost track of whether or not the semphore was taken.

>  			mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
>  			mdev_add->mq->length = 0;
>  			maple_add_packet(mdev_add->mq);
> +			/* mark that we are checking sub devices */
>  			scanning = 1;
>  		}
>  		submask = submask >> 1;
> @@ -512,15 +529,17 @@ static void maple_dma_handler(struct work_struct *work)
>  	struct maple_device *dev;
>  	char *recvbuf;
>  	enum maple_code code;
> -	int i;
> +	int i, locking;
>  
>  	if (!maple_dma_done())
>  		return;
>  	ctrl_outl(0, MAPLE_ENABLE);
> +	mutex_lock(&maple_list_lock);
>  	if (!list_empty(&maple_sentq)) {
>  		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
>  			recvbuf = mq->recvbuf;
>  			code = recvbuf[0];
> +			up(&mq->sem);
>  			dev = mq->dev;
>  			switch (code) {
>  			case MAPLE_RESPONSE_NONE:
> @@ -559,18 +578,26 @@ static void maple_dma_handler(struct work_struct *work)
>  			}
>  		}
>  		INIT_LIST_HEAD(&maple_sentq);
> +		mutex_unlock(&maple_list_lock);
> +		/* if scanning is 1 then we have subdevices to check */
>  		if (scanning == 1) {
>  			maple_send();
>  			scanning = 2;
>  		} else
>  			scanning = 0;
> -
> +		/*check if we have actually tested all ports yet */
>  		if (!fullscan) {
>  			fullscan = 1;
>  			for (i = 0; i < MAPLE_PORTS; i++) {
>  				if (checked[i] == false) {
>  					fullscan = 0;
>  					dev = baseunits[i];
> +					locking = down_trylock(&dev->mq->sem);
> +					if (locking) {
> +						up(&dev->mq->sem);
> +						down_interruptible
> +							(&dev->mq->sem);
> +					}

Ditto.

>  					dev->mq->command =
>  						MAPLE_COMMAND_DEVINFO;
>  					dev->mq->length = 0;
> @@ -578,8 +605,11 @@ static void maple_dma_handler(struct work_struct *work)
>  				}
>  			}
>  		}
> +		/* mark that we have been through the first scan */
>  		if (started == 0)
>  			started = 1;
> +	} else {
> +		mutex_unlock(&maple_list_lock);
>  	}
>  	maplebus_dma_reset();
>  }
> @@ -631,7 +661,7 @@ static int match_maple_bus_driver(struct device *devptr,
>  	if (maple_dev->devinfo.function == 0xFFFFFFFF)
>  		return 0;
>  	else if (maple_dev->devinfo.function &
> -		 be32_to_cpu(maple_drv->function))
> +		 cpu_to_be32(maple_drv->function))
>  		return 1;
>  	return 0;
>  }
> @@ -713,6 +743,8 @@ static int __init maple_bus_init(void)
>  	if (!maple_queue_cache)
>  		goto cleanup_bothirqs;
>  
> +	INIT_LIST_HEAD(&maple_waitq);
> +
>  	/* setup maple ports */
>  	for (i = 0; i < MAPLE_PORTS; i++) {
>  		checked[i] = false;
> @@ -723,6 +755,7 @@ static int __init maple_bus_init(void)
>  				maple_free_dev(mdev[i]);
>  			goto cleanup_cache;
>  		}
> +		down_interruptible(&mdev[i]->mq->sem);
>  		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
>  		mdev[i]->mq->length = 0;
>  		maple_add_packet(mdev[i]->mq);
> diff --git a/include/linux/maple.h b/include/linux/maple.h
> index d31e36e..e40142e 100644
> --- a/include/linux/maple.h
> +++ b/include/linux/maple.h
> @@ -33,6 +33,7 @@ struct mapleq {
>  	void *sendbuf, *recvbuf, *recvbufdcsp;
>  	unsigned char length;
>  	enum maple_code command;
> +	struct semaphore sem;
>  };
>  
>  struct maple_devinfo {
> @@ -73,6 +74,7 @@ void maple_getcond_callback(struct maple_device *dev,
>  int maple_driver_register(struct device_driver *drv);
>  void maple_add_packet(struct mapleq *mq);
>  
> +
>  #define to_maple_dev(n) container_of(n, struct maple_device, dev)
>  #define to_maple_driver(n) container_of(n, struct maple_driver, drv)

Stray newline.
