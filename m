Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbZIRW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbZIRW4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 18:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbZIRW4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 18:56:40 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:46932 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZIRW4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 18:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=loBSrN6Oj8U3kNpLoWt0FJT+G+MNpibrpkl2pqd1GlOc2ZJIzBtUSlTmjXaXm1NwsV
         dQNoQcTFsra2p5XRjZjeL8/vjRchA6V0HuZFCSCc/sUZYB7bWvr+ez+kyb6foB7u+kVe
         lkfinfxX8hFzr2wsMYQ7Z65i8oPgAhazD3/Ww=
Message-ID: <4AB411D9.6070702@gmail.com>
Date: Sat, 19 Sep 2009 01:03:53 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] random: kmalloc failure ignored in init_std_data()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up and error out if kmalloc() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found with sed: http://kernelnewbies.org/roelkluin

Build tested. Please review

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d8a9255..8a68be8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -939,7 +939,7 @@ EXPORT_SYMBOL(get_random_bytes);
  * data into the pool to prepare it for use. The pool is not cleared
  * as that can only decrease the entropy in the pool.
  */
-static void init_std_data(struct entropy_store *r)
+static int init_std_data(struct entropy_store *r)
 {
 	ktime_t now;
 	unsigned long flags;
@@ -952,16 +952,35 @@ static void init_std_data(struct entropy_store *r)
 	mix_pool_bytes(r, &now, sizeof(now));
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 	/* Enable continuous test in fips mode */
-	if (fips_enabled)
+	if (fips_enabled) {
 		r->last_data = kmalloc(EXTRACT_SIZE, GFP_KERNEL);
+		if (r->last_data == NULL)
+			return -ENOMEM;
+	}
+	return 0;
 }
 
 static int rand_initialize(void)
 {
-	init_std_data(&input_pool);
-	init_std_data(&blocking_pool);
-	init_std_data(&nonblocking_pool);
+	int ret;
+	ret = init_std_data(&input_pool);
+	if (ret != 0)
+		return ret;
+
+	ret = init_std_data(&blocking_pool);
+	if (ret != 0)
+		goto free_ip_ld;
+
+	ret = init_std_data(&nonblocking_pool);
+	if (ret != 0)
+		goto free_bp_ld;
+
 	return 0;
+free_bp_ld:
+	kfree(blocking_pool.last_data);
+free_ip_ld:
+	kfree(input_pool.last_data);
+	return ret;
 }
 module_init(rand_initialize);
 
@@ -1160,8 +1179,8 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		/* Clear the entropy pool counters. */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		rand_initialize();
-		return 0;
+		retval = rand_initialize();
+		return retval;
 	default:
 		return -EINVAL;
 	}
