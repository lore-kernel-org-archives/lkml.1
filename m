Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXKNEha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXKNEha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbXKNEgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:36:54 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:32131 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756846AbXKNEgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:36:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z1xQ/fwdlYcom7MyPweecBfl+Hd+d/mgatsUbJvAQGeeM8oa1xs7DQ21p+Wx6799+9KXb3fyFbQoWBC6IXxoDCSlcULs5iQb21BNLjwphq6oAsa+Ta1mx0F2ITSWa6P1JoT7WFVFuEyE8rUQE1HRXzgIeGB6w4p/7PEC1LYtGzM=  ;
X-YMail-OSG: t.z5nbgVM1mz8J5EvEKD1dSmaVg2ombt7HjzVWeDGyvPWLhVhP8VE88pQPjaMOlAwZKXxZ7rUA--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 20:36:13 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <f17812d70711131704r4de82efat757dbb5479273ce2@mail.gmail.com> <f17812d70711131704l6b0562ffmec6e7e1981130898@mail.gmail.com>
In-Reply-To: <f17812d70711131704l6b0562ffmec6e7e1981130898@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132036.14927.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, eric miao wrote:
> Subject: [PATCH 5/5] move per GPIO "requested" to "struct gpio_desc"
> 

>  struct gpio_desc {
>  	struct gpio_chip *chip;
>  	unsigned is_out:1;
> +	unsigned requested:1;
> +#ifdef CONFIG_DEBUG_FS
> +	const char *requested_str;
> +#endif

A better name for this would be "label", matching what's
passed from gpio_request().  Ndls abrviatns r bd.


Note that this means (on typical 32-bit embedded hardware)
twelve bytes per GPIO, which if you assume 256 GPIOs means
an extra 3 KB static memory compared to the patch I sent.


> @@ -43,20 +43,19 @@ static inline int gpio_is_onchip(unsigned gpio,
> struct gpio_chip *chip)
>  /* Warn when drivers omit gpio_request() calls -- legal but
>   * ill-advised when setting direction, and otherwise illegal.
>   */
> -static void gpio_ensure_requested(struct gpio_chip *chip, unsigned offset)
> +static void gpio_ensure_requested(unsigned gpio)

Simpler to pass a gpio_desc pointer ...


>  	if (!requested)
> -		printk(KERN_DEBUG "GPIO-%d autorequested\n",
> -				chip->base + offset);
> +		pr_debug("GPIO-%d autorequested\n", gpio);

Leave the printk in ... this is the sort of thing we want
to see fixed, which becomes unlikely once you hide such
diagnostics.  And for that matter, what would be enabling
the "-DDEBUG" that would trigger a pr_debug() message?



... overall the main downside of these patches seems to
be that it consumes more static memory.  
