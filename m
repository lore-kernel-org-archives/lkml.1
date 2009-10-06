Return-Path: <linux-kernel-owner+w=401wt.eu-S933475AbZJFVge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbZJFVge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933274AbZJFVgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:36:33 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39151 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391AbZJFVeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:11 -0400
Subject: [PATCH 2/7] vsprintf: add %pR support for IRQ and DMA resources
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:33:34 -0600
Message-ID: <20091006213334.4272.31517.stgit@bob.kio>
In-Reply-To: <20091006213259.4272.68068.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print addresses (IO port numbers and memory addresses) in hex, but print
others (IRQs and DMA channels) in decimal.  Only print the end if it's
different from the start.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 lib/vsprintf.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7830576..1b60aed 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -604,26 +604,37 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 #ifndef MEM_RSRC_PRINTK_SIZE
 #define MEM_RSRC_PRINTK_SIZE	10
 #endif
-	struct printf_spec num_spec = {
+	struct printf_spec hex_spec = {
 		.base = 16,
 		.precision = -1,
 		.flags = SPECIAL | SMALL | ZEROPAD,
 	};
-	/* room for the actual numbers, the two "0x", -, [, ] and the final zero */
-	char sym[4*sizeof(resource_size_t) + 8];
+	struct printf_spec dec_spec = {
+		.base = 10,
+		.precision = -1,
+		.flags = 0,
+	};
+	/* room for two actual numbers (decimal or hex), the two "0x", -, [, ]
+	 * and the final zero */
+	char sym[2*3*sizeof(resource_size_t) + 8];
 	char *p = sym, *pend = sym + sizeof(sym);
-	int size = -1;
+	int size = -1, addr = 0;
 
-	if (res->flags & IORESOURCE_IO)
+	if (res->flags & IORESOURCE_IO) {
 		size = IO_RSRC_PRINTK_SIZE;
-	else if (res->flags & IORESOURCE_MEM)
+		addr = 1;
+	} else if (res->flags & IORESOURCE_MEM) {
 		size = MEM_RSRC_PRINTK_SIZE;
+		addr = 1;
+	}
 
 	*p++ = '[';
-	num_spec.field_width = size;
-	p = number(p, pend, res->start, num_spec);
-	*p++ = '-';
-	p = number(p, pend, res->end, num_spec);
+	hex_spec.field_width = size;
+	p = number(p, pend, res->start, addr ? hex_spec : dec_spec);
+	if (res->start != res->end) {
+		*p++ = '-';
+		p = number(p, pend, res->end, addr ? hex_spec : dec_spec);
+	}
 	*p++ = ']';
 	*p = 0;
 

