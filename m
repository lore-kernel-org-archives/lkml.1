Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZKQLps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZKQLps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbZKQLpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:45:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:39505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbZKQLpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:45:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L8VW8xIEvXHnczUgiK+OufH+H1/4EnrhLCXqt6GFG9K8wfOvdokplUJDshB6mUqtar
         gjrLIPE+wy8EHLhypjLt66I31Qok9Ckh8X+uMyqbRpETja+RAmTS2dLPVQS/rw2BYMth
         Q11hOWZMG/mPVX2DVx0gyHm+o4iDnHpXVCFT0=
MIME-Version: 1.0
In-Reply-To: <1258457469-16145-1-git-send-email-giometti@linux.it>
References: <1258457469-16145-1-git-send-email-giometti@linux.it>
Date: Tue, 17 Nov 2009 17:15:49 +0530
Message-ID: <4fb5db50911170345m687ea1fcmff1444250d341240@mail.gmail.com>
Subject: Re: [PATCH] gpio: show IRQ settings even if GPIO direction is 
	"output"
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       raffaele.recalcati@bticino.it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAHBk116015337

On Tue, Nov 17, 2009 at 5:01 PM, Rodolfo Giometti <giometti@linux.it> wrote:> Some architectures (as PXA 27x for example) may define GPIO IRQ lines> as outputs since internal circuitry supports such configuration.>> This patch simply detects if a GPIO is a IRQ line or not just looking> for IRQ line number, "desc" and "desc->action" fields.>> Signed-off-by: Rodolfo Giometti <giometti@linux.it>> Cc: raffaele.recalcati@bticino.it> --->  drivers/gpio/gpiolib.c |   82 ++++++++++++++++++++++++------------------------>  1 files changed, 41 insertions(+), 41 deletions(-)>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c> index 50de0f5..298b66f 100644> --- a/drivers/gpio/gpiolib.c> +++ b/drivers/gpio/gpiolib.c> @@ -1381,6 +1381,8 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)>        unsigned                gpio = chip->base;>        struct gpio_desc        *gdesc = &gpio_desc[gpio];>        int                     is_out;> +       int                     irq;> +       struct irq_desc         *desc;>>        for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {>                if (!test_bit(FLAG_REQUESTED, &gdesc->flags))> @@ -1394,48 +1396,46 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)>                                ? (chip->get(chip, i) ? "hi" : "lo")>                                : "?  ");>> -               if (!is_out) {> -                       int             irq = gpio_to_irq(gpio);> -                       struct irq_desc *desc = irq_to_desc(irq);> -> -                       /* This races with request_irq(), set_irq_type(),> -                        * and set_irq_wake() ... but those are "rare".> -                        *> -                        * More significantly, trigger type flags aren't> -                        * currently maintained by genirq.> -                        */> -                       if (irq >= 0 && desc->action) {> -                               char *trigger;> -> -                               switch (desc->status & IRQ_TYPE_SENSE_MASK) {> -                               case IRQ_TYPE_NONE:> -                                       trigger = "(default)";> -                                       break;> -                               case IRQ_TYPE_EDGE_FALLING:> -                                       trigger = "edge-falling";> -                                       break;> -                               case IRQ_TYPE_EDGE_RISING:> -                                       trigger = "edge-rising";> -                                       break;> -                               case IRQ_TYPE_EDGE_BOTH:> -                                       trigger = "edge-both";> -                                       break;> -                               case IRQ_TYPE_LEVEL_HIGH:> -                                       trigger = "level-high";> -                                       break;> -                               case IRQ_TYPE_LEVEL_LOW:> -                                       trigger = "level-low";> -                                       break;> -                               default:> -                                       trigger = "?trigger?";> -                                       break;> -                               }> -> -                               seq_printf(s, " irq-%d %s%s",> -                                       irq, trigger,> -                                       (desc->status & IRQ_WAKEUP)> -                                               ? " wakeup" : "");> +               irq = gpio_to_irq(gpio);> +               desc = irq_to_desc(irq);> +> +               /* This races with request_irq(), set_irq_type(),> +                * and set_irq_wake() ... but those are "rare".> +                *> +                * More significantly, trigger type flags aren't> +                * currently maintained by genirq.> +                */> +               if (irq >= 0 && desc && desc->action) {> +                       char *trigger;> +> +                       switch (desc->status & IRQ_TYPE_SENSE_MASK) {> +                       case IRQ_TYPE_NONE:> +                               trigger = "(default)";> +                               break;> +                       case IRQ_TYPE_EDGE_FALLING:> +                               trigger = "edge-falling";> +                               break;> +                       case IRQ_TYPE_EDGE_RISING:> +                               trigger = "edge-rising";> +                               break;> +                       case IRQ_TYPE_EDGE_BOTH:> +                               trigger = "edge-both";> +                               break;> +                       case IRQ_TYPE_LEVEL_HIGH:> +                               trigger = "level-high";> +                               break;> +                       case IRQ_TYPE_LEVEL_LOW:> +                               trigger = "level-low";> +                               break;> +                       default:> +                               trigger = "?trigger?";> +                               break;>                        }> +> +                       seq_printf(s, " irq-%d %s%s",> +                               irq, trigger,> +                               (desc->status & IRQ_WAKEUP)> +                                       ? " wakeup" : "");>                }>>                seq_printf(s, "\n");> --> 1.6.3.3
Is there any valid test scenario that makes use of thispatch???Detecting GPIO if it is IRQ in kernel what is the advantage?

Regards,Ram.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
