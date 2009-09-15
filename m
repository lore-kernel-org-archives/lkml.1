Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZIOLQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZIOLQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZIOLQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:16:42 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:37032 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZIOLQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dyl+uyKZx5UGtP2m6aSpBljkLlhlyGbbtyGatJskKhEHmhhYHY3OB12VCtKAMzpPeO
         SY7p0/5pRBuRfIxBPJa3Xr/2g3lePwbim7bKZGMiOLF2jTKhI9Miy4ORKkV4+Op2AqGp
         FH60P1NRfktu7TErDvaVQIHvtMgTIJ0kehwMI=
MIME-Version: 1.0
In-Reply-To: <20090915055224.GD1132@core.coreip.homeip.net>
References: <1252911864-19233-1-git-send-email-vapier@gentoo.org> 
	<1252950003-9451-1-git-send-email-vapier@gentoo.org> <200909141049.50705.dmitry.torokhov@gmail.com> 
	<8bd0f97a0909141102l5fa309f4ua1bedd0f1ac99295@mail.gmail.com> 
	<4AAE8908.1000104@hvsistemas.es> <20090915055224.GD1132@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 07:16:25 -0400
Message-ID: <8bd0f97a0909150416j444999e4sfcb6ad77146a97d7@mail.gmail.com>
Subject: Re: [PATCH v3] input/keyboard: new OpenCores Keyboard Controller 
	driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Javier Herrero <jherrero@hvsistemas.es>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 01:52, Dmitry Torokhov wrote:
> On Mon, Sep 14, 2009 at 08:18:48PM +0200, Javier Herrero wrote:
>> It has a bit long since last time I touched the driver, so I should also
>> try to refresh my memory about it :). I suppose that you're right in the
>> double allocation issue (I took another keyboard driver as a starting
>> point and probably the double allocation was already there...), so feel
>> free to introduce the change and I will test it as soon as I can.
>>
>> About the exact scancode - key mapping, the reason is that since the
>> FPGA opencores device already implements a translation table, I found
>> that another translation table sounded a bit redundant.
>
> OK, below is what I have now... One concern though - don't we need to do
> request_mem_region/ioremap for the addr_res?

i think so ... these operations are nops on a Blackfin CPU which is
probably why it "just works".

> +struct opencores_kbd {
> +       struct input_dev *input;
> +       void __iomem *addr;
> +       int irq;
> +       struct resource *irq_res;

the irq_res member is no longer needed

+#define NUM_KEYS 128
> +       unsigned short keycodes[NUM_KEYS];

since this is the only usage of NUM_KEYS, could just inline it now ...

> +       error = request_irq(irq, &opencores_kbd_isr,
> +                           IRQF_TRIGGER_RISING, pdev->name, opencores_kbd);
> +       if (error) {
> +               dev_err(&pdev->dev, "unable to claim irq %d\n", irq);
> +               goto err_free_mem;
> +       }
> +
> +       error = input_register_device(input);
> +       if (error) {
> +               dev_err(&pdev->dev, "unable to register input device\n");
> +               goto err_free_irq;
> +       }

the input layer can handle input even if it's not registered ?
-mike
