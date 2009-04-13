Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZDMCdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZDMCdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZDMCdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:33:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53737 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbZDMCdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:33:40 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Apr 2009 03:33:37 +0100
Message-Id: <1239590017.18110.120.camel@deadeye.i.decadent.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/3] crc-itu-t: add bit-reversed calculation
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
---
 include/linux/crc-itu-t.h |   10 ++++++++++
 lib/crc-itu-t.c           |   18 ++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

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
 
diff --git a/lib/crc-itu-t.c b/lib/crc-itu-t.c
index a63472b..886981e 100644
--- a/lib/crc-itu-t.c
+++ b/lib/crc-itu-t.c
@@ -64,6 +64,24 @@ u16 crc_itu_t(u16 crc, const u8 *buffer, size_t len)
 }
 EXPORT_SYMBOL(crc_itu_t);
 
+/**
+ * crc_itu_t_byte_reversed - Compute the CRC-ITU-T for the data buffer;
+ * the buffer content is assumed to be bit-reversed
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
1.5.6.5


