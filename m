Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYGHHLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYGHHLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYGHHLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:11:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:63912 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYGHHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=pJjdJfi0m7DwWAWOHCWQdJF9I0JlHIfJNInAmZLRGs9+6lc7hmcYtpHrfcm8r50fJI
         IZkWS4vg00Q/9ViI5nVg+xMzXa6GiggO0IU6j6c9fQlEhDuJzXJVGc3sfPLPx6dN+3pD
         AHfhOdKBwObyE7am7K0KQxM3mE64oh0WSwcbE=
Subject: [PATCH] crypto/tcrypt.c fix resource leak
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
       davem@davemloft.net, linux-crypto@vger.kernel.org,
       jmorris@intercode.com.au, jef@linuxbe.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Jul 2008 05:24:14 +1000
Message-Id: <1215458654.8316.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

G'day people,

Coverity CID: 2306 & 2307 RESOURCE_LEAK

In the second for loop in test_cipher(), data is allocated space with
kzalloc() and is only ever freed in an error case.
Looking at this loop, data is written to this memory but nothing seems
to read from it. 
So here is a patch removing the allocation, I think this is the right
fix.

Only compile tested.

﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6beabc5..e47f6e0 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -586,12 +586,6 @@ static void test_cipher(char *algo, int enc,
 	j = 0;
 	for (i = 0; i < tcount; i++) {
 
-		data = kzalloc(template[i].ilen, GFP_KERNEL);
-		if (!data)
-			continue;
-
-		memcpy(data, template[i].input, template[i].ilen);
-
 		if (template[i].iv)
 			memcpy(iv, template[i].iv, MAX_IVLEN);
 		else
@@ -613,10 +607,8 @@ static void test_cipher(char *algo, int enc,
 				printk("setkey() failed flags=%x\n",
 						crypto_ablkcipher_get_flags(tfm));
 
-				if (!template[i].fail) {
-					kfree(data);
+				if (!template[i].fail)
 					goto out;
-				}
 			}
 
 			temp = 0;


