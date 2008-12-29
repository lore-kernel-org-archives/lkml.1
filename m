Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYL2Ueo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYL2Ueo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYL2UeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:25 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48101 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751509AbYL2UeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:24 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Wp9vhDrvJakTqZaUIRtwywZ4WsSWtzQ1oT2dBBGLLuYgllYXbc4xw0jgkxmNbpWHK8dVilxzEzwsCA1zk48VfB8qbyw1Iop6V3ZsSc6CKblhW7e0n6OLkVUBLrbtGspkwISvJ7NlY2CVGsLy2/fd2PETKMM79gCxnax3tv5tEOE=  ;
X-YMail-OSG: U9r_ZSYVM1mzRZvXFgsanPWHqXjK7vHBlTDhvToecKtB_6RlEO5yahEkTar9RXmbCrFTMNKsoXUGCJjuBrgfhhNPiHjus200M3OrUZjtxYitKv_dw9Uj0T81z5jHYDiLoTThiUji4RTOZkXXeTWIUfPb
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Mon, 29 Dec 2008 11:06:41 -0800
User-Agent: KMail/1.9.10
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200811300955.30180.david-b@pacbell.net> <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
In-Reply-To: <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200812291106.42238.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 November 2008, Jaya Kumar wrote:
> > The gpio_*() interfaces are how system glue code and drivers
> > access GPIOs, unless they roll their own chip-specific calls.
> >
> > Whereas gpiolib (and gpio_chip) are an *optional* framework
> > for implementing those calls.  Platforms can (and do!) use
> > other frameworks ... maybe they don't want to pay its costs,
> > and don't need the various GPIO expander drivers.
> >
> > So to repeat:  don't assume the interface is implemented in
> > one particular way (using gpiolib).  It has to make sense
> > with other implementation strategies too.  Standard split
> > between interface and implementation, that's all.  (Some folk
> > have been heard to talk about "gpiolib" as the interface to
> > drivers ... it's not, it's a provider-only interface library.)
> >
> 
> Okay, I read above several times and I read Documentation/gpio.txt.
> But... I'm not confident I've understood your meanings above in terms
> of how it should change the code. What I know so far is:
> 
> a)
> arch/arm/mach-pxa/include/mach/gpio.h is where the pxa GPIO api
> interface is defined.

It's actually where the *implementation* is *declared*.  The
API is defined primarily in Documentation/gpio.txt ... though
in this case the implementation mostly punts to gpiolib.  And
as you note below, the implementation is *defined* elsewhere.


> So that's where I will put the 
> gpio_get/set_values_batch functions. This will match the existing
> gpio_set/get_value code there.

Those functions just punt to gpiolib, unlesss they happen
to fit in the "constant parameters" case where they can
expend to two or three instructions inline, rather than a
more expensive function call.

In this case, I don't see any benefit to supporting that
"inline constant parameters" case.

 
> b)
> arch/arm/mach-pxa/gpio.c is where the implementation is.
> So I'll put the pxa_gpio_direction_input/output_batch and
> pxa_gpio_set/get_batch there.

This is where the PXA implementation is *defined*, yes.

 
> c)
> drivers/gpio/gpiolib_batch.c
> 
> This is where I'd put the generic platform independent implementations
> of __gpio_set/get_values_batch
> 
> Does this sound consistent with your recommendation? If not, I need
> more help to understand what changes you are recommending.

More or less, yes.  I'd have to see actual code.  :)


> > Doesn't necessarily need to be *you* doing that, but if it only
> > works on older gumstix boards it'd not be general enough.  Which
> > is part of why I say to get the lowest level proposal out there
> > first.  If done right, it'll be easy to support on other chips.
> 
> Yes, I completely agree that it must work on a wide range of
> architectures. But I don't understand what you mean when you say get
> the lowest level proposal out there first.

Provide a patch/RFD with

 (0) methods you want to add to "struct gpio_chip".

Nothing else.  That should be the easiest part of this change.

Other patches should probably include:

 (1) one with the proposed driver level interface ... needs
     discussion, so beginning with a patch may not be best;

 (2) one *implementing* that interface using current calls;

 (3) another *optimizing* that interface to use the new low
     level methods (0), on chips where they're available;

 (4) gpio_chip implementations for those low level ops.

Plus at least one example of how to use the interfaces in (1),
by the time everything starts to become solid, and implementation
patches are worth while.

(I'm not keen on starting with code to implement interfaces, except
when the interfaces are trivial or obvious.  Interfaces are hard to
change.  It's best to spend some time up-front improving them, while
they're easy to change/fix.)


> I see the RFC code that I 
> posted as being the lowest level proposal (albeit needing better name
> and bitmask support) and one that is sufficiently general that it can
> be implemented on other architectures. 

To repeat:  what you've sent so far is mixing layers.  It doesn't split
out the programming interface from its implementation at all.

Yet the whole *point* of having gpiolib is to make that split easy.

Which is why I want to see patches that reflect that architectural
split, instead of a hard-to-review megapatch that crosses all the
existing boundaries and doesn't show how non-PXA hardware could
implement these patches (or benefit from them).

- Dave

