Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbYELTHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbYELTHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbYELTFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:05:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:41906 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbYELTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:05:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VED5Wa47RyjJjzhVhfIEymEWXQ5Cf9IymnmEASalMgZ5+gXepUFxcOd0HEGM2FymDEYOcJspFbwbjsZOCvO8Ds3Ml55JvcjCo6csiiLqfis/WUWcSm98FJ1i+3tDDXIoxUie+S6MCOarRdkm8Xis1EIEFQuIBNpgJCXaE2ipUs8=
Subject: [PATCH 07/12] cris: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:05:40 -0700
Message-Id: <1210619140.24092.58.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/cris/arch-v10/kernel/kgdb.c |   79 +++++++++++--------------------------
 arch/cris/arch-v32/kernel/kgdb.c |   60 ++++++----------------------
 2 files changed, 37 insertions(+), 102 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index a3ca551..6fea45f 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -278,14 +278,6 @@ void putDebugChar (int val);
 
 void enableDebugIRQ (void);
 
-/* Returns the character equivalent of a nibble, bit 7, 6, 5, and 4 of a byte,
-   represented by int x. */
-static char highhex (int x);
-
-/* Returns the character equivalent of a nibble, bit 3, 2, 1, and 0 of a byte,
-   represented by int x. */
-static char lowhex (int x);
-
 /* Returns the integer equivalent of a hexadecimal character. */
 static int hex (char ch);
 
@@ -356,9 +348,6 @@ extern unsigned char executing_task;
 /* Run-length encoding maximum length. Send 64 at most. */
 #define RUNLENMAX 64
 
-/* Definition of all valid hexadecimal characters */
-static const char hexchars[] = "0123456789abcdef";
-
 /* The inbound/outbound buffers used in packet I/O */
 static char remcomInBuffer[BUFMAX];
 static char remcomOutBuffer[BUFMAX];
@@ -499,8 +488,8 @@ gdb_cris_strtol (const char *s, char **endptr, int base)
 	char *sd;
 	int x = 0;
 	
-	for (s1 = (char*)s; (sd = gdb_cris_memchr(hexchars, *s1, base)) != NULL; ++s1)
-		x = x * base + (sd - hexchars);
+	for (s1 = (char*)s; (sd = gdb_cris_memchr(hex_asc, *s1, base)) != NULL; ++s1)
+		x = x * base + (sd - hex_asc);
         
         if (endptr)
         {
@@ -670,22 +659,6 @@ read_register (char regno, unsigned int *valptr)
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
 /* Returns the integer equivalent of a hexadecimal character. */
 static int
 hex (char ch)
@@ -721,8 +694,7 @@ mem2hex(char *buf, unsigned char *mem, int count)
                 /* Valid mem address. */
                 for (i = 0; i < count; i++) {
                         ch = *mem++;
-                        *buf++ = highhex (ch);
-                        *buf++ = lowhex (ch);
+			buf = pack_hex_byte(buf, ch);
                 }
         }
         
@@ -857,9 +829,9 @@ putpacket(char *buffer)
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
 
@@ -895,9 +867,8 @@ stub_is_stopped(int sigval)
         
 	/* Send trap type (converted to signal) */
 
-	*ptr++ = 'T';	
-	*ptr++ = highhex (sigval);
-	*ptr++ = lowhex (sigval);
+	*ptr++ = 'T';
+	ptr = pack_hex_byte(ptr, sigval);
 
 	/* Send register contents. We probably only need to send the
 	 * PC, frame pointer and stack pointer here. Other registers will be
@@ -910,9 +881,7 @@ stub_is_stopped(int sigval)
                 status = read_register (regno, &reg_cont);
                 
 		if (status == SUCCESS) {
-                        
-                        *ptr++ = highhex (regno);
-                        *ptr++ = lowhex (regno);
+			ptr = pack_hex_byte(ptr, regno);
                         *ptr++ = ':';
 
                         ptr = mem2hex(ptr, (unsigned char *)&reg_cont,
@@ -937,8 +906,8 @@ stub_is_stopped(int sigval)
 	/* Store thread:r...; with the executing task TID. */
 	gdb_cris_strcpy (&remcomOutBuffer[pos], "thread:");
 	pos += gdb_cris_strlen ("thread:");
-	remcomOutBuffer[pos++] = highhex (executing_task);
-	remcomOutBuffer[pos++] = lowhex (executing_task);
+	remcomOutBuffer[pos++] = hex_asc_hi(executing_task);
+	remcomOutBuffer[pos++] = hex_asc_lo(executing_task);
 	gdb_cris_strcpy (&remcomOutBuffer[pos], ";");
 #endif
 
@@ -1126,8 +1095,8 @@ handle_exception (int sigval)
 				   Success: SAA, where AA is the signal number.
 				   Failure: void. */
 				remcomOutBuffer[0] = 'S';
-				remcomOutBuffer[1] = highhex (sigval);
-				remcomOutBuffer[2] = lowhex (sigval);
+				remcomOutBuffer[1] = hex_asc_hi(sigval);
+				remcomOutBuffer[2] = hex_asc_lo(sigval);
 				remcomOutBuffer[3] = 0;
 				break;
 				
@@ -1224,23 +1193,23 @@ handle_exception (int sigval)
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
@@ -1251,16 +1220,16 @@ handle_exception (int sigval)
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
index 4e2e2e2..8bd5a5b 100644
--- a/arch/cris/arch-v32/kernel/kgdb.c
+++ b/arch/cris/arch-v32/kernel/kgdb.c
@@ -398,14 +398,6 @@ void putDebugChar(int val)
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
 /* Returns the integer equivalent of a hexadecimal character. */
 static int hex(char ch);
 
@@ -464,9 +456,6 @@ void breakpoint(void);
 /* Run-length encoding maximum length. Send 64 at most. */
 #define RUNLENMAX 64
 
-/* Definition of all valid hexadecimal characters */
-static const char hexchars[] = "0123456789abcdef";
-
 /* The inbound/outbound buffers used in packet I/O */
 static char input_buffer[BUFMAX];
 static char output_buffer[BUFMAX];
@@ -550,8 +539,8 @@ gdb_cris_strtol(const char *s, char **endptr, int base)
 	char *sd;
 	int x = 0;
 
-	for (s1 = (char*)s; (sd = gdb_cris_memchr(hexchars, *s1, base)) != NULL; ++s1)
-		x = x * base + (sd - hexchars);
+	for (s1 = (char*)s; (sd = gdb_cris_memchr(hex_asc, *s1, base)) != NULL; ++s1)
+		x = x * base + (sd - hex_asc);
 
         if (endptr) {
                 /* Unconverted suffix is stored in endptr unless endptr is NULL. */
@@ -655,22 +644,6 @@ read_register(char regno, unsigned int *valptr)
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
 /* Returns the integer equivalent of a hexadecimal character. */
 static int
 hex(char ch)
@@ -704,8 +677,7 @@ mem2hex(char *buf, unsigned char *mem, int count)
                 /* Valid mem address. */
 		for (i = 0; i < count; i++) {
 			ch = *mem++;
-			*buf++ = highhex (ch);
-			*buf++ = lowhex (ch);
+			buf = pack_hex_byte(buf, ch);
 		}
         }
         /* Terminate properly. */
@@ -723,8 +695,7 @@ mem2hex_nbo(char *buf, unsigned char *mem, int count)
 	mem += count - 1;
 	for (i = 0; i < count; i++) {
 		ch = *mem--;
-		*buf++ = highhex (ch);
-		*buf++ = lowhex (ch);
+		buf = pack_hex_byte(buf, ch);
         }
 
         /* Terminate properly. */
@@ -862,8 +833,8 @@ putpacket(char *buffer)
 			}
 		}
 		putDebugChar('#');
-		putDebugChar(highhex (checksum));
-		putDebugChar(lowhex (checksum));
+		putDebugChar(hex_asc_hi(checksum));
+		putDebugChar(hex_asc_lo(checksum));
 	} while(kgdb_started && (getDebugChar() != '+'));
 }
 
@@ -909,8 +880,7 @@ stub_is_stopped(int sigval)
 	/* Send trap type (converted to signal) */
 
 	*ptr++ = 'T';
-	*ptr++ = highhex(sigval);
-	*ptr++ = lowhex(sigval);
+	ptr = pack_hex_byte(ptr, sigval);
 
 	if (((reg.exs & 0xff00) >> 8) == 0xc) {
 
@@ -1018,30 +988,26 @@ stub_is_stopped(int sigval)
 	}
 	/* Only send PC, frame and stack pointer. */
 	read_register(PC, &reg_cont);
-	*ptr++ = highhex(PC);
-	*ptr++ = lowhex(PC);
+	ptr = pack_hex_byte(PC);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[PC]);
 	*ptr++ = ';';
 
 	read_register(R8, &reg_cont);
-	*ptr++ = highhex(R8);
-	*ptr++ = lowhex(R8);
+	ptr = pack_hex_byte(R8);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[R8]);
 	*ptr++ = ';';
 
 	read_register(SP, &reg_cont);
-	*ptr++ = highhex(SP);
-	*ptr++ = lowhex(SP);
+	ptr = pack_hex_byte(SP);
 	*ptr++ = ':';
 	ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[SP]);
 	*ptr++ = ';';
 
 	/* Send ERP as well; this will save us an entire register fetch in some cases. */
         read_register(ERP, &reg_cont);
-        *ptr++ = highhex(ERP);
-        *ptr++ = lowhex(ERP);
+	ptr = pack_hex_byte(ERP);
         *ptr++ = ':';
         ptr = mem2hex(ptr, (unsigned char *)&reg_cont, register_size[ERP]);
         *ptr++ = ';';
@@ -1533,8 +1499,8 @@ handle_exception(int sigval)
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
1.5.5.1.404.g981f6


