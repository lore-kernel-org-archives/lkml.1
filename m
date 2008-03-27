Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYC0INE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYC0INE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbYC0IMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:12:33 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:39247 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbYC0IM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:12:28 -0400
Date: Thu, 27 Mar 2008 13:42:21 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@ozlabs.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] init()/fini() clean up in the crypto
Message-ID: <20080327081221.GA17717@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20080327035249.6F774DDF4D@ozlabs.org> <20080326210038.e54b6180.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326210038.e54b6180.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 09:00:38PM -0700, Andrew Morton wrote:
> On Thu, 27 Mar 2008 14:52:15 +1100 Benjamin Herrenschmidt <benh@ozlabs.org> wrote:
> 
> > The futex init function is called init(). This is a pain in the neck
> > when debugging when you code dies in ... init :-)
> > 
> > This renames it to futex_init().
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > ---
> > 
> >  kernel/futex.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux-work.orig/kernel/futex.c	2008-03-27 14:50:11.000000000 +1100
> > +++ linux-work/kernel/futex.c	2008-03-27 14:50:20.000000000 +1100
> > @@ -2158,7 +2158,7 @@ static struct file_system_type futex_fs_
> >  	.kill_sb	= kill_anon_super,
> >  };
> >  
> > -static int __init init(void)
> > +static int __init futex_init(void)
> >  {
> >  	u32 curval;
> >  	int i;
> > @@ -2194,4 +2194,4 @@ static int __init init(void)
> >  
> >  	return 0;
> >  }
> > -__initcall(init);
> > +__initcall(futex_init);
> 
> heh, I seem to remember doing about fifty of these in netfilter code a
> while back.
> 
> You have a way to go - there are thirty-odd just in the crypto code.
> 
This patch cleanups the crypto code, replaces the init() and fini()  with the 
<algorithm name>_init/_fini or init/fini_<algorithm name> (if the
<algorithm name>_init/_fini exist) 

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
diff --git a/crypto/anubis.c b/crypto/anubis.c
index 4ff0e1e..44c30f9 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -687,7 +687,7 @@ static struct crypto_alg anubis_alg = {
 	.cia_decrypt		=	anubis_decrypt } }
 };
 
-static int __init init(void)
+static int __init anubis_init(void)
 {
 	int ret = 0;
 	
@@ -695,13 +695,13 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit anubis_fini(void)
 {
 	crypto_unregister_alg(&anubis_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(anubis_init);
+module_exit(anubis_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Anubis Cryptographic Algorithm");
diff --git a/crypto/blowfish.c b/crypto/blowfish.c
index 80c3fd8..360cd1b 100644
--- a/crypto/blowfish.c
+++ b/crypto/blowfish.c
@@ -465,18 +465,18 @@ static struct crypto_alg alg = {
 	.cia_decrypt  		=	bf_decrypt } }
 };
 
-static int __init init(void)
+static int __init blowfish_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit blowfish_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(blowfish_init);
+module_exit(blowfish_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Blowfish Cipher Algorithm");
diff --git a/crypto/cast5.c b/crypto/cast5.c
index 13ea60a..7e93e15 100644
--- a/crypto/cast5.c
+++ b/crypto/cast5.c
@@ -817,18 +817,18 @@ static struct crypto_alg alg = {
 	}
 };
 
-static int __init init(void)
+static int __init cast5_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit cast5_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(cast5_init);
+module_exit(cast5_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cast5 Cipher Algorithm");
diff --git a/crypto/cast6.c b/crypto/cast6.c
index 5fd9420..85ec9b4 100644
--- a/crypto/cast6.c
+++ b/crypto/cast6.c
@@ -528,18 +528,18 @@ static struct crypto_alg alg = {
 		  }
 };
 
-static int __init init(void)
+static int __init cast6_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit cast6_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(cast6_init);
+module_exit(cast6_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cast6 Cipher Algorithm");
diff --git a/crypto/crc32c.c b/crypto/crc32c.c
index 0fa7443..32a561d 100644
--- a/crypto/crc32c.c
+++ b/crypto/crc32c.c
@@ -98,18 +98,18 @@ static struct crypto_alg alg = {
 	}
 };
 
-static int __init init(void)
+static int __init crc32c_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit crc32c_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(crc32c_init);
+module_exit(crc32c_fini);
 
 MODULE_AUTHOR("Clay Haapala <chaapala@cisco.com>");
 MODULE_DESCRIPTION("CRC32c (Castagnoli) calculations wrapper for lib/crc32c");
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index ff7b3de..805b7ad 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -142,7 +142,7 @@ MODULE_ALIAS("compress_null");
 MODULE_ALIAS("digest_null");
 MODULE_ALIAS("cipher_null");
 
-static int __init init(void)
+static int __init crypto_null_init(void)
 {
 	int ret = 0;
 	
@@ -174,7 +174,7 @@ out_unregister_cipher:
 	goto out;
 }
 
-static void __exit fini(void)
+static void __exit crypto_null_fini(void)
 {
 	crypto_unregister_alg(&compress_null);
 	crypto_unregister_alg(&digest_null);
@@ -182,8 +182,8 @@ static void __exit fini(void)
 	crypto_unregister_alg(&cipher_null);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(crypto_null_init);
+module_exit(crypto_null_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Null Cryptographic Algorithms");
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 6588bbf..45c853e 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -208,18 +208,18 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
-static int __init init(void)
+static int __init init_deflate(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit fini_deflate(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(init_deflate);
+module_exit(fini_deflate);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Deflate Compression Algorithm for IPCOMP");
diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 355ecb7..cafe038 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -977,7 +977,7 @@ static struct crypto_alg des3_ede_alg = {
 
 MODULE_ALIAS("des3_ede");
 
-static int __init init(void)
+static int __init des_generic_init(void)
 {
 	int ret = 0;
 
@@ -992,14 +992,14 @@ out:
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit des_generic_fini(void)
 {
 	crypto_unregister_alg(&des3_ede_alg);
 	crypto_unregister_alg(&des_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(des_generic_init);
+module_exit(des_generic_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("DES & Triple DES EDE Cipher Algorithms");
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index a32cb68..81ae48e 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -405,18 +405,18 @@ static struct crypto_alg fcrypt_alg = {
 	.cia_decrypt		=	fcrypt_decrypt } }
 };
 
-static int __init init(void)
+static int __init fcrypt_init(void)
 {
 	return crypto_register_alg(&fcrypt_alg);
 }
 
-static void __exit fini(void)
+static void __exit fcrypt_fini(void)
 {
 	crypto_unregister_alg(&fcrypt_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(fcrypt_init);
+module_exit(fcrypt_fini);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FCrypt Cipher Algorithm");
diff --git a/crypto/khazad.c b/crypto/khazad.c
index 704ebfe..c1fe09c 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -862,7 +862,7 @@ static struct crypto_alg khazad_alg = {
 	.cia_decrypt		=	khazad_decrypt } }
 };
 
-static int __init init(void)
+static int __init khazad_init(void)
 {
 	int ret = 0;
 	
@@ -870,14 +870,14 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit khazad_fini(void)
 {
 	crypto_unregister_alg(&khazad_alg);
 }
 
 
-module_init(init);
-module_exit(fini);
+module_init(khazad_init);
+module_exit(khazad_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Khazad Cryptographic Algorithm");
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 48c3288..5f2784a 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -89,18 +89,18 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= lzo_decompress } }
 };
 
-static int __init init(void)
+static int __init init_lzo(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit fini_lzo(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(init_lzo);
+module_exit(fini_lzo);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("LZO Compression Algorithm");
diff --git a/crypto/md4.c b/crypto/md4.c
index c1bc71b..6e710f5 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -233,18 +233,18 @@ static struct crypto_alg alg = {
 	.dia_final  	=	md4_final } }
 };
 
-static int __init init(void)
+static int __init init_md4(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit fini_md4(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(init_md4);
+module_exit(fini_md4);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD4 Message Digest Algorithm");
diff --git a/crypto/md5.c b/crypto/md5.c
index 93d18e8..28d2426 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -228,18 +228,18 @@ static struct crypto_alg alg = {
 	.dia_final  	=	md5_final } }
 };
 
-static int __init init(void)
+static int __init init_md5(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit fini_md5(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(init_md5);
+module_exit(fini_md5);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD5 Message Digest Algorithm");
diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 1fa4e4d..56c8285 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -237,18 +237,18 @@ static struct crypto_alg alg = {
 	}
 };
 
-static int __init init(void)
+static int __init salsa20_generic_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit salsa20_generic_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(salsa20_generic_init);
+module_exit(salsa20_generic_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Salsa20 stream cipher algorithm");
diff --git a/crypto/serpent.c b/crypto/serpent.c
index 2b0a19a..d190c5f 100644
--- a/crypto/serpent.c
+++ b/crypto/serpent.c
@@ -557,7 +557,7 @@ static struct crypto_alg tnepres_alg = {
 	.cia_decrypt  		=	tnepres_decrypt } }
 };
 
-static int __init init(void)
+static int __init serpent_init(void)
 {
 	int ret = crypto_register_alg(&serpent_alg);
 
@@ -572,14 +572,14 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit serpent_fini(void)
 {
 	crypto_unregister_alg(&tnepres_alg);
 	crypto_unregister_alg(&serpent_alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(serpent_init);
+module_exit(serpent_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Serpent and tnepres (kerneli compatible serpent reversed) Cipher Algorithm");
diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 68c62f5..2363b42 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -120,18 +120,18 @@ static struct crypto_alg alg = {
 	.dia_final  	=	sha1_final } }
 };
 
-static int __init init(void)
+static int __init sha1_generic_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit sha1_generic_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(sha1_generic_init);
+module_exit(sha1_generic_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm");
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 3cc93fd..658ba2e 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -353,7 +353,7 @@ static struct crypto_alg sha224 = {
 	.dia_final	= sha224_final } }
 };
 
-static int __init init(void)
+static int __init sha256_generic_init(void)
 {
 	int ret = 0;
 
@@ -370,14 +370,14 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit sha256_generic_fini(void)
 {
 	crypto_unregister_alg(&sha224);
 	crypto_unregister_alg(&sha256);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(sha256_generic_init);
+module_exit(sha256_generic_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-224 and SHA-256 Secure Hash Algorithm");
diff --git a/crypto/sha512.c b/crypto/sha512.c
index c39c803..4261fe7 100644
--- a/crypto/sha512.c
+++ b/crypto/sha512.c
@@ -280,7 +280,7 @@ static struct crypto_alg sha384 = {
 
 MODULE_ALIAS("sha384");
 
-static int __init init(void)
+static int __init init_sha512(void)
 {
         int ret = 0;
 
@@ -292,14 +292,14 @@ out:
         return ret;
 }
 
-static void __exit fini(void)
+static void __exit fini_sha512(void)
 {
         crypto_unregister_alg(&sha384);
         crypto_unregister_alg(&sha512);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(init_sha512);
+module_exit(fini_sha512);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-512 and SHA-384 Secure Hash Algorithms");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1ab8c01..15f8d39 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1775,7 +1775,7 @@ static void do_test(void)
 	}
 }
 
-static int __init init(void)
+static int __init tcrypt_init(void)
 {
 	int err = -ENOMEM;
 
@@ -1814,10 +1814,10 @@ static int __init init(void)
  * If an init function is provided, an exit function must also be provided
  * to allow module unload.
  */
-static void __exit fini(void) { }
+static void __exit tcrypt_fini(void) { }
 
-module_init(init);
-module_exit(fini);
+module_init(tcrypt_init);
+module_exit(tcrypt_fini);
 
 module_param(mode, int, 0);
 module_param(sec, uint, 0);
diff --git a/crypto/tea.c b/crypto/tea.c
index 6893b3f..a56c6a4 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -267,7 +267,7 @@ static struct crypto_alg xeta_alg = {
 	.cia_decrypt		=	xeta_decrypt } }
 };
 
-static int __init init(void)
+static int __init tea_init(void)
 {
 	int ret = 0;
 	
@@ -292,7 +292,7 @@ out:
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit tea_fini(void)
 {
 	crypto_unregister_alg(&tea_alg);
 	crypto_unregister_alg(&xtea_alg);
@@ -302,8 +302,8 @@ static void __exit fini(void)
 MODULE_ALIAS("xtea");
 MODULE_ALIAS("xeta");
 
-module_init(init);
-module_exit(fini);
+module_init(tea_init);
+module_exit(tea_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TEA, XTEA & XETA Cryptographic Algorithms");
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 2e7ea16..977e35f 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -663,7 +663,7 @@ static struct crypto_alg tgr128 = {
 			     .dia_final = tgr128_final}}
 };
 
-static int __init init(void)
+static int __init init_tgr192(void)
 {
 	int ret = 0;
 
@@ -688,7 +688,7 @@ static int __init init(void)
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit fini_tgr192(void)
 {
 	crypto_unregister_alg(&tgr192);
 	crypto_unregister_alg(&tgr160);
@@ -698,8 +698,8 @@ static void __exit fini(void)
 MODULE_ALIAS("tgr160");
 MODULE_ALIAS("tgr128");
 
-module_init(init);
-module_exit(fini);
+module_init(init_tgr192);
+module_exit(fini_tgr192);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Tiger Message Digest Algorithm");
diff --git a/crypto/twofish.c b/crypto/twofish.c
index 4979a2b..1e9ac82 100644
--- a/crypto/twofish.c
+++ b/crypto/twofish.c
@@ -197,18 +197,18 @@ static struct crypto_alg alg = {
 	.cia_decrypt        =   twofish_decrypt } }
 };
 
-static int __init init(void)
+static int __init twofish_init(void)
 {
 	return crypto_register_alg(&alg);
 }
 
-static void __exit fini(void)
+static void __exit twofish_fini(void)
 {
 	crypto_unregister_alg(&alg);
 }
 
-module_init(init);
-module_exit(fini);
+module_init(twofish_init);
+module_exit(twofish_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION ("Twofish Cipher Algorithm");
diff --git a/crypto/wp512.c b/crypto/wp512.c
index f746952..1e2ca24 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1146,7 +1146,7 @@ static struct crypto_alg wp256 = {
 	.dia_final  	=	wp256_final } }
 };
 
-static int __init init(void)
+static int __init init_wp512(void)
 {
 	int ret = 0;
 
@@ -1172,7 +1172,7 @@ out:
 	return ret;
 }
 
-static void __exit fini(void)
+static void __exit fini_wp512(void)
 {
 	crypto_unregister_alg(&wp512);
 	crypto_unregister_alg(&wp384);
@@ -1182,8 +1182,8 @@ static void __exit fini(void)
 MODULE_ALIAS("wp384");
 MODULE_ALIAS("wp256");
 
-module_init(init);
-module_exit(fini);
+module_init(init_wp512);
+module_exit(fini_wp512);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Whirlpool Message Digest Algorithm");
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
