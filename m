Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbYELTIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbYELTIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYELTFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:05:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:42516 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbYELTFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e0GBRZrDC2NIuTvXvKrsFrhtilrkQi5XnTJDx7ri0CwjpmJZIGWDrw2pkctXeEimb3RAw39iEsjAxjKoGzaZFc3eTacTvFdulvQlhEoH3Og40TPlNkmkgRP84WCjTRx/tvUJ0lmiLXDETeI4OmMDmNZ/fQTyM2AeUDbHCYtzDyc=
Subject: [PATCH 08/12] frv: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:05:41 -0700
Message-Id: <1210619141.24092.59.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/frv/kernel/gdb-stub.c |   88 ++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 52 deletions(-)

diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index 48a0393..7ca8a6b 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -182,8 +182,6 @@ extern volatile u32 __attribute__((section(".bss"))) gdbstub_trace_through_excep
 static char	input_buffer[BUFMAX];
 static char	output_buffer[BUFMAX];
 
-static const char hexchars[] = "0123456789abcdef";
-
 static const char *regnames[] = {
 	"PSR ", "ISR ", "CCR ", "CCCR",
 	"LR  ", "LCR ", "PC  ", "_stt",
@@ -383,8 +381,8 @@ static int gdbstub_send_packet(char *buffer)
 		}
 
 		gdbstub_tx_char('#');
-		gdbstub_tx_char(hexchars[checksum >> 4]);
-		gdbstub_tx_char(hexchars[checksum & 0xf]);
+		gdbstub_tx_char(hex_asc_hi(checksum));
+		gdbstub_tx_char(hex_asc_lo(checksum));
 
 	} while (gdbstub_rx_char(&ch,0),
 #ifdef GDBSTUB_DEBUG_PROTOCOL
@@ -674,8 +672,7 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if ((uint32_t)mem&1 && count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 		mem++;
 		count--;
 	}
@@ -683,10 +680,8 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if ((uint32_t)mem&3 && count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -694,14 +689,10 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	while (count>=4) {
 		if (!gdbstub_read_dword(mem,(uint32_t *)ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
-		*buf++ = hexchars[ch[2] >> 4];
-		*buf++ = hexchars[ch[2] & 0xf];
-		*buf++ = hexchars[ch[3] >> 4];
-		*buf++ = hexchars[ch[3] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
+		buf = pack_hex_byte(buf, ch[2]);
+		buf = pack_hex_byte(buf, ch[3]);
 		mem += 4;
 		count -= 4;
 	}
@@ -709,10 +700,8 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if (count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -720,8 +709,7 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if (count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 	}
 
 	*buf = 0;
@@ -1471,22 +1459,22 @@ void gdbstub(int sigval)
 		*ptr++ = 'O';
 		ptr = mem2hex(title, ptr, sizeof(title) - 1,0);
 
-		hx = hexchars[(brr & 0xf0000000) >> 28];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x0f000000) >> 24];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x00f00000) >> 20];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x000f0000) >> 16];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x0000f000) >> 12];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x00000f00) >> 8];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x000000f0) >> 4];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(brr & 0x0000000f)];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hex_asc_hi(brr >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(brr >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(brr >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(brr);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(brr);
+		ptr = pack_hex_byte(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1500,12 +1488,10 @@ void gdbstub(int sigval)
 
 	/* Send trap type (converted to signal) */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/* Send Error PC */
-	*ptr++ = hexchars[GDB_REG_PC >> 4];
-	*ptr++ = hexchars[GDB_REG_PC & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REG_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1513,8 +1499,7 @@ void gdbstub(int sigval)
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[GDB_REG_FP >> 4];
-	*ptr++ = hexchars[GDB_REG_FP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->fp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1522,8 +1507,7 @@ void gdbstub(int sigval)
 	/*
 	 * Send stack pointer
 	 */
-	*ptr++ = hexchars[GDB_REG_SP >> 4];
-	*ptr++ = hexchars[GDB_REG_SP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->sp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1548,8 +1532,8 @@ void gdbstub(int sigval)
 			/* request repeat of last signal number */
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
@@ -2059,8 +2043,8 @@ void gdbstub_exit(int status)
 	}
 
 	gdbstub_tx_char('#');
-	gdbstub_tx_char(hexchars[checksum >> 4]);
-	gdbstub_tx_char(hexchars[checksum & 0xf]);
+	gdbstub_tx_char(hex_asc_hi(checksum));
+	gdbstub_tx_char(hex_asc_lo(checksum));
 
 	/* make sure the output is flushed, or else RedBoot might clobber it */
 	gdbstub_tx_char('-');
-- 
1.5.5.1.404.g981f6


