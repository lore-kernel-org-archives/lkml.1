Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYK2W43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYK2W43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 17:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbYK2Wzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 17:55:39 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30486 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753076AbYK2WzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 17:55:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=NYHw26V2TjXv8ebb/DGqtBDyjDarxkbx6KuY0Awub0T51H73IfFgWffO08Z+to2mvQl7MfEamKbtELTnJEhQ0rwHLKWYG77lSQDtWcK/HjbQoyS7DOnr2lyuyva03eMVSV4ebtCX1+6inYuCxdlm5tGFYebhGfSoF1bZ14C2rZE=  ;
X-YMail-OSG: gJqba3sVM1nZ7EuO2t5E2_ySIe8QHqJX.2Kxwp3ID8WJea1O0psujZU7ZlU8Fmz.gdDC7lW2Y7wMqKl7GGf8O_Zwjfn02jak2xfQPFQMVktxY9P1itlq3F3CNhh2.uBexlZiH7CPUpudWFXbLPSWiaLnpKOHSfgUo5bqFmE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Sat, 29 Nov 2008 14:54:15 -0800
User-Agent: KMail/1.9.10
Cc: "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Jean Delvare" <khali@linux-fr.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200811252015.57870.david-b@pacbell.net> <45a44e480811252151q54580e07xfa73d69596fbfaac@mail.gmail.com>
In-Reply-To: <45a44e480811252151q54580e07xfa73d69596fbfaac@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811291454.17110.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008, Jaya Kumar wrote:
> In the area of framebuffers for lower end display devices, I find this
> to be quite common.

I'd have said "display modules" myself, although I don't
currently have any Linux systems using them.  Some of
those modules use SPI, since it tends support DMA for
downloading the image data ... although admittedly those
are not the very lowest end devices.


> I have also seen this in systems such as 8-bit A2D devices, also with
> various coprocessor solutions where a smaller CPU like a msp430 or
> HC05 would clock data to the host using 8-bit gpio data.

When I hear "coprocessor" I think more like Video DSPs.  ;)

And for microcontrollers (msp430, avr8, etc) hooking up,
I've usually seen them use a serial bus (I2C, SPI, etc).

But it's also true that when data transfer rates matter,
it's faster to talk to microcontrollers using a parallel
bus than such a serial bus.  The Linux SOC it's talking
to can probably clock SPI an order of magnitude faster
than the microcontroller tolerates.  And the reason you
want a dedicated microcontroller is for predictable
(a.k.a. "realtime") monitoring tasks, which they can't
do if they're spending all their time talking to Linux.

Sounds like you're working with a bunch of semicustom
monitoring/control designs?


If you want to pursue this, I'd like to get the gpio_chip
proposal in place first:  bitmask read and write, without
forcing an "all bits are contiguous" policy.  Lightweight.

Maybe it should suffice to have a gpio_chip support the
bitmask ops, instead of just bit-at-a-time ones... so it'd
be practical to incorporate this by itself, given patches
to convert a couple gpio_chip implementations.

Then separately two more things:

 - A gpio_* interface proposal for higher-level bitmask calls.
   This is worth some discussion; the calls should clearly
   be optional (not everything will implement them), and I
   can't help but suspect <linux/bitmap.h> interfaces should
   interoperate smoothly.

 - A gpiolib based implementation, using those new gpio_chip
   methods as accelerators if they're present.  This should
   probably also be optional, even at the Kconfig level; many
   systems won't need to spend memory on these calls.

Right now you seem to have smooshed together those three
things, which probably helped get your sample driver going
faster but isn't a very good way to move forward.  Don't
assume gpiolib when defining the interface.

- Dave
