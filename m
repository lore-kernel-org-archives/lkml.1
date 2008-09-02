Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYIBPDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYIBPDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYIBPDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:03:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55549 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbYIBPDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:03:33 -0400
Date: Tue, 2 Sep 2008 10:03:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmoriss@namei.org>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Peter Dolding <oiaohm@gmail.com>, Kenneth Goldman <kgoldman@us.ibm.com>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Pavel Machek <pavel@suse.cz>,
       Greg KH <greg@kroah.com>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] TPM: update char dev BKL pushdown
Message-ID: <20080902150320.GB8524@us.ibm.com>
References: <cover.1220065144.git.srajiv@linux.vnet.ibm.com> <9e39ed5efc804fac7111bb94ea2eaf6b25e7c339.1220065144.git.srajiv@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e39ed5efc804fac7111bb94ea2eaf6b25e7c339.1220065144.git.srajiv@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> This patch removes the BKL calls from the TPM driver, which
> were added in the overall misc-char-dev-BKL-pushdown.patch,
> as they are not needed.  In addition, renames num_open to
> is_open, as only one process can open the file at a time.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  drivers/char/tpm/tpm.c |   35 ++++++++++++++++++-----------------
>  drivers/char/tpm/tpm.h |    2 +-
>  2 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index ae766d8..59b31e1 100644
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
> +	if (chip->is_open) {
>  		dev_dbg(chip->dev, "Another process owns this TPM\n");
>  		rc = -EBUSY;
>  		goto err_out;
>  	}
> 
> -	chip->num_opens++;
> -	get_device(chip->dev);
> +	chip->is_open = 1;
> +	get_device(chip->dev); /* protect from chip disappearing */
> 
>  	spin_unlock(&driver_lock);
> 
>  	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
>  	if (chip->data_buffer == NULL) {
> -		chip->num_opens--;
> +		chip->is_open = 0;
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
> +	chip->is_open = 0;
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
> index e885148..2756cab 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -90,7 +90,7 @@ struct tpm_chip {
>  	struct device *dev;	/* Device stuff */
> 
>  	int dev_num;		/* /dev/tpm# */
> -	int num_opens;		/* only one allowed */
> +	unsigned long is_open;	/* only one allowed */
>  	int time_expired;
> 
>  	/* Data passed to and from the tpm via the read/write calls */
> -- 
> 1.5.6.3
