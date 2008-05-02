Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbYEBTC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbYEBTC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934804AbYEBTBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:01:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934334AbYEBTBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UlAiQgzsA8tUJ55X/9hxMBwSQR4sRgglc3pCBveGZhrjFCT+V5hY8G/U/PZ81B74JBO6R9qX1MjKnvUNjHgjhZBcRrXtm8o/MFR4S8SNPFb59gvNOyX9wHNLMcwQf/j78vq1BTGTeg3Q2D4aljH60GijuneZnP/tsq5Mgj66LEg=
Subject: [PATCH 03/12] cris: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:52 -0700
Message-Id: <1209754912.26173.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/cris/arch-v10/kernel/kgdb.c |  103 +++++++++++---------------------------
 arch/cris/arch-v32/kernel/kgdb.c |   91 +++++++++------------------------
 2 files changed, 54 insertions(+), 140 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index a3ca551..a40581f 100644
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
@@ -356,9 +345,6 @@ extern unsigned char executing_task;
 /* Run-length encoding maximum length. Send 64 at most. */
 #define RUNLENMAX 64
 
-/* Definition of all valid hexadecimal characters */
-static const char hexchars[] = "0123456789abcdef";
-
 /* The inbound/outbound buffers used in packet I/O */
 static char remcomInBuffer[BUFMAX];
 static char remcomOutBuffer[BUFMAX];
@@ -499,8 +485,8 @@ gdb_cris_strtol (const char *s, char **endptr, int base)
 	char *sd;
 	int x = 0;
 	
-	for (s1 = (char*)s; (sd = gdb_cris_memchr(hexchars, *s1, base)) != NULL; ++s1)
-		x = x * base + (sd - hexchars);
+	for (s1 = (char*)s; (sd = gdb_cris_memchr(hex_asc, *s1, base)) != NULL; ++s1)
+		x = x * base + (sd - hex_asc);
         
         if (endptr)
         {
@@ -670,35 +656,6 @@ read_register (char regno, unsigned int *valptr)
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
@@ -721,8 +678,8 @@ mem2hex(char *buf, unsigned char *mem, int count)
                 /* Valid mem address. */
                 for (i = 0; i < count; i++) {
                         ch = *mem++;
-                        *buf++ = highhex (ch);
-                        *buf++ = lowhex (ch);
+                        *buf++ = hex_asc_hi(ch);
+                        *buf++ = hex_asc_lo(ch);
                 }
         }
         
@@ -740,8 +697,8 @@ hex2mem (unsigned char *mem, char *buf, int count)
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
@@ -800,8 +757,8 @@ getpacket (char *buffer)
 		buffer[count] = '\0';
 		
 		if (ch == '#') {
-			xmitcsum = hex (getDebugChar ()) << 4;
-			xmitcsum += hex (getDebugChar ());
+			xmitcsum = hex_to_int(getDebugChar()) << 4;
+			xmitcsum += hex_to_int(getDebugChar());
 			if (checksum != xmitcsum) {
 				/* Wrong checksum */
 				putDebugChar ('-');
@@ -857,9 +814,9 @@ putpacket(char *buffer)
 				src++;
 			}
 		}
-		putDebugChar ('#');
-		putDebugChar (highhex (checksum));
-		putDebugChar (lowhex (checksum));
+		putDebugChar('#');
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 	} while(kgdb_started && (getDebugChar() != '+'));
 }
 
@@ -896,8 +853,8 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';	
-	*ptr++ = highhex (sigval);
-	*ptr++ = lowhex (sigval);
+	*ptr++ = hex_asc_hi(sigval);
+	*ptr++ = hex_asc_lo(sigval);
 
 	/* Send register contents. We probably only need to send the
 	 * PC, frame pointer and stack pointer here. Other registers will be
@@ -911,8 +868,8 @@ stub_is_stopped(int sigval)
                 
 		if (status == SUCCESS) {
                         
-                        *ptr++ = highhex (regno);
-                        *ptr++ = lowhex (regno);
+                        *ptr++ = hex_asc_hi(regno);
+                        *ptr++ = hex_asc_lo(regno);
                         *ptr++ = ':';
 
                         ptr = mem2hex(ptr, (unsigned char *)&reg_cont,
@@ -937,8 +894,8 @@ stub_is_stopped(int sigval)
 	/* Store thread:r...; with the executing task TID. */
 	gdb_cris_strcpy (&remcomOutBuffer[pos], "thread:");
 	pos += gdb_cris_strlen ("thread:");
-	remcomOutBuffer[pos++] = highhex (executing_task);
-	remcomOutBuffer[pos++] = lowhex (executing_task);
+	remcomOutBuffer[pos++] = hex_asc_hi(executing_task);
+	remcomOutBuffer[pos++] = hex_asc_lo(executing_task);
 	gdb_cris_strcpy (&remcomOutBuffer[pos], ";");
 #endif
 
@@ -1126,8 +1083,8 @@ handle_exception (int sigval)
 				   Success: SAA, where AA is the signal number.
 				   Failure: void. */
 				remcomOutBuffer[0] = 'S';
-				remcomOutBuffer[1] = highhex (sigval);
-				remcomOutBuffer[2] = lowhex (sigval);
+				remcomOutBuffer[1] = hex_asc_hi(sigval);
+				remcomOutBuffer[2] = hex_asc_lo(sigval);
 				remcomOutBuffer[3] = 0;
 				break;
 				
@@ -1224,23 +1181,23 @@ handle_exception (int sigval)
 						case 'C':
 							/* Identify the remote current thread. */
 							gdb_cris_strcpy (&remcomOutBuffer[0], "QC");
-							remcomOutBuffer[2] = highhex (current_thread_c);
-							remcomOutBuffer[3] = lowhex (current_thread_c);
+							remcomOutBuffer[2] = hex_asc_hi(current_thread_c);
+							remcomOutBuffer[3] = hex_asc_lo(current_thread_c);
 							remcomOutBuffer[4] = '\0';
 							break;
 						case 'L':
 							gdb_cris_strcpy (&remcomOutBuffer[0], "QM");
 							/* Reply with number of threads. */
 							if (os_is_started()) {
-								remcomOutBuffer[2] = highhex (number_of_tasks);
-								remcomOutBuffer[3] = lowhex (number_of_tasks);
+								remcomOutBuffer[2] = hex_asc_hi(number_of_tasks);
+								remcomOutBuffer[3] = hex_asc_lo(number_of_tasks);
 							}
 							else {
-								remcomOutBuffer[2] = highhex (0);
-								remcomOutBuffer[3] = lowhex (1);
+								remcomOutBuffer[2] = hex_asc_hi(0);
+								remcomOutBuffer[3] = hex_asc_lo(1);
 							}
 							/* Done with the reply. */
-							remcomOutBuffer[4] = lowhex (1);
+							remcomOutBuffer[4] = hex_asc_lo(1);
 							pos = 5;
 							/* Expects the argument thread id. */
 							for (; pos < (5 + HEXCHARS_IN_THREAD_ID); pos++)
@@ -1251,16 +1208,16 @@ handle_exception (int sigval)
 								for (thread_id = 0; thread_id < number_of_tasks; thread_id++) {
 									nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
 									for (; pos < nextpos; pos ++)
-										remcomOutBuffer[pos] = lowhex (0);
-									remcomOutBuffer[pos++] = lowhex (thread_id);
+										remcomOutBuffer[pos] = hex_asc_lo(0);
+									remcomOutBuffer[pos++] = hex_asc_lo(thread_id);
 								}
 							}
 							else {
 								/* Store the thread identifier of the boot task. */
 								nextpos = pos + HEXCHARS_IN_THREAD_ID - 1;
 								for (; pos < nextpos; pos ++)
-									remcomOutBuffer[pos] = lowhex (0);
-								remcomOutBuffer[pos++] = lowhex (current_thread_c);
+									remcomOutBuffer[pos] = hex_asc_lo(0);
+								remcomOutBuffer[pos++] = hex_asc_lo(current_thread_c);
 							}
 							remcomOutBuffer[pos] = '\0';
 							break;
diff --git a/arch/cris/arch-v32/kernel/kgdb.c b/arch/cris/arch-v32/kernel/kgdb.c
index 4e2e2e2..8d0dae9 100644
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
@@ -464,9 +453,6 @@ void breakpoint(void);
 /* Run-length encoding maximum length. Send 64 at most. */
 #define RUNLENMAX 64
 
-/* Definition of all valid hexadecimal characters */
-static const char hexchars[] = "0123456789abcdef";
-
 /* The inbound/outbound buffers used in packet I/O */
 static char input_buffer[BUFMAX];
 static char output_buffer[BUFMAX];
@@ -550,8 +536,8 @@ gdb_cris_strtol(const char *s, char **endptr, int base)
 	char *sd;
 	int x = 0;
 
-	for (s1 = (char*)s; (sd = gdb_cris_memchr(hexchars, *s1, base)) != NULL; ++s1)
-		x = x * base + (sd - hexchars);
+	for (s1 = (char*)s; (sd = gdb_cris_memchr(hex_asc, *s1, base)) != NULL; ++s1)
+		x = x * base + (sd - hex_asc);
 
         if (endptr) {
                 /* Unconverted suffix is stored in endptr unless endptr is NULL. */
@@ -655,35 +641,6 @@ read_register(char regno, unsigned int *valptr)
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
@@ -704,8 +661,8 @@ mem2hex(char *buf, unsigned char *mem, int count)
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
@@ -723,8 +680,8 @@ mem2hex_nbo(char *buf, unsigned char *mem, int count)
 	mem += count - 1;
 	for (i = 0; i < count; i++) {
 		ch = *mem--;
-		*buf++ = highhex (ch);
-		*buf++ = lowhex (ch);
+		*buf++ = hex_asc_hi(ch);
+		*buf++ = hex_asc_lo(ch);
         }
 
         /* Terminate properly. */
@@ -741,8 +698,8 @@ hex2mem(unsigned char *mem, char *buf, int count)
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
@@ -806,8 +763,8 @@ getpacket(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(getDebugChar()) << 4;
-			xmitcsum += hex(getDebugChar());
+			xmitcsum = hex_to_int(getDebugChar()) << 4;
+			xmitcsum += hex_to_int(getDebugChar());
 			if (checksum != xmitcsum) {
 				/* Wrong checksum */
 				putDebugChar('-');
@@ -862,8 +819,8 @@ putpacket(char *buffer)
 			}
 		}
 		putDebugChar('#');
-		putDebugChar(highhex (checksum));
-		putDebugChar(lowhex (checksum));
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 	} while(kgdb_started && (getDebugChar() != '+'));
 }
 
@@ -909,8 +866,8 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';
-	*ptr++ = highhex(sigval);
-	*ptr++ = lowhex(sigval);
+	*ptr++ = hex_asc_hi(sigval);
+	*ptr++ = hex_asc_lo(sigval);
 
 	if (((reg.exs & 0xff00) >> 8) == 0xc) {
 
@@ -1018,30 +975,30 @@ stub_is_stopped(int sigval)
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
@@ -1533,8 +1490,8 @@ handle_exception(int sigval)
 				   Success: SAA, where AA is the signal number.
 				   Failure: void. */
 				output_buffer[0] = 'S';
-				output_buffer[1] = highhex(sigval);
-				output_buffer[2] = lowhex(sigval);
+				output_buffer[1] = hex_asc_hi(sigval);
+				output_buffer[2] = hex_asc_lo(sigval);
 				output_buffer[3] = 0;
 				break;
 
-- 
1.5.5.1.350.gbbbf


