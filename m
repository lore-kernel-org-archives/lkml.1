Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0AOMEF (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 07:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306Ab0AOMEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 07:04:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:22860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab0AOMEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 07:04:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,281,1262592000"; 
   d="scan'208";a="587415098"
From: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
To: "avorontsov@ru.mvista.com" <avorontsov@ru.mvista.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>, "cbou@mail.ru" <cbou@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Jan 2010 17:31:55 +0530
Subject: RE: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Thread-Topic: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Thread-Index: AcqTBaK4bYz2aSiiTmGEOPxTBgXXDAC0Z3Pg
Message-ID: <175E0F9A9EFCEA46A65F5552BB0572980445DB31FB@bgsmsx502.gar.corp.intel.com>
References: <175E0F9A9EFCEA46A65F5552BB0572980445D2BE30@bgsmsx502.gar.corp.intel.com>
 <20100111213242.GA3985@oksana.dev.rtsoft.ru>
In-Reply-To: <20100111213242.GA3985@oksana.dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id o0FC4Fhp021169

> You can add lkml as well.

Will do it going forward.


>> +static int pmicbatteryDebug;
>> +module_param(pmicbatteryDebug, int, 0444);
> 
> Please don't use camelCase in kernel.

My bad, sorry... I am planning to remove this code anyway.


>> +MODULE_PARM_DESC(pmicbatteryDebug,
>> +                       "Flag to enable PMIC Battery debug messages.");
>> +
>> +#define PMIC_BATT_DEBUG                        (pmicbatteryDebug)
> 
> I think you don't need this. There is a dynamic debug
> infrastructure exist (see include/linux/device.h, dev_dbg()
> stuff).

Exactly, realized it very late and missed to update the patch with the 
change. Will take care...


>> +/* battery cca value */
>> +struct batt_cca_data {
>> +       signed int cca_val;
> 
> Why explicitly state that this is signed?

My bad... was not intended. Will correct.


>> +       unsigned int batt_charge_now;           /* in mAS */
>> +       unsigned int batt_prev_charge_full;     /* in mAS */
>> +       unsigned int batt_charge_rate;          /* in units per second */
> 
> Per include/linux/power_supply.h and
> Documentation/power/power_supply_class.txt
> 
> * All voltages, currents, charges, energies, time and temperatures in uV,
> * uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
> * stated. It's driver's job to convert its raw values to units in which
> * this class operates.

I just now checked the hardware spec and it is indeed mAh. I will correct 
the comment appropriately.



>> +       pmic_batt_cmd.ioc = TRUE;
>> +       pmic_batt_cmd.cmd = IPC_BATT_CCA_READ;
>> +       if (ipc_config_cmd(pmic_batt_cmd, sizeof(struct batt_cca_data),
> 
> I'd write it as
> 
> ret = ipc_config_cmd(...);
> if (ret) {
> 	dev_warn(..., "%s(): ipc config cmd failed %d\n", __func__, ret);
> 	return;
> }
> 
> But that's a matter of taste...

:-)... I will accept the comment as it improves readability.


>> +       /* set batt_status */
>> +       if ((batt_present) && (!batt_exception)) {
> 
> No need for these parenthesis.

OK, I tried to be extra cautious... unnecessary I guess.


>> +       /* set batt_charge_rate */
>> +       if ((pbi->is_dev_info_updated) && (batt_present) && (!batt_exception)) {
> 
> Ditto.

I will remove it..


>> +       /* batt_charge_now */
>> +       if ((batt_present) && (!batt_exception))
> 
> The parenthesis aren't needed.

Will take care...


>> +       struct pmic_power_module_info *pbi =
>> +                               (struct pmic_power_module_info *)dev;
>
>This type casting isn't needed.

Yup, redundant type case... will clean.


>> +       schedule_work(&pbi->handler);
> 
> I think you can use threaded irq for this.
> 
> See documentation for request_threaded_irq() in kernel/irq/manage.c.
> And as an example of usage see drivers/mfd/wm8350-irq.c.

Haa that is useful information... completely missed to read about this 
feature. Will modify the code to make use of threaded IRQ.


>> +       /* check if pmic_power_module_info is initialized */
>> +       if (!pbi)
> 
> This check is useless. container_of will always return non-NULL
> result.

Hmm good point... I guess I need to have some other clean mechanism to 
check it the module is initialized. Will take care in my next patch.


>> +       if (PMIC_BATT_DEBUG)
>> +               printk(KERN_INFO "pmic-battery: %s() - setting up battery "
>> +                                       "charger successful\n", __func__);
>
> dev_dbg().

Yes will take care of this in my next patch.


>> +static int pmic_battery_probe(struct spi_device *spi)
>> +{
>> +       int retval = 0;
>> +       struct pmic_power_module_info *pbi = 0;
> 
> Do not initialize pointers with 0. Plus, you don't actually need
> to initialize pbi here.

Accepted. Will take care...


>> +       /* initialize all required framework before enabling interrupts */
>> +       INIT_WORK(&pbi->handler, (void *)pmic_battery_handle_intrpt);
> 
> No need for (void *) cast.

Yup, redundant type case... will clean.


>> +       /* register interrupt */
>> +       retval = request_irq(pbi->irq, pmic_battery_interrupt_handler,
>> +                                                       0, DRIVER_NAME, pbi);
> 
> I think you'd better use dev_name() instead of DRIVER_NAME here,
> to distinguish interrupts from several devices.

Good point. Will make the change...


>> +
>> +       /* register pmic-batt with power supply subsystem */
>> +       pbi->batt.name = "pmic-batt";
> 
> This won't work if we have several pmic batteries. I think you need
> kasprintf(GFP_KERNEL, "%s-batt", dev_name(..));

Got it. Will change as suggested.


>> +       /* register pmic-usb with power supply subsystem */
>> +       pbi->usb.name = "pmic-usb";
> 
> kasprintf(GFP_KERNEL, "%s-usb", dev_name(..));

OK, will incorporate the change as suggested.


>> +/**
>> + * pmic_battery_remove - pmic battery finalize
>> + * @spi: pmic battery spi device structure
>> + * Context: can sleep
>> + *
>> + * PMIC battery finalizes its internal data structue and other
>> + * infrastructure components that it initialized in
>> + * pmic_battery_probe.
>> + */
>> +static int pmic_battery_remove(struct spi_device *spi)
> 
> __devexit?

Haa right... bad miss.


>> +{
>> +       struct pmic_power_module_info *pbi = dev_get_drvdata(&spi->dev);
>> +
>> +       if (pbi) {
> 
> The check isn't needed. _remove() won't run if device didn't probe
> successfully.

Good point. Will remove it.


>> +};
>> +
>> +
> 
> No need for two empty lines.

OK


Thank a lot for the comments Anton. I will incorporate all of these and will re-test 
on the hardware before submitting it again.


Regards,
Nithish
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
