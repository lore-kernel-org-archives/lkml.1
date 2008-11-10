Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYKJPnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYKJPnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYKJPni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:43:38 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:44654 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753163AbYKJPnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:43:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Yx/HCiSNXNhgMflZ2NZoyid/8y3t6maBt1W88dCOoDdc8GNkRiJrxa0QWiBMFLyLJOLKTFfK4ZiKWQ68Edp7R5yHi9o1+TK736uuEBA4vb2hc8230d55Al9NLUNfSv5Lhdontzz8Kdcc2+maOL6s0QtL+LJRK0muEOyfdoQ1OqA=  ;
X-YMail-OSG: 00b9ld4VM1nhQbh3s2g_cXy0M37_OKxyGMaKhJZPzmq5q2RC_xu.L3s2XhenOCAtr7SkZFpawPmRB7IAcsPcoeLt3poxKgRoZfoEp8HdyaRVcN70.jzVpipUAZKDLEI2Zq_QEW_T_IIRFBzGD2qBuLYXjWmrmwP_9EiVEfPdi1Me1WrA5tYVFVT3neH0
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Date: Mon, 10 Nov 2008 07:43:34 -0800
User-Agent: KMail/1.9.10
Cc: broonie@opensource.wolfsonmicro.com, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <1226322857.6727.117.camel@vega.slimlogic.co.uk>
In-Reply-To: <1226322857.6727.117.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811100743.34741.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2008, Liam Girdwood wrote:
> On Sun, 2008-11-09 at 15:31 -0800, David Brownell wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > The regulator framework needs to expose an OFF mode for regulators
> > with a single state machine.  Example:  TWL4030 regulators each
> > have a status register exposing the current mode, which will be
> > either ACTIVE, STANDBY, or OFF.  But regulator_ops.get_mode()
> > currently has no way to report that third (OFF) mode.
> 
> OFF is currently not a regulator operating mode but is a regulator
> operating state (e.g. state is either ON or OFF).

The regulator itself supports exactly three states/modes.

You seem to imply that the programming interface should be
exposing four -- {ACTIVE, STANDBY } x { ON, OFF } -- which
doesn't reflect how the hardware works.

See below; the key conceptual problem in this interface is
probably the assumption that the Linux CPU isn't sharing
control over the regulator.  So regulator_disable() can't
imply REGULATOR_MODE_OFF ... another CPU may need to keep
it in some other state.


> The modes define the 
> ON (supplying power) operating modes supported by a regulator.
> I should probably add some more docs/comments here......

Seems to me more like this is a "fix the interface" case
instead of a "document the problem" one.  It's not that
the implication was unclear ... but that it won't work.


> I assume the TWL4030's ACTIVE and STANDBY modes supply power and
> probably all share the same register/bits with OFF (thus making
> it more tightly coupled in the hardware).

It's *very* tightly coupled to the hardware.  The regulator
state (active/standby/off) is determined by a vote between
three hardware request mechanisms ... the CPU running Linux
only gets one vote.  Have a look at the docs[1], if you dare.

So for example when any of the three requestors asks for the
regulator to go ACTIVE it will do so.  This means you can have
cases like:

 - One CPU (running Linux, say) asks to disable() the regulator
    * implemented by clearing that CPU's bit in a mask
    * is_enabled() tests that bit and says "no, not enabled"
 - Another CPU needs it active
    * request might be coupled to the nSLEEP2 signal
    * thus get_mode() will say it's ACTIVE

So you see why enable/disable is orthogonal to MODE_OFF.

It's true that it won't be OFF unless the Linux CPU is
not requesting it ("disabled" its request) ... but the
converse is false, because of the non-Linux requestor(s).


> The other two patches are fine. Would you be able to resend the first
> without the OFF mode patch changes.

I could, but I'd rather get the interface problem resolved
first.  At this point, adding MODE_OFF is the only viable
option on the table...

- Dave

[1] http://focus.ti.com/docs/prod/folders/print/tps65950.html

    "TPS65950" is a mouthful, so it's easier to say TWL5030
    (equivalent part) or TWL4030 (predecessor part, which is
    in more developers' hands).

    The most relevant section of the doc seem to be chapter 5,
    pp. 221-390 ... yes, some Linux-capable SOCs are smaller
    and simpler chips; and no, I've not read it all either.
    You'd want the TRM, 9+ MBytes, for programming info.
