Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYKZFvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYKZFvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYKZFva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:51:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:57988 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYKZFv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:51:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jQBIIDyVdJfKEH4aZO34F0+UTNj+fIBtmiVYkUMkJ5WoQkTbTRWfY9y8lqPyIBaWdb
         VtVqWi+4RF+MZsK+WyR1UspdhHr/Vrf8DMPRbw6DdPT8cUSC0Bu7Hqq6/nYLtsSQGA2L
         vae66s/KuyiXv65TSOucMyXcoxBfgevZls8e0=
Message-ID: <45a44e480811252151q54580e07xfa73d69596fbfaac@mail.gmail.com>
Date: Wed, 26 Nov 2008 00:51:27 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
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
In-Reply-To: <200811252015.57870.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <f17812d70811251720u47bec50dt3734f5b2bb0d339@mail.gmail.com>
	 <200811252015.57870.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 11:15 PM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 25 November 2008, Eric Miao wrote:
>> Using a bit mask will be more generic if the GPIOs are not contiguous.
>> Yet I still doubt this will be generic enough to be added to gpiolib.
>
> My expectation for this kind of mechanism was that systems who need
> to craft another parallel bus out of GPIO pins would be doing this
> with some system-specific utility functions.
>
> So my "is it generic enough" question is more at the level of "Are
> there enough Linux systems that need this sort of thing to justify
> generic support?".  I happen not to have come across the need for
> such ganged access from Linux (yet).  Whereas I've yet to use non-x86
> Linux systems that don't need to manipulate individual GPIO pins...

I have come across the following scenarios where a bus set of gpio is useful:
- Broadsheet E-Ink controller (uses 16-bit data bus over GPIO)
framebuffer device (this patch is for this)
- Apollo/Hecuba E-Ink controller (uses 8-bit data bus over GPIO)
framebuffer device
- 8-bit parallel IO matrix LCD controllers, such as the Samsung KS108,
also Hitachi, etc

In the area of framebuffers for lower end display devices, I find this
to be quite common.

I have also seen this in systems such as 8-bit A2D devices, also with
various coprocessor solutions where a smaller CPU like a msp430 or
HC05 would clock data to the host using 8-bit gpio data.

>
>
>> The user of this gpio_set_value_bus() may assume too much about
>> the internal, e.g. how many GPIOs on the chip and whether these GPIOs
>> are contiguous or not, and whether this GPIO chip support bitwise
>> operations.
>
> Actually I would expect that to be addressed by the hardware designer.

I agree that the gpio's are always contiguous. It would be very
unusual (I've never seen it yet) where a hardware designer picked
non-consecutive pins to be used for a bus. In the case of AM300, the
board designer picked the xscale's 58 - 73 gpio pins.

>
> As in, if you're bitbanging a 16-bit parallel bus (plus several
> control signals -- chip select lines, address latch, r/w, etc) the
> board would be designed for efficient bitbanging, by taking care
> that the software bus ops aren't stupidly complex.  So I guess I'm
> agreeing with Eric there:  wanting this kind of stuff at all seems
> to imply being fairly low-down'n'dirty.

Yes, agreed, handling the contiguous bus case turned out to be quite
straightforward and the core is just about 30 lines of code.

+       do {
+               chip = gpio_to_chip(gpio + i);
+               WARN_ON(extra_checks && chip->can_sleep);
+
+               if (!chip->set_bus) {
+                       while (((gpio + i) < (chip->base + chip->ngpio))
+                               && bitwidth) {
+                               value = values & (1 << i);
+                               chip->set(chip, gpio + i - chip->base, value);
+                               i++;
+                               bitwidth--;
+                       }
+               } else {
+                       value = values >> i; /* shift off the used stuff */
+                       remwidth = ((chip->base + (int) chip->ngpio) -
+                                       ((int) gpio + i));
+                       width = min(bitwidth, remwidth);
+
+                       chip->set_bus(chip, gpio + i - chip->base, value,
+                                       width);
+                       i += width;
+                       bitwidth -= width;
+               }
+       } while (bitwidth);


>
>
> Example, assuming a 32 bit GPIO bank, the data lines would probably
> be all adjacent and politely ordered by the board designer so that

A typical board designer will ensure that the selected pins are
consecutive. But I think given today's rapid development time, I'd be
hard pressed to ensure that they're also register consecutive. In the
case of AM300, the designer picked a pin sequence that spans 2 32-bit
registers since it starts at 58 and ends at 73. So it spans the 32-63
and 64-95 registers. The code handles that case fine.

>
>        /* write a 16 bit value on the specfied data lines,
>         * assuming the intermediate state doesn't matter...
>         */
>        writew(0xffff << N, &bank->clear_bits);
>        writew(value << N, &bank->set_bits);
>
> instead of needing to compute some complex permutation of those
> bits ... and similarly
>
>        /* read a 16 bit value from the specified data lines */
>        value = 0xffff & (readw(&bank->read_bits) >> N);
>
> possibly after handshaking with the device on the other side
> about changing signal direction, again without permutation.
>
> But heck, maybe there just aren't that many adjacent GPIOs free,
> because of alternate functions that are used... ugh.
>
>
> Note also that this proposal only includes
>
>> > +       void                    (*set_bus)(struct gpio_chip *chip,
>> > +                                          unsigned offset, int values,
>> > +                                          int bitwidth);
>
> not its sibling read operation.
>

Yes, I figured I'd start with the most basic approach. Also, the
costliest operation in am300epd is the the actual framebuffer transfer
to the device which is just a lot of writes. If people want me to do
it, I can also implement get_bus.

>
>> Let's have a concrete example: what if the user gives a bunch of GPIOs
>> that crosses the chip boundary, say, GPIO29 - GPIO35 (with each chip
>> covering 32 GPIOs).
>
> I'd care more about the upper level operation being performed ... like the
> control protocol for passing the address of a word being read or written
> and then switching the bus from address to data read (or write) mode to
> get the word, then yielding the bus access.

The upper level protocol in this case is from broadsheetfb (also
posted). Here's the relevant code:

+static void broadsheet_issue_data(struct broadsheetfb_par *par, u16 data)
+{
+       par->board->set_ctl(par, BS_WR, 0);
+       par->board->set_hdb(par, data);
+       par->board->set_ctl(par, BS_WR, 1);
+}
...
which is called to transfer the fb via:
+static void broadsheet_burst_write(struct broadsheetfb_par *par, int size,
+                                       u16 *data)
+{
...
+       for (i = 0; i < size; i++) {
...
+               par->board->set_hdb(par, tmp);

Thanks,
jaya
