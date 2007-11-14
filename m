Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbXKNEhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbXKNEhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXKNEgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:36:52 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:32114 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754852AbXKNEgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:36:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ilCKH4AteaeRDZXpnnJwywDn8M+jNGpvXof8BhlTQE32W4WfBFSErwuYV23SVMn00yoEZuxtKinftJQZlaSFZ5GlDYnZUYtX+rekEKu7MEHh3yHOnRsuId4aEuxcbNbHUzijeoe3lcnPk4DsocSCfpYoh9CvCvuaPIMmsztcVzs=  ;
X-YMail-OSG: 2dGrQs8VM1mEivWkYbIN.unAb2eq8wWqBnslHoE5uW5Y0eGJsElTMOOh1rOyb23chR12uQwB7w--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 20:18:22 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <f17812d70711131702m4315a1f3ia16e1d0fedf30825@mail.gmail.com> <f17812d70711131703g2e37d68aub8cacc61ccbae49f@mail.gmail.com>
In-Reply-To: <f17812d70711131703g2e37d68aub8cacc61ccbae49f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132018.22995.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, eric miao wrote:
> Here comes the point of "struct gpio_desc"
> 
> Subject: [PATCH 3/5] use a per GPIO "struct gpio_desc" and chain
> "gpio_chip" to a list

I see what it does, but don't see the "why" ... surely
you can come up with a one sentence description of why
this would be better?

And I'd been so glad to *get rid of* that list, too.


> +struct gpio_desc {
> +	struct gpio_chip *chip;
> +};
> +

> -/* gpio_lock protects modification to the table of chips and to
> - * gpio_chip->requested.  If a gpio is requested, its gpio_chip
> - * is not removable.
> - */

But it still protects data.  Don't remove documentation for
what locks protect ... update it!  Otherwise someonels going
to come by and make a change which breaks the locking model.
Usually in some subtle (hard-to-debug) way.

> 
> -	for (id = 0; id < ARRAY_SIZE(chips); id++) {
> -		chip = chips[id];
> -		if (!chip)
> -			continue;
> -
> +	list_for_each_entry(chip, &gpio_chip_list, node) {
>  		seq_printf(s, "%sGPIOs %d-%d, %s%s:\n",
>  				started ? "\n" : "",
>  				chip->base, chip->base + chip->ngpio - 1,

Note that this now produces the debug info in a relatively
random order ... ordered by registration rather than anything
useful, and hence awkward to read.

It'd be better if you just scanned your new gpio_desc[]
table in numeric order, and start a new section whenever
you find a new gpio_chip.

That'd get rid of that otherwise-useless list, too.

- Dave
