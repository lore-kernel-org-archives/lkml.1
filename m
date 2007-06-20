Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXFTPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXFTPe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 11:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXFTPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 11:34:20 -0400
Received: from gateway-a.fh-trier.de ([143.93.54.181]:41109 "EHLO
	gateway-a.fh-trier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXFTPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 11:34:19 -0400
Message-ID: <467948F5.3010709@gentoo.org>
Date: Wed, 20 Jun 2007 17:34:13 +0200
From: Alexander Gabert <pappy@gentoo.org>
Organization: Hardened Gentoo Linux
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       linux-kernel@vger.kernel.org, hardened@gentoo.org
CC: torvalds@linux-foundation.org
Subject: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
References: <4675C678.3080807@gentoo.org>	 <1182128803.22999.9.camel@laptopd505.fenrus.org>	 <4675DFA8.6060703@gentoo.org> <1182130680.22999.13.camel@laptopd505.fenrus.org> <4676601A.7070209@gentoo.org>
In-Reply-To: <4676601A.7070209@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

http://dev.gentoo.org/~pappy/kernel/linux-2.6.21.5-get_urandom_long-AT_ENTROPY.patch

this patch adds the function drivers/char/random.c:get_random_long()
and adds an AT_ENTROPY field in the auxv without config option
(the config option was removed as suggested by Arjan on LKML).

README: get_random_long() and AT_ENTROPY support for auxv
NAME: Alexander Gabert
EMAIL: pappy@gentoo.org



diff -Nru linux-2.6.21.5.ORIG/drivers/char/random.c 
linux-2.6.21.5/drivers/char/random.c
--- linux-2.6.21.5.ORIG/drivers/char/random.c    2007-06-11 
20:37:06.000000000 +0200
+++ linux-2.6.21.5/drivers/char/random.c    2007-06-20 
17:00:35.000000000 +0200
@@ -1654,6 +1654,53 @@
 }
 
 /*
+ * get_random_long() returns a randomized unsigned long word.
+ * It recycles it's entropy cache for a given time period and
+ * uses half_md4_transform to generate a unique return value.
+ * Every REKEY_INTERVAL the cache is reloaded with fresh
+ * randomization data using get_random_bytes().
+ * This function is not intended for strong cryptographic routines.
+ */
+unsigned long get_random_long(void)
+{
+  /* remember the last time we refreshed the cache with random entropy */
+  static time_t   rekey_time;
+
+  time_t          t;
+
+  /*
+   * the following data in the buffer is unchanged during REKEY_INTERVAL:
+   * |----|----|KKKK|KKKK|KKKK|KKKK|KKKK|KKKK|----|----|----|----|
+   * ___0____1____2____3____4____5____6____7____8____9___10___11__
+   *
+   * the following data is updated during the first half_md4_transform call
+   * |----|YYYY|----|----|----|----|----|----|ZZZZ|ZZZZ|ZZZZ|ZZZZ|
+   * ___0____1____2____3____4____5____6____7____8____9___10___11__
+   *
+   * the following data is updated during the second half_md4_transform
+   * |XXXX|----|----|----|----|----|----|----|ZZZZ|ZZZZ|ZZZZ|ZZZZ|
+   * ___0____1____2____3____4____5____6____7____8____9___10___11__
+   */
+  static __u32    entropycache[12];
+
+  /* get the current time in seconds */
+  t = get_seconds();
+
+  /* check for REKEY_INTERVAL */
+  if (t && (!rekey_time || ((t - rekey_time) > REKEY_INTERVAL))) {
+    rekey_time = t;
+    /* refresh with random entropy */
+    get_random_bytes(entropycache, sizeof(entropycache));
+  }
+
+  /* transform the buffer to a new state, thus generating new return 
value */
+  entropycache[1] = half_md4_transform(entropycache+8, entropycache);
+  entropycache[0] = half_md4_transform(entropycache+8, entropycache);
+
+  return *(unsigned long *)entropycache;
+}
+
+/*
  * randomize_range() returns a start address such that
  *
  *    [...... <range> .....]
diff -Nru linux-2.6.21.5.ORIG/fs/binfmt_elf.c linux-2.6.21.5/fs/binfmt_elf.c
--- linux-2.6.21.5.ORIG/fs/binfmt_elf.c    2007-06-11 20:37:06.000000000 
+0200
+++ linux-2.6.21.5/fs/binfmt_elf.c    2007-06-20 17:02:59.000000000 +0200
@@ -201,6 +201,7 @@
     NEW_AUX_ENT(AT_GID, tsk->gid);
     NEW_AUX_ENT(AT_EGID, tsk->egid);
      NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+  NEW_AUX_ENT(AT_ENTROPY, get_random_long());
     if (k_platform) {
         NEW_AUX_ENT(AT_PLATFORM,
                 (elf_addr_t)(unsigned long)u_platform);
diff -Nru linux-2.6.21.5.ORIG/include/linux/auxvec.h 
linux-2.6.21.5/include/linux/auxvec.h
--- linux-2.6.21.5.ORIG/include/linux/auxvec.h    2007-06-11 
20:37:06.000000000 +0200
+++ linux-2.6.21.5/include/linux/auxvec.h    2007-06-20 
16:47:44.000000000 +0200
@@ -26,6 +26,8 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
-#define AT_VECTOR_SIZE  44 /* Size of auxiliary table.  */
+#define AT_ENTROPY 24 /* kernel entropy in auxv */
+
+#define AT_VECTOR_SIZE 45 /* Size of auxiliary table in.  */
 
 #endif /* _LINUX_AUXVEC_H */
diff -Nru linux-2.6.21.5.ORIG/include/linux/random.h 
linux-2.6.21.5/include/linux/random.h
--- linux-2.6.21.5.ORIG/include/linux/random.h    2007-06-11 
20:37:06.000000000 +0200
+++ linux-2.6.21.5/include/linux/random.h    2007-06-20 
16:19:02.000000000 +0200
@@ -67,6 +67,9 @@
 #endif
 
 unsigned int get_random_int(void);
+
+unsigned long get_random_long(void);
+
 unsigned long randomize_range(unsigned long start, unsigned long end, 
unsigned long len);
 
 u32 random32(void);



