Return-Path: <linux-kernel-owner+w=401wt.eu-S1760745AbZEMSmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760745AbZEMSmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZEMSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:42:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbZEMSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:42:33 -0400
Date: Wed, 13 May 2009 11:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <mike@compulab.co.il>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, mike@compulab.co.il
Subject: Re: [PATCH] da9030_battery: fix race between event handler and
 monitor
Message-Id: <20090513114046.6557fc0e.akpm@linux-foundation.org>
In-Reply-To: <1242112809-10021-1-git-send-email-mike@compulab.co.il>
References: <1242112809-10021-1-git-send-email-mike@compulab.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 10:20:09 +0300
Mike Rapoport <mike@compulab.co.il> wrote:

> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

We seem to be missing a changelog.

> 
> diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
> index 1662bb0..3364198 100644
> --- a/drivers/power/da9030_battery.c
> +++ b/drivers/power/da9030_battery.c
> @@ -22,8 +22,6 @@
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  
> -#define DA9030_STATUS_CHDET	(1 << 3)
> -
>  #define DA9030_FAULT_LOG		0x0a
>  #define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
>  #define DA9030_FAULT_LOG_VBAT_OVER	(1 << 4)
> @@ -244,6 +242,8 @@ static void da9030_set_charge(struct da9030_charger *charger, int on)
>  	}
>  
>  	da903x_write(charger->master, DA9030_CHARGE_CONTROL, val);
> +
> +	power_supply_changed(&charger->psy);
>  }
>  
>  static void da9030_charger_check_state(struct da9030_charger *charger)
> @@ -258,6 +258,12 @@ static void da9030_charger_check_state(struct da9030_charger *charger)
>  			da9030_set_charge(charger, 1);
>  		}
>  	} else {
> +		/* Charger has been pulled out */
> +		if (!charger->chdet) {
> +			da9030_set_charge(charger, 0);
> +			return;
> +		}
> +
>  		if (charger->adc.vbat_res >=
>  		    charger->thresholds.vbat_charge_stop) {
>  			da9030_set_charge(charger, 0);
> @@ -395,13 +401,11 @@ static int da9030_battery_event(struct notifier_block *nb, unsigned long event,
>  {
>  	struct da9030_charger *charger =
>  		container_of(nb, struct da9030_charger, nb);
> -	int status;
>  
>  	switch (event) {
>  	case DA9030_EVENT_CHDET:
> -		status = da903x_query_status(charger->master,
> -					     DA9030_STATUS_CHDET);
> -		da9030_set_charge(charger, status);
> +		cancel_delayed_work_sync(&charger->work);
> +		schedule_work(&charger->work.work);
>  		break;
>  	case DA9030_EVENT_VBATMON:
>  		da9030_battery_vbat_event(charger);
> @@ -565,7 +569,8 @@ static int da9030_battery_remove(struct platform_device *dev)
>  	da903x_unregister_notifier(charger->master, &charger->nb,
>  				   DA9030_EVENT_CHDET | DA9030_EVENT_VBATMON |
>  				   DA9030_EVENT_CHIOVER | DA9030_EVENT_TBAT);
> -	cancel_delayed_work(&charger->work);
> +	cancel_delayed_work_sync(&charger->work);
> +	da9030_set_charge(charger, 0);
>  	power_supply_unregister(&charger->psy);
>  
>  	kfree(charger);

What is this race?  What are the user-visible effects when it occurs? 
How does the patch fix the race?

