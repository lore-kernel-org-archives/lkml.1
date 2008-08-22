Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYHVQTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYHVQTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYHVQTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:19:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45866 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYHVQTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:19:13 -0400
Date: Fri, 22 Aug 2008 11:19:08 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zohar@us.ibm.com, dvelarde@us.ibm.com,
       safford@us.ibm.com
Subject: Re: [PATCH] TPM: update char dev BKL pushdown
Message-ID: <20080822161908.GA24791@us.ibm.com>
References: <1219421072.4765.7.camel@blackbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219421072.4765.7.camel@blackbox>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> This patch removes the BKL calls from the TPM driver, which
> were added in the overall misc-char-dev-BKL-pushdown.patch,
> as they are not needed. Changed num_opens from an int to atomic_t.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Yes, this patch is good.  

It would also be good to rename num_opens.  Note that it is always
either 0 or 1, and indicates whether someone has opened the chip.
So 'is_open' may make more sense.

Mimi is also working on a patch (on top of this one) to use rcu
to protect chip->list, and that patch will (I hope) include an
explanation of all of the locking/protection involved.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  drivers/char/tpm/tpm.c |   22 +++++++---------------
>  drivers/char/tpm/tpm.h |    2 +-
>  2 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index ae766d8..cd4ff36 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -960,7 +960,6 @@ int tpm_open(struct inode *inode, struct file *file)
>  	int rc = 0, minor = iminor(inode);
>  	struct tpm_chip *chip = NULL, *pos;
> 
> -	lock_kernel();
>  	spin_lock(&driver_lock);
> 
>  	list_for_each_entry(pos, &tpm_chip_list, list) {
> @@ -975,34 +974,31 @@ int tpm_open(struct inode *inode, struct file *file)
>  		goto err_out;
>  	}
> 
> -	if (chip->num_opens) {
> +	if (atomic_read(&chip->num_opens)) {
>  		dev_dbg(chip->dev, "Another process owns this TPM\n");
>  		rc = -EBUSY;
>  		goto err_out;
>  	}
> 
> -	chip->num_opens++;
> +	atomic_inc(&chip->num_opens);
>  	get_device(chip->dev);
> 
>  	spin_unlock(&driver_lock);
> 
>  	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
>  	if (chip->data_buffer == NULL) {
> -		chip->num_opens--;
> +		atomic_dec(&chip->num_opens);
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
> @@ -1016,7 +1012,7 @@ int tpm_release(struct inode *inode, struct file *file)
>  	file->private_data = NULL;
>  	del_singleshot_timer_sync(&chip->user_read_timer);
>  	atomic_set(&chip->data_pending, 0);
> -	chip->num_opens--;
> +	atomic_dec(chip->num_opens);
>  	put_device(chip->dev);
>  	kfree(chip->data_buffer);
>  	spin_unlock(&driver_lock);
> @@ -1231,20 +1227,16 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
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
> index e885148..edb8ed6 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -90,7 +90,7 @@ struct tpm_chip {
>  	struct device *dev;	/* Device stuff */
> 
>  	int dev_num;		/* /dev/tpm# */
> -	int num_opens;		/* only one allowed */
> +	atomic_t num_opens;		/* only one allowed */
>  	int time_expired;
> 
>  	/* Data passed to and from the tpm via the read/write calls */
> -- 
> 1.5.4.5
> 
> 
