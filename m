Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZBIAEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZBIAEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZBIAEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:04:32 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:41266 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753520AbZBIAEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:04:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1rx9p1bWp5finh4LIw5A3nG5lFR6h5AzN83WJJkyJeZLasrZ4hQJxy8Qkks8v3/VSqL+4OO0M+fn3IyJiVVXaJYRp7yQF0yzBiiwr4jevP6pHz9J8xvofcvcUApwkJewdEccGSo9eEdkItnwnsBmrMeIjGUpKTx59x4Dp1L8yYY=  ;
X-YMail-OSG: ezZEaP0VM1lAse5pQzT_9lp5Nj4UIPldktHPn5hbaPRKFsv9NvT4RK56KMOL4n9VvEStRgddS4WvuoOs9QfzQOEpGfYiIgV1Vb274KaA35kSf_IMgxRRBc87hfoVZEYh3K0Ka7N1Lzi6Mafz3MP7JsoIWEWwxugm8VU1gZcSjFNWaW2V13IbhN1JKLYT
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc3-git 1/2] regulator: twl4030 regulators
Date: Sun, 8 Feb 2009 16:04:29 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <20090208232922.GA16966@sirena.org.uk>
In-Reply-To: <20090208232922.GA16966@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902081604.29905.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Mark Brown wrote:
> > +     /* Constrain board-specific capabilities according to what
> > +      * this driver and the chip itself can actually do.
> > +      */
> > +     c = &initdata->constraints;
> > +     if (!c->min_uV || c->min_uV < min_uV)
> > +             c->min_uV = min_uV;
> 
> If we're going to do this I think it'd be better to push it into the
> core and let the regulators pass in a set of constraints so that the
> behaviour will be consistent between drivers.

Maybe, but there is no such mechanism right yet.
When it's created, then this could switch over.


> I'd also expect to have the registration fail or at least issue a
> warning if the code kicks in since that indicates that the board
> constraints have been set up incorrectly.

A warning might make sense in some cases ... that's
something I would expect to see from the regulator
core, though.  Example, I see no "max < min" checks
triggering registration errors.


> There's a reasonable chance 
> that the fixed up constraints will still need to be changed for the
> board to be configured properly and things may end up being driven out
> of spec, potentially causing damage.

I don't see that happening ... all that code does is
tighten existing constraints to match what the hardware
can do.  The result is just a subset of the range the
board already said was OK.  If no valid subset exists,
that's a board design bug ... albeit one the regulator
core could detect.  (E.g. those "max < min" checks that
don't currently exist.)

I can easily imagine having things partially set up, and
not really caring whether, on a particular board, those
initial constraints are really the most specific ones
applicable.  One component tolerates a range of 1V8..3V6
maybe, but on any given board it can be hooked up to any
supply that's even partially in-range.

If I hook such a component up to a supply supporting 1V2
through 2V5, it's really no worry that the 1V2..1V8 part
of that range won't be used; or if 2V5..3V6 could also
work.  Those options really don't matter at all.  The
only significant part is that only the 1V8..2V5 will be
software-accessible on that board.

- Dave

