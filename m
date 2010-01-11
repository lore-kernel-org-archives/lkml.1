Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541Ab0AKVcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0AKVcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810Ab0AKVcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:32:50 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:45145 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752319Ab0AKVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:32:46 -0500
Date: Tue, 12 Jan 2010 00:32:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: "Mahalingam, Nithish" <nithish.mahalingam@intel.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>, "cbou@mail.ru" <cbou@mail.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Adding Intel Moorestown PMIC Battery Driver
Message-ID: <20100111213242.GA3985@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <175E0F9A9EFCEA46A65F5552BB0572980445D2BE30@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <175E0F9A9EFCEA46A65F5552BB0572980445D2BE30@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch!

On Mon, Jan 11, 2010 at 05:27:01AM +0530, Mahalingam, Nithish wrote:
[...]
> P.S. As I understand there is no mailing list for power supply subsystem, do
> let me know if I need to add someone else for review.

You can add lkml as well.

Few comments down below.

[...]
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/workqueue.h>
> +#include <linux/jiffies.h>
> +#include <linux/param.h>
> +#include <linux/device.h>
> +#include <linux/spi/spi.h>
> +#include <linux/power_supply.h>
> +
> +#include <asm/ipc_defs.h>
> +#include <linux/usb/langwell_udc.h>
> +
> +
> +MODULE_AUTHOR("Nithish Mahalingam <nithish.mahalingam@intel.com>");
> +MODULE_DESCRIPTION("Intel Moorestown PMIC Battery Driver");
> +MODULE_LICENSE("GPL");
> +
> +#define DRIVER_NAME "pmic_battery"
> +
> +/*********************************************************************
> + *             Generic defines
> + *********************************************************************/
> +
> +static int pmicbatteryDebug;
> +module_param(pmicbatteryDebug, int, 0444);

Please don't use camelCase in kernel.

> +MODULE_PARM_DESC(pmicbatteryDebug,
> +                       "Flag to enable PMIC Battery debug messages.");
> +
> +#define PMIC_BATT_DEBUG                        (pmicbatteryDebug)

I think you don't need this. There is a dynamic debug
infrastructure exist (see include/linux/device.h, dev_dbg()
stuff).

> +
> +#define PMIC_BATT_DRV_INFO_UPDATED     1
> +#define PMIC_BATT_PRESENT              1
> +#define PMIC_BATT_NOT_PRESENT          0
> +#define PMIC_USB_PRESENT               PMIC_BATT_PRESENT
> +#define PMIC_USB_NOT_PRESENT           PMIC_BATT_NOT_PRESENT
> +
> +/* pmic battery register related */
> +#define PMIC_BATT_CHR_SCHRGINT_ADDR    0xD2
> +#define PMIC_BATT_CHR_SBATOVP_MASK     (1 << 1)
> +#define PMIC_BATT_CHR_STEMP_MASK       (1 << 2)
> +#define PMIC_BATT_CHR_SCOMP_MASK       (1 << 3)
> +#define PMIC_BATT_CHR_SUSBDET_MASK     (1 << 4)
> +#define PMIC_BATT_CHR_SBATDET_MASK     (1 << 5)
> +#define PMIC_BATT_CHR_SDCLMT_MASK      (1 << 6)
> +#define PMIC_BATT_CHR_SUSBOVP_MASK     (1 << 7)
> +#define PMIC_BATT_CHR_EXCPT_MASK       0xC6
> +#define PMIC_BATT_ADC_ACCCHRG_MASK     (1 << 31)
> +#define PMIC_BATT_ADC_ACCCHRGVAL_MASK  0x7FFFFFFF
> +
> +/* pmic ipc related */
> +#define PMIC_BATT_CHR_IPC_CMDID                0xEF
> +#define PMIC_BATT_CHR_IPC_FCHRG_SUBID  0x4
> +#define PMIC_BATT_CHR_IPC_TCHRG_SUBID  0x6
> +
> +/* internal return values */
> +#define BATTSUCCESS    0
> +#define EBATTFAIL      1
> +#define EBATTERR       2
> +
> +/* types of battery charging */
> +enum batt_charge_type {
> +       BATT_USBOTG_500MA_CHARGE,
> +       BATT_USBOTG_TRICKLE_CHARGE,
> +};
> +
> +/* valid battery events */
> +enum batt_event {
> +       BATT_EVENT_BATOVP_EXCPT,
> +       BATT_EVENT_USBOVP_EXCPT,
> +       BATT_EVENT_TEMP_EXCPT,
> +       BATT_EVENT_DCLMT_EXCPT,
> +       BATT_EVENT_EXCPT
> +};
> +
> +/* battery cca value */
> +struct batt_cca_data {
> +       signed int cca_val;

Why explicitly state that this is signed?

> +};
> +
> +/* battery property structure */
> +struct batt_prop_data {
> +       unsigned int batt_capacity;
> +       char batt_chrg_crnt;
> +       char batt_chrg_volt;
> +       char batt_chrg_prot;
> +       char batt_chrg_prot2;
> +       char batt_chrg_timer;
> +} __attribute__((packed));
> +
> +
> +/*********************************************************************
> + *             Battery properties
> + *********************************************************************/
> +
> +/*
> + * pmic battery info
> + */
> +struct pmic_power_module_info {
> +       bool is_dev_info_updated;
> +       struct spi_device *spi;
> +       /* pmic battery data */
> +       unsigned long update_time;              /* jiffies when data read */
> +       unsigned int usb_is_present;
> +       unsigned int batt_is_present;
> +       unsigned int batt_health;
> +       unsigned int usb_health;
> +       unsigned int batt_status;
> +       unsigned int batt_charge_now;           /* in mAS */
> +       unsigned int batt_prev_charge_full;     /* in mAS */
> +       unsigned int batt_charge_rate;          /* in units per second */

Per include/linux/power_supply.h and
Documentation/power/power_supply_class.txt

 * All voltages, currents, charges, energies, time and temperatures in uV,
 * uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
 * stated. It's driver's job to convert its raw values to units in which
 * this class operates.

[...]
> +static void pmic_battery_read_status(struct pmic_power_module_info *pbi)
> +{
> +       unsigned int update_time_intrvl = 0;
> +       unsigned int chrg_val = 0;
> +       struct ipc_pmic_reg_data pmic_batt_reg = {0};
> +       struct ipc_cmd_type pmic_batt_cmd = {0};
> +       struct batt_cca_data ccval = {0};
> +       struct batt_prop_data batt_prop = {0};
> +       int batt_present = 0;
> +       int usb_present = 0;
> +       int batt_exception = 0;
> +
> +       /* make sure the last batt_status read happened delay_time before */
> +       if (pbi->update_time && time_before(jiffies, pbi->update_time +
> +                                               msecs_to_jiffies(delay_time)))
> +               return;
> +
> +       update_time_intrvl = jiffies_to_msecs(jiffies - pbi->update_time);
> +       pbi->update_time = jiffies;
> +
> +       /* read coulomb counter registers and schrgint register */
> +
> +       pmic_batt_cmd.ioc = TRUE;
> +       pmic_batt_cmd.cmd = IPC_BATT_CCA_READ;
> +       if (ipc_config_cmd(pmic_batt_cmd, sizeof(struct batt_cca_data),

I'd write it as

ret = ipc_config_cmd(...);
if (ret) {
	dev_warn(..., "%s(): ipc config cmd failed %d\n", __func__, ret);
	return;
}

But that's a matter of taste...

> +                                                               &ccval)) {
> +               dev_warn(&pbi->spi->dev, "%s(): ipc config cmd failed\n",
> +                                                               __func__);
> +               return;
> +       }
> +
> +       pmic_batt_reg.ioc = TRUE;
> +       pmic_batt_reg.pmic_reg_data[0].register_address =
> +                                               PMIC_BATT_CHR_SCHRGINT_ADDR;
> +       pmic_batt_reg.num_entries = 1;
> +
> +       if (ipc_pmic_register_read(&pmic_batt_reg)) {
> +               dev_warn(&pbi->spi->dev, "%s(): ipc pmic read failed\n",
> +                                                               __func__);
> +               return;
> +       }
> +
> +       /*
> +        * set pmic_power_module_info members based on pmic register values
> +        * read.
> +        */
> +
> +       /* set batt_is_present */
> +       if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_SBATDET_MASK) {
> +               pbi->batt_is_present = PMIC_BATT_PRESENT;
> +               batt_present = 1;
> +       } else {
> +               pbi->batt_is_present = PMIC_BATT_NOT_PRESENT;
> +               pbi->batt_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +               pbi->batt_status = POWER_SUPPLY_STATUS_UNKNOWN;
> +       }
> +
> +       /* set batt_health */
> +       if (batt_present) {
> +               if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_SBATOVP_MASK) {
> +                       pbi->batt_health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
> +                       pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +                       pmic_battery_log_event(BATT_EVENT_BATOVP_EXCPT);
> +                       batt_exception = 1;
> +               } else if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_SDCLMT_MASK) {
> +                       pbi->batt_health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
> +                       pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +                       pmic_battery_log_event(BATT_EVENT_DCLMT_EXCPT);
> +                       batt_exception = 1;
> +               } else if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_STEMP_MASK) {
> +                       pbi->batt_health = POWER_SUPPLY_HEALTH_OVERHEAT;
> +                       pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +                       pmic_battery_log_event(BATT_EVENT_TEMP_EXCPT);
> +                       batt_exception = 1;
> +               } else {
> +                       pbi->batt_health = POWER_SUPPLY_HEALTH_GOOD;
> +               }
> +       }
> +
> +       /* set usb_is_present */
> +       if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_SUSBDET_MASK) {
> +               pbi->usb_is_present = PMIC_USB_PRESENT;
> +               usb_present = 1;
> +       } else {
> +               pbi->usb_is_present = PMIC_USB_NOT_PRESENT;
> +               pbi->usb_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +       }
> +
> +       if (usb_present) {
> +               if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_SUSBOVP_MASK) {
> +                       pbi->usb_health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
> +                       pmic_battery_log_event(BATT_EVENT_USBOVP_EXCPT);
> +               } else {
> +                       pbi->usb_health = POWER_SUPPLY_HEALTH_GOOD;
> +               }
> +       }
> +
> +       chrg_val = ccval.cca_val & PMIC_BATT_ADC_ACCCHRGVAL_MASK;
> +
> +       /* set batt_prev_charge_full to battery capacity the first time */
> +       if (!pbi->is_dev_info_updated) {
> +               pmic_batt_cmd.ioc = TRUE;
> +               pmic_batt_cmd.cmd = IPC_BATT_GET_PROP;
> +               if (ipc_config_cmd(pmic_batt_cmd,
> +                               sizeof(struct batt_prop_data), &batt_prop)) {
> +                       dev_warn(&pbi->spi->dev, "%s(): ipc config cmd "
> +                                                       "failed\n", __func__);
> +                       return;
> +               }
> +               pbi->batt_prev_charge_full = batt_prop.batt_capacity;
> +       }
> +
> +       /* set batt_status */
> +       if ((batt_present) && (!batt_exception)) {

No need for these parenthesis.

> +               if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_SCOMP_MASK) {
> +                       pbi->batt_status = POWER_SUPPLY_STATUS_FULL;
> +                       pbi->batt_prev_charge_full = chrg_val;
> +               } else if (ccval.cca_val & PMIC_BATT_ADC_ACCCHRG_MASK) {
> +                       pbi->batt_status = POWER_SUPPLY_STATUS_DISCHARGING;
> +               } else {
> +                       pbi->batt_status = POWER_SUPPLY_STATUS_CHARGING;
> +               }
> +       }
> +
> +       /* set batt_charge_rate */
> +       if ((pbi->is_dev_info_updated) && (batt_present) && (!batt_exception)) {

Ditto.

> +               if (pbi->batt_status == POWER_SUPPLY_STATUS_DISCHARGING) {
> +                       if (pbi->batt_charge_now - chrg_val) {
> +                               pbi->batt_charge_rate = ((pbi->batt_charge_now -
> +                                       chrg_val) * 1000 * 60) /
> +                                       update_time_intrvl;
> +                       }
> +               } else if (pbi->batt_status == POWER_SUPPLY_STATUS_CHARGING) {
> +                       if (chrg_val - pbi->batt_charge_now) {
> +                               pbi->batt_charge_rate = ((chrg_val -
> +                                       pbi->batt_charge_now) * 1000 * 60) /
> +                                       update_time_intrvl;
> +                       }
> +               } else
> +                       pbi->batt_charge_rate = 0;
> +       } else {
> +               pbi->batt_charge_rate = -1;
> +       }
> +
> +       /* batt_charge_now */
> +       if ((batt_present) && (!batt_exception))

The parenthesis aren't needed.

> +               pbi->batt_charge_now = chrg_val;
> +       else
> +               pbi->batt_charge_now = -1;
> +
> +       pbi->is_dev_info_updated = PMIC_BATT_DRV_INFO_UPDATED;
> +}
[...]
> +/**
> + * pmic_battery_interrupt_handler - pmic battery interrupt handler
> + * Context: interrupt context
> + *
> + * PMIC battery interrupt handler which will be called with either
> + * battery full condition occurs or usb otg & battery connect
> + * condition occurs.
> + */
> +static irqreturn_t pmic_battery_interrupt_handler(int id, void *dev)
> +{
> +       struct pmic_power_module_info *pbi =
> +                               (struct pmic_power_module_info *)dev;

This type casting isn't needed.

> +       schedule_work(&pbi->handler);

I think you can use threaded irq for this.

See documentation for request_threaded_irq() in kernel/irq/manage.c.
And as an example of usage see drivers/mfd/wm8350-irq.c.

> +
> +       return IRQ_HANDLED;
> +}
> +
> +/**
> + * pmic_battery_handle_intrpt - pmic battery service interrupt
> + * @work: work structure
> + * Context: can sleep
> + *
> + * PMIC battery needs to either update the battery status as full
> + * if it detects battery full condition caused the interrupt or needs
> + * to enable battery charger if it detects usb and battery detect
> + * caused the source of interrupt.
> + */
> +static void pmic_battery_handle_intrpt(struct work_struct *work)
> +{
> +       struct ipc_pmic_reg_data pmic_batt_reg = {0};
> +       struct pmic_power_module_info *pbi = container_of(work,
> +                               struct pmic_power_module_info, handler);
> +       int power = 0;
> +       enum batt_charge_type chrg;
> +       int retval = 0;
> +
> +       /* check if pmic_power_module_info is initialized */
> +       if (!pbi)

This check is useless. container_of will always return non-NULL
result.

> +               return;
> +
> +       /* read schrgint register to interpret cause of interrupt */
> +       pmic_batt_reg.ioc = TRUE;
> +       pmic_batt_reg.pmic_reg_data[0].register_address =
> +                                               PMIC_BATT_CHR_SCHRGINT_ADDR;
> +       pmic_batt_reg.num_entries = 1;
> +
> +       if (ipc_pmic_register_read(&pmic_batt_reg)) {
> +               dev_warn(&pbi->spi->dev, "%s(): ipc pmic read failed\n",
> +                                                               __func__);
> +               return;
> +       }
> +
> +       /* find the cause of the interrupt */
> +
> +       if (pmic_batt_reg.pmic_reg_data[0].value & PMIC_BATT_CHR_SBATDET_MASK) {
> +               pbi->batt_is_present = PMIC_BATT_PRESENT;
> +       } else {
> +               pbi->batt_is_present = PMIC_BATT_NOT_PRESENT;
> +               pbi->batt_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +               pbi->batt_status = POWER_SUPPLY_STATUS_UNKNOWN;
> +               return;
> +       }
> +
> +       if (pmic_batt_reg.pmic_reg_data[0].value &
> +                                               PMIC_BATT_CHR_EXCPT_MASK) {
> +               pbi->batt_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +               pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +               pbi->usb_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +               pmic_battery_log_event(BATT_EVENT_EXCPT);
> +               return;
> +       } else {
> +               pbi->batt_health = POWER_SUPPLY_HEALTH_GOOD;
> +               pbi->usb_health = POWER_SUPPLY_HEALTH_GOOD;
> +       }
> +
> +       if (pmic_batt_reg.pmic_reg_data[0].value & PMIC_BATT_CHR_SCOMP_MASK) {
> +               struct ipc_cmd_type pmic_batt_cmd = {0};
> +               struct batt_cca_data ccval = {0};
> +
> +               pbi->batt_status = POWER_SUPPLY_STATUS_FULL;
> +               pmic_batt_cmd.ioc = TRUE;
> +               pmic_batt_cmd.cmd = IPC_BATT_CCA_READ;
> +               if (ipc_config_cmd(pmic_batt_cmd,
> +                                       sizeof(struct batt_cca_data), &ccval)) {
> +                       dev_warn(&pbi->spi->dev, "%s(): ipc config cmd "
> +                                                       "failed\n", __func__);
> +                       return;
> +               }
> +               pbi->batt_prev_charge_full = ccval.cca_val &
> +                                               PMIC_BATT_ADC_ACCCHRGVAL_MASK;
> +               return;
> +       }
> +
> +       if (pmic_batt_reg.pmic_reg_data[0].value & PMIC_BATT_CHR_SUSBDET_MASK) {
> +               pbi->usb_is_present = PMIC_USB_PRESENT;
> +       } else {
> +               pbi->usb_is_present = PMIC_USB_NOT_PRESENT;
> +               pbi->usb_health = POWER_SUPPLY_HEALTH_UNKNOWN;
> +               return;
> +       }
> +
> +       /* setup battery charging */
> +
> +       /* check usb otg power capability and set charger accordingly */
> +       retval = langwell_udc_maxpower(&power);
> +       if (retval) {
> +               dev_warn(&pbi->spi->dev, "%s(): usb otg power query failed "
> +                               "with error code %d\n", __func__, retval);
> +               return;
> +       }
> +
> +       if (power >= 500)
> +               chrg = BATT_USBOTG_500MA_CHARGE;
> +       else
> +               chrg = BATT_USBOTG_TRICKLE_CHARGE;
> +
> +       /* enable battery charging */
> +       if (pmic_battery_set_charger(pbi, chrg)) {
> +               dev_warn(&pbi->spi->dev, "%s(): failed to setup battery "
> +                                                       "charging\n", __func__);
> +               return;
> +       }
> +
> +       if (PMIC_BATT_DEBUG)
> +               printk(KERN_INFO "pmic-battery: %s() - setting up battery "
> +                                       "charger successful\n", __func__);

dev_dbg().

> +}
> +
> +/**
> + * pmic_battery_probe - pmic battery initialize
> + * @spi: pmic battery spi structure
> + * Context: can sleep
> + *
> + * PMIC battery initializes its internal data structue and other
> + * infrastructure components for it to work as expected.
> + */
> +static int pmic_battery_probe(struct spi_device *spi)
> +{
> +       int retval = 0;
> +       struct pmic_power_module_info *pbi = 0;

Do not initialize pointers with 0. Plus, you don't actually need
to initialize pbi here.

> +
> +       if (PMIC_BATT_DEBUG)
> +               printk(KERN_INFO "pmic-battery: %s() - found pmic battery "
> +                                                       "device\n", __func__);
> +
> +       pbi = kzalloc(sizeof(*pbi), GFP_KERNEL);
> +       if (!pbi) {
> +               dev_err(&spi->dev, "%s(): memory allocation failed\n",
> +                                                               __func__);
> +               return -ENOMEM;
> +       }
> +
> +       pbi->spi = spi;
> +       pbi->irq = spi->irq;
> +       dev_set_drvdata(&spi->dev, pbi);
> +
> +       /* initialize all required framework before enabling interrupts */
> +       INIT_WORK(&pbi->handler, (void *)pmic_battery_handle_intrpt);

No need for (void *) cast.

> +       INIT_DELAYED_WORK(&pbi->monitor_battery, pmic_battery_monitor);
> +       pbi->monitor_wqueue =
> +                       create_singlethread_workqueue(dev_name(&spi->dev));
> +       if (!pbi->monitor_wqueue) {
> +               dev_err(&spi->dev, "%s(): wqueue init failed\n", __func__);
> +               retval = -ESRCH;
> +               goto wqueue_failed;
> +       }
> +
> +       /* register interrupt */
> +       retval = request_irq(pbi->irq, pmic_battery_interrupt_handler,
> +                                                       0, DRIVER_NAME, pbi);

I think you'd better use dev_name() instead of DRIVER_NAME here,
to distinguish interrupts from several devices.

> +       if (retval) {
> +               dev_err(&spi->dev, "%s(): cannot get IRQ\n", __func__);
> +               goto requestirq_failed;
> +       }
> +
> +       /* register pmic-batt with power supply subsystem */
> +       pbi->batt.name = "pmic-batt";

This won't work if we have several pmic batteries. I think you need
kasprintf(GFP_KERNEL, "%s-batt", dev_name(..));

> +       pbi->batt.type = POWER_SUPPLY_TYPE_BATTERY;
> +       pbi->batt.properties = pmic_battery_props;
> +       pbi->batt.num_properties = ARRAY_SIZE(pmic_battery_props);
> +       pbi->batt.get_property = pmic_battery_get_property;
> +       retval = power_supply_register(&spi->dev, &pbi->batt);
> +       if (retval) {
> +               dev_err(&spi->dev, "%s(): failed to register pmic battery "
> +                                       "device with power supply subsystem\n",
> +                                       __func__);
> +               goto power_reg_failed;
> +       }
> +
> +       if (PMIC_BATT_DEBUG)
> +               printk(KERN_INFO "pmic-battery: %s() - pmic battery device "
> +                               "registration with power supply subsystem "
> +                               "successful\n", __func__);
> +
> +       queue_delayed_work(pbi->monitor_wqueue, &pbi->monitor_battery, HZ * 1);
> +
> +       /* register pmic-usb with power supply subsystem */
> +       pbi->usb.name = "pmic-usb";

kasprintf(GFP_KERNEL, "%s-usb", dev_name(..));

> +       pbi->usb.type = POWER_SUPPLY_TYPE_USB;
> +       pbi->usb.properties = pmic_usb_props;
> +       pbi->usb.num_properties = ARRAY_SIZE(pmic_usb_props);
> +       pbi->usb.get_property = pmic_usb_get_property;
> +       retval = power_supply_register(&spi->dev, &pbi->usb);
> +       if (retval) {
> +               dev_err(&spi->dev, "%s(): failed to register pmic usb "
> +                                       "device with power supply subsystem\n",
> +                                       __func__);
> +               goto power_reg_failed_1;
> +       }
> +
> +       if (PMIC_BATT_DEBUG)
> +               printk(KERN_INFO "pmic-battery: %s() - pmic usb device "
> +                       "registration with power supply subsystem successful\n",
> +                       __func__);
> +
> +       return retval;
> +
> +power_reg_failed_1:
> +       power_supply_unregister(&pbi->batt);
> +power_reg_failed:
> +       cancel_rearming_delayed_workqueue(pbi->monitor_wqueue,
> +                                               &pbi->monitor_battery);
> +requestirq_failed:
> +       destroy_workqueue(pbi->monitor_wqueue);
> +wqueue_failed:
> +       kfree(pbi);
> +
> +       return retval;
> +}
> +
> +/**
> + * pmic_battery_remove - pmic battery finalize
> + * @spi: pmic battery spi device structure
> + * Context: can sleep
> + *
> + * PMIC battery finalizes its internal data structue and other
> + * infrastructure components that it initialized in
> + * pmic_battery_probe.
> + */
> +static int pmic_battery_remove(struct spi_device *spi)

__devexit?

> +{
> +       struct pmic_power_module_info *pbi = dev_get_drvdata(&spi->dev);
> +
> +       if (pbi) {

The check isn't needed. _remove() won't run if device didn't probe
successfully.

> +               free_irq(pbi->irq, pbi);
> +
> +               cancel_rearming_delayed_workqueue(pbi->monitor_wqueue,
> +                                               &pbi->monitor_battery);
> +               destroy_workqueue(pbi->monitor_wqueue);
> +
> +               power_supply_unregister(&pbi->usb);
> +               power_supply_unregister(&pbi->batt);
> +
> +               flush_scheduled_work();
> +
> +               kfree(pbi);
> +       }
> +
> +       return 0;
> +}
> +
> +
> +/*********************************************************************
> + *             Driver initialisation and finalization
> + *********************************************************************/
> +
> +static struct spi_driver pmic_battery_driver = {
> +       .driver = {
> +               .name = DRIVER_NAME,
> +               .bus = &spi_bus_type,
> +               .owner = THIS_MODULE,
> +       },
> +       .probe = pmic_battery_probe,
> +       .remove = __devexit_p(pmic_battery_remove),
> +};
> +
> +

No need for two empty lines.

> +static int __init pmic_battery_module_init(void)
> +{
> +       return spi_register_driver(&pmic_battery_driver);
> +}
> +
> +static void __exit pmic_battery_module_exit(void)
> +{
> +       spi_unregister_driver(&pmic_battery_driver);
> +}
> +
> +module_init(pmic_battery_module_init);
> +module_exit(pmic_battery_module_exit);
> --
> 1.6.5.2

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
