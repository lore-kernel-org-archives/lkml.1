Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYJ3SBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYJ3SBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYJ3SBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:01:36 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:41451 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbYJ3SBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:01:35 -0400
Date: Thu, 30 Oct 2008 19:01:33 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
       containers@lists.linux-foundation.org,
       Cedric Le Goater <clg@fr.ibm.com>, Andrey Mirkin <major@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based
	checkpointing/restart
Message-ID: <20081030180133.GN15171@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1220439476-16465-1-git-send-email-major@openvz.org> <200810271707.13580.major@openvz.org> <4905D2AD.1070309@cs.columbia.edu> <200810300902.47067.major@openvz.org> <20081030114747.GL15171@hawkmoon.kerlabs.com> <1225386524.12673.284.camel@nimitz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-8436-1225389547-0001-2"
Content-Disposition: inline
In-Reply-To: <1225386524.12673.284.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-8436-1225389547-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2008 at 10:08:44AM -0700, Dave Hansen wrote:
> On Thu, 2008-10-30 at 12:47 +0100, Louis Rilling wrote:
> > 1) this prevents userspace from doing weird things, like changing the t=
ask tree
> > and let the kernel detect it and deal with the mess this creates (think=
 about
> > two threads being restarted in separate processes that do not even shar=
e their
> > parents). But one can argue that userspace can change the checkpoint im=
age as
> > well, so that the kernel must check for such weird things anyway.
>=20
> To me, this is one of the strongest arguments out there for doing
> restart as much as possible with existing user<->kernel APIs.  Having
> the kernel detect and clean up userspace's messes is not going to work.
> We might as well just do things in the kernel rather than do that.
>=20
> What we *should* do is leverage all of the existing APIs that we already
> have instead of creating completely new code paths into which my butter
> fingers can introduce new kernel bugs.
>=20
> > 2) restart will be more efficient with respect to shared objects.
>=20
> Can you quantify this?  Which objects?  How much more efficient?

Quantify? No. I expect that investigating both approaches will show us numb=
ers.
Unless Oren already has some?

Which objects? I think that two kinds will especially matter: objects usual=
ly
shared only inside a thread group (mm_struct, fs_struct, files_struct,
signal_struct and sighand_struct), and individual file descriptors. The poi=
nt is
to avoid creating new structures before destroying them because the restart=
ed
task shares them with a previously restarted one.

Concerning individual file descriptors, limiting the number of open files b=
efore
calling sys_restart() may avoid these useless creations/destructions (actua=
lly
the "useless" work mainly consists in managing ref counts since file descri=
ptors
are shared after fork()).

Concerning thread-shared structures, it is probably easy for userspace to g=
uess
which clone flags to use when restarting threads, but
1) kernel-space will have to check that the sharing is correct anyway, and
2) kernel-space will have to fix it anyway if structures are not shared in =
an
obvious manner between tasks (think about A creating B with shared files_st=
ruct,
B creating C with shared files_struct, B unsharing its files_struct, and th=
en
checkpoint).

So, with a userspace implementation, useless structures will be created any=
way,
and optimizing the common cases (regular threads) just duplicates kernel's =
work
of checking which shared structure to use for each task to restart.
With a kernel-space implementation, all useless creations can be avoided, a=
nd no
duplicate work is needed.

That said, numbers may show us that useless creations are not so
time-consuming, but we won't know before seeing them...

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-8436-1225389547-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJCfZ9VKcRuvQ9Q1QRAgnGAJ4y/I50OqavdrDFvS5Vg4Ru0/ppIQCfZCPt
N1UQfUCQboa1FxxqqiGxEMQ=
=TvuX
-----END PGP SIGNATURE-----

--=_bohort-8436-1225389547-0001-2--
