Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYJWGGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYJWGGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYJWGGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:06:10 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:36304 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751086AbYJWGGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:06:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sxPK8w25fdMN26legEoLdya9/fmB1eZDn3qBCx0W7ZIQXDBazpHTMKBhxyoN6tXh2BcC6qQYksUQVhTki2LjOazHovJPB93/ZUxCuxekmH+n3KSt8Vt+EjfeI5Y+K62e8oWygqV/CLGhnfnRf+et/YlywpgtouwdhzQhzzdSNGs=  ;
X-YMail-OSG: 2cck6j0VM1nl9AjuvaSc8hHKWJVHjHDnfIEx_KqKPg8n8xKYpm.ESYYfRL7DFREeqcfvEqrk04g2veXasLBdQQ5CvShE5PoWUlVjKoptgV5NRcO.7v755mtEA5WTHAbqWd0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Wed, 22 Oct 2008 23:06:01 -0700
User-Agent: KMail/1.9.10
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810221404.52798.david-b@pacbell.net> <1224737145.7654.387.camel@pasglop>
In-Reply-To: <1224737145.7654.387.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810222306.01661.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008, Benjamin Herrenschmidt wrote:
> On Wed, 2008-10-22 at 14:04 -0700, David Brownell wrote:
> > > So if we register the board infos after 
> > > the controller registered, then nobody will probe the board infos.
> > 
> > See above.  If you're doing it right, there's no problem.
> > That is, scan the OF tables early.  Just like PNP tables
> > get scanned early, for example.
> 
> It's still pretty yucky in that case to scan the device-tree to convert
> it into some kind of fugly board info ... I'd rather have the end
> drivers that actually use those GPIOs scan the device-tree directly.

Keep in mind that these problems are not specific to GPIOs.

And, very important!!, most of the drivers run without OF...

Pretty much any little device that needs board-specific
customization has the same class of problems:  drivers
will need a variety of parameters that may are often not
sharable with other devices, with idiosyncratic usage.
And they hook up to other drivers in arbitrary ways.

When PCs have such issues, ACPI hides them from Linux.

If those parameters -- potentially including callbacks
that escape to FORTH -- are stored in the OF device tree,
so be it.  But "fugly" sounds like part of that problem
domain, so it's no surprise that it maps onto the solution
space too...


Specifically with respect to GPIOs ... what do you mean
by "end driver" though?  I previously pointed at one
example (Davinci EVM) where one bank of GPIOs is used
by about six different drivers ... none of which have
any reason to know they're using a pcf8574a vs any other
kind of GPIO.  Is the "end driver" the IDE/CF driver?
The USB OTG driver?  The driver sitting the next layer
above of one of those?  *Some* of the drivers need to
touch the GPIOs.  Others don't.

 
> But then, I'm not a believer in generic drivers for things
> like GPIOs, i2c devices, etc.. :-)

I kind of like being able to re-use code myself.  ;)

It's a win to have *one* pcf8574/5 driver that can be
reused -- with a bit of care configuring it into the
system -- instead of having every board contribute yet
another board-specific hack in drivers/i2c/chips ...

And I think such stuff can be done even with OF.

- Dave
