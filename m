Return-Path: <linux-kernel-owner+w=401wt.eu-S965710AbXAZQaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965710AbXAZQaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965715AbXAZQaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:30:12 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1829 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965710AbXAZQaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:30:10 -0500
Message-ID: <45BA2C7C.8070105@imap.cc>
Date: Fri, 26 Jan 2007 17:29:48 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 2.6.20-rc5] Gigaset ISDN driver error handling fixes
References: <20070117174213.A39123427B1@gx110.ts.pxnet.com> <20070123224742.4b13b2ea.akpm@osdl.org>
In-Reply-To: <20070123224742.4b13b2ea.akpm@osdl.org>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig382CE6A97BE09193404B5F38"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig382CE6A97BE09193404B5F38
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton schrieb:
> On Wed, 17 Jan 2007 18:42:13 +0100 (CET)
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> +	mutex_init(&cs->mutex);
>> +	mutex_lock(&cs->mutex);
>=20
> I have vague memories of making rude comments about this a few months a=
go.

Rude comments from you? I must have missed that. ;-)

> It is very weird to lock a mutex just after intialising it.  I mean, if=
 any other
> thread can lock this mutex then there's a race.  If no other thread can=

> lock it, then this thread doesn't need to either.

No other thread can lock it at this point, because the data structure
pointed to by cs is only just being created. The possibility for other
threads to access it is created a little later, however, specifically
by the calls to gigaset_if_init(cs) and gigaset_init_dev_sysfs(cs) in
line 741 and 744, so the mutex has to be locked before entering these.

But I admit the mutexed code section is cut a bit generously here.
Would something like the following reduce the weirdness sufficiently?
(compile tested only)


--- linux-2.6.20-rc6-work/drivers/isdn/gigaset/common.c	2007-01-25 23:53:=
17.000000000 +0100
+++ local/drivers/isdn/gigaset/common.c	2007-01-26 13:38:42.000000000 +01=
00
@@ -640,7 +640,6 @@ struct cardstate *gigaset_initcs(struct
 		return NULL;
 	}
 	mutex_init(&cs->mutex);
-	mutex_lock(&cs->mutex);

 	gig_dbg(DEBUG_INIT, "allocating bcs[0..%d]", channels - 1);
 	cs->bcs =3D kmalloc(channels * sizeof(struct bc_state), GFP_KERNEL);
@@ -738,6 +737,9 @@ struct cardstate *gigaset_initcs(struct

 	++cs->cs_init;

+	mutex_lock(&cs->mutex);
+
+	/* set up character device */
 	gigaset_if_init(cs);

 	/* set up device sysfs */
@@ -746,6 +748,9 @@ struct cardstate *gigaset_initcs(struct
 	spin_lock_irqsave(&cs->lock, flags);
 	cs->running =3D 1;
 	spin_unlock_irqrestore(&cs->lock, flags);
+
+	mutex_unlock(&cs->mutex);
+
 	setup_timer(&cs->timer, timer_tick, (unsigned long) cs);
 	cs->timer.expires =3D jiffies + msecs_to_jiffies(GIG_TICK);
 	/* FIXME: can jiffies increase too much until the timer is added?
@@ -753,11 +758,9 @@ struct cardstate *gigaset_initcs(struct
 	add_timer(&cs->timer);

 	gig_dbg(DEBUG_INIT, "cs initialized");
-	mutex_unlock(&cs->mutex);
 	return cs;

 error:
-	mutex_unlock(&cs->mutex);
 	gig_dbg(DEBUG_INIT, "failed");
 	gigaset_freecs(cs);
 	return NULL;


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig382CE6A97BE09193404B5F38
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD4DBQFFuiyJMdB4Whm86/kRAtuCAJ4++zkDAo9m9kZG43g2i46l2J9MfwCUCzjx
P8mL8EF+rDOfT/1eUZI/rA==
=XgYQ
-----END PGP SIGNATURE-----

--------------enig382CE6A97BE09193404B5F38--
