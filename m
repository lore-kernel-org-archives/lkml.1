Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbXJKSzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbXJKSzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 14:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbXJKSza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 14:55:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61637 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXJKSz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 14:55:29 -0400
Date: Thu, 11 Oct 2007 11:54:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: <Valdis.Kletnieks@vt.edu>, <linux-kernel@vger.kernel.org>
Subject: Re: TPM driver changes to support multiple locality
Message-Id: <20071011115429.92326cbd.randy.dunlap@oracle.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com>
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
	<27383.1192045583@turing-police.cc.vt.edu>
	<A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com>
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

On Thu, 11 Oct 2007 11:33:35 -0700 Agarwal, Lomesh wrote:

> Below is the patch for TPM driver.
> Comments/suggestions?

Observe/use kernel coding style.
Run the patch thru scripts/checkpatch.pl and check its suggestions.
Use "diffstat -p1 -w70" and put that summary near the top of the
patch (after the patch description).

Use -p option of diff to generate the diff so that reviewers
can see the function name that patch blocks apply to.

Use tabs instead of spaces for indenting.
More below.

> --- pristine-linux-2.6.18/drivers/char/tpm/tpm_tis.c	2006-09-19
> 20:42:06.000000000 -0700
> +++ linux-2.6.18-xen/drivers/char/tpm/tpm_tis.c	2007-10-09
> 15:30:49.000000000 -0700
> @@ -56,29 +56,36 @@
>  
>  enum tis_defaults {
>  	TIS_MEM_BASE = 0xFED40000,
> -	TIS_MEM_LEN = 0x5000,
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
> +

Indent above/below the same amount (1 tab, not spaces).

> +	tpm_access = ioread8(chip->vendor.iobase + TPM_ACCESS(l));
> +
> +    /* check if locality is closed */
> +	if(tpm_access == 0xFF)

	if (

> +        return -1;
> +
> +	if((tpm_access & (TPM_ACCESS_ACTIVE_LOCALITY |

	if ((

> TPM_ACCESS_VALID)) ==
>  	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID))
>  		return chip->vendor.locality = l;
>  
> @@ -251,10 +258,14 @@
>  
>  out:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, chip->vendor.locality, 1);
>  	return size;
>  }
>  
> +static int locality = 0;

No need to init this to 0.

> +module_param(locality, int, 0444);
> +MODULE_PARM_DESC(locality, "TPM Locality To access");
> +
>  /*
>   * If interrupts are used (signaled by an irq set in the vendor
> structure)
>   * tpm.c can skip polling for the data to be available as the interrupt
> is
> @@ -266,7 +277,7 @@
>  	size_t count = 0;
>  	u32 ordinal;
>  
> -	if (request_locality(chip, 0) < 0)
> +	if (request_locality(chip, locality) < 0)
>  		return -EBUSY;
>  
>  	status = tpm_tis_status(chip);
> @@ -326,7 +337,7 @@
>  	return len;
>  out_err:
>  	tpm_tis_ready(chip);
> -	release_locality(chip, chip->vendor.locality, 0);
> +	release_locality(chip, chip->vendor.locality, 1);
>  	return rc;
>  }
>  
> @@ -401,7 +412,10 @@
>  {
>  	struct tpm_chip *chip = (struct tpm_chip *) dev_id;
>  	u32 interrupt;
> -	int i;
> +
> +        /* check if interrupt is meant for this locality */
> +        if(check_locality(chip, locality) < 0)
> +                return IRQ_NONE;
>  

Use same indenting as surrounding code.

>  	interrupt = ioread32(chip->vendor.iobase +
>  			     TPM_INT_STATUS(chip->vendor.locality));
> @@ -411,10 +425,6 @@
>  
>  	if (interrupt & TPM_INTF_DATA_AVAIL_INT)
>  		wake_up_interruptible(&chip->vendor.read_queue);
> -	if (interrupt & TPM_INTF_LOCALITY_CHANGE_INT)
> -		for (i = 0; i < 5; i++)
> -			if (check_locality(chip, i) >= 0)
> -				break;
>  	if (interrupt &
>  	    (TPM_INTF_LOCALITY_CHANGE_INT | TPM_INTF_STS_VALID_INT |
>  	     TPM_INTF_CMD_READY_INT))
> @@ -440,7 +450,7 @@
>  	struct tpm_chip *chip;
>  
>  	if (!start)
> -		start = TIS_MEM_BASE;
> +		start = TIS_MEM_BASE | (locality << 12);

Looks like all of those "<< 12"s (mostly in header file) could use
some helpers.

>  	if (!len)
>  		len = TIS_MEM_LEN;
>  
> @@ -490,8 +500,9 @@
>  	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
>  		dev_dbg(dev, "\tData Avail Int Support\n");
>  
> -	if (request_locality(chip, 0) != 0) {
> -		rc = -ENODEV;
> +	if (request_locality(chip, locality) < 0) {
> +		rc = -EBUSY;
> +		printk("failed request_locality\n");

Use some prefix identity string that tells the use what module
failed here.

>  		goto out_err;
>  	}
>  
> @@ -582,9 +593,11 @@
>  
>  	tpm_get_timeouts(chip);
>  	tpm_continue_selftest(chip);
> +	release_locality(chip, chip->vendor.locality, 1);
>  
>  	return 0;
>  out_err:
> +	release_locality(chip, chip->vendor.locality, 1);
>  	if (chip->vendor.iobase)
>  		iounmap(chip->vendor.iobase);
>  	tpm_remove_hardware(chip->dev);
> @@ -636,7 +649,7 @@
>  MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to
> probe");
>  
>  static struct device_driver tis_drv = {
> -	.name = "tpm_tis",
> +	.name = "",
>  	.bus = &platform_bus_type,
>  	.owner = THIS_MODULE,
>  	.suspend = tpm_pm_suspend,
> @@ -648,19 +661,34 @@
>  static int force;
>  module_param(force, bool, 0444);
>  MODULE_PARM_DESC(force, "Force device probe rather than using ACPI
> entry");
> +
> +static char *devname = NULL;

No need to init to 0 or NULL.

But why is devname global here?
could it be in the function below or is it used later?
A quick scan finds only local function use below...


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
>  			return PTR_ERR(pdev);
>  		if((rc=tpm_tis_init(&pdev->dev, 0, 0)) != 0) {
>  			platform_device_unregister(pdev);
>  			driver_unregister(&tis_drv);
> +			kfree(devname);
>  		}
>  		return rc;
>  	}
> @@ -692,7 +720,9 @@
>  	if (force) {
>  		platform_device_unregister(pdev);
>  		driver_unregister(&tis_drv);
> -	} else
> +		kfree(devname);
> +	}
> +	else 
>  		pnp_unregister_driver(&tis_pnp_driver);
>  }

---
~Randy
