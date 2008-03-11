Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYCKCIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYCKCIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbYCKCHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:07:46 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21568 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755943AbYCKCHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:07:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MIVB9oZQ3apLnpdu+6uWWOl9rzpdm8zq/3+jSrlqyxKFPc2QUMR1AojHz07UD6uI1oFcze7UR/3Q3+fj0eQO8Wr4BA96+Knsigjqco8C5aTKk8rIIP/wdEXcvZqtjINeSFBwnTMBe7r8nZH7NpUUtJID8koUXL96H84Hp1oXDxE=  ;
X-YMail-OSG: IbeWlCEVM1mj_5ECmiehV9EvDfzMb.0s__4DjgEG2GhsClk6hrAI7vecUb7NaU1gNR98fb1LJA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Mon, 10 Mar 2008 18:00:25 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803071943.14805.david-b@pacbell.net> <1205061053.13653.114.camel@localhost.localdomain>
In-Reply-To: <1205061053.13653.114.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803101900.25430.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008, Liam Girdwood wrote:
> 
> > > +int regulator_set_voltage(struct regulator *regulator, int uV);
> > 
> > You described a mode where consumers could set ranges that
> > might overlap (e.g. 1.6 to 1.9V, 1.8 to 2.0) and the result
> > would be some compatible result.  But I don't see how that
> > could be achieved, since that's the only call to provide
> > a consumer's constraints.
> 
> In this example the power domain constraint (not consumer constraint)
> would be 1.6 - > 2.0 V. 

I was actually thinking of a chip I've used which has four
prgrammable regulators:

  * Three are similar ... they can supply 2.5V, 2.75V, or
    3.0V; plus a regulator-specific fourth setting of either
    3.3V, 1.8V, or adjusted by board-specific feedback.

  * The fourth has eight settings (from 0.85V up to 1.6V).

Those are the hard power domain constraints for the chip.

But any given board (set of "consumers") needs to be able to
provide additional constraints.


> i.e. this range is safe for all consumers on 
> this domain as all can operate at 2.0V and some can operate as low as
> 1.6V.

You've declared similar hidden assumptions in response to some
of my other questions.  Such hidden assumptions are not helpful.
Best to document them, if they survive discussion ...

One assumption is that consumers can't make constraints.  That's
because of a second one, that somehow board designers can and will
ensure they don't need to.

I don't buy that.  If the designer ensured that there would be
no need for such constraints, then why even have a set_voltage()
request?  That adds a constraint ... but it's an inflexible one.


But maybe the broader issue is:  just what model are you using
for customization here?  At what points are constraints specific
to a chip, board, or external connection applied?


My assumption is that the regulators themselves should know
only about their hard constraints ... most often specific to
the chip (this regulator is optimized for these voltages),
but sometimes specific to a given board's wiring (e.g. the
resistor ladder for a given voltage feedback channel).

And then additional constraints could come from consumers,
which would basically be of two types:  (a) board setup code,
and (b) drivers that cope with various situations, some of
which are externally imposed.  Those drivers would tend to
need just on/off controls for power domains they manage,
but in some cases (like the MMC example I mentioned) would
need more capability than that.


> The actual regulator output will be determined by consumer voltage
> requests. e.g. On power domain A, consumer x sets 1.8V and consumer y
> sets 1.9V, hence regulator output will be 1.9V. (as y needs 1.9 to
> operate, but x can operate at 1.8 - 2.0)

So when consumer X tunes everything to run in a low power mode
(using 1.6V as a better example), consumer Y can come along and
change things (to 2.0V ... 25% higher voltage, a "huge" delta)?

How would consume X know that it's got to re-adjust things, and
shift out of a low power operational mode?  Or prevent the need
to do that?  (Or vice versa.  Y could come first, preventing X
from entering a low power mode ... though maybe X could still
run in a high power mode.)


> > Presumably one configures a voltage then enables it?  How
> > does one turn a voltage supply on or off?  I'm guessing
> > that zero volts doesn't equate to "off"...
> 
> Some regulators cant go down as far as 0V ;)

For the ones that can, shouldn't that be equivalent to disabling
the regulator?  And for ones that can't, doesn't that mean
that regulator can not be enabled or disabled??

This "interface" definition is at best vague about quite a
lot of issues like these.

 
> We have regulator_enable() and regulator
> regulator output.
> 
> e.g. set voltage -> enable -> do some stuff -> disable. 

Would it be allowable to enable -> set voltage too?

Oh ... and if the regulator doesn't have a setting for
the specific voltage requested, is it allowed to choose
something "close"?  (How close is close enough?)  Or must
it instead fail?

- Dave

