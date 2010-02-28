Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936450Ab0B1TGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:06:34 -0500
Received: from ms01.sssup.it ([193.205.80.99]:55556 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936410Ab0B1TGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:06:30 -0500
Subject: [RFC][PATCH 0/11] sched: SCHED_DEADLINE v2
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dario <raistlin@linux.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eRm9BFbWXNYbpg9SC20I"
Date: Sun, 28 Feb 2010 20:06:16 +0100
Message-ID: <1267383976.13676.79.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eRm9BFbWXNYbpg9SC20I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi everybody,

Here it is the new version of the SCHED_DEADLINE patchset.

For the ones that missed the first posting[*], it is basically a new
scheduling policy (implemented inside its own scheduling class) aiming
at introducing deadline scheduling for Linux tasks, and it is being
developed by Evidence S.r.l. (http://www.evidence.eu.com) in the context
of the EU-Funded project ACTORS (http://www.actors-project.eu/).

=46rom the previous version, mainly:
 - I followed all the suggestions --about bug-fixing and code
   restyling-- that Peter kindly gave us in his review;
 - in particular, I rewrote from scratch the group part, i.e.,
   bandwidth is now accounted for in a per-CPU fashion, such that
   the interface is the same we already have for RT-throttling;
 - I added a first drafted implementation of deadline inheritance, even
   though it surely needs thorough testing and refinements.

The official page of the project is:
  http://www.evidence.eu.com/sched_deadline.html

while the development is taking place at[**]:
  http://gitorious.org/sched_deadline/pages/Home
  http://gitorious.org/sched_deadline

Still Missing parts:
 - bandwidth reclaiming mechanisms, i.e., methods that avoid stopping
   the tasks until their next deadline when overrunning. There are at
   least three of them that are very simple, and patches are on their
   way;
 - porting to PREEMPT-RT is almost done --thanks to Nicola and Luca--
   and separate patches will be available on the project website soon;
 - migration of tasks throughout push and pull (as in -rt), to make it
   possible to deploy global-EDF scheduling. Patches are ready, they're
   just being tested and adapted to this last version;
 - refinements in deadline inheritance, especially regarding the
   possibility of retaining bandwidth isolation among non-interacting
   tasks. This is being studied from both theoretical and practical
   points of view, and hopefully we can have some demonstrative code
   soon.

As Fabio said recently, I also would like to remark that we are
addressing different problems and providing the kernel with different
new features, but we can share some code and we'll definitely do that if
it is the case.

Patchset against Linus' master (at the time of this writing) follows,
comments and any kind of feedback is, as usual, more than welcome.

Many thanks and Regards,
	Dario Faggioli
	Claudio Scordino
	Michael Trimarchi

[*] http://lwn.net/Articles/353797/
[**] the repositories are outdated right now, I'll post the last changes
     and the last version of utilities and testing programs in the very
     next days.

Dario Faggioli, SCHED_DEADLINE (11)
  sched: add sched_class->task_dead.
  sched: SCHED_DEADLINE policy implementation.
  sched: add extended scheduling interface.
  sched: add resource limits for -deadline tasks.
  sched: add a syscall to wait for the next instance.
  sched: add the sched-debug bits for sched_dl.
  sched: add latency tracing for -deadline tasks.
  sched: send SIGXCPU at -deadline task overruns.
  sched: first draft of deadline inheritance.
  sched: add bandwidth management for sched_dl.
  sched: add sched_dl documentation.

 Documentation/scheduler/sched-deadline.txt |  188 ++++
 arch/arm/include/asm/unistd.h              |    4 +
 arch/arm/kernel/calls.S                    |    4 +
 arch/x86/ia32/ia32entry.S                  |    4 +
 arch/x86/include/asm/unistd_32.h           |    6 +-
 arch/x86/include/asm/unistd_64.h           |    8 +
 arch/x86/kernel/syscall_table_32.S         |    4 +
 include/asm-generic/resource.h             |    7 +-
 include/linux/sched.h                      |  173 ++++
 include/linux/syscalls.h                   |    9 +
 init/Kconfig                               |   15 +
 kernel/fork.c                              |   12 +
 kernel/hrtimer.c                           |    2 +-
 kernel/sched.c                             | 1329 ++++++++++++++++++++++++=
+++-
 kernel/sched_debug.c                       |   36 +-
 kernel/sched_dl.c                          |  787 ++++++++++++++++
 kernel/sched_fair.c                        |    2 +-
 kernel/sched_rt.c                          |    2 +-
 kernel/sysctl.c                            |   21 +
 kernel/trace/trace_sched_wakeup.c          |   44 +-
 kernel/trace/trace_selftest.c              |   30 +-
 21 files changed, 2630 insertions(+), 57 deletions(-)

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-eRm9BFbWXNYbpg9SC20I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKvqcACgkQk4XaBE3IOsSSewCeK4KdM6/o8usf+RyfMhiEBNbh
DGQAnR47cp2wcjun4KLgYFVjFvN0PosZ
=Y5Ku
-----END PGP SIGNATURE-----

--=-eRm9BFbWXNYbpg9SC20I--

