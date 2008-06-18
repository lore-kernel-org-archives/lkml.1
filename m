Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbYFRIRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbYFRIRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYFRIQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:16:57 -0400
Received: from ms01.sssup.it ([193.205.80.99]:48457 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbYFRIQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:16:55 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 04:16:54 EDT
Subject: NULL pointer dereference while setting sched_rt_period_us
From: Dario Faggioli <raistlin@linux.it>
To: Michael Trimarchi <trimarchimichael@yahoo.it>, peterz@infradead.org,
       mingo@elte.hu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OaJzNE1uS742PwRFSrI8"
Date: Wed, 18 Jun 2008 09:18:38 +0200
Message-Id: <1213773519.5371.8.camel@Palanthas.Krynn>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OaJzNE1uS742PwRFSrI8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

When CONFIG_RT_GROUP_SCHED and =EF=BB=BFCONFIG_CGROUP_SCHED are enabled, wi=
th:

 echo 10000 > /proc/sys/kernel/sched_rt_period_us

We get this:

 BUG: unable to handle kernel NULL pointer dereference at 0000008c
 [  947.682233] IP: [<c0216b72>] __rt_schedulable+0x12/0x160
 [  947.683123] *pde =3D 00000000=20
 [  947.683782] Oops: 0000 [#1]=20
 [  947.684307] Modules linked in:
 [  947.684308]=20
 [  947.684308] Pid: 2359, comm: bash Not tainted (2.6.26-rc6 #8)
 [  947.684308] EIP: 0060:[<c0216b72>] EFLAGS: 00000246 CPU: 0
 [  947.684308] EIP is at __rt_schedulable+0x12/0x160
 [  947.684308] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
 [  947.684308] ESI: c0521db4 EDI: 00000001 EBP: c6cc9f00 ESP: c6cc9ed0
 [  947.684308]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
 [  947.684308] Process bash (pid: 2359, ti=3Dc6cc8000 task=3Dc7a54f00=20
 task.ti=3Dc6cc8000)
 [  947.684308] Stack: c0222790 00000000 080f8c08 c0521db4 c6cc9f00=20
 00000001 00000000 00000000=20
 [  947.684308]        c6cc9f9c 00000000 c0521db4 00000001 c6cc9f28=20
 c0216d40 00000000 00000000=20
 [  947.684308]        c6cc9f9c 000f4240 000e7ef0 ffffffff c0521db4=20
 c79dfb60 c6cc9f58 c02af2cc=20
 [  947.684308] Call Trace:
 [  947.684308]  [<c0222790>] ? do_proc_dointvec_conv+0x0/0x50
 [  947.684308]  [<c0216d40>] ? sched_rt_handler+0x80/0x110
 [  947.684308]  [<c02af2cc>] ? proc_sys_call_handler+0x9c/0xb0
 [  947.684308]  [<c02af2fa>] ? proc_sys_write+0x1a/0x20
 [  947.684308]  [<c0273c36>] ? vfs_write+0x96/0x160
 [  947.684308]  [<c02af2e0>] ? proc_sys_write+0x0/0x20
 [  947.684308]  [<c027423d>] ? sys_write+0x3d/0x70
 [  947.684308]  [<c0202ef5>] ? sysenter_past_esp+0x6a/0x91
 [  947.684308]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
 [  947.684308] Code: 24 04 e8 62 b1 0e 00 89 c7 89 f8 8b 5d f4 8b 75
 f8 8b 7d fc 89 ec 5d c3 90 55 89 e5 57 56 53 83 ec 24 89 45 ec 89 55 e4
 89 4d e8 <8b> b8 8c 00 00 00 85 ff 0f 84 c9 00 00 00 8b 57 24 39 55 e8
 8b=20
 [  947.684308] EIP: [<c0216b72>] __rt_schedulable+0x12/0x160 SS:ESP =20
 0068:c6cc9ed0


We think the following patch solves the issue.

Hope this is of some help.

Regards,
Dario Faggioli

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index eaf6751..7205e25 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8348,7 +8348,7 @@ static unsigned long to_ratio(u64 period, u64
runtime)
 #ifdef CONFIG_CGROUP_SCHED
 static int __rt_schedulable(struct task_group *tg, u64 period, u64
runtime)
 {
-	struct task_group *tgi, *parent =3D tg->parent;
+	struct task_group *tgi, *parent =3D tg ? tg->parent : NULL;
 	unsigned long total =3D 0;
=20
 	if (!parent) {

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-OaJzNE1uS742PwRFSrI8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhYts4ACgkQk4XaBE3IOsQNiACffcPctmEZV/ttZD3F/VYHY0n7
HI0AmwZNbUIW+YEHCcedI6aL2YRirKEl
=dIFn
-----END PGP SIGNATURE-----

--=-OaJzNE1uS742PwRFSrI8--

