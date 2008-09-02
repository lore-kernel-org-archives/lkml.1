Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbYIBPTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbYIBPTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYIBPTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:19:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60074 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYIBPTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:19:35 -0400
Date: Tue, 2 Sep 2008 10:19:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmoriss@namei.org>, Peter Dolding <oiaohm@gmail.com>,
       Kenneth Goldman <kgoldman@us.ibm.com>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Pavel Machek <pavel@suse.cz>,
       Greg KH <greg@kroah.com>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] TPM: rcu locking
Message-ID: <20080902151912.GC8524@us.ibm.com>
References: <cover.1220065144.git.srajiv@linux.vnet.ibm.com> <5cc709bcd66c62c9e55c9bd10788fbb27efb3ede.1220065144.git.srajiv@linux.vnet.ibm.com> <20080831202808.GK7015@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831202808.GK7015@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul E. McKenney (paulmck@linux.vnet.ibm.com):
> On Sat, Aug 30, 2008 at 12:05:04AM -0300, Rajiv Andrade wrote:
> > Continue to protect the tpm_chip_list using the driver_lock
> > as before, and add an rcu to protect readers.
> 
> A few questions interspersed below...
> 
> 							Thanx, Paul
> 
> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> > ---
> >  drivers/char/tpm/tpm.c |  268 ++++++++++++++++++++++++++++++++----------------
> >  1 files changed, 178 insertions(+), 90 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> > index 59b31e1..704ab01 100644
> > --- a/drivers/char/tpm/tpm.c
> > +++ b/drivers/char/tpm/tpm.c
> > @@ -587,14 +587,22 @@ ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
> >  {
> >  	u8 *data;
> >  	ssize_t rc;
> > +	struct tpm_chip *chip;
> > +
> 
> The following five lines of code appear repeatedly.  Why not put them
> into an inline function or a macro?

Yes, a good idea, because in the second repetition of this code sequence
you have the wrong set of gotos, and can end up doing
put_device(chip->dev) when dev is NULL  :)

> Also, doesn't there need to be an rcu_dereference() somewhere either in
> this sequence of code or in either dev_get_drvdata() or get_device()?
> Or am I missing something subtle here?
> 
> >From what I see of the code, I actually don't understand why the
> rcu_read_lock() is needed here -- only tpm_chip_list is covered by

Good point.  Which I missed entirely when I saw the patch before.

Taking the case of tpm_show_enabled(), it is called as a sysfs file
callback, right?  So the sysfs/kobject infrastructure will pin the
device for the duration of the callback I presume?

> the RCU list addition/deletion primitives in this patch.  If you are
> adding a multilinked data structure into an RCU-protected list, you
> need RCU traversal primitives only when traversing the list, not the
> data structure contained in the list.  (Of course, any changes to the
> data structure contained in the list must be protected somehow or other,
> unless there are no such changes.)
> 
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
> > @@ -603,13 +611,15 @@ ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
> >  	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  			"attemtping to determine the permanent enabled state");
> >  	if (rc) {
> > -		kfree(data);
> > -		return 0;
> > +		rc = 0;
> > +		goto out;
> >  	}
> > 
> >  	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
> > -
> > +out:
> >  	kfree(data);
> > +out_alloc:
> > +	put_device(chip->dev);
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_enabled);
> > @@ -619,14 +629,24 @@ ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
> >  {
> >  	u8 *data;
> >  	ssize_t rc;
> > +	struct tpm_chip *chip;
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> > -	if (chip == NULL)
> > -		return -ENODEV;
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > +
> > +	if (chip == NULL) {
> > +		rc = -ENODEV;
> > +		goto out_alloc;
> > +	}
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
> > @@ -635,13 +655,15 @@ ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
> >  	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  			"attemtping to determine the permanent active state");
> >  	if (rc) {
> > -		kfree(data);
> > -		return 0;
> > +		rc = 0;
> > +		goto out;
> >  	}
> > 
> >  	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
> > -
> > +out:
> >  	kfree(data);
> > +out_alloc:
> > +	put_device(chip->dev);
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_active);
> > @@ -651,14 +673,22 @@ ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
> >  {
> >  	u8 *data;
> >  	ssize_t rc;
> > +	struct tpm_chip *chip;
> > +
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
> > @@ -667,13 +697,15 @@ ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
> >  	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  			"attempting to determine the owner state");
> >  	if (rc) {
> > -		kfree(data);
> > -		return 0;
> > +		rc = 0;
> > +		goto out;
> >  	}
> > 
> >  	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
> > -
> > +out:
> >  	kfree(data);
> > +out_alloc:
> > +	put_device(chip->dev);
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_owned);
> > @@ -683,14 +715,22 @@ ssize_t tpm_show_temp_deactivated(struct device * dev,
> >  {
> >  	u8 *data;
> >  	ssize_t rc;
> > +	struct tpm_chip *chip;
> > +
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
> > @@ -699,13 +739,15 @@ ssize_t tpm_show_temp_deactivated(struct device * dev,
> >  	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  			"attempting to determine the temporary state");
> >  	if (rc) {
> > -		kfree(data);
> > -		return 0;
> > +		rc = 0;
> > +		goto out;
> >  	}
> > 
> >  	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
> > -
> > +out:
> >  	kfree(data);
> > +out_alloc:
> > +	put_device(chip->dev);
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
> > @@ -725,14 +767,22 @@ ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
> >  	int i, j, num_pcrs;
> >  	__be32 index;
> >  	char *str = buf;
> > +	struct tpm_chip *chip;
> > +
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
> > @@ -741,8 +791,8 @@ ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
> >  	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  			"attempting to determine the number of PCRS");
> >  	if (rc) {
> > -		kfree(data);
> > -		return 0;
> > +		rc = 0;
> > +		goto out;
> >  	}
> > 
> >  	num_pcrs = be32_to_cpu(*((__be32 *) (data + 14)));
> > @@ -753,15 +803,18 @@ ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
> >  		rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  				"attempting to read a PCR");
> >  		if (rc)
> > -			goto out;
> > +			break;
> >  		str += sprintf(str, "PCR-%02d: ", i);
> >  		for (j = 0; j < TPM_DIGEST_SIZE; j++)
> >  			str += sprintf(str, "%02X ", *(data + 10 + j));
> >  		str += sprintf(str, "\n");
> >  	}
> > +	rc = str - buf;
> >  out:
> >  	kfree(data);
> > -	return str - buf;
> > +out_alloc:
> > +	put_device(chip->dev);
> > +	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_pcrs);
> > 
> > @@ -779,21 +832,31 @@ ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
> >  	ssize_t err;
> >  	int i, rc;
> >  	char *str = buf;
> > +	struct tpm_chip *chip;
> > +
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(READ_PUBEK_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, readpubek, sizeof(readpubek));
> > 
> >  	err = transmit_cmd(chip, data, READ_PUBEK_RESULT_SIZE,
> >  			"attempting to read the PUBEK");
> > -	if (err)
> > +	if (err) {
> > +		rc = str - buf;
> >  		goto out;
> > +	}
> > 
> >  	/* 
> >  	   ignore header 10 bytes
> > @@ -823,9 +886,11 @@ ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
> >  		if ((i + 1) % 16 == 0)
> >  			str += sprintf(str, "\n");
> >  	}
> > -out:
> >  	rc = str - buf;
> > +out:
> >  	kfree(data);
> > +out_alloc:
> > +	put_device(chip->dev);
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_pubek);
> > @@ -847,14 +912,22 @@ ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
> >  	u8 *data;
> >  	ssize_t rc;
> >  	char *str = buf;
> > +	struct tpm_chip *chip;
> > +
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
> > @@ -863,8 +936,8 @@ ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
> >  	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  			"attempting to determine the manufacturer");
> >  	if (rc) {
> > -		kfree(data);
> > -		return 0;
> > +		rc = 0;
> > +		goto out;
> >  	}
> > 
> >  	str += sprintf(str, "Manufacturer: 0x%x\n",
> > @@ -874,17 +947,22 @@ ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
> >  	data[CAP_VERSION_IDX] = CAP_VERSION_1_1;
> >  	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
> >  			"attempting to determine the 1.1 version");
> > -	if (rc)
> > +	if (rc) {
> > +		rc = str - buf;
> >  		goto out;
> > +	}
> > 
> >  	str += sprintf(str,
> >  		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
> >  		       (int) data[14], (int) data[15], (int) data[16],
> >  		       (int) data[17]);
> > 
> > +	rc = str - buf;
> >  out:
> >  	kfree(data);
> > -	return str - buf;
> > +out_alloc:
> > +	put_device(chip->dev);
> > +	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_caps);
> > 
> > @@ -892,16 +970,25 @@ ssize_t tpm_show_caps_1_2(struct device * dev,
> >  			  struct device_attribute * attr, char *buf)
> >  {
> >  	u8 *data;
> > +	ssize_t rc;
> >  	ssize_t len;
> >  	char *str = buf;
> > +	struct tpm_chip *chip;
> > +
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> > 
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> >  	if (chip == NULL)
> >  		return -ENODEV;
> > 
> >  	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
> > -	if (!data)
> > -		return -ENOMEM;
> > +	if (!data) {
> > +		rc = -ENOMEM;
> > +		goto out_alloc;
> > +	}
> > 
> >  	memcpy(data, tpm_cap, sizeof(tpm_cap));
> >  	data[TPM_CAP_IDX] = TPM_CAP_PROP;
> > @@ -913,7 +1000,8 @@ ssize_t tpm_show_caps_1_2(struct device * dev,
> >  			"attempting to determine the manufacturer\n",
> >  			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
> >  		kfree(data);
> > -		return 0;
> > +		rc = 0;
> > +		goto out;
> >  	}
> > 
> >  	str += sprintf(str, "Manufacturer: 0x%x\n",
> > @@ -927,6 +1015,7 @@ ssize_t tpm_show_caps_1_2(struct device * dev,
> >  		dev_err(chip->dev, "A TPM error (%d) occurred "
> >  			"attempting to determine the 1.2 version\n",
> >  			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
> > +		rc = str - buf;
> >  		goto out;
> >  	}
> >  	str += sprintf(str,
> > @@ -934,20 +1023,29 @@ ssize_t tpm_show_caps_1_2(struct device * dev,
> >  		       (int) data[16], (int) data[17], (int) data[18],
> >  		       (int) data[19]);
> > 
> > +	rc = str - buf;
> >  out:
> >  	kfree(data);
> > -	return str - buf;
> > +out_alloc:
> > +	put_device(chip->dev);
> > +	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
> > 
> >  ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
> >  			const char *buf, size_t count)
> >  {
> > -	struct tpm_chip *chip = dev_get_drvdata(dev);
> > +	struct tpm_chip *chip;
> > +
> > +	rcu_read_lock();
> > +	chip = dev_get_drvdata(dev);
> > +	if (chip)
> > +		get_device(chip->dev);	/* protect from disappearing */
> > +	rcu_read_unlock();
> >  	if (chip == NULL)
> >  		return 0;
> > -
> >  	chip->vendor.cancel(chip);
> > +	put_device(chip->dev);
> >  	return count;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_store_cancel);
> > @@ -956,70 +1054,59 @@ EXPORT_SYMBOL_GPL(tpm_store_cancel);
> >   * Device file system interface to the TPM
> >   *
> >   * It's assured that the chip will be opened just once,
> > - * by the check of is_open variable, which is protected
> > - * by driver_lock.
> > + * by the check of is_open variable.
> >   */
> >  int tpm_open(struct inode *inode, struct file *file)
> >  {
> > -	int rc = 0, minor = iminor(inode);
> > +	int minor = iminor(inode);
> >  	struct tpm_chip *chip = NULL, *pos;
> > 
> > -	spin_lock(&driver_lock);
> > -
> > -	list_for_each_entry(pos, &tpm_chip_list, list) {
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
> >  		if (pos->vendor.miscdev.minor == minor) {
> >  			chip = pos;
> > +			get_device(chip->dev); /* protect from disappearing */
> >  			break;
> >  		}
> >  	}
> > +	rcu_read_unlock();
> > +	if (!chip)
> > +		return -ENODEV;
> > 
> > -	if (chip == NULL) {
> > -		rc = -ENODEV;
> > -		goto err_out;
> > -	}
> > -
> > -	if (chip->is_open) {
> > +	if (!test_and_set_bit(0, &chip->is_open)) {
> >  		dev_dbg(chip->dev, "Another process owns this TPM\n");
> > -		rc = -EBUSY;
> > -		goto err_out;
> > +		return -EBUSY;
> >  	}
> > 
> > -	chip->is_open = 1;
> > -	get_device(chip->dev); /* protect from chip disappearing */
> > -
> > -	spin_unlock(&driver_lock);
> > -
> >  	chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
> >  	if (chip->data_buffer == NULL) {
> > -		chip->is_open = 0;
> > +		clear_bit(0, &chip->is_open);
> >  		put_device(chip->dev);
> >  		return -ENOMEM;
> >  	}
> > 
> >  	atomic_set(&chip->data_pending, 0);
> > -
> >  	file->private_data = chip;
> >  	return 0;
> > -
> > -err_out:
> > -	spin_unlock(&driver_lock);
> > -	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_open);
> > 
> > +/*
> > + * Called on file close
> > + */
> >  int tpm_release(struct inode *inode, struct file *file)
> >  {
> >  	struct tpm_chip *chip = file->private_data;
> > 
> >  	flush_scheduled_work();
> > -	spin_lock(&driver_lock);
> >  	file->private_data = NULL;
> >  	del_singleshot_timer_sync(&chip->user_read_timer);
> >  	atomic_set(&chip->data_pending, 0);
> > -	chip->is_open = 0;
> > -	put_device(chip->dev);
> >  	kfree(chip->data_buffer);
> > -	spin_unlock(&driver_lock);
> > +
> > +	clear_bit(0, &chip->is_open);
> > +
> > +	put_device(chip->dev);
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_release);
> > @@ -1082,6 +1169,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
> >  	return ret_size;
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_read);
> > +
> >  /*
> >   *   Called on unloading the driver.
> >   *
> > @@ -1098,13 +1186,11 @@ void tpm_remove_hardware(struct device *dev)
> >  	}
> > 
> >  	spin_lock(&driver_lock);
> > -
> > -	list_del(&chip->list);
> > -
> > +	list_del_rcu(&chip->list);
> >  	spin_unlock(&driver_lock);
> > +	synchronize_rcu();
> > 
> >  	misc_deregister(&chip->vendor.miscdev);
> > -
> >  	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
> >  	tpm_bios_log_teardown(chip->bios_dir);
> > 
> > @@ -1152,8 +1238,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_resume);
> >  /*
> >   * Once all references to platform device are down to 0,
> >   * release all allocated structures.
> > - * In case vendor provided release function,
> > - * call it too.
> > + * In case vendor provided release function, call it too.
> >   */
> >  static void tpm_dev_release(struct device *dev)
> >  {
> > @@ -1176,8 +1261,8 @@ static void tpm_dev_release(struct device *dev)
> >   * upon errant exit from this function specific probe function should call
> >   * pci_disable_device
> >   */
> > -struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vendor_specific
> > -				       *entry)
> > +struct tpm_chip *tpm_register_hardware(struct device *dev,
> > +		const struct tpm_vendor_specific *entry)
> >  {
> >  #define DEVNAME_SIZE 7
> > 
> > @@ -1243,9 +1328,12 @@ struct tpm_chip *tpm_register_hardware(struct device *dev, const struct tpm_vend
> >  	}
> > 
> >  	chip->bios_dir = tpm_bios_log_setup(devname);
> > +
> > +	/* Make chip available */
> >  	spin_lock(&driver_lock);
> > -	list_add(&chip->list, &tpm_chip_list);
> > +	list_add_rcu(&chip->list, &tpm_chip_list);
> >  	spin_unlock(&driver_lock);
> > +	synchronize_rcu();
> 
> The above synchronize_rcu() is not needed -- unless it is required that
> tpm_register_hardware() not return until it can be guaranteed that all
> subsequent readers will see the new entry.  (Of course, the current
> CPU/task is guaranteed to see it in any subsequent call, even without
> the synchronize_rcu().)
> 
> >  	return chip;
> >  }
> > -- 
> > 1.5.6.3
> > 
