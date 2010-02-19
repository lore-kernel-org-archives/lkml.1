Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0BSR6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:58:36 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37473 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab0BSR6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:58:34 -0500
Subject: [PATCH v1 3/7] vsprintf: move %pR resource printf_specs off the stack
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 19 Feb 2010 10:58:33 -0700
Message-ID: <20100219175833.9199.24884.stgit@bob.kio>
In-Reply-To: <20100219175655.9199.30691.stgit@bob.kio>
References: <20100219175655.9199.30691.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds separate I/O and memory specs, so we don't have to change the
field width in a shared spec, which then lets us make all the specs const
and static, since they never change.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 lib/vsprintf.c |   45 ++++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 21 deletions(-)


diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 212d047..9ed3976 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -597,22 +597,29 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 #ifndef MEM_RSRC_PRINTK_SIZE
 #define MEM_RSRC_PRINTK_SIZE	10
 #endif
-	struct printf_spec hex_spec = {
+	static const struct printf_spec io_spec = {
 		.base = 16,
+		.field_width = IO_RSRC_PRINTK_SIZE,
 		.precision = -1,
 		.flags = SPECIAL | SMALL | ZEROPAD,
 	};
-	struct printf_spec dec_spec = {
+	static const struct printf_spec mem_spec = {
+		.base = 16,
+		.field_width = MEM_RSRC_PRINTK_SIZE,
+		.precision = -1,
+		.flags = SPECIAL | SMALL | ZEROPAD,
+	};
+	static const struct printf_spec dec_spec = {
 		.base = 10,
 		.precision = -1,
 		.flags = 0,
 	};
-	struct printf_spec str_spec = {
+	static const struct printf_spec str_spec = {
 		.field_width = -1,
 		.precision = 10,
 		.flags = LEFT,
 	};
-	struct printf_spec flag_spec = {
+	static const struct printf_spec flag_spec = {
 		.base = 16,
 		.precision = -1,
 		.flags = SPECIAL | SMALL,
@@ -628,35 +635,31 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);
-	int size = -1, addr = 0;
 	int decode = (fmt[0] == 'R') ? 1 : 0;
-
-	if (res->flags & IORESOURCE_IO) {
-		size = IO_RSRC_PRINTK_SIZE;
-		addr = 1;
-	} else if (res->flags & IORESOURCE_MEM) {
-		size = MEM_RSRC_PRINTK_SIZE;
-		addr = 1;
-	}
+	const struct printf_spec *specp;
 
 	*p++ = '[';
-	if (res->flags & IORESOURCE_IO)
+	if (res->flags & IORESOURCE_IO) {
 		p = string(p, pend, "io  ", str_spec);
-	else if (res->flags & IORESOURCE_MEM)
+		specp = &io_spec;
+	} else if (res->flags & IORESOURCE_MEM) {
 		p = string(p, pend, "mem ", str_spec);
-	else if (res->flags & IORESOURCE_IRQ)
+		specp = &mem_spec;
+	} else if (res->flags & IORESOURCE_IRQ) {
 		p = string(p, pend, "irq ", str_spec);
-	else if (res->flags & IORESOURCE_DMA)
+		specp = &dec_spec;
+	} else if (res->flags & IORESOURCE_DMA) {
 		p = string(p, pend, "dma ", str_spec);
-	else {
+		specp = &dec_spec;
+	} else {
 		p = string(p, pend, "??? ", str_spec);
+		specp = &mem_spec;
 		decode = 0;
 	}
-	hex_spec.field_width = size;
-	p = number(p, pend, res->start, addr ? hex_spec : dec_spec);
+	p = number(p, pend, res->start, *specp);
 	if (res->start != res->end) {
 		*p++ = '-';
-		p = number(p, pend, res->end, addr ? hex_spec : dec_spec);
+		p = number(p, pend, res->end, *specp);
 	}
 	if (decode) {
 		if (res->flags & IORESOURCE_MEM_64)

