Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZISAq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZISAq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 20:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZISAqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 20:46:52 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:59394 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZISAqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 20:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FzUWv8xu0PwpxQDzuz5+CjcpQ/HXlC6b37p0fpmYacMW197+dshgvWFwrghqjY2Ssa
         3Ul0VyS+u6u72UDwnjx//LBtGYhx4XeVEpRodYgOWkpfimvIFePE5l05IlwMuARky/Dm
         20vraTV5HK2SecgUeuPb/h3RoJuTMDDgz2Va4=
Message-ID: <4AB42BAF.90204@gmail.com>
Date: Sat, 19 Sep 2009 02:54:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: kmalloc failure ignored in init_std_data()
References: <4AB411D9.6070702@gmail.com> <1253319020.3364.180.camel@calx>
In-Reply-To: <1253319020.3364.180.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc may fail so build the array into the statically allocated
pool structures instead.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this what you had in mind? (it builds)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d8a9255..9012540 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -400,6 +400,8 @@ module_param(debug, bool, 0644);
  *
  **********************************************************************/
 
+#define EXTRACT_SIZE 10
+
 struct entropy_store;
 struct entropy_store {
 	/* read-only data: */
@@ -414,7 +416,9 @@ struct entropy_store {
 	unsigned add_ptr;
 	int entropy_count;
 	int input_rotate;
-	__u8 *last_data;
+#ifdef CONFIG_CRYPTO_FIPS
+	__u8 last_data[EXTRACT_SIZE];
+#endif
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -714,8 +718,6 @@ void add_disk_randomness(struct gendisk *disk)
 }
 #endif
 
-#define EXTRACT_SIZE 10
-
 /*********************************************************************
  *
  * Entropy extraction routines
@@ -951,9 +953,6 @@ static void init_std_data(struct entropy_store *r)
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
-	/* Enable continuous test in fips mode */
-	if (fips_enabled)
-		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
 }
 
 static int rand_initialize(void)
