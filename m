Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYCLX50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYCLX50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYCLX5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:57:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47744 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751952AbYCLX5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:57:17 -0400
Date: Wed, 12 Mar 2008 23:57:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Message-ID: <20080312235715.GA15894@opensource.wolfsonmicro.com>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	Liam Girdwood <lg@opensource.wolfsonmicro.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803120031.59742.david-b@pacbell.net> <20080312130216.GA26583@rakim.wolfsonmicro.main> <200803121452.47600.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803121452.47600.david-b@pacbell.net>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 01:52:46PM -0800, David Brownell wrote:
> On Wednesday 12 March 2008, Mark Brown wrote:

> > What do you see as being missing in the externally presented interface?

> It's not *presented* as a tree of power domains, and it's not clear
> that's the intended model.  Plus, what Liam said about the names
> being global, not local/logical.

Hrm.  I suspect that the documentation which Liam is currently writing
(together with some actual in-tree users) will help here.

> > As far as I can see the main difference between the two APIs on this
> > front is that the regulator API explicitly separates the interface used
> > to set up the tree from the interface used by consumers.

> I'd say that differently.  The clock framework *has* no such
> implementor/setup support ... which has caused problems for

Well, the platforms I've looked at do implement a fairly standard
registration API to set up their clocks, even if it's only used to
configure things for the particular SoC variant in use and does tend to
omit things not used on the platform in question.

> many new implementations.  I'm unclear on the status of some
> recent patches [1] from Dmitry Baryshkov to help address that.

That looks like it'd help a lot in making the feature set implemented by
the clock API consistent over platforms.

> Specifically, it's awkard even to do simple things like binding
> one of a SOC's programmable clocks onto an off-chip audio codec
> or video controller; that's got to go through platform_data or
> something similar.  And plugging in external clock generators ...
> not portably, no way!

> You seem to be aiming to not recreate those problems, which is good.

Right; any regulator API is going to need to cope with connecting
multiple chips together since that's such a core use case.

> > What might be nicer would be an API that platform code could use to map
> > regulators to device/name tuples.  The core could then search these when
> > a client calls regulator_get() (either by maintaining a separate table
> > or by setting up virtual regulators).

> Right.

We'll try to implement this before we next resubmit.

> > >     Power --> Regulator -+-> Switch-1 -+-> Switch-2 --> [Dev-A]
> > >                          |             |
> > >                          |             +-> [Dev-B], [Dev-C]
> > >                          |
> > >                          +-> [Dev-D], [Dev-E]

> > I don't see a particular problem fitting this into the structure of
> > the current API - to me the switches inflexible regulators with no
> > configurable voltage control of their own.

...

> That maps exactly to the clock tree model.  Not all clocks can
> support clk_set_rate() or clk_set_parent().  Not all power domains
> can support a set_voltage() call, etc.

That's the aim, and some of this works already.  For example, regulators
with no set_voltage() are supported by the core.

> This just suggests a bit of refocusing of your current code,
> so it'll be more widely applicable.

In API terms I'm not sure it even needs a refocusing - I think the API
can already support everything you're asking for in this subthread
except for the addition of an API to allow platforms to map a symbolic
name and device tuple to an actual regulator.  Some of the cases that
can be set up will require additional work in the core to support them
but doing that shouldn't affect anything that doesn't directly deal with
those cases.
