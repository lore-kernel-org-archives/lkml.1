Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbYEAXHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbYEAXHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbYEAXFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:05:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:4109 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762295AbYEAXFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=no43GkRlCLkys6YIHijb880t/IYNXdsBu5C9ap1FSBSFJDP5SYn9TMGxdDCmC9jXG+j7LOyz/E+/QNDC63Am3uRBk67j1e3muSuPBgYyBGClfBasn4nXXAyPHoXq/TE5JR1B8KNKWlo64FkFrK/R1JbIzFnjFelXx7uG5YMoDfY=
Subject: [PATCH 6/9] mn10300: gdb-stub.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:05:37 -0700
Message-Id: <1209683137.24729.208.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mn10300/kernel/gdb-stub.c |  183 ++++++++++++++++++----------------------
 1 files changed, 83 insertions(+), 100 deletions(-)

diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 21891c7..2431571 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -163,8 +163,6 @@ static char	input_buffer[BUFMAX];
 static char	output_buffer[BUFMAX];
 static char	trans_buffer[BUFMAX];
 
-static const char hexchars[] = "0123456789abcdef";
-
 struct gdbstub_bkpt {
 	u8	*addr;		/* address of breakpoint */
 	u8	len;		/* size of breakpoint */
@@ -179,27 +177,12 @@ static struct gdbstub_bkpt gdbstub_bkpts[256];
 static void getpacket(char *buffer);
 static int putpacket(char *buffer);
 static int computeSignal(enum exception_code excep);
-static int hex(unsigned char ch);
 static int hexToInt(char **ptr, int *intValue);
 static unsigned char *mem2hex(const void *mem, char *buf, int count,
 			      int may_fault);
 static const char *hex2mem(const char *buf, void *_mem, int count,
 			   int may_fault);
 
-/*
- * Convert ch from a hex digit to an int
- */
-static int hex(unsigned char ch)
-{
-	if (ch >= 'a' && ch <= 'f')
-		return ch - 'a' + 10;
-	if (ch >= '0' && ch <= '9')
-		return ch - '0';
-	if (ch >= 'A' && ch <= 'F')
-		return ch - 'A' + 10;
-	return -1;
-}
-
 #ifdef CONFIG_GDBSTUB_DEBUGGING
 
 void debug_to_serial(const char *p, int n)
@@ -286,12 +269,12 @@ static void getpacket(char *buffer)
 		ret = gdbstub_io_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum = hex(ch) << 4;
+		xmitcsum = hex_to_int(ch) << 4;
 
 		ret = gdbstub_io_rx_char(&ch, 0);
 		if (ret < 0)
 			error = ret;
-		xmitcsum |= hex(ch);
+		xmitcsum |= hex_to_int(ch);
 
 		if (error) {
 			if (error == -EIO)
@@ -363,8 +346,8 @@ static int putpacket(char *buffer)
 		}
 
 		gdbstub_io_tx_char('#');
-		gdbstub_io_tx_char(hexchars[checksum >> 4]);
-		gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+		gdbstub_io_tx_char(hex_asc_hi(checksum));
+		gdbstub_io_tx_char(hex_asc_lo(checksum));
 
 	} while (gdbstub_io_rx_char(&ch, 0),
 		 ch == '-' && (gdbstub_io("### GDB Rx NAK\n"), 0),
@@ -394,7 +377,7 @@ static int hexToInt(char **ptr, int *intValue)
 	*intValue = 0;
 
 	while (**ptr) {
-		hexValue = hex(**ptr);
+		hexValue = hex_to_int(**ptr);
 		if (hexValue < 0)
 			break;
 
@@ -822,8 +805,8 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if ((u32) mem & 1 && count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
 		mem++;
 		count--;
 	}
@@ -831,10 +814,10 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if ((u32) mem & 3 && count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
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
@@ -842,14 +825,14 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	while (count >= 4) {
 		if (gdbstub_read_dword(mem, ch) != 0)
 			return 0;
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
@@ -857,10 +840,10 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if (count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
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
@@ -868,8 +851,8 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if (count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		*buf++ = hex_asc_hi(ch[0]);
+		*buf++ = hex_asc_lo(ch[0]);
 	}
 
 	*buf = 0;
@@ -892,8 +875,8 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	} ch;
 
 	if ((u32) mem & 1 && count >= 1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
 		if (gdbstub_write_byte(ch.val, mem) != 0)
 			return 0;
 		mem++;
@@ -901,10 +884,10 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	if ((u32) mem & 3 && count >= 2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
 		if (gdbstub_write_word(ch.val, mem) != 0)
 			return 0;
 		mem += 2;
@@ -912,14 +895,14 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	while (count >= 4) {
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
 		if (gdbstub_write_dword(ch.val, mem) != 0)
 			return 0;
 		mem += 4;
@@ -927,10 +910,10 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	if (count >= 2) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
-		ch.b[1]  = hex(*buf++) << 4;
-		ch.b[1] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
+		ch.b[1]  = hex_to_int(*buf++) << 4;
+		ch.b[1] |= hex_to_int(*buf++);
 		if (gdbstub_write_word(ch.val, mem) != 0)
 			return 0;
 		mem += 2;
@@ -938,8 +921,8 @@ const char *hex2mem(const char *buf, void *_mem, int count, int may_fault)
 	}
 
 	if (count >= 1) {
-		ch.b[0]  = hex(*buf++) << 4;
-		ch.b[0] |= hex(*buf++);
+		ch.b[0]  = hex_to_int(*buf++) << 4;
+		ch.b[0] |= hex_to_int(*buf++);
 		if (gdbstub_write_byte(ch.val, mem) != 0)
 			return 0;
 	}
@@ -1304,14 +1287,14 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 		*ptr++ = 'O';
 		ptr = mem2hex(title, ptr, sizeof(title) - 1, 0);
 
-		hx = hexchars[(excep & 0xf000) >> 12];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(excep & 0x0f00) >> 8];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(excep & 0x00f0) >> 4];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(excep & 0x000f)];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hex_asc_hi(excep >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(excep >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(excep);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(excep);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1322,22 +1305,22 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 		*ptr++ = 'O';
 		ptr = mem2hex(tbcberr, ptr, sizeof(tbcberr) - 1, 0);
 
-		hx = hexchars[(bcberr & 0xf0000000) >> 28];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x0f000000) >> 24];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x00f00000) >> 20];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x000f0000) >> 16];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x0000f000) >> 12];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x00000f00) >> 8];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x000000f0) >> 4];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
-		hx = hexchars[(bcberr & 0x0000000f)];
-		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
+		hx = hex_asc_hi(bcberr >> 24);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr >> 24);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(bcberr >> 16);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr >> 16);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(bcberr >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr >> 8);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_hi(bcberr);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
+		hx = hex_asc_lo(bcberr);
+		*ptr++ = hex_asc_hi(hx);	*ptr++ = hex_asc_lo(hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1353,14 +1336,14 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 	 * Send trap type (converted to signal)
 	 */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	*ptr++ = hex_asc_hi(sigval);
+	*ptr++ = hex_asc_lo(sigval);
 
 	/*
 	 * Send Error PC
 	 */
-	*ptr++ = hexchars[GDB_REGID_PC >> 4];
-	*ptr++ = hexchars[GDB_REGID_PC & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REGID_PC);
+	*ptr++ = hex_asc_lo(GDB_REGID_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1368,8 +1351,8 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[GDB_REGID_FP >> 4];
-	*ptr++ = hexchars[GDB_REGID_FP & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REGID_FP);
+	*ptr++ = hex_asc_lo(GDB_REGID_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->a3, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1378,8 +1361,8 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 	 * Send stack pointer
 	 */
 	ssp = (unsigned long) (regs + 1);
-	*ptr++ = hexchars[GDB_REGID_SP >> 4];
-	*ptr++ = hexchars[GDB_REGID_SP & 0xf];
+	*ptr++ = hex_asc_hi(GDB_REGID_SP);
+	*ptr++ = hex_asc_lo(GDB_REGID_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&ssp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1399,8 +1382,8 @@ packet_waiting:
 			/* request repeat of last signal number */
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
@@ -1838,8 +1821,8 @@ void gdbstub_exit(int status)
 
 	gdbstub_busy = 1;
 	output_buffer[0] = 'W';
-	output_buffer[1] = hexchars[(status >> 4) & 0x0F];
-	output_buffer[2] = hexchars[status & 0x0F];
+	output_buffer[1] = hex_asc_hi(status);
+	output_buffer[2] = hex_asc_lo(status);
 	output_buffer[3] = 0;
 
 	gdbstub_io_tx_char('$');
@@ -1853,8 +1836,8 @@ void gdbstub_exit(int status)
 	}
 
 	gdbstub_io_tx_char('#');
-	gdbstub_io_tx_char(hexchars[checksum >> 4]);
-	gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+	gdbstub_io_tx_char(hex_asc_hi(checksum));
+	gdbstub_io_tx_char(hex_asc_lo(checksum));
 
 	/* make sure the output is flushed, or else RedBoot might clobber it */
 	gdbstub_io_tx_flush();
-- 
1.5.5.1.305.g7c84


