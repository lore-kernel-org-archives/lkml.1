Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbYELL1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbYELL1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYELL11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:27:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:34123 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbYELL10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o6+pLCgwhq5WJ9XJY0w8tP7UGZrGwBt2gc/X/Z0esf2lqdhOVr6X5uMF3B9HRDAJwyun0LOAXmgktbjETbVAP2lzlD5V7/sX+WKHheT/8nDBiVqX+5BIg0xE66jCt0bsY7drKt3YpAZLy+L6QcLOsJUxsdykLL3mwO6xNKDwsJs=
Message-ID: <74d0deb30805120427x71b4588es9200f80252bab319@mail.gmail.com>
Date: Mon, 12 May 2008 13:27:24 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Cc: dbrownell@users.sourceforge.net, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <1210587437-9751-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210587437-9751-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 12, 2008 at 12:17 PM, Bryan Wu <cooloney@kernel.org> wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
>  It's an actual deficiency in the hardware that we can't address,
>  so it needs to be worked around in software.
>
>  Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>  Signed-off-by: Bryan Wu <cooloney@kernel.org>
>  ---
>   drivers/input/keyboard/gpio_keys.c |   15 ++++++++++++++-
>   1 files changed, 14 insertions(+), 1 deletions(-)
>
>  diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
>  index bbd00c3..d856eb9 100644
>  --- a/drivers/input/keyboard/gpio_keys.c
>  +++ b/drivers/input/keyboard/gpio_keys.c
>  @@ -26,6 +26,18 @@
>
>   #include <asm/gpio.h>
>
>  +#if defined(CONFIG_BLACKFIN) && !defined(BF548_FAMILY)
>  +
>  +/*
>  + * On some Blackfin CPUs reading edge triggered
>  + * GPIOs doesn't return the current value
>  + */

If this is a generic problem, shouldn't this be addressed inside gpio_get_value?

>  +
>  +#define GPIOKEYS_EDGE_SENSE(x) set_gpio_edge(gpio, x)
>  +#else
>  +#define GPIOKEYS_EDGE_SENSE(x) do {} while (0)
>  +#endif
>  +
>   static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
>   {
>         int i;
>  @@ -39,8 +51,9 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
>
>                 if (irq == gpio_to_irq(gpio)) {
>                         unsigned int type = button->type ?: EV_KEY;
>  +                       GPIOKEYS_EDGE_SENSE(0);
>                         int state = (gpio_get_value(gpio) ? 1 : 0) ^ button->active_low;
>  -
>  +                       GPIOKEYS_EDGE_SENSE(1);
>                         input_event(input, type, button->code, !!state);
>                         input_sync(input);
>                         return IRQ_HANDLED;
>  --
>  1.5.5
>
>

regards
Philipp
