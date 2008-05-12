Return-Path: <linux-kernel-owner+w=401wt.eu-S1758452AbYELTJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbYELTJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbYELTF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:05:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:41906 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbYELTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UeV1KkyVrGJnmpgjqN/4M5QNuZDkkz/xAGsAGwbTy0jobMFApw7LEk19EaWI3LFQDd2Op4EzCGgHdispN0XGqnZP92VJM5C2JcbRYqh9t1pZs3gYMQ3u02kUDPCvTH8Ti6GtGztNCcsC9+2W0tWJhbu2LXPPBUuvPRmEC059Cfk=
Subject: [PATCH 10/12] mips: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "ralf@linux-mips.org" <ralf@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:05:43 -0700
Message-Id: <1210619143.24092.61.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mips/kernel/gdb-stub.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/mips/kernel/gdb-stub.c b/arch/mips/kernel/gdb-stub.c
index 25f4eab..5746f74 100644
--- a/arch/mips/kernel/gdb-stub.c
+++ b/arch/mips/kernel/gdb-stub.c
@@ -190,7 +190,6 @@ static char input_buffer[BUFMAX];
 static char output_buffer[BUFMAX];
 static int initialized;	/* !0 means we've been initialized */
 static int kgdb_started;
-static const char hexchars[]="0123456789abcdef";
 
 /* Used to prevent crashes in memory access.  Note that they'll crash anyway if
    we haven't set up fault handlers yet... */
@@ -306,8 +305,8 @@ static void putpacket(char *buffer)
 		}
 
 		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 
 	}
 	while ((getDebugChar() & 0x7f) != '+');
@@ -328,8 +327,7 @@ static unsigned char *mem2hex(char *mem, char *buf, int count, int may_fault)
 	while (count-- > 0) {
 		if (kgdb_read_byte(mem++, &ch) != 0)
 			return 0;
-		*buf++ = hexchars[ch >> 4];
-		*buf++ = hexchars[ch & 0xf];
+		buf = pack_hex_byte(buf, ch);
 	}
 
 	*buf = 0;
@@ -812,14 +810,12 @@ void handle_exception(struct gdb_regs *regs)
 	 * Send trap type (converted to signal)
 	 */
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/*
 	 * Send Error PC
 	 */
-	*ptr++ = hexchars[REG_EPC >> 4];
-	*ptr++ = hexchars[REG_EPC & 0xf];
+	ptr = pack_hex_byte(ptr, REG_EPC);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->cp0_epc, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -827,8 +823,7 @@ void handle_exception(struct gdb_regs *regs)
 	/*
 	 * Send frame pointer
 	 */
-	*ptr++ = hexchars[REG_FP >> 4];
-	*ptr++ = hexchars[REG_FP & 0xf];
+	ptr = pack_hex_byte(ptr, REG_FP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg30, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -836,8 +831,7 @@ void handle_exception(struct gdb_regs *regs)
 	/*
 	 * Send stack pointer
 	 */
-	*ptr++ = hexchars[REG_SP >> 4];
-	*ptr++ = hexchars[REG_SP & 0xf];
+	ptr = pack_hex_byte(ptr, REG_SP);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->reg29, ptr, sizeof(long), 0);
 	*ptr++ = ';';
@@ -856,8 +850,8 @@ void handle_exception(struct gdb_regs *regs)
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
1.5.5.1.404.g981f6


