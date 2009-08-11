Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZHKWcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZHKWcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZHKWcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:32:02 -0400
Received: from www84.your-server.de ([213.133.104.84]:36407 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbZHKWcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:32:00 -0400
Subject: [PATCH 5/7] new kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 00:32:00 +0200
Message-Id: <1250029920.17599.103.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfifo.h |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

Signed-off-by: Stefani Seibold <stefani@seibold.net>

diff -u -N -r linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h linux-2.6.31-rc4-kfifo5/include/linux/kfifo.h
--- linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h	2009-08-11 22:14:19.000000000 +0200
+++ linux-2.6.31-rc4-kfifo5/include/linux/kfifo.h	2009-08-11 22:53:29.000000000 +0200
@@ -32,6 +32,28 @@
 	unsigned int out;	/* data is extracted from off. (out % size) */
 };
 
+#define KFIFO_INIT(s, b) \
+	(struct kfifo) { \
+		.size	= s, \
+		.in	= 0, \
+		.out	= 0, \
+		.buffer = b \
+	}
+
+
+#define DECLARE_KFIFO(name, size) \
+union { \
+	struct kfifo name; \
+	unsigned char name##_buffer[size + sizeof(struct kfifo)]; \
+}
+
+#define DEFINE_KFIFO(name, size) \
+	DECLARE_KFIFO(name, size) = KFIFO_INIT(name, size)
+
+#define INIT_KFIFO(name) \
+	name = KFIFO_INIT(sizeof(name##_buffer) - sizeof(struct kfifo), \
+				name##_buffer)
+
 extern void kfifo_init(struct kfifo *fifo,
 			unsigned char *buffer, unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo,
@@ -52,6 +74,24 @@
 }
 
 /**
+ * kfifo_reset_in - skip input FIFO contents
+ * @fifo: the fifo to be emptied.
+ */
+static inline void kfifo_reset_in(struct kfifo *fifo)
+{
+	fifo->in = fifo->out;
+}
+
+/**
+ * kfifo_reset_in - skip output FIFO contents
+ * @fifo: the fifo to be emptied.
+ */
+static inline void kfifo_reset_out(struct kfifo *fifo)
+{
+	fifo->out = fifo->in;
+}
+
+/**
  * kfifo_in_locked - puts some data into the FIFO using a spinlock for locking
  * @fifo: the fifo to be used.
  * @buffer: the data to be added.
@@ -122,4 +162,40 @@
 	return fifo->in - out;
 }
 
+/**
+ * kfifo_size - returns the size of the fifo in bytes
+ * @fifo: the fifo to be used.
+ */
+static inline __must_check unsigned int kfifo_size(struct kfifo *fifo)
+{
+	return fifo->size;
+}
+
+/**
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
 #endif


