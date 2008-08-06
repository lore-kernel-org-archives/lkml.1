Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYHFNJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYHFNJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYHFNJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:09:38 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51206 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYHFNJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:09:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18585.41608.256730.530607@harpo.it.uu.se>
Date: Wed, 6 Aug 2008 15:09:28 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, linux-kernel@vger.kernel.org
Subject: Re: Opteron Rev E has a bug ... a locked  instruction doesn't act as a read-acquire barrier
In-Reply-To: <18583.6153.542598.838960@harpo.it.uu.se>
References: <200808031106.12366.arekm@maven.pl>
	<18583.883.70907.983634@harpo.it.uu.se>
	<200808041556.05339.arekm@maven.pl>
	<18583.6153.542598.838960@harpo.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > On Mon, 4 Aug 2008 15:56:05 +0200, Arkadiusz Miskiewicz wrote:
 > >On Monday 04 August 2008, Mikael Pettersson wrote:
 > >> Arkadiusz Miskiewicz writes:
 > >>  > Hello,
 > >>  >
 > >>  > http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/=
 > >at
 > >>  >omicops-internals-x86.cc says
 > >>  >
 > >>  > "  // Opteron Rev E has a bug in which on very rare occasions a locked
 > >>  >   // instruction doesn't act as a read-acquire barrier if followed by a
 > >>  >   // non-locked read-modify-write instruction.  Rev F has this bug in
 > >>  >   // pre-release versions, but not in versions released to customers,
 > >>  >   // so we test only for Rev E, which is family 15, model 32..63
 > >>  > inclusive. if (strcmp(vendor, "AuthenticAMD") =3D=3D 0 &&       // AMD
 > >>  >       family =3D=3D 15 &&
 > >>  >       32 <=3D model && model <=3D 63) {
 > >>  >     AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug =3D true;
 > >>  >   } else {
 > >>  >     AtomicOps_Internalx86CPUFeatures.has_amd_lock_mb_bug =3D false;
 > >>  >   }
 > >>  > "
 > >>  >
 > >>  > does kernel have quirk/workaround for this? I'm looking at
 > >>  > arch/x86/kernel/cpu but I don't see workaround related to this (possib=
 > >ly
 > >>  > I'm overlooking).
 > >>
 > >> I can find no reference to this alleged RevE erratum in the
 > >> Athlon64/Opteron revision guide (25759.pdf).
 > >>
 > >> But if this bug is real then we need to know about it. Could
 > >> you ask the author of the code you quoted above to clarify?
 > >
 > >Got answer, opensolaris has some workarounds for this bug I still don't kno=
 > >w=20
 > >which errata # is that:
 > >
 > >http://groups.google.com/group/google-perftools/browse_thread/thread/3d1b78=
 > >d4a9db8c6e
 > >
 > >btw. I got info about this bug after hiting this problem:=20
 > >http://bugs.mysql.com/bug.php?id=3D26081
 > 
 > Thanks, found the Solaris code in question and the mysql discussion.
 > I'll dig deeper tomorrow.

I investigated the Solaris track, but I've found no detailed
explanation of the alleged bug. I've asked the Sun engineer
who committed the fix for an explanation, but so far there's
been no reply.

Anyway, here's what I've found out.

It's Solaris bug # 6323525.

They call it "Mutex primitives don't work as expected."

if (number_of_cores() < 2) then don't have bug
if (family == 0xf && Model < 0x40) then have bug
if (rdmsr(MSR_BU_CFG/*0xC0011023*/) & 2) then bug is masked

lock:	// mutex_lock, spin_lock, etc
	...
	lock; cmpxchg ..
	jnz fail
	ret; nop; nop; nop	// patched to "lfence; ret" if bug

The workaround is to place a fencing instruction (lfence) between
the mutex operation and the subsequent read-modify-write instruction.
(This provides the necessary load memory barrier.)

There's no change to the unlock code.

Anyone know who to contact @ AMD about confirming or denying this?

/Mikael
