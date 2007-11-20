Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbXKTGiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbXKTGiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXKTGiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:38:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527AbXKTGiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:38:00 -0500
Date: Mon, 19 Nov 2007 22:37:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard MUSIL <richard.musil@st.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpm@selhorst.net>
Subject: Re: [PATCH] - TPM device driver layer (tpm.c|h) - repost
Message-Id: <20071119223746.5f0e938f.akpm@linux-foundation.org>
In-Reply-To: <46F909CA.3030101@st.com>
References: <46CD497F.8030207@st.com>
	<20070823092604.GA6057@kroah.com>
	<46F909CA.3030101@st.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 15:14:50 +0200 Richard MUSIL <richard.musil@st.com> wrote:

> Hello all,
> 
> sometime ago I submitted patch to TPM layer, originally I thought this
> patch could be accepted into kernel (see below). However,
> since this did not happen, I wonder, if there are some problems with the
> patch or whether I am expected to do/provide something else, in order to
> have it accepted.
> 
> The patch follows even more below.
> 

Thanks.  We prefer that contributors sign off their work as per
Documentation/SubmittingPatches.  Please review that and if agrereable,
send a Signed-off-by: for this work.

>  /*
> + * Once all references to platform device are down to 0,
> + * release all allocated structures.
> + * In case vendor provided release function,
> + * call it too.
> + */
> +static void tpm_dev_release(struct device *dev)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +	/* call vendor release, if defined */

That's not the most useful of comments ;)

> +	if (chip->vendor.release)
> +		chip->vendor.release(dev);
> +
> +	/* it *should* be: chip->release != NULL */

And that one's actually wrong in the context of kernel coding practices. 
But whatever.

> +	if (likely(chip->release))
> +		chip->release(dev);

>From my reading, neither of these fields can ever be NULL, so the tests
simply aren't needed?

> +	clear_bit(chip->dev_num, dev_mask);
> +	kfree(chip->vendor.miscdev.name);
> +	kfree(chip);
> +}
> +
> +/*
>   * Called from tpm_<specific>.c probe function only for devices 
>   * the driver has determined it should claim.  Prior to calling
>   * this function the specific probe function has called pci_enable_device
> @@ -1136,23 +1153,21 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
>  
>  	chip->vendor.miscdev.parent = dev;
>  	chip->dev = get_device(dev);
> +	chip->release = dev->release;
> +	dev->release = tpm_dev_release;
> +	dev_set_drvdata(dev, chip);
>  
>  	if (misc_register(&chip->vendor.miscdev)) {
>  		dev_err(chip->dev,
>  			"unable to misc_register %s, minor %d\n",
>  			chip->vendor.miscdev.name,
>  			chip->vendor.miscdev.minor);
> -		put_device(dev);
> -		clear_bit(chip->dev_num, dev_mask);
> -		kfree(chip);
> -		kfree(devname);
> +		put_device(chip->dev);
>  		return NULL;
>  	}
>  
>  	spin_lock(&driver_lock);
>  
> -	dev_set_drvdata(dev, chip);
> -
>  	list_add(&chip->list, &tpm_chip_list);
>  
>  	spin_unlock(&driver_lock);
> @@ -1160,10 +1175,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
>  	if (sysfs_create_group(&dev->kobj, chip->vendor.attr_group)) {
>  		list_del(&chip->list);
>  		misc_deregister(&chip->vendor.miscdev);
> -		put_device(dev);
> -		clear_bit(chip->dev_num, dev_mask);
> -		kfree(chip);
> -		kfree(devname);
> +		put_device(chip->dev);
>  		return NULL;
>  	}
>  
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index b2e2b00..f1c265e 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -74,6 +74,7 @@ struct tpm_vendor_specific {
>  	int (*send) (struct tpm_chip *, u8 *, size_t);
>  	void (*cancel) (struct tpm_chip *);
>  	u8 (*status) (struct tpm_chip *);
> +	void (*release) (struct device *);
>  	struct miscdevice miscdev;
>  	struct attribute_group *attr_group;
>  	struct list_head list;
> @@ -106,6 +107,7 @@ struct tpm_chip {
>  	struct dentry **bios_dir;
>  
>  	struct list_head list;
> +	void (*release) (struct device *);
>  };
>  
>  #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)

