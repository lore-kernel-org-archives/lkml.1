Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbYCKPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbYCKPTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYCKPTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:19:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55284 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752204AbYCKPTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:19:37 -0400
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <200803101900.25430.david-b@pacbell.net>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main>
	 <200803071943.14805.david-b@pacbell.net>
	 <1205061053.13653.114.camel@localhost.localdomain>
	 <200803101900.25430.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 15:19:34 +0000
Message-Id: <1205248774.13653.347.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 18:00 -0800, David Brownell wrote:
> On Sunday 09 March 2008, Liam Girdwood wrote:
> > 
> > > > +int regulator_set_voltage(struct regulator *regulator, int uV);
> > > 
> > > You described a mode where consumers could set ranges that
> > > might overlap (e.g. 1.6 to 1.9V, 1.8 to 2.0) and the result
> > > would be some compatible result.  But I don't see how that
> > > could be achieved, since that's the only call to provide
> > > a consumer's constraints.
> > 
> > In this example the power domain constraint (not consumer constraint)
> > would be 1.6 - > 2.0 V. 
> 
> I was actually thinking of a chip I've used which has four
> prgrammable regulators:
> 
>   * Three are similar ... they can supply 2.5V, 2.75V, or
>     3.0V; plus a regulator-specific fourth setting of either
>     3.3V, 1.8V, or adjusted by board-specific feedback.
> 
>   * The fourth has eight settings (from 0.85V up to 1.6V).
> 
> Those are the hard power domain constraints for the chip.
> 
> But any given board (set of "consumers") needs to be able to
> provide additional constraints.

I think we probably have some confusion over the nomenclature here (as
there are several 'levels' of constraint). I'll detail this in the docs
though. 

I think you are meaning the board (or power domain) constraint here:-

The regulator driver currently enforces the chip (or regulator)
constraints, whilst the power domain (board) constraints are defined in
board.c.

e.g.

struct regulation_constraints led = {
	.min_uA		= 0,
	.max_uA		= 27898,
	.valid_ops_mask	= REGULATOR_CHANGE_CURRENT,
	.valid_modes_mask	= REGULATOR_MODE_NORMAL,
};

struct regulation_constraints cpufreq = {
	.min_uV		= mV_to_uV(1300),
	.max_uV		= mV_to_uV(1600),
	.valid_ops_mask	= REGULATOR_CHANGE_VOLTAGE | REGULATOR_CHANGE_MODE,
	.valid_modes_mask	= REGULATOR_MODE_NORMAL | REGULATOR_MODE_FAST,
};

It designed to work as follows:-

1. Consumer: set voltage 1.8V
2. reg core: if 1.8V is not within board (power domain) constraint then
return err.
3. regulator (chip) driver: check that 1.8V is ok then write to chip to
change voltage.

> 
> 
> > i.e. this range is safe for all consumers on 
> > this domain as all can operate at 2.0V and some can operate as low as
> > 1.6V.
> 
> You've declared similar hidden assumptions in response to some
> of my other questions.  Such hidden assumptions are not helpful.
> Best to document them, if they survive discussion ...
> 
> One assumption is that consumers can't make constraints.  That's
> because of a second one, that somehow board designers can and will
> ensure they don't need to.
> 

A board designer must make sure that the power domain constraints are
within the regulator (chip) constraints. He must also make sure that all
consumers on a power domain can all operate similtaiously at the same
voltage and that they are not damaged by other domain consumers
operating at different voltages.

> I don't buy that.  If the designer ensured that there would be
> no need for such constraints, then why even have a set_voltage()
> request?  That adds a constraint ... but it's an inflexible one.
> 

Basically there are two types of consumers.

1. Consumers that don't care about their supply voltage/current. They
use the voltage specified by the system designer and don't care about
it's value. They only need to enable()/disable()

2. Consumers that do care about their voltage/current. This group of
consumers do care about voltage and current. Typical users are
Backlight, CPUfreq, LED's, MMC, vibrator, USB.....

The first type can usually share a supply regulator whilst the latter
group have a 1:1 consumer to regulator mapping. 

The system designer ensures that all type 1 consumers exist on domains
with compatible power requirements. Type 1 consumers don't care about
voltage or current constraints.

Type 2 consumers do care about power domain constraints.

This also leads to 3 different types of power domain :-

1. Fixed Voltage.
2. Variable Voltage.
3. Variable Current limit.

> 
> But maybe the broader issue is:  just what model are you using
> for customization here?  At what points are constraints specific
> to a chip, board, or external connection applied?
> 

We have the physical constraints of the regulators (chip) and the
physical constraints of the power domain. The power domain example near
the top hopefully answers this. 

> 
> My assumption is that the regulators themselves should know
> only about their hard constraints

Agreed, they do.

>  ... most often specific to
> the chip (this regulator is optimized for these voltages),
> but sometimes specific to a given board's wiring (e.g. the
> resistor ladder for a given voltage feedback channel).
> 

Imho, the regulator driver should not no anything about the board. It's
up to the board init code to configure things like this. 

We do this atm for a WM8350 resistor config in platform code and pass
onto the pmic driver. 

> And then additional constraints could come from consumers,
> which would basically be of two types:  (a) board setup code,
> and (b) drivers that cope with various situations, some of
> which are externally imposed.  Those drivers would tend to
> need just on/off controls for power domains they manage,
> but in some cases (like the MMC example I mentioned) would
> need more capability than that.
> 
> 
> > The actual regulator output will be determined by consumer voltage
> > requests. e.g. On power domain A, consumer x sets 1.8V and consumer y
> > sets 1.9V, hence regulator output will be 1.9V. (as y needs 1.9 to
> > operate, but x can operate at 1.8 - 2.0)
> 
> So when consumer X tunes everything to run in a low power mode
> (using 1.6V as a better example), consumer Y can come along and
> change things (to 2.0V ... 25% higher voltage, a "huge" delta)?

This is probably a bad example as the voltage delta is quite large and
probably unrealistic. I was thinking of smaller deltas in the range of a
few percent. The big numbers just make it easier to read. I'm beginning
to consider removing this feature.

> 
> How would consume X know that it's got to re-adjust things, and
> shift out of a low power operational mode?  Or prevent the need
> to do that?  (Or vice versa.  Y could come first, preventing X
> from entering a low power mode ... though maybe X could still
> run in a high power mode.)
> 

We have a notifier block for notifying changes atm but it doesn't notify
other domain consumers of a pending domain voltage change yet.  

> 
> > > Presumably one configures a voltage then enables it?  How
> > > does one turn a voltage supply on or off?  I'm guessing
> > > that zero volts doesn't equate to "off"...
> > 
> > Some regulators cant go down as far as 0V ;)
> 
> For the ones that can, shouldn't that be equivalent to disabling
> the regulator?  

Imho no, as the regulator internals will probably still be clocking and
burning power when set to 0V. I think we need the enable() and disable()
calls to do make this cleaner.

> And for ones that can't, doesn't that mean
> that regulator can not be enabled or disabled??
> 
> This "interface" definition is at best vague about quite a
> lot of issues like these.
> 
>  
> > We have regulator_enable() and regulator
> > regulator output.
> > 
> > e.g. set voltage -> enable -> do some stuff -> disable. 
> 
> Would it be allowable to enable -> set voltage too?
> 

Yes, this is fine.

> Oh ... and if the regulator doesn't have a setting for
> the specific voltage requested, is it allowed to choose
> something "close"?  (How close is close enough?)  Or must
> it instead fail?
> 

It should fail. However, it might be worth adding something like :-

regulator_set_voltage(client, min, max);
regulator_set_current(client, min, max);

I think it's probably best that I write some docs describing the
architecture and usage model before any more patches. Hopefully, this
will clear up the ambiguities around constraints and nomenclature. I'll
also factor in the recent comments in this email chain. 

Liam 


