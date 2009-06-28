Return-Path: <linux-kernel-owner+w=401wt.eu-S1752074AbZF1HTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbZF1HTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 03:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZF1HTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 03:19:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:34565 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZF1HT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 03:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t4GSaUX19rwJEuJqPCnVWoySqEkRk2aVD6ZzvfhtA4UoazTTiH75z2F5Fnm6AZ0O3V
         w43iN7rDDHYqsROh5tc2HY4lfA0gG9biqVBbJEkYvr3WIKw2nR1aVFIpGhdqci3MgD3I
         4groyyUEFjMgVuutWqO9sA75K+Pe1uyeJgA80=
MIME-Version: 1.0
In-Reply-To: <1246122592.3727.20.camel@brutus>
References: <1246122592.3727.20.camel@brutus>
Date: Sun, 28 Jun 2009 12:49:31 +0530
Message-ID: <5d5443650906280019m1e7d9343qd44875716b540e4b@mail.gmail.com>
Subject: Re: [PATCH] PCAP misc input driver (for 2.6.32)
From: Trilok Soni <soni.trilok@gmail.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       inux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Ilya Petrov <ilya.muromec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> +
> +static int __init pcap_keys_probe(struct platform_device *pdev)
> +{
> +       int err = -ENOMEM;
> +       struct pcap_keys *pcap_keys;
> +
> +       pcap_keys = kmalloc(sizeof(struct pcap_keys), GFP_KERNEL);
> +       if (!pcap_keys)
> +               return err;
> +
> +       pcap_keys->pcap = platform_get_drvdata(pdev);
> +
> +       pcap_keys->input = input_allocate_device();
> +       if (!pcap_keys->input)
> +               goto fail;
> +
> +       platform_set_drvdata(pdev, pcap_keys);
> +       pcap_keys->input->name = pdev->name;
> +       pcap_keys->input->phys = "pcap-keys/input0";
> +       pcap_keys->input->dev.parent = &pdev->dev;
> +
> +       pcap_keys->input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_SW);
> +       set_bit(KEY_POWER, pcap_keys->input->keybit);
> +       set_bit(SW_HEADPHONE_INSERT, pcap_keys->input->swbit);
> +       set_bit(KEY_HP, pcap_keys->input->keybit);

__set_bit please.

> +
> +       err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
> +                       pcap_keys_handler, 0, "Power key", pcap_keys);
> +       if (err)
> +               goto fail_dev;
> +
> +       err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS),
> +                       pcap_keys_handler, 0, "Headphone jack", pcap_keys);
> +       if (err)
> +               goto fail_pwrkey;
> +
> +       err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> +                       pcap_keys_handler, 0, "MIC jack/button", pcap_keys);
> +       if (err)
> +               goto fail_jack;
> +
> +       err = input_register_device(pcap_keys->input);
> +       if (err)
> +               goto fail_mic;

Same comment as given in PCAP touchscreen driver.

> +
> +static int pcap_keys_remove(struct platform_device *pdev)
> +{
> +       struct pcap_keys *pcap_keys = platform_get_drvdata(pdev);
> +
> +       free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF), pcap_keys);
> +       free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_HS), pcap_keys);
> +       free_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC), pcap_keys);
> +
> +       input_unregister_device(pcap_keys->input);
> +       kfree(pcap_keys);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver pcap_keys_device_driver = {
> +       .probe          = pcap_keys_probe,
> +       .remove         = pcap_keys_remove,

__devexit_p ?

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
