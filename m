Return-Path: <linux-kernel-owner+w=401wt.eu-S932132AbXKOS4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbXKOS4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXKOSzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:55:51 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:22177 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759960AbXKOSzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:55:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Nk/3yp2pgvnkaF4Odb1QgPHz1Bg3Q+QxZVZkguB4yHHAqviLGMi+XG1lUXsj1+JAG+YMxtrge2z/UP5J4/Cm4WfMF9QUhnE9oAkvxGxc6tXlgstsyiqphXYZFk7MSSBahf4cIsK80xDtetQaVpiz/aoWvcElI7UjHOIUzbbmWdI=  ;
X-YMail-OSG: jCpclMQVM1kK7xrPrXenc8FtbwR1rwZUNDkLtoKFi2EkXBJL
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Thu, 15 Nov 2007 10:55:42 -0800
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>
References: <200711091136.20051.david-b@pacbell.net> <200711150020.33887.david-b@pacbell.net> <20071115095123.3f595b62@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20071115095123.3f595b62@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151055.43312.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007, Haavard Skinnemoen wrote:
> On Thu, 15 Nov 2007 00:20:33 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > > >   - gpio_direction_input()/gpio_direction_output() implicitly
> > > >     request the pins, if they weren't already requested.  
> > > 
> > > Eek, that's completely wrong. Allowing to access a resource _before_
> > > it is assigned and then doing the assignment implicit is a really bad
> > > idea.  
> > 
> > This is an artifact of making the GPIO interface easy to adopt,
> > by letting all the initial adopters wrap "legacy" SOC-specific
> > GPIO interfaces instead of creating a bunch of new platform code.
> 
> It's still ok for platforms that do not use gpiolib to provide NOP
> gpio_request() and gpio_free() functions if they don't care about
> tracking gpio usage.

In fact they *must* provide some implementation of those calls,
and several platforms do exactly that.  (Since the legacy GPIO
code didn't use such primitives ... nothing to wrap.)


> That doesn't mean we shouldn't require all drivers 
> to use those calls -- if they are implemented as empty inlines, it
> won't cost anything to call them.

Thing is, issuing those calls is not currently mandatory ... so
requiring use of them would be an incompatible API change, which
would require auditing (and fixing, and testing) much platform code.


> I'd rather speed up the gpio_direction_* functions a bit by removing
> the implicit gpio_request() since they may be called a lot more
> frequently and, as you pointed out, possibly from atomic context.

In fact, possibly before IRQs get set up ... some platforms start
using GPIOs very early in system setup.

- Dave
