Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbZAPKff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbZAPKff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZAPKf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:35:26 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:59544 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZAPKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:35:25 -0500
Date: Fri, 16 Jan 2009 11:35:22 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] pids: refactor vnr/nr_ns helpers to make them safe
Message-ID: <20090116103522.GA32212@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Pavel Emelyanov <xemul@openvz.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20090116055520.GA28131@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-12061-1232101962-0001-2"
Content-Disposition: inline
In-Reply-To: <20090116055520.GA28131@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-12061-1232101962-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oleg,

On 16/01/09  6:55 +0100, Oleg Nesterov wrote:
> Inho, the safety rules for vnr/nr_ns helpers are horrible and buggy.
>=20
> task_pid_nr_ns(task) needs rcu/tasklist depending on task =3D=3D current.
>=20
> As for "special" pids, vnr/nr_ns helpers always need rcu. However,
> if task !=3D current, they are unsafe even under rcu lock, we can't
> trust task->group_leader without the special checks.
>=20
> And almost every helper has a callsite which needs a fix.
>=20
> Also, it is a bit annoying that the implementations of, say,
> task_pgrp_vnr() and task_pgrp_nr_ns() are not "symmetrical".
>=20
> This patch introduces the new helper, __task_pid_nr_ns(), which is
> always safe to use, and turns all other helpers into the trivial
> wrappers.
>=20
> If this patch is acceptable, I'll send another one which converts
> task_tgid_xxx() as well, there are a bit special.
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>=20

[...]

> --- CUR/kernel/pid.c~SP_3_NR	2009-01-16 02:54:26.000000000 +0100
> +++ CUR/kernel/pid.c	2009-01-16 05:40:43.000000000 +0100
> @@ -452,11 +452,24 @@ pid_t pid_vnr(struct pid *pid)
>  }
>  EXPORT_SYMBOL_GPL(pid_vnr);
> =20
> -pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
> +pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
> +			struct pid_namespace *ns)
>  {
> -	return pid_nr_ns(task_pid(tsk), ns);
> +	pid_t nr =3D 0;
> +
> +	rcu_read_lock();
> +	if (!ns)
> +		ns =3D current->nsproxy->pid_ns;
> +	if (likely(pid_alive(task))) {

I don't see what this pid_alive() check buys you. Since tasklist_lock is not
enforced, nothing prevents another CPU from detaching the pid right after t=
he
check.

I'm also a bit puzzled by your description with using tasklist_lock when ta=
sk !=3D
current, and not seeing tasklist_lock anywhere in the patch. Does this mean=
 that
"safe" is for "no access to freed memory is done, but caller has to take
tasklist_lock or may get 0 as return value"?

Thanks,

Louis

> +		if (type !=3D PIDTYPE_PID)
> +			task =3D task->group_leader;
> +		nr =3D pid_nr_ns(task->pids[type].pid, ns);
> +	}
> +	rcu_read_unlock();
> +
> +	return nr;
>  }
> -EXPORT_SYMBOL(task_pid_nr_ns);
> +EXPORT_SYMBOL(__task_pid_nr_ns);
> =20
>  pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
>  {

[...]

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-12061-1232101962-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJcGLqVKcRuvQ9Q1QRAq98AJ92WY6UzYhGQwiTCkw5J6lXS3n/3QCgtae0
ppNxeVPyNP4KVDUx2u2SbIA=
=aVWx
-----END PGP SIGNATURE-----

--=_bohort-12061-1232101962-0001-2--
