Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZHCLAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZHCLAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZHCLAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:00:51 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:43482 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZHCLAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:00:50 -0400
Date: Mon, 3 Aug 2009 13:00:48 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Benjamin Blum <bblum@google.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090803110048.GB29252@hawkmoon.kerlabs.com>
Mail-Followup-To: Benjamin Blum <bblum@google.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
	menage@google.com
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com> <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com> <20090724100220.GF11101@hawkmoon.kerlabs.com> <2f86c2480907241452m74c50975k522c5a43a62e8459@mail.gmail.com> <2f86c2480907281723n7452c7f5l5a475e8120dccd83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-17655-1249297216-0001-2"
Content-Disposition: inline
In-Reply-To: <2f86c2480907281723n7452c7f5l5a475e8120dccd83@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-17655-1249297216-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28/07/09 17:23 -0700, Benjamin Blum wrote:
> On Fri, Jul 24, 2009 at 2:52 PM, Benjamin Blum<bblum@google.com> wrote:
> > On Fri, Jul 24, 2009 at 3:02 AM, Louis Rilling<Louis.Rilling@kerlabs.co=
m> wrote:
> >> On 23/07/09 20:22 -0700, Ben Blum wrote:
> >>> @@ -408,6 +409,15 @@ You can attach the current shell task by echoing=
 0:
> >>>
> >>> =A0# echo 0 > tasks
> >>>
> >>> +The cgroup.procs file is useful for managing all tasks in a threadgr=
oup at
> >>> +once. It works the same way as the tasks file, but moves all tasks i=
n the
> >>> +threadgroup with the specified tgid.
> >>> +
> >>> +Writing the pid of a task that's not the threadgroup leader (i.e., a=
 pid
> >>> +that isn't a tgid) is treated as invalid. Writing a '0' to cgroup.pr=
ocs will
> >>> +attach the writing task and all tasks in its threadgroup, but is inv=
alid if
> >>> +the writing task is not the leader of the threadgroup.
> >>> +
> >>
> >> This restriction sounds unfortunate and I'm not sure that there are go=
od reasons
> >> for it (see below).
> >
> > Would it be preferable to allow any thread in a threadgroup to move
> > the whole group to a new cgroup? Would that undermine the desired
> > restriction of the tasks file in which a thread needs to have
> > sufficient perms to move a thread that's not itself, or is the task
> > file's restriction there undesirable in the case of threadgroups?
>=20
> Still wondering on what to do about this. Noting that this restriction
> approximately parallels the behaviour you'd get from using the tasks
> file, I think it'd be safer to leave it like this then possibly in the
> future lift the restriction, rather than make it currently lifted then
> decide in the future that we want to re-impose it.

Sorry, I was on vacations last week.

To me it looks like all threads should be treated equally, since AFAIK POSI=
X has
no notion of thread group leader. Moreover, a thread group (process) can li=
ve an
arbitrary long time after the death of its leader (that remains as a zombie=
), so
this restriction just prevents such processes to user the procs file.

>=20
> >>> + =A0 =A0 =A0* to move all tasks to the new cgroup. the only fail cas=
e henceforth
> >>> + =A0 =A0 =A0* is if the threadgroup leader has PF_EXITING set (in wh=
ich case all
> >>> + =A0 =A0 =A0* the other threads get killed) - if other threads happe=
n to be
> >>
> >> This statement is wrong. A thread group leader can have PF_EXITING (an=
d even
> >> become zombie) while other sub-threads continue their execution. For i=
nstance it
> >> is perfectly valid for a thread group leader to call sys_exit(), and n=
o other
> >> thread will be affected.
> >
> > Is that the case? Then, what becomes of his task_struct when he's
> > gone, since presumably all the sub-threads will need it. Does it just
> > hang around?

Yes. The thread leader remains in zombie state (and cannot be reaped) until=
 all
other threads have exited.

> >
> > If so, would the desired behaviour be to proceed with moving all
> > sub-threads if the leader is exiting? (That's not a very big change
> > code-wise)
> >
>=20
> I've fixed this, and also implemented the rwsem as threadgroup-local.
> If there's no more discussion on this version of the patch, I'll send
> out the revised series soon.

Ok. Thanks.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-17655-1249297216-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp2w2AACgkQVKcRuvQ9Q1TWIwCg1bWplKyNNALh1Z+aBpXgYox3
eLwAmwbn6GDKJZISMkfAUARfaDNktleT
=y1QM
-----END PGP SIGNATURE-----

--=_bohort-17655-1249297216-0001-2--
