Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXGDN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXGDN5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbXGDN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:57:11 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:47015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbXGDN5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:57:09 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070704125219.GA98@tv-sign.ru>
References: <1182969638.4769.56.camel@johannes.berg>
	 <1183048429.4089.1.camel@johannes.berg>
	 <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4>
	 <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg>
	 <20070703173112.GA108@tv-sign.ru> <1183549772.3812.10.camel@johannes.berg>
	 <20070704125219.GA98@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m+hT3DQbhhX5ablwaXk5"
Date: Wed, 04 Jul 2007 15:57:59 +0200
Message-Id: <1183557479.3812.24.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m+hT3DQbhhX5ablwaXk5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-04 at 16:52 +0400, Oleg Nesterov wrote:

> Yes. And no other work (except a barrier) can run before the caller of
> wait_on_work() is woken.

Alright, thanks. Yes, then what you proposed makes a lot of sense, I'll
implement it.

> Aha, now I see where I was confused. Yes, we can't avoid the false positi=
ves
> with flush_workqueue().
>=20
> I hope this won't be a problem, because almost every usage of flush_workq=
ueue()
> is pointless nowadays. So even if we have a false positive, it probably
> means the code needs cleanups anyway.
>=20
> But see below,

[...]

> If you are going to do this, may I suggest you to make 2 separate patches=
?
> Exactly because we can't avoid the false positives with flush_workqueue()=
,
> it would be nice if we have an option to revert the 2-nd patch if there a=
re
> too many false positives (I hope this won't happen).

I've run this patch on my system for a few days now and only seen
exactly one warning; however, it's *not* actually a *false* positive,
it's a positive but it's also perfectly possible to deadlock if the
system is loaded more than one work item is stuck on the workqueue for
some reason. Say A takes L1 and B runs without locks, and then you flush
the workqueue under L1; you'll get a real deadlock when both A and B are
actually scheduled to run!

johannes

--=-m+hT3DQbhhX5ablwaXk5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGi6dn/ETPhpq3jKURAgNRAKCUrmlsmzRsfXH5LuMa5HMG1VQi6ACfahtK
3c56nbo5z7Buto/SIk6D3rs=
=Xezd
-----END PGP SIGNATURE-----

--=-m+hT3DQbhhX5ablwaXk5--

