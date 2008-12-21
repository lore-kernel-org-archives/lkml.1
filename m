Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbYLUI3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbYLUI3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYLUI3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:29:33 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:40253 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYLUI3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:29:31 -0500
Message-ID: <494DFE4D.3040701@compulab.co.il>
Date: Sun, 21 Dec 2008 10:29:01 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@openedhand.com>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, eric miao <eric.miao@marvell.com>,
       cbou@mail.ru, David Woodhouse <dwmw2@infradead.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 2/2] Add Dialog DA9030 battery charger driver
References: <4948B09A.70108@compulab.co.il> <20081218101713.GB2517@sortiz.org> <494A35BC.4090905@compulab.co.il> <20081218205550.GA25717@oksana.dev.rtsoft.ru> <20081218220806.GA21233@sortiz.org>
In-Reply-To: <20081218220806.GA21233@sortiz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

Samuel Ortiz wrote:
> On Thu, Dec 18, 2008 at 11:55:50PM +0300, Anton Vorontsov wrote:
>> Hi all,
>>
>> On Thu, Dec 18, 2008 at 01:36:28PM +0200, Mike Rapoport wrote:
>> [...]
>>>> 2 remarks though:
>>>> 1) I'd like to get Anton Ack on it.
>> Samuel, as it depends on the MFD part, feel free to merge it into your
>> tree.
>>
>> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Thanks Anton, I just applied Mike's latest version of the patch.

I've fixed the points Anton has raised. Would you prefer me to resend the entire
patch or send you incremental patch with fixes?

> Cheers,
> Samuel.
> 
>  
>>>> 2) This patch wont build, as the Makefile is trying to build da903x_battery.o
>>>> while da9030_battery.c is created. I guess it'd make sense to rename it
>>>> da903x_battery.c.
>>> Last minute changes...
>>> I actually prefer to keep it da9030 for now because I have no idea how much
>>> DA9034 charger differs from DA9030.
>>> So, here's the updated patch that fixes Kconfig and Makefile entries and
>>> addresses the points Andrew raised at [1]
>> Mike,
>>
>> Thanks for the patch, looks really good. Few comments down below.
>>
>> [...]
>>> +++ b/drivers/power/da9030_battery.c
>>> @@ -0,0 +1,593 @@
>>> +/*
>>> + * Battery charger driver for Dialog Semiconductor DA9030
>>> + *
>>> + * Copyright (C) 2008 Compulab, Ltd.
>>> + * 	Mike Rapoport <mike@compulab.co.il>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>> The code should explicitly include all the needed headers.
>>
>> #include <linux/kernel.h> (for container_of, sprintf, ...)
>> #include <linux/init.h> (initcalls)
>> #include <linux/types.h> (uint8_t)
>> #include <linux/device.h> (struct device)
>> #include <linux/workqueue.h> (delayedwork)
>>
>> ^^^ This is the only real comment. All the rest are nitpicks,
>> which you can freely ignore if you like.
>>
>>> +#include <linux/module.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/power_supply.h>
>>> +#include <linux/mfd/da903x.h>
>>> +
>>> +#include <linux/debugfs.h>
>>> +#include <linux/seq_file.h>
>>> +
>>> +#define DA9030_STATUS_CHDET	(1 << 3)
>>> +
>>> +#define DA9030_FAULT_LOG		0x0a
>>> +#define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
>>> +#define DA9030_FAULT_LOG_VBAT_OVER	(1 << 4)
>>> +
>>> +#define DA9030_CHARGE_CONTROL		0x28
>>> +#define DA9030_CHRG_CHARGER_ENABLE	(1 << 7)
>>> +
>>> +#define DA9030_ADC_MAN_CONTROL		0x30
>>> +#define DA9030_ADC_TBATREF_ENABLE	(1 << 5)
>>> +#define DA9030_ADC_LDO_INT_ENABLE	(1 << 4)
>>> +
>>> +#define DA9030_ADC_AUTO_CONTROL		0x31
>>> +#define DA9030_ADC_TBAT_ENABLE		(1 << 5)
>>> +#define DA9030_ADC_VBAT_IN_TXON		(1 << 4)
>>> +#define DA9030_ADC_VCH_ENABLE		(1 << 3)
>>> +#define DA9030_ADC_ICH_ENABLE		(1 << 2)
>>> +#define DA9030_ADC_VBAT_ENABLE		(1 << 1)
>>> +#define DA9030_ADC_AUTO_SLEEP_ENABLE	(1 << 0)
>>> +
>>> +#define DA9030_VBATMON		0x32
>>> +#define DA9030_VBATMONTXON	0x33
>>> +#define DA9030_TBATHIGHP	0x34
>>> +#define DA9030_TBATHIGHN	0x35
>>> +#define DA9030_TBATLOW		0x36
>>> +
>>> +#define DA9030_VBAT_RES		0x41
>>> +#define DA9030_VBATMIN_RES	0x42
>>> +#define DA9030_VBATMINTXON_RES	0x43
>>> +#define DA9030_ICHMAX_RES	0x44
>>> +#define DA9030_ICHMIN_RES	0x45
>>> +#define DA9030_ICHAVERAGE_RES	0x46
>>> +#define DA9030_VCHMAX_RES	0x47
>>> +#define DA9030_VCHMIN_RES	0x48
>>> +#define DA9030_TBAT_RES		0x49
>>> +
>>> +struct da9030_adc_res {
>>> +	uint8_t vbat_res;
>>> +	uint8_t vbatmin_res;
>>> +	uint8_t vbatmintxon;
>>> +	uint8_t ichmax_res;
>>> +	uint8_t ichmin_res;
>>> +	uint8_t ichaverage_res;
>>> +	uint8_t vchmax_res;
>>> +	uint8_t vchmin_res;
>>> +	uint8_t tbat_res;
>>> +	uint8_t adc_in4_res;
>>> +	uint8_t adc_in5_res;
>>> +};
>>> +
>>> +struct da9030_battery_thresholds {
>>> +	int tbat_low;
>>> +	int tbat_high;
>>> +	int tbat_restart;
>>> +
>>> +	int vbat_low;
>>> +	int vbat_crit;
>>> +	int vbat_charge_start;
>>> +	int vbat_charge_stop;
>>> +	int vbat_charge_restart;
>>> +
>>> +	int vcharge_min;
>>> +	int vcharge_max;
>>> +};
>>> +
>>> +struct da9030_charger {
>>> +	struct power_supply psy;
>>> +
>>> +	struct device *master;
>>> +
>>> +	struct da9030_adc_res adc;
>>> +	struct delayed_work work;
>>> +	unsigned int interval;
>>> +
>>> +	struct power_supply_info *battery_info;
>>> +
>>> +	struct da9030_battery_thresholds thresholds;
>>> +
>>> +	unsigned int charge_milliamp;
>>> +	unsigned int charge_millivolt;
>>> +
>>> +	/* charger status */
>>> +	int chdet:1;
>> In kernel we can use bool type, and true/false constants.
>>
>>> +	uint8_t fault;
>>> +	int mA;
>>> +	int mV;
>>> +	int is_on;
>>> +
>>> +	struct notifier_block nb;
>>> +
>>> +	/* platform callbacks for battery low and critical events */
>>> +	void (*battery_low)(void);
>>> +	void (*battery_critical)(void);
>>> +
>>> +	struct dentry *debug_file;
>>> +};
>>> +
>>> +static inline int da9030_reg_to_mV(int reg)
>>> +{
>>> +	return ((reg * 2650) >> 8) + 2650;
>>> +}
>>> +
>>> +static inline int da9030_millivolt_to_reg(int mV)
>>> +{
>>> +	return ((mV - 2650) << 8) / 2650;
>>> +}
>>> +
>>> +static inline int da9030_reg_to_mA(int reg)
>>> +{
>>> +	return ((reg * 24000) >> 8) / 15;
>>> +}
>>> +
>>> +#ifdef CONFIG_DEBUG_FS
>>> +
>> (1)
>>
>>> +static int bat_debug_show(struct seq_file *s, void *data)
>>> +{
>>> +	struct da9030_charger *charger = s->private;
>>> +
>>> +	seq_printf(s, "charger is %s\n", charger->is_on ? "on" : "off");
>>> +	if (charger->chdet) {
>>> +		seq_printf(s, "iset = %dmA, vset = %dmV\n",
>>> +			   charger->mA, charger->mV);
>>> +	}
>>> +
>>> +	seq_printf(s, "vbat_res = %d (%dmV)\n",
>>> +		   charger->adc.vbat_res,
>>> +		   da9030_reg_to_mV(charger->adc.vbat_res));
>>> +	seq_printf(s, "vbatmin_res = %d (%dmV)\n",
>>> +		   charger->adc.vbatmin_res,
>>> +		   da9030_reg_to_mV(charger->adc.vbatmin_res));
>>> +	seq_printf(s, "vbatmintxon = %d (%dmV)\n",
>>> +		   charger->adc.vbatmintxon,
>>> +		   da9030_reg_to_mV(charger->adc.vbatmintxon));
>>> +	seq_printf(s, "ichmax_res = %d (%dmA)\n",
>>> +		   charger->adc.ichmax_res,
>>> +		   da9030_reg_to_mV(charger->adc.ichmax_res));
>>> +	seq_printf(s, "ichmin_res = %d (%dmA)\n",
>>> +		   charger->adc.ichmin_res,
>>> +		   da9030_reg_to_mA(charger->adc.ichmin_res));
>>> +	seq_printf(s, "ichaverage_res = %d (%dmA)\n",
>>> +		   charger->adc.ichaverage_res,
>>> +		   da9030_reg_to_mA(charger->adc.ichaverage_res));
>>> +	seq_printf(s, "vchmax_res = %d (%dmV)\n",
>>> +		   charger->adc.vchmax_res,
>>> +		   da9030_reg_to_mA(charger->adc.vchmax_res));
>>> +	seq_printf(s, "vchmin_res = %d (%dmV)\n",
>>> +		   charger->adc.vchmin_res,
>>> +		   da9030_reg_to_mV(charger->adc.vchmin_res));
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int debug_open(struct inode *inode, struct file *file)
>>> +{
>>> +	return single_open(file, bat_debug_show, inode->i_private);
>>> +}
>>> +
>>> +static const struct file_operations bat_debug_fops = {
>>> +	.open		= debug_open,
>>> +	.read		= seq_read,
>>> +	.llseek		= seq_lseek,
>>> +	.release	= single_release,
>>> +};
>>> +
>>> +static struct dentry *da9030_bat_create_debugfs(struct da9030_charger *charger)
>>> +{
>>> +	charger->debug_file = debugfs_create_file("charger", 0666, 0, charger,
>>> +						 &bat_debug_fops);
>>> +	return charger->debug_file;
>>> +}
>>> +
>>> +static void da9030_bat_remove_debugfs(struct da9030_charger *charger)
>>> +{
>>> +	debugfs_remove(charger->debug_file);
>>> +}
>> I'd put an empty line here, or remove empty line at (1). Just for
>> consistency.
>>
>>> +#else
>>> +static inline struct dentry *da9030_bat_create_debugfs(struct da9030_charger *charger)
>>> +{
>>> +	return NULL;
>>> +}
>>> +static inline void da9030_bat_remove_debugfs(struct da9030_charger *charger)
>>> +{
>>> +}
>>> +#endif
>>> +
>>> +static inline void da9030_read_adc(struct da9030_charger *charger,
>>> +				   struct da9030_adc_res *adc)
>>> +{
>>> +	da903x_reads(charger->master, DA9030_VBAT_RES,
>>> +		     sizeof(*adc), (uint8_t *)adc);
>>> +}
>>> +
>>> +static void da9030_charger_update_state(struct da9030_charger *charger)
>>> +{
>>> +	uint8_t val;
>>> +
>>> +	da903x_read(charger->master, DA9030_CHARGE_CONTROL, &val);
>>> +	charger->is_on = (val & DA9030_CHRG_CHARGER_ENABLE) ? 1 : 0;
>>> +	charger->mA = ((val >> 3) & 0xf) * 100;
>>> +	charger->mV = (val & 0x7) * 50 + 4000;
>>> +
>>> +	da9030_read_adc(charger, &charger->adc);
>>> +	da903x_read(charger->master, DA9030_FAULT_LOG, &charger->fault);
>>> +	charger->chdet = da903x_query_status(charger->master,
>>> +						     DA9030_STATUS_CHDET);
>>> +}
>>> +
>>> +static void da9030_set_charge(struct da9030_charger *charger, int on)
>>> +{
>>> +	uint8_t val = 0;
>> = 0 isn't necessary here.
>>
>>> +
>>> +	if (on) {
>>> +		val = DA9030_CHRG_CHARGER_ENABLE;
>>> +		val |= (charger->charge_milliamp / 100) << 3;
>>> +		val |= (charger->charge_millivolt - 4000) / 50;
>>> +		charger->is_on = 1;
>>> +	} else {
>>> +		val = 0;
>>> +		charger->is_on = 0;
>>> +	}
>>> +
>>> +	da903x_write(charger->master, DA9030_CHARGE_CONTROL, val);
>>> +}
>>> +
>>> +static void da9030_charger_check_state(struct da9030_charger *charger)
>>> +{
>>> +	da9030_charger_update_state(charger);
>>> +
>>> +	/* we wake or boot with external power on */
>>> +	if (!charger->is_on) {
>>> +		if ((charger->chdet) &&
>>> +		    (charger->adc.vbat_res <
>>> +		     charger->thresholds.vbat_charge_start)) {
>>> +			da9030_set_charge(charger, 1);
>>> +		}
>>> +	} else {
>>> +		if (charger->adc.vbat_res >=
>>> +		    charger->thresholds.vbat_charge_stop) {
>>> +			da9030_set_charge(charger, 0);
>>> +			da903x_write(charger->master, DA9030_VBATMON,
>>> +				       charger->thresholds.vbat_charge_restart);
>>> +		} else if (charger->adc.vbat_res >
>>> +			   charger->thresholds.vbat_low) {
>>> +			/* we are charging and passed LOW_THRESH,
>>> +			   so upate DA9030 VBAT threshold
>>> +			 */
>>> +			da903x_write(charger->master, DA9030_VBATMON,
>>> +				     charger->thresholds.vbat_low);
>>> +		}
>>> +		if (charger->adc.vchmax_res > charger->thresholds.vcharge_max ||
>>> +		    charger->adc.vchmin_res < charger->thresholds.vcharge_min ||
>>> +		    /* Tempreture readings are negative */
>>> +		    charger->adc.tbat_res < charger->thresholds.tbat_high ||
>>> +		    charger->adc.tbat_res > charger->thresholds.tbat_low) {
>>> +			/* disable charger */
>>> +			da9030_set_charge(charger, 0);
>>> +		}
>>> +	}
>>> +}
>>> +
>>> +static void da9030_charging_monitor(struct work_struct *work)
>>> +{
>>> +	struct da9030_charger *charger;
>>> +
>>> +	charger = container_of(work, struct da9030_charger, work.work);
>>> +
>>> +	da9030_charger_check_state(charger);
>>> +
>>> +	/* reschedule for the next time */
>>> +	schedule_delayed_work(&charger->work, charger->interval);
>>> +}
>>> +
>>> +static enum power_supply_property da9030_battery_props[] = {
>>> +	POWER_SUPPLY_PROP_MODEL_NAME,
>>> +	POWER_SUPPLY_PROP_STATUS,
>>> +	POWER_SUPPLY_PROP_HEALTH,
>>> +	POWER_SUPPLY_PROP_TECHNOLOGY,
>>> +	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
>>> +	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
>>> +	POWER_SUPPLY_PROP_VOLTAGE_NOW,
>>> +	POWER_SUPPLY_PROP_CURRENT_AVG,
>>> +};
>>> +
>>> +static void da9030_battery_check_status(struct da9030_charger *charger,
>>> +				    union power_supply_propval *val)
>>> +{
>>> +	if (charger->chdet) {
>>> +		if (charger->is_on)
>>> +			val->intval = POWER_SUPPLY_STATUS_CHARGING;
>>> +		else
>>> +			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
>>> +	} else {
>>> +		val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
>>> +	}
>>> +}
>>> +
>>> +static void da9030_battery_check_health(struct da9030_charger *charger,
>>> +				    union power_supply_propval *val)
>>> +{
>>> +	if (charger->fault & DA9030_FAULT_LOG_OVER_TEMP)
>>> +		val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
>>> +	else if (charger->fault & DA9030_FAULT_LOG_VBAT_OVER)
>>> +		val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
>>> +	else
>>> +		val->intval = POWER_SUPPLY_HEALTH_GOOD;
>>> +}
>>> +
>>> +static int da9030_battery_get_property(struct power_supply *psy,
>>> +				   enum power_supply_property psp,
>>> +				   union power_supply_propval *val)
>>> +{
>>> +	struct da9030_charger *charger;
>>> +	charger = container_of(psy, struct da9030_charger, psy);
>>> +
>>> +	switch (psp) {
>>> +	case POWER_SUPPLY_PROP_STATUS:
>>> +		da9030_battery_check_status(charger, val);
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_HEALTH:
>>> +		da9030_battery_check_health(charger, val);
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_TECHNOLOGY:
>>> +		val->intval = charger->battery_info->technology;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
>>> +		val->intval = charger->battery_info->voltage_max_design;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
>>> +		val->intval = charger->battery_info->voltage_min_design;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
>>> +		val->intval = da9030_reg_to_mV(charger->adc.vbat_res) * 1000;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_CURRENT_AVG:
>>> +		val->intval =
>>> +			da9030_reg_to_mA(charger->adc.ichaverage_res) * 1000;
>>> +		break;
>>> +	case POWER_SUPPLY_PROP_MODEL_NAME:
>>> +		val->strval = charger->battery_info->name;
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void da9030_battery_vbat_event(struct da9030_charger *charger)
>>> +{
>>> +	da9030_read_adc(charger, &charger->adc);
>>> +
>>> +	if (!charger->is_on) {
>> I'd write it as:
>>
>> if (charger->is_on)
>> 	return;
>> the-rest;
>>
>> Saves one indent level.
>>
>>> +		if (charger->adc.vbat_res < charger->thresholds.vbat_low) {
>>> +			/* set VBAT threshold for critical */
>>> +			da903x_write(charger->master, DA9030_VBATMON,
>>> +				     charger->thresholds.vbat_crit);
>>> +			if (charger->battery_low)
>>> +				charger->battery_low();
>>> +		} else if (charger->adc.vbat_res <
>>> +			   charger->thresholds.vbat_crit) {
>>> +			/* notify the system of battery critical */
>>> +			if (charger->battery_critical)
>>> +				charger->battery_critical();
>>> +		}
>>> +	}
>>> +}
>>> +
>>> +static int da9030_battery_event(struct notifier_block *nb, unsigned long event,
>>> +				void *data)
>>> +{
>>> +	struct da9030_charger *charger =
>>> +		container_of(nb, struct da9030_charger, nb);
>>> +	int status;
>>> +
>>> +	switch (event) {
>>> +	case DA9030_EVENT_CHDET:
>>> +		status = da903x_query_status(charger->master,
>>> +					     DA9030_STATUS_CHDET);
>>> +		da9030_set_charge(charger, status);
>>> +		break;
>>> +	case DA9030_EVENT_VBATMON:
>>> +		da9030_battery_vbat_event(charger);
>>> +		break;
>>> +	case DA9030_EVENT_CHIOVER:
>>> +	case DA9030_EVENT_TBAT:
>>> +		da9030_set_charge(charger, 0);
>>> +		break;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void da9030_battery_convert_thresholds(struct da9030_charger *charger,
>>> +					      struct da9030_battery_info *pdata)
>>> +{
>>> +	charger->thresholds.tbat_low = pdata->tbat_low;
>>> +	charger->thresholds.tbat_high = pdata->tbat_high;
>>> +	charger->thresholds.tbat_restart  = pdata->tbat_restart;
>>> +
>>> +	charger->thresholds.vbat_low =
>>> +		da9030_millivolt_to_reg(pdata->vbat_low);
>>> +	charger->thresholds.vbat_crit =
>>> +		da9030_millivolt_to_reg(pdata->vbat_crit);
>>> +	charger->thresholds.vbat_charge_start =
>>> +		da9030_millivolt_to_reg(pdata->vbat_charge_start);
>>> +	charger->thresholds.vbat_charge_stop =
>>> +		da9030_millivolt_to_reg(pdata->vbat_charge_stop);
>>> +	charger->thresholds.vbat_charge_restart =
>>> +		da9030_millivolt_to_reg(pdata->vbat_charge_restart);
>>> +
>>> +	charger->thresholds.vcharge_min =
>>> +		da9030_millivolt_to_reg(pdata->vcharge_min);
>>> +	charger->thresholds.vcharge_max =
>>> +		da9030_millivolt_to_reg(pdata->vcharge_max);
>>> +}
>>> +
>>> +static void da9030_battery_setup_psy(struct da9030_charger *charger)
>>> +{
>>> +	struct power_supply *psy = &charger->psy;
>>> +	struct power_supply_info *info = charger->battery_info;
>>> +
>>> +	psy->name = info->name;
>>> +	psy->use_for_apm = info->use_for_apm;
>>> +	psy->type = POWER_SUPPLY_TYPE_BATTERY;
>>> +	psy->get_property = da9030_battery_get_property;
>>> +
>>> +	psy->properties = da9030_battery_props;
>>> +	psy->num_properties = ARRAY_SIZE(da9030_battery_props);;
>> One semicolon is enough.
>>
>>> +};
>>> +
>>> +static int da9030_battery_charger_init(struct da9030_charger *charger)
>>> +{
>>> +	char v[5];
>>> +	int ret;
>>> +
>>> +	v[0] = v[1] = charger->thresholds.vbat_low;
>>> +	v[2] = charger->thresholds.tbat_high;
>>> +	v[3] = charger->thresholds.tbat_restart;
>>> +	v[4] = charger->thresholds.tbat_low;
>>> +
>>> +	ret = da903x_writes(charger->master, DA9030_VBATMON, 5, v);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	/* enable reference voltage supply for ADC from the LDO_INTERNAL
>>> +	   regulator. Must be set before ADC measurements can be made. */
>> I would suggest using canonical-style comments:
>>
>> /*
>>  * Not a big deal though, I'm
>>  * just nitpicking. ;-)
>>  */
>>
>> Thanks,
>>
>> -- 
>> Anton Vorontsov
>> email: cbouatmailru@gmail.com
>> irc://irc.freenode.net/bd2
> 

-- 
Sincerely yours,
Mike.

