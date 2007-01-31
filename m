Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXAaU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXAaU4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030575AbXAaU4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:56:23 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41565 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030510AbXAaU4W (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:56:22 -0500
Message-Id: <200701312054.l0VKstxg020891@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: wsl3@lrsehosting.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, alan@redhat.com,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Unidentified Intel wifi network card
In-Reply-To: Your message of "Wed, 31 Jan 2007 11:30:23 CST."
             <1170264624.5569.15.camel@scott-640m>
From: Valdis.Kletnieks@vt.edu
References: <1170264624.5569.15.camel@scott-640m>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170276895_19655P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Jan 2007 15:54:55 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170276895_19655P
Content-Type: multipart/mixed ;
	boundary="==_Exmh_1170275546_196550"

This is a multipart MIME message.

--==_Exmh_1170275546_196550
Content-Type: text/plain; charset=us-ascii

(Adding Adrian Bunk and Herbert Xu to the cc: list)

On Wed, 31 Jan 2007 11:30:23 CST, Scott Lockwood said:
> I'm looking for assistance with a wifi device I can't find a driver for,
> the Intel Wireless 3945.
> 
> I"m getting this:
> 
> 0000:0c:00.0 Network controller: Intel Corporation: Unknown device 4222
> (rev 02)
> 
> on a new Dell Latitude D820. Anyone know if there will be an open source
> driver for this any time soon, or if there is one now?

http://ipw3945.sourceforge.net has almost everything you could possibly need.

Only gotcha I know of:  Sometimes one of the ipw3945d kernel threads will
hang in a loop if the RFKill switch is set to "kill" when the system comes
up.  I also don't know how it handles suspend, I don't use that on my D820.

I also needed to make 2 patches (attached) to make it work under recent -mm kernels,
with them I'm able to use it on 20-rc6-mm3.

Oh - the git-crypto-fix patch has to be applied with -R, I never got around to
re-diffing it the other way.

(Yes, I really should fix up these 2 and push them upstream to the ipw3945 crew.
That's on this week's to-do list...)

--==_Exmh_1170275546_196550
Content-Type: text/plain ; name="fix1"; charset=us-ascii
Content-Description: fix1
Content-Disposition: attachment; filename="fix1"

--- linux-2.6.20-rc6-mm1/drivers/net/wireless/ipw3945.c.dist	2007-01-27 20:21:42.000000000 -0500
+++ linux-2.6.20-rc6-mm1/drivers/net/wireless/ipw3945.c	2007-01-27 20:22:21.000000000 -0500
@@ -16554,7 +16554,7 @@ static int ipw_pci_probe(struct pci_dev 
 	/* If power management is turned on, default to AC mode */
 	priv->power_mode = IPW_POWER_AC;
 	priv->actual_txpower_limit = IPW_DEFAULT_TX_POWER;
-	err = request_irq(pdev->irq, ipw_isr, SA_SHIRQ, DRV_NAME, priv);
+	err = request_irq(pdev->irq, ipw_isr, IRQF_SHARED, DRV_NAME, priv);
 	if (err) {
 		IPW_ERROR("Error allocating IRQ %d\n", pdev->irq);
 		goto out_release_ucode;

--==_Exmh_1170275546_196550
Content-Type: application/x-patch ; name="crypto-fix.patch"
Content-Description: crypto-fix.patch
Content-Disposition: attachment; filename="crypto-fix.patch"

GIT 13c49e85b6c43df0285ecccc2cef1f56f8706ede git+ssh://master.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

commit 
Author: Adrian Bunk <bunk@stusta.de>
Date:   Wed Nov 22 17:55:00 2006 +1100

    [CRYPTO] api: Remove unused functions
    
    This patch removes the following no longer used functions:
    - api.c: crypto_alg_available()
    - digest.c: crypto_digest_init()
    - digest.c: crypto_digest_update()
    - digest.c: crypto_digest_final()
    - digest.c: crypto_digest_digest()
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/digest.c b/crypto/digest.c
index 0155a94..8f45932 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -21,54 +21,6 @@ #include <linux/scatterlist.h>
 #include "internal.h"
 #include "scatterwalk.h"
 
-void crypto_digest_init(struct crypto_tfm *tfm)
-{
-	struct crypto_hash *hash = crypto_hash_cast(tfm);
-	struct hash_desc desc = { .tfm = hash, .flags = tfm->crt_flags };
-
-	crypto_hash_init(&desc);
-}
-EXPORT_SYMBOL_GPL(crypto_digest_init);
-
-void crypto_digest_update(struct crypto_tfm *tfm,
-			  struct scatterlist *sg, unsigned int nsg)
-{
-	struct crypto_hash *hash = crypto_hash_cast(tfm);
-	struct hash_desc desc = { .tfm = hash, .flags = tfm->crt_flags };
-	unsigned int nbytes = 0;
-	unsigned int i;
-
-	for (i = 0; i < nsg; i++)
-		nbytes += sg[i].length;
-
-	crypto_hash_update(&desc, sg, nbytes);
-}
-EXPORT_SYMBOL_GPL(crypto_digest_update);
-
-void crypto_digest_final(struct crypto_tfm *tfm, u8 *out)
-{
-	struct crypto_hash *hash = crypto_hash_cast(tfm);
-	struct hash_desc desc = { .tfm = hash, .flags = tfm->crt_flags };
-
-	crypto_hash_final(&desc, out);
-}
-EXPORT_SYMBOL_GPL(crypto_digest_final);
-
-void crypto_digest_digest(struct crypto_tfm *tfm,
-			  struct scatterlist *sg, unsigned int nsg, u8 *out)
-{
-	struct crypto_hash *hash = crypto_hash_cast(tfm);
-	struct hash_desc desc = { .tfm = hash, .flags = tfm->crt_flags };
-	unsigned int nbytes = 0;
-	unsigned int i;
-
-	for (i = 0; i < nsg; i++)
-		nbytes += sg[i].length;
-
-	crypto_hash_digest(&desc, sg, nbytes, out);
-}
-EXPORT_SYMBOL_GPL(crypto_digest_digest);
-
 static int init(struct hash_desc *desc)
 {
 	struct crypto_tfm *tfm = crypto_hash_tfm(desc->tfm);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 6485e97..4aa9046 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -218,10 +218,8 @@ int crypto_unregister_alg(struct crypto_
  * Algorithm query interface.
  */
 #ifdef CONFIG_CRYPTO
-int crypto_alg_available(const char *name, u32 flags) __deprecated_for_modules;
 int crypto_has_alg(const char *name, u32 type, u32 mask);
 #else
-static int crypto_alg_available(const char *name, u32 flags) __deprecated_for_modules;
 static inline int crypto_has_alg(const char *name, u32 type, u32 mask)
 {
 	return 0;
@@ -707,16 +703,6 @@ static inline void crypto_cipher_decrypt
 						dst, src);
 }
 
-void crypto_digest_init(struct crypto_tfm *tfm) __deprecated_for_modules;
-void crypto_digest_update(struct crypto_tfm *tfm,
-			  struct scatterlist *sg, unsigned int nsg)
-	__deprecated_for_modules;
-void crypto_digest_final(struct crypto_tfm *tfm, u8 *out)
-	__deprecated_for_modules;
-void crypto_digest_digest(struct crypto_tfm *tfm,
-			  struct scatterlist *sg, unsigned int nsg, u8 *out)
-	__deprecated_for_modules;
-
 static inline struct crypto_hash *__crypto_hash_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_hash *)tfm;
@@ -729,14 +715,6 @@ static inline struct crypto_hash *crypto
 	return __crypto_hash_cast(tfm);
 }
 
-static int crypto_digest_setkey(struct crypto_tfm *tfm, const u8 *key,
-				unsigned int keylen) __deprecated;
-static inline int crypto_digest_setkey(struct crypto_tfm *tfm,
-                                       const u8 *key, unsigned int keylen)
-{
-	return tfm->crt_hash.setkey(crypto_hash_cast(tfm), key, keylen);
-}
-
 static inline struct crypto_hash *crypto_alloc_hash(const char *alg_name,
 						    u32 type, u32 mask)
 {

--==_Exmh_1170275546_196550--


--==_Exmh_1170276895_19655P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFwQIfcC3lWbTT17ARAr/5AJ94ml0L68P2Izy5xvJ0a8t4Ppa3pQCfXJUo
6cVXOZPjpgrghN8uP956CZ4=
=ALQ2
-----END PGP SIGNATURE-----

--==_Exmh_1170276895_19655P--
