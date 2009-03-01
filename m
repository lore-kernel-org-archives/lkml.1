Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbZCAOJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbZCAOJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZCAOJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:09:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:13084 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZCAOJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:09:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=lr8TGB/qEG/gVcQJnMqVdqJKo9JBKcvXrbktefsV9M9j09ttBxOnTTMUIDPV0cq78r
         LsArjFMkGU4pfiyG4VhVARdgU0OBaIi+z7KNETe3D8Irpq9Kdj5fSI4r9KYRK2AubPtR
         RhxAuA1SdoO4f0T9sOtJObEUdAClhi2OkSOVg=
Date: Sun, 1 Mar 2009 16:09:14 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] x86: count errors in testmmiotrace.ko
Message-ID: <20090301160914.568a4d16@daedalus.pq.iki.fi>
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e4f0af96ad7507fce1229d46dc68cbc09a5b61d3 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 22 Feb 2009 13:35:56 +0200
Subject: [PATCH] x86: count errors in testmmiotrace.ko

Check the read values against the written values in the MMIO read/write
test. This test shows if the given MMIO test area really works as
memory, which is a prerequisite for a successful mmiotrace test.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/testmmiotrace.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index ab50a8d..4b29f3b 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -1,5 +1,5 @@
 /*
- * Written by Pekka Paalanen, 2008 <pq@iki.fi>
+ * Written by Pekka Paalanen, 2008-2009 <pq@iki.fi>
  */
 #include <linux/module.h>
 #include <linux/io.h>
@@ -11,28 +11,51 @@ static unsigned long mmio_address;
 module_param(mmio_address, ulong, 0);
 MODULE_PARM_DESC(mmio_address, "Start address of the mapping of 16 kB.");
 
+static unsigned v16(unsigned i)
+{
+	return i * 12 + 7;
+}
+
+static unsigned v32(unsigned i)
+{
+	return i * 212371 + 13;
+}
+
 static void do_write_test(void __iomem *p)
 {
 	unsigned int i;
 	mmiotrace_printk("Write test.\n");
+
 	for (i = 0; i < 256; i++)
 		iowrite8(i, p + i);
+
 	for (i = 1024; i < (5 * 1024); i += 2)
-		iowrite16(i * 12 + 7, p + i);
+		iowrite16(v16(i), p + i);
+
 	for (i = (5 * 1024); i < (16 * 1024); i += 4)
-		iowrite32(i * 212371 + 13, p + i);
+		iowrite32(v32(i), p + i);
 }
 
 static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
+	unsigned errs[3] = { 0 };
 	mmiotrace_printk("Read test.\n");
+
 	for (i = 0; i < 256; i++)
-		ioread8(p + i);
+		if (ioread8(p + i) != i)
+			++errs[0];
+
 	for (i = 1024; i < (5 * 1024); i += 2)
-		ioread16(p + i);
+		if (ioread16(p + i) != v16(i))
+			++errs[1];
+
 	for (i = (5 * 1024); i < (16 * 1024); i += 4)
-		ioread32(p + i);
+		if (ioread32(p + i) != v32(i))
+			++errs[2];
+
+	mmiotrace_printk("Read errors: 8-bit %d, 16-bit %d, 32-bit %d.\n",
+						errs[0], errs[1], errs[2]);
 }
 
 static void do_test(void)
-- 
1.6.0.6

