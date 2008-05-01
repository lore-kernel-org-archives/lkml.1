Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbYEAXGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbYEAXGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764766AbYEAXF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:05:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:4109 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764032AbYEAXFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jjXvRMn9PrNZhACXf1mkQvTa+Dr3wsM8exspQ+UznGjjcEHSvJDhH1iMSQRjWuSv+yGckiXCoWdkSr2rz1RHLJMCqzfhHaGhUqKUlW79dZ+x4Q2PdIFajxD+pheUxSbm7leYk5nnsBhxmwAnL3mzWK3ZqhqVhzNrh5f6lduBVcY=
Subject: [PATCH 4/9] kgdb: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:05:36 -0700
Message-Id: <1209683136.24729.206.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/misc/kgdbts.c |    5 ++---
 kernel/kgdb.c         |   36 +++++++++++-------------------------
 2 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 30a1af8..03d3549 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -118,7 +118,6 @@
 	} while (0)
 #define MAX_CONFIG_LEN		40
 
-static const char hexchars[] = "0123456789abcdef";
 static struct kgdb_io kgdbts_io_ops;
 static char get_buf[BUFMAX];
 static int get_buf_cnt;
@@ -618,8 +617,8 @@ static void fill_get_buf(char *buf)
 		count++;
 	}
 	strcat(get_buf, "#");
-	get_buf[count + 2] = hexchars[checksum >> 4];
-	get_buf[count + 3] = hexchars[checksum & 0xf];
+	get_buf[count + 2] = hex_asc_hi(checksum);
+	get_buf[count + 3] = hex_asc_lo(checksum);
 	get_buf[count + 4] = '\0';
 	v2printk("get%i: %s\n", ts.idx, get_buf);
 }
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 1bd0ec1..216c3dc 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -226,20 +226,6 @@ void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
 /*
  * GDB remote protocol parser:
  */
-
-static const char	hexchars[] = "0123456789abcdef";
-
-static int hex(char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
 /* scan for the sequence $<data>#<checksum> */
 static void get_packet(char *buffer)
 {
@@ -276,8 +262,8 @@ static void get_packet(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(kgdb_io_ops->read_char()) << 4;
-			xmitcsum += hex(kgdb_io_ops->read_char());
+			xmitcsum = hex_to_int(kgdb_io_ops->read_char()) << 4;
+			xmitcsum += hex_to_int(kgdb_io_ops->read_char());
 
 			if (checksum != xmitcsum)
 				/* failed checksum */
@@ -316,8 +302,8 @@ static void put_packet(char *buffer)
 		}
 
 		kgdb_io_ops->write_char('#');
-		kgdb_io_ops->write_char(hexchars[checksum >> 4]);
-		kgdb_io_ops->write_char(hexchars[checksum & 0xf]);
+		kgdb_io_ops->write_char(hex_asc_hi(checksum));
+		kgdb_io_ops->write_char(hex_asc_lo(checksum));
 		if (kgdb_io_ops->flush)
 			kgdb_io_ops->flush();
 
@@ -348,8 +334,8 @@ static void put_packet(char *buffer)
 
 static char *pack_hex_byte(char *pkt, u8 byte)
 {
-	*pkt++ = hexchars[byte >> 4];
-	*pkt++ = hexchars[byte & 0xf];
+	*pkt++ = hex_asc_hi(byte);
+	*pkt++ = hex_asc_lo(byte);
 
 	return pkt;
 }
@@ -427,8 +413,8 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
 	tmp_hex = tmp_raw - 1;
 	while (tmp_hex >= buf) {
 		tmp_raw--;
-		*tmp_raw = hex(*tmp_hex--);
-		*tmp_raw |= hex(*tmp_hex--) << 4;
+		*tmp_raw = hex_to_int(*tmp_hex--);
+		*tmp_raw |= hex_to_int(*tmp_hex--) << 4;
 	}
 
 	return probe_kernel_write(mem, tmp_raw, count);
@@ -446,7 +432,7 @@ int kgdb_hex2long(char **ptr, long *long_val)
 	*long_val = 0;
 
 	while (**ptr) {
-		hex_val = hex(**ptr);
+		hex_val = hex_to_int(**ptr);
 		if (hex_val < 0)
 			break;
 
@@ -486,8 +472,8 @@ static void error_packet(char *pkt, int error)
 {
 	error = -error;
 	pkt[0] = 'E';
-	pkt[1] = hexchars[(error / 10)];
-	pkt[2] = hexchars[(error % 10)];
+	pkt[1] = hex_asc[(error / 10)];
+	pkt[2] = hex_asc[(error % 10)];
 	pkt[3] = '\0';
 }
 
-- 
1.5.5.1.305.g7c84


