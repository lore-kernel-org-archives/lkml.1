Return-Path: <linux-kernel-owner+w=401wt.eu-S932990AbYEAXJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbYEAXJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762815AbYEAXFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:05:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:53914 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbYEAXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ERzt8TQh0Hu6hohR7MGeU0Pj1iidgjwin6ahNdL093JM1ms8ES7saGEc2MifHBHSPAgh5zL3qyBQiHsbC3tca3CdWFM35rX42PlDgCF+Khsya3MdKVC7mvq4LdgCQYfbiaIl4yzPhRMaDJY0PeSvh+tSZdjFR4yiE+0EDbKd2zQ=
Subject: [PATCH 9/9] ppc: ppc-stub.c use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:05:39 -0700
Message-Id: <1209683139.24729.211.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/ppc/kernel/ppc-stub.c |   53 ++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/arch/ppc/kernel/ppc-stub.c b/arch/ppc/kernel/ppc-stub.c
index 5f9ee7b..2379f70 100644
--- a/arch/ppc/kernel/ppc-stub.c
+++ b/arch/ppc/kernel/ppc-stub.c
@@ -130,9 +130,6 @@ static int kgdb_started;
 static u_int fault_jmp_buf[100];
 static int kdebug;
 
-
-static const char hexchars[]="0123456789abcdef";
-
 /* Place where we save old trap entries for restoration - sparc*/
 /* struct tt_entry kgdb_savettable[256]; */
 /* typedef void (*trapfunc_t)(void); */
@@ -205,28 +202,26 @@ mem2hex(const char *mem, char *buf, int count)
 		if ((count == 2) && (((long)mem & 1) == 0)) {
 			tmp_s = *(unsigned short *)mem;
 			mem += 2;
-			*buf++ = hexchars[(tmp_s >> 12) & 0xf];
-			*buf++ = hexchars[(tmp_s >> 8) & 0xf];
-			*buf++ = hexchars[(tmp_s >> 4) & 0xf];
-			*buf++ = hexchars[tmp_s & 0xf];
-
+			*buf++ = hex_asc_hi(tmp_s >> 8);
+			*buf++ = hex_asc_lo(tmp_s >> 8);
+			*buf++ = hex_asc_hi(tmp_s);
+			*buf++ = hex_asc_lo(tmp_s);
 		} else if ((count == 4) && (((long)mem & 3) == 0)) {
 			tmp_l = *(unsigned int *)mem;
 			mem += 4;
-			*buf++ = hexchars[(tmp_l >> 28) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 24) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 20) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 16) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 12) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 8) & 0xf];
-			*buf++ = hexchars[(tmp_l >> 4) & 0xf];
-			*buf++ = hexchars[tmp_l & 0xf];
-
+			*buf++ = hex_asc_hi(tmp_l >> 24);
+			*buf++ = hex_asc_lo(tmp_l >> 24);
+			*buf++ = hex_asc_hi(tmp_l >> 16);
+			*buf++ = hex_asc_lo(tmp_l >> 16);
+			*buf++ = hex_asc_hi(tmp_l >> 8);
+			*buf++ = hex_asc_lo(tmp_l >> 8);
+			*buf++ = hex_asc_hi(tmp_l);
+			*buf++ = hex_asc_lo(tmp_l);
 		} else {
 			while (count-- > 0) {
 				ch = *mem++;
-				*buf++ = hexchars[ch >> 4];
-				*buf++ = hexchars[ch & 0xf];
+				*buf++ = hex_asc_hi(ch);
+				*buf++ = hex_asc_lo(ch);
 			}
 		}
 
@@ -411,8 +406,8 @@ static void putpacket(unsigned char *buffer)
 		}
 
 		putDebugChar('#');
-		putDebugChar(hexchars[checksum >> 4]);
-		putDebugChar(hexchars[checksum & 0xf]);
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 		recv = getDebugChar();
 	} while ((recv & 0x7f) != '+');
 }
@@ -602,15 +597,15 @@ handle_exception (struct pt_regs *regs)
 	ptr = remcomOutBuffer;
 
 	*ptr++ = 'T';
-	*ptr++ = hexchars[sigval >> 4];
-	*ptr++ = hexchars[sigval & 0xf];
-	*ptr++ = hexchars[PC_REGNUM >> 4];
-	*ptr++ = hexchars[PC_REGNUM & 0xf];
+	*ptr++ = hex_asc_hi(sigval);
+	*ptr++ = hex_asc_lo(sigval);
+	*ptr++ = hex_asc_hi(PC_REGNUM);
+	*ptr++ = hex_asc_lo(PC_REGNUM);
 	*ptr++ = ':';
 	ptr = mem2hex((char *)&regs->nip, ptr, 4);
 	*ptr++ = ';';
-	*ptr++ = hexchars[SP_REGNUM >> 4];
-	*ptr++ = hexchars[SP_REGNUM & 0xf];
+	*ptr++ = hex_asc_hi(SP_REGNUM);
+	*ptr++ = hex_asc_lo(SP_REGNUM);
 	*ptr++ = ':';
 	ptr = mem2hex(((char *)regs) + SP_REGNUM*4, ptr, 4);
 	*ptr++ = ';';
@@ -632,8 +627,8 @@ handle_exception (struct pt_regs *regs)
 		switch (remcomInBuffer[0]) {
 		case '?': /* report most recent signal */
 			remcomOutBuffer[0] = 'S';
-			remcomOutBuffer[1] = hexchars[sigval >> 4];
-			remcomOutBuffer[2] = hexchars[sigval & 0xf];
+			remcomOutBuffer[1] = hex_asc_hi(sigval);
+			remcomOutBuffer[2] = hex_asc_lo(sigval);
 			remcomOutBuffer[3] = 0;
 			break;
 #if 0
-- 
1.5.5.1.305.g7c84

