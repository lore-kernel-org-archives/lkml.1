Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbZCPVDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbZCPVDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbZCPVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:03:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:46695 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468AbZCPVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:03:15 -0400
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] memory_accessor: new interface for reading/writing persistent memory
References: <1236478048-11075-1-git-send-email-khilman@deeprootsystems.com>
	<200903161227.01938.david-b@pacbell.net>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 16 Mar 2009 14:03:10 -0700
In-Reply-To: <200903161227.01938.david-b@pacbell.net> (David Brownell's message of "Mon\, 16 Mar 2009 12\:27\:01 -0700")
Message-ID: <87zlflgoz5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> writes:

> I was kind of hoping you'd address the locking and chunking 
> comments I made ... I'll ack if it includes something like
> the appended patch.

Sorry, somehow I missed those comments on the first round, I will
incorporate and resubmit.

Kevin

> ---
>  drivers/misc/eeprom/at24.c |   43 ++++++++++++++++++++++++++++---------------
>  1 file changed, 28 insertions(+), 15 deletions(-)
>
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -226,14 +226,11 @@ static ssize_t at24_eeprom_read(struct a
>  		return status;
>  }
>  
> -static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
> +static ssize_t at24_read(struct at24_data *at24,
>  		char *buf, loff_t off, size_t count)
>  {
> -	struct at24_data *at24;
>  	ssize_t retval = 0;
>  
> -	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
> -
>  	if (unlikely(!count))
>  		return count;
>  
> @@ -263,6 +260,15 @@ static ssize_t at24_bin_read(struct kobj
>  	return retval;
>  }
>  
> +static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
> +		char *buf, loff_t off, size_t count)
> +{
> +	struct at24_data *at24;
> +
> +	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
> +	return at24_read(at24, buf, off, count);
> +}
> +
>  
>  /*
>   * Note that if the hardware write-protect pin is pulled high, the whole
> @@ -341,14 +347,11 @@ static ssize_t at24_eeprom_write(struct 
>  	return -ETIMEDOUT;
>  }
>  
> -static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
> +static ssize_t at24_write(struct at24_data *at24,
>  		char *buf, loff_t off, size_t count)
>  {
> -	struct at24_data *at24;
>  	ssize_t retval = 0;
>  
> -	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
> -
>  	if (unlikely(!count))
>  		return count;
>  
> @@ -378,6 +381,15 @@ static ssize_t at24_bin_write(struct kob
>  	return retval;
>  }
>  
> +static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
> +		char *buf, loff_t off, size_t count)
> +{
> +	struct at24_data *at24;
> +
> +	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
> +	return at24_write(at24, buf, off, count);
> +}
> +
>  /*-------------------------------------------------------------------------*/
>  
>  /*
> @@ -386,20 +398,20 @@ static ssize_t at24_bin_write(struct kob
>   * data generated on the manufacturing floor.
>   */
>  
> -static ssize_t at24_read(struct memory_accessor *macc, char *buf,
> +static ssize_t at24_macc_read(struct memory_accessor *macc, char *buf,
>  			 off_t offset, size_t count)
>  {
>  	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
>  
> -	return at24_eeprom_read(at24, buf, offset, count);
> +	return at24_read(at24, buf, offset, count);
>  }
>  
> -static ssize_t at24_write(struct memory_accessor *macc, char *buf,
> +static ssize_t at24_macc_write(struct memory_accessor *macc, char *buf,
>  			  off_t offset, size_t count)
>  {
>  	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
>  
> -	return at24_eeprom_write(at24, buf, offset, count);
> +	return at24_write(at24, buf, offset, count);
>  }
>  
>  /*-------------------------------------------------------------------------*/
> @@ -470,9 +482,6 @@ static int at24_probe(struct i2c_client 
>  		goto err_out;
>  	}
>  
> -	at24->macc.read = at24_read;
> -	at24->macc.write = at24_write;
> -
>  	mutex_init(&at24->lock);
>  	at24->use_smbus = use_smbus;
>  	at24->chip = chip;
> @@ -487,6 +496,8 @@ static int at24_probe(struct i2c_client 
>  	at24->bin.read = at24_bin_read;
>  	at24->bin.size = chip.byte_len;
>  
> +	at24->macc.read = at24_macc_read;
> +
>  	writable = !(chip.flags & AT24_FLAG_READONLY);
>  	if (writable) {
>  		if (!use_smbus || i2c_check_functionality(client->adapter,
> @@ -494,6 +505,8 @@ static int at24_probe(struct i2c_client 
>  
>  			unsigned write_max = chip.page_size;
>  
> +			at24->macc.write = at24_macc_write;
> +
>  			at24->bin.write = at24_bin_write;
>  			at24->bin.attr.mode |= S_IWUSR;
>  
