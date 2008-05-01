Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbYEAXH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbYEAXH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932851AbYEAXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:05:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:8094 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765672AbYEAXF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RiuBT/BizdombiP3RRoenW7qRyqlfjlm3SqcjltZkuASMcM6k9o9s28/hQSLZ2IZG6EOKyuNTxAqOaGZEKiXlR0gNTUujigz7bKzB0lOSW3ZLPxtJc4mHj/E6b1XCYymvZJJWUJ5MD03XC+Jn6YXV7Q0Rsmu01tsDTeakZDCCmA=
Subject: [PATCH 5/9] frv: gdb-stub.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:05:36 -0700
Message-Id: <1209683136.24729.207.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/frv/kernel/gdb-stub.c |  163 ++++++++++++++++++++------------------------
 1 files changed, 73 insertions(+), 90 deletions(-)

diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index 48a0393..5a369d7 100644
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
@@ -214,25 +212,10 @@ static struct gdbstub_bkpt gdbstub_bkpts[256];
 static void gdbstub_recv_packet(char *buffer);
 static int gdbstub_send_packet(char *buffer);
 static int gdbstub_compute_signal(unsigned long tbr);
-static int hex(unsigned char ch);
 static int hexToInt(char **ptr, unsigned long *intValue);
 static unsigned char *mem2hex(const void *mem, char *buf, int count, int may_fault);
 static char *hex2mem(const char *buf, void *_mem, int count);
 
-/*
- * Convert ch from a hex digit to an int
- */
-static int hex(unsigned char ch)
-{
-	if (ch >= 'a' && ch <= 'f')
-		return ch-'a'+10;
-	if (ch >= '0' && ch <= '9')
-		return ch-'0';
-	if (ch >= 'A' && ch <= 'F')
-		return ch-'A'+10;
-	return -1;
-}
-
 void gdbstub_printk(const char *fmt, ...)
 {
 	static char buf[1024];
@@ -314,12 +297,12 @@ static void gdbstub_recv_packet(char *buffer)
 		ret = gdbstub_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum = hex(ch) << 4;
+		xmitcsum = hex_to_int(ch) << 4;
 
 		ret = gdbstub_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum |= hex(ch);
+		xmitcsum |= hex_to_int(ch);
 
 		if (error) {
 			if (error == -EIO)
@@ -383,8 +366,8 @@ static int gdbstub_send_packet(char *buffer)
 		}
 
 		gdbstub_tx_char('#');
-		gdbstub_tx_char(hexchars[checksum >> 4]);
-		gdbstub_tx_char(hexchars[checksum & 0xf]);
+		gdbstub_tx_char(hex_asc_hi(checksum));
+		gdbstub_tx_char(hex_asc_lo(checksum));
 
 	} while (gdbstub_rx_char(&ch,0),
 #ifdef GDBSTUB_DEBUG_PROTOCOL
@@ -413,7 +396,7 @@ static int hexToInt(char **ptr, unsigned long *_value)
 
 	*_value = 0;
 	while (**ptr) {
-		ch = hex(**ptr);
+		ch = hex_to_int(**ptr);
 		if (ch < 0)
 			break;
 
@@ -674,8 +657,8 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if ((uint32_t)mem&1 && count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
 		mem++;
 		count--;
 	}
@@ -683,10 +666,10 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if ((uint32_t)mem&3 && count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
+		*buf++ = hex_asc_hi(ch[1]);
+		*buf++ = hex_asc_lo(ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -694,14 +677,14 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
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
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
+		*buf++ = hex_asc_hi(ch[1]);
+		*buf++ = hex_asc_lo(ch[1]);
+		*buf++ = hex_asc_hi(ch[2]);
+		*buf++ = hex_asc_lo(ch[2]);
+		*buf++ = hex_asc_hi(ch[3]);
+		*buf++ = hex_asc_lo(ch[3]);
 		mem += 4;
 		count -= 4;
 	}
@@ -709,10 +692,10 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if (count>=2) {
 		if (!gdbstub_read_word(mem,(uint16_t *)ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
+		*buf++ = hex_asc_hi(ch[1]);
+		*buf++ = hex_asc_lo(ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -720,8 +703,8 @@ static unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fa
 	if (count>=1) {
 		if (!gdbstub_read_byte(mem,ch))
 			return NULL;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
 	}
 
 	*buf = 0;
@@ -744,8 +727,8 @@ static char *hex2mem(const char *buf, void *_mem, int count)
 	} ch;
 
 	if ((u32)mem&1 && count>=1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
 		if (!gdbstub_write_byte(mem,ch.b[0]))
 			return NULL;
 		mem++;
@@ -753,10 +736,10 @@ static char *hex2mem(const char *buf, void *_mem, int count)
 	}
 
 	if ((u32)mem&3 && count>=2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
 		if (!gdbstub_write_word(mem,ch.w))
 			return NULL;
 		mem += 2;
@@ -764,14 +747,14 @@ static char *hex2mem(const char *buf, void *_mem, int count)
 	}
 
 	while (count>=4) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
-		ch.b[2]  = hex(*buf++) << 4;
-		ch.b[2] |= hex(*buf++);
-		ch.b[3]  = hex(*buf++) << 4;
-		ch.b[3] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
+		ch.b[2]  = hex_to_int(*buf++) << 4;
+		ch.b[2] |= hex_to_int(*buf++);
+		ch.b[3]  = hex_to_int(*buf++) << 4;
+		ch.b[3] |= hex_to_int(*buf++);
 		if (!gdbstub_write_dword(mem,ch.l))
 			return NULL;
 		mem += 4;
@@ -779,10 +762,10 @@ static char *hex2mem(const char *buf, void *_mem, int count)
 	}
 
 	if (count>=2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
 		if (!gdbstub_write_word(mem,ch.w))
 			return NULL;
 		mem += 2;
@@ -790,8 +773,8 @@ static char *hex2mem(const char *buf, void *_mem, int count)
 	}
 
 	if (count>=1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
 		if (!gdbstub_write_byte(mem,ch.b[0]))
 			return NULL;
 	}
@@ -1471,22 +1454,22 @@ void gdbstub(int sigval)
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
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(brr >> 24);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(brr >> 16);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(brr >> 16);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(brr >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(brr >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(brr);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(brr);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1500,12 +1483,12 @@ void gdbstub(int sigval)
 
 	/* Send trap type (converted to signal) */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	*ptr++ = hex_asc_hi(sigval);
+	*ptr++ = hex_asc_lo(sigval);
 
 	/* Send Error PC */
-	*ptr++ = hexchars[GDB_REG_PC >> 4];
-	*ptr++ = hexchars[GDB_REG_PC & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REG_PC);
+	*ptr++ = hex_asc_lo(GDB_REG_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1513,8 +1496,8 @@ void gdbstub(int sigval)
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[GDB_REG_FP >> 4];
-	*ptr++ = hexchars[GDB_REG_FP & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REG_FP);
+	*ptr++ = hex_asc_lo(GDB_REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->fp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1522,8 +1505,8 @@ void gdbstub(int sigval)
 	/*
 	 * Send stack pointer
 	 */
-	*ptr++ = hexchars[GDB_REG_SP >> 4];
-	*ptr++ = hexchars[GDB_REG_SP & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REG_SP);
+	*ptr++ = hex_asc_lo(GDB_REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&__debug_frame->sp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1548,8 +1531,8 @@ void gdbstub(int sigval)
 			/* request repeat of last signal number */
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
@@ -2059,8 +2042,8 @@ void gdbstub_exit(int status)
 	}
 
 	gdbstub_tx_char('#');
-	gdbstub_tx_char(hexchars[checksum >> 4]);
-	gdbstub_tx_char(hexchars[checksum & 0xf]);
+	gdbstub_tx_char(hex_asc_hi(checksum));
+	gdbstub_tx_char(hex_asc_lo(checksum));
 
 	/* make sure the output is flushed, or else RedBoot might clobber it */
 	gdbstub_tx_char('-');
-- 
1.5.5.1.305.g7c84


