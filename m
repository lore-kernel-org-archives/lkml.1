Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbYKZEQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbYKZEQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYKZEQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:16:03 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:47781 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752923AbYKZEQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:16:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LNQ7wCGxRPRDMn5WGu1nh4S5PBG+zthgzw+QItmav6PetvPLiFjsGxv7Onh8VGQo6c8Id5PTAKx4eNCiHNkkLsazAnTNByKMYDwZ26OlnjwwzvDEcKbVBQpza1IDIz5U77TZyhx5J/mp523avz+FM5ET3lJrJR5C1O6XP6gb8Yo=  ;
X-YMail-OSG: w22UhCAVM1n84v_EkFSUFoWJOh0H8AF6Hv1wdDufBBRiw5L.eCxTRJQ.28aSG99ZJL9Wo2ixpbJGupPemZ2Y_Y8E1SlGCdosLaomNMUGStd6tC_oI57JMz8w4oBTH7P8Sp5JptyY3rXfplrEFTAPa.4kw5AFktQ.kEvoFco-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Eric Miao" <eric.y.miao@gmail.com>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Tue, 25 Nov 2008 20:15:56 -0800
User-Agent: KMail/1.9.10
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Jean Delvare" <khali@linux-fr.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <f17812d70811251720u47bec50dt3734f5b2bb0d339@mail.gmail.com>
In-Reply-To: <f17812d70811251720u47bec50dt3734f5b2bb0d339@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811252015.57870.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008, Eric Miao wrote:
> Using a bit mask will be more generic if the GPIOs are not contiguous.
> Yet I still doubt this will be generic enough to be added to gpiolib.

My expectation for this kind of mechanism was that systems who need
to craft another parallel bus out of GPIO pins would be doing this
with some system-specific utility functions.

So my "is it generic enough" question is more at the level of "Are
there enough Linux systems that need this sort of thing to justify
generic support?".  I happen not to have come across the need for
such ganged access from Linux (yet).  Whereas I've yet to use non-x86
Linux systems that don't need to manipulate individual GPIO pins...


> The user of this gpio_set_value_bus() may assume too much about
> the internal, e.g. how many GPIOs on the chip and whether these GPIOs
> are contiguous or not, and whether this GPIO chip support bitwise
> operations.

Actually I would expect that to be addressed by the hardware designer.

As in, if you're bitbanging a 16-bit parallel bus (plus several
control signals -- chip select lines, address latch, r/w, etc) the
board would be designed for efficient bitbanging, by taking care
that the software bus ops aren't stupidly complex.  So I guess I'm
agreeing with Eric there:  wanting this kind of stuff at all seems
to imply being fairly low-down'n'dirty.


Example, assuming a 32 bit GPIO bank, the data lines would probably
be all adjacent and politely ordered by the board designer so that

	/* write a 16 bit value on the specfied data lines,
	 * assuming the intermediate state doesn't matter...
	 */
	writew(0xffff << N, &bank->clear_bits);
	writew(value << N, &bank->set_bits);

instead of needing to compute some complex permutation of those
bits ... and similarly

	/* read a 16 bit value from the specified data lines */
	value = 0xffff & (readw(&bank->read_bits) >> N);

possibly after handshaking with the device on the other side
about changing signal direction, again without permutation.

But heck, maybe there just aren't that many adjacent GPIOs free,
because of alternate functions that are used... ugh.


Note also that this proposal only includes

> > +       void                    (*set_bus)(struct gpio_chip *chip,
> > +                                          unsigned offset, int values,
> > +                                          int bitwidth); 

not its sibling read operation.


> Let's have a concrete example: what if the user gives a bunch of GPIOs
> that crosses the chip boundary, say, GPIO29 - GPIO35 (with each chip
> covering 32 GPIOs).

I'd care more about the upper level operation being performed ... like the
control protocol for passing the address of a word being read or written
and then switching the bus from address to data read (or write) mode to
get the word, then yielding the bus access.

- Dave

