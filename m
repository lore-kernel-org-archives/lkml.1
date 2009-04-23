Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZDWJoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZDWJoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZDWJn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:43:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:39413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZDWJn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:43:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,235,1239001200"; 
   d="asc'?scan'208";a="134917260"
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <49DC5D11.4060505@jp.fujitsu.com>
References: <20090407506.675031434@firstfloor.org>
	 <20090407150656.43E161D046D@basil.firstfloor.org>
	 <49DC5D11.4060505@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iQTmbVoGj4/d2Ojs9WVF"
Date: Thu, 23 Apr 2009 17:43:53 +0800
Message-Id: <1240479833.6842.554.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iQTmbVoGj4/d2Ojs9WVF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Add some description for the patch, hope that to be more clear.

Best Regards,
Huang Ying
--------------------------------------------->
mce_get_rip() is used to get IP when MCE is generated, usually from
the stack. But the IP on the stack is not always valid.
MCG_STATUS_RIPV indicates program can restart from the IP on the stack,
so if it is set, the IP is valid. MCG_STATUS_EIPV indicate IP on the
stack is directly associated with the error, so if it is set, the IP
is valid too.

In current implementation, no IP will be returned (and then reported)
if MCG_STATUS_RIPV is not set and MCG_STATUS_EIPV is set. This patch
fixes this issue by returning IP on the stack when MCG_STATUS_EIPV is
set.

In some CPU, a MSR (rip_msr) provides another way to get IP when MCE
is generated. This is used by mce_get_rip() too.

There is no MSR for CS, in current implementation, if rip_msr is used
to get IP, reported CS is set to 0. But in fact, the CS on the stack
can be trusted if MCG_STATUS_RIPV or MCG_STATUS_EIPV is set. This
patch fixes this issue by keeping reported CS when rip_msr is used.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -173,21 +173,22 @@ int mce_available(struct cpuinfo_x86 *c)
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
=20
+/*
+ * Get the address of instruction at the time of the machine check error.
+ */
 static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 {
-	if (regs && (m->mcgstatus & MCG_STATUS_RIPV)) {
+	/* Use value on the stack if it is meaningful. */
+	if (regs && (m->mcgstatus & (MCG_STATUS_RIPV | MCG_STATUS_EIPV))) {
 		m->ip =3D regs->ip;
 		m->cs =3D regs->cs;
 	} else {
 		m->ip =3D 0;
 		m->cs =3D 0;
 	}
-	if (rip_msr) {
-		/* Assume the RIP in the MSR is exact. Is this true? */
-		m->mcgstatus |=3D MCG_STATUS_EIPV;
+	/* Use accurate value if available. */
+	if (rip_msr)
 		rdmsrl(rip_msr, m->ip);
-		m->cs =3D 0;
-	}
 }
=20
 /*
@@ -569,7 +570,10 @@ static int mce_cap_init(void)
 		memset(bank, 0xff, banks * sizeof(u64));
 	}
=20
-	/* Use accurate RIP reporting if available. */
+	/*
+	 * Use Extended Machine Check State Register to get accurate state of
+	 * the RIP register at the time of the machine check if available.
+	 */
 	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >=3D 9)
 		rip_msr =3D MSR_IA32_MCG_EIP;
=20


--=-iQTmbVoGj4/d2Ojs9WVF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknwOEsACgkQKhFGF+eHlpgTwwCcC+kRyI9kfEJRqPkaruYs4UHO
OSEAmgLR9DFPwW3U7vnZg/nsUfY+5I0T
=1bHO
-----END PGP SIGNATURE-----

--=-iQTmbVoGj4/d2Ojs9WVF--

