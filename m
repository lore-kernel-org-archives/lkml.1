Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbZAJRHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbZAJRHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 12:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZAJRHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 12:07:36 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:53830 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 12:07:35 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090110155720.GA10954@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
	 <1231598714.11642.53.camel@quest>  <20090110155720.GA10954@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rqUWpVrKdq8s6a9zP7rt"
Date: Sat, 10 Jan 2009 17:07:32 +0000
Message-Id: <1231607252.11642.103.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rqUWpVrKdq8s6a9zP7rt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 16:57 +0100, Oleg Nesterov wrote:

> I can't understand why should we change ->exit_signal if we want to
> use signalfd. Yes, SIGCHLD is not rt. So what?
>=20
> We do not need multiple signals in queue if we want to reap multiple
> zombies. Once we have a single SIGCHLD (reported by signalfd or
> whatever) we can do do_wait(WNOHANG) in a loop.
>=20
Well, a good reason why is that it makes things much easier to do in
userspace.  The NOTES sections of many of the syscall manpages are
already too long with strange behaviours that you have to take into
account every time (and which most people fail to do).

You may as well ask why we have signalfd() at all, and what was wrong
with sigaction() and ordinary signal handlers?  Well, lots of things
actually; for a start, you couldn't really do much in the signal
handler, so from userspace all we ended up doing was writing a byte to a
pipe so we could wake up our main loop.

You then had to remember to exhaust this pipe *before* checking what
signals were triggered, just in case a signal was delivered while you
were checking (so at least you'd wake the main loop up once more to
check).

signalfd() improves matters a lot; we don't have to worry about any
strange behaviour, we just read() to know a signal is pending.  But
there were two competing implementations: one would just poll for read
if signals were pending, but have no other detail; the other (which is
what we have) gives us a siginfo_t for each pending signal.

Except or non-RT signals of course, in which it just gives us the
siginfo_t for the first pending signal of that type; future ones are
discarded.

I've suggested before that that's a bug in of itself, and that signalfd
should always queue signals even if they're non-RT.  But since, other
than SIGCHLD, the only other signals with useful data are SIGILL,
SIGFPE, SIGSEGV and SIGBUS (which have si_addr) which you kinda need to
catch in a signal handler; and SIGPOLL (which has si_band and si_fd)
which is negated by being in poll anyway, that's kinda hard to argue.


So let's compare userspace code for trying to reap children using
signalfd(); to save space, I've omitted error handling and the
select()/poll()/etc. call - assuming that the top half is
initialisation, and the bottom half is inside the select() handler.

First, what we have today:

	sigemptyset (&mask);
	sigaddset (&mask, SIGCHLD);

	/* Block normal delivery and receive by sigfd instead */
	sigprocmask (SIG_BLOCK, &mask, NULL);
	sigfd =3D signalfd (-1, &mask, 0);

	for (;;) {
		read (sigfd, &fd_siginfo, sizeof siginfo);

		/* throw away fd_siginfo, we're reading SIGCHLD and
		 * can't use it :-(
		 */

		/* SIGCHLD means _at_least_one_ child is pending, there
		 * may be more; so we have to loop AND expect to find
		 * nothing
		 */
		for (;;) {
			/* ARGH! waitid returns 0 with WNOHANG if there
			 * are no children.
			 *
			 * AND the structure, despite being logically
			 * the same, isn't the same as the signalfd
			 * one :-/
			 */
			memset (&w_siginfo, 0, sizeof w_siginfo);

			waitid (P_ALL, 0, &w_siginfo,
				WEXITED | WNOHANG);

			/* Did we find anything? */
			if (! w_siginfo.si_pid)
				break;

			/* NOW we have the siginfo_t for a recently
			 * deceased process
			 */

			mourn (&w_siginfo);
		}

		/* Oh-HO!
		 * While we were looping in waitid(), other children may
		 * have died, and we probably already cleaned them up!
		 *
		 * But we'll still have a pending SIGCHLD, it might be
		 * tempting to clear that *BUT* the child could have
		 * died after the last waitid() call but before we clear
		 * it.
		 *
		 * We have no choice in this situation but to loop back
		 * through our entire main loop again, and do nothing.
		 */
	}
	=09
Pros:
 - code exists today

Cons:
 - having siginfo_t returned by read() is pointless, we can't use it
 - double loop isn't pretty
 - strange waitid() API in case of WNOHANG and no child
 - incompatible structures for signalfd()'s read result and waitid(),
   despite being logically the same structure! :-/
 - can't simultaneously clear pending signal and wait, so we always have
   to go back round the main loop if a child dies after the read()

In fact, that's not what userspace code does at all.

Since there's no point listening to SIGCHLD, it's a complete no-op, we
don't respond to it at all.  We only need to use it to wake up the main
loop.  The wait() loop tends to be at the bottom of the main loop
somewhere, completely outside of the fd processing.


Now, what if signalfd() would always queue pending signals even if
they're non-RT?  This would also be the same code if we could change
SIGCHLD to SIGRTMIN for the *waiting* process's children:

	sigemptyset (&mask);
	sigaddset (&mask, SIGCHLD);

	/* Block normal delivery and receive by sigfd instead */
	sigprocmask (SIG_BLOCK, &mask, NULL);
	sigfd =3D signalfd (-1, &mask, 0);

	for (;;) {
		read (sigfd, &siginfo, sizeof siginfo);

		/* siginfo is immediately useful!
		 */

		mourn (&siginfo);

		/* we didn't clear off the wait queue, but that's easy
		 * since we have the pid from signalfd()
		 */
		waitid (P_PID, siginfo.si_pid, NULL, WEXITED);
	}

Pros:
 - single siginfo_t structure type returned by read()
 - we get information for each signal, we don't need a signal loop to
   find out what the signal is telling us
 - exact match between the signal and the wait call
 - no need to go round the main loop again just in case!
 - child signal can now be processed just like anything else.  This
   makes "standard main loop functions" (g_main_loop, etc.) much easier
   to write.

Cons:
 - needs kernel patch

Personally, I think the fact this solves the case where you wait on a
process that wasn't part of the original set the signal was pending for,
so you have to process an extra SIGCHLD with nothing to do, is a good
enough reason in of itself.

The overhead of going back through a main loop of a userspace process
just to find out whether you already responded to a notification is a
waste of cycles.


That's pretty neat, much nicer than what we had before.  So what about
waitfd() [I think I've slightly changed Casey's API here, or he changed
my proposed one <g>]?

	wfd =3D waitfd (-1, P_ALL, 0, WEXITED);

	for (;;) {
		read (wfd, &siginfo, sizeof siginfo);

		/* siginfo is immediately useful AND the process has
		 * been reaped!
		 */
	=09
		mourn (&siginfo);
	}

Pros:
 - we don't need to care about SIGCHLD anymore - why should we listen to
   a notification to call wait, if we can just call wait?
 - the absolute easiest for a generic main loop; signals, timers and
   child death (as well as inotify, netlink, etc.) are now just cases of
   "select an fd, read structs of known size, process them"
 - possibility to allow waitfd (WNOWAIT) on children outside of your own
   usual process tree - notification without reaping?  Maybe too much?

Cons:
 - needs kernel patch
 - new API

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-rqUWpVrKdq8s6a9zP7rt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklo1dQACgkQSnQiFMl4yK7LYACaApw28g8zrimQOoymm6ye+zCc
8y4AnilTG/5lLYFHKKLFoQBilQ7pBcID
=Pf7s
-----END PGP SIGNATURE-----

--=-rqUWpVrKdq8s6a9zP7rt--

