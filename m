Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbZBYBNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbZBYBNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZBYBM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:12:29 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:47052 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754595AbZBYBM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:12:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qDKOX9UjLNUtPAJ8JNRMullxQME6Xa6xRkC60lCdacR+Smh3UY588qJ4hik1vDfEBM+ujyLhYEJEXPyldjw+LM5y5F5p27gGq0ZEQTo2K5NKDi9hUbSzM1m6XjqUSpzzwgstit39iJM/OqhNiXApYZjP5zZ2Uw+oPLvKD/AXs9U=  ;
X-YMail-OSG: qUA3dfAVM1na3AUYqZ6MOeGHsDR6XkgXhMCRvNdkiSjQwdKXaMHO305p7dy8_8SzNcCyiwG3F6lOuCorI0SUtvMybefzrloeRjtTjGSqcMaK2uzogMLjgwkEhW_dSSZG.GnWudYtGQK4wmcsqLnY3LCx
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Tue, 24 Feb 2009 16:17:22 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902231252.01980.david-b@pacbell.net> <20090224222328.GA21553@sirena.org.uk>
In-Reply-To: <20090224222328.GA21553@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241617.22643.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Mark Brown wrote:
> On Mon, Feb 23, 2009 at 12:52:01PM -0800, David Brownell wrote:
> 
> > Use those methods to force machine-level constraints into bounds.
> > (Example:  regulator supports 1.8V, 2.4V, 2.6V, 3.3V, and board
> > constraints for that rail are 2.0V to 3.6V ... so the range of
> > voltages is then 2.4V to 3.3V on this board.)
> 
> Being able to support this is definitely a win, thanks for looking at
> this.

Likewise consumers being able to see what voltages are available...


> > +	/* maybe force machine-wide voltage constraints to match the
> > +	 * voltages supported by this regulator.  use the regulator's
> > +	 * entire range for boards with no particular constraints.
> > +	 */
> 
> I'd really rather the second bit weren't here.  I'd like to see a
> warning for the first part.

Fixable in an update.  I still think it's better to require less
manual configuration, not more ... manual configuration is by
definition error prone; requiring more manual configuration makes
systems be more fragile.  Which is why I wouldn't naturally want
to see a warning:  it implies manual configuration is desirable.


> > + * @count_voltages: Return the number of supported voltage indices which
> > + *	may be passed to @list_voltage().  Some indices may correspond to
> > + *	voltages that are not usable on this system.
> > + * @list_voltage: Return one of the supported voltages, in microvolts;
> > + *	or negative errno.  Indices range from zero to one less than
> > + *	@count_voltages().  Voltages may be reported in any order.
> 
> I'm having a hard time loving this interface for the driver.  It feels
> fairly cumbersome to have to provide two functions to look up what I'd
> expect to be static data - I'd be fairly surprised to see it change at
> runtime. 

It can be a function of configuration, and I didn't want to force
such seldom-used data into wasteful standardized-format tables.
Notice that with the twl4030 code, a functional interface takes
less space ... and is more flexible, since it copes with the
voltage options that are defined as "not supported".

Function accessors can use static const data when that's appropriate.
But going the other way around isn't very straightforward...

Consider also the TPS6235x regulators:  the voltages they support are
a simple linear function of an index 0..63, and that driver handles
seven such chips.  64 values * 4 bytes * 7 chips == about 2KB of
table data ... vs a few dozen bytes of function code.

Again, the tradeoff looks to me like a clear win:  this functional
interface is small, simple, clear, flexible.


> I think I'd expect to see something more like the way ALSA 
> represents dB scales where the driver supplies a list of ranges that can
> either be simple values or value ranges expressed as (start, step,
> count).  That would cover both complicated cases like the TWL4030 and
> the other common case with large regular ranges of voltages.

Another virtue of functional interfaces for enumeration is
they avoid the need for callers to see and handle a variety
of different models, like that!!

Do you really think it's easier to have to write code like

	if (regulator uses table model) {
		table iteration code {
			check(get(i))
		}
	else if (regulator uses start/step/count model) {
		start/step iteration {
			check(something)
		}
	else if ... another model-du-jour ... {
		...
	} else
		error

Instead of a one simple flexible model?

	limit = get_limit();
	for (i = 0; i < limit; i++)
		check(get(i));

 
> This mostly applies to the driver interface - on the consumer side it
> feels a bit cumbersome to use but I can't think of anything that's
> particularly better. 

There's a LONG history of functional iterator models, such as
the one I used.  I think they are clearly better, and don't
understand why you'd prefer that more cumbersome approach.


> An interface that also allows consumers to ask if 
> particular ranges can be satisfied might help here - it'd be nice for
> things like MMC that want to check for a relatively small set of
> voltages or voltage ranges (which I'd expect is the common case).

Umm, did you look at the MMC patch I sent?  It shows
how the $SUBJECT interface fits nicely with what the
MMC framework needs.  mmc_regulator_get_ocrmask() took
just thirty (ARM) instructions.

MMC doesn't want to "check" like that.  It wants to get
a mask of supported voltages, then AND it with the mask
reported by the MMC/SD/SDIO/eMMC/CE-ATA/... device to
pick a voltage supported by both host and card.

- Dave


