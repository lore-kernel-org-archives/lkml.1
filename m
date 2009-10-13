Return-Path: <linux-kernel-owner+w=401wt.eu-S1761109AbZJMTWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109AbZJMTWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934121AbZJMTWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:22:51 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:30823 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZJMTWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:22:48 -0400
Subject: [PATCH v2 3/9] vsprintf: add %pR decoding and %pr for raw struct
	resource
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 13 Oct 2009 13:22:10 -0600
Message-ID: <20091013192210.22336.28703.stgit@bob.kio>
In-Reply-To: <20091013192040.22336.84876.stgit@bob.kio>
References: <20091013192040.22336.84876.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for printing struct resource type and flag information.
For example, "%pR" looks like "[mem 0xf5df0000-0xf5df3fff 64bit pref]",
and "%pr" looks like "[mem 0xff5e2000-0xff5e2007 flags 0x201]".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 lib/vsprintf.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fcbe69d..6438cd5 100644
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
@@ -614,12 +614,29 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		.precision = -1,
 		.flags = 0,
 	};
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
+
 	/* 32-bit res (sizeof==4): 10 chars in dec, 10 in hex ("0x" + 8)
 	 * 64-bit res (sizeof==8): 20 chars in dec, 18 in hex ("0x" + 16) */
-#define RSRC_BUF_SIZE	((2 * sizeof(resource_size_t)) + 4)
-	char sym[2*RSRC_BUF_SIZE + sizeof("[-]")];
+#define RSRC_BUF_SIZE		((2 * sizeof(resource_size_t)) + 4)
+#define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
+#define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref disabled]")
+#define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
+	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
+
 	char *p = sym, *pend = sym + sizeof(sym);
 	int size = -1, addr = 0;
+	int decode = (fmt[0] == 'R') ? 1 : 0;
 
 	if (res->flags & IORESOURCE_IO) {
 		size = IO_RSRC_PRINTK_SIZE;
@@ -630,12 +647,35 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 	}
 
 	*p++ = '[';
+	if (res->flags & IORESOURCE_IO)
+		p = string(p, pend, "io  ", str_spec);
+	else if (res->flags & IORESOURCE_MEM)
+		p = string(p, pend, "mem ", str_spec);
+	else if (res->flags & IORESOURCE_IRQ)
+		p = string(p, pend, "irq ", str_spec);
+	else if (res->flags & IORESOURCE_DMA)
+		p = string(p, pend, "dma ", str_spec);
+	else {
+		p = string(p, pend, "??? ", str_spec);
+		decode = 0;
+	}
 	hex_spec.field_width = size;
 	p = number(p, pend, res->start, addr ? hex_spec : dec_spec);
 	if (res->start != res->end) {
 		*p++ = '-';
 		p = number(p, pend, res->end, addr ? hex_spec : dec_spec);
 	}
+	if (decode) {
+		if (res->flags & IORESOURCE_MEM_64)
+			p = string(p, pend, " 64bit", str_spec);
+		if (res->flags & IORESOURCE_PREFETCH)
+			p = string(p, pend, " pref", str_spec);
+		if (res->flags & IORESOURCE_DISABLED)
+			p = string(p, pend, " disabled", str_spec);
+	} else {
+		p = string(p, pend, " flags ", str_spec);
+		p = number(p, pend, res->flags, flag_spec);
+	}
 	*p++ = ']';
 	*p = '\0';
 
@@ -813,8 +853,8 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
  * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers with offset
  * - 's' For symbolic direct pointers without offset
- * - 'R' For a struct resource pointer, it prints the range of
- *       addresses (not the name nor the flags)
+ * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
+ * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
  * - 'M' For a 6-byte MAC address, it prints the address in the
  *       usual colon-separated hex notation
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
@@ -845,7 +885,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'S':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
-		return resource_string(buf, end, ptr, spec);
+	case 'r':
+		return resource_string(buf, end, ptr, spec, fmt);
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
 		return mac_address_string(buf, end, ptr, spec, fmt);

