Return-Path: <linux-kernel-owner+w=401wt.eu-S934158AbZHEKVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934158AbZHEKVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934145AbZHEKVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:21:00 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54138 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144AbZHEKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:20:58 -0400
Date: Wed, 5 Aug 2009 12:20:57 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090805102057.GT29252@hawkmoon.kerlabs.com>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Benjamin Blum <bblum@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com> <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com> <20090803175452.GA5481@us.ibm.com> <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com> <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com> <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com> <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com> <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-24649-1249467624-0001-2"
Content-Disposition: inline
In-Reply-To: <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-24649-1249467624-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04/08/09 12:28 -0700, Paul Menage wrote:
> On Tue, Aug 4, 2009 at 12:14 PM, Benjamin Blum<bblum@google.com> wrote:
> >
> > Hmm, the tasklist_lock section in fork() is entirely inside the
> > read-lock. Presumably then iterating the threadgroup list to take all
> > rwsems is safe from a race in which one thread escapes?
> >
>=20
> I think so - the write-side locking would be something like:
>=20
> again:
>   read_lock(&tasklist_lock);
>   find first not-yet-locked task t
>   while (t !=3D group_leader) {
>     if (!down_write_trylock(&t->threadgroup_stability_mutex)) {
>       get_task_struct(t);
>       read_unlock(&tasklist_lock);
>       down_write(&t->threadgroup_stability_mutex);
>       put_task_struct(t);
>       goto again;
>     }
>     t =3D t->next_thread;
>   }
>   read_unlock(&tasklist_lock);

The downside of this is teaching lockdep about this recursive locking. Not =
that
simple actually... so that such cases are currently handled using a higher-=
level
lock that prevents races in locking the whole chain (there was one such exa=
mple
for locking all vmas with KVM). IIUC, the intent here is to avoid such
higher-level lock.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-24649-1249467624-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp5XQkACgkQVKcRuvQ9Q1Sm0wCfXbE4OFiSty/OI+C5K8txTat5
9EgAoNCJZbOv9eCNIXXibuSO+YY64Y3P
=Q8i+
-----END PGP SIGNATURE-----

--=_bohort-24649-1249467624-0001-2--
