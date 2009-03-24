Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbZCXUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbZCXUXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZCXUXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:23:01 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbZCXUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:23:00 -0400
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20090324172354.GB17297@ldl.fc.hp.com>
References: <20090320204327.12275.43010.stgit@bob.kio>
	 <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com>
	 <20090324032304.GB6175@ldl.fc.hp.com> <20090324092525.GE6605@elte.hu>
	 <20090324034659.9e1f97dc.akpm@linux-foundation.org>
	 <1237897972.4320.79.camel@johannes.local>
	 <20090324172354.GB17297@ldl.fc.hp.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B1AP1S5Lvv/zYdjc49HI"
Date: Tue, 24 Mar 2009 21:22:11 +0100
Message-Id: <1237926131.4320.127.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B1AP1S5Lvv/zYdjc49HI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 11:23 -0600, Alex Chiang wrote:

> > There is no bug -- it's a false positive in a way. I've pointed this ou=
t
> > in the original thread, see
> > http://thread.gmane.org/gmane.linux.kernel/550877/focus=3D550932
>=20
> I'm actually a bit confused now.

Sorry.

> Peter explained why flushing a workqueue from the same queue is
> bad, and in general I agree, but what do you mean by "false
> positive"?

Well, even though generally flushing it from within is bad, the actual
thing lockdep reports is bogus -- it's reporting a nested locking.

> By the way, this scenario:
>=20
> 	code path 1:
> 	  my_function() -> lock(L1); ...; flush_workqueue(); ...
>=20
> 	code path 2:
> 	  run_workqueue() -> my_work() -> ...; lock(L1); ...
>=20
> is _not_ what is happening here.

Indeed.

> So what you really have going on is:
>=20
> 	sysfs callback -> add remove callback to global workqueue
> 	remove callback fires off (pci_remove_bus_device) and we do...
> 	    device_unregister
> 	    driver's ->remove method called
> 	    driver's ->remove method calls flush_scheduled_work
>=20
> Yes, after read the thread I agree that generically calling
> flush_workqueue in the middle of run_workqueue is bad, but the
> lockdep warning that Kenji showed us really won't deadlock.

Exactly that is what I meant by "false positive".

> This is because pci_remove_bus_device() will not acquire any lock
> L1 that an individual device driver will attempt to acquire in
> the remove path. If that were the case, we would deadlock every
> time you rmmod'ed a device driver's module or every time you shut
> your machine down.
>=20
> I think from my end, there are 2 things I need to do:
>=20
> 	a) make sysfs_schedule_callback() use its own work queue
> 	   instead of global work queue, because too many drivers
> 	   call flush_scheduled_work in their remove path
>=20
> 	b) give sysfs attributes the ability to commit suicide
>=20
> (a) is short term work, 2.6.30 timeframe, since it doesn't
> involve any large conceptual changes.
>=20
> (b) is picking up Tejun Heo's existing work, but that was a bit
> controversial last time, and I'm not sure it will make it during
> this merge window.
>=20
> Question for the lockdep folks though -- given what I described,
> do you agree that the warning we saw was a false positive? Or am
> I off in left field?

I think we're not sure yet -- it seems Lai Jiangshan described a
scenario in which flushing from within the work actually _can_ deadlock.

johannes

--=-B1AP1S5Lvv/zYdjc49HI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyUDwAAoJEKVg1VMiehFYsHcQAJIvoNnwSH6y7Z3ktPfxj1pn
4KeQTTDeghUbkvnpHeJoDXIkf7AUFK7spUe6yx0IG5Ef9rYEOWGNdpRh8Fc1zngC
b84iMw10b5Pf22vQ7qy90hI06ZaEAo0+lguEgGcu6BUibKyT8WfkuuIGL3lGVFT7
1GU0L4edRsCKlUC/VpXihQtsoIkkAcbyN2Y3f0Fse2ojS+v8KPDLF67adKkl/rab
zKPYprq40fsb7bLe1w6+OhnCPuSxnDVU3bLbhZ66O25zDgSZWPy2dDJhdVpCkPVw
uudGoMzqGVFJyq8CcGUPkBZoMhymxL0RL/jgRaL9qS06g7WoyRd6wOQaXKIr/lQD
Ul2bu2AnHO1GhVQO0XO17pJQAyGepka5oe8jgqC+1eEg1vzMsmmYFFUxPB4kfqz0
h2po/bTRzhbVOUCnfo8hLiWQODza76rWisYak4poK3pbUc8A1b8G7tI/2QNpi+nz
NUsoJ6D/G3S5HO/5W6h1LpoLpFTnlwY4cAOmPqNFycoR2pruwTHI25FxyQONE3MD
GztdI6/erj5FXLJHq9wLXjL+qz+KqnMSm1dNarer53aHUuZQBOqNup6CQbD7+an5
k0TY3opJcVU8ZBYxwFUw3Vo6Kq0zpQTyND9IWA63svlQlqdGrk+9r+lTdGutplcT
892ONMy2A8d0JpHjqWxg
=uxr6
-----END PGP SIGNATURE-----

--=-B1AP1S5Lvv/zYdjc49HI--

