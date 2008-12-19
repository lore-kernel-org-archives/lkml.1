Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYLSMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYLSMvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 07:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYLSMvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 07:51:12 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:44233 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYLSMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 07:51:12 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <494B98CC.4050700@gmail.com>
Date: Fri, 19 Dec 2008 12:51:24 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Andy Green <andy@openmoko.com>
CC: Balaji Rao <balajirrao@openmoko.org>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH V2 2/7] mfd: PCF50633 adc driver
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055653.31696.4361.stgit@cff.thadambail> <494B831C.5050402@gmail.com> <494B9073.8070104@openmoko.com>
In-Reply-To: <494B9073.8070104@openmoko.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Green wrote:
> Somebody in the thread at some point said:
>
> Hi Johnathan -
>
> | This needs a bit more explanation. Particularly as the data
> | sheet describes that accsw as 'for rationmetric measurement'.
>
> What's going on here is that ACCSW can be driven from the PMU to bias a
> resistor divider to scale what's being measured... we use it to detect
> resistor to 0V on ID pin of USB on our charger.
>
> You can power accsw / that divider "by hand" which is what we're doing
> here, or you can have the ratiometric state machine change the mux /
> bias automatically between the two measurements it takes, which we're
> not doing.
That makes sense. Thanks for the explanation.
>
> | Also, seeing as I assume this is the only driver that can touch
> | these registers and you don't change them else where, why can't
> | they be in initial setup code rather than here? (probably a good
> | reason, but be nice to have it document here!)
>
> ADCC2 setting concerned with ratiometric disable could indeed be moved
> to init, it was done like this before I did the queuing stuff and we
> took ADC measurement in two different places in the code.  But in fact
> for the best we should only enable accsw until the measurement completes
> and save a tiny bit of power.
Either way sounds fine to me as I'd be surprised if it is a significant
power
drain and anyway it would come at the cost of a couple more register writes
which, if the bus is slow, would be more of an issue.

>
> |> +    /* kill ratiometric, but enable ACCSW biasing */
> |> +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC2, 0x00);
> |> +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC3, 0x01);
> |> +
> |> +    /* start ADC conversion on selected channel */
> |> +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC1, channel | avg |
> | ...
> |> +
> |> +static void pcf50633_adc_irq(int irq, void *data)
> |> +{
> |> +    struct pcf50633_adc *adc = data;
> |> +    struct pcf50633 *pcf = adc->pcf;
> |> +    struct pcf50633_adc_request *req;
> |> +    int head;
> |> +    mutex_lock(&adc->queue_mutex);
> |> +    head = adc->queue_head;
> |> +
> |> +    req = adc->queue[head];
> |> +    if (WARN_ON(!req)) {
> |> +        dev_err(pcf->dev, "pcf50633-adc irq: ADC queue empty!\n");
> |> +        mutex_unlock(&adc->queue_mutex);
> |> +        return;
> |> +    }
> |> +    adc->queue[head] = NULL;
> |
> | Weird formatting?
> |
> |> +    adc->queue_head = (head + 1) &
> |> +                      (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
> |> +
> |> +    mutex_unlock(&adc->queue_mutex);
>
> This would save the power
>
> ~    pcf50633_reg_write(pcf, PCF50633_REG_ADCC3, 0x0);
>
> |> +    req->callback(pcf, req->callback_param, adc_result(pcf));
> |> +    kfree(req);
> |> +
> |> +    trigger_next_adc_job_if_any(pcf);
> |> +}
> |> +
> | Rest looks good to me.
> |
> | Acked-by: Jonathan Cameron
> |
>
> -Andy

