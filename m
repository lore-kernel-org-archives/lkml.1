Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYCLGaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYCLGaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 02:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYCLGaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 02:30:06 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:28604 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751381AbYCLGaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 02:30:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jRFELOUAAyb8hC9sx68iEyWEEmnuAuAiTwMLSbJqwGv1QIhBHxSVlxHOD7B8+JVRUjIlBiF4Q4cIRBmDFo3IVUORm2sANp6RUldwukMQ9D79EJAWRZbiy3hJIJn0udiI3IAAWP1wwNxx/lSPe1KaKSO9+4/9e5SS1F6Nsv5jkzE=  ;
X-YMail-OSG: Yaz3legVM1ko2ElZ_fQxIgxbBb6dRUGInozJoadpNT4y70qSKUdipto5eBu8AGSjr2b5Yhi0Vg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Tue, 11 Mar 2008 22:29:57 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803101900.25430.david-b@pacbell.net> <1205248774.13653.347.camel@localhost.localdomain>
In-Reply-To: <1205248774.13653.347.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112329.57926.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Liam Girdwood wrote:
> On Mon, 2008-03-10 at 18:00 -0800, David Brownell wrote:
> > On Sunday 09 March 2008, Liam Girdwood wrote:
> > > 
> > > > > +int regulator_set_voltage(struct regulator *regulator, int uV);
> > > > 
> > > > You described a mode where consumers could set ranges that
> > > > might overlap (e.g. 1.6 to 1.9V, 1.8 to 2.0) and the result
> > > > would be some compatible result.  But I don't see how that
> > > > could be achieved, since that's the only call to provide
> > > > a consumer's constraints.
> > > 
> > > In this example the power domain constraint (not consumer constraint)
> > > would be 1.6 - > 2.0 V. 
> > 
> > I was actually thinking of a chip I've used which has four
> > prgrammable regulators:
> > 
> >   * Three are similar ... they can supply 2.5V, 2.75V, or
> >     3.0V; plus a regulator-specific fourth setting of either
> >     3.3V, 1.8V, or adjusted by board-specific feedback.
> > 
> >   * The fourth has eight settings (from 0.85V up to 1.6V).
> > 
> > Those are the hard power domain constraints for the chip.
> > 
> > But any given board (set of "consumers") needs to be able to
> > provide additional constraints.
> 
> I think we probably have some confusion over the nomenclature here (as
> there are several 'levels' of constraint). I'll detail this in the docs
> though. 
> 
> I think you are meaning the board (or power domain) constraint here:-

I named two different sets of constraints.  One from the power
management chips themselves.  And a board-specific subset of those;
which just limits the power supply capabilities that drivers could
access.  In a way, each constraint defines a subsidiary domain...


> The regulator driver currently enforces the chip (or regulator)
> constraints, whilst the power domain (board) constraints are defined in
> board.c.

OK -- that's the right model.  Drivers are generic, and board
specific stuff is localized in board.c files.


> It designed to work as follows:-
> 
> 1. Consumer: set voltage 1.8V

Now you're introducing a third party, adding its own constraints.
In this case:  something that must be a subset of the constraints
you've defined already.


> 2. reg core: if 1.8V is not within board (power domain) constraint then
> return err.
> 3. regulator (chip) driver: check that 1.8V is ok then write to chip to
> change voltage.

If the only way to add constraints is to add new layers, I think
there will be some undesirable API growth patterns.  :)

This is handled in the clock framework just as part of the clock
tree.  Drivers mostly deal only with leaves and a few branches.
Platform and board code deals with the rest:  this board has
these crystals, these PLLs are configured as follows, divisors
set like this, maybe autogated in hardware, etc.

I'd think that a power domain tree would be a natural model to
use here, and it would avoid those API growth troubles...


> A board designer must make sure that the power domain constraints are
> within the regulator (chip) constraints.

Right.


> He must also make sure that all 
> consumers on a power domain can all operate similtaiously at the same
> voltage

That may of course require the drivers to know which voltage
has been chosen, and to be able to rule out some voltages.

I think changing voltages will be uncommon outside of board
specific setup code, at least for now.  Hardware designers
aren't currently expecting software to be able to dynamically
adjust voltage, for power saving or whatever.  Except for
DVFS stuff like cpufreq, which is awkward since among other
things it's got to coordinate clock and power domain changes.

But we already have one example in-kernel of a simple driver
framework which supports switching just voltages at run-time...

That's the MMC framework.  As a rule all MMC/SD cards can
work at 3/3.3V, plus or minus a few decivolts.  But there's
been a push to get "dual voltage" cards out there, which can
also operate at 1.8V (plus or minus, in a smaller range).
See <include/mmc/mmc_host.h> for the MMC_VDD bitmasks; the
architecture allows ranges that aren't yet widely used by
current boards and cards.


> and that they are not damaged by other domain consumers 
> operating at different voltages.

If a board supports two MMC slots, it could easily end up
having a "high" voltage card and a dual voltage card inserted
at the same time, sharing the same regulator.  That may mean
the low voltage range is temporarily not allowable.  It's
an issue of "can it work", not "will it be damaged".


> > I don't buy that.  If the designer ensured that there would be
> > no need for such constraints, then why even have a set_voltage()
> > request?  That adds a constraint ... but it's an inflexible one.
> > 
> 
> Basically there are two types of consumers.
> 
> 1. Consumers that don't care about their supply voltage/current. They
> use the voltage specified by the system designer and don't care about
> it's value. They only need to enable()/disable()

They want an on/off switch, basically.  Though I think there
are variants of this, notably:

 - Some drivers don't really need to know if power goes off.
   They can share a power domain, and are content with a
   refcount model:  turn it off when no users are active.

 - Other drivers may care that it's actually off; maybe the
   only reset mechanism they have is a power-up reset, or
   they need to power down a saw to change its blade.

Some of that will be supported by the hardware designs.  But
when it's not, I think a "power it down NOW!" primitive may
be needed.  Folk managing industrial controls will probably
need extra features -- it takes time for the voltage/current
to stop, the saw blade has momentum, etc -- but minimally it
seems to me there should be a "disable-and-wait" variant for
drivers in that second category.


> 2. Consumers that do care about their voltage/current. This group of
> consumers do care about voltage and current. Typical users are
> Backlight, CPUfreq, LED's, MMC, vibrator, USB.....

Some LCD contrast controls run by voltage too.

USB has fairly limited current control requirements; in
practice they matter more on the peripheral side, where
the host supplies a certain amount of current (at nominal
5V), which is a system *input* ...

I hesitate to call this second class of driver "power aware".
The driver has a control knob it uses, and it doesn't know
what goes on when it turns that knob.  MMC and USB are to
some extent truly power aware:  labels on those knobs read
Volts (MMC) and current (MMC, nyet supported; and USB).
Even CPUfreq just uses presets for its DVFS settings.


> The first type can usually share a supply regulator whilst the latter
> group have a 1:1 consumer to regulator mapping. 
> 
> The system designer ensures that all type 1 consumers exist on domains
> with compatible power requirements. Type 1 consumers don't care about
> voltage or current constraints.

To the extent that's true, I suspect it's because hardware
designers have been told software won't manage power budgets.

On the other hand, I can easily imagine wanting to do something
like have a 150 mA regulator power a couple MMC slots, instead
of a 300 mA one, and just require that software not kick in
high power read/writes in both slots at the same time.  That's
just a simple current budgeting issue, which may not matter until
someone puts two high speed/power cards in at once...


> Type 2 consumers do care about power domain constraints.
> 
> This also leads to 3 different types of power domain :-
> 
> 1. Fixed Voltage.
> 2. Variable Voltage.
> 3. Variable Current limit.

I think that conclusion doesn't quite follow from what you've
said so far.  But I'm not sure it matters, at least for what
I've needed to do.


> > But maybe the broader issue is:  just what model are you using
> > for customization here?  At what points are constraints specific
> > to a chip, board, or external connection applied?
> > 
> 
> We have the physical constraints of the regulators (chip) and the
> physical constraints of the power domain. The power domain example near
> the top hopefully answers this. 

It's a bit clearer, but you're introducing a new term
"power domain", and your understanding of that notion
doesn't quite match what I've seen.  It may be a lot
simpler to represent the hierarchy of power domains,
not unlike how the hierarchy of clock domains.


> > My assumption is that the regulators themselves should know
> > only about their hard constraints
> 
> Agreed, they do.
> 
> >  ... most often specific to
> > the chip (this regulator is optimized for these voltages),
> > but sometimes specific to a given board's wiring (e.g. the
> > resistor ladder for a given voltage feedback channel).
> 
> Imho, the regulator driver should not no anything about the board. It's
> up to the board init code to configure things like this. 
> 
> We do this atm for a WM8350 resistor config in platform code and pass
> onto the pmic driver. 

That's what device.platform_data should be used for.  It's not
a case of drivers hard-wiring board-specific data; they should
get told such stuff the same way other drivers get told.

Remember that board init code probably can't do anything with
that resistor config; knowledge of how to do that shuld be part
of a driver that hasn't yet initialized.


> > And then additional constraints could come from consumers,
> > which would basically be of two types:  (a) board setup code,
> > and (b) drivers that cope with various situations, some of
> > which are externally imposed.  Those drivers would tend to
> > need just on/off controls for power domains they manage,
> > but in some cases (like the MMC example I mentioned) would
> > need more capability than that.
> > 
> > 
> > > The actual regulator output will be determined by consumer voltage
> > > requests. e.g. On power domain A, consumer x sets 1.8V and consumer y
> > > sets 1.9V, hence regulator output will be 1.9V. (as y needs 1.9 to
> > > operate, but x can operate at 1.8 - 2.0)
> > 
> > So when consumer X tunes everything to run in a low power mode
> > (using 1.6V as a better example), consumer Y can come along and
> > change things (to 2.0V ... 25% higher voltage, a "huge" delta)?
> 
> This is probably a bad example as the voltage delta is quite large and
> probably unrealistic. I was thinking of smaller deltas in the range of a
> few percent. The big numbers just make it easier to read. I'm beginning
> to consider removing this feature.

I chose my MMC example with care.  :)

And in that case, it's very realistic to want to put a slot
into either a 3V3 or 1V8 regulation mode.  It's also realistic
to have slots share a parent power domain (and thus a current
budget), even if they have individual FETs for power on/off.
The stretch is small:  that both situations are combined.


> > How would consume X know that it's got to re-adjust things, and
> > shift out of a low power operational mode?  Or prevent the need
> > to do that?  (Or vice versa.  Y could come first, preventing X
> > from entering a low power mode ... though maybe X could still
> > run in a high power mode.)
> > 
> 
> We have a notifier block for notifying changes atm but it doesn't notify
> other domain consumers of a pending domain voltage change yet.  

Maybe the notifier should be per-domain, with veto capability.
That would address the issues I noted.  Though it should be a
bit simpler to just have the clients register callbacks if
they care; notifiers are an idiom that mostly bothers me.


> > > > Presumably one configures a voltage then enables it?  How
> > > > does one turn a voltage supply on or off?  I'm guessing
> > > > that zero volts doesn't equate to "off"...
> > > 
> > > Some regulators cant go down as far as 0V ;)
> > 
> > For the ones that can, shouldn't that be equivalent to disabling
> > the regulator?  
> 
> Imho no, as the regulator internals will probably still be clocking and
> burning power when set to 0V. I think we need the enable() and disable()
> calls to do make this cleaner.

I'm not sure I see the point in *not* expecting the
regulator to turn itself off when set to 0V ... but
that's not a very big issue.

 
> > And for ones that can't, doesn't that mean
> > that regulator can not be enabled or disabled??
> > 
> > This "interface" definition is at best vague about quite a
> > lot of issues like these.
> > 
> >  
> > > We have regulator_enable() and regulator
> > > regulator output.
> > > 
> > > e.g. set voltage -> enable -> do some stuff -> disable. 
> > 
> > Would it be allowable to enable -> set voltage too?
> > 
> 
> Yes, this is fine.

Something for kerneldoc to make clear.


> > Oh ... and if the regulator doesn't have a setting for
> > the specific voltage requested, is it allowed to choose
> > something "close"?  (How close is close enough?)  Or must
> > it instead fail?
> > 
> 
> It should fail. However, it might be worth adding something like :-
> 
> regulator_set_voltage(client, min, max);
> regulator_set_current(client, min, max);

That make sense to me.  More so than needing to worry about
whether 3.1V will pass as 3.0V on a given system...


> I think it's probably best that I write some docs describing the
> architecture and usage model before any more patches. Hopefully, this
> will clear up the ambiguities around constraints and nomenclature. I'll
> also factor in the recent comments in this email chain. 

Agreed.  In particular, please consider the notion of a tree
of power domains, as a way to cleanly structure all the various
interdependencies.

- Dave

