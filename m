Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYHZV3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYHZV3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 17:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYHZV3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 17:29:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47793 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYHZV3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 17:29:46 -0400
Date: Tue, 26 Aug 2008 16:29:45 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zohar@us.ibm.com, dvelarde@us.ibm.com,
       safford@us.ibm.com
Subject: Re: [PATCH][resubmit] TPM: update char dev BKL pushdown
Message-ID: <20080826212945.GA13435@us.ibm.com>
References: <1219784185.4768.6.camel@blackbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219784185.4768.6.camel@blackbox>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> Now considering the num_opens to is_open change and the use of atomic_set
> instead of atomic_dec and atomic_inc. This also includes additional comments on
> tpm_open.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

In the future, though, please do keep a more complete intro that
you always send with patch resends - because not everyone will
know the history - and a detailed changelog - since some people
do.

thanks,
-serge

> ---
>  drivers/char/tpm/tpm.c |   35 ++++++++++++++++++-----------------
>  drivers/char/tpm/tpm.h |    2 +-
>  2 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index ae766d8..09829f3 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -954,13 +954,16 @@ EXPORT_SYMBOL_GPL(tpm_store_cancel);
> 
>  /*
>   * Device file system interface to the TPM
> + *
> + * It's assured that the chip will be opened just once,
> + * by the check of is_open variable, which is protected
> + * by driver_lock.
>   */
>  int tpm_open(struct inode *inode, struct file *file)
>  {
>  	int rc = 0, minor = iminor(inode);
>  	struct tpm_chip *chip = NULL, *pos;
> 
> -	lock_kernel();
>  	spin_lock(&driver_lock);
> 
>  	list_for_each_entry(pos, &tpm_chip_list, list) {
> @@ -975,34 +978,31 @@ int tpm_open(struct inode *inode, struct file *file)
>  		goto err_out;
>  	}
> 
> -	if (chip->num_opens) {
> +	if (atomic_read(&chip->is_open)) {
>  		dev_dbg(chip->dev, "Another process owns this TPM\n");
>  		rc = -EBUSY;
>  		goto err_out;
>  	}
> 
> -	chip->num_opens++;
> -	get_device(chip->dev);
> +	atomic_set(&chip->is_open, 1);
> +	get_device(chip->dev); /* protect from chip disappearing */
> 
>  	spin_unlock(&driver_lock);
> 
>  	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
>  	if (chip->data_buffer == NULL) {
> -		chip->num_opens--;
> +		atomic_set(&chip->is_open, 0);
>  		put_device(chip->dev);
> -		unlock_kernel();
>  		return -ENOMEM;
>  	}
> 
>  	atomic_set(&chip->data_pending, 0);
> 
>  	file->private_data = chip;
> -	unlock_kernel();
>  	return 0;
> 
>  err_out:
>  	spin_unlock(&driver_lock);
> -	unlock_kernel();
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_open);
> @@ -1016,7 +1016,7 @@ int tpm_release(struct inode *inode, struct file *file)
>  	file->private_data = NULL;
>  	del_singleshot_timer_sync(&chip->user_read_timer);
>  	atomic_set(&chip->data_pending, 0);
> -	chip->num_opens--;
> +	atomic_set(&chip->is_open, 0);
>  	put_device(chip->dev);
>  	kfree(chip->data_buffer);
>  	spin_unlock(&driver_lock);
> @@ -1082,7 +1082,12 @@ ssize_t tpm_read(struct file *file, char __user *buf,
>  	return ret_size;
>  }
>  EXPORT_SYMBOL_GPL(tpm_read);
> -
> +/*
> + *   Called on unloading the driver.
> + *
> + *   First part unloading the chip is done here. The remainder
> + *   is done, when the device count reaches 0, in tpm_dev_release().
> + */
>  void tpm_remove_hardware(struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
> @@ -1231,20 +1236,16 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
>  		return NULL;
>  	}
> 
> -	spin_lock(&driver_lock);
> -
> -	list_add(&chip->list, &tpm_chip_list);
> -
> -	spin_unlock(&driver_lock);
> -
>  	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
> -		list_del(&chip->list);
>  		misc_deregister(&chip->vendor.miscdev);
>  		put_device(chip->dev);
>  		return NULL;
>  	}
> 
>  	chip->bios_dir = tpm_bios_log_setup(devname);
> +	spin_lock(&driver_lock);
> +	list_add(&chip->list, &tpm_chip_list);
> +	spin_unlock(&driver_lock);
> 
>  	return chip;
>  }
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index e885148..7e0d3fb 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -90,7 +90,7 @@ struct tpm_chip {
>  	struct device *dev;	/* Device stuff */
> 
>  	int dev_num;		/* /dev/tpm# */
> -	int num_opens;		/* only one allowed */
> +	atomic_t is_open;	/* only one allowed */
>  	int time_expired;
> 
>  	/* Data passed to and from the tpm via the read/write calls */
> -- 
> 1.5.4.5
> 
> 
