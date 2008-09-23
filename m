Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYIWSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYIWSTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYIWST3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:19:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48733 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbYIWST2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:19:28 -0400
Date: Tue, 23 Sep 2008 11:19:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jmoriss@namei.org,
       serue@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com, debora@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] TPM: rcu locking
Message-ID: <20080923181922.GE6637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com> <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 02:19:28PM -0300, Rajiv Andrade wrote:
> Protects tpm_chip_list when transversing it.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Question below...

> ---
>  drivers/char/tpm/tpm.c |   58 ++++++++++++++++++-----------------------------
>  1 files changed, 22 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index dfd4e7f..ac8982e 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -961,33 +961,27 @@ EXPORT_SYMBOL_GPL(tpm_store_cancel);
>   */
>  int tpm_open(struct inode *inode, struct file *file)
>  {
> -	int rc = 0, minor = iminor(inode);
> +	int minor = iminor(inode);
>  	struct tpm_chip *chip = NULL, *pos;
> 
> -	spin_lock(&driver_lock);
> -
> -	list_for_each_entry(pos, &tpm_chip_list, list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {

Here we are traversing starting at a global tpm_chip_list...

>  		if (pos->vendor.miscdev.minor == minor) {
>  			chip = pos;
> +			get_device(chip->dev);
>  			break;
>  		}
>  	}
> +	rcu_read_unlock();
> 
> -	if (chip == NULL) {
> -		rc = -ENODEV;
> -		goto err_out;
> -	}
> +	if (!chip)
> +		return -ENODEV;
> 
>  	if (test_and_set_bit(0, &chip->is_open)) {
>  		dev_dbg(chip->dev, "Another process owns this TPM\n");
> -		rc = -EBUSY;
> -		goto err_out;
> +		return -EBUSY;
>  	}
> 
> -	get_device(chip->dev);
> -
> -	spin_unlock(&driver_lock);
> -
>  	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
>  	if (chip->data_buffer == NULL) {
>  		clear_bit(0, &chip->is_open);
> @@ -999,26 +993,23 @@ int tpm_open(struct inode *inode, struct file *file)
> 
>  	file->private_data = chip;
>  	return 0;
> -
> -err_out:
> -	spin_unlock(&driver_lock);
> -	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_open);
> 
> +/*
> + * Called on file close
> + */
>  int tpm_release(struct inode *inode, struct file *file)
>  {
>  	struct tpm_chip *chip = file->private_data;
> 
>  	flush_scheduled_work();
> -	spin_lock(&driver_lock);
>  	file->private_data = NULL;
>  	del_singleshot_timer_sync(&chip->user_read_timer);
>  	atomic_set(&chip->data_pending, 0);
> +	kfree(chip->data_buffer);
>  	clear_bit(0, &chip->is_open);
>  	put_device(chip->dev);
> -	kfree(chip->data_buffer);
> -	spin_unlock(&driver_lock);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(tpm_release);
> @@ -1092,13 +1083,11 @@ void tpm_remove_hardware(struct device *dev)
>  	}
> 
>  	spin_lock(&driver_lock);
> -
> -	list_del(&chip->list);
> -
> +	list_del_rcu(&chip->list);

But here we are deleting from what appears to be some other list.
And I don't see any insertiong into either list.

What am I missing here?

							Thanx, Paul

>  	spin_unlock(&driver_lock);
> +	synchronize_rcu();
> 
>  	misc_deregister(&chip->vendor.miscdev);
> -
>  	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
>  	tpm_bios_log_teardown(chip->bios_dir);
> 
> @@ -1146,8 +1135,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
>  /*
>   * Once all references to platform device are down to 0,
>   * release all allocated structures.
> - * In case vendor provided release function,
> - * call it too.
> + * In case vendor provided release function, call it too.
>   */
>  static void tpm_dev_release(struct device *dev)
>  {
> @@ -1155,7 +1143,6 @@ static void tpm_dev_release(struct device *dev)
> 
>  	if (chip->vendor.release)
>  		chip->vendor.release(dev);
> -
>  	chip->release(dev);
> 
>  	clear_bit(chip->dev_num, dev_mask);
> @@ -1170,8 +1157,8 @@ static void tpm_dev_release(struct device *dev)
>   * upon errant exit from this function specific probe function should call
>   * pci_disable_device
>   */
> -struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vendor_specific
> -				       *entry)
> +struct tpm_chip *tpm_register_hardware(struct device *dev,
> +		const struct tpm_vendor_specific *entry)
>  {
>  #define DEVNAME_SIZE 7
> 
> @@ -1230,12 +1217,6 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
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
>  		list_del(&chip->list);
>  		misc_deregister(&chip->vendor.miscdev);
> @@ -1245,6 +1226,11 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
> 
>  	chip->bios_dir = tpm_bios_log_setup(devname);
> 
> +	/* Make chip available */
> +	spin_lock(&driver_lock);
> +	list_add(&chip->list, &tpm_chip_list);
> +	spin_unlock(&driver_lock);
> +
>  	return chip;
>  }
>  EXPORT_SYMBOL_GPL(tpm_register_hardware);
> -- 
> 1.5.6.3
> 
