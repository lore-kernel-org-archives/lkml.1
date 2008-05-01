Return-Path: <linux-kernel-owner+w=401wt.eu-S1764222AbYEATWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764222AbYEATWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYEATWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:22:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:20769 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYEATWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nRFHUw19nrrlb2NVKa8Ig7w+MDeL0AYLGXM3rtUetcIseJsfK9YV0NKa7dusgcaKhGcGJ4NusJoqqtIu3TsZpaCL1GmYsIxETWYH62t36Gr4ygIkg0tVddhzeGWg74n1kPbaO7aoHmx/zPhVN8g59Q67yhF+XcMDi8cSq2YRhKQ=
Subject: [PATCH] kernel: add helpers for ascii character conversion
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 12:23:00 -0700
Message-Id: <1209669780.24729.151.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for getting an ascii hex char for the high and low
nibble of a byte.  Also add a small helper to get an integer
value from a given hex char.

Included here are a few of the current places that roll their
own versions being moved to the common helper.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Maybe I should call this RFC, but people have rolled their own all
over the place in tree, so this should go in somewhere.

 arch/cris/arch-v10/kernel/kgdb.c |   94 +++++++++++---------------------------
 arch/cris/arch-v32/kernel/kgdb.c |   84 +++++++++-------------------------
 drivers/pnp/support.c            |    8 ++--
 include/linux/kernel.h           |   15 ++++++
 lib/hexdump.c                    |    4 +-
 5 files changed, 70 insertions(+), 135 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index a3ca551..149bd03 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -278,17 +278,6 @@ void putDebugChar (int val);
 
 void enableDebugIRQ (void);
 
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static char highhex (int x);
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static char lowhex (int x);
-
-/* Returns the integer equivalent of a hexadecimal character. */
-static int hex (char ch);
-
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
@@ -670,35 +659,6 @@ read_register (char regno, unsigned int *valptr)
 }
 
 /********************************** Packet I/O ******************************/
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static inline char
-highhex(int x)
-{
-	return hexchars[(x >> 4) & 0xf];
-}
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static inline char
-lowhex(int x)
-{
-	return hexchars[x & 0xf];
-}
-
-/* Returns the integer equivalent of a hexadecimal character. */
-static int
-hex (char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return (ch - 'a' + 10);
-	if ((ch >= '0') && (ch <= '9'))
-		return (ch - '0');
-	if ((ch >= 'A') && (ch <= 'F'))
-		return (ch - 'A' + 10);
-	return (-1);
-}
-
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
@@ -721,8 +681,8 @@ mem2hex(char *buf, unsigned char *mem, int count)
                 /* Valid mem address. */
                 for (i = 0; i < count; i++) {
                         ch = *mem++;
-                        *buf++ = highhex (ch);
-                        *buf++ = lowhex (ch);
+                        *buf++ = asc_hex_hi(ch);
+                        *buf++ = asc_hex_lo(ch);
                 }
         }
         
@@ -740,8 +700,8 @@ hex2mem (unsigned char *mem, char *buf, int count)
 	int i;
 	unsigned char ch;
 	for (i = 0; i < count; i++) {
-		ch = hex (*buf++) << 4;
-		ch = ch + hex (*buf++);
+		ch = hex_to_int(*buf++) << 4;
+		ch = ch + hex_to_int(*buf++);
 		*mem++ = ch;
 	}
 	return (mem);
@@ -800,8 +760,8 @@ getpacket (char *buffer)
 		buffer[count] = '\0';
 		
 		if (ch == '#') {
-			xmitcsum = hex (getDebugChar ()) << 4;
-			xmitcsum += hex (getDebugChar ());
+			xmitcsum = hex_to_int(getDebugChar ()) << 4;
+			xmitcsum += hex_to_int(getDebugChar ());
 			if (checksum != xmitcsum) {
 				/* Wrong checksum */
 				putDebugChar ('-');
@@ -858,8 +818,8 @@ putpacket(char *buffer)
 			}
 		}
 		putDebugChar ('#');
-		putDebugChar (highhex (checksum));
-		putDebugChar (lowhex (checksum));
+		putDebugChar(asc_hex_hi(checksum));
+		putDebugChar(asc_hex_lo(checksum));
 	} while(kgdb_started && (getDebugChar() != '+'));
 }
 
@@ -896,8 +856,8 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';	
-	*ptr++ = highhex (sigval);
-	*ptr++ = lowhex (sigval);
+	*ptr++ = asc_hex_hi(sigval);
+	*ptr++ = asc_hex_lo(sigval);
 
 	/* Send register contents. We probably only need to send the
 	 * PC, frame pointer and stack pointer here. Other registers will be
@@ -911,8 +871,8 @@ stub_is_stopped(int sigval)
                 
 		if (status == SUCCESS) {
                         
-                        *ptr++ = highhex (regno);
-                        *ptr++ = lowhex (regno);
+                        *ptr++ = asc_hex_hi(regno);
+                        *ptr++ = asc_hex_lo(regno);
                         *ptr++ = ':';
 
                         ptr = mem2hex(ptr, (unsigned char *)&reg_cont,
@@ -937,8 +897,8 @@ stub_is_stopped(int sigval)
 	/* Store thread:r...; with the executing task TID. */
 	gdb_cris_strcpy (&remcomOutBuffer[pos], "thread:");
 	pos += gdb_cris_strlen ("thread:");
-	remcomOutBuffer[pos++] = highhex (executing_task);
-	remcomOutBuffer[pos++] = lowhex (executing_task);
+	remcomOutBuffer[pos++] = asc_hex_hi(executing_task);
+	remcomOutBuffer[pos++] = asc_hex_lo(executing_task);
 	gdb_cris_strcpy (&remcomOutBuffer[pos], ";");
 #endif
 
@@ -1126,8 +1086,8 @@ handle_exception (int sigval)
 				   Success: SAA, where AA is the signal number.
 				   Failure: void. */
 				remcomOutBuffer[0] = 'S';
-				remcomOutBuffer[1] = highhex (sigval);
-				remcomOutBuffer[2] = lowhex (sigval);
+				remcomOutBuffer[1] = asc_hex_hi(sigval);
+				remcomOutBuffer[2] = asc_hex_lo(sigval);
 				remcomOutBuffer[3] = 0;
 				break;
 				
@@ -1224,23 +1184,23 @@ handle_exception (int sigval)
 						case 'C':
 							/* Identify the remote current thread. */
 							gdb_cris_strcpy (&remcomOutBuffer[0], "QC");
-							remcomOutBuffer[2] = highhex (current_thread_c);
-							remcomOutBuffer[3] = lowhex (current_thread_c);
+							remcomOutBuffer[2] = asc_hex_hi(current_thread_c);
+							remcomOutBuffer[3] = asc_hex_lo(current_thread_c);
 							remcomOutBuffer[4] = '\0';
 							break;
 						case 'L':
 							gdb_cris_strcpy (&remcomOutBuffer[0], "QM");
 							/* Reply with number of threads. */
 							if (os_is_started()) {
-								remcomOutBuffer[2] = highhex (number_of_tasks);
-								remcomOutBuffer[3] = lowhex (number_of_tasks);
+								remcomOutBuffer[2] = asc_hex_hi(number_of_tasks);
+								remcomOutBuffer[3] = asc_hex_lo(number_of_tasks);
 							}
 							else {
-								remcomOutBuffer[2] = highhex (0);
-								remcomOutBuffer[3] = lowhex (1);
+								remcomOutBuffer[2] = asc_hex_hi(0);
+								remcomOutBuffer[3] = asc_hex_lo(1);
 							}
 							/* Done with the reply. */
-							remcomOutBuffer[4] = lowhex (1);
+							remcomOutBuffer[4] = asc_hex_lo(1);
 							pos = 5;
 							/* Expects the argument thread id. */
 							for (; pos < (5 + HEXCHARS_IN_THREAD_ID); pos++)
@@ -1251,16 +1211,16 @@ handle_exception (int sigval)
 								for (thread_id = 0; thread_id < number_of_tasks; thread_id++) {
 									nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
 									for (; pos < nextpos; pos ++)
-										remcomOutBuffer[pos] = lowhex (0);
-									remcomOutBuffer[pos++] = lowhex (thread_id);
+										remcomOutBuffer[pos] = asc_hex_lo(0);
+									remcomOutBuffer[pos++] = asc_hex_lo(thread_id);
 								}
 							}
 							else {
 								/* Store the thread identifier of the boot task. */
 								nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
 								for (; pos < nextpos; pos ++)
-									remcomOutBuffer[pos] = lowhex (0);
-								remcomOutBuffer[pos++] = lowhex (current_thread_c);
+									remcomOutBuffer[pos] = asc_hex_lo(0);
+								remcomOutBuffer[pos++] = asc_hex_lo(current_thread_c);
 							}
 							remcomOutBuffer[pos] = '\0';
 							break;
diff --git a/arch/cris/arch-v32/kernel/kgdb.c b/arch/cris/arch-v32/kernel/kgdb.c
index 4e2e2e2..6831c7f 100644
--- a/arch/cris/arch-v32/kernel/kgdb.c
+++ b/arch/cris/arch-v32/kernel/kgdb.c
@@ -398,17 +398,6 @@ void putDebugChar(int val)
 }
 #endif
 
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static char highhex(int x);
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static char lowhex(int x);
-
-/* Returns the integer equivalent of a hexadecimal character. */
-static int hex(char ch);
-
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
@@ -655,35 +644,6 @@ read_register(char regno, unsigned int *valptr)
 }
 
 /********************************** Packet I/O ******************************/
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static inline char
-highhex(int x)
-{
-	return hexchars[(x >> 4) & 0xf];
-}
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static inline char
-lowhex(int x)
-{
-	return hexchars[x & 0xf];
-}
-
-/* Returns the integer equivalent of a hexadecimal character. */
-static int
-hex(char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return (ch - 'a' + 10);
-	if ((ch >= '0') && (ch <= '9'))
-		return (ch - '0');
-	if ((ch >= 'A') && (ch <= 'F'))
-		return (ch - 'A' + 10);
-	return -1;
-}
-
 /* Convert the memory, pointed to by mem into hexadecimal representation.
    Put the result in buf, and return a pointer to the last character
    in buf (null). */
@@ -704,8 +664,8 @@ mem2hex(char *buf, unsigned char *mem, int count)
                 /* Valid mem address. */
 		for (i = 0; i < count; i++) {
 			ch = *mem++;
-			*buf++ = highhex (ch);
-			*buf++ = lowhex (ch);
+			*buf++ = hex_asc_hi(ch);
+			*buf++ = hex_asc_lo(ch);
 		}
         }
         /* Terminate properly. */
@@ -723,8 +683,8 @@ mem2hex_nbo(char *buf, unsigned char *mem, int count)
 	mem += count - 1;
 	for (i = 0; i < count; i++) {
 		ch = *mem--;
-		*buf++ = highhex (ch);
-		*buf++ = lowhex (ch);
+		*buf++ = hex_asc_hi(ch);
+		*buf++ = hex_asc_lo(ch);
         }
 
         /* Terminate properly. */
@@ -741,8 +701,8 @@ hex2mem(unsigned char *mem, char *buf, int count)
 	int i;
 	unsigned char ch;
 	for (i = 0; i < count; i++) {
-		ch = hex (*buf++) << 4;
-		ch = ch + hex (*buf++);
+		ch = hex_to_int(*buf++) << 4;
+		ch = ch + hex_to_int(*buf++);
 		*mem++ = ch;
 	}
 	return mem;
@@ -806,8 +766,8 @@ getpacket(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(getDebugChar()) << 4;
-			xmitcsum += hex(getDebugChar());
+			xmitcsum = hex_to_int(getDebugChar()) << 4;
+			xmitcsum += hex_to_int(getDebugChar());
 			if (checksum != xmitcsum) {
 				/* Wrong checksum */
 				putDebugChar('-');
@@ -862,8 +822,8 @@ putpacket(char *buffer)
 			}
 		}
 		putDebugChar('#');
-		putDebugChar(highhex (checksum));
-		putDebugChar(lowhex (checksum));
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 	} while(kgdb_started && (getDebugChar() != '+'));
 }
 
@@ -909,8 +869,8 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';
-	*ptr++ = highhex(sigval);
-	*ptr++ = lowhex(sigval);
+	*ptr++ = hex_asc_hi(sigval);
+	*ptr++ = hex_asc_lo(sigval);
 
 	if (((reg.exs & 0xff00) >> 8) == 0xc) {
 
@@ -1018,30 +978,30 @@ stub_is_stopped(int sigval)
 	}
 	/* Only send PC, frame and stack pointer. */
 	read_register(PC, &reg_cont);
-	*ptr++ = highhex(PC);
-	*ptr++ = lowhex(PC);
+	*ptr++ = hex_asc_hi(PC);
+	*ptr++ = hex_asc_lo(PC);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[PC]);
 	*ptr++ = ';';
 
 	read_register(R8, &reg_cont);
-	*ptr++ = highhex(R8);
-	*ptr++ = lowhex(R8);
+	*ptr++ = hex_asc_hi(R8);
+	*ptr++ = hex_asc_lo(R8);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[R8]);
 	*ptr++ = ';';
 
 	read_register(SP, &reg_cont);
-	*ptr++ = highhex(SP);
-	*ptr++ = lowhex(SP);
+	*ptr++ = hex_asc_hi(SP);
+	*ptr++ = hex_asc_lo(SP);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[SP]);
 	*ptr++ = ';';
 
 	/* Send ERP as well; this will save us an entire register fetch in some cases. */
         read_register(ERP, &reg_cont);
-        *ptr++ = highhex(ERP);
-        *ptr++ = lowhex(ERP);
+        *ptr++ = hex_asc_hi(ERP);
+        *ptr++ = hex_asc_lo(ERP);
         *ptr++ = ':';
         ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[ERP]);
         *ptr++ = ';';
@@ -1533,8 +1493,8 @@ handle_exception(int sigval)
 				   Success: SAA, where AA is the signal number.
 				   Failure: void. */
 				output_buffer[0] = 'S';
-				output_buffer[1] = highhex(sigval);
-				output_buffer[2] = lowhex(sigval);
+				output_buffer[1] = hex_asc_hi(sigval);
+				output_buffer[2] = hex_asc_lo(sigval);
 				output_buffer[3] = 0;
 				break;
 
diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 3eba85e..95b076c 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -45,10 +45,10 @@ void pnp_eisa_id_to_string(u32 id, char *str)
 	str[0] = 'A' + ((id >> 26) & 0x3f) - 1;
 	str[1] = 'A' + ((id >> 21) & 0x1f) - 1;
 	str[2] = 'A' + ((id >> 16) & 0x1f) - 1;
-	str[3] = hex_asc((id >> 12) & 0xf);
-	str[4] = hex_asc((id >>  8) & 0xf);
-	str[5] = hex_asc((id >>  4) & 0xf);
-	str[6] = hex_asc((id >>  0) & 0xf);
+	str[3] = hex_asc_hi(id >> 8);
+	str[4] = hex_asc_lo(id >> 8);
+	str[5] = hex_asc_hi(id);
+	str[6] = hex_asc_lo(id);
 	str[7] = '\0';
 }
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4d46e29..63aefcf 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -277,6 +277,21 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			const void *buf, size_t len);
 #define hex_asc(x)	"0123456789abcdef"[x]
+#define hex_asc_lo(x)	hex_asc(((x) & 0x0f))
+#define hex_asc_hi(x)	hex_asc(((x) & 0xf0) >> 4)
+
+static inline u8 hex_to_int(char ch)
+{
+	/*
+	 * Make ch lower-case, works only for digits and letters
+	 */
+	ch |= 0x20;
+	if ((ch >= 'a') && (ch <= 'f'))
+		return (ch - 'a' + 10);
+	if ((ch >= '0') && (ch <= '9'))
+		return (ch - '0');
+	return (-1);
+}
 
 #define pr_emerg(fmt, arg...) \
 	printk(KERN_EMERG fmt, ##arg)
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 3435465..32b0bd7 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -93,8 +93,8 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
 		     j++) {
 			ch = ptr[j];
-			linebuf[lx++] = hex_asc(ch >> 4);
-			linebuf[lx++] = hex_asc(ch & 0x0f);
+			linebuf[lx++] = hex_asc_hi(ch);
+			linebuf[lx++] = hex_asc_lo(ch);
 			linebuf[lx++] = ' ';
 		}
 		ascii_column = 3 * rowsize + 2;
-- 
1.5.5.1.305.g7c84



