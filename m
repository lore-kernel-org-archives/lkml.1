Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZHSVDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZHSVDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 17:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZHSVDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 17:03:39 -0400
Received: from www84.your-server.de ([213.133.104.84]:52404 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZHSVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 17:03:38 -0400
Subject: Re: [PATCH 5/7] kfifo: add DEFINE_KFIFO and friends, add very tiny
 functions
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <1250714990.13476.3.camel@wall-e>
References: <1250714990.13476.3.camel@wall-e>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 23:03:11 +0200
Message-Id: <1250715791.13476.17.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add DECLARE_KFIFO - macro to declare a kfifo and the associated buffer inside a struct
 Add INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
 Add DEFINE_KFIFO - macro to define and initialize a kfifo as a global or local object
 Add kfifo_size() - returns the size of the fifo in bytes
 Add kfifo_is_empty() - returns true if the fifo is empty
 Add kfifo_is_full() - returns true if the fifo is full
 Add kfifo_avail() - returns the number of bytes available in the FIFO
 Do some code cleanup

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 include/linux/kfifo.h |   47 ++++++++++++++++
 kernel/kfifo.c        |  139 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 170 insertions(+), 16 deletions(-)

diff -u -N -r linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h linux-2.6.31-rc4-kfifo5/include/linux/kfifo.h
--- linux-2.6.31-rc4-kfifo4/include/linux/kfifo.h	2009-08-19 22:38:10.000000000 +0200
+++ linux-2.6.31-rc4-kfifo5/include/linux/kfifo.h	2009-08-17 17:26:39.000000000 +0200
@@ -51,6 +51,57 @@
 	unsigned int out;	/* data is extracted from off. (out % size) */
 };
 
+/*
+ * Macros for declaration and initialization of the kfifo datatype
+ */
+
+#define __kfifo_initializer(s, b) \
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
+ * Note: the macro creates two objects:
+ *  A kfifo object with the given name and a buffer for the kfifo
+ *  object named name##kfifo_buffer
+ */
+#define DECLARE_KFIFO(name, size) \
+union { \
+	struct kfifo name; \
+	unsigned char name##kfifo_buffer[size + sizeof(struct kfifo)]; \
+}
+
+/**
+ * INIT_KFIFO - Initialize a kfifo declared by DECLARED_KFIFO
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ */
+#define INIT_KFIFO(name) \
+	name = __kfifo_initializer(sizeof(name##kfifo_buffer) - \
+				sizeof(struct kfifo), name##kfifo_buffer)
+
+/**
+ * DEFINE_KFIFO - macro to define and initialize a kfifo
+ * @name: name of the declared kfifo datatype
+ * @size: size of the fifo buffer
+ *
+ * Note: the macro can be used for global and local kfifo data type variables
+ * Note: the macro creates two objects:
+ *  A kfifo object with the given name and a buffer for the kfifo
+ *  object named name##kfifo_buffer
+ */
+#define DEFINE_KFIFO(name, size) \
+	unsigned char name##kfifo_buffer[size]; \
+	struct kfifo name = __kfifo_initializer(size, name##kfifo_buffer)
+
 extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
@@ -71,6 +122,15 @@
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
@@ -84,6 +144,33 @@
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
@@ -133,8 +220,8 @@
 	 * optimization: if the FIFO is empty, set the indices to 0
 	 * so we don't wrap the next time
 	 */
-	if (fifo->in == fifo->out)
-		fifo->in = fifo->out = 0;
+	if (kfifo_is_empty(fifo))
+		kfifo_reset(fifo);
 
 	spin_unlock_irqrestore(lock, flags);
 


