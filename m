Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYELTIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYELTIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbYELTF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:05:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:38624 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350AbYELTFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rrnh0+sX9en1iXQEpJYrTokDo8qn4CJpl8SwOEnQY6bfQiUQ7MSXttt8yjprur0YnDFEGSD609z/tZPnNCUuGbxRASWP+so6R98ELqRuF5Ma722BPsl0NHAnBR7Lqop+EPbC1apXN9K5gJKA8vn9QVL/jOnTP2wMnSPcx7pYlJg=
Subject: [PATCH 11/12] sh: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:05:43 -0700
Message-Id: <1210619144.24092.62.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sh/kernel/kgdb_stub.c |   11 +++++------
 drivers/serial/sh-sci.c    |    8 ++++----
 include/asm-sh/kgdb.h      |   14 --------------
 3 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/sh/kernel/kgdb_stub.c b/arch/sh/kernel/kgdb_stub.c
index 832641b..bf8ac4c 100644
--- a/arch/sh/kernel/kgdb_stub.c
+++ b/arch/sh/kernel/kgdb_stub.c
@@ -274,8 +274,7 @@ static char *mem_to_hex(const char *mem, char *buf, const int count)
 	}
 	for (i = 0; i < count; i++) {
 		ch = *mem++;
-		*buf++ = highhex(ch);
-		*buf++ = lowhex(ch);
+		buf = pack_hex_byte(buf, ch);
 	}
 	*buf = 0;
 	return (buf);
@@ -427,8 +426,8 @@ static void put_packet(char *buffer)
 
 		/* '#' Separator, put high and low components of checksum */
 		put_debug_char('#');
-		put_debug_char(highhex(checksum));
-		put_debug_char(lowhex(checksum));
+		put_debug_char(hex_asc_hi(checksum));
+		put_debug_char(hex_asc_lo(checksum));
 	}
 	while ((get_debug_char()) != '+');	/* While no ack */
 }
@@ -650,8 +649,8 @@ static void undo_single_step(void)
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
index 8fdafc2..ce6ee92 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -184,15 +184,15 @@ static void put_string(struct sci_port *sci_port, const char *buffer, int count)
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
1.5.5.1.404.g981f6


