Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbZIWXMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbZIWXMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZIWXMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:12:46 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:38447 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZIWXMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:12:45 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [regression, bisected] adb trackpad disappears after suspend to ram
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	<200906032200.55563.rjw@sisk.pl> <1253676745.7103.268.camel@pasglop>
	<200909231538.51227.rjw@sisk.pl>
Date: Thu, 24 Sep 2009 01:12:22 +0200
Message-ID: <87eipxjlwp.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested the patch against v2.6.30 and v2.6.31 and in both cases
the bug is fixed.

Thanks,
   Jan

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday 23 September 2009, Benjamin Herrenschmidt wrote:
>> Allright, I think I nailed it (finally !)
>
> Great, thanks a lot for taking care of this!
>
>> Can everybody try this patch:
>> 
>> [PATCH] powerpc/pmac: Fix issues with sleep on some powerbooks
>> 
>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> 
>> Since the change of how interrupts are disabled during suspend,
>> certain PowerBook models started exhibiting various issues during
>> suspend or resume from sleep.
>> 
>> I finally tracked it down to the code that runs various "platform"
>> functions (kind of little scripts extracted from the device-tree),
>> which uses our i2c and PMU drivers expecting interrutps to work,
>> and at a time where with the new scheme, they have been disabled.
>> 
>> This causes timeouts internally which for some reason results in
>> the PMU being unable to see the trackpad, among other issues, really
>> it depends on the machine. Most of the time, we fail to properly adjust
>> some clocks for suspend/resume so the results are not always
>> predictable.
>> 
>> This patch fixes it by using IRQF_TIMER for both the PMU and the I2C
>> interrupts. I prefer doing it this way than moving the call sites since
>> I really want those platform functions to still be called after all
>> drivers (and before sysdevs).
>
> Alternatively, you could introduce a new flag IRQF_NOSUSPEND and use that
> instead of IRQF_TIMER.  That would be cleaner than using IRQF_TIMER for
> non-timer interrupts IMHO.
>
>> We also do a slight cleanup to via-pmu.c driver to make sure the
>> ADB autopoll mask is handled correctly when doing bus resets
>> 
>> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> ---
>> 
>> diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
>> index 21226b7..414ca98 100644
>> --- a/arch/powerpc/platforms/powermac/low_i2c.c
>> +++ b/arch/powerpc/platforms/powermac/low_i2c.c
>> @@ -540,8 +540,11 @@ static struct pmac_i2c_host_kw *__init kw_i2c_host_init(struct device_node *np)
>>  	/* Make sure IRQ is disabled */
>>  	kw_write_reg(reg_ier, 0);
>>  
>> -	/* Request chip interrupt */
>> -	if (request_irq(host->irq, kw_i2c_irq, 0, "keywest i2c", host))
>> +	/* Request chip interrupt. We set IRQF_TIMER because we don't
>> +	 * want that interrupt disabled between the 2 passes of driver
>> +	 * suspend or we'll have issues running the pfuncs
>> +	 */
>> +	if (request_irq(host->irq, kw_i2c_irq, IRQF_TIMER, "keywest i2c", host))
>>  		host->irq = NO_IRQ;
>>  
>>  	printk(KERN_INFO "KeyWest i2c @0x%08x irq %d %s\n",
>> diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
>> index b40fb9b..6f308a4 100644
>> --- a/drivers/macintosh/via-pmu.c
>> +++ b/drivers/macintosh/via-pmu.c
>> @@ -405,7 +405,11 @@ static int __init via_pmu_start(void)
>>  		printk(KERN_ERR "via-pmu: can't map interrupt\n");
>>  		return -ENODEV;
>>  	}
>> -	if (request_irq(irq, via_pmu_interrupt, 0, "VIA-PMU", (void *)0)) {
>> +	/* We set IRQF_TIMER because we don't want the interrupt to be disabled
>> +	 * between the 2 passes of driver suspend, we control our own disabling
>> +	 * for that one
>> +	 */
>> +	if (request_irq(irq, via_pmu_interrupt, IRQF_TIMER, "VIA-PMU", (void *)0)) {
>>  		printk(KERN_ERR "via-pmu: can't request irq %d\n", irq);
>>  		return -ENODEV;
>>  	}
>> @@ -419,7 +423,7 @@ static int __init via_pmu_start(void)
>>  			gpio_irq = irq_of_parse_and_map(gpio_node, 0);
>>  
>>  		if (gpio_irq != NO_IRQ) {
>> -			if (request_irq(gpio_irq, gpio1_interrupt, 0,
>> +			if (request_irq(gpio_irq, gpio1_interrupt, IRQF_TIMER,
>>  					"GPIO1 ADB", (void *)0))
>>  				printk(KERN_ERR "pmu: can't get irq %d"
>>  				       " (GPIO1)\n", gpio_irq);
>> @@ -925,8 +929,7 @@ proc_write_options(struct file *file, const char __user *buffer,
>>  
>>  #ifdef CONFIG_ADB
>>  /* Send an ADB command */
>> -static int
>> -pmu_send_request(struct adb_request *req, int sync)
>> +static int pmu_send_request(struct adb_request *req, int sync)
>>  {
>>  	int i, ret;
>>  
>> @@ -1005,16 +1008,11 @@ pmu_send_request(struct adb_request *req, int sync)
>>  }
>>  
>>  /* Enable/disable autopolling */
>> -static int
>> -pmu_adb_autopoll(int devs)
>> +static int __pmu_adb_autopoll(int devs)
>>  {
>>  	struct adb_request req;
>>  
>> -	if ((vias == NULL) || (!pmu_fully_inited) || !pmu_has_adb)
>> -		return -ENXIO;
>> -
>>  	if (devs) {
>> -		adb_dev_map = devs;
>>  		pmu_request(&req, NULL, 5, PMU_ADB_CMD, 0, 0x86,
>>  			    adb_dev_map >> 8, adb_dev_map);
>>  		pmu_adb_flags = 2;
>> @@ -1027,9 +1025,17 @@ pmu_adb_autopoll(int devs)
>>  	return 0;
>>  }
>>  
>> +static int pmu_adb_autopoll(int devs)
>> +{
>> +	if ((vias == NULL) || (!pmu_fully_inited) || !pmu_has_adb)
>> +		return -ENXIO;
>> +
>> +	adb_dev_map = devs;
>> +	return __pmu_adb_autopoll(devs);
>> +}
>> +
>>  /* Reset the ADB bus */
>> -static int
>> -pmu_adb_reset_bus(void)
>> +static int pmu_adb_reset_bus(void)
>>  {
>>  	struct adb_request req;
>>  	int save_autopoll = adb_dev_map;
>> @@ -1038,13 +1044,13 @@ pmu_adb_reset_bus(void)
>>  		return -ENXIO;
>>  
>>  	/* anyone got a better idea?? */
>> -	pmu_adb_autopoll(0);
>> +	__pmu_adb_autopoll(0);
>>  
>> -	req.nbytes = 5;
>> +	req.nbytes = 4;
>>  	req.done = NULL;
>>  	req.data[0] = PMU_ADB_CMD;
>> -	req.data[1] = 0;
>> -	req.data[2] = ADB_BUSRESET;
>> +	req.data[1] = ADB_BUSRESET;
>> +	req.data[2] = 0;
>>  	req.data[3] = 0;
>>  	req.data[4] = 0;
>>  	req.reply_len = 0;
>> @@ -1056,7 +1062,7 @@ pmu_adb_reset_bus(void)
>>  	pmu_wait_complete(&req);
>>  
>>  	if (save_autopoll != 0)
>> -		pmu_adb_autopoll(save_autopoll);
>> +		__pmu_adb_autopoll(save_autopoll);
>>  
>>  	return 0;
>>  }
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Jan Scholz                                ____  ____    __    ___ 
                                          ( ___)(_  _)  /__\  / __)
 Frankfurt Institute for Advanced Studies  )__)  _)(_  /(__)\ \__ \
                                          (__)  (____)(__)(__)(___/
 Goethe Universitaet Frankfurt
 Ruth-Moufang-Str. 1                             Tel. 069-798-47534
 60438 Frankfurt am Main
