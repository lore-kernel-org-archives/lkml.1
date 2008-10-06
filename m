Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYJFKUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYJFKUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYJFKUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:20:40 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:56171 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbYJFKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:20:39 -0400
Date: Mon, 6 Oct 2008 12:20:37 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/76] tty: Add a kref count
Message-ID: <20081006102037.GB29198@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <20081005160231.1997.10462.stgit@localhost.localdomain> <20081005160811.1997.59217.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-5923-1223288297-0001-2"
Content-Disposition: inline
In-Reply-To: <20081005160811.1997.59217.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-5923-1223288297-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 05, 2008 at 05:08:15PM +0100, Alan Cox wrote:
> Introduce a kref to the tty structure and use it to protect the tty->sign=
al
> tty references. For now we don't introduce it for anything else.

[...]

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 7ce2ebe..30de644 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -802,6 +802,7 @@ static int copy_signal(unsigned long clone_flags, str=
uct task_struct *tsk)
> =20
>  	sig->leader =3D 0;	/* session leadership doesn't inherit */
>  	sig->tty_old_pgrp =3D NULL;
> +	sig->tty =3D NULL;
> =20
>  	sig->utime =3D sig->stime =3D sig->cutime =3D sig->cstime =3D cputime_z=
ero;
>  	sig->gtime =3D cputime_zero;
> @@ -838,6 +839,7 @@ static int copy_signal(unsigned long clone_flags, str=
uct task_struct *tsk)
>  void __cleanup_signal(struct signal_struct *sig)
>  {
>  	exit_thread_group_keys(sig);
> +	tty_kref_put(sig->tty);
>  	kmem_cache_free(signal_cachep, sig);
>  }
> =20
> @@ -1227,7 +1229,8 @@ static struct task_struct *copy_process(unsigned lo=
ng clone_flags,
>  				p->nsproxy->pid_ns->child_reaper =3D p;
> =20
>  			p->signal->leader_pid =3D pid;
> -			p->signal->tty =3D current->signal->tty;
> +			tty_kref_put(p->signal->tty);
> +			p->signal->tty =3D tty_kref_get(current->signal->tty);
>  			set_task_pgrp(p, task_pgrp_nr(current));
>  			set_task_session(p, task_session_nr(current));
>  			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));

I'm a bit puzzled by this 'tty_kref_put(p->signal->tty)'. AFAICS, this is a=
 noop
since we are not in the CLONE_THREAD case and hence p->signal->tty =3D=3D N=
ULL.
So, is it to make the code look more consistent? If so, is it worth adding =
extra
code and cycles for this (I doubt that gcc is able to optimize this away)? =
What
kind of future changes should this code protect against?

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-5923-1223288297-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI6eZ1VKcRuvQ9Q1QRAn4mAJ91vQ9WC22xhruDuG8MnixnS9Rl6ACffZHH
Hf0Xrri9lgcsT08YGMtxJGw=
=Z1Wt
-----END PGP SIGNATURE-----

--=_bohort-5923-1223288297-0001-2--
