Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZHNLoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZHNLoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZHNLoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:44:25 -0400
Received: from www84.your-server.de ([213.133.104.84]:58805 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbZHNLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:44:24 -0400
Subject: [PATCH 4/6] new kfifo API v0.3 - add DEFINE_KFIFO and friends, add
 very tiny functions
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 13:44:22 +0200
Message-Id: <1250250262.19690.95.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 4/6 of the new kfifo API:
 Add KFIFO_INIT - macro to generate a kfifo initializer
 Add DECLARE_KFIFO - macro to declare a kfifo and the associated buffer inside a struct
 Add INIT_KFIFO - macro to initialize a with DECLARE_KFIFO declared kfifo 
 Add DEFINE_KFIFO - macro to define and initialize a kfifo as a global or local object
 Add kfifo_size() - returns the size of the fifo in bytes
 Add kfifo_is_empty() - returns true if the fifo is empty
 Add kfifo_is_full() - returns true if the fifo is full
 Add kfifo_avail() - returns the number of bytes available in the FIFO
 Do some code cleanup

 kfifo.h |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 2 deletions(-)

Signed-off-by: Stefani Seibold <stefani@seibold.net>

diff -u -N -r linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h linux-2.6.31-rc4-kfifo5/include/linux/kfifo.h
--- linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h	2009-08-14 10:48:03.000000000 +0200
+++ linux-2.6.31-rc4-kfifo5/include/linux/kfifo.h	2009-08-14 11:53:52.000000000 +0200
@@ -32,6 +32,56 @@
 	unsigned int out;	/* data is extracted from off. (out % size) */
 };
 
+/*
+ * Macros for declaration and initialization of the kfifo datatype
+ */
+
+/**
+ * KFIFO_INIT - macro to generate a kfifo initializer
+ * @s: size of the fifo buffer
+ * @b: address of the fifo buffer
+ */
+#define KFIFO_INIT(s, b) \
+	(struct kfifo) { \
+		.size	= s, \
+		.in	= 0, \
+		.out	= 0, \
+		.buffer = b \
+	}
+
+/**
+ * DECLARE_KFIFO - macro to declare a kfifo and the associated buffer
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ *
+ * Note: the macro can be used inside struct or union declaration
+ */
+#define DECLARE_KFIFO(name, size) \
+union { \
+	struct kfifo name; \
+	unsigned char name##_buffer[size + sizeof(struct kfifo)]; \
+}
+
+/**
+ * INIT_KFIFO - macro to initialize a with DECLARE_KFIFO declared kfifo
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ */
+#define INIT_KFIFO(name) \
+	name = KFIFO_INIT(sizeof(name##_buffer) - sizeof(struct kfifo), \
+				name##_buffer)
+
+/**
+ * DEFINE_KFIFO - macro to define and initialize a kfifo
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ *
+ * Note: the macro can be used for global and local kfifo data type variables
+ */
+#define DEFINE_KFIFO(name, size) \
+	unsigned char name##_buffer[size]; \
+	struct kfifo name = KFIFO_INIT(size, name##_buffer)
+
 extern void kfifo_init(struct kfifo *fifo,
 			unsigned char *buffer, unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo,
@@ -52,6 +102,15 @@
 }
 
 /**
+ * kfifo_size - returns the size of the fifo in bytes
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check unsigned int kfifo_size(struct kfifo *fifo)
+{
+	return fifo->size;
+}
+
+/**
  * kfifo_len - returns the number of used bytes in the FIFO
  * @fifo: the fifo to be used.
  */
@@ -65,6 +124,33 @@
 }
 
 /**
+ * kfifo_is_empty - returns true if the fifo is empty
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check int kfifo_is_empty(struct kfifo *fifo)
+{
+	return fifo->in == fifo->out;
+}
+
+/**
+ * kfifo_is_full - returns true if the fifo is full
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check int kfifo_is_full(struct kfifo *fifo)
+{
+	return kfifo_len(fifo) == kfifo_size(fifo);
+}
+
+/**
+ * kfifo_avail - returns the number of bytes available in the FIFO
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check unsigned int kfifo_avail(struct kfifo *fifo)
+{
+	return kfifo_size(fifo) - kfifo_len(fifo);
+}
+
+/**
  * kfifo_in_locked - puts some data into the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
  * @from: the data to be added.
@@ -114,8 +200,8 @@
 	 * optimization: if the FIFO is empty, set the indices to 0
 	 * so we don't wrap the next time
 	 */
-	if (fifo->in == fifo->out)
-		fifo->in = fifo->out = 0;
+	if (kfifo_is_empty(fifo))
+		kfifo_reset(fifo);
 
 	spin_unlock_irqrestore(lock, flags);
 


