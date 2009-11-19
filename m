Return-Path: <linux-kernel-owner+w=401wt.eu-S932538AbZKSENJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbZKSENJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 23:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932461AbZKSENI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 23:13:08 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:41035 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbZKSENH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 23:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wEr03XB5FJkc4GPdmE3WAsHQ7Y47UAcAEXom+YQibH4R3yzgIBH83pJqsabBzsxfXy
         KTyGHZlCIkfyDkZvhGTOG1d1brDF0UsYBE+iisN/onyqK3w7BqwQmK5l9Nl3H8rb1zTk
         XegbH1KRYkFT3noLP65PTDJkV1u8awBRfHmhc=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] Optimize hweight32 for x86
Date: Thu, 19 Nov 2009 13:12:12 +0900
Message-Id: <1258603932-4590-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize hweight32 by using the same technique in hweight64.
The proof of this technique can be found in the commit log for
f9b4192923fa6e38331e88214b1fe5fc21583fcc

The userspece benchmark on x86_32 showed 20% speedup with
bitmap_weight() which uses hweight32 to count bits for each
unsigned long on 32bit architectures.

int main(void)
{
	#define SZ (1024 * 1024 * 512)

	static DECLARE_BITMAP(bitmap, SZ) = {
	        [0 ... 100] = 1,
	};

	return bitmap_weight(bitmap, SZ);
}

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/hweight.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/lib/hweight.c b/lib/hweight.c
index 389424e..63ee4eb 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -11,11 +11,18 @@
 
 unsigned int hweight32(unsigned int w)
 {
+#ifdef ARCH_HAS_FAST_MULTIPLIER
+	w -= (w >> 1) & 0x55555555;
+	w =  (w & 0x33333333) + ((w >> 2) & 0x33333333);
+	w =  (w + (w >> 4)) & 0x0f0f0f0f;
+	return (w * 0x01010101) >> 24;
+#else
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
 	res = (res + (res >> 4)) & 0x0F0F0F0F;
 	res = res + (res >> 8);
 	return (res + (res >> 16)) & 0x000000FF;
+#endif
 }
 EXPORT_SYMBOL(hweight32);
 
-- 
1.6.5.1

