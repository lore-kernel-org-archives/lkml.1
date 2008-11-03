Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYKCQR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYKCQR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYKCQRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:17:51 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:52473 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750921AbYKCQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:17:51 -0500
Date: Mon, 3 Nov 2008 17:17:49 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Woodhouse <dwmw2@infradead.org>,
       Richard Purdie <rpurdie@openedhand.com>
cc: linux-mtd@lists.infradead.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] jffs2: Fix race condition in jffs2_lzo_compress()
Message-ID: <Pine.LNX.4.64.0811031714590.6298@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-244102331-1225729069=:6298"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-244102331-1225729069=:6298
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

deflate_mutex protects the globals lzo_mem and lzo_compress_buf. However,
jffs2_lzo_compress() unlocks deflate_mutex _before_ it has copied out the
compressed data from lzo_compress_buf. Correct this by moving the mutex unlock
after the copy.
In addition, document what deflate_mutex actually protects.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
Just noticed this when looking at the code.
The patch is untested, except for a quick compile test.

 fs/jffs2/compr_lzo.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/jffs2/compr_lzo.c
+++ b/fs/jffs2/compr_lzo.c
@@ -19,7 +19,7 @@
 
 static void *lzo_mem;
 static void *lzo_compress_buf;
-static DEFINE_MUTEX(deflate_mutex);
+static DEFINE_MUTEX(deflate_mutex);	/* for lzo_mem and lzo_compress_buf */
 
 static void free_workspace(void)
 {
@@ -49,18 +49,21 @@ static int jffs2_lzo_compress(unsigned c
 
 	mutex_lock(&deflate_mutex);
 	ret = lzo1x_1_compress(data_in, *sourcelen, lzo_compress_buf, &compress_size, lzo_mem);
-	mutex_unlock(&deflate_mutex);
-
 	if (ret != LZO_E_OK)
-		return -1;
+		goto fail;
 
 	if (compress_size > *dstlen)
-		return -1;
+		goto fail;
 
 	memcpy(cpage_out, lzo_compress_buf, compress_size);
-	*dstlen = compress_size;
+	mutex_unlock(&deflate_mutex);
 
+	*dstlen = compress_size;
 	return 0;
+
+ fail:
+	mutex_unlock(&deflate_mutex);
+	return -1;
 }
 
 static int jffs2_lzo_decompress(unsigned char *data_in, unsigned char *cpage_out,

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-244102331-1225729069=:6298--
