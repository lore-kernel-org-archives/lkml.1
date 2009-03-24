Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZCXXlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZCXXlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZCXXlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:41:04 -0400
Received: from vena.lwn.net ([206.168.112.25]:42503 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbZCXXlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:41:02 -0400
Date: Tue, 24 Mar 2009 17:40:57 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: stoyboyker@gmail.com
Cc: linux-kernel@vger.kernel.org, Stoyan Gaydarov <stoyboyker@gmail.com>,
       gregkh@suse.de
Subject: Re: [PATCH 01/13] [staging] changed ioctls to unlocked
Message-ID: <20090324174057.47f7da3d@bike.lwn.net>
In-Reply-To: <1237929168-15341-2-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-2-git-send-email-stoyboyker@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, looking at the patch now...

>  drivers/staging/epl/EplApiLinuxKernel.c |   10 ++-
>  drivers/staging/meilhaus/memain.c       |  124 +++++++++++++++++++++----------
>  drivers/staging/poch/poch.c             |   25 +++++--
>  3 files changed, 107 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/staging/epl/EplApiLinuxKernel.c b/drivers/staging/epl/EplApiLinuxKernel.c
> index 05ca062..9517da2 100644
> --- a/drivers/staging/epl/EplApiLinuxKernel.c
> +++ b/drivers/staging/epl/EplApiLinuxKernel.c
> @@ -219,7 +219,7 @@ static ssize_t EplLinRead(struct file *pInstance_p, char *pDstBuff_p,
>  			  size_t BuffSize_p, loff_t * pFileOffs_p);
>  static ssize_t EplLinWrite(struct file *pInstance_p, const char *pSrcBuff_p,
>  			   size_t BuffSize_p, loff_t * pFileOffs_p);
> -static int EplLinIoctl(struct inode *pDeviceFile_p, struct file *pInstance_p,
> +static long EplLinIoctl(struct file *pInstance_p,
>  		       unsigned int uiIoctlCmd_p, unsigned long ulArg_p);
>  
>  //---------------------------------------------------------------------------
> @@ -237,7 +237,7 @@ static struct file_operations EplLinFileOps_g = {
>  	.release = EplLinRelease,
>  	.read = EplLinRead,
>  	.write = EplLinWrite,
> -	.ioctl = EplLinIoctl,
> +	.unlocked_ioctl = EplLinIoctl,
>  
>  };
>  
> @@ -551,12 +551,13 @@ static ssize_t EplLinWrite(struct file *pInstance_p,	// information about driver
>  //  -> ioctl(...)
>  //---------------------------------------------------------------------------
>  
> -static int EplLinIoctl(struct inode *pDeviceFile_p,	// information about the device to open
> -		       struct file *pInstance_p,	// information about driver instance
> +static long EplLinIoctl(struct file *pInstance_p,	// information about driver instance
>  		       unsigned int uiIoctlCmd_p,	// Ioctl command to execute
>  		       unsigned long ulArg_p)	// Ioctl command specific argument/parameter
>  {
>  
> +	lock_kernel();
> +
>  	tEplKernel EplRet;
>  	int iErr;
>  	int iRet;
> @@ -1148,6 +1149,7 @@ static int EplLinIoctl(struct inode *pDeviceFile_p,	// information about the dev
>        Exit:
>  
>  //    TRACE1("EPL: - EplLinIoctl (iRet=%d)\n", iRet);
> +	unlock_kernel();
>  	return (iRet);
>  
>  }

Gee what ugly code you're working on here.  It's like...crap or
something...:)

You should avoid making it worse by putting lock_kernel() above the
variable declarations, though.  That will set off alarms for sure, even in
-staging code.

> diff --git a/drivers/staging/meilhaus/memain.c b/drivers/staging/meilhaus/memain.c
> index b09d1a6..9a1706b 100644
> --- a/drivers/staging/meilhaus/memain.c
> +++ b/drivers/staging/meilhaus/memain.c
> @@ -95,7 +95,7 @@ static int replace_with_dummy(int vendor_id, int device_id, int serial_no);
>  static void clear_device_list(void);
>  static int me_open(struct inode *inode_ptr, struct file *filep);
>  static int me_release(struct inode *, struct file *);
> -static int me_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
> +static long me_ioctl(struct file *, unsigned int, unsigned long);
>  //static int me_probe_usb(struct usb_interface *interface, const struct usb_device_id *id);
>  //static void me_disconnect_usb(struct usb_interface *interface);
>  
> @@ -109,7 +109,7 @@ static struct cdev *cdevp;
>  
>  static struct file_operations me_file_operations = {
>  	.owner = THIS_MODULE,
> -	.ioctl = me_ioctl,
> +	.unlocked_ioctl = me_ioctl,
>  	.open = me_open,
>  	.release = me_release,
>  };
> @@ -1751,14 +1751,17 @@ static void me_disconnect_usb(struct usb_interface *interface)
>  }
>  */
>  
> -static int me_ioctl(struct inode *inodep,
> -		    struct file *filep, unsigned int service, unsigned long arg)
> +static long me_ioctl(struct file *filep, unsigned int service,
> +		    unsigned long arg)
>  {
> +	lock_kernel();
> +	long ret;

Please declare the variable first.
  
>  	PDEBUG("executed.\n");
>  
>  	if (_IOC_TYPE(service) != MEMAIN_MAGIC) {
>  		PERROR("Invalid magic number.\n");
> +		unlock_kernel();
>  		return -ENOTTY;
>  	}

You also clearly do not need to do lock_kernel() before this test, so you
could move it down here and avoid one unlock/return sequence.
  
> @@ -1766,147 +1769,186 @@ static int me_ioctl(struct inode *inodep,
>  
>  	switch (service) {
>  	case ME_IO_IRQ_ENABLE:
> -		return me_io_irq_start(filep, (me_io_irq_start_t *) arg);
> +		ret = me_io_irq_start(filep, (me_io_irq_start_t *) arg);
> +		break;
>  
>  	case ME_IO_IRQ_WAIT:
> -		return me_io_irq_wait(filep, (me_io_irq_wait_t *) arg);
> +		ret = me_io_irq_wait(filep, (me_io_irq_wait_t *) arg);
> +		break;
>  
>  	case ME_IO_IRQ_DISABLE:
> -		return me_io_irq_stop(filep, (me_io_irq_stop_t *) arg);
> +		ret = me_io_irq_stop(filep, (me_io_irq_stop_t *) arg);
> +		break;
>  
>  	case ME_IO_RESET_DEVICE:
> -		return me_io_reset_device(filep, (me_io_reset_device_t *) arg);
> +		ret =  me_io_reset_device(filep, (me_io_reset_device_t *) arg);
> +		break;
>  
>  	case ME_IO_RESET_SUBDEVICE:
> -		return me_io_reset_subdevice(filep,
> +		ret =  me_io_reset_subdevice(filep,
>  					     (me_io_reset_subdevice_t *) arg);
> +		break;
>  
>  	case ME_IO_SINGLE_CONFIG:
> -		return me_io_single_config(filep,
> +		ret = me_io_single_config(filep,
>  					   (me_io_single_config_t *) arg);
> +		break;
>  
>  	case ME_IO_SINGLE:
> -		return me_io_single(filep, (me_io_single_t *) arg);
> +		ret =  me_io_single(filep, (me_io_single_t *) arg);
> +		break;
>  
>  	case ME_IO_STREAM_CONFIG:
> -		return me_io_stream_config(filep,
> +		ret = me_io_stream_config(filep,
>  					   (me_io_stream_config_t *) arg);
> +		break;
>  
>  	case ME_IO_STREAM_NEW_VALUES:
> -		return me_io_stream_new_values(filep,
> +		ret =  me_io_stream_new_values(filep,
>  					       (me_io_stream_new_values_t *)
>  					       arg);
> +		break;
>  
>  	case ME_IO_STREAM_READ:
> -		return me_io_stream_read(filep, (me_io_stream_read_t *) arg);
> +		ret = me_io_stream_read(filep, (me_io_stream_read_t *) arg);
> +		break;
>  
>  	case ME_IO_STREAM_START:
> -		return me_io_stream_start(filep, (me_io_stream_start_t *) arg);
> +		ret = me_io_stream_start(filep, (me_io_stream_start_t *) arg);
> +		break;
>  
>  	case ME_IO_STREAM_STATUS:
> -		return me_io_stream_status(filep,
> +		ret =  me_io_stream_status(filep,
>  					   (me_io_stream_status_t *) arg);
> +		break;
>  
>  	case ME_IO_STREAM_STOP:
> -		return me_io_stream_stop(filep, (me_io_stream_stop_t *) arg);
> +		ret = me_io_stream_stop(filep, (me_io_stream_stop_t *) arg);
> +		break;
>  
>  	case ME_IO_STREAM_WRITE:
> -		return me_io_stream_write(filep, (me_io_stream_write_t *) arg);
> +		ret = me_io_stream_write(filep, (me_io_stream_write_t *) arg);
> +		break;
>  
>  	case ME_LOCK_DRIVER:
> -		return me_lock_driver(filep, (me_lock_driver_t *) arg);
> +		ret = me_lock_driver(filep, (me_lock_driver_t *) arg);
> +		break;
>  
>  	case ME_LOCK_DEVICE:
> -		return me_lock_device(filep, (me_lock_device_t *) arg);
> +		ret = me_lock_device(filep, (me_lock_device_t *) arg);
> +		break;
>  
>  	case ME_LOCK_SUBDEVICE:
> -		return me_lock_subdevice(filep, (me_lock_subdevice_t *) arg);
> +		ret = me_lock_subdevice(filep, (me_lock_subdevice_t *) arg);
> +		break;
>  
>  	case ME_QUERY_INFO_DEVICE:
> -		return me_query_info_device(filep,
> +		ret = me_query_info_device(filep,
>  					    (me_query_info_device_t *) arg);
> +		break;
>  
>  	case ME_QUERY_DESCRIPTION_DEVICE:
> -		return me_query_description_device(filep,
> +		ret = me_query_description_device(filep,
>  						   (me_query_description_device_t
>  						    *) arg);
> +		break;
>  
>  	case ME_QUERY_NAME_DEVICE:
> -		return me_query_name_device(filep,
> +		ret = me_query_name_device(filep,
>  					    (me_query_name_device_t *) arg);
> +		break;
>  
>  	case ME_QUERY_NAME_DEVICE_DRIVER:
> -		return me_query_name_device_driver(filep,
> +		ret = me_query_name_device_driver(filep,
>  						   (me_query_name_device_driver_t
>  						    *) arg);
> +		break;
>  
>  	case ME_QUERY_NUMBER_DEVICES:
> -		return me_query_number_devices(filep,
> +		ret = me_query_number_devices(filep,
>  					       (me_query_number_devices_t *)
>  					       arg);
> +		break;
>  
>  	case ME_QUERY_NUMBER_SUBDEVICES:
> -		return me_query_number_subdevices(filep,
> +		ret =  me_query_number_subdevices(filep,
>  						  (me_query_number_subdevices_t
>  						   *) arg);
> +		break;
>  
>  	case ME_QUERY_NUMBER_CHANNELS:
> -		return me_query_number_channels(filep,
> +		ret = me_query_number_channels(filep,
>  						(me_query_number_channels_t *)
>  						arg);
> +		break;
>  
>  	case ME_QUERY_NUMBER_RANGES:
> -		return me_query_number_ranges(filep,
> +		ret = me_query_number_ranges(filep,
>  					      (me_query_number_ranges_t *) arg);
> +		break;
>  
>  	case ME_QUERY_RANGE_BY_MIN_MAX:
> -		return me_query_range_by_min_max(filep,
> +		ret = me_query_range_by_min_max(filep,
>  						 (me_query_range_by_min_max_t *)
>  						 arg);
> +		break;
>  
>  	case ME_QUERY_RANGE_INFO:
> -		return me_query_range_info(filep,
> +		ret = me_query_range_info(filep,
>  					   (me_query_range_info_t *) arg);
> +		break;
>  
>  	case ME_QUERY_SUBDEVICE_BY_TYPE:
> -		return me_query_subdevice_by_type(filep,
> +		ret = me_query_subdevice_by_type(filep,
>  						  (me_query_subdevice_by_type_t
>  						   *) arg);
> +		break;
>  
>  	case ME_QUERY_SUBDEVICE_TYPE:
> -		return me_query_subdevice_type(filep,
> +		ret = me_query_subdevice_type(filep,
>  					       (me_query_subdevice_type_t *)
>  					       arg);
> +		break;
>  
>  	case ME_QUERY_SUBDEVICE_CAPS:
> -		return me_query_subdevice_caps(filep,
> +		ret = me_query_subdevice_caps(filep,
>  					       (me_query_subdevice_caps_t *)
>  					       arg);
> +		break;
>  
>  	case ME_QUERY_SUBDEVICE_CAPS_ARGS:
> -		return me_query_subdevice_caps_args(filep,
> +		ret = me_query_subdevice_caps_args(filep,
>  						    (me_query_subdevice_caps_args_t
>  						     *) arg);
> +		break;
>  
>  	case ME_QUERY_TIMER:
> -		return me_query_timer(filep, (me_query_timer_t *) arg);
> +		ret = me_query_timer(filep, (me_query_timer_t *) arg);
> +		break;
>  
>  	case ME_QUERY_VERSION_MAIN_DRIVER:
> -		return me_query_version_main_driver(filep,
> +		ret = me_query_version_main_driver(filep,
>  						    (me_query_version_main_driver_t
>  						     *) arg);
> +		break;
>  
>  	case ME_QUERY_VERSION_DEVICE_DRIVER:
> -		return me_query_version_device_driver(filep,
> +		ret = me_query_version_device_driver(filep,
>  						      (me_query_version_device_driver_t
>  						       *) arg);
> +		break;
>  
>  	case ME_CONFIG_LOAD:
> -		return me_config_load(filep, (me_config_load_t *) arg);
> +		ret = me_config_load(filep, (me_config_load_t *) arg);
> +		break;
> +	}
> +	if(!ret) {
> +	    PERROR("Invalid ioctl number.\n");
> +	    ret = -ENOTTY;
>  	}

Actually, you've changed the control flow a bit, and probably broken the
function too.  If it's truly an invalid ioctl number, you'll just drop out
of the switch - there's no default branch.  But ret will be a random value
in that case.

In every other case, you take a return code of zero (which means success)
and map it onto -ENOTTY.  Probably not the right thing to do.

> -	PERROR("Invalid ioctl number.\n");
> -	return -ENOTTY;
> +	unlock_kernel();
> +	return ret;
>  }
>  
>  // Init and exit of module.
> diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
> index 0d111dd..03cc5b7 100644
> --- a/drivers/staging/poch/poch.c
> +++ b/drivers/staging/poch/poch.c
> @@ -979,9 +979,10 @@ static unsigned int poch_poll(struct file *filp, poll_table *pt)
>  	return ret;
>  }
>  
> -static int poch_ioctl(struct inode *inode, struct file *filp,
> -		      unsigned int cmd, unsigned long arg)
> +static long poch_ioctl(struct file *filp, unsigned int cmd,
> +		      unsigned long arg)
>  {
> +	lock_kernel();
>  	struct channel_info *channel = filp->private_data;
>  	void __iomem *fpga = channel->fpga_iomem;
>  	void __iomem *bridge = channel->bridge_iomem;

After declarations, please.  If you're not sure about accesses to channel,
you need to separate the declarations and the initializations of the
variables. 

> @@ -1026,8 +1027,10 @@ static int poch_ioctl(struct inode *inode, struct file *filp,
>  		}
>  		break;
>  	case POCH_IOC_GET_COUNTERS:
> -		if (!access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters)))
> +		if (!access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters))) {
> +			unlock_kernel();
>  			return -EFAULT;
> +		}

In general, you want to have a single unlock/return at the end, and use
goto to get there from inside the function.  Lots of returns from the
middle of a function which takes locks can lead to grief sooner or later.
If there's only one path out, things are harder to break.

>  		spin_lock_irq(&channel->counters_lock);
>  		counters = channel->counters;
> @@ -1036,23 +1039,31 @@ static int poch_ioctl(struct inode *inode, struct file *filp,
>  
>  		ret = copy_to_user(argp, &counters,
>  				   sizeof(struct poch_counters));
> -		if (ret)
> +		if (ret) {
> +			unlock_kernel();
>  			return ret;
> +		}
>  
>  		break;
>  	case POCH_IOC_SYNC_GROUP_FOR_USER:
>  	case POCH_IOC_SYNC_GROUP_FOR_DEVICE:
>  		vms = find_vma(current->mm, arg);
> -		if (!vms)
> +		if (!vms) {
> +			unlock_kernel();
>  			/* Address not mapped. */
>  			return -EINVAL;
> -		if (vms->vm_file != filp)
> +		}
> +		if (vms->vm_file != filp) {
> +			unlock_kernel();
>  			/* Address mapped from different device/file. */
>  			return -EINVAL;
> +		}
>  
>  		flush_cache_range(vms, arg, arg + channel->group_size);
>  		break;
>  	}
> +
> +	unlock_kernel();
>  	return 0;
>  }

This driver looks like it has other locking problems, incidentally; it has
a spinlock for its counters, but there's nothing serializing access to the
device registers.

jon
