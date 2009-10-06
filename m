Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbZJFVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbZJFVeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933445AbZJFVeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:18 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:14093 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442AbZJFVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:16 -0400
Subject: [PATCH 3/7] vsprintf: add %pRt, %pRf to print struct resource details
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:33:39 -0600
Message-ID: <20091006213339.4272.93907.stgit@bob.kio>
In-Reply-To: <20091006213259.4272.68068.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for printing struct resource type and flag information.
For example, "%pRt" looks like "[mem 0x80080000000-0x8008001ffff 64bit pref]",
and "%pRf" looks like "[mem 0xff5e2000-0xff5e2007 pref flags 0x1]".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 lib/vsprintf.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1b60aed..a6e1951 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -595,7 +595,7 @@ static char *symbol_string(char *buf, char *end, void *ptr,
 }
 
 static char *resource_string(char *buf, char *end, struct resource *res,
-				struct printf_spec spec)
+				struct printf_spec spec, const char *fmt)
 {
 #ifndef IO_RSRC_PRINTK_SIZE
 #define IO_RSRC_PRINTK_SIZE	6
@@ -614,9 +614,21 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		.precision = -1,
 		.flags = 0,
 	};
-	/* room for two actual numbers (decimal or hex), the two "0x", -, [, ]
-	 * and the final zero */
-	char sym[2*3*sizeof(resource_size_t) + 8];
+	struct printf_spec str_spec = {
+		.field_width = -1,
+		.precision = 10,
+		.flags = LEFT,
+	};
+	struct printf_spec flag_spec = {
+		.base = 16,
+		.precision = -1,
+		.flags = SPECIAL | SMALL,
+	};
+	/*
+	 * room for three actual numbers (decimal or hex), plus
+	 * "[mem 0x-0x 64bit pref disabled flags 0x]\0"
+	 */
+	char sym[3*3*sizeof(resource_size_t) + 41];
 	char *p = sym, *pend = sym + sizeof(sym);
 	int size = -1, addr = 0;
 
@@ -629,12 +641,35 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 	}
 
 	*p++ = '[';
+	if (fmt[1] == 't' || fmt[1] == 'f') {
+		if (res->flags & IORESOURCE_IO)
+			p = string(p, pend, "io  ", str_spec);
+		else if (res->flags & IORESOURCE_MEM)
+			p = string(p, pend, "mem ", str_spec);
+		else if (res->flags & IORESOURCE_IRQ)
+			p = string(p, pend, "irq ", str_spec);
+		else if (res->flags & IORESOURCE_DMA)
+			p = string(p, pend, "dma ", str_spec);
+	}
 	hex_spec.field_width = size;
 	p = number(p, pend, res->start, addr ? hex_spec : dec_spec);
 	if (res->start != res->end) {
 		*p++ = '-';
 		p = number(p, pend, res->end, addr ? hex_spec : dec_spec);
 	}
+	if (fmt[1] == 't' || fmt[1] == 'f') {
+		if (res->flags & IORESOURCE_MEM_64)
+			p = string(p, pend, " 64bit", str_spec);
+		if (res->flags & IORESOURCE_PREFETCH)
+			p = string(p, pend, " pref", str_spec);
+		if (res->flags & IORESOURCE_DISABLED)
+			p = string(p, pend, " disabled", str_spec);
+		if (fmt[1] == 'f') {
+			p = string(p, pend, " flags ", str_spec);
+			p = number(p, pend, res->flags & ~IORESOURCE_TYPE_BITS,
+				   flag_spec);
+		}
+	}
 	*p++ = ']';
 	*p = 0;
 
@@ -812,8 +847,10 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
- * - 'R' For a struct resource pointer, it prints the range of
- *       addresses (not the name nor the flags)
+ * - 'R' For a struct resource pointer, print:
+ *       R   address range only ([0x0-0x1f])
+ *       Rt  type and range ([mem 0x0-0x1f 64bit pref])
+ *       Rf  type, range, and flags ([mem 0x0-0x1f 64bit pref flags 0x1])
  * - 'M' For a 6-byte MAC address, it prints the address in the
  *       usual colon-separated hex notation
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
@@ -844,7 +881,7 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
-		return resource_string(buf, end, ptr, spec);
+		return resource_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
 		return mac_address_string(buf, end, ptr, spec, fmt);

