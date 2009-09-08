Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZIHXXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZIHXXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIHXXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:23:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52472 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbZIHXXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:23:50 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Kettlewell <rjk@terraraq.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t7cnfdNirT98JFPhNRSs"
Date: Wed, 09 Sep 2009 00:23:48 +0100
Message-Id: <1252452228.3423.121.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] x86: Fix code patching for paravirt-alternatives on 486
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t7cnfdNirT98JFPhNRSs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

As reported in <http://bugs.debian.org/511703> and
<http://bugs.debian.org/515982>, kernels with paravirt-alternatives
enabled crash in text_poke_early() on at least some 486-class
processors.

The problem is that text_poke_early() itself contains paravirt-
alternatives and therefore will modify instructions that have already
been prefetched.  Pentium and later processors will invalidate the
prefetched instructions in this case, but 486-class processors do
not.  We must use a jmp instruction to limit prefetching.

There is then a further problem in that sync_core() uses "cpuid" which
isn't implemented by most 486-class processors.  Since they also do
not perform speculative execution, we can make this conditional on the
processor family.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This has been tested as a change to 2.6.26 by Richard Kettlewell.  This
code doesn't appear to have changed significantly since then, so
hopefully the change is still correct.

Possible the call to sync_core() should be moved above the
local_irq_restore() and should incorporate the dummy jmp?

Ben.

 arch/x86/include/asm/processor.h |    6 ++++++
 arch/x86/kernel/alternative.c    |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index c776826..74ddfce 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -708,6 +708,12 @@ static inline void sync_core(void)
 {
 	int tmp;
=20
+#if defined(CONFIG_M386) || defined(CONFIG_M486)
+	/* This is unnecessary on 386- and 486-class processors, most of
+	   which don't even implement CPUID. */
+	if (boot_cpu_data.x86 < 5)
+		return;
+#endif
 	asm volatile("cpuid" : "=3Da" (tmp) : "0" (1)
 		     : "ebx", "ecx", "edx", "memory");
 }
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 4869351..330ab89 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -498,6 +498,9 @@ static void *__init_or_module text_poke_early(void *add=
r, const void *opcode,
 	unsigned long flags;
 	local_irq_save(flags);
 	memcpy(addr, opcode, len);
+	/* Force 486-class processors to flush prefetched instructions,
+	   since we may have just patched local_irq_restore(). */
+	asm volatile("jmp 1f\n1:\n" ::: "memory");
 	local_irq_restore(flags);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
--=20
1.6.3.3


--=-t7cnfdNirT98JFPhNRSs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASqbnf+e/yOyVhhEJAQIQXw//dtSGei3Frv5E5708/LLcOj46VrGLuCcH
w41i+9BM2EAjufoTAyWbY2W1rMxb4yVC217bGjeqpd2Xw6j8oYs45UPVCQ23Gor1
NbEJUbg/ufYrtEx40ZLEyHVzR06GXwJY6iM4zftICazpNG9U27JIRUyTOT0Fsrls
qJvn5KcIHZoq9YPL2FMLJRBTvDezOqHTFuLHz9r/nQUn/6SV5zqg80BUFGs5os/B
i56Sg2/d0CdBmSycBzDcM2okOKVGIg0qxNdb51aF4hV0OfLIxOUPPFtjUNie9EE7
Hmx0rYcOm5Z0AGGqephcX5EKhTtG+UDmkpmlxv7DXRllJAT6pRzFHChQLi3y5s+D
tLSEsfKS6XeXWabrFkAf15EiTZWx1Q6dVcXukB8SvLCrrlgNykgO1WrraEMbeIXz
nWVoyBNExZE6nWnUYBoLcrYzxICRre8TDP/HqEk1VwU0uj5J1Mfm1x/IiCDeM4sg
wIwQnWk8z/hoV8DXYaW3tTyHhEbJDvBuwXxra8RMJIEwQFi67ZiV52NI3PZbPZp9
srpxMc0fd7ac//nM1c6EFJqoJEUlzFSuBgTRu3VBbzQtOFkBtb0I7rB0cjj/Q25+
IjlWT6vERsQKseaZTWgYluE2ZUQRmDwPurM+j0JMZzvRQNRDKsIzR/wBbNAv9Z6Q
HvigjiyG4B8=
=tA0S
-----END PGP SIGNATURE-----

--=-t7cnfdNirT98JFPhNRSs--
