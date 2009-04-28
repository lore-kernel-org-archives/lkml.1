Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZD1J62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZD1J62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZD1J6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:58:17 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:41944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbZD1J6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:58:15 -0400
Subject: Re: [PATCH] [RFC] EEE PC hangs when booting off battery
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <49F6CA0E.5040101@tuffmail.co.uk> (sfid-20090428_111942_198975_13CDA6F5)
References: <49E065CF.6040408@tuffmail.co.uk>
	 <200904140859.02188.bjorn.helgaas@hp.com>
	 <20090414081728.10de978a@infradead.org>
	 <200904140948.37633.bjorn.helgaas@hp.com> <49E5F01B.2060201@tuffmail.co.uk>
	 <49EF0ABD.2080801@tuffmail.co.uk> <49F446AE.6070607@tuffmail.co.uk>
	 <49F6CA0E.5040101@tuffmail.co.uk> (sfid-20090428_111942_198975_13CDA6F5)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ssrFuVECca1fp0kSm0VT"
Date: Tue, 28 Apr 2009 11:58:08 +0200
Message-Id: <1240912688.28835.10.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ssrFuVECca1fp0kSm0VT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

It seems the only reason lockdep doesn't warn is the detour to userspace
(modprobe) and the waiting for a userspace task (waiting isn't lockdep
annotated and I don't think it can be)

It seems you cannot load a module while under _any_ lock, ever, since
userspace might turn around and do something that requires that lock? I
think we should probably add a warning to the code that waits for the
userspace task:

	debug_check_no_locks_held(current);

Or not? Some purely internal locks _might_ be ok... but how could you
verify that?

> - ieee80211_wep_init(), which is called with rtnl_lock() held, is
> blocked in request_module() [waiting for modprobe to load a crypto module=
].

Right.

> - modprobe is blocked in a call to flush_workqueue(), caused by closing
> a TTY.

Can you point out where? I can't find that.

> - worker_thread is blocked because the workqueue item linkwatch_event()
> is blocked on rtnl_lock.

This I know about.

> I've hacked up a test patch to move wep_init() outside of rtnl_lock, and
> it solved the problem.  My one caveat is that it would probably be
> cleaner to move it after rtnl_unlock(), instead of before rtnl_lock().=20
> I just wasn't 100% sure if that would be safe.  Here's the patch:

That doesn't seem relevant, this just does some initialisation. However,
you definitely missed adding a call to wep_free().

johannes

--=-ssrFuVECca1fp0kSm0VT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ9tMuAAoJEKVg1VMiehFYSxYQAInSVwhErD9Q6+48V4JpDp2l
3imRtIkdF7+ZFwa2SdF/kiBYP+s+XF1sdulp7PHCtbqdHk4cvoi+XKHOawqo1wYr
qpI2AKDfOf2rzoczAcK4YW2w6BftgxTTqoUVfLKxPb5KUUChjkJnqrRv5UJEyXBv
kWRQSbcT4obujlPIBhnPo93wtlvBSQujU1vPrdqs3G5gaSbQtJlZRjFUuJg35Pke
CEn4nJ62kFeyGZl2eI+QDpyODn7SFUWXuyNTOXgWMcTZsnSlZm7GOTfTi9jBBNEB
FW4ynZ+itvAkxsDIB2cIEsiC0fygxrDDtDcMHFeQWXWdIOiZSMdcgRK6jaxj1sCh
qIwq1uuQ4DU4kobHciOBn00GJgNKT3mViS6CbUjXbqN42/+S9BZOY2IG6YPTmoRb
mn7NcVzA6oy9HVYU2LcBmDuez1lg4w7U7+f1+peCgpAbV4EJ/J0F91TJFNFvGBOK
dHDhxGwdmCQWurgI6FyL37rxSW42Ho6clicm2epdmZ/yG2DRRYD68Vj20IqCEowA
rOfO57ypb/1G71EkyNfCWr9ITTNs+WSQhWFm1YO8U9IgAelIJH/MQLTQ0mKR6Zoe
PYosgETnBt2Nh+p8BRt2gI2+D9W9T7G/IBZaSmMjGLrHjMKIC02Dpkqkri2injDc
9FjC2xhtyugVVRruZXil
=pqaC
-----END PGP SIGNATURE-----

--=-ssrFuVECca1fp0kSm0VT--

