Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbXLRO5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbXLRO5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbXLRO5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:57:14 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:35744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbXLRO5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:57:13 -0500
Subject: Re: 2.6.24-rc5-mm1 -- INFO: possible circular locking dependency
	detected -- pm-suspend/5800 is trying to acquire lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <a44ae5cd0712180641n15ceae8bp977efe9a5b45e6bc@mail.gmail.com> (sfid-20071218_144150_051683_83D9589E)
References: <a44ae5cd0712180603v2a37023dj714a8500c14c08de@mail.gmail.com>
	 <1197986886.4885.156.camel@johannes.berg>
	 <a44ae5cd0712180641n15ceae8bp977efe9a5b45e6bc@mail.gmail.com>
	 (sfid-20071218_144150_051683_83D9589E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hRdJylCaQ45BEXgq2z/I"
Date: Tue, 18 Dec 2007 15:57:06 +0100
Message-Id: <1197989826.4885.169.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hRdJylCaQ45BEXgq2z/I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Sorry.  GMail doesn't support sending unwrapped text, as far as I can
> tell.  I will send the log segment to you as an attachment.  Also,
> when I sent my .config inline to Andrew recently, it tripped his spam
> filter.  I'll attach it as well.

Thanks. This is a bug in iwlwifi.

The problem is actually another case where my workqueue debugging with
lockdep is triggering a warning :))

Here's the thing:

iwl3945_cancel_deferred_work does=20

cancel_delayed_work_sync(&priv->init_alive_start);

(which is the "(&(&priv->init_alive_start)->work)" lock)

but it is called from within a locked section of
mutex_lock(&priv->mutex); (locked from iwl3945_pci_suspend)

On the other hand, the task that runs from the init_alive_start
workqueue is iwl3945_bg_init_alive_start() which will lock the same
mutex.

So the deadlock condition is that you can be in
cancel_delayed_work_sync() above while the mutex is locked, and be
waiting for iwl_3945_bg_init_alive_start() which tries to lock the
mutex.

johannes

--=-hRdJylCaQ45BEXgq2z/I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ffwaVg1VMiehFYAQJ1sw//d3WjOmOMlwroYtDEVaG86jP8YfTS3RLg
+HDmGC+xXZAqGSJK1/g02/oexaMSJUKAXctNcL7L7jc0gIiPRCA3UDkuMQAZG7Iw
3hTwb7vxZL5/cwdqwEeEbJuor2yAond8o5L+w1480HMCpsXMaUyc6oCv39hxlfVL
RYcAmfBpKYdh68Y9NkASaabJLQjgXwIFGYmFpigOghjWITZCH19+mdLoRMcbG9bE
He3DfTNR0ShgvJT0C0KUPEpW0XnNODc+/iOdmxJknAK3FYtlH1gFHPNfOw4dKpMA
cFmEgM3IxhWDRKuuI1ZtPJyPBIHGxXwBZRP+vPx6jSYZYhVSP1VQ+xmfcdDr/ggp
C4yFemYiWmJFzdqjPndVWJnjJDO4cgmL1SG9uDaxLF14OCAU6Vz5LkmwDEPJYj/Z
ZdSSbIKZjbmME+5G8Jl1ek+WO93V+X6mhS46nc1ZpBw5XxFueba+UjkC6oan0TeJ
N1ciKOTooSYfbZSbla9UaAiQvPizawPJAuSeTji4pa8pAQ2+57b3dFoFCPGAoaj3
Qt4lB/2XlufUOQ5d5VVJde39d7iYbgrA8TCPGo76n0NY3vF6atApLScqzdKPYma7
JDXKclIwhw8MTR1iLtztA8YuN8cUD7JDdGGctZyJqaJrS7SLq1xkuH6fMXsDtuIf
csgW708C/rg=
=L9ty
-----END PGP SIGNATURE-----

--=-hRdJylCaQ45BEXgq2z/I--

