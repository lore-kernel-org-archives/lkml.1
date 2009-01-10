Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZAJUNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZAJUNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZAJUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:13:23 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:35860 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZAJUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:13:22 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090110181340.GA14978@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
	 <1231598714.11642.53.camel@quest> <20090110155720.GA10954@redhat.com>
	 <1231607252.11642.103.camel@quest>  <20090110181340.GA14978@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iQiSpVHVl5xrTmYEqLNW"
Date: Sat, 10 Jan 2009 20:13:27 +0000
Message-Id: <1231618407.11642.196.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iQiSpVHVl5xrTmYEqLNW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 19:13 +0100, Oleg Nesterov wrote:

> On 01/10, Scott James Remnant wrote:
> >
> > On Sat, 2009-01-10 at 16:57 +0100, Oleg Nesterov wrote:
> >
> > > I can't understand why should we change ->exit_signal if we want to
> > > use signalfd. Yes, SIGCHLD is not rt. So what?
> > >
> > > We do not need multiple signals in queue if we want to reap multiple
> > > zombies. Once we have a single SIGCHLD (reported by signalfd or
> > > whatever) we can do do_wait(WNOHANG) in a loop.
> > >
> > Well, a good reason why is that it makes things much easier to do in
> > userspace.
>=20
> I never argued with this. And, let me repeat. I am not arguing against
> waitfd! Actually, I always try to avoid the "do we need this feature"
> discussions.
>=20
Unless I'm misinterpreting you, you're saying that you don't understand
why we should change any current behaviour?  My post is attempting to
illustrate why we should.

> What I disagree with is that waitfd adds the functionality which does
> not exists currently.
>=20
I'm not saying that it doesn't at all; in fact I gave an example of how
you implement the exact same functionality today.

Changing the behaviour of signalfd() or introducing a call like waitfd()
makes it easier to do things in userspace.

> > Cons:
> >  - having siginfo_t returned by read() is pointless, we can't use it
>=20
> Indeed. We use read() only to wait for the signal death.
>=20
In fact, because main loops use select()/poll(), for the SIGCHLD case
you'd never use signalfd() at all!

Unless I'm missing something, the following two examples are identical
in behaviour:

using signalfd:

	sigemptyset (&mask);
	sigaddset (&mask, SIGCHLD);

	sigprocmask (SIG_BLOCK, &mask, NULL);
	sigfd =3D signalfd (-1, &mask, 0);

	/* prepare signal set */

	FD_SET (sigfd, &readfds);
	nfds =3D sigfd > nfds ? sigfd + 1 : nfds;

	for (;;) {
		select (nfds, &readfds, NULL, NULL, NULL);

		if (FD_ISSET (sigfd, &readfds))
			for (;;)
				read (sigfd, &fdsi, sizeof fdsi);

		/* SIGCHLD only notifies us that wait() can be called
		 * at least once without blocking.
		 *
		 * Since we have to call it multiple times anyway,
		 * and since it may block, all SIGCHLD really does it
		 * wakes up our main loop.
		 *
		 * Thus unconditionally loop on wait every time through
		 */
		while ((pid =3D waitpid (-1, &status, WNOHANG)) =3D=3D 0)
			mourn (pid, status);
	}

using pselect:

	sigemptyset (&mask);
	sigaddset (&mask, SIGCHLD);

	sigprocmask (SIG_BLOCK, &mask, &origmask);

	/* prepare signal set */

	for (;;) {
		pselect (nfds, &readnfds, NULL, NULL, NULL,
			 &origmask);

		/* SIGCHLD only needs to wake up our main loop,
		 * unconditionally loop on wait every time through
		 */
		while ((pid =3D waitpid (-1, &status, WNOHANG)) =3D=3D 0)
			mourn (pid, status);
	}


But the pselect() version is neater.  Which is why I started the
previous reply off with "why have signalfd() at all?"

> >  - can't simultaneously clear pending signal and wait, so we always hav=
e
> >    to go back round the main loop if a child dies after the read()
>=20
> Can't understand... waitfd doesn't clear the signal too?
>=20
> And you forget to mention another drwaback with the current code:
> a lot of pathetic comments ;)
>=20
The comments were illustrating the sources of userspace frustration with
the current syscalls.

One of them was attempting to explain what you don't understand here,
I'll try and be more verbose...


We only want to be woken up in our main loop if we have something to do.
One of those things that we need to do is reap dead child processes.

The kernel provides a couple of methods of being woken up because of
that event; we can use signalfd() for SIGCHLD, or we could use pselect()
and otherwise mask SIGCHLD so that any pending signal wakes up the main
loop.

That notification only tells us that *at least one* process has died;
SIGCHLD may only be pending once at a time.  If further children die
before we clear the signal, nothing will happen.

We clear the signal with read() on the signalfd, or it's inherently
cleared inside pselect() by allowing it to be delivered to ourselves.

It will not be cleared again until we read() again, or call pselect()
again.

Because it only tells us that *at least one* process has died, we have
to call waitpid() repeatedly until we have exhausted the wait queue.

~~Calling waitpid() does not clear the pending signal.~~

This is the important bit.

If a further process dies while we're inside the waitpid() loop, we will
most likely reap that straight away.  But this does not clear the
pending signal.  The main loop will be woken up again, even though it
does not need to be.

Thus:

 - child process #1 dies
 - main loop woken up by SIGCHLD
 - pending status of signal cleared
 - enter wait loop
 - child process #2 dies
 - SIGCHLD pending again
 - waitpid() called first time, child process #1 reaped
 - waitpid() called second time, child process #2 reaped
   (SIGCHLD still pending)
 - waitpid() called third time, no child processes remain
 - exit wait loop
 - back to top of main loop, immediately woken up by pending SIGCHLD
 - pending status of signal cleared
 - enter wait loop
 - waitpid() called first time, but no child processes remain
   (we reaped it last time round)
 - exit wait loop
 - back to top of main loop, sleep


A rookie mistake is to assume that you receive SIGCHLD every time a
child process dies.  Nearly everyone writes this first time out:

	signal (SIGCHLD, reaper);

void
reaper (int signum)
{
	pid =3D waitpid (-1, &status, 0);
	printf ("%d died! :-(\n", pid);		// yes, I know
}

You may even be encouraged to believe that will work, because you've
read that SIGCHLD is masked while the signal handler is running.  Of
course, we all know that many children may die between the time the
first child dies (that makes the signal pending) and the signal handler
actually executing.

W. Richard Stevens even makes this mistake in Advanced Programming in
the UNIX Environment (p. 605), he even justifies called waitpid() in the
signal handler because multiple children can die.

He doesn't help matters in the second edition of UNIX Network
Programming v1 where he defines exactly the same function (p. 122)
though he at least goes on to explain all the errors and define a
correct function that loops on waitpid() (p. 128)


Seasoned developers might smile wryly, but I've seen them make another
error.  Presumably because they know about select()/poll(), they appear
to treat SIGCHLD accordingly.

	"SIGCHLD is to waitpid() as select() is to read()"

or perhaps more verbosely:

	"A pending SIGCHLD means that a call to waitpid() won't block"

We know that this is completely wrong.

SIGCHLD and the wait queue are entirely separate, the only connection is
that SIGCHLD will be made pending, if not already, when a new entry is
added to the wait queue.

However since the two are cleared by different means, the following
behaviours can all be exhibited:

 - SIGCHLD not pending, but waitpid() will not block

   This is true in all example usage; after you've called the read() on
   the signalfd - or the pselect() has woken, SIGCHLD is probably no
   longer pending but waitpid() will not block

   Compare with select() behaviour; if you fail to read() from the fd,
   select() wakes up yet again

 - SIGCHLD pending, but waitpid() will block

   This is true if you exhaust the wait queue in a loop,=20


All SIGCHLD is useful for is to get your main loop out of
select()/poll(); you must always exhaust the wait queue every time you
have woken up.

(I think we agreed on this, I'm trying to explain the next paragraph.)

Unfortunately because the wake up, and the wait queue, are *not*
connected; we can be woken up when we do not need to be.

> > The wait() loop tends to be at the bottom of the main loop
> > somewhere, completely outside of the fd processing.
>=20
> Huh.
>=20
=46rom the above reasoning, SIGCHLD is only there to wake up your main
loop.  If you fail to exhaust the wait queue, you will not be woken up
again until another child process dies, so you must exhaust the wait
queue.

Now, we can try and work out whether it was SIGCHLD that woke up our
main loop.  If using signalfd(), we would read() and check ssi_pid; if
using pselect() we'd have to have a signal handler that sets a
sigatomic_t.

We could check that, and then only loop on waitpid() if set.

But why?

We've proved above that SIGCHLD being pending does not mean that
waitpid() will not block.  We're not actually saving ourselves from the
extra iteration of the main loop, or even saving ourselves from the
first call to waitpid() that returns -1.

Arguably the extra effort to check whether SIGCHLD was pending is more
expensive (certainly in code readability) than just calling waitpid()
anyway.

Thus it's most common (certainly in the standard libraries I've read) to
just always loop on waitpid().

> > Now, what if signalfd() would always queue pending signals even if
> > they're non-RT?
>=20
> Well, I think this is off-topic, and more importantly I don't think
> this change is possible.
>=20
=46rom the argument above, it should be reasonably clear that what this
patch is attempting to do is join up the "waking up the main loop" from
the "clearing of the wait queue".

In simpler words, make wait behave more like select().

waitfd() does that absolutely directly.  It allows you to select() on
the wait queue itself.  Clearing the wait queue, and the main loop
wake-up, are directly connected.

We eliminate the problem of the extra main loop wake-up and iteration,
because if we exhaust the wait queue then the waitfd socket will not
poll for reading.

We also eliminate the problem where if we fail to exhaust the wait
queue, we will not be woken up, because the waitfd socket will still
poll for reading.

If you're using waitfd, SIGCHLD is unnecessary.


I'm not personally arguing for waitfd() *itself*, just that there be
some way of coupling the main loop wake up with the actual contents of
the wait queue.

If signalfd() can be used for this, I'd be happy as a clam.

But today, signalfd() doesn't help at all because it still has all the
same drawbacks.

We have an extra main loop wake-up and iteration if a process dies while
we're exhausting the wait queue because SIGCHLD is pending again.

If we fail to exhaust the wait queue, the main loop will not be woken up
because SIGCHLD is not pending - despite the wait queue not being empty.


It's actually completely possible, in fact, it's almost a one-line
patch.

--- kernel/signal.c~	2009-01-10 20:04:50.000000000 +0000
+++ kernel/signal.c	2009-01-10 20:05:24.000000000 +0000
@@ -816,8 +816,10 @@
 	 * exactly one non-rt signal, so that we can get more
 	 * detailed information about the cause of the signal.
 	 */
-	if (legacy_queue(pending, sig))
+	if (legacy_queue(pending, sig)) {
+		signalfd_notify(t, sig);
 		return 0;
+	}
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.

There might be considerations here I haven't thought of, but it worked
pretty well for me.

This isn't waitfd(), you're not actually selecting on the wait queue.
But it means you'll have a queue of SIGCHLDs for each entry in the wait
queue.

You still have to remember that for each SIGCHLD you read from the
signalfd, you must call waitpid on that pid, but if you don't do that -
it'll still poll and you can go round again.


Personally I think waitfd() is more elegant, and has a rather nice
symmetry with the other system calls.

> > So what about
> > waitfd()
>=20
> Yes, the user-space code (for this particular artificial example)
> becomes simpler. Following this logic, let's add sys_copyfile()
> to kernel? From time to time I regret we don't have it...
>=20
Well, I don't think that argument is quite orthogonal because copyfile()
can be implemented in userspace with identical behaviour to a kernel
syscall (open, fstat, sendfile, chown/etc.).

A more orthogonal example would be pselect().  That implemented, in the
kernel, a syscall that it actually wasn't possible to implement in
userspace in _quite_ the same way.  The procmask/select sequence was
known to be racy, so we all worked around it with an interrupt pipe.

The argument for waitfd() or similar in the kernel is because there are
races in userspace that we can't solve.


Hopefully you can see my argument now? :-)

> (from another thread)
>=20
As noted there, I replied separately and cut the discussion about this
because I didn't want to confuse the matter.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-iQiSpVHVl5xrTmYEqLNW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklpAWcACgkQSnQiFMl4yK7ICACaA10Ch4HJeUVBIyhiSlFNWqRZ
4gUAnief4LZWZm8mfQkQwximjO3Lj3tH
=QRos
-----END PGP SIGNATURE-----

--=-iQiSpVHVl5xrTmYEqLNW--

