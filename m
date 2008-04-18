Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbYDRMdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbYDRMdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYDRMdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:33:40 -0400
Received: from www.tglx.de ([62.245.132.106]:36887 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYDRMdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:33:39 -0400
Date: Fri, 18 Apr 2008 14:33:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] ftrace: simplify hex print
Message-ID: <alpine.LFD.1.10.0804181430310.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simplify hex to ascii conversion with a lookup table.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/trace/trace.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

Index: linux/kernel/trace/trace.c
===================================================================
--- linux.orig/kernel/trace/trace.c
+++ linux/kernel/trace/trace.c
@@ -248,19 +248,18 @@ trace_seq_putmem(struct trace_seq *s, vo
 }
 
 #define HEX_CHARS 17
+static const char hex2asc[] = "0123456789abcdef";
 
 static int
 trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 {
 	unsigned char hex[HEX_CHARS];
-	unsigned char *data;
+	unsigned char *data = mem;
 	unsigned char byte;
 	int i, j;
 
 	BUG_ON(len >= HEX_CHARS);
 
-	data = mem;
-
 #ifdef __BIG_ENDIAN
 	for (i = 0, j = 0; i < len; i++) {
 #else
@@ -268,22 +267,10 @@ trace_seq_putmem_hex(struct trace_seq *s
 #endif
 		byte = data[i];
 
-		hex[j]   = byte & 0x0f;
-		if (hex[j] >= 10)
-			hex[j] += 'a' - 10;
-		else
-			hex[j] += '0';
-		j++;
-
-		hex[j] = byte >> 4;
-		if (hex[j] >= 10)
-			hex[j] += 'a' - 10;
-		else
-			hex[j] += '0';
-		j++;
+		hex[j++] = hex2asc[byte & 0x0f];
+		hex[j++] = hex2asc[byte >> 4];
 	}
-	hex[j] = ' ';
-	j++;
+	hex[j++] = ' ';
 
 	return trace_seq_putmem(s, hex, j);
 }
