Return-Path: <linux-kernel-owner+w=401wt.eu-S936550AbYEBTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936550AbYEBTER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964882AbYEBTBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:01:49 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:48598 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936225AbYEBTBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NwQPZMBcnKJ5vS2G7OMgcI2DgrbuJ3JbCvs9wjJXGYQfTOPLV97nqM/VN7B4BBW0gVBbfRTYBqHz2a0Jx1xChkgGAezDDMlqMYCXnAeMJXjp+8onNRNCYr8nE2CEyqB958aYzMQxhSzXzc3QbWU7Q2LTEhw9tQe7s/3EBp2VaE0=
Subject: [PATCH 07/12] mips: gdb-stub.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:54 -0700
Message-Id: <1209754914.26173.32.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mips/kernel/gdb-stub.c |   56 +++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/arch/mips/kernel/gdb-stub.c b/arch/mips/kernel/gdb-stub.c
index 25f4eab..fe81aa4 100644
--- a/arch/mips/kernel/gdb-stub.c
+++ b/arch/mips/kernel/gdb-stub.c
@@ -164,7 +164,6 @@ extern void adel(void);
 static void getpacket(char *buffer);
 static void putpacket(char *buffer);
 static int computeSignal(int tt);
-static int hex(unsigned char ch);
 static int hexToInt(char **ptr, int *intValue);
 static int hexToLong(char **ptr, long *longValue);
 static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault);
@@ -190,7 +189,6 @@ static char input_buffer[BUFMAX];
 static char output_buffer[BUFMAX];
 static int initialized;	/* !0 means we've been initialized */
 static int kgdb_started;
-static const char hexchars[]="0123456789abcdef";
 
 /* Used to prevent crashes in memory access.  Note that they'll crash anyway if
    we haven't set up fault handlers yet... */
@@ -198,20 +196,6 @@ int kgdb_read_byte(unsigned char *address, unsigned char *dest);
 int kgdb_write_byte(unsigned char val, unsigned char *dest);
 
 /*
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
-/*
  * scan for the sequence $<data>#<checksum>
  */
 static void getpacket(char *buffer)
@@ -251,8 +235,8 @@ static void getpacket(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(getDebugChar() & 0x7f) << 4;
-			xmitcsum |= hex(getDebugChar() & 0x7f);
+			xmitcsum = hex_to_int(getDebugChar() & 0x7f) << 4;
+			xmitcsum |= hex_to_int(getDebugChar() & 0x7f);
 
 			if (checksum != xmitcsum)
 				putDebugChar('-');	/* failed checksum */
@@ -306,8 +290,8 @@ static void putpacket(char *buffer)
 		}
 
 		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 
 	}
 	while ((getDebugChar() & 0x7f) != '+');
@@ -328,8 +312,8 @@ static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault)
 	while (count-- > 0) {
 		if (kgdb_read_byte(mem++, &ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch >> 4];
-		*buf++ = hexchars[ch & 0xf];
+		*buf++ = hex_asc_hi(ch);
+		*buf++ = hex_asc_lo(ch);
 	}
 
 	*buf = 0;
@@ -356,8 +340,8 @@ static char *hex2mem(char *buf, char *mem, int count, int binary, int may_fault)
 				ch = 0x20 ^ *buf++;
 		}
 		else {
-			ch = hex(*buf++) << 4;
-			ch |= hex(*buf++);
+			ch = hex_to_int(*buf++) << 4;
+			ch |= hex_to_int(*buf++);
 		}
 		if (kgdb_write_byte(ch, mem++) != 0)
 			return 0;
@@ -457,7 +441,7 @@ static int hexToInt(char **ptr, int *intValue)
 	*intValue = 0;
 
 	while (**ptr) {
-		hexValue = hex(**ptr);
+		hexValue = hex_to_int(**ptr);
 		if (hexValue < 0)
 			break;
 
@@ -478,7 +462,7 @@ static int hexToLong(char **ptr, long *longValue)
 	*longValue = 0;
 
 	while (**ptr) {
-		hexValue = hex(**ptr);
+		hexValue = hex_to_int(**ptr);
 		if (hexValue < 0)
 			break;
 
@@ -812,14 +796,14 @@ void handle_exception(struct gdb_regs *regs)
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
-	*ptr++ = hexchars[REG_EPC >> 4];
-	*ptr++ = hexchars[REG_EPC & 0xf];
+	*ptr++ = hex_asc_hi(REG_EPC);
+	*ptr++ = hex_asc_lo(REG_EPC);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->cp0_epc, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -827,8 +811,8 @@ void handle_exception(struct gdb_regs *regs)
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[REG_FP >> 4];
-	*ptr++ = hexchars[REG_FP & 0xf];
+	*ptr++ = hex_asc_hi(REG_FP);
+	*ptr++ = hex_asc_lo(REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg30, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -836,8 +820,8 @@ void handle_exception(struct gdb_regs *regs)
 	/*
 	 * Send stack pointer
 	 */
-	*ptr++ = hexchars[REG_SP >> 4];
-	*ptr++ = hexchars[REG_SP & 0xf];
+	*ptr++ = hex_asc_hi(REG_SP);
+	*ptr++ = hex_asc_lo(REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg29, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -856,8 +840,8 @@ void handle_exception(struct gdb_regs *regs)
 		{
 		case '?':
 			output_buffer[0] = 'S';
-			output_buffer[1] = hexchars[sigval >> 4];
-			output_buffer[2] = hexchars[sigval & 0xf];
+			output_buffer[1] = hex_asc_hi(sigval);
+			output_buffer[2] = hex_asc_lo(sigval);
 			output_buffer[3] = 0;
 			break;
 
-- 
1.5.5.1.350.gbbbf


