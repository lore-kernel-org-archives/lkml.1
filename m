Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbYEAXIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbYEAXIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbYEAXFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:05:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:53694 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165AbYEAXFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Gf11ad59CaZ0N27swpr5FzKc4kYqkECmYxCU0bwdwRvBHUlMzw16tpCOUi5z1SLBbd2qSiaVgYnvUT4EOypUjDvaXBbDE/60Wq1+E5jF2zH8wb32dS/nUPPhhm82VokiR5qiQUKMd5PCXjgahFWJH4sa6eeSl9wSLT7L3cdcYEw=
Subject: [PATCH 8/9] sh: kgdb-stub.c, sh-sci.c use the common ascii hex
	helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:05:38 -0700
Message-Id: <1209683138.24729.210.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/kernel/kgdb_stub.c |   16 ++++++++--------
 drivers/serial/sh-sci.c    |    8 ++++----
 include/asm-sh/kgdb.h      |   14 --------------
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/arch/sh/kernel/kgdb_stub.c b/arch/sh/kernel/kgdb_stub.c
index d453c3a..98cdb2b 100644
--- a/arch/sh/kernel/kgdb_stub.c
+++ b/arch/sh/kernel/kgdb_stub.c
@@ -274,8 +274,8 @@ static char *mem_to_hex(const char *mem, char *buf, const int count)
 	}
 	for (i = 0; i < count; i++) {
 		ch = *mem++;
-		*buf++ = highhex(ch);
-		*buf++ = lowhex(ch);
+		*buf++ = hex_asc_hi(ch);
+		*buf++ = hex_asc_lo(ch);
 	}
 	*buf = 0;
 	return (buf);
@@ -333,8 +333,8 @@ static char *ebin_to_mem(const char *buf, char *mem, int count)
 /* Pack a hex byte */
 static char *pack_hex_byte(char *pkt, int byte)
 {
-	*pkt++ = hexchars[(byte >> 4) & 0xf];
-	*pkt++ = hexchars[(byte & 0xf)];
+	*pkt++ = hex_asc_hi(byte);
+	*pkt++ = hex_asc_lo(byte);
 	return pkt;
 }
 
@@ -435,8 +435,8 @@ static void put_packet(char *buffer)
 
 		/* '#' Separator, put high and low components of checksum */
 		put_debug_char('#');
-		put_debug_char(highhex(checksum));
-		put_debug_char(lowhex(checksum));
+		put_debug_char(hex_asc_hi(checksum));
+		put_debug_char(hex_asc_lo(checksum));
 	}
 	while ((get_debug_char()) != '+');	/* While no ack */
 }
@@ -658,8 +658,8 @@ static void undo_single_step(void)
 static void send_signal_msg(const int signum)
 {
 	out_buffer[0] = 'S';
-	out_buffer[1] = highhex(signum);
-	out_buffer[2] = lowhex(signum);
+	out_buffer[1] = hex_asc_hi(signum);
+	out_buffer[2] = hex_asc_lo(signum);
 	out_buffer[3] = 0;
 	put_packet(out_buffer);
 }
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 9691061..6c1d3fc 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -186,15 +186,15 @@ static void put_string(struct sci_port *sci_port, const char *buffer, int count)
 			int h, l;
 
 			c = *p++;
-			h = highhex(c);
-			l = lowhex(c);
+			h = hex_asc_hi(c);
+			l = hex_asc_lo(c);
 			put_char(port, h);
 			put_char(port, l);
 			checksum += h + l;
 		}
 		put_char(port, '#');
-		put_char(port, highhex(checksum));
-		put_char(port, lowhex(checksum));
+		put_char(port, hex_asc_hi(checksum));
+		put_char(port, hex_asc_lo(checksum));
 	    } while  (get_char(port) != '+');
 	} else
 #endif /* CONFIG_SH_STANDARD_BIOS || CONFIG_SH_KGDB */
diff --git a/include/asm-sh/kgdb.h b/include/asm-sh/kgdb.h
index 4bc8cb1..24e4207 100644
--- a/include/asm-sh/kgdb.h
+++ b/include/asm-sh/kgdb.h
@@ -66,18 +66,4 @@ extern int     setjmp(jmp_buf __jmpb);
 /* Forced breakpoint */
 #define breakpoint()	__asm__ __volatile__("trapa   #0x3c")
 
-/* Taken from sh-stub.c of GDB 4.18 */
-static const char hexchars[] = "0123456789abcdef";
-
-/* Get high hex bits */
-static inline char highhex(const int x)
-{
-	return hexchars[(x >> 4) & 0xf];
-}
-
-/* Get low hex bits */
-static inline char lowhex(const int x)
-{
-	return hexchars[x & 0xf];
-}
 #endif
-- 
1.5.5.1.305.g7c84


