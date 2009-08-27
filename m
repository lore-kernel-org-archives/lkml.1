Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZH0WWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZH0WWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZH0WW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:22:29 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43613 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbZH0WW2 (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Thu, 27 Aug 2009 18:22:28 -0400
Message-ID: <4A97071F.5070804@novell.com>
Date: Thu, 27 Aug 2009 18:22:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org>  <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org>  <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig353EA08A2E3493907A255907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig353EA08A2E3493907A255907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thomas Gleixner wrote:
> On Thu, 27 Aug 2009, Christoph Lameter wrote:
>> On Thu, 27 Aug 2009, Chris Friesen wrote:
>>
>>> I just went and read the docs.  One of the things I noticed is that i=
t
>>> says that the offlined cpu cannot run userspace tasks.  For our
>>> situation that's a showstopper, unfortunately.
>> It needs to be implemented the right way. Essentially this is a variat=
ion
>> on the isolcpu kernel boot option. We probably need some syscall to mo=
ve
>> a user space process to a bare metal cpu since the cpu cannot be
>> considered online in the regular sense.
>=20
> It can. It needs to be flagged as reserved for special tasks and you
> need a separate mechanism to move and pin a task to such a CPU.
>=20
>> An isolated cpu can then only execute one process at a time. A process=

>> would do all initialization and lock itsresources in memory before goi=
ng
>> to the isolated processor. Any attempt to use OS facilities need to ca=
use
>> the process to be moved back to a cpu with OS services.
>=20
> You are creating a "one special case" operation mode which is not
> justified in my opinion. Let's look at the problem you want to solve:
>=20
>   Run exactly one thread on a dedicated CPU w/o any disturbance by the
>   scheduler tick.
>=20
> You can move away anything else than the scheduler tick from a CPU
> today already w/o a single line of code change.
>=20
> But you want to impose restrictions like resource locking and moving
> back to another CPU in case of a syscall. What's the purpose of this ?
> It does not buy anything except additional complexity.
>=20
> That's just the wrong approach. All you need is a way to tell the
> kernel that CPUx can switch off the scheduler tick when only one
> thread is running and that very thread is running in user space. Once
> another thread arrives on that CPU or the single thread enters the
> kernel for a blocking syscall the scheduler tick has to be
> restarted.
>=20
> It's not rocket science to fix the well known issues of stopping and
> eventually restarting the scheduler tick, the CPU time accounting and
> some other small details. Such a modification would be of general use
> contrary to your proposed solution which is just a hack to solve your
> particular special case of operation.

I wonder if it makes sense to do something along the lines of the
sched-class...

IOW: What if we adopted one of the following models:

1) Create a new class that is higher prio than FIFO/RR and, when
selected, disables the tick.

2) Modify FIFO so that it disables tick by default...update accounting
info at next reschedule event.

3) Variation of 2..leave FIFO+tick as is by default, but have some kind
of parameter to optionally disable tick if desired.

In a way, we should probably consider (2) independent of this particular
thread.  FIFO doesn't need a tick anyway afaict...only a RESCHED+IPI
truly ever matter here....or am I missing something obvious (probably
w.r.t accounting)?

You could then couple this solution with cpusets (possibly with a little
work to get rid of any pesky per-cpy kthreads) to achieve the desired
effect of interference-free operation.  You wouldn't even have to have
funky rules eluded to above w.r.t. making sure only one userspace thread
is running on the core.

Thoughts?
-Greg


--------------enig353EA08A2E3493907A255907
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqXBx8ACgkQP5K2CMvXmqFh+ACfdHEqhvEAmSZ4uoeiMJ5QNr/s
42wAn2LMe5KV54wp8HvXszgdrzH6NezA
=j22u
-----END PGP SIGNATURE-----

--------------enig353EA08A2E3493907A255907--
