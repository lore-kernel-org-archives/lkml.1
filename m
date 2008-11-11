Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYKKE4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYKKE4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbYKKE4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:56:23 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:43918 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754389AbYKKE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:56:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=gIEsGjwPQHQ5X7PUSiZPEaB7D5K56at8gPkq39YRd1hMa6MwGP10KLpb07hYBvUzkaQfcUD5qdKf4cgaH/UWencd6U1BVKy16hICZRF3bTDP1w8S/t2zORjv2CJ0jKJFkIJVwR2aZ5Z4SWZ88JxZlsRjy1/eBc8oZ+ksp5RSW+U=  ;
X-YMail-OSG: opLkDSUVM1k8SGgJ9.GL9dWCUuMrqBUZisA1Goy3gbT2D31XaVfpajb920bsH2KN_UMMpyqd0J8ZH_UAQl0JWrODDlQBSyCkWpEdZrEeiZaPwK_m.d_2Zsoswcw7uCS7hMBIjZWV9Gx4eeuy9Oo.JvkD_ka6jR6YUxVuHz8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Date: Mon, 10 Nov 2008 20:56:19 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200811100743.34741.david-b@pacbell.net> <20081110165625.GE12804@sirena.org.uk>
In-Reply-To: <20081110165625.GE12804@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811102056.20008.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2008, Mark Brown wrote:
> On Mon, Nov 10, 2008 at 07:43:34AM -0800, David Brownell wrote:
> 
> > See below; the key conceptual problem in this interface is
> > probably the assumption that the Linux CPU isn't sharing
> > control over the regulator.  So regulator_disable() can't

Read that as regulator_ops.disable() ... although there are
issues with regulator_disable() too.   $SUBJECT patch relates
to regulator_ops semantics, which of course bubble up.


> > imply REGULATOR_MODE_OFF ... another CPU may need to keep
> > it in some other state.
> 
> regulator_disable() needn't imply that the regulator will actually be
> off -

Would you say that also for regulator_ops.disable() though?


> regulator API already does internal reference counting for shared 
> regulators and...

Very confusing refcounting.  The naming convention is unusual too,
and that's just the start of it:

    struct regulator_dev ... unique handle to the hardware, has
	some real refcounting (use_count), and is what shows
	up in /sys/class/regulator (vs. say .../regulator_dev).
	This class is internal to the regulator framework.

    struct regulator ... opaque client handle, wraps regulator_dev,
	but has no refcounting:  just a boolean 'enabled' flag,
	and KERN_CRIT messaging if you try using enable/disable
	like you would with clocks or IRQs (N enables are fine,
	so long as they're eventually paired with N disables).
	Each "consumer" would normally have its own "regulator".

Less surprising/confusing would be if regulator_{en,dis}able() did
its own refcounting and called down to regulator_dev when changing
a per-client refcount to/from zero.  (Easy patch, for later.)

And, hrm, kerneldoc for regulator_is_enabled() says it returns
a refcount, not boolean; but the refcount is unavailable to the
regulator_ops method returning that value.


> > So for example when any of the three requestors asks for the
> > regulator to go ACTIVE it will do so.  This means you can have
> > cases like:
> 
> ...this sounds like the same thing done in hardware.

Seems to me more like a three input OR gate.  No counters.  ;)
At least, if you ignore the additional arbitration between
ACTIVE, STANDBY, and OFF modes.  (Highest one wins...)


> >  - One CPU (running Linux, say) asks to disable() the regulator
> >     * implemented by clearing that CPU's bit in a mask
> >     * is_enabled() tests that bit and says "no, not enabled"
> >  - Another CPU needs it active
> >     * request might be coupled to the nSLEEP2 signal
> >     * thus get_mode() will say it's ACTIVE
>
> > So you see why enable/disable is orthogonal to MODE_OFF.
> 
> Not really.  The mode reflects the characteristics of the regulator when
> it is enabled ...

That answer doesn't make much sense to me; plus, kerneldoc
for regulator_get_mode() -- which essentially just calls down
to regulator_ops.get_mode() -- says it returns the "current"
mode.  NOT some potential future mode.  Giving the "current"
mode implies asking the hardware what it's doing right now.

Consider also the scenario above, where Linux calls enable()
and has requested STANDBY mode.  The regulator will instead
be in ACTIVE state; answering STANDBY seems quite wrong.
(Just like answering STANDBY when it's really OFF...)


> The issue you see here is a divergence between the software-requested
> state and the actual physical state of the regulator.

In a general sense, yes ... but this framework splits that
state into a "mode" and an "enable" flag (called "state" in
sysfs, which doesn't reduce confusion at all).

 
> > It's true that it won't be OFF unless the Linux CPU is
> > not requesting it ("disabled" its request) ... but the
> > converse is false, because of the non-Linux requestor(s).
> 
> My first instinct here would be to have the software simply reflect the
> state requested by the CPU and ignore the other enable sources.

Mine is to have get_mode() report the actual hardware state,
matching kerneldoc ... and thus the $SUBJECT patch.  Also, I
have no set_mode(), and thus no mode "requested by the CPU"
through this framework.


> My 
> second instinct would be to have is_enabled() report the actual state
> and leave it at that.

But *which* actual state?  I'd say that reporting this CPU's
enable/request bit *is* reporting actual hardware state:  the
request line managed by regulator_ops.disable()/enable().


> I'm having a hard time thinking of a hardware 
> design that could tolerate too much uncoordinated control of the
> regulators.

True; the coordination here is done in hardware.  There
are "scripts" that get downloaded into the hardware, and
which update things on various hardware state changes.

 
> I'm also wondering if part of what we need to do is add separate out the
> reporting paths for the actual and requested status?  At the minute we
> only report the actual status and there's no indication of the logical
> status which does create some confusion here.

Makes sense.  Record "requested_mode" in "struct regulator_dev"
and expose a new sysfs attribute for it.  Should I update
the $SUBJECT patch to do that too?

- Dave

