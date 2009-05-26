Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZEZOcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZEZOcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZEZOb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:31:59 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:35445 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZEZOb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=huIZe0EWCuKjqcEhZN//pvDKoFDB4fmWMwvI7wa2y6SE+BdpoDk6QcszwBP2jpzBj1
         nOKpE4FnbTy7sikyIUa6jL1a0ACnnPldiXSzrxRmo5noUZr2azDni+7AR5pJj8NOCK6L
         MKnPy+bJDxzPLPo7yUrJ5wINTgkPI2S7KNetw=
MIME-Version: 1.0
In-Reply-To: <20090526061532.GD9188@linux-sh.org>
References: <20090526061532.GD9188@linux-sh.org>
Date: Tue, 26 May 2009 16:31:58 +0200
Message-ID: <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback 
	sched_clock().
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, peterz@infradead.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/26 Paul Mundt <lethal@linux-sh.org>:

>  */
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> +       /*
> +        * Use the current clocksource when it becomes available later in
> +        * the boot process, and ensure that it has a high enough rating
> +        * to make it suitable for general use.
> +        */
> +       if (clock && clock->rating >= 100)
> +               return cyc2ns(clock, clocksource_read(clock));
> +
> +       /* Otherwise just fall back on jiffies */
>        return (unsigned long long)(jiffies - INITIAL_JIFFIES)
>                                        * (NSEC_PER_SEC / HZ);
>  }

This seems like it would make the patch I sent the other day
unnecessary (subject u300 sched_clock() implementation).

It would also trim off this solution found in all OMAP platforms in
arch/arm/plat-omap/common.c

BUT Peter Zijlstra replied to my question about why this wasn't
generic with:

[peterz]:
> But that is the reason this isn't generic, non of the 'stable'
> clocksources on x86 are fast enough to use as sched_clock.

Does that mean clock->rating for these clocksources is
for certain < 100?

The definition of "rating" from the kerneldoc does not
seem to imply that, it's a subjective measure AFAICT.

Else you might want an additional criteria, like
cyc2ns(1) (much less than) jiffies_to_usecs(1)*1000
(however you do that the best way)
so you don't pick something
that isn't substantially faster than the jiffy counter atleast?

Yours,
Linus Walleij
