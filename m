Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYAEW2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYAEW2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 17:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYAEW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 17:28:09 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:41996 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYAEW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 17:28:08 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jan 2008 17:28:07 EST
Date: Sat, 5 Jan 2008 16:16:55 -0600
From: David Fries <david@fries.net>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] system timer: fix crash in <100Hz system timer
Message-ID: <20080105221653.GA10065@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The kernel has a divide by zero crash when trying to run the system
timer less than 100Hz.  The problem is x/(HZ/USER_HZ) and related.
Now x*(USER_HZ/HZ) will be used if HZ<USER_HZ.

I'm running the Linux kernel under qemu and went to run a slower
system timer to take less CPU (and battery) on the host.  I found that
the kernel paniced under emulation because of a divide by zero in
three places.  Here is the patch.  The base git was updated today
01-05-2008.  I went for a 20Hz system time by adding config HZ_20 etc
to kernel/Kconfig.hz.  With this patch I verified the system timer by
looking at /proc/interrupts.

Signed-off-by: David Fries <david@fries.net>

--=20
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)


diff --git a/include/linux/acct.h b/include/linux/acct.h
index 302eb72..86b848d 100644
--- a/include/linux/acct.h
+++ b/include/linux/acct.h
@@ -173,7 +173,11 @@ typedef struct acct acct_t;
 static inline u32 jiffies_to_AHZ(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / AHZ)) =3D=3D 0
-	return x / (HZ / AHZ);
+	#if HZ < AHZ
+		return x * (AHZ / HZ);
+	#else
+		return x / (HZ / AHZ);
+	#endif
 #else
         u64 tmp =3D (u64)x * TICK_NSEC;
         do_div(tmp, (NSEC_PER_SEC / AHZ));
diff --git a/kernel/time.c b/kernel/time.c
index 09d3c45..23af26f 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -565,7 +565,11 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 clock_t jiffies_to_clock_t(long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) =3D=3D 0
+	#if HZ < USER_HZ
+	return x * (USER_HZ / HZ);
+	#else
 	return x / (HZ / USER_HZ);
+	#endif
 #else
 	u64 tmp =3D (u64)x * TICK_NSEC;
 	do_div(tmp, (NSEC_PER_SEC / USER_HZ));
@@ -598,7 +602,12 @@ EXPORT_SYMBOL(clock_t_to_jiffies);
 u64 jiffies_64_to_clock_t(u64 x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) =3D=3D 0
-	do_div(x, HZ / USER_HZ);
+	#if HZ < USER_HZ
+		x *=3D USER_HZ;
+		do_div(x, HZ);
+	#else
+		do_div(x, HZ / USER_HZ);
+	#endif
 #else
 	/*
 	 * There are better ways that don't overflow early,

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFHgAHVAI852cse6PARAnBiAJ9UybCzUcNk4+cni4QWPmmBcPb3GQCgjMGy
VwGv13QHFpAlgThurpj1tvY=
=amiE
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
