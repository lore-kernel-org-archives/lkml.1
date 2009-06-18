Return-Path: <linux-kernel-owner+w=401wt.eu-S1764489AbZFRO1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764489AbZFRO1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 10:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761121AbZFRO0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 10:26:46 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58265 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbZFRO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 10:26:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JXT39LCvZd57i8WLlJF/rMytGSd8ckQGyvFsVLHpUxqwJvdqYOR3AxJgoGUENizyyP
         0yOWwmeHjd5BH9y+sBf0VXGnBjAExDYDMH7VWRNGWpNsUxF3zUSzsRvg12nkv5PuMxbm
         0gvpN/g2MKqPkDMUmCTW+b6f3vkdfpSTELoHA=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergey Lapin <slapin@ossfans.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: [PATCH 2/5] crc-itu-t: add bit-reversed calculation
Date: Thu, 18 Jun 2009 18:26:14 +0400
Message-Id: <1245335177-16810-3-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245335177-16810-2-git-send-email-dbaryshkov@gmail.com>
References: <1245335177-16810-1-git-send-email-dbaryshkov@gmail.com>
 <1245335177-16810-2-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Salt <linux@youmustbejoking.demon.co.uk>

Changes since original patch by Darren:
* add 'select BITREVERSE'
* fix kerneldoc

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 include/linux/crc-itu-t.h |   10 ++++++++++
 lib/Kconfig               |    1 +
 lib/crc-itu-t.c           |   17 +++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/crc-itu-t.h b/include/linux/crc-itu-t.h
index 84920f3..7b2b7ba 100644
--- a/include/linux/crc-itu-t.h
+++ b/include/linux/crc-itu-t.h
@@ -6,6 +6,9 @@
  *   Poly  0x0x1021 (x^16 + x^12 + x^15 + 1)
  *   Init  0
  *
+ * The bit-reversed buffer variants may be non-standard, but some firmware
+ * loaders require them.
+ *
  * This source code is licensed under the GNU General Public License,
  * Version 2. See the file COPYING for more details.
  */
@@ -14,15 +17,22 @@
 #define CRC_ITU_T_H
 
 #include <linux/types.h>
+#include <linux/bitrev.h>
 
 extern u16 const crc_itu_t_table[256];
 
 extern u16 crc_itu_t(u16 crc, const u8 *buffer, size_t len);
+extern u16 crc_itu_t_bitreversed(u16 crc, const u8 *buffer, size_t len);
 
 static inline u16 crc_itu_t_byte(u16 crc, const u8 data)
 {
 	return (crc << 8) ^ crc_itu_t_table[((crc >> 8) ^ data) & 0xff];
 }
 
+static inline u16 crc_itu_t_bitreversed_byte(u16 crc, const u8 data)
+{
+	return (crc << 8) ^ crc_itu_t_table[((crc >> 8) ^ bitrev8(data)) & 0xff];
+}
+
 #endif /* CRC_ITU_T_H */
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 8ade0a7..0ec01c3 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -45,6 +45,7 @@ config CRC_T10DIF
 
 config CRC_ITU_T
 	tristate "CRC ITU-T V.41 functions"
+	select BITREVERSE
 	help
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC ITU-T V.41 functions, but a module built outside
diff --git a/lib/crc-itu-t.c b/lib/crc-itu-t.c
index a63472b..a1422d8 100644
--- a/lib/crc-itu-t.c
+++ b/lib/crc-itu-t.c
@@ -64,6 +64,23 @@ u16 crc_itu_t(u16 crc, const u8 *buffer, size_t len)
 }
 EXPORT_SYMBOL(crc_itu_t);
 
+/**
+ * crc_itu_t_bitreversed - Compute the CRC-ITU-T for the bit-reversed data buffer;
+ *
+ * @crc:     previous CRC value
+ * @buffer:  data pointer
+ * @len:     number of bytes in the buffer
+ *
+ * Returns the updated CRC value
+ */
+u16 crc_itu_t_bitreversed(u16 crc, const u8 *buffer, size_t len)
+{
+	while (len--)
+		crc = crc_itu_t_bitreversed_byte(crc, *buffer++);
+	return crc;
+}
+EXPORT_SYMBOL(crc_itu_t_bitreversed);
+
 MODULE_DESCRIPTION("CRC ITU-T V.41 calculations");
 MODULE_LICENSE("GPL");
 
-- 
1.6.3.1

