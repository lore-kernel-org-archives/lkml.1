Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYC0JHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYC0JHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYC0JHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:07:32 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49398 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753692AbYC0JHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:07:31 -0400
Date: Thu, 27 Mar 2008 10:06:23 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hskinnemoen@atmel.com, domen.puncer@telargo.com, lethal@linux-sh.org,
       tony@atomide.com, rmk+kernel@arm.linux.org.uk, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	<20080326155203.GA15405@doriath.ww600.siemens.net>
	<20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	<bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 09:06:24.0133 (UTC) FILETIME=[D4DAF350:01C88FE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 19:52:34 +0300
Dmitry <dbaryshkov@gmail.com> wrote:

> Basically mode becomes enable/disable (however it may be better to merge back
> those pointers into one function). And dev and index go to priv data.

I think it would definitely help to combine some hooks into one.
enable/disable is one example, set_rate/round_rate is another.

> The documentation will come later.

Hmm. Missing documentation makes it harder to review this stuff...

> >  I have quite a few clocks, so the increased memory consumption is quite
> >  significant. What are the advantages of this?  
> 
> At maximum 55, IIUC. I counted 32 or so additional bytes in the struct
> (over avr32-specific one). That would count up to 1.5 K overhead. Is
> that really too much for current kernels?

If the only advantage is less code duplication, I'd say it's too much.
However...

> OTOH this would bring unification of platform code, allow
> configurations when a non-platform driver would provide it's own
> clocks (think about multi-function companion chips when there is a
> "core" which manages "clocks" for it's "periferal" devices. Currently
> if one tries to implement such driver, he is forced to either bind it
> to platform code, or to implement non-standard
> my_device_clock_enable()-like functions.

...that is a good argument. External clock generators come to
mind...they can even be parents for other clocks.

> Also you aren't forced to use this API. simply don't select
> HAVE_CLOCK_LIB and leave
> all things as they are. E.g. gpiolib is now merged, however not all
> gpio-providing platforms
> are using it.

Sure, but then I won't be able to use the suggested drivers that
depend on this stuff.

How about we try to slim things down a bit? Let's see...

> +struct clk {
> +	struct list_head node;
> +	struct clk	*parent;
> +
> +	const char	*name;

I guess these are always required if we're going to do dynamic
registration...

> +	struct module	*owner;

This will probably be unused for most platforms, but I guess we need it
to get the advantage you're talking about.

> +	int		users;

Reference counting, probably need that too.

> +	unsigned long	rate;

This one is redundant. Use getrate() instead.

> +	int		delay;

Huh? A delay after enabling the clock? Why can't the enable() hook do
that if it's really necessary?

> +	int (*can_get)	(struct clk *, struct device *);

What's this for? I'm assuming it's necessary to couple clocks to
specific devices?

> +	int (*set_parent) (struct clk *, struct clk *);

We probably need this.

> +	int (*enable)	(struct clk *);
> +	void (*disable)	(struct clk *);

Combine these into "mode" or something (with an extra parameter)

> +	unsigned long (*getrate) (struct clk*);

We need this one.

> +	int (*setrate)	(struct clk *, unsigned long);
> +	long (*roundrate) (struct clk *, unsigned long);

Combine these into one call with an extra "apply" parameter or
something. The underlying logic is pretty much the same apart from the
"actually write stuff to registers" step.

> +	void		*priv;

Remove this and let platforms extend the struct instead. They can use
container_of() to access the extra fields, which is faster too.

> +};

The result is something like this:

struct clk {
	struct list_head node;
	struct clk	*parent;

	const char	*name;
	struct module	*owner;

	int		users;

	int (*can_get)	(struct clk *, struct device *);
	int (*set_parent) (struct clk *, struct clk *);
	int (*mode)	(struct clk *, bool enabled);
	unsigned long (*getrate) (struct clk*);
	int (*setrate)	(struct clk *, unsigned long, bool apply);
};

which is 44 bytes, 12 bytes more than the avr32 version. That can
probably be explained by the "node" and "owner" fields, which really
are necessary in order to support dynamic registration of clocks.

Adding the "dev" and "index" fields takes us to 52 bytes, or 20 bytes
more. That's about 1.1K extra in total for 55 clocks, which is still a
bit much, but I can probably live with that.

Haavard
