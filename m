Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYILQ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYILQ1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYILQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:27:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbYILQ1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:27:01 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>, Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Fri, 12 Sep 2008 12:24:33 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200809121224.34345.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 15:49:25 Stefan Bauer wrote:
> Jarod Wilson wrote:
[...]
> >> > +static inline unsigned int sinp(int offset)
> >> > +{
> >> > +#if defined(LIRC_ALLOW_MMAPPED_IO)
> >> > +	if (iommap != 0) {
> >> > +		/* the register is memory-mapped */
> >> > +		offset <<= ioshift;
> >> > +		return readb(io + offset);
> >> > +	}
> >> > +#endif
> >> > +	return inb(io + offset);
> >> > +}
> >>
> >> This all looks like a reimplementation of ioport_map() and the
> >> associated ioread*() and iowrite*() functions...?
> >
> > Probably. Will see about using those instead.

>From what I've been able to ascertain, reducing the above to...

static u8 sinp(int offset)
{
        if (iommap != 0)
                /* the register is memory-mapped */
                offset <<= ioshift;

        return inb(io + offset);
}

...should be sane. inb() either calls ioport_map() and ioread8() as needed, or 
defines inb() as readb() (or __raw_readb()) on platforms where its 
appropriate. (and similar for lirc_serial.c::soutp()).

> >> Nothing in this function does anything to assure itself that the port
> >> actually exists and is the right kind of hardware.  Maybe that can't
> >> really be done with this kind of device?
> >
> > We should probably try to make sure the port actually exists, but I don't
> > think there's a whole lot (if anything) we can do as far as verifying the
> > device itself.

I've borrowed the simple existence test from 
drivers/serial/8250.c::autoconfig(), which tries a few reads and writes from 
UART_IER. I think this is probably sufficient for verifying the port is legit.

Christoph B., you're definitely much more familiar with serial IR devices than 
I am... Is there any sort of test you can think of that we could use to try to 
verify the existence of an IR device hooked to the port? Or should we be happy 
we at least know there's a port and just assume the IR device is there?


> I just want to thank you very much for your work and give you my Tested-By.
> Todays git (b2e9c18a32423310a309f94ea5a659c4bb264378) works well here with
> lirc-0.8.3 userspace on a Pentium 3/i815-system.

Oh good! I haven't broken anything further w/my changes up to b2e9c18... ;) 
I've got another slew of updates to lirc_serial still pending though -- a few 
that I'm about to push, and at least one more chunk I still need to figure out 
(the hrtimers/rdtscl bits).

Continued testing would be much appreciated, since I still have no serial IR 
hardware myself (couldn't find the thingy that shipped with my Technisat card, 
but I do now have hardware on the way).

> But I've had a section mismatch in the lirc code, don't know if this is
> serious.
>
> WARNING: drivers/input/lirc/lirc_serial.o(.init.text+0x11e): Section
> mismatch in reference from the function init_module() to the
> function .exit.text:lirc_serial_exit()
> The function __init init_module() references
> a function __exit lirc_serial_exit().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __exit annotation of
> lirc_serial_exit() so it may be used outside an exit section.

Ah, I believe you're absolutely correct. Done.

-- 
Jarod Wilson
jarod@redhat.com

