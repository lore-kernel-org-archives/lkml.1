Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbXJKVkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbXJKVkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbXJKVkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:40:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42026 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbXJKVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:40:02 -0400
Date: Thu, 11 Oct 2007 14:39:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: <Valdis.Kletnieks@vt.edu>, <linux-kernel@vger.kernel.org>
Subject: Re: TPM driver changes to support multiple locality
Message-Id: <20071011143917.0eb75029.randy.dunlap@oracle.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628CB9CB2@scsmsx412.amr.corp.intel.com>
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
	<27383.1192045583@turing-police.cc.vt.edu>
	<A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com>
	<20071011115429.92326cbd.randy.dunlap@oracle.com>
	<A3258B497F1C1441AD36A2E8B45FD628CB9CB2@scsmsx412.amr.corp.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 14:08:17 -0700 Agarwal, Lomesh wrote:

> Here is info. -
> 
> This patch adds multiple locality support in tpm_tis driver.

whatever that means.  I guess anyone who is familiar with TPM
knows what it means,  and others can do research to find out.
Or the patch description could add another 2 lines for it (?).


> drivers/char/tpm/tpm_tis.c |   83 ++++++++++++++++++++++++-----------
>  1 file changed, 57 insertions(+), 26 deletions(-)

Thanks for that.

> --- pristine-linux-2.6.18/drivers/char/tpm/tpm_tis.c	2006-09-19
> 20:42:06.000000000 -0700
> +++ linux-2.6.18-xen/drivers/char/tpm/tpm_tis.c	2007-10-11
> 13:28:38.000000000 -0700
> @@ -56,29 +56,37 @@ enum tis_int_flags {
>  
>  enum tis_defaults {
>  	TIS_MEM_BASE = 0xFED40000,
> -	TIS_MEM_LEN = 0x5000,
> +    TIS_LOCALITY_SHIFT = 12,

Indent above uses spaces, not tab.

> +	TIS_MEM_LEN = 0x1000,
>  	TIS_SHORT_TIMEOUT = 750,	/* ms */
>  	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
>  };
>  
> -#define	TPM_ACCESS(l)			(0x0000 | ((l) << 12))
> -#define	TPM_INT_ENABLE(l)		(0x0008 | ((l) << 12))
> -#define	TPM_INT_VECTOR(l)		(0x000C | ((l) << 12))
> -#define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
> -#define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
> -#define	TPM_STS(l)			(0x0018 | ((l) << 12))
> -#define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
> +#define	TPM_ACCESS(l)			(0x0000)
> +#define	TPM_INT_ENABLE(l)		(0x0008)
> +#define	TPM_INT_VECTOR(l)		(0x000C)
> +#define	TPM_INT_STATUS(l)		(0x0010)
> +#define	TPM_INTF_CAPS(l)		(0x0014)
> +#define	TPM_STS(l)			(0x0018)
> +#define	TPM_DATA_FIFO(l)		(0x0024)
>  
> -#define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
> -#define	TPM_RID(l)			(0x0F04 | ((l) << 12))
> +#define	TPM_DID_VID(l)			(0x0F00)
> +#define	TPM_RID(l)			(0x0F04)
>  
>  static LIST_HEAD(tis_chips);
>  static DEFINE_SPINLOCK(tis_lock);
>  
>  static int check_locality(struct tpm_chip *chip, int l)
>  {
> -	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
> -	     (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
> +    unsigned char tpm_access;

Use tab above, not spaces.

> +
> +	tpm_access = ioread8(chip->vendor.iobase + TPM_ACCESS(l));
> +
> +    /* check if locality is closed */
> +    if(tpm_access == 0xFF)

	if (

> +        return -1;

and use tab(s) for indent, not spaces.

> +
> +	if ((tpm_access & (TPM_ACCESS_ACTIVE_LOCALITY |
> TPM_ACCESS_VALID)) ==
>  	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
>  		return chip->vendor.locality = l;
>  
> @@ -251,10 +259,14 @@ static int tpm_tis_recv(struct tpm_chip 
>  
>  out:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, chip->vendor.locality, 1);
>  	return size;
>  }
>  
> +static int locality = 0;

Don't init statics to 0 or NULL (it's done for you).
(same comment as first time)


> +module_param(locality, int, 0444);
> +MODULE_PARM_DESC(locality, "TPM Locality To access");
> +
>  /*
>   * If interrupts are used (signaled by an irq set in the vendor
> structure)
>   * tpm.c can skip polling for the data to be available as the interrupt
> is
> @@ -401,7 +413,10 @@ static irqreturn_t tis_int_handler(int i
>  {
>  	struct tpm_chip *chip = (struct tpm_chip *) dev_id;
>  	u32 interrupt;
> -	int i;
> +
> +        /* check if interrupt is meant for this locality */
> +        if(check_locality(chip, locality) < 0)

	if (

and use tab(s) to indent, not spaces.

> +            return IRQ_NONE;
>  
>  	interrupt = ioread32(chip->vendor.iobase +
>  			     TPM_INT_STATUS(chip->vendor.locality));
> @@ -490,8 +501,9 @@ static int tpm_tis_init(struct device *d
>  	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
>  		dev_dbg(dev, "\tData Avail Int Support\n");
>  
> -	if (request_locality(chip, 0) != 0) {
> -		rc = -ENODEV;
> +	if (request_locality(chip, locality) < 0) {
> +		rc = -EBUSY;
> +		printk("tpm_tis: failed request_locality %d\n",
> locality);

printk() usually should have a facility level, like
KERN_WARNING:

		printk(KERN_WARNING "tpm_tis: failed request_locality %d\n",
			locality);

>  		goto out_err;
>  	}
>  
> @@ -648,19 +662,34 @@ static struct platform_device *pdev;
>  static int force;
>  module_param(force, bool, 0444);
>  MODULE_PARM_DESC(force, "Force device probe rather than using ACPI
> entry");
> +
> +static char *devname;
> +
>  static int __init init_tis(void)
>  {
> +#define DEVNAME_SIZE 10
> +
>  	int rc;
>  
> +	if ((locality < 0) || (locality > 4)) {
> +		return PTR_ERR(pdev);
> +	}

No braces on single-statement "blocks."

> +
>  	if (force) {
> +		devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
> +        	scnprintf(devname, DEVNAME_SIZE, "%s%d", "tpm_tis",
> locality);
> +
> +		tis_drv.name = devname;
>  		rc = driver_register(&tis_drv);
>  		if (rc < 0)
>  			return rc;
> -		if
> (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
> +
> +		if (IS_ERR(pdev=platform_device_register_simple(devname,
> -1, NULL, 0)))

Please split up the assignment to pdev and then if/return:

		pdev = platform_device_register_simple(devname, -1,
				NULL, 0);
		if (IS_ERR(pdev))
>  			return PTR_ERR(pdev);


>  		if((rc=tpm_tis_init(&pdev->dev, 0, 0)) != 0) {
>  			platform_device_unregister(pdev);
>  			driver_unregister(&tis_drv);
> +			kfree(devname);
>  		}
>  		return rc;
>  	}
> @@ -692,7 +721,9 @@ static void __exit cleanup_tis(void)
>  	if (force) {
>  		platform_device_unregister(pdev);
>  		driver_unregister(&tis_drv);
> -	} else
> +		kfree(devname);
> +	}
> +	else 
>  		pnp_unregister_driver(&tis_pnp_driver);
>  }
> 
> I don't have scripts/checkpatch.pl in my linux tree. Where can I get
> one?

What kernel tree are you using?  Oh.  2.6.18.  :(
Does the patch apply to 2.6.23?  It must do that to be useful.
(Well, it does after fixing the malformed patch problems.)

Take the latest version of checkpatch.pl from
http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/ .

patch complains about malformed patch:
The patch also has about 10 instances of lines being broken
(split) where they shouldn't be split, cause 'patch' not to be
able to apply it.
This is most likely your email client (MUA) doing this, although
it could be some server along the way, I suppose.

What mail client are you using to send patches?


> Devname is being used in 2 functions. That's why it is global. Locality
> parameter is initialized with 0 just to be safe. Are all the global
> variables in driver is guaranteed to be init 0? Even if it is it doesn't
> hurt to init it.

All static globals are guaranteed to be init to 0.
It increases the object file size to init them again.
Kernel style is not to init these to 0 or NULL.

---
~Randy
