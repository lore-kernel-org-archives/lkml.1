Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYFYXxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYFYXxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYFYXxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:53:24 -0400
Received: from ms01.sssup.it ([193.205.80.99]:52710 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754651AbYFYXxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:53:23 -0400
Subject: divide error trying to set rt_period to zero
From: Dario Faggioli <raistlin@linux.it>
To: Michael Trimarchi <trimarchimichael@yahoo.it>,
       PeterZijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Daniel K." <dk@uw.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RcBH3QTChv4lF/Zq9IJA"
Date: Thu, 26 Jun 2008 00:17:27 +0200
Message-Id: <1214432249.5464.22.camel@Palanthas.Krynn>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RcBH3QTChv4lF/Zq9IJA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all again,

Here it is another little Oops we found:

echo 0 > /dev/cgroups/0/cpu.rt_period_us
or
echo 4294967296 > /dev/cgroups/0/cpu.rt_period_us

[  205.509825] divide error: 0000 [#1]=20
[  205.510151] Modules linked in:
[  205.510151]=20
[  205.510151] Pid: 2339, comm: bash Not tainted (2.6.26-rc8 #33)
[  205.510151] EIP: 0060:[<c030c6ef>] EFLAGS: 00000293 CPU: 0
[  205.510151] EIP is at div64_u64+0x5f/0x70
[  205.510151] EAX: 0000389f EBX: 00000000 ECX: 00000000 EDX: 00000000
[  205.510151] ESI: d9800000 EDI: 00000000 EBP: c6cede60 ESP: c6cede50
[  205.510151]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  205.510151] Process bash (pid: 2339, ti=3Dc6cec000 task=3Dc79be370 task.=
ti=3Dc6cec000)
[  205.510151] Stack: d9800000 0000389f c05971a0 d9800000 c6cedeb4 c0214dbd=
 00000000 00000000=20
[  205.510151]        c6cede88 c0242bd8 c05377c0 c7a41b40 00000000 00000000=
 00000000 c05971a0=20
[  205.510151]        c780ed20 c7508494 c7a41b40 00000000 00000002 c6cedebc=
 c05971a0 ffffffea=20
[  205.510151] Call Trace:
[  205.510151]  [<c0214dbd>] ? __rt_schedulable+0x1cd/0x240
[  205.510151]  [<c0242bd8>] ? cgroup_file_open+0x18/0xe0
[  205.510151]  [<c0214fe4>] ? tg_set_bandwidth+0xa4/0xf0
[  205.510151]  [<c0215066>] ? sched_group_set_rt_period+0x36/0x50
[  205.510151]  [<c021508e>] ? cpu_rt_period_write_uint+0xe/0x10
[  205.510151]  [<c0242dc5>] ? cgroup_file_write+0x125/0x160
[  205.510151]  [<c0232c15>] ? hrtimer_interrupt+0x155/0x190
[  205.510151]  [<c02f047f>] ? security_file_permission+0xf/0x20
[  205.510151]  [<c0277ad8>] ? rw_verify_area+0x48/0xc0
[  205.510151]  [<c0283744>] ? dupfd+0x104/0x130
[  205.510151]  [<c027838c>] ? vfs_write+0x9c/0x160
[  205.510151]  [<c0242ca0>] ? cgroup_file_write+0x0/0x160
[  205.510151]  [<c027850d>] ? sys_write+0x3d/0x70
[  205.510151]  [<c0203019>] ? sysenter_past_esp+0x6a/0x91
[  205.510151]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[  205.510151] Code: 0f 45 de 31 f6 0f ad d0 d3 ea f6 c1 20 0f 45 c2 0f 45 =
d6 89 45 f0 89 55 f4 8b 55 f4 31 c9 8b 45 f0 39 d3 89 c6 77 08 89 d0 31 d2 =
<f7> f3 89 c1 83 c4 08 89 f0 f7 f3 89 ca 5b 5e 5d c3 55 89 e5 56=20
[  205.510151] EIP: [<c030c6ef>] div64_u64+0x5f/0x70 SS:ESP 0068:c6cede50

The attached patch solves the issue for me.

I'm checking as soon as possible for the period not being zero since, if
it is, going ahead is useless. This way we also save a mutex_lock() and
a read_lock() wrt doing it inside tg_set_bandwidth() or
__rt_schedulable().

Regards,
Dario Faggioli

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 3aaa5c8..9c3df51 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8501,6 +8501,9 @@ int sched_group_set_rt_period(struct task_group
*tg, long rt_period_us)
 	rt_period =3D (u64)rt_period_us * NSEC_PER_USEC;
 	rt_runtime =3D tg->rt_bandwidth.rt_runtime;
=20
+	if (period =3D=3D 0)
+		return -EINVAL;
+
 	return tg_set_bandwidth(tg, rt_period, rt_runtime);
 }

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

--=-RcBH3QTChv4lF/Zq9IJA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhiw/YACgkQk4XaBE3IOsRfOACfeZY6TS3fYLWeteyRHZI2CSkE
9RQAnjc8PGSCleum+oAhC1gJeKLPx4ns
=vMEe
-----END PGP SIGNATURE-----

--=-RcBH3QTChv4lF/Zq9IJA--

