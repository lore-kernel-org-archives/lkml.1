Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYL0MVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYL0MVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 07:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbYL0MUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 07:20:41 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:35234 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbYL0MUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 07:20:40 -0500
Subject: [RFC] Notify init when processes are reparented to it
From: Scott James Remnant <scott@canonical.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-svFXc6l8wyUuQH2vx5y8"
Date: Sat, 27 Dec 2008 11:42:08 +0000
Message-Id: <1230378128.7026.50.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-svFXc6l8wyUuQH2vx5y8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

All processes must have a parent process.  When a process dies, the
parent is notified by SIGCHLD and must use the wait() system call to
reap the remaining zombie.

Should the parent process die, its children are reparented to the init
daemon so that they always have a parent process.

The init daemon cannot die.


As well as a parent, processes also have a process group and a session.
This is quite complicated and takes up an entire chapter of Stevens
which few people claim to have even read.

It all comes down to connecting the life of a process to the life of a
terminal.  Long-lived daemon processes don't want to be connected to a
terminal at all, so they perform a common pattern:

 - the process run by the shell fork()s, creating a child

 - the original process (child of the shell) exits and the shell reaps
   it, while the child carries on and is now reparented to the init
   daemon

 - the process calls setsid() to change to a new session and process
   group, it's now no longer connected to the terminal

 - *but* due to a quirk of POSIX, if it were to now open() a tty device,
   it would end up owning it and becoming connected to it!  FAIL.

 - so the process fork()s again, creating a new child

 - the process (child of the child of the shell) exits and the init
   daemon reaps it, while the child carries on and is reparented to the
   init daemon

This remaining process is the daemon; it's a child of init, and in a
process group and session on its own, but is not the leader of either
and not connected to a terminal.

Win!


Well, almost a win.  The trouble is that this also happens to completely
disconnect it from any kind of process supervisor.  We want to be able
to supervise daemons.

This wouldn't be so bad, execpt that most daemons don't actually
daemonise until after they've finished initialisation, and are even
listening on their well known port.  The daemonisation becomes more than
just the escape from the terminal, its the notification that they are
running.


We could change the rules, and say that new daemons shouldn't do all
that.  They can assume they're running from the init daemon, remain in
the foreground, and notify init that they are running by some other
means (D-Bus maybe?)

That's not really ideal either, for a start there's a lot of commercial
applications out there we don't have the source to.  Then there's all of
those that won't change because they want to be "portable", and aren't
interested in adopting Linux-specific behaviour.

And at the least, it would take a very long time to rewrite all of the
daemon software out there.  Even if this were the right long-term
solution.


We want to be able to supervise daemons.

Init has a head-start already.  Since it's the eventual parent of daemon
processes, it will always be notified of a daemon's death by SIGCHLD and
receives their exit status information through wait().

So while you can't escape from init, and while init can see the process
death, it has no idea what the process was and what it was supposed to
do about it.

If there's two Apache daemons running (in different chroots, or on
different IPs or ports) it can't know which of the two died because the
process that died is unknown to it.

Likewise it can't provide status information as to whether either is
running or not since the only processes it knew about (those it spawned
directly) exited immediately after it ran them.


This is because this is what happens from init's POV:

 - init (1) spawns new apache process (1000)
 - apache (1000) fork()s and exits
 - init (1) receives SIGCHLD for 1000.

Meanwhile:

 - apache (1001) reparented to init (no notification)
 - apache (1001) fork()s and exits
 - init (1) receives SIGCHLD for 1001
 - apache (1002) reparented to init (no notification)

Later on, 1002 will die and init will receive SIGCHLD for it.

Unfortunately neither the 1001 or 1002 processes are known to init, even
though they are original children of the process it spawned (1000), for
init to be notified about them - this has been forgotten.

The only piece of information missing to make this work is the original
parent process id.  If we knew that 1001 was a child of 1000, and 1002
was a child of 1001, we'd be fine.


Can we do this from userspace?

In short, no.

At the end of the day, we need a piece of information that the kernel
doesn't make available to userspace when we need it.  (Because the
kernel itself forgets that information).

If init gets the SIGCHLD for 1002, 1002's ppid is 1 not 1001; likewise
for 1001/1000.

At the point that 1000 exits, its children have already been reparented
to init.  We can't, even with waitid(WNOWAIT) iterate them in any way.


The closest I've come to a race-free way to do this so far is by having
init ptrace() every process it spawns, that at least allows it to follow
fork() and exec().

Even that doesn't work so well, and I'm tiring of the death threats from
security people and people whose software's behaviour is altered under
ptrace() :p


About the patch:

The patch adds a new PR_{GET,SET}_ADOPTSIG prctl(), similar to the
existing PR_{GET,SET}_PDEATHSIG control and with similar semantics.  It
sets a adopt_signal member of the task struct.

 - When non-zero, the process will receive the given signal if another
   process is reparented to it.

 - This signal has the form of SIGCHLD, with:
    * si_code set to zero
    * si_pid set to the process that has been reparented to init
    * (most importantly) si_status set to the previous parent process id

 - Notification is disabled after exec() or setsid()

This functionality only affects the init daemon, and only if the init
daemon activates the prctl().  It is safe for other processes.

There's already other init-daemon specific code in the kernel, and
already other specialist prctl() signals, so this seemed the appropriate
way to do the patch.

Since the siginfo_t contains the useful information, the signal should
generally be >=3D SIGRTMIN.

The signal is made pending before the SIGCHLD for the terminating
previous parent.  While signal delivery order isn't guaranteed, signal
semantics are.

The kernel may actually deliver the SIGCHLD signal first (especially if
you use the suggested SIGRTMIN signal), but the adoption signal can be
checked with sigpending() and delivered with sigsuspend() while still in
the SIGCHLD signal handler.  If using signalfd(), the fd will still poll
for reading if you read SIGCHLD first.

Termination order of processes isn't guaranteed either.  In our example
above, 1001 may actually exit before 1000, so init won't initially
receive SIGCHLD.  Happily 1000 shouldn't call wait(), so when 1000 exits
later, the 1001 zombie is reparented to init and all is well.


Notes:

I'm stuffing a pid into an int and hoping it fits.  There isn't a second
pid_t member of siginfo_t, adding one would require changes to every
arch tree (each implements copy_siginfo_to_userspace on its own) and
changes to the userspace headers as well.

prctl() is evil, another option would be ioctl() but that's evil too.


I did this as a signal because there needs to be reliability between the
delivery of the adoption notice and the delivery of the child death
notice (SIGCHLD).  If the adoption notice were delivered along a
different band (netlink, file descriptor, etc.) then this reliability
would be gone.  (I don't think you could absolutely guarantee that the
fd would be read()able in the child signal handler).

An option would be to implement this as an "child events file
descriptor", delivering both adoption notices *and* child death notices,
etc.  This would be a much larger patch, and overlap heavily with
signalfd() anyway, which is already notified in the appropriate places.


Scott
--=20
Scott James Remnant
scott@canonical.com

--=-svFXc6l8wyUuQH2vx5y8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklWFJAACgkQSnQiFMl4yK6LqwCcCQV9khRrxEdcmgGPqja33b7e
bPkAnjQeIbE/uzp6c/jb0vR2z1W9lOXb
=2bsT
-----END PGP SIGNATURE-----

--=-svFXc6l8wyUuQH2vx5y8--

