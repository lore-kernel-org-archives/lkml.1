Return-Path: <linux-kernel-owner+w=401wt.eu-S1751145AbZGBEOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145AbZGBEOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 00:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZGBEO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 00:14:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:52822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZGBEO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 00:14:29 -0400
Message-ID: <4A4C3410.8080704@kernel.org>
Date: Wed, 01 Jul 2009 21:14:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: printk regression?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   75.690022] <7>printing local APIC contents on CPU#0/0:
[   75.704406] ... APIC ID:      00000000 (0)
[   75.707905] ... APIC VERSION: 00060015
[   75.722551] ... APIC TASKPRI: 00000000 (00)
[   75.725473] ... APIC PROCPRI: 00000000
[   75.728592] ... APIC LDR: 00000001
[   75.742137] ... APIC SPIV: 000001ff
[   75.744101] ... APIC ISR field:
[   75.746648] 0123456789abcdef0123456789abcdef
[   75.746649] <7>00000000000000000000000000000000
[   75.774075] 00000000000000000000000000000000
[   75.784750] 00000000000000000000000000000000
[   75.795441] 00000000000000000000000000000000
[   75.805870] 00000000000000000000000000000000
[   75.817110] 00000000000000000000000000000000
[   75.827522] 00000000000000000000000000000000
[   75.836998] 00000000000000000000000000000000
[   75.848060] ... APIC TMR field:
[   75.849677] 0123456789abcdef0123456789abcdef
[   75.849678] <7>00000000000000000000000000000000
[   75.870185] 00000000000000000000000000000000
[   75.881238] 00000000000000000000000000000000
[   75.891653] 00000000000000000000000000000000
[   75.902632] 00000000000000000000000000000000
[   75.913418] 00000000000000000000000000000000
[   75.923295] 00000000000000000000000000000000
[   75.934364] 00000000000000000000000000000000
[   75.945550] ... APIC IRR field:
[   75.948346] 0123456789abcdef0123456789abcdef
[   75.948347] <7>00000000000000000000000000000000
[   75.968152] 00000000000000000000000000000000
[   75.979004] 00000000000000000000000000000000
[   75.990312] 00000000000000000000000000000000
[   76.001879] 00000000000000000000000000000000
[   76.012855] 00000000000000000000000000000000
[   76.024529] 00000000000000000000000000000000
[   76.034353] 00000000000000010000000000000000

got extra <7>

seems caused by:

commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jun 16 10:57:02 2009 -0700

    printk: clean up handling of log-levels and newlines
    
    It used to be that we would only look at the log-level in a printk()
    after explicit newlines, which can cause annoying problems when the
    previous printk() did not end with a '\n'. In that case, the log-level
    marker would be just printed out in the middle of the line, and be
    seen as just noise rather than change the logging level.
    
    This changes things to always look at the log-level in the first
    bytes of the printout. If a log level marker is found, it is always
    used as the log-level. Additionally, if no newline existed, one is
    added (unless the log-level is the explicit KERN_CONT marker, to
    explicitly show that it's a continuation of a previous line).
    
    Acked-by: Arjan van de Ven <arjan@infradead.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..a87770c 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -687,20 +687,33 @@ asmlinkage int vprintk(const char *fmt, va_list args)
                                  sizeof(printk_buf) - printed_len, fmt, args);
 
 
+       p = printk_buf;
+
+       /* Do we have a loglevel in the string? */
+       if (p[0] == '<') {
+               unsigned char c = p[1];
+               if (c && p[2] == '>') {
+                       switch (c) {
+                       case '0' ... '7': /* loglevel */
+                               current_log_level = c - '0';
+                               if (!new_text_line) {
+                                       emit_log_char('\n');
+                                       new_text_line = 1;
+                               }
+                       /* Fallthrough - skip the loglevel */
+                       case 'c': /* KERN_CONT */
+                               p += 3;
+                               break;
+                       }
+               }
+       }
+
        /*
         * Copy the output into log_buf.  If the caller didn't provide
         * appropriate log level tags, we insert them here
         */
-       for (p = printk_buf; *p; p++) {
+       for ( ; *p; p++) {
                if (new_text_line) {
-                       /* If a token, set current_log_level and skip over */
-                       if (p[0] == '<' && p[1] >= '0' && p[1] <= '7' &&
-                           p[2] == '>') {
-                               current_log_level = p[1] - '0';
-                               p += 3;
-                               printed_len -= 3;
-                       }
-
                        /* Always output the token */
                        emit_log_char('<');
                        emit_log_char(current_log_level + '0');

