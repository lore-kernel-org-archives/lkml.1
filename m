Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbYADAlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbYADAlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 19:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYADAlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 19:41:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:58304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYADAlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 19:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Psv5x1sAN+0NG64zIw8+Y5Qb75G0ol7o2Z7j8mO+D/W85SnofNG5vd4fn0X8IKzhMkSGvSPjUBVgSEsh0UnA1hPlskjhTTGNSD1oYAwiSvOybCuZRpG0xCvKjzySER9hF5rXmeBI201OB835zEaodA4Bhrd9BZKETGcXOJrLxDo=
Date: Fri, 4 Jan 2008 03:29:07 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] pda-power: only register available psu
Message-ID: <20080104002907.GA767@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080103005319.GA714@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080103005319.GA714@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Thu, Jan 03, 2008 at 03:53:19AM +0300, Dmitry Baryshkov wrote:
> Currently pda-power adds both ac and usb power supply units.
> This patch fixes it so that psu are added only if they are enabled.

Thanks for the patch, this should be fixed of course. A comment
though...

> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> 
> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index c058f28..42eac09 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
[...]
>  	if (ac_irq) {
> +		ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);

I don't think we should check for IRQs when determining which one
of power supplies to register. Better use is_{ac,usb}_online
callbacks, this will not produce an obstacle to implement polling --
when irqs aren't mandatory. I'll send my two pending patches to show
the idea.

For this particular issue, I think something like that should work.
If it works for you, I'll commit that version, preserving your
authorship, of course.

--- 

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index c058f28..d98622f 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -168,66 +168,74 @@ static int pda_power_probe(struct platform_device *pdev)
 		pda_power_supplies[1].num_supplicants = pdata->num_supplicants;
 	}
 
-	ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
-	if (ret) {
-		dev_err(dev, "failed to register %s power supply\n",
-			pda_power_supplies[0].name);
-		goto supply0_failed;
-	}
+	if (pdata->is_ac_online) {
+		ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
+		if (ret) {
+			dev_err(dev, "failed to register %s power supply\n",
+				pda_power_supplies[0].name);
+			goto ac_supply_failed;
+		}
 
-	ret = power_supply_register(&pdev->dev, &pda_power_supplies[1]);
-	if (ret) {
-		dev_err(dev, "failed to register %s power supply\n",
-			pda_power_supplies[1].name);
-		goto supply1_failed;
+		if (ac_irq) {
+			ret = request_irq(ac_irq->start, power_changed_isr,
+					  get_irq_flags(ac_irq), ac_irq->name,
+					  &pda_power_supplies[0]);
+			if (ret) {
+				dev_err(dev, "request ac irq failed\n");
+				goto ac_irq_failed;
+			}
+		}
 	}
 
-	if (ac_irq) {
-		ret = request_irq(ac_irq->start, power_changed_isr,
-				  get_irq_flags(ac_irq), ac_irq->name,
-				  &pda_power_supplies[0]);
+	if (pdata->is_usb_online) {
+		ret = power_supply_register(&pdev->dev, &pda_power_supplies[1]);
 		if (ret) {
-			dev_err(dev, "request ac irq failed\n");
-			goto ac_irq_failed;
+			dev_err(dev, "failed to register %s power supply\n",
+				pda_power_supplies[1].name);
+			goto usb_supply_failed;
 		}
-	}
 
-	if (usb_irq) {
-		ret = request_irq(usb_irq->start, power_changed_isr,
-				  get_irq_flags(usb_irq), usb_irq->name,
-				  &pda_power_supplies[1]);
-		if (ret) {
-			dev_err(dev, "request usb irq failed\n");
-			goto usb_irq_failed;
+		if (usb_irq) {
+			ret = request_irq(usb_irq->start, power_changed_isr,
+					  get_irq_flags(usb_irq),
+					  usb_irq->name,
+					  &pda_power_supplies[1]);
+			if (ret) {
+				dev_err(dev, "request usb irq failed\n");
+				goto usb_irq_failed;
+			}
 		}
 	}
 
-	goto success;
+	return 0;
 
 usb_irq_failed:
-	if (ac_irq)
+	if (pdata->is_usb_online)
+		power_supply_unregister(&pda_power_supplies[1]);
+usb_supply_failed:
+	if (pdata->is_ac_online && ac_irq)
 		free_irq(ac_irq->start, &pda_power_supplies[0]);
 ac_irq_failed:
-	power_supply_unregister(&pda_power_supplies[1]);
-supply1_failed:
-	power_supply_unregister(&pda_power_supplies[0]);
-supply0_failed:
+	if (pdata->is_ac_online)
+		power_supply_unregister(&pda_power_supplies[0]);
+ac_supply_failed:
 noirqs:
 wrongid:
-success:
 	return ret;
 }
 
 static int pda_power_remove(struct platform_device *pdev)
 {
-	if (usb_irq)
+	if (pdata->is_usb_online && usb_irq)
 		free_irq(usb_irq->start, &pda_power_supplies[1]);
-	if (ac_irq)
+	if (pdata->is_ac_online && ac_irq)
 		free_irq(ac_irq->start, &pda_power_supplies[0]);
 	del_timer_sync(&charger_timer);
 	del_timer_sync(&supply_timer);
-	power_supply_unregister(&pda_power_supplies[1]);
-	power_supply_unregister(&pda_power_supplies[0]);
+	if (pdata->is_usb_online)
+		power_supply_unregister(&pda_power_supplies[1]);
+	if (pdata->is_ac_online)
+		power_supply_unregister(&pda_power_supplies[0]);
 	return 0;
 }
 
