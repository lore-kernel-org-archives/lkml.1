Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZIAKXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZIAKXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 06:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZIAKXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 06:23:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41397 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753351AbZIAKXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 06:23:24 -0400
Date: Tue, 1 Sep 2009 11:23:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] AB3100 regulator support v2
Message-ID: <20090901102324.GA21165@rakim.wolfsonmicro.main>
References: <1251667749-31276-1-git-send-email-linus.walleij@stericsson.com>
 <1251722641.4254.46.camel@finisterre.sirena.org.uk>
 <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63386a3d0908310716x1a33a8fdpddedbaf24648216f@mail.gmail.com>
X-Cookie: To be is to program.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 04:16:15PM +0200, Linus Walleij wrote:
> 2009/8/31 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> >> +     err = ab3100_get_register_interruptible(abreg->ab3100, abreg->regreg,
> >> +                                             &regval);

> > I did query last time if having these operations be interruptible is a
> > good idea - I can't see it helping robustness, it's not something that
> > other drivers are doing and it'd complicate things for all API users to
> > add handling for the error. I don't recall any discussion of the
> > thinking here?

> I recently renamed all the ab3100 accessor functions to *_interruptible
> to reflect the fact that the accessor mutex on ab3100 uses
> mutex_lock_interruptible() so this suffix should propagate so it is
> clear that stuff like -ERESTARTSYS can be returned.
> So the above errorcheck is probably bogus.

Oh, there's no noninterruptible version?  With the naming it looked like
there was.

> That said, I think the regulator paths are entirely in-kernel and
> under such circumstances that signals from userspace are blocked
> anyway. The problem is that the ab3100 is accessed by complex

The regulator API doesn't give any guarantees that signals can't be
delivered.

> userspace programs and I2C is sometimes slow so there is a need
> for being able to interrupt it, but I *could* go in and use an

While I2C isn't fast for the sorts of access regulators tend to do it's
not so slow as to make this critical.

> uniterruptable mutex if you prefer that, I'll ask around here if
> we should do this. Can the function name stand as it is for the time being?

> >> +static int ab3100_get_voltage_regulator_external(struct regulator_dev *reg)
> >> +{

> > Hrm.  I suspect that you either want to add some platform data to
> > specify the voltage as a plain number or just have boards use the
> > regulator supply mechanism with a fixed voltage regulator supplied by
> > this one if they need to specify the voltage of the supply.

> I was designing for it to be controllable but not controllable by the
> AB3100 driver, perhaps it is a regulator somewhere else here,
> defined in the board data. But I went for a fixed int member
> voltage setting for the time being, we can discuss that stuff later
> when I have some practical use for it.

I've got the same sort of external switch on the WM831x.  What I did
there was just not have the voltage at all.  The regulator API supports
chaining of regulators so one regulator is the supply for another so
what a board could do is set things up so that the switch on the PMIC is
the supply for an external regulator.  There's already a standard driver
for simple fixed voltage regulators and if the regulator is more complex
and supports variable voltages then it can use its normal driver.

> If this sequence is a dependency graph of regulators that need to
> have deps in all strange directions you get a directed graph
> http://en.wikipedia.org/wiki/Directed_graph
> Or you could limit yourself to a directed acyclic graph
> http://en.wikipedia.org/wiki/Directed_acyclic_graph
> in either case it's rather a delicate computational problem
> but I guess you're after a simple linear sequence here, like
> switch on A, B, C, D ... N in a special order?

The power sequencing provided by hardware designers is normally a simple
linear sequence of things to do to bring the system power up - normally
you'd bring some supplies up, wait for a given time period then bring
some more up and so on.  Sometimes there will be some handshaking
involved (waiting for "I've started" signals from components).  

> In my case it's actually not the switching-on or of that is
> the problem, it's more of putting some magic numbers
> into some registers in a special order (well, any order
> actually except for one register that is special).

> I'll see if I can think of something more elegant to
> make this more appealing, like tagging each default
> register value with a sequence number or so.

Are the magic numbers controlling things other than the settings that
are exposed through the regulator API?
