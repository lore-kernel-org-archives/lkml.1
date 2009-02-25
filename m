Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZBYOZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZBYOZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZBYOYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:24:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:34710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZBYOYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:24:49 -0500
Message-ID: <49A5549F.4070304@suse.de>
Date: Wed, 25 Feb 2009 15:24:31 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       akpm@linux-foundation.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com,
       Frank Seidel <frank@f-seidel.de>
Subject: [PATCHv2][trivial] crypto: tcrypt - reduce stack size
References: <49A54C23.8090209@suse.de>
In-Reply-To: <49A54C23.8090209@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Applying kernel janitors todos (printk calls need KERN_*
constants on linebeginnings, reduce stack footprint where
possible) to tcrypts test_hash_speed (where stacks
memory footprint was very high (on i386 1184 bytes to
164 now).

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 crypto/tcrypt.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -396,27 +396,34 @@ static void test_hash_speed(const char *
 	struct scatterlist sg[TVMEMSIZE];
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
-	char output[1024];
+	char *output;
+	size_t output_size = 1024;
 	int i;
 	int ret;
 
-	printk("\ntesting speed of %s\n", algo);
+	printk(KERN_INFO "\ntesting speed of %s\n", algo);
+
+	output = kmalloc(output_size * sizeof(*output), GFP_KERNEL);
+	if (!output) {
+		printk(KERN_ERR "tcrypt: failed to allocate outputbuffer\n");
+		return;
+	}
 
 	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
-		printk("failed to load transform for %s: %ld\n", algo,
+		printk(KERN_ERR "failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
-		return;
+		goto out;
 	}
 
 	desc.tfm = tfm;
 	desc.flags = 0;
 
-	if (crypto_hash_digestsize(tfm) > sizeof(output)) {
-		printk("digestsize(%u) > outputbuffer(%zu)\n",
-		       crypto_hash_digestsize(tfm), sizeof(output));
-		goto out;
+	if (crypto_hash_digestsize(tfm) > output_size) {
+		printk(KERN_ERR "digestsize(%u) > outputbuffer(%zu)\n",
+		       crypto_hash_digestsize(tfm), output_size);
+		goto out_free_tfm;
 	}
 
 	sg_init_table(sg, TVMEMSIZE);
@@ -427,12 +434,14 @@ static void test_hash_speed(const char *
 
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			printk("template (%u) too big for tvmem (%lu)\n",
+			printk(KERN_ERR
+			       "template (%u) too big for tvmem (%lu)\n",
 			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
-			goto out;
+			goto out_free_tfm;
 		}
 
-		printk("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		printk(KERN_INFO "test%3u "
+		       "(%5u byte blocks,%5u bytes per update,%4u updates): ",
 		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
 
 		if (sec)
@@ -443,13 +452,15 @@ static void test_hash_speed(const char *
 					       speed[i].plen, output);
 
 		if (ret) {
-			printk("hashing failed ret=%d\n", ret);
+			printk(KERN_ERR "hashing failed ret=%d\n", ret);
 			break;
 		}
 	}
 
-out:
+out_free_tfm:
 	crypto_free_hash(tfm);
+out:
+	kfree(output);
 }
 
 static void test_available(void)

