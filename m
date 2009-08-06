Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZHFLYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZHFLYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbZHFLYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:24:54 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:56030 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZHFLYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:24:52 -0400
Date: Thu, 6 Aug 2009 13:24:50 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090806112450.GF26446@hawkmoon.kerlabs.com>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Benjamin Blum <bblum@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20090803194555.GA10158@us.ibm.com> <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com> <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com> <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com> <20090805102057.GT29252@hawkmoon.kerlabs.com> <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com> <20090805164218.GB26446@hawkmoon.kerlabs.com> <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com> <20090806095854.GD26446@hawkmoon.kerlabs.com> <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-27638-1249557857-0001-2"
Content-Disposition: inline
In-Reply-To: <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-27638-1249557857-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06/08/09  3:28 -0700, Paul Menage wrote:
> On Thu, Aug 6, 2009 at 2:58 AM, Louis Rilling<Louis.Rilling@kerlabs.com> =
wrote:
> >
> > mutex_lock_nested is not enough, since this would require putting each =
thread's
> > mutex in a different class. Again, something like mutex_lock_nest_lock(=
) is
> > the solution, especially since Peter's recent improvement.
> >
>=20
> OK, well if lockdep can't currently handle the "writer takes a lock on
> every thread" model, then maybe we should go with a simpler model
> until someone shows a performance issue with it? Ben's original
> patches had a per-task_struct lock, and a thread forking with CLONE_VM
> would down_read() its group leader's lock. Something that's even
> simpler (doesn't have to deal with thread group leader changing due to
> an execve()), and avoids the per-task_struct overhead would be to put
> the lock in sighand_struct instead (so only one per process). The
> procs file writer does a down_write(&tsk->sighand->fork_sem), and
> cgroup_fork() can do a down_read(&current->sighand->fork_sem) if
> flags&CLONE_SIGHAND.
>=20
> If you put it as the second member of sighand_struct, there wouldn't
> even be any extra cacheline bouncing in the common case, since
> copy_sighand() would already have brought that line into cache in
> order to do atomic_inc(&current->sighand->count)

You meant signal_struct, right? sighand_struct can be shared by several
thread groups, while signal_struct can't.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-27638-1249557857-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp6vYIACgkQVKcRuvQ9Q1Q9KQCfZsbhnDsilu6sMsQ0GZZMhUE8
4OkAn1ZZ3ptJnvxU7kfhfdfmgncFPWqE
=LVXe
-----END PGP SIGNATURE-----

--=_bohort-27638-1249557857-0001-2--
