Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZFAL5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZFAL5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbZFAL5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:57:12 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48609 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZFAL5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=IDGWa0450o96NOM/9QnpH38usDfTS16RCctdMdFpPTkkzTa6sWGHIp+0UZhGmaHjSL
         jofYC8pNV52Mam9AD94y1CacsXM2JiQraHJZvpskc7AJo3QK0IdY9sQbhs3/yoxe7dxI
         j/rj3pi6c0vO7Rub6791327C66JwKAECI4xNU=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 1 Jun 2009 13:57:09 +0200
Subject: [PATCH 1/9] kernel: export sound/core/pcm_timer.c gcd implementation
MIME-Version: 1.0
X-Length: 2484
To: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       akpm <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011357.09966.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports the gcd implementation from
sound/core/pcm_timer.c into include/linux/kernel.h.
AR7 uses it in its clock routines.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..878a27a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -147,6 +147,22 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
+/* Greatest common divisor */
+static inline unsigned long gcd(unsigned long a, unsigned long b)
+{
+        unsigned long r;
+        if (a < b) {
+                r = a;
+                a = b;
+                b = r;
+        }
+        while ((r = a % b) != 0) {
+                a = b;
+                b = r;
+        }
+        return b;
+}
+
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
 #else
diff --git a/sound/core/pcm_timer.c b/sound/core/pcm_timer.c
index ca8068b..e9dbf62 100644
--- a/sound/core/pcm_timer.c
+++ b/sound/core/pcm_timer.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/kernel.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/timer.h>
@@ -28,22 +29,6 @@
  *  Timer functions
  */
 
-/* Greatest common divisor */
-static unsigned long gcd(unsigned long a, unsigned long b)
-{
-	unsigned long r;
-	if (a < b) {
-		r = a;
-		a = b;
-		b = r;
-	}
-	while ((r = a % b) != 0) {
-		a = b;
-		b = r;
-	}
-	return b;
-}
-
 void snd_pcm_timer_resolution_change(struct snd_pcm_substream *substream)
 {
 	unsigned long rate, mult, fsize, l, post;
