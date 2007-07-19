Return-Path: <linux-kernel-owner+w=401wt.eu-S938423AbXGSOp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938423AbXGSOp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbXGSOpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:45:47 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:27823 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755468AbXGSOpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:45:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=o233rGZGjP4ztbFWJ3VagnxJNjiwjWKUn6Cc7P8RjqCzvH2ii0tEa/tkkXeZ+gSwdb+t9MP7JDv0EHX2N0Zl2qUsl/mIVD8F98CgBtkjOAv3EGh6VAZRzgsrTknbEQvgvUeOFXK+CAje9OoDHIBo3i7VWAP7kN7PbkNtjLnTdYk=  ;
X-YMail-OSG: wlZGP.AVM1nUg0zFjNbYvnu1yr1SBTQrLJ0Z2fC7xQsY.0WTP.v.eeZ4SGA_pv6O4h1fphLe9w--
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 1/1] Driver for the Atmel on-chip SSC on AT32AP and AT91.
Date: Thu, 19 Jul 2007 07:45:42 -0700
User-Agent: KMail/1.9.6
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       kernel-avr32 <kernel@avr32linux.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <1184568752.15535.9.camel@localhost.localdomain> <20070719110122.262c2778@dhcp-255-175.norway.atmel.com> <20070719113136.4d0a951f@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070719113136.4d0a951f@dhcp-255-175.norway.atmel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707190745.43151.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007, Haavard Skinnemoen wrote:

> > So the protocol drivers need some kind of resource management in order
> > to not step on each others' toes, and that's the reason for the export
> > of ssc_request() and ssc_free().
> > 
> > I'm not sure if anyone would have been very mad at me for sneaking this
> > in through the avr32 tree, but I'd really like to know what others, in
> > particular the AT91 people and David, think of this kind of thing
> > before it ends up in mainline.

Does this work with both AT91 and AVR32 instances of SSC-to-at73c213
audio output hardware?  Clearly it "should".

This "kind of thing" seems pretty routine.  I see it all the time with
timer modules and DMA channels ... as well as flexible serial links like
this "SSC" module.  (Other serial-link examples include McBSP on OMAP,
SSP on PXA, and lots of non-AC97 audio data stream links.)

In this case a simple request/free interface is enough, since only one
module will hook up to the external hardware.  (Here, a Codec/AMP chip.)
In other cases the request may imply a more complex choice algorithm
than just matching IDs:  the particular DMA channel or timer returned
may not matter.  So for now I think hardware-specific APIs are OK.

Thing is, these don't fit very nicely into the driver model since not
all instances of that silicon module will use the same driver.  One
instance might manage a bidirectional audio stream through a codec;
another might implement the control interface to that code using SPI;
while a third might manage a custom data acquisition interface.

- Dave
