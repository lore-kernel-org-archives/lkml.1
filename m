Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZF1HP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZF1HP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 03:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZF1HPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 03:15:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:33697 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZF1HPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 03:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E47sjdiQUlh37lG0fJlA207+RKoEUmaBfEv/AybLyJQ/3V6CUOX08EfgqrwaTZPxn9
         k2wD7VcV5PBv/6+qnU3InILKikqYTWKNe5WIPnGO3qhBzrkeixe5LT4jK9IEcJPuQgJc
         9JnR7Wii41GBWLIgXBkX15pdMTrisnvBNXPpE=
MIME-Version: 1.0
In-Reply-To: <1246122138.3727.12.camel@brutus>
References: <1246122138.3727.12.camel@brutus>
Date: Sun, 28 Jun 2009 12:45:17 +0530
Message-ID: <5d5443650906280015x4bddefa5v9dd36f888c5f2e92@mail.gmail.com>
Subject: Re: [PATCH] PCAP touchscreen driver (for 2.6.32)
From: Trilok Soni <soni.trilok@gmail.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Harald Welte <laforge@gnumonks.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

2009/6/27 Daniel Ribeiro <drwyrm@gmail.com>:
> Touchscreen driver for PCAP2 PMIC.
>

Some more description in commit text really helps.

> +static irqreturn_t pcap_ts_event_touch(int pirq, void *data)
> +{
> +       struct pcap_ts *pcap_ts = data;
> +
> +       if (pcap_ts->read_state == PCAP_ADC_TS_M_STANDBY) {
> +               pcap_ts->read_state = PCAP_ADC_TS_M_PRESSURE;
> +               schedule_delayed_work(&pcap_ts->work, 0);
> +       }
> +       return IRQ_HANDLED;
> +}
> +
> +static int __devinit pcap_ts_probe(struct platform_device *pdev)
> +{
> +       struct input_dev *input_dev;
> +       struct pcap_ts *pcap_ts;
> +       int err = -ENOMEM;
> +
> +       pcap_ts = kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
> +       if (!pcap_ts)
> +               return err;
> +
> +       pcap_ts->pcap = platform_get_drvdata(pdev);
> +       platform_set_drvdata(pdev, pcap_ts);
> +
> +       input_dev = input_allocate_device();
> +       if (!pcap_ts || !input_dev)
> +               goto fail;
> +
> +       INIT_DELAYED_WORK(&pcap_ts->work, pcap_ts_work);
> +
> +       pcap_ts->read_state = PCAP_ADC_TS_M_STANDBY;
> +
> +       pcap_ts->input = input_dev;
> +
> +       input_dev->name = "pcap-touchscreen";
> +       input_dev->phys = "pcap_ts/input0";
> +       input_dev->id.bustype = BUS_HOST;
> +       input_dev->id.vendor = 0x0001;
> +       input_dev->id.product = 0x0002;
> +       input_dev->id.version = 0x0100;
> +       input_dev->dev.parent = &pdev->dev;
> +
> +       input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +       input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +       input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
> +       input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
> +       input_set_abs_params(input_dev, ABS_PRESSURE, PRESSURE_MIN,
> +                            PRESSURE_MAX, 0, 0);
> +
> +       err = request_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS),
> +                       pcap_ts_event_touch, 0, "Touch Screen", pcap_ts);
> +       if (err)
> +               goto fail;
> +
> +       err = input_register_device(pcap_ts->input);
> +       if (err)
> +               goto fail_touch;

Please move request_irq after input_register_device, as IRQ can get
fired before input device gets available, right?

Overall driver is nice and clean.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
