Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbXKOHSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbXKOHSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbXKOHRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:17:22 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:22000 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752381AbXKOHRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:17:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=D3rsHj0FpfiKFiJPkV4Je3aQ5TReMC7dUPUaUzANidXLMK92Nd7gHg5a+lRjkDN8ziRHp7VAUHYEfeh86rlTQVGgMIFdxb8W6dYagXPVWCdtjm45fTkT/ueZxkruKCw3rtyE3ZCmYD8X/uXSjnFbKI3OIhjsDkIhdzgyI9ZQZa0=  ;
X-YMail-OSG: b62g.bUVM1mHtdQwbr6dYIhx32tPewIa8rZTdTDmVoisCmiRSMotoWgYSfjNVEjFJByW.515uw--
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 22:50:17 -0800
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>
References: <200711091136.20051.david-b@pacbell.net> <200711140037.58049.david-b@pacbell.net> <20071114105441.2d01018f@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20071114105441.2d01018f@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142250.18392.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007, Haavard Skinnemoen wrote:
> On Wed, 14 Nov 2007 00:37:57 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > Although another point is related to "trivial":  the data
> > is being protected through an operation too trivial to be
> > worth paying for any of that priority logic.
> 
> But isn't there any way we can remove the lock from the fast path
> altogether? What is it really protecting?

The integrity of the table.  Entries can be added and removed
(both operations being *RARE* which is good!) at any time.


> Since this is the code that runs under the lock

No, there's more than that.  This is what runs under it in
the hot paths, yes, but the gpio request/free paths do
more work than this.  (That includes direction setting,
since that can be an implicit request.)


> (excluding the "extra checks" case):
> 
> +static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
> +{
> +	return chips[gpio / ARCH_GPIOS_PER_CHIP];
> +}
> 
> I'd say it protects against chips being removed in the middle of the
> operation. However, this comment says that chips cannot be removed
> while any gpio on it is requested:
> 
> +/* gpio_lock protects the table of chips and to gpio_chip->requested.
> + * While any gpio is requested, its gpio_chip is not removable.  It's
> + * a raw spinlock to ensure safe access from hardirq contexts, and to
> + * shrink bitbang overhead:  per-bit preemption would be very wrong.
> + */
>
> And since we drop the lock before calling the actual get/set bit
> operation, we would be screwed anyway if the chip was removed during
> the call to __gpio_set_value(). So what does the lock really buy us?

The get/set bit calls are the hot paths.  Locking on those paths
buys us a consistent locking policy, which is obviously correct.
It's consistent with the request/free paths.

But I think what you're suggesting is that the "requested" flag
is effectively a long-term lock, so grabbing the spinlock on
those paths is not necessary.  Right?

Hmm ... that makes some sense.  I hadn't started out thinking of
that "requested" flag as a lock bit, but in fact that's what it
ended up becoming.

Removing the spinlock from those paths -- at least in the "no
extra checks case" -- would let us avoid all this flamage about
whether raw spinlocks are ever OK.

I think I forsee a patch coming...

- Dave
