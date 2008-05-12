Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYELTJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYELTJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbYELTF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:05:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:37566 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352AbYELTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XL3607MdhpQjlHc79hBQHwjW2AiVqb4iH1K9oNM46SNBBjDeOR1UgBIPRcnoH/g0QpOwbWzzdMzcdIdzxMKOg32xdmsJz2AI9E5Eb45s61sH2ZhdWEvvA0swxb61H+8A8plGw0lbVoVvgckGnq2uWju7/AgElE0wTi69tJb11Jc=
Subject: [PATCH 09/12] mn10300: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:05:42 -0700
Message-Id: <1210619142.24092.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mn10300/kernel/gdb-stub.c |  108 +++++++++++++++++-----------------------
 1 files changed, 46 insertions(+), 62 deletions(-)

diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 21891c7..644c52a 100644
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
@@ -363,8 +361,8 @@ static int putpacket(char *buffer)
 		}
 
 		gdbstub_io_tx_char('#');
-		gdbstub_io_tx_char(hexchars[checksum >> 4]);
-		gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+		gdbstub_io_tx_char(hex_asc_hi(checksum));
+		gdbstub_io_tx_char(hex_asc_lo(checksum));
 
 	} while (gdbstub_io_rx_char(&ch, 0),
 		 ch == '-' && (gdbstub_io("### GDB Rx NAK\n"), 0),
@@ -822,8 +820,7 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if ((u32) mem & 1 && count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 		mem++;
 		count--;
 	}
@@ -831,10 +828,8 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if ((u32) mem & 3 && count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -842,14 +837,10 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
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
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
+		buf = pack_hex_byte(buf, ch[2]);
+		buf = pack_hex_byte(buf, ch[3]);
 		mem += 4;
 		count -= 4;
 	}
@@ -857,10 +848,8 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if (count >= 2) {
 		if (gdbstub_read_word(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
-		*buf++ = hexchars[ch[1] >> 4];
-		*buf++ = hexchars[ch[1] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
+		buf = pack_hex_byte(buf, ch[1]);
 		mem += 2;
 		count -= 2;
 	}
@@ -868,8 +857,7 @@ unsigned char *mem2hex(const void *_mem, char *buf, int count, int may_fault)
 	if (count >= 1) {
 		if (gdbstub_read_byte(mem, ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch[0] >> 4];
-		*buf++ = hexchars[ch[0] & 0xf];
+		buf = pack_hex_byte(buf, ch[0]);
 	}
 
 	*buf = 0;
@@ -1304,14 +1292,14 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
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
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep);
+		ptr = pack_hex_byte(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1322,22 +1310,22 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
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
+		hx = hex_asc_hi(excep >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 24);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 16);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep >> 8);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_hi(excep);
+		ptr = pack_hex_byte(ptr, hx);
+		hx = hex_asc_lo(excep);
+		ptr = pack_hex_byte(ptr, hx);
 
 		ptr = mem2hex(crlf, ptr, sizeof(crlf) - 1, 0);
 		*ptr = 0;
@@ -1353,14 +1341,12 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 	 * Send trap type (converted to signal)
 	 */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/*
 	 * Send Error PC
 	 */
-	*ptr++ = hexchars[GDB_REGID_PC >> 4];
-	*ptr++ = hexchars[GDB_REGID_PC & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REGID_PC);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->pc, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1368,8 +1354,7 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[GDB_REGID_FP >> 4];
-	*ptr++ = hexchars[GDB_REGID_FP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REGID_FP);
 	*ptr++ = ':';
 	ptr = mem2hex(&regs->a3, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1378,8 +1363,7 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 	 * Send stack pointer
 	 */
 	ssp = (unsigned long) (regs + 1);
-	*ptr++ = hexchars[GDB_REGID_SP >> 4];
-	*ptr++ = hexchars[GDB_REGID_SP & 0xf];
+	ptr = pack_hex_byte(ptr, GDB_REGID_SP);
 	*ptr++ = ':';
 	ptr = mem2hex(&ssp, ptr, 4, 0);
 	*ptr++ = ';';
@@ -1399,8 +1383,8 @@ packet_waiting:
 			/* request repeat of last signal number */
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
@@ -1838,8 +1822,8 @@ void gdbstub_exit(int status)
 
 	gdbstub_busy = 1;
 	output_buffer[0] = 'W';
-	output_buffer[1] = hexchars[(status >> 4) & 0x0F];
-	output_buffer[2] = hexchars[status & 0x0F];
+	output_buffer[1] = hex_asc_hi(status);
+	output_buffer[2] = hex_asc_lo(status);
 	output_buffer[3] = 0;
 
 	gdbstub_io_tx_char('$');
@@ -1853,8 +1837,8 @@ void gdbstub_exit(int status)
 	}
 
 	gdbstub_io_tx_char('#');
-	gdbstub_io_tx_char(hexchars[checksum >> 4]);
-	gdbstub_io_tx_char(hexchars[checksum & 0xf]);
+	gdbstub_io_tx_char(hex_asc_hi(checksum));
+	gdbstub_io_tx_char(hex_asc_lo(checksum));
 
 	/* make sure the output is flushed, or else RedBoot might clobber it */
 	gdbstub_io_tx_flush();
-- 
1.5.5.1.404.g981f6


