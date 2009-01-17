Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbZAQNd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbZAQNd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 08:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZAQNdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 08:33:17 -0500
Received: from mail.klingt.org ([86.59.21.178]:47229 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbZAQNdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 08:33:16 -0500
Subject: Re: 2.6.28-rc9: oprofile regression
From: Tim Blechmann <tim@klingt.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
       venkatesh.pallipadi@intel.com
In-Reply-To: <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain>
References: <1229869416.6911.1.camel@thinkpad>
	 <1229894585.6898.6.camel@thinkpad>  <49544497.9020900@linux.intel.com>
	 <1230894257.6072.10.camel@thinkpad>
	 <alpine.LFD.2.00.0901141739580.3598@localhost.localdomain>
	 <1231957184.13033.70.camel@thinkpad>
	 <alpine.LFD.2.00.0901150940250.3598@localhost.localdomain>
	 <1232010853.6541.4.camel@thinkpad>
	 <alpine.LFD.2.00.0901152135110.3400@localhost.localdomain>
	 <1232067181.6134.74.camel@thinkpad>
	 <alpine.LFD.2.00.0901160956170.3400@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DZ++Q4jAMtHfbtXmxLvh"
Date: Sat, 17 Jan 2009 14:32:49 +0100
Message-Id: <1232199169.7016.12.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Sat, 17 Jan 2009 14:32:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DZ++Q4jAMtHfbtXmxLvh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

hm, it seems a bit more complicated than i originally thought.

trying to reconstruct commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8, i
found, that resetting counter_width in ppro_setup_ctrs, causes the
issue. reverting part of the patch, resolved the issue:

--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -79,8 +79,8 @@ static void ppro_setup_ctrs(struct op_msrs const * const =
msrs)
        if (cpu_has_arch_perfmon) {
                union cpuid10_eax eax;
                eax.full =3D cpuid_eax(0xa);
-               if (counter_width < eax.split.bit_width)
-                       counter_width =3D eax.split.bit_width;
+//             if (counter_width < eax.split.bit_width)
+//                     counter_width =3D eax.split.bit_width;
        }
=20
        /* clear all counters */


however, trying to apply this patch to 2.6.28, the behavior is the same
as before (one NMI) ... so possibly, it is a combination of two bugs,
with similar symptoms ...=20

hth, tim

--
tim@klingt.org
http://tim.klingt.org

Your mind will answer most questions if you learn to relax and wait
for the answer.
  William S. Burroughs

--=-DZ++Q4jAMtHfbtXmxLvh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklx3f8ACgkQdL+4qsZfVsucIQCeI+ENwhH4//h5kX0xtDq+tB6/
O08AnRfVPc/PWPbKKlyMBnBKM2/Utsm/
=oSvq
-----END PGP SIGNATURE-----

--=-DZ++Q4jAMtHfbtXmxLvh--

