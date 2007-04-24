Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbXDXEw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbXDXEw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbXDXEw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:52:26 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:26220 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752443AbXDXEwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:52:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lFIeBsyR++l7KkCPZCWaJ1McEBhA5IrfpmsEmb31XzcdmHaWQPWyy6T1pxObhtjZ119H9c1gWqEaB1SExMWAjdJ/OnYaCsY2v4f7nresmaJMP1iVF7Syt/xjmIxqibv/+rii2JyA5iPGlyI7cdE/CLD6cz56SLorODHlYW5FGMo=  ;
From: David Brownell <david-b@pacbell.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
Date: Mon, 23 Apr 2007 21:52:21 -0700
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704181922.44635.david-b@pacbell.net> <74966835.20070423114538@gmail.com>
In-Reply-To: <74966835.20070423114538@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232152.22064.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2007, Paul Sokolovsky wrote:
> Hello David,
> 
> Thursday, April 19, 2007, 5:22:44 AM, you wrote:
> 
> >> >> > So, talking about what an (optional) implementation framework might
> >> >> > look like (and which could handle the SOC, FPGA, I2C, and MFD cases
> >> >> > I've looked at):
> >> 
> >> > See patches in following messages ... a preliminary "gpio_chip" core
> >> > for such a framework, plus example support for one SOC family's GPIOs,
> >> > and then updating one board's handling of GPIOs, including over I2C.
> >> 
> >>         Just to compare, diffstats for GPIODEV:
>
> > Now, if they were functionally equivalent, such a comparison
> > would be less of an apples/oranges thing!
> 
>         But of course they are functionally equivalent! They do the
> same thing - manage GPIOs. They even do it in very similar ways.

Functional equivalence means handling all the capabilities
defined in Documentation/gpio.txt ... they are defined
because without them, the programming interface wouldn't
cover significant capabilities folk asked for.

You omitted notions of:  spinlock safe/unsafe operation,
as needed to handle e.g. register access over I2C/SPI
versus spinlock-safe access; request/reserve, minimizing
inter-driver conflicts; direction setting, since it's most
often mutable.

It's no surprise when less-functional code is smaller...


> >>       it needs work - it doesn't adhere to your own
> >> optimization scheme by using lookup table instead of list.
> 
> > I thought it was more important to address the $SUBJECT first:
> 
>         Well, is this your last argument why your implementation is
> better: GPIO chip framework is needed just because there's some random
> mail subject which mentions it?

I certainly pointed out that something like a gpio_chip would
be easy enough to do, back when the programming interfaces were
first discussed ... in the context of supporting more than the
initial implementations of platform-level SOC style GPIOs, after
things are under way.

Working on that was what I've called a "phase III" issue ... where
"phase I" was a programming interface that could be be easily and
widely adopted, and "phase II" was the initial adoption (platforms
and drivers).  With "phase II" well under way, broadening the scope
of implementations now make sense.


>         Let's recollect with what the discussion started: 

Depends which discussion you mean.  I was continuing previous
ones; you seemed to want to start a new one.


>         proposal 
> from myself and other HH.org developers of the alternative implementation,

No, that original proposal was a *REPLACEMENT INTERFACE* along
with a fairly nasty C++ish implementation.  You then reposted that
same code to a wider audience after ignoring the initial feedback,
then later a revised version with minor changes.  (After my latest
updates were working on multiple boards, but before I posted them.)


>         And we both understand well why we can't reach agreement here:
> we represent different communities with different needs. 

That's not my understanding at all.  Though you're right to
imply that the HH.org community seems to **feel** (for reasons
opaque to most people) that its embedded needs are for some
reason different from those of folk working more closely with
the kernel.org codebase.

(IMO it's a microcosm of a classic embedded product approach:
hack a bunch of stuff so it works, try throwing it upstream,
and only then notice that merging takes real work, with thought
for what other systems with related problems need.)


> >> So, now the most important question is what we all would get
> >> with your approach in the end.
> >> 
> >> So, if you could make sure gpiolib.c doesn't contain inefficient
> >> implementation,
> 
> > I can make it comparable to existing implementations that work
> > the same way ... e.g. AT91 and OMAP code.
> 
>         Why would you compare it to such implementations?

Because the alternatives were *MUCH* lighter weight (much less
flexible), so any comparisons would be unfair!  :)

 
>         I also hear shade of encouragement to keep elaborating
> and submitting GPIODEV in your words, but unfortunately that's not 
> really what I'd like. The whole argument was about having one good
> runtime-extensible framework, not two.

The thing that's potentially interesting in what you've said is
what an API using {gpio_chip, index} addressing would look like.
The extensibility would be through gpio_chip.

The notion has come up before (even from me!), and I recently
noticed some CRIS GPIO code looking something like that.

It's not clear such a thing is needed very often ... but as I've
structured things, it would be easy to add such a layer, should
it turn out to be necessary.  That's why "struct gpio_chip" is
such a relevant next step.

- Dave

