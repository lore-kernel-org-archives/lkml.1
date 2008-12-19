Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYLSLrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYLSLrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYLSLrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:47:00 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:53766 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYLSLq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:46:59 -0500
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2008 06:46:59 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <494B831C.5050402@gmail.com>
Date: Fri, 19 Dec 2008 11:18:52 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Balaji Rao <balajirrao@openmoko.org>
CC: linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH V2 2/7] mfd: PCF50633 adc driver
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055653.31696.4361.stgit@cff.thadambail>
In-Reply-To: <20081218055653.31696.4361.stgit@cff.thadambail>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balaji,

Nice driver.  I particularly like the queueing structure. In the IIO
design I hadn't come across any devices that operate in this request
then wait for interrupt fashion.  May need to rethink a few bits of
that.

Couple of minor suggestions below.

> This patch adds basic support for the PCF50633 ADC. The subtractive mode
> is not supported yet.
>
> Since we don't have adc subsystem, it currently lives in drivers/mfd.
>
> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> Cc: Andy Green <andy@openmoko.com>
...
> --- /dev/null
> +++ b/drivers/mfd/pcf50633-adc.c
> @@ -0,0 +1,277 @@
> +/* NXP PCF50633 ADC Driver
> + *
> + * (C) 2006-2008 by Openmoko, Inc.
> + * Author: Balaji Rao <balajirrao@openmoko.org>
> + * All rights reserved.
> + *
> + * Broken down from monstrous PCF50633 driver mainly by
> + * Harald Welte, Andy Green and Werner Almesberger
> + *
> + *  This program is free software; you can redistribute  it and/or
modify it
> + *  under  the terms of  the GNU General  Public License as published
by the
> + *  Free Software Foundation;  either version 2 of the  License, or
(at your
> + *  option) any later version.
> + *
> + *  NOTE: This driver does not yet support subtractive ADC mode, which
means
> + *  you can do only one measurement per read request.
> + */
...

This is confusingly named. To my mind it is writing the setup
to the device not reading it.

> +static void adc_read_setup(struct pcf50633 *pcf, int channel, int avg)
> +{
> +    channel &= PCF50633_ADCC1_ADCMUX_MASK;
This needs a bit more explanation. Particularly as the data
sheet describes that accsw as 'for rationmetric measurement'.
Also, seeing as I assume this is the only driver that can touch
these registers and you don't change them else where, why can't
they be in initial setup code rather than here? (probably a good
reason, but be nice to have it document here!)
> +    /* kill ratiometric, but enable ACCSW biasing */
> +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC2, 0x00);
> +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC3, 0x01);
> +
> +    /* start ADC conversion on selected channel */
> +    pcf50633_reg_write(pcf, PCF50633_REG_ADCC1, channel | avg |
...
> +
> +static void pcf50633_adc_irq(int irq, void *data)
> +{
> +    struct pcf50633_adc *adc = data;
> +    struct pcf50633 *pcf = adc->pcf;
> +    struct pcf50633_adc_request *req;
> +    int head;
> +    mutex_lock(&adc->queue_mutex);
> +    head = adc->queue_head;
> +
> +    req = adc->queue[head];
> +    if (WARN_ON(!req)) {
> +        dev_err(pcf->dev, "pcf50633-adc irq: ADC queue empty!\n");
> +        mutex_unlock(&adc->queue_mutex);
> +        return;
> +    }
> +    adc->queue[head] = NULL;

Weird formatting?

> +    adc->queue_head = (head + 1) &
> +                      (PCF50633_MAX_ADC_FIFO_DEPTH - 1);
> +
> +    mutex_unlock(&adc->queue_mutex);
> +    req->callback(pcf, req->callback_param, adc_result(pcf));
> +    kfree(req);
> +
> +    trigger_next_adc_job_if_any(pcf);
> +}
> +
Rest looks good to me.

Acked-by: Jonathan Cameron

