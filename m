Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYJXJo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYJXJo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYJXJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:44:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYJXJoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:44:46 -0400
Subject: [PATCH 0/2] Timer sync lock checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6p1JdZLFi1Y4z0oILEqd"
Date: Thu, 23 Oct 2008 21:35:41 +0200
Message-Id: <1224790541.6002.53.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6p1JdZLFi1Y4z0oILEqd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Here are two patches that implement checking with lockdep that nobody
tries to implement something like this:

void timerfn(unsigned long data)
{
	spin_lock(&lock);
	...
	spin_unlock(&lock);
}

...

setup
	spin_lock_init(&lock);
	setup_timer(&timer, timerfn, 0);

...

tear_down
	spin_lock_bh(&lock);
	del_timer_sync(&timer);
	spin_unlock_bh(&lock);

Because of the usage of the fake lock in the timer code, I first needed
to teach lockdep about a new "check" value which means that it doesn't
check irq-safety. This is required because we patch 2 takes a fake lock
around the timerfn, and del_timer_sync() also takes this fake lock, but
quite obviously the former runs in softirq context and the latter
doesn't necessarily, but clearly it doesn't need to disable softirqs
either.

Unlike with the workqueue debugging where I did the same thing, I don't
actually know about any such bug. My test code resulted in the warning
below, as expected.

johannes

[   75.083150] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   75.083163] [ INFO: possible circular locking dependency detected ]
[   75.083170] 2.6.27-wl-03435-g9b45bb6-dirty #92
[   75.083177] -------------------------------------------------------
[   75.083184] rmmod/4365 is trying to acquire lock:
[   75.083191]  (&test_timer){-...}, at: [<c00000000005c834>] .del_timer_sy=
nc+0x0/0x94
[   75.083219]=20
[   75.083220] but task is already holding lock:
[   75.083228]  (&lock){-+..}, at: [<d0000000001090b4>] .modexit+0x38/0x70 =
[timer_test]
[   75.083253]=20
[   75.083254] which lock already depends on the new lock.
[   75.083257]=20
[   75.083263]=20
[   75.083265] the existing dependency chain (in reverse order) is:
[   75.083272]=20
[   75.083273] -> #1 (&lock){-+..}:
[   75.083290]        [<c00000000007fc4c>] .lock_acquire+0xa4/0xec
[   75.083305]        [<c0000000003ee0ec>] ._spin_lock+0x50/0xac
[   75.083320]        [<d00000000010902c>] .timerfn+0x2c/0x7c [timer_test]
[   75.083331]        [<c00000000005bdcc>] .run_timer_softirq+0x214/0x2e4
[   75.083343]        [<c0000000000560cc>] .__do_softirq+0xd8/0x1c4
[   75.083354]        [<c00000000000c298>] .do_softirq+0x5c/0xb8
[   75.083366]        [<c000000000055b08>] .irq_exit+0x74/0xe0
[   75.083376]        [<c00000000001e0e8>] .timer_interrupt+0xe4/0x12c
[   75.083389]        [<c000000000003614>] decrementer_common+0x114/0x180
[   75.083400]        [<c000000000011ea8>] .cpu_idle+0xd0/0x200
[   75.083411]        [<c0000000003eee04>] .rest_init+0x8c/0xa4
[   75.083423]        [<c000000000588bc0>] .start_kernel+0x4a0/0x4c8
[   75.083437]        [<c000000000007568>] .start_here_common+0x3c/0x54
[   75.083449]=20
[   75.083450] -> #0 (&test_timer){-...}:
[   75.083464]        [<c00000000007fc4c>] .lock_acquire+0xa4/0xec
[   75.083474]        [<c00000000005c878>] .del_timer_sync+0x44/0x94
[   75.083486]        [<d0000000001090c0>] .modexit+0x44/0x70 [timer_test]
[   75.083497]        [<c00000000008c320>] .sys_delete_module+0x278/0x314
[   75.083509]        [<c0000000000076d4>] syscall_exit+0x0/0x40
[   75.083520]=20
[   75.083521] other info that might help us debug this:
[   75.083523]=20
[   75.083530] 1 lock held by rmmod/4365:
[   75.083536]  #0:  (&lock){-+..}, at: [<d0000000001090b4>] .modexit+0x38/=
0x70 [timer_test]
[   75.083557]=20
[   75.083558] stack backtrace:
[   75.083563] Call Trace:
[   75.083571] [c00000020ed8b8d0] [c00000000000f860] .show_stack+0x6c/0x174=
 (unreliable)
[   75.083586] [c00000020ed8b980] [c00000000007e008] .print_circular_bug_ta=
il+0xc8/0xec
[   75.083598] [c00000020ed8ba50] [c00000000007f4d0] .__lock_acquire+0x10ac=
/0x1784
[   75.083609] [c00000020ed8bb50] [c00000000007fc4c] .lock_acquire+0xa4/0xe=
c
[   75.083621] [c00000020ed8bc10] [c00000000005c878] .del_timer_sync+0x44/0=
x94
[   75.083633] [c00000020ed8bca0] [d0000000001090c0] .modexit+0x44/0x70 [ti=
mer_test]
[   75.083645] [c00000020ed8bd30] [c00000000008c320] .sys_delete_module+0x2=
78/0x314
[   75.083657] [c00000020ed8be30] [c0000000000076d4] syscall_exit+0x0/0x40


--=-6p1JdZLFi1Y4z0oILEqd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJANIHAAoJEKVg1VMiehFYqOcQAIxiMVEzwBZ5nV23r9adIMNl
/XARk7uU0iqNQsDY73TVUDGsaKrSu0fb8SA3fPOeFrD8H5saZop0V/ef0YVJR2Zy
/zlnLR2utkUFqdTknlV7ZaXDiN0E7+seoiPJ/rxlFHhF1Kys/Z0xFWrTdSGHp47f
62vR1UkmzGtB9XbkroW2JhEmO0nscvWOP8lxZVoozj59qLv94EE0UYVxTE7M/mdB
LOpY8dJ6hSbVJL7V7noeB4Fct1hXR1XbMjErzMIRdXI8MrAv+nqUYQklLwvOWt4D
qe2cwLx5/6sUx82NhU44RhiFJzjOApYu1jrlpGzEwkk8EZE7pqaDKwU+hKTiXNZ+
RDI4ti0akDUzsWQYvR0t3ZvnOLbd/dXey1QSKYK1kprlrsVstIp9vh30ZuBgz3L6
QG2NpVvXa2Ge8AnqkrOGvAkZOPBcHI02MxGPI7POOOZiJdj74AQI2MbZrHfgukE7
18SABsrSlzxoD7T+zOzU5g7O2Gd0UJmJi7bD5R2s0JyvE3Mw5eouSGt92Gd6RJFD
nefS1pQcUXWS2zcW3XulkkKKGJa9/WWrQ31fdYrE+JYcCOUzEdd/vcCwurTDLSpX
+Om+a+qIi8sbGN2u3iMVA0hb0bHZI0G19Iad2lwiBCPX6XqLvvMdsnusz7h3kdlr
J3olO2ZuZT7kAPEQqpIv
=hXoh
-----END PGP SIGNATURE-----

--=-6p1JdZLFi1Y4z0oILEqd--

