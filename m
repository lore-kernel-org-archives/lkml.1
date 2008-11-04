Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYKDOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYKDOae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKDOa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:30:26 -0500
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:53642 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYKDOaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:30:25 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 09:30:24 EST
Message-ID: <49105B29.8080707@selhorst.net>
Date: Tue, 04 Nov 2008 15:24:41 +0100
From: Marcel Selhorst <tpm@selhorst.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080930)
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       zohar@linux.vnet.ibm.com, akpm@linux-foundation.org, jmorris@namei.org
Subject: Re: [PATCH 4/5] TPM: addition of pnp_remove()
References: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>	 <8e75ba3e9a38cba61b8627c92a5164903e255b17.1223042186.git.srajiv@linux.vnet.ibm.com>	 <20081003200509.GA7577@us.ibm.com> <1223668202.2586.21.camel@Blackbox.br.ibm.com>
In-Reply-To: <1223668202.2586.21.camel@Blackbox.br.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.0.10; VDF: 7.1.0.33; host: mail.selhorst.net); id=24403-Mmvnp5
X-Df-Sender: 174499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for the delay in my response.
As far as I understand, there is no need to add something to the Infineon
driver, since it already calls the according pnp device release functions on its
own (see code snippets below).
Or do you want to remove the tpm_inf_pnp_remove-function calls from the Infineon
device driver and let the TPM-framework handle the pnp release?

I still have one or two Infineon 1.1b here, so in case you want me to test a
patch, I am happy to do so.

Thanks in advance,
Marcel

static __devexit void tpm_inf_pnp_remove(struct pnp_dev *dev)
{
        struct tpm_chip *chip = pnp_get_drvdata(dev);
        if (chip) {
                if (tpm_dev.iotype == TPM_INF_IO_PORT) {
                        release_region(tpm_dev.data_regs, tpm_dev.data_size);
                        release_region(tpm_dev.config_port,
                                       tpm_dev.config_size);
                } else {
                        iounmap(tpm_dev.mem_base);
                        release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
                }
                tpm_remove_hardware(chip->dev);
        }
}

static struct pnp_driver tpm_inf_pnp_driver = {
[...]
        .remove = __devexit_p(tpm_inf_pnp_remove),
};


Rajiv Andrade schrieb:
> Unfortunately we don't have an old 1.1 infineon tpm chip in order to
> test this legacy driver, but probably we'd need to add a call to
> tpm_dev_vendor_release() in tpm_infineon.c
> 
> Marcel, do you have any clue?
> 
> On Fri, 2008-10-03 at 15:05 -0500, Serge E. Hallyn wrote:
>> Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
>>> The tpm_dev_release function is only called for platform devices, not pnp devices, so we
>>> implemented the .remove function for pnp ones.
>>> Since it's code is very similar to the one inside tpm_dev_release, we've created a helper
>>> function tpm_dev_vendor_release, which is called by both.
>> Should tpm_infineon also be switched over to this?
>>
>>> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
>>> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
>>> ---
>>>  drivers/char/tpm/tpm.c     |   22 ++++++++++++++++------
>>>  drivers/char/tpm/tpm.h     |    1 +
>>>  drivers/char/tpm/tpm_tis.c |   14 +++++++++++++-
>>>  3 files changed, 30 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
>>> index 24fb7ab..ab03b4d 100644
>>> --- a/drivers/char/tpm/tpm.c
>>> +++ b/drivers/char/tpm/tpm.c
>>> @@ -1133,23 +1133,33 @@ int tpm_pm_resume(struct device *dev)
>>>  }
>>>  EXPORT_SYMBOL_GPL(tpm_pm_resume);
>>>
>>> +/* In case vendor provided release function, call it too.*/
>>> +
>>> +void tpm_dev_vendor_release(struct tpm_chip *chip)
>>> +{
>>> +	if (chip->vendor.release)
>>> +	 	chip->vendor.release(chip->dev);
>>> +	
>>> +	clear_bit(chip->dev_num, dev_mask);
>>> +	kfree(chip->vendor.miscdev.name);
>>> +}
>>> +EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
>>> +
>>> +
>>>  /*
>>>   * Once all references to platform device are down to 0,
>>>   * release all allocated structures.
>>> - * In case vendor provided release function, call it too.
>>>   */
>>>  static void tpm_dev_release(struct device *dev)
>>>  {
>>>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>>>
>>> -	if (chip->vendor.release)
>>> -		chip->vendor.release(dev);
>>> -	chip->release(dev);
>>> +	tpm_dev_vendor_release(chip);
>>>
>>> -	clear_bit(chip->dev_num, dev_mask);
>>> -	kfree(chip->vendor.miscdev.name);
>>> +	chip->release(dev);
>>>  	kfree(chip);
>>>  }
>>> +EXPORT_SYMBOL_GPL(tpm_dev_release);
>>>
>>>  /*
>>>   * Called from tpm_<specific>.c probe function only for devices 
>>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>>> index 2756cab..8e30df4 100644
>>> --- a/drivers/char/tpm/tpm.h
>>> +++ b/drivers/char/tpm/tpm.h
>>> @@ -132,6 +132,7 @@ extern struct tpm_chip* tpm_register_hardware(struct device *,
>>>  				 const struct tpm_vendor_specific *);
>>>  extern int tpm_open(struct inode *, struct file *);
>>>  extern int tpm_release(struct inode *, struct file *);
>>> +extern void tpm_dev_vendor_release(struct tpm_chip *);
>>>  extern ssize_t tpm_write(struct file *, const char __user *, size_t,
>>>  			 loff_t *);
>>>  extern ssize_t tpm_read(struct file *, char __user *, size_t, loff_t *);
>>> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>>> index ed1879c..3491d70 100644
>>> --- a/drivers/char/tpm/tpm_tis.c
>>> +++ b/drivers/char/tpm/tpm_tis.c
>>> @@ -630,12 +630,23 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
>>>  	{"", 0}			/* Terminator */
>>>  };
>>>
>>> +static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
>>> +{
>>> +	struct tpm_chip *chip = pnp_get_drvdata(dev);
>>> +	
>>> +	tpm_dev_vendor_release(chip);
>>> +
>>> +	kfree(chip);
>>> +}
>>> +
>>> +
>>>  static struct pnp_driver tis_pnp_driver = {
>>>  	.name = "tpm_tis",
>>>  	.id_table = tpm_pnp_tbl,
>>>  	.probe = tpm_tis_pnp_init,
>>>  	.suspend = tpm_tis_pnp_suspend,
>>>  	.resume = tpm_tis_pnp_resume,
>>> +	.remove = tpm_tis_pnp_remove,
>>>  };
>>>
>>>  #define TIS_HID_USR_IDX sizeof(tpm_pnp_tbl)/sizeof(struct pnp_device_id) -2
>>> @@ -683,6 +694,7 @@ static void __exit cleanup_tis(void)
>>>  	spin_lock(&tis_lock);
>>>  	list_for_each_entry_safe(i, j, &tis_chips, list) {
>>>  		chip = to_tpm_chip(i);
>>> +		tpm_remove_hardware(chip->dev);
>>>  		iowrite32(~TPM_GLOBAL_INT_ENABLE &
>>>  			  ioread32(chip->vendor.iobase +
>>>  				   TPM_INT_ENABLE(chip->vendor.
>>> @@ -694,9 +706,9 @@ static void __exit cleanup_tis(void)
>>>  			free_irq(chip->vendor.irq, chip);
>>>  		iounmap(i->iobase);
>>>  		list_del(&i->list);
>>> -		tpm_remove_hardware(chip->dev);
>>>  	}
>>>  	spin_unlock(&tis_lock);
>>> +	
>>>  	if (force) {
>>>  		platform_device_unregister(pdev);
>>>  		driver_unregister(&tis_drv);
>>> -- 
>>> 1.5.6.3
> 
> 
