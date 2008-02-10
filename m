Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbYBJB17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbYBJB17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 20:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbYBJB1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 20:27:47 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:45389 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757280AbYBJB1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 20:27:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qq3mx2FntCDCAwlOCCi/A91UbdswPHIuDQ1t6VCfg3V7y2SdfTo8DaexPG7P5dSCwM44yIfhsqJU+cgJuOT9kHWFJ9V22WPlu1fQg+dhaByT5WtFDg/+NsnkqaICko4EgCrhsay5D3E7oR3qJn7lAoSXCwRQGjQ41AM80HVsTeE=  ;
X-YMail-OSG: a6FcpQAVM1n0Pqak40gjHwEmhwbiCL6Oy8e4Pz4qFkYylV0rhJX3_KC2XimC0mdtNQfWxhmGzg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [PATCH] Define a NO_GPIO macro to compare against and to use as an invalid GPIO
Date: Sat, 9 Feb 2008 17:27:42 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
References: <Pine.LNX.4.64.0801311624370.8478@axis700.grange> <200802081543.42467.david-b@pacbell.net> <Pine.LNX.4.64.0802100053450.7517@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0802100053450.7517@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091727.42628.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008, Guennadi Liakhovetski wrote:
> On Fri, 8 Feb 2008, David Brownell wrote:
> 
> > Actually I thought that what you needed was an is_valid_gpio();
> > your motivation was that you needed a predicate.
> > 
> > The problem I have with a #define for a single such invalid GPIO
> > number is that people will inevitably start to assume it's the
> > only such number.  In particular "if (gpio == NO_GPIO) ..."
> > is by definition incorrect.
> > 
> > So I'd really rather see a predicate like is_valid_gpio().
> > 
> > If you want to designate one value for use as an initializer,
> > then I'd rather see a simple
> > 
> > 	#define NO_GPIO	(-EINVAL)
> > 
> > without any option for arch-specific overrides ... along with a
> > comment that this is only *one* of the numerous values which
> > will fail is_valid_gpio().
> 
> I was thinking about irq numbers and trying to avoid as early as possible 
> their problem: namely that each and every platform has its own idea of 
> which irq numbers are valid and which are not, some use 0 as invalid irq, 
> some -1, some 256, etc.

That problem came about mostly because the definition was not
part of the original interface definition.  Not unlike DMA
addressing ... for the longest time it was impossible to
report DMA mapping failures.

Whereas there's *never* been any question about whether
negative numbers are invalid GPIO numbers.  (They aren't.)


> And when those platforms share drivers, problems  
> arise. And the simple and efficient NO_IRQ notion, that would fis those 
> problems nicely, cannot seem to establish itself.

Inertia is one of the problems there ... plus, the only
obvious advantage of "#define NO_IRQ 0" is that it makes
it easier to be lazy about initialization.

Plus, changing platforms to use that convention means they
mostly need to adopt an *unnatural* step of mapping from the
hardware IRQ numbers (which often start at zero, as they do
on one system I just ssh'd into) to some "logical" ID.
Even if you believe that's worthwhile, it's work; and it
could easily break something.


> The disadvantages I see in your suggestions are:
> 
> 1. two accessors (is_valid_gpio() and NO_GPIO) instead of one

Neither of those is an "accessor".  One is a "predicate"; and
the other is an "initializer".  (A better initializer name might
be more like INIT_GPIO_INVALID.)

The "accessor" scenario is actually a natural place to rely
on errno values.  Accessors are like

	int gpio = foo_get_gpio(foo_ptr);

And the normal kernel convention there is to return negative
errno values that characterize the different fault modes.
(Ditto allocators:  foo_alloc_gpio etc.)


> 2. have to include errno.h

Which most code already does.  And you'd certainly want to
do that if you were using an accessor to get GPIOs...


> 3. it doesn't seem very logical to me to define a gpio number in terms of 
>    an error code

It's not a GPIO number though; it's specifically designated as
NOT being a GPIO.  So why not have it be a magic number which
has meaning in multiple contexts?  Do you object to "ssize_t",
or in general the "return negative errno on fault" conventions?


> 4. "confusing freedom" - NO_GPIO is the invalid gpio number, but, in fact, 
>    you can use just any negative number

I don't see any reason to change the API to disallow using
other negative values there.  What good would come from that?
(Remember, the *CURRENT* definition covers this situation
by saying no negative number is a valid GPIO number.)

At the machine instruction level, comparing against "-1" or
any other single currently-defined-as-invalid number is more
expensive than checking "is it negative".

And at a higher level, you'd prevent normal accessor (or
allocator, etc) idioms.  I can't see any value to preventing
such usage.

 
> Advantages of my proposal:
> 
> 1. simplicity - only one macro, and "well-definedness" - use this and only 
>    this as invalid gpio number. The rest are either valid, or undefined.

It's currently simple and well defined; negative numbers
are not GPIOs.  You want a *different* model, which is in
fact more complex ... it adds that "undefined" notion.


> 2. overridable by platforms - though I don't have any examples at hand, I 
>    can imagine, that some platforms would prefer some specific "natural" 
>    for them numbers.

They can already pick any positive number.  I don't know
about you, but I *shudder* to think of anyone who's
seriously trying to manage more than 2 Gbits of GPIOs
one bit at a time!


> But, this is not something I would spend too much energy arguing about, 
> and this is your code in the end:-) So, if you still disagree, I'll do it 
> the way you suggest. I might well be wrong too:-)

Well, you've not convinced me there's any reason to change
the current rules to prevent accessor/allocator idioms from
returning fault codes that could be meaningful.

- Dave



