Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYG0Xa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYG0Xa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 19:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYG0XaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 19:30:16 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:31951 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752947AbYG0XaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 19:30:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RAbyk2hjJL+5s9J7HC4maBXTGpral9qkBq2qSlbhJHVFzeU6J/KnXnipO14DXd+V8XHslRFryiViatCv66cI/QonIN/xr+A3GuhEVgBZUHoVl/lsWW5xJPP0aWMIph58S7h6DI4nW5XzevzuNKyupbmcVDEgSinfRhpCNReUKdk=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Date: Sun, 27 Jul 2008 16:30:07 -0700
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>, gregkh <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807182201.33913.mb@bu3sch.de> <200807211341.35766.david-b@pacbell.net> <20080721135332.4ce02e0c.randy.dunlap@oracle.com>
In-Reply-To: <20080721135332.4ce02e0c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807271630.07939.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I just now saw your reply ...

> On Monday 21 July 2008 22:41:35 David Brownell wrote:
> > So what this driver adds is mostly a userspace interface, yes?
> 
> Mostly. It also provides a simple platform device.

Yeah but I don't like interfaces like that ... which provide
less functional clones of existing interfaces.  If the goal is
convenience, then just wrap the existing ones together to give
the "one stop shopping" experience.

 
> > Please switch to the more conventional "MOSI" (Master Out, Slave In)
> > and "MISO" (Master In, Slave Out).  That's unambiguous.  If you want
> > to be a bit more clear you could say that MOSI goes to the MMC/SD
> > card pin 2 (card data in), and MISO goes to MMC/SD card pin 7 (card
> > data out).
> 
> Maybe.

Not clear what you mean.  You are using "DI" and "DO", which is quite
ambiguous (data in to card?  or data in to host?).  And you don't say
which direction is meant.  So that's ambigious ... just like "maybe".


> 
> > > > +	if (res < 8)
> > > > +		pdata->p.no_spi_delay = 0; /* Default: Delay turned on */
> > > > +	if (res < 7)
> > > > +		pdata->p.max_bus_speed = 5000000; /* Default: 5Mhz */
> > 
> 
> > So I'd default to leaving the delay off
> 
> How to?

Simplest to just rip out the support for using one!  And in any case:
as a rule, any delay should be a function of the target bus speed.

If you wanted to get fancy you could measure how long it takes to issue a
non-inlined GPIO call, and solve for the delay:

	cycle time = 1/max_speed_hz
	cycle_time = 4 * call_cost + 2 * delay_len

One way to measure would be wrapping ktime_get_ts() calls around a loop that
toggles the SPI clock a few hundred times.


> > > > +	if (res < 6)
> > > > +		pdata->p.mode = 0; /* Default: SPI mode 0 */
> > 
> > Don't need to do this.  The mmc_spi driver forces mode 0 in
> > any case...
> 
> Where's that documented?

UTSL ... mmc_spi_probe(), first thing.  :)


> > > > +config GPIOMMC
> > > > +	tristate "MMC/SD over GPIO-based SPI"
> > 
> > "Sysfs interface for ..."
> > 
> > Because we can already do MMC/SD over GPIO-SPI,
> > without using this code.
> 
> This also adds a platform device interface for convenience
> (as it also uses that internally).

Don't export that.  It's a (less expressive) subset of the standard
way to do that.


> > > > + * @no_spi_delay: Do not use delays in the lowlevel SPI bitbanging code.
> > > > + *                This is not standards compliant, but may be required for some
> > > > + *                embedded machines to gain reasonable speed.
> > 
> > Rather than emphasize "not standards compliant", I'd instead emphasize that
> > bitbanged SPI is so slow that you probably don't want to slow it down any
> > more by additional delays between per-bit operations!
> 
> I'd say you cannot tell how fast the GPIOs are. They can be pretty fast
> on a huge machine.

Huge machine tends to mean lots of busses to traverse before getting to
where the actual I/O gets performed.  Like a PCI posted write, followed
by a read to make sure the write completed and the I/O was performed.

Regardless, the point isn't standards, it's platform performance ... which
is, in all cases I've used bitbanged SPI, at most 1 MHz when non-inlined
GPIO calls are used.  And many times faster with inlined calls that go
directly to the GPIO controller...


> > Again, please don't promote a *SECOND* platform-device based mechanism
> 
> It is not a second mechanism, it is a mechanism on top of the first two
> mechanisms.

There's already a way to define an MMC-over-SPI device.  This is another
one.  In what way would that not be a "second" mechanism??


> > > > +Registering devices via platform-device
> > > > +=======================================
> > > > +
> > > > +The platform-device interface is used for registering MMC/SD devices that are
> > > > +part of the hardware platform. This is most useful only for embedded machines
> > > > +with MMC/SD devices statically connected to the platform GPIO bus.
> > 
> > There is no "platform GPIO bus" ... 
> 
> hm??

If you look in /sys/bus you won't see GPIO.  It's not a bus.


> > This is the interface I'd rather just not see exposed ...
> 
> People asked me to expose it. It was hidden in the first patch that
> I submitted. I'm not going to change this just to see the next one
> yelling "I want to see this interface in public" again.

Could you send me some URLs for that feedback?  Again, I'm not keen
on adding a second (and less functional) way to do this.


> 
> > > > +Registering devices via sysfs
> > > > +=============================
> > 
> > This is the interface I don't have any particular issues with.
> 
> Yeah, but it's gone. See updated patches.

I meant "the userspace interface".  I did see the update patch
that changed it to use about configfs.



