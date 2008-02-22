Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbYBVMet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbYBVMet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbYBVMel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:34:41 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:55421 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756759AbYBVMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:34:40 -0500
Date: Fri, 22 Feb 2008 20:34:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <mbroz@redhat.com>
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Message-ID: <20080222123423.GA12678@gondor.apana.org.au>
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com> <47BC0DA9.1030607@redhat.com> <20080220172449.GD27726@gondor.apana.org.au> <47BC67CE.9070407@redhat.com> <20080220175819.GA28246@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220175819.GA28246@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 01:58:19AM +0800, Herbert Xu wrote:
> On Wed, Feb 20, 2008 at 06:47:58PM +0100, Milan Broz wrote:
> >
> > I just tested one affected configuration and problem was in missing
> > "chainiv.ko" module on ramdisk.
> 
> Ah OK.  We probably should merge chainiv into the blkcipher
> module too since it's the default IV generator.  I'll take
> care of it.

Does this patch fix the problem?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/Makefile b/crypto/Makefile
index 48c7583..7cf3625 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -12,9 +12,9 @@ obj-$(CONFIG_CRYPTO_AEAD) += aead.o
 
 crypto_blkcipher-objs := ablkcipher.o
 crypto_blkcipher-objs += blkcipher.o
+crypto_blkcipher-objs += chainiv.o
+crypto_blkcipher-objs += eseqiv.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER) += crypto_blkcipher.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER) += chainiv.o
-obj-$(CONFIG_CRYPTO_BLKCIPHER) += eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
 crypto_hash-objs := hash.o
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 3bcb099..94140b3 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -341,6 +341,3 @@ err:
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_ablkcipher);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Asynchronous block chaining cipher type");
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 4a7e65c..185f955 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -696,5 +696,34 @@ void skcipher_geniv_exit(struct crypto_tfm *tfm)
 }
 EXPORT_SYMBOL_GPL(skcipher_geniv_exit);
 
+static int __init blkcipher_module_init(void)
+{
+	int err;
+
+	err = chainiv_module_init();
+	if (err)
+		goto out;
+
+	err = eseqiv_module_init();
+	if (err)
+		goto eseqiv_err;
+
+out:
+	return err;
+
+eseqiv_err:
+	chainiv_module_exit();
+	goto out;
+}
+
+static void __exit blkcipher_module_exit(void)
+{
+	eseqiv_module_exit();
+	chainiv_module_exit();
+}
+
+module_init(blkcipher_module_init);
+module_exit(blkcipher_module_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Generic block chaining cipher type");
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index d17fa04..0a7cac6 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -314,18 +314,14 @@ static struct crypto_template chainiv_tmpl = {
 	.module = THIS_MODULE,
 };
 
-static int __init chainiv_module_init(void)
+int __init chainiv_module_init(void)
 {
 	return crypto_register_template(&chainiv_tmpl);
 }
+EXPORT_SYMBOL_GPL(chainiv_module_init);
 
-static void __exit chainiv_module_exit(void)
+void __exit chainiv_module_exit(void)
 {
 	crypto_unregister_template(&chainiv_tmpl);
 }
-
-module_init(chainiv_module_init);
-module_exit(chainiv_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Chain IV Generator");
+EXPORT_SYMBOL_GPL(chainiv_module_exit);
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index eb90d27..6f2cd06 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -247,18 +247,14 @@ static struct crypto_template eseqiv_tmpl = {
 	.module = THIS_MODULE,
 };
 
-static int __init eseqiv_module_init(void)
+int __init eseqiv_module_init(void)
 {
 	return crypto_register_template(&eseqiv_tmpl);
 }
+EXPORT_SYMBOL_GPL(eseqiv_module_init);
 
-static void __exit eseqiv_module_exit(void)
+void __exit eseqiv_module_exit(void)
 {
 	crypto_unregister_template(&eseqiv_tmpl);
 }
-
-module_init(eseqiv_module_init);
-module_exit(eseqiv_module_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Encrypted Sequence Number IV Generator");
+EXPORT_SYMBOL_GPL(eseqiv_module_exit);
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 2ba42cd..a8f1264 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -15,6 +15,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
+#include <linux/init.h>
 #include <linux/types.h>
 
 struct rtattr;
@@ -64,6 +65,11 @@ void skcipher_geniv_free(struct crypto_instance *inst);
 int skcipher_geniv_init(struct crypto_tfm *tfm);
 void skcipher_geniv_exit(struct crypto_tfm *tfm);
 
+int __init eseqiv_module_init(void);
+void __exit eseqiv_module_exit(void);
+int __init chainiv_module_init(void);
+void __exit chainiv_module_exit(void);
+
 static inline struct crypto_ablkcipher *skcipher_geniv_cipher(
 	struct crypto_ablkcipher *geniv)
 {
