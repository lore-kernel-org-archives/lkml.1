Return-Path: <linux-kernel-owner+w=401wt.eu-S1761553AbZJMWVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbZJMWVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZJMWVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:21:13 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41559 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754173AbZJMWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:21:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=4Q63+9qOWeZ4HkvRvVvpGt7DUlt+gwlbwMKx/7em2ESUP8ngB/hdsGgEKsASF7HNLNLulLi14aMLBWVBGyViwWL2/pPRv4Vwn8WNx2SvbGmJw4iJvDEB9zpREH0hQvOhZdU4px+QDuyG00H59XHhGWRkym+xE0BtMDojyhWWDQo=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: mEwm9osVM1mZpClPO9hS331RSB.hYUeqQnVqOsVJn2ZthvN4hj.7JKf6TGyll5SFYxaZM0piJJsqtFjd4eB8fjXezpmE_BHxQzB4ROFqofa7OApYmgPP3LdmnUAgc7PDOF._LEztxLSOvbz2Koix9GmFkOaEZycv8K.QHpcd7vZNswTqhZlvagdUXnP9TLe2P.WZzU1JFwg73gDPfsG8wopzkMSegPVsF_UaMWNRJCH0tJNVffTXDPnFaLZYg.sFs2XgRjuYg4A.XbnFZqVfEH5Gmbp3b6s640jn
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Date: Tue, 13 Oct 2009 15:05:44 -0700
User-Agent: KMail/1.9.10
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, dsilvers@simtec.co.uk
References: <20091010134814.0bac8624@bike.lwn.net> <20091010135343.775e535f@bike.lwn.net> <1255327904.5347.79.camel@ben-desktop>
In-Reply-To: <1255327904.5347.79.camel@ben-desktop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910131505.44739.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 October 2009, Ben Nizette wrote:
> OK for something supposedly basic, all this gpio stuff is getting messy.

Sigh.  :(

One can only _expect_ that as infrastructure gets more widely
used, it (unfortunately) starts expanding.  And one _hopes_ the
growth does not turn into bloat.  This is a constant battle with
all tools and infrastructure.  


> The gpio framework was written to use gpio numbers as they were
> recognised as being common to all possible implementations of the
> framework.  

I'm not sure I'd put it that way.  Most SoC-integrated GPIOs
had vendor docs using names like "GPIO-n"; a few combined them
with bank IDs, like "Port C-19".  In all cases, the IDs could
be mapped to numbers ... ('C' - 'A') * 32 + 19, etc.  And mostly
they *needed* to have such a mapping, since GPIOs are often the
main flavor of external IRQ signal, and IRQs are numbered.

Embedded boards also use pcf8574 I2C GPIO expanders and such,
which can be modeled as just fancier banks where IO the calls
require sleeping access.  Enter gpiolib to pull such devices
into the API.

Plus of course, numbers are easily used as a global ID space,
on any platform.  Trivially, if one had a per-GPIO structure
(a thing to avoid, in general, for a single hardware bit!!),
the pointer to that structure is a number.  QED.


Originally, the only name-ish thing was labels for diagnostics,
to help associate for example GPIO-78 with nCS2 or SDA in the
/sys/kernel/debug/gpio listing or in diagnostics.

> I didn't notice Daniel's original patch fly by otherwise I would have
> said something at the time, but storing the names at the chip level
> seems an odd idea.  Given that at that stage they were only for sysfs
> id, why not just give them as an argument to gpio_export()?

Yeah, I wasn't wholly keen on that either.  Notice that we now
have gpio_export_link()... and that the names given in gpio bank
registration can conflict with the *existing* ones registered by
the gpio_request() primitives.

There's also some role conflict here ... the entity registering
the GPIO bank may not always know the purpose to which the GPIO
will be put, while the entity calling gpio_request() *does*.  And
what good is a name which presents the wrong purpose?

Plus, GPIOs may need to be registered very early -- preceding
core_initcall() in some cases -- which can be a long time before
the board-specific labels are available, e.g. in arch_initcall().

But the biggest issue is name uniqueness ...

- Dave
