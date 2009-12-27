Return-Path: <linux-kernel-owner+w=401wt.eu-S1751092AbZL0VDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbZL0VDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZL0VDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:03:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43512 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbZL0VDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:03:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
In-Reply-To: <200912271003.631128760@firstfloor.org>
To: stefani@seibold.net, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [4/6] kfifo: add kfifo_out_peek
Message-Id: <20091227210314.ABA04B17C3@basil.firstfloor.org>
Date: Sun, 27 Dec 2009 22:03:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In some upcoming code it's useful to peek into a FIFO without
permanentely removing data. This patch implements a new 
kfifo_out_peek() to do this. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kfifo.h |    3 +++
 kernel/kfifo.c        |   21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

Index: linux/include/linux/kfifo.h
===================================================================
--- linux.orig/include/linux/kfifo.h
+++ linux/include/linux/kfifo.h
@@ -114,6 +114,9 @@ extern unsigned int kfifo_in(struct kfif
 				const void *from, unsigned int len);
 extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
 				void *to, unsigned int len);
+extern __must_check unsigned int kfifo_out_peek(struct kfifo *fifo,
+				void *to, unsigned int len, unsigned offset);
+
 
 /**
  * kfifo_reset - removes the entire FIFO contents
Index: linux/kernel/kfifo.c
===================================================================
--- linux.orig/kernel/kfifo.c
+++ linux/kernel/kfifo.c
@@ -301,6 +301,27 @@ unsigned int kfifo_out(struct kfifo *fif
 }
 EXPORT_SYMBOL(kfifo_out);
 
+/**
+ * kfifo_out_peek - copy some data from the FIFO, but do not remove it
+ * @fifo: the fifo to be used.
+ * @to: where the data must be copied.
+ * @len: the size of the destination buffer.
+ * @offset: offset into the fifo
+ *
+ * This function copies at most @len bytes at @offset from the FIFO
+ * into the @to buffer and returns the number of copied bytes.
+ * The data is not removed from the FIFO.
+ */
+unsigned int kfifo_out_peek(struct kfifo *fifo, void *to, unsigned int len,
+			    unsigned offset)
+{
+	len = min(kfifo_len(fifo), len + offset);
+
+	__kfifo_out_data(fifo, to, len, offset);
+	return len;
+}
+EXPORT_SYMBOL(kfifo_out_peek);
+
 unsigned int __kfifo_out_generic(struct kfifo *fifo,
 	void *to, unsigned int len, unsigned int recsize,
 	unsigned int *total)
