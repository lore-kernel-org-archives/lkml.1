Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZA2Sv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZA2Sv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZA2SvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:51:17 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:52320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZA2SvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:51:16 -0500
Subject: circular locking dependency on shutdown
From: Johannes Berg <johannes@sipsolutions.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Manfred Spraul <manfred@colorfullife.com>,
       Peter Zijlstra <peterz@infradead.org>, cpufreq@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qyONsnimUHMtonmTAd4d"
Date: Thu, 29 Jan 2009 19:50:49 +0100
Message-Id: <1233255049.4067.12.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qyONsnimUHMtonmTAd4d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Every time I shut down my machine with a 2.6.29-rc2 kernel, I get a
lockdep report that scrolls off. I tried capturing it on video, the
relevant frames are here:
http://johannes.sipsolutions.net/files/shutdown-lockdep-images.tar.bz2

Some info I transscribed:

halt is trying to acquire lock
	(&per_cpu(cpu_policy_rwsem, cpu)){---}

but task is already holding lock
	(&cpu_hotplug.lock){--..}

which already yadda yadda

lock chain:
#1	(&cpu_hotplug.lock){--..}
	...
	get_online_cpus
#0	(&per_cpu(cpu_policy_rwsem, cpu))
	...
	disable_nonboot_cpus

stacktrace:
	down_write
	lock_policy_rwsem_write
	cpufreq_cpu_callback
	notifier_call_chain
	disable_nonboot_cpus
	kernel_power_off
	...


johannes

--=-qyONsnimUHMtonmTAd4d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgfqHAAoJEKVg1VMiehFYzFMQALz17Z53dK1hz4xXHwfn30va
8sFUtnDrVrGZkDkZjSnYMoSImtv6RXqBwdzYjoGbWhsk7S4DrsORubAkCSW3C0o/
7Y6O26wf0szDI9NAYHstUl21mCVVrdDztYHIfZUnLUf4IhALCRhUa5zmGjZ8x3YG
abO0nL/itsNsnv37liouHTFBzOeGLmWTbcP4vTa/kdEofBJLkY4LZxY1cCixZtGw
mCZehtTwJ1JpGiMU+7edmT2quWjsETjxgEc41Y9v/GkA2JD78a2P+GvcikmKxGMo
nBpm8f2w93jxHUSyZxd5Yr3QCpae2uaGmQO72BNgykXxYOcSA3vhyrjG4J1fC1bW
RukDJfWCa3TgHNuq0RG9GeXBCHyhP+nB9vX8wBF8DfNsvt8Jy+mCfe/h0nD3tL6c
agvzOIAK1wAvzhvPueLrVvX3n0w62P5Gclv1odDeB17wyh3mP4+njVcnWPQIKDf4
jzhNr1yiBnjb9fO9Tt0HLFxVTN7JlQBXP4DrA5uOA37HrBA3deO3kSEBKKSAzcAu
C4VM/6CeHKA10uFcS1KstY8kxKdxLoHFbr/0NPPTSSLFCI7mKyeKtDnuBMUkDgEO
w8NdpfBv4YLshHQeXyB79MKvBKBGQ3q72rhna3EA0NBEt+vKA8AWS/AlOuvBaq9A
nUrXn+f5cigLMmzWmRjg
=rLa9
-----END PGP SIGNATURE-----

--=-qyONsnimUHMtonmTAd4d--

