Return-Path: <linux-kernel-owner+w=401wt.eu-S936688AbYEBTE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936688AbYEBTE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965041AbYEBTBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:01:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964996AbYEBTBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b5Nm08DZ5ncMOlvuSBVieAsMHvge6jjAumlUOOVW5GL3xotOQQMOYCp0LgF4LrVA94OUQSCtm1poW37S7iq2bSs53EeDd0jM9UqLcEEAebtoB8CahyR+2PZ6/yIP+HSLgKODH0PQQOX8nYZbdNS6avE/fp5N4GZ58YV2fMZLtWg=
Subject: [PATCH 09/12] ppc: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:55 -0700
Message-Id: <1209754915.26173.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/powerpc/kernel/btext.c     |   34 +++++++++++-------------
 arch/powerpc/kernel/prom_init.c |    3 +-
 arch/ppc/kernel/ppc-stub.c      |   53 +++++++++++++++++---------------------
 arch/ppc/syslib/btext.c         |   18 ++++++-------
 arch/ppc/xmon/start_8xx.c       |    2 +-
 5 files changed, 50 insertions(+), 60 deletions(-)

diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 9f93777..c72c85e 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -443,28 +443,26 @@ void btext_drawtext(const char *c, unsigned int len)
 
 void btext_drawhex(unsigned long v)
 {
-	char *hex_table = "0123456789abcdef";
-
 	if (!boot_text_mapped)
 		return;
 #ifdef CONFIG_PPC64
-	btext_drawchar(hex_table[(v >> 60) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 56) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 52) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 48) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 44) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 40) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 36) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 32) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 56));
+	btext_drawchar(hex_asc_lo(v >> 56));
+	btext_drawchar(hex_asc_hi(v >> 48));
+	btext_drawchar(hex_asc_lo(v >> 48));
+	btext_drawchar(hex_asc_hi(v >> 40));
+	btext_drawchar(hex_asc_lo(v >> 40));
+	btext_drawchar(hex_asc_hi(v >> 32));
+	btext_drawchar(hex_asc_lo(v >> 32));
 #endif
-	btext_drawchar(hex_table[(v >> 28) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 24) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 20) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 16) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 12) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  8) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  4) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  0) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 24));
+	btext_drawchar(hex_asc_lo(v >> 24));
+	btext_drawchar(hex_asc_hi(v >> 16));
+	btext_drawchar(hex_asc_lo(v >> 16));
+	btext_drawchar(hex_asc_hi(v >> 8));
+	btext_drawchar(hex_asc_lo(v >> 8));
+	btext_drawchar(hex_asc_hi(v));
+	btext_drawchar(hex_asc_lo(v));
 	btext_drawchar(' ');
 }
 
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 6d6df1e..c5aa96e 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -453,7 +453,6 @@ static void add_string(char **str, const char *q)
 
 static char *tohex(unsigned int x)
 {
-	static char digits[] = "0123456789abcdef";
 	static char result[9];
 	int i;
 
@@ -461,7 +460,7 @@ static char *tohex(unsigned int x)
 	i = 8;
 	do {
 		--i;
-		result[i] = digits[x & 0xf];
+		result[i] = hex_asc_lo(x);
 		x >>= 4;
 	} while (x != 0 && i > 0);
 	return &result[i];
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
diff --git a/arch/ppc/syslib/btext.c b/arch/ppc/syslib/btext.c
index d116670..f1af035 100644
--- a/arch/ppc/syslib/btext.c
+++ b/arch/ppc/syslib/btext.c
@@ -391,18 +391,16 @@ btext_drawstring(const char *c)
 void BTEXT
 btext_drawhex(unsigned long v)
 {
-	static char hex_table[] = "0123456789abcdef";
-
 	if (!boot_text_mapped)
 		return;
-	btext_drawchar(hex_table[(v >> 28) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 24) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 20) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 16) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >> 12) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  8) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  4) & 0x0000000FUL]);
-	btext_drawchar(hex_table[(v >>  0) & 0x0000000FUL]);
+	btext_drawchar(hex_asc_hi(v >> 24));
+	btext_drawchar(hex_asc_lo(v >> 24));
+	btext_drawchar(hex_asc_hi(v >> 16));
+	btext_drawchar(hex_asc_lo(v >> 16));
+	btext_drawchar(hex_asc_hi(v >> 8));
+	btext_drawchar(hex_asc_lo(v >> 8));
+	btext_drawchar(hex_asc_hi(v));
+	btext_drawchar(hex_asc_lo(v));
 	btext_drawchar(' ');
 }
 
diff --git a/arch/ppc/xmon/start_8xx.c b/arch/ppc/xmon/start_8xx.c
index 3097406..207fd5c 100644
--- a/arch/ppc/xmon/start_8xx.c
+++ b/arch/ppc/xmon/start_8xx.c
@@ -273,7 +273,7 @@ prom_drawhex(uint val)
 	int i;
 	for (i = 7;  i >= 0;  i--)
 	{
-		buf[i] = "0123456789abcdef"[val & 0x0f];
+		buf[i] = hex_asc_lo(val);
 		val >>= 4;
 	}
 	buf[8] = '\0';
-- 
1.5.5.1.350.gbbbf


