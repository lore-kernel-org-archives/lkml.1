Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZEDRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZEDRWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbZEDRWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:22:06 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZEDRWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:22:03 -0400
Subject: Re: [BUG 13245] -  possible circular locking dependency detected
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Miles Lane <miles.lane@gmail.com>, rusty <rusty@rustcorp.com.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <peterz@infradead.org>, bugme-daemon@bugzilla.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i2yMeZo47TKzl4dTopUt"
Date: Mon, 04 May 2009 19:21:24 +0200
Message-Id: <1241457684.8683.77.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i2yMeZo47TKzl4dTopUt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

This is effectively a copy of
http://bugzilla.kernel.org/show_bug.cgi?id=3D13245 but with a few more
people. I hope this works and bugme picks it up.

The report is below.

The problem here is effectively that something runs off the events
workqueue, and ends up, with some indirection that I think doesn't
matter much, using cpu_add_remove_lock, either while being on the events
workqueue or in this case depending on a lock that was used from the
events workqueue.

It seems that the problem is in disable_nonboot_cpus, which via the
notifier indirection calls cleanup_workqueue_thread() which flushes the
workqueue so needs the fake "events" lock.

On the other hand, via some indirection, things that run off the events
end up using (depending on something that uses) cpu_add_remove_lock.

Thoughts?

[ 1231.558889] [ INFO: possible circular locking dependency detected ]
[ 1231.558895] 2.6.30-rc4-git1 #5
[ 1231.558899] -------------------------------------------------------
[ 1231.558903] pm-suspend/4741 is trying to acquire lock:
[ 1231.558908]  (events){+.+.+.}, at: [<ffffffff80249feb>] cleanup_workqueu=
e_thread+0x1e/0xf8
[ 1231.558927]=20
[ 1231.558929] but task is already holding lock:
[ 1231.558932]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8023a8a5>] dis=
able_nonboot_cpus+0x33/0x11d
[ 1231.558947]=20
[ 1231.558948] which lock already depends on the new lock.
[ 1231.558951]=20
[ 1231.558954]=20
[ 1231.558955] the existing dependency chain (in reverse order) is:
[ 1231.558959]=20
[ 1231.558961] -> #5 (cpu_add_remove_lock){+.+.+.}:
[ 1231.558969]        [<ffffffff8025dc42>] __lock_acquire+0xa88/0xc22
[ 1231.558980]        [<ffffffff8025ded2>] lock_acquire+0xf6/0x11a
[ 1231.558988]        [<ffffffff8058a217>] __mutex_lock_common+0x5a/0x429
[ 1231.558999]        [<ffffffff8058a680>] mutex_lock_nested+0x30/0x35
[ 1231.559008]        [<ffffffff8023a80e>] cpu_maps_update_begin+0x12/0x14
[ 1231.559017]        [<ffffffff8024a34b>] __create_workqueue_key+0x161/0x2=
26
[ 1231.559026]        [<ffffffff80275cc8>] stop_machine_create+0x3a/0x9b
[ 1231.559035]        [<ffffffff80275d42>] stop_machine+0x19/0x4b
[ 1231.559044]        [<ffffffffa0115238>] 0xffffffffa0115238
[ 1231.559061]        [<ffffffff8020906b>] do_one_initcall+0x65/0x153
[ 1231.559072]        [<ffffffff80266b50>] sys_init_module+0xab/0x1d3
[ 1231.559080]        [<ffffffff8020b26b>] system_call_fastpath+0x16/0x1b
[ 1231.559089]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1231.559097]=20
[ 1231.559099] -> #4 (setup_lock){+.+.+.}:
[ 1231.559105]        [<ffffffff8025dc42>] __lock_acquire+0xa88/0xc22
[ 1231.559114]        [<ffffffff8025ded2>] lock_acquire+0xf6/0x11a
[ 1231.559122]        [<ffffffff8058a217>] __mutex_lock_common+0x5a/0x429
[ 1231.559132]        [<ffffffff8058a680>] mutex_lock_nested+0x30/0x35
[ 1231.559141]        [<ffffffff80275ca0>] stop_machine_create+0x12/0x9b
[ 1231.559150]        [<ffffffff8023a888>] disable_nonboot_cpus+0x16/0x11d
[ 1231.559159]        [<ffffffff80267993>] suspend_devices_and_enter+0xd6/0=
x1b1
[ 1231.559168]        [<ffffffff80267bfa>] enter_state+0x163/0x1c9
[ 1231.559176]        [<ffffffff80267d17>] state_store+0xb7/0xd8
[ 1231.559184]        [<ffffffff803bd78b>] kobj_attr_store+0x17/0x19
[ 1231.559194]        [<ffffffff803137b3>] sysfs_write_file+0xe4/0x119
[ 1231.559203]        [<ffffffff802c237a>] vfs_write+0xab/0x105
[ 1231.559212]        [<ffffffff802c2498>] sys_write+0x47/0x70
[ 1231.559219]        [<ffffffff8020b26b>] system_call_fastpath+0x16/0x1b
[ 1231.559228]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1231.559236]=20
[ 1231.559238] -> #3 (dpm_list_mtx){+.+.+.}:
[ 1231.559245]        [<ffffffff8025dc42>] __lock_acquire+0xa88/0xc22
[ 1231.559253]        [<ffffffff8025ded2>] lock_acquire+0xf6/0x11a
[ 1231.559262]        [<ffffffff8058a217>] __mutex_lock_common+0x5a/0x429
[ 1231.559272]        [<ffffffff8058a680>] mutex_lock_nested+0x30/0x35
[ 1231.559281]        [<ffffffff8046002d>] device_pm_add+0x1e/0xb5
[ 1231.559292]        [<ffffffff80459fae>] device_add+0x37c/0x557
[ 1231.559301]        [<ffffffffa008f453>] wiphy_register+0x148/0x1ec [cfg8=
0211]
[ 1231.559320]        [<ffffffffa00c62f8>] ieee80211_register_hw+0xe9/0x3aa=
 [mac80211]
[ 1231.559348]        [<ffffffffa01776e2>] iwl3945_pci_probe+0xb5c/0xcce [i=
wl3945]
[ 1231.559368]        [<ffffffff803d1a5f>] local_pci_probe+0x12/0x16
[ 1231.559378]        [<ffffffff803d274e>] pci_device_probe+0x5f/0x89
[ 1231.559388]        [<ffffffff8045bf49>] driver_probe_device+0x9e/0x143
[ 1231.559398]        [<ffffffff8045c046>] __driver_attach+0x58/0x7b
[ 1231.559406]        [<ffffffff8045b83c>] bus_for_each_dev+0x54/0x8a
[ 1231.559415]        [<ffffffff8045bdbb>] driver_attach+0x1c/0x1e
[ 1231.559423]        [<ffffffff8045b178>] bus_add_driver+0xb2/0x1e6
[ 1231.559432]        [<ffffffff8045c300>] driver_register+0xb6/0x121
[ 1231.559439]        [<ffffffff803d2b76>] __pci_register_driver+0x61/0xcf
[ 1231.559448]        [<ffffffffa018505c>] 0xffffffffa018505c
[ 1231.559456]        [<ffffffff8020906b>] do_one_initcall+0x65/0x153
[ 1231.559464]        [<ffffffff80266b50>] sys_init_module+0xab/0x1d3
[ 1231.559473]        [<ffffffff8020b26b>] system_call_fastpath+0x16/0x1b
[ 1231.559481]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1231.559489]=20
[ 1231.559491] -> #2 (cfg80211_mutex){+.+.+.}:
[ 1231.559498]        [<ffffffff8025dc42>] __lock_acquire+0xa88/0xc22
[ 1231.559507]        [<ffffffff8025ded2>] lock_acquire+0xf6/0x11a
[ 1231.559515]        [<ffffffff8058a217>] __mutex_lock_common+0x5a/0x429
[ 1231.559524]        [<ffffffff8058a680>] mutex_lock_nested+0x30/0x35
[ 1231.559533]        [<ffffffffa0090a0b>] reg_todo+0x5d/0x4d8 [cfg80211]
[ 1231.559553]        [<ffffffff80249bf9>] worker_thread+0x24b/0x367
[ 1231.559561]        [<ffffffff8024d94d>] kthread+0x56/0x83
[ 1231.559570]        [<ffffffff8020c37a>] child_rip+0xa/0x20
[ 1231.559577]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1231.559585]=20
[ 1231.559587] -> #1 (reg_work){+.+.+.}:
[ 1231.559593]        [<ffffffff8025dc42>] __lock_acquire+0xa88/0xc22
[ 1231.559603]        [<ffffffff8025ded2>] lock_acquire+0xf6/0x11a
[ 1231.559611]        [<ffffffff80249bf0>] worker_thread+0x242/0x367
[ 1231.559619]        [<ffffffff8024d94d>] kthread+0x56/0x83
[ 1231.559627]        [<ffffffff8020c37a>] child_rip+0xa/0x20
[ 1231.559634]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1231.559658]=20
[ 1231.559659] -> #0 (events){+.+.+.}:
[ 1231.559666]        [<ffffffff8025db36>] __lock_acquire+0x97c/0xc22
[ 1231.559675]        [<ffffffff8025ded2>] lock_acquire+0xf6/0x11a
[ 1231.559683]        [<ffffffff8024a012>] cleanup_workqueue_thread+0x45/0x=
f8
[ 1231.559691]        [<ffffffff8057c347>] workqueue_cpu_callback+0xc2/0x10=
5
[ 1231.559703]        [<ffffffff8058e6a1>] notifier_call_chain+0x5e/0x92
[ 1231.559712]        [<ffffffff80251c78>] raw_notifier_call_chain+0xf/0x11
[ 1231.559722]        [<ffffffff8057a9db>] _cpu_down+0x278/0x295
[ 1231.559730]        [<ffffffff8023a8ea>] disable_nonboot_cpus+0x78/0x11d
[ 1231.559740]        [<ffffffff80267993>] suspend_devices_and_enter+0xd6/0=
x1b1
[ 1231.559749]        [<ffffffff80267bfa>] enter_state+0x163/0x1c9
[ 1231.559757]        [<ffffffff80267d17>] state_store+0xb7/0xd8
[ 1231.559765]        [<ffffffff803bd78b>] kobj_attr_store+0x17/0x19
[ 1231.559773]        [<ffffffff803137b3>] sysfs_write_file+0xe4/0x119
[ 1231.559781]        [<ffffffff802c237a>] vfs_write+0xab/0x105
[ 1231.559788]        [<ffffffff802c2498>] sys_write+0x47/0x70
[ 1231.559796]        [<ffffffff8020b26b>] system_call_fastpath+0x16/0x1b
[ 1231.559804]        [<ffffffffffffffff>] 0xffffffffffffffff
[ 1231.559813]=20
[ 1231.559814] other info that might help us debug this:
[ 1231.559817]=20
[ 1231.559822] 4 locks held by pm-suspend/4741:
[ 1231.559825]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff80313707>] sys=
fs_write_file+0x38/0x119
[ 1231.559838]  #1:  (pm_mutex){+.+.+.}, at: [<ffffffff80267c57>] enter_sta=
te+0x1c0/0x1c9
[ 1231.559851]  #2:  (dpm_list_mtx){+.+.+.}, at: [<ffffffff8045f533>] devic=
e_pm_lock+0x12/0x14
[ 1231.559864]  #3:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8023a8a5>=
] disable_nonboot_cpus+0x33/0x11d
[ 1231.559878]=20
[ 1231.559880] stack backtrace:
[ 1231.559886] Pid: 4741, comm: pm-suspend Not tainted 2.6.30-rc4-git1 #5
[ 1231.559892] Call Trace:
[ 1231.559895]  [<ffffffff8025ce44>] print_circular_bug_tail+0x71/0x7c
[ 1231.559895]  [<ffffffff8025db36>] __lock_acquire+0x97c/0xc22
[ 1231.559895]  [<ffffffff8025ded2>] lock_acquire+0xf6/0x11a
[ 1231.559895]  [<ffffffff80249feb>] ? cleanup_workqueue_thread+0x1e/0xf8
[ 1231.559895]  [<ffffffff8024a012>] cleanup_workqueue_thread+0x45/0xf8
[ 1231.559895]  [<ffffffff80249feb>] ? cleanup_workqueue_thread+0x1e/0xf8
[ 1231.559895]  [<ffffffff8057c347>] workqueue_cpu_callback+0xc2/0x105
[ 1231.559895]  [<ffffffff8058e6a1>] notifier_call_chain+0x5e/0x92
[ 1231.559895]  [<ffffffff80251c78>] raw_notifier_call_chain+0xf/0x11
[ 1231.559895]  [<ffffffff8057a9db>] _cpu_down+0x278/0x295
[ 1231.559895]  [<ffffffff8023a8ea>] disable_nonboot_cpus+0x78/0x11d
[ 1231.559895]  [<ffffffff80267993>] suspend_devices_and_enter+0xd6/0x1b1
[ 1231.559895]  [<ffffffff80267bfa>] enter_state+0x163/0x1c9
[ 1231.559895]  [<ffffffff80267d17>] state_store+0xb7/0xd8
[ 1231.559895]  [<ffffffff803bd78b>] kobj_attr_store+0x17/0x19
[ 1231.559895]  [<ffffffff803137b3>] sysfs_write_file+0xe4/0x119
[ 1231.559895]  [<ffffffff802c237a>] vfs_write+0xab/0x105
[ 1231.559895]  [<ffffffff802c2498>] sys_write+0x47/0x70
[ 1231.559895]  [<ffffffff8020b26b>] system_call_fastpath+0x16/0x1b


--=-i2yMeZo47TKzl4dTopUt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/yQRAAoJEKVg1VMiehFYpWwP/RVfux8Za+5fkfTS8UOf5dQ3
igJt6CShWhL9ku9vPZ41Glvtvb+yNYJtm7g0JCWH4hKsApQ5Mfw+uFX8vZ3VvWfO
dKpY4zwqYwkihuJoSXUSeT1YH8Fyvn9th6OP7DYyZ2WFfmecV6UQPhVroxc8AazK
gVlJH9vRIlOR1Dl26lTlxxKcgda8Uw03V1Jq0LzlNBRfAUyanO9FOX9YP+XuImRb
6D8DxNjZmzQOJ4azH12Sy8GiiqP2bDMf6YPF34adUV1lfk42Rh02PcdkesZxNNPR
U+JpY2U5fHYNPfkZFONSPRNIJ02nNXq5tB0YCMmBUSqhMmRd+sL4ZITZopySnXd6
Pc5CXPZ20KWgK+So8cQ/a6BkrMSbWsXx1oQi5/SjF8BJx3lrVcjoUQLf6dAN0n2E
ggcmfm/qSy0nY6mCZBa/JQTmcS7B2/6j0l6QOEteAMdihFyrb71p+ID91QsqdKyh
AsIkFBAzAqJjU/radSpBYyonvwyGJhA77S7y9DLgR0vjLGcODSydeEJfItd1ZcmU
AWm8IlSoLXC3IyOsbAt3eoamKFWgs/6JPn0hBRudS4Xk/5Fk4GtCEutNPg1hY4zk
hnl1XCw7AQALnrOjFE4TH7zrXDlm4ZbPyKjVFq9Q6xZxY7LP90BF7JwypE4BNEyP
4alnSOaGHHbj/2fmYzSU
=lLjX
-----END PGP SIGNATURE-----

--=-i2yMeZo47TKzl4dTopUt--

