Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYLKOow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYLKOow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 09:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYLKOoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 09:44:44 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:56749 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYLKOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 09:44:43 -0500
Date: Thu, 11 Dec 2008 15:44:41 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
Subject: Re: configfs, dlm_controld & lockdep
Message-ID: <20081211144441.GA19128@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Steven Whitehouse <swhiteho@redhat.com>,
	joel.becker@oracle.com, linux-kernel@vger.kernel.org,
	cluster-devel@redhat.com
References: <1229005208.3625.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-1582-1229006525-0001-2"
Content-Disposition: inline
In-Reply-To: <1229005208.3625.26.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-1582-1229006525-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On 11/12/08 14:20 +0000, Steven Whitehouse wrote:
> Hi,
>=20
> I've been trying to track down the cause of the following messages which
> appear in my logs each time I start up dlm_controld:
>=20
> Dec  1 12:53:17 men-an-tol kernel:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Dec  1 12:53:17 men-an-tol kernel: [ INFO: possible recursive locking
> detected ]
> Dec  1 12:53:17 men-an-tol kernel: 2.6.28-rc5 #179
> Dec  1 12:53:17 men-an-tol kernel:
> ---------------------------------------------
> Dec  1 12:53:17 men-an-tol kernel: dlm_controld/2455 is trying to
> acquire lock:
> Dec  1 12:53:17 men-an-tol kernel:
> (&sb->s_type->i_mutex_key#11/2){--..}, at: [<
> ffffffffa0294d76>] configfs_attach_group+0x4a/0x183 [configfs]
> Dec  1 12:53:17 men-an-tol kernel:
> Dec  1 12:53:17 men-an-tol kernel: but task is already holding lock:
> Dec  1 12:53:17 men-an-tol kernel:
> (&sb->s_type->i_mutex_key#11/2){--..}, at: [<
> ffffffffa0294d76>] configfs_attach_group+0x4a/0x183 [configfs]
> Dec  1 12:53:17 men-an-tol kernel:
> Dec  1 12:53:17 men-an-tol kernel: other info that might help us debug
> this:
> Dec  1 12:53:17 men-an-tol kernel: 2 locks held by dlm_controld/2455:
> Dec  1 12:53:17 men-an-tol kernel: #0:
> (&sb->s_type->i_mutex_key#10/1){--..}, a
> t: [<ffffffff802b5e11>] lookup_create+0x26/0x94
> Dec  1 12:53:17 men-an-tol kernel: #1:
> (&sb->s_type->i_mutex_key#11/2){--..}, a
> t: [<ffffffffa0294d76>] configfs_attach_group+0x4a/0x183 [configfs]
> Dec  1 12:53:17 men-an-tol kernel:
>=20
> which seems to be caused by the mkdir which dlm_controld does in
> configfs. Looking at the stack trace, this didn't make much sense until
> I stuck noinline in front of several functions in configfs, whereupon I
> get:
>  [<ffffffff8025808e>] __lock_acquire+0xdce/0x14f5
>  [<ffffffff80254894>] ? get_lock_stats+0x34/0x5c
>  [<ffffffff802548ca>] ? put_lock_stats+0xe/0x27
>  [<ffffffff802549c3>] ? lock_release_holdtime+0xe0/0xe5
>  [<ffffffff8025880a>] lock_acquire+0x55/0x71
>  [<ffffffffa024add0>] ? configfs_attach_group+0x40/0x89 [configfs]
>  [<ffffffff8050563c>] mutex_lock_nested+0xf9/0x2c5
>  [<ffffffffa024add0>] ? configfs_attach_group+0x40/0x89 [configfs]
>  [<ffffffffa024add0>] ? configfs_attach_group+0x40/0x89 [configfs]
>  [<ffffffffa024ac7c>] ? configfs_attach_item+0xed/0x201 [configfs]
>  [<ffffffffa024add0>] configfs_attach_group+0x40/0x89 [configfs] <- secon=
d call
>  [<ffffffffa024aec5>] create_default_group+0xac/0xe3 [configfs]
>  [<ffffffffa024af24>] populate_groups+0x28/0x52 [configfs]
>  [<ffffffffa024add8>] configfs_attach_group+0x48/0x89 [configfs] <- first=
 call
>  [<ffffffffa024b222>] configfs_mkdir+0x2d4/0x3bf [configfs]
>  [<ffffffff802b66ef>] vfs_mkdir+0xb0/0x121
>  [<ffffffff802b8afa>] sys_mkdirat+0xa2/0xf5
>  [<ffffffff8020b4fc>] ? sysret_check+0x27/0x62
>  [<ffffffff802569ec>] ? trace_hardirqs_on_caller+0xf0/0x114
>  [<ffffffff8026cf14>] ? audit_syscall_entry+0x126/0x15a
>  [<ffffffff802b8b60>] sys_mkdir+0x13/0x15
>  [<ffffffff8020b4cb>] system_call_fastpath+0x16/0x1b

These warnings are known issues. This results from a lack of lockdep annota=
tions
in configfs. I must admit that I started to send patches for that a few mon=
ths
ago, and then could not find time to finish this work.

The problem is a bit harder than just playing with I_MUTEX_CHILD, I_MUTEX_P=
ARENT
and I_MUTEX_NORMAL, since configfs recursively locks variable numbers
(this can go to as many as the depth of the whole configfs tree) of
config_group inodes during operations like mkdir(), rmdir(), and depend_ite=
m().

I was working on two kinds of solutions:
1) insert lockdep_off()/lockdep_on() at the places of recursion,
2) separate default groups inode mutex classes according to their depth und=
er
the created group they belong to.

People tend to reject any proposition like 1), but IIRC Joel was tending to
accept it.

Solution 2) does not work for depend_item(). This needs to rework the locki=
ng
scheme of depend_item() by removing the variable lock recursion depth, and I
think that it's doable thanks to the configfs_dirent_lock.
	Joel, what do you think about this?

Anyway, I still hope to find time for this :)

Louis

>=20
> so it looks like configfs_attach_group is being called recursively in
> this case, and I think thats the cause of the warning messages. Also I
> spotted a couple of other things... from configfs_attach_item() the
> inode mutex which is being locked just uses a plain old mutex_lock()
> call whereas in configfs_attach_group() which calls
> configfs_attach_item() there is an annotated I_MUTEX_CHILD call. I would
> have expected them both to be the same since I presume that the parent
> is common (locked by the VFS if I've understood whats going on here).
>=20
> The second thing is that configfs_attach_item() calls populate_attrs()
> which calls through to configfs_add_file(), so in order words it seems
> to also be called from the context of the mkdir call. In that case the
> inode mutex is locked with I_MUTEX_NORMAL annotation.
>=20
> So I'm a bit confused as to why lockdep doesn't flag up those issues too
> since they appear to occur before the one which produced the above
> message, or maybe I've misunderstood how the annotation works.
>=20
> Any ideas what is going wrong here? I think it must just be an
> annotation issue since it appears that configfs works perfectly ok
> otherwise, but it would be nice to get to the bottom of it,
>=20
> Steve.
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-1582-1229006525-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJQSdZVKcRuvQ9Q1QRAtM4AKCeHazu8oGS5uf8QsA/9lvtYuZvVACgn7Gr
goqub1UeJIPnxkbQSYhmFoY=
=Jdkg
-----END PGP SIGNATURE-----

--=_bohort-1582-1229006525-0001-2--
