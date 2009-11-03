Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZKCWCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZKCWCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbZKCWCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:02:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbZKCWCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:02:00 -0500
Date: Tue, 3 Nov 2009 16:00:53 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jon Masters <jcm@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf latency builtin command
Message-ID: <20091103160053.0f0dd357@torg>
In-Reply-To: <20091103192839.GB21023@elte.hu>
References: <20091101155500.7dd22f19@torg>
	<20091101155809.191a7ed6@torg>
	<20091103192839.GB21023@elte.hu>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//jyRgEkrBrzmaXoLVIWCyBK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//jyRgEkrBrzmaXoLVIWCyBK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Nov 2009 20:28:39 +0100
Ingo Molnar <mingo@elte.hu> wrote:

>=20
> Clark, John,
>=20
> I'm wondering whether we could do something perf event based that makes=20
> 'perf latency' self-sufficient and eliminates the debugfs interface.
>=20
> ( We could still merge the first two patches in their current form as=20
>   they are clear improvements in terms of debugfs access within perf -=20
>   so no work is lost and progress is possible. )

Yeah, I figured that the first two patches were improvements. I may
poke around a little more to see if we can factor out some more
duplicate routines.=20

>=20
> Basically hwlat_detector is using stop_machine_run() plus a tight rdtsc=20
> based loop to sample what is happening in the system. Much of=20
> hwlat_detector.c deals with getting that information (and parameters)=20
> back and forth between user space and kernel space.
>=20
> Couldnt we move that functionality a bit closer to perf by creating=20
> special events in a tight loop that generate a stream of perf events,=20
> and let the rest of perf events take over the details, and do the=20
> analysis in the user-space builtin-latency.c code?
> =20
> Also, do we need stop_machine_run() - couldnt we do the measurement on a=
=20
> specific CPU with irqs (and NMIs) disabled [but other CPUs still=20
> running]?
>=20

So what would the source of the event's be and how confident would we
be that they're accurate? Jon used stop_machine() so that *nothing*
under the control of Linux is going to happen during the test; no
C-state changes, no interrupts, nada. The intent is that if there's a
gap seen in the TSC values, it's because something happened that's out
of our control.

> This would all still be possible in the .33 timeframe i suspect, as what=
=20
> we need is really just a special event (via TRACE_EVENT() perhaps), and=20
> a way to trigger it via a 'run this many times' parameter. (i.e. event=20
> injection - we want to have that kind of support in perf events anyway)
>=20

Hmmm, seems like what you're saying is that we'd poll a free running
perf counter (or some equivalent, still learning about the guts of perf
event system), detect a gap at the low level and just send an event
with that info up to user-space? That would work...

What counter(s) would we use for detecting a gap in time?

> This would simplify and standardize hw-latency detection, without losing=
=20
> any utility - and we wouldnt have to go via some special debugfs=20
> interface to access the hwlat_detect module.
>=20
> Thoughts?

As long as we feel confident that we can detect temporal gaps with a
performance counter, I'd be ok with it.=20

Clark



--Sig_//jyRgEkrBrzmaXoLVIWCyBK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkrwqBkACgkQHyuj/+TTEp2Y5wCg2Ss1YFfIBIZEGZhjmLA9It0S
5rMAoOMb/XTxtMA/ONnJBgFeXMULBE/V
=quvD
-----END PGP SIGNATURE-----

--Sig_//jyRgEkrBrzmaXoLVIWCyBK--
