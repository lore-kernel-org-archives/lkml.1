Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbZGNESJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbZGNESJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 00:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZGNESJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 00:18:09 -0400
Received: from mail-px0-f185.google.com ([209.85.216.185]:52710 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbZGNESH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 00:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bgoVrNRaC4B1o9F2wWBgPoE91nfZB53t05A6chKGlbagQxC2sm2hCgUjPC618P4HjQ
         0AINOeVDZXK8ZXUf9XwWPydyFze7wZCkHQK6EQWmcuHOnfqqvkCRE9mlXUiLjLlqIs9t
         THFYwCcRqAyQy+8E/aNdYXtmzvzcjrMARJGQw=
Date: Mon, 13 Jul 2009 21:17:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] tsc2007: make platform callbacks optional
Message-ID: <20090714041759.GA2822@dtor-d630.eng.vmware.com>
References: <4A40C28E.1070109@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A40C28E.1070109@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, Jun 23, 2009 at 01:54:54PM +0200, Richard Röjfors wrote:
> The platform callbacks are only called if supplied. Makes the driver
> to fallback on only pressure calculation to decide when the pen is up.
> 
> Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
> ---
> Index: linux-2.6.30/drivers/input/touchscreen/tsc2007.c
> ===================================================================
> --- linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 943)
> +++ linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 945)
> @@ -59,6 +59,10 @@
>  #define READ_X		(ADC_ON_12BIT | TSC2007_MEASURE_X)
>  #define PWRDOWN		(TSC2007_12BIT | TSC2007_POWER_OFF_IRQ_EN)
> 
> +#define PEN_STATE_UP	0x00
> +#define PEN_STATE_DOWN	0x01
> +#define PEN_STATE_IRQ	0x01

Why the last 2 are the same?

> +
>  struct ts_event {
>  	u16	x;
>  	u16	y;
> @@ -76,7 +80,7 @@
>  	u16			model;
>  	u16			x_plate_ohms;
> 
> -	unsigned		pendown;
> +	unsigned		penstate;
>  	int			irq;
> 
>  	int			(*get_pendown_state)(void);
> @@ -149,15 +153,18 @@
>  	 *
>  	 * The only safe way to check for the pen up condition is in the
>  	 * work function by reading the pen signal state (it's a GPIO and IRQ).
> +	 *
> +	 * But sadly we don't always have the possibility to use such callback
> +	 * in that case rely on the pressure anyway
>  	 */
>  	if (rt) {
>  		struct input_dev *input = ts->input;
> 
> -		if (!ts->pendown) {
> +		if (ts->penstate != PEN_STATE_DOWN) {
>  			dev_dbg(&ts->client->dev, "DOWN\n");
> 
>  			input_report_key(input, BTN_TOUCH, 1);
> -			ts->pendown = 1;
> +			ts->penstate = PEN_STATE_DOWN;
>  		}
> 
>  		input_report_abs(input, ABS_X, x);
> @@ -168,7 +175,9 @@
> 
>  		dev_dbg(&ts->client->dev, "point(%4d,%4d), pressure (%4u)\n",
>  			x, y, rt);
> -	}
> +	} else if (!ts->get_pendown_state)
> +		/* no callback to check pendown state, use pressure */
> +		ts->penstate = PEN_STATE_UP;
> 

Since we are not going to re-check pen state why don't we report "pen
up" event here right away and forego rescheduling the work?

>  	schedule_delayed_work(&ts->work, TS_POLL_PERIOD);
>  }

Thanks.

-- 
Dmitry
