Return-Path: <linux-kernel-owner+w=401wt.eu-S1751569AbZH1E2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbZH1E2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZH1E2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:28:03 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59129 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZH1E2B (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 28 Aug 2009 00:28:01 -0400
Message-ID: <4A975CC4.1090208@novell.com>
Date: Fri, 28 Aug 2009 00:27:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org>  <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org>  <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain> <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com>
In-Reply-To: <4A975025.8030500@novell.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA06A2847230247B26266916C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA06A2847230247B26266916C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Hi Rik,
>=20
> Rik van Riel wrote:
>> Gregory Haskins wrote:
>>
>>> 2) Modify FIFO so that it disables tick by default...update accountin=
g
>>> info at next reschedule event.
>> I like it.  The only thing to watch out for is that
>> events that wake up higher-priority FIFO tasks do
>> not get deferred :)
>>
>=20
> Yeah, agreed.  My (potentially half-baked) proposal should work at leas=
t
> from a pure scheduling perspective since FIFO technically does not
> reschedule based on a tick, and wakeups/migrations should still work
> bidirectionally with existing scheduler policies.
>=20
> However, and to what I believe is your point: its not entirely clear to=

> me what impact, if any, there would be w.r.t. any _other_ events that
> may be driven off of the scheduler tick (i.e. events other than
> scheduling policies, like timeslice expiration, etc).  Perhaps someone
> else like Thomas, Ingo, or Peter have some input here.
>=20
> I guess the specific question to ask is: Does the scheduler tick code
> have any role other than timeslice policies and updating accounting
> information?  Examples would include timer-expiry, for instance.  I
> would think most of this logic is handled by finer grained components
> like HRT, but I am admittedly ignorant of the actual timer voodoo ;)
>=20

Thinking about this idea some more:  I can't see why this isn't just a
trivial variation of the nohz idle code already in mainline.  In both
cases (idle and FIFO tasks) the cpu is "consumed" 100% by some arbitrary
job (spinning/HLT for idle, RT thread for FIFO) while we have the
scheduler tick disabled.  The only real difference is a matter of
power-management (HLT/mwait go to sleep-states, whereas spinning/rt-task
run full tilt).

Therefore the answer may be as simple as bracketing the FIFO task with
tick_nohz_stop_sched_tick() + tick_nohz_restart_sched_tick().  The nohz
code will probably need some minor adjustments so it is not assuming
things about the state being "idle" (e.g. "isidle") for places when it
matters (idle_calls++ stat is one example).

Potential problems:

a) disabling/renabling the tick on a per-RT task schedule() may prove to
be prohibitively expensive.

b) we will need to make sure the rt-bandwidth protection mechanism is
defeated so the task is allowed to consume 100% bandwidth.

Perhaps these states should be in the cpuset/root-domain, and configured
when you create the partition (e.g. "tick=3Doff", "bandwidth=3Doff" makes=
 it
an "offline" set).

Kind Regards,
-Greg


--------------enigA06A2847230247B26266916C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqXXMQACgkQP5K2CMvXmqEKLQCeIzXg/OBhfWu/Hcz8oexeD45N
OgsAoIQFdLRner9OcbDI+fZ1Q2OxHQOm
=qEko
-----END PGP SIGNATURE-----

--------------enigA06A2847230247B26266916C--
