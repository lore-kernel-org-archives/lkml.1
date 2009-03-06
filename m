Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZCFWOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZCFWOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZCFWOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:14:07 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:34221 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755738AbZCFWOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:14:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RrFLubHayiXmh81ATGyxTl7AwEmPFBqZCeTs8g3fwZzp6BWBL80s64X8kfN+Z2F9plkLCnrPemNXgw/lJQhadDMHJK2nVWTydkxL/r0dqbjvgCpEp8J1JWaltv5PVYrZ9LdrE9EdD1bWeLCG2fjLQUs6esCb/TN5YVeE4vxQl4s=  ;
X-YMail-OSG: T3fTC44VM1klrbYBtS0S4hEZsD4dE4NcWan.W8mtNFNba_MUSlrJZNCk6RE7Uf5hxVKO21cTxgmd.2Og5M89DiXpa2M39x4nP9QvlYUNInz3EeciHowmLcIkMxxCQ5Aqn5HBxGbjlU2YLepHZ7LRnWZIliyFX_EC.P9BWXuL8woErXV0I8MRC2KOcLnaDhlxwrOabXdhCe9kEpypRnGue2r5vVBLOZiR8ND3Yw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] eeprom: add kernel interface for reading/writing persistent memory
Date: Fri, 6 Mar 2009 14:10:56 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1236281608-18063-1-git-send-email-khilman@deeprootsystems.com>
In-Reply-To: <1236281608-18063-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061410.56807.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009, Kevin Hilman wrote:
> This patch adds an interface by which other kernel code can read/write
> persistent memory such as i2c or SPI EEPROMs.

Use cases include storage of board-specific configuration
data like Ethernet addresses and sensor calibrations, as
you noted in the at24 updates ... probably worth mentioning
that in the interface patch, since that's as far as many
folk will ever read.

The same interface can work with NVRAM, which a lot of
RTC chips provide.  Another use case would be supporting
a more platform-agnostic solution for what PM_TRACE_RTC
does for x86 ... and without trashing RTC state and thus
screwing up reboots.  


> In additon, the at24 EEPROM driver is updated to use this interface.
> 
> In the case of at24 EEPROM, the platform code registers a 'setup'
> callback with the at24_platform_data.  When the at24 driver detects an
> EEPROM, it fills out the read and write functions of the
> memory_accessor and calls the setup callback passing the
> memory_accessor struct.  The platform code can then use the read/write
> functions in the memory_accessor struct for reading and writing the
> EEPROM.

I don't have any particular issue seeing the interface and
its first implementation in the same patch, but $SUBJECT
should say so if that's what you're doing.  :)

Better would be a short set of patches.  I'll send an at25
driver update in a moment, which could be the third in that
little series.

 
> Original idea, review and updates by David Brownell <david-b@pacbell.net>
>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

I have no particular issues with this interface, but
there are a few ways the at24 part could be improved;
see below.  At any rate, for the interface part:

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> Applies against v2.6.29-rc7
> 
>  drivers/misc/eeprom/at24.c |   42 +++++++++++++++++++++++++++++++++++-------
>  include/linux/i2c/at24.h   |    4 ++++
>  include/linux/memory.h     |   11 +++++++++++
>  3 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> index d477552..80bf7ab 100644
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -53,6 +53,7 @@
>  
>  struct at24_data {
>  	struct at24_platform_data chip;
> +	struct memory_accessor macc;
>  	bool use_smbus;
>  
>  	/*
> @@ -264,13 +265,6 @@ static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
>  
>  
>  /*
> - * REVISIT: export at24_bin{read,write}() to let other kernel code use
> - * eeprom data. For example, it might hold a board's Ethernet address, or
> - * board-specific calibration data generated on the manufacturing floor.
> - */
> -
> -
> -/*
>   * Note that if the hardware write-protect pin is pulled high, the whole
>   * chip is normally write protected. But there are plenty of product
>   * variants here, including OTP fuses and partial chip protect.
> @@ -386,6 +380,30 @@ static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
>  
>  /*-------------------------------------------------------------------------*/
>  
> +/*
> + * This lets other kernel code access the eeprom data. For example, it
> + * might hold a board's Ethernet address, or board-specific calibration
> + * data generated on the manufacturing floor.
> + */
> +
> +static ssize_t at24_read(struct memory_accessor *macc, char *buf,
> +			 off_t offset, size_t count)
> +{
> +	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
> +
> +	return at24_eeprom_read(at24, buf, offset, count);

The at24_bin_read() routine does two things that this doesn't:

 - compensate at24_eeprom_read() possibly returning just a
   byte (e.g. on SMBUS-only hardware) by issuing many reads

 - range checking the parameters

I suspect both the sysfs and in-kernel accessor should call a
common routine, which handles those issues.


> +}
> +
> +static ssize_t at24_write(struct memory_accessor *macc, char *buf,
> +			  off_t offset, size_t count)
> +{
> +	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
> +
> +	return at24_eeprom_write(at24, buf, offset, count);

Same kind of issue here, too.  Although for writes there are
some extra reasons for the lower level routine not to handle
the whole buffer:  EEPROM page sizes can be a lot smaller
than the data chunks, and data can cross page boundaries.



> +}
> +
> +/*-------------------------------------------------------------------------*/
> +
>  static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
>  	struct at24_platform_data chip;
> @@ -413,6 +431,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		 * is recommended anyhow.
>  		 */
>  		chip.page_size = 1;
> +
> +		chip.setup = NULL;
> +		chip.context = NULL;
>  	}
>  
>  	if (!is_power_of_2(chip.byte_len))
> @@ -449,6 +470,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		goto err_out;
>  	}
>  
> +	at24->macc.read = at24_read;
> +	at24->macc.write = at24_write;
> +
>  	mutex_init(&at24->lock);
>  	at24->use_smbus = use_smbus;
>  	at24->chip = chip;
> @@ -520,6 +544,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		at24->write_max,
>  		use_smbus ? ", use_smbus" : "");
>  
> +	/* export data to kernel code */
> +	if (chip.setup)
> +		chip.setup(&at24->macc, chip.context);

Since you're not using the return value of setup() ...

> +
>  	return 0;
>  
>  err_clients:
> diff --git a/include/linux/i2c/at24.h b/include/linux/i2c/at24.h
> index f6edd52..85b4f7e 100644
> --- a/include/linux/i2c/at24.h
> +++ b/include/linux/i2c/at24.h
> @@ -2,6 +2,7 @@
>  #define _LINUX_AT24_H
>  
>  #include <linux/types.h>
> +#include <linux/memory.h>
>  
>  /*
>   * As seen through Linux I2C, differences between the most common types of I2C
> @@ -23,6 +24,9 @@ struct at24_platform_data {
>  #define AT24_FLAG_READONLY	0x40	/* sysfs-entry will be read-only */
>  #define AT24_FLAG_IRUGO		0x20	/* sysfs-entry will be world-readable */
>  #define AT24_FLAG_TAKE8ADDR	0x10	/* take always 8 addresses (24c00) */
> +
> +	int             (*setup)(struct memory_accessor *, void *context);

... might as well declare its value as "void".


> +	void		*context;
>  };
>  
>  #endif /* _LINUX_AT24_H */
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 3fdc108..aa97724 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -99,4 +99,15 @@ enum mem_add_context { BOOT, HOTPLUG };
>  #define hotplug_memory_notifier(fn, pri) do { } while (0)
>  #endif
>  
> +/*
> + * 'struct memory_accessor' is a generic interface to provide
> + * in-kernel access to persistent memory such as i2c or SPI EEPROMs

Capitalize I2C.


> + */
> +struct memory_accessor {
> +	ssize_t (*read)(struct memory_accessor *, char *buf, off_t offset,
> +			size_t count);
> +	ssize_t (*write)(struct memory_accessor *, char *buf, off_t offset,
> +			 size_t count);
> +};

That interface suits my minimalist tendancies nicely.  ;)

Though maybe the write() should take a pointer to const data.

> +
>  #endif /* _LINUX_MEMORY_H_ */
> -- 
> 1.6.1.3
> 
> 


