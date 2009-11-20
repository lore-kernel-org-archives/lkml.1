Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZKTI3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZKTI3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZKTI3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:29:15 -0500
Received: from www84.your-server.de ([213.133.104.84]:38530 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZKTI3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:29:14 -0500
Subject: Re: [PATCH 6/7] kfifo: add kfifo_skip, kfifo_from_user and
 kfifo_to_user
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1258704942.4426.5.camel@wall-e>
References: <1258704942.4426.5.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 20 Nov 2009 09:29:06 +0100
Message-ID: <1258705746.4426.18.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add kfifo_reset_out() for save lockless discard the fifo output
 Add kfifo_skip() to skip a number of output bytes
 Add kfifo_from_user() to copy user space data into the fifo
 Add kfifo_to_user() to copy fifo data to user space

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/kfifo.h |   47 ++++++++++++++++
 kernel/kfifo.c        |  139 ++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 170 insertions(+), 16 deletions(-)

diff -u -N -r -p kfifo5/include/linux/kfifo.h kfifo6/include/linux/kfifo.h
--- kfifo5/include/linux/kfifo.h	2009-11-19 20:54:36.294317779 +0100
+++ kfifo6/include/linux/kfifo.h	2009-11-19 20:54:56.275420767 +0100
@@ -122,6 +122,16 @@ static inline void kfifo_reset(struct kf
 }
 
 /**
+ * kfifo_reset_out - skip FIFO contents
+ * @fifo: the fifo to be emptied.
+ */
+static inline void kfifo_reset_out(struct kfifo *fifo)
+{
+	smp_mb();
+	fifo->out = fifo->in;
+}
+
+/**
  * kfifo_size - returns the size of the fifo in bytes
  * @fifo: the fifo to be used.
  */
@@ -228,4 +238,41 @@ static inline __must_check unsigned int 
 	return ret;
 }
 
+extern void kfifo_skip(struct kfifo *fifo, unsigned int len);
+
+extern __must_check unsigned int kfifo_from_user(struct kfifo *fifo,
+	const void __user *from, unsigned int n);
+
+extern __must_check unsigned int kfifo_to_user(struct kfifo *fifo,
+	void __user *to, unsigned int n);
+
+/**
+ * __kfifo_add_out internal helper function for updating the out offset
+ */
+static inline void __kfifo_add_out(struct kfifo *fifo,
+				unsigned int off)
+{
+	smp_mb();
+	fifo->out += off;
+}
+
+/**
+ * __kfifo_add_in internal helper function for updating the in offset
+ */
+static inline void __kfifo_add_in(struct kfifo *fifo,
+				unsigned int off)
+{
+	smp_wmb();
+	fifo->in += off;
+}
+
+/**
+ * __kfifo_off internal helper function for calculating the index of a
+ * given offeset
+ */
+static inline unsigned int __kfifo_off(struct kfifo *fifo, unsigned int off)
+{
+	return off & (fifo->size - 1);
+}
+
 #endif
diff -u -N -r -p kfifo5/kernel/kfifo.c kfifo6/kernel/kfifo.c
--- kfifo5/kernel/kfifo.c	2009-10-19 21:25:25.763176479 +0200
+++ kfifo6/kernel/kfifo.c	2009-10-19 21:29:14.000000000 +0200
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/kfifo.h>
 #include <linux/log2.h>
+#include <linux/uaccess.h>
 
 static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
 		unsigned int size)
@@ -100,6 +101,21 @@ void kfifo_free(struct kfifo *fifo)
 EXPORT_SYMBOL(kfifo_free);
 
 /**
+ * kfifo_skip - skip output data
+ * @fifo: the fifo to be used.
+ * @len: number of bytes to skip
+ */
+void kfifo_skip(struct kfifo *fifo, unsigned int len)
+{
+	if (len < kfifo_len(fifo)) {
+		__kfifo_add_out(fifo, len);
+		return;
+	}
+	kfifo_reset_out(fifo);
+}
+EXPORT_SYMBOL(kfifo_skip);
+
+/**
  * kfifo_in - puts some data into the FIFO
  * @fifo: the fifo to be used.
  * @from: the data to be added.
@@ -115,6 +131,7 @@ EXPORT_SYMBOL(kfifo_free);
 unsigned int kfifo_in(struct kfifo *fifo,
 			const unsigned char *from, unsigned int len)
 {
+	unsigned int off;
 	unsigned int l;
 
 	len = min(len, fifo->size - fifo->in + fifo->out);
@@ -126,21 +143,16 @@ unsigned int kfifo_in(struct kfifo *fifo
 
 	smp_mb();
 
+	off = __kfifo_off(fifo, fifo->in);
+
 	/* first put the data starting from fifo->in to buffer end */
-	l = min(len, fifo->size - (fifo->in & (fifo->size - 1)));
-	memcpy(fifo->buffer + (fifo->in & (fifo->size - 1)), from, l);
+	l = min(len, fifo->size - off);
+	memcpy(fifo->buffer + off, from, l);
 
 	/* then put the rest (if any) at the beginning of the buffer */
 	memcpy(fifo->buffer, from + l, len - l);
 
-	/*
-	 * Ensure that we add the bytes to the kfifo -before-
-	 * we update the fifo->in index.
-	 */
-
-	smp_wmb();
-
-	fifo->in += len;
+	__kfifo_add_in(fifo, len);
 
 	return len;
 }
@@ -161,6 +173,7 @@ EXPORT_SYMBOL(kfifo_in);
 unsigned int kfifo_out(struct kfifo *fifo,
 			 unsigned char *to, unsigned int len)
 {
+	unsigned int off;
 	unsigned int l;
 
 	len = min(len, fifo->in - fifo->out);
@@ -172,22 +185,116 @@ unsigned int kfifo_out(struct kfifo *fif
 
 	smp_rmb();
 
+	off = __kfifo_off(fifo, fifo->out);
+
 	/* first get the data from fifo->out until the end of the buffer */
-	l = min(len, fifo->size - (fifo->out & (fifo->size - 1)));
-	memcpy(to, fifo->buffer + (fifo->out & (fifo->size - 1)), l);
+	l = min(len, fifo->size - off);
+	memcpy(to, fifo->buffer + off, l);
 
 	/* then get the rest (if any) from the beginning of the buffer */
 	memcpy(to + l, fifo->buffer, len - l);
 
+	__kfifo_add_out(fifo, len);
+
+	return len;
+}
+EXPORT_SYMBOL(kfifo_out);
+
+/**
+ * kfifo_from_user - puts some data from user space into the FIFO
+ * @fifo: the fifo to be used.
+ * @from: pointer to the data to be added.
+ * @len: the length of the data to be added.
+ *
+ * This function copies at most @len bytes from the @from into the
+ * FIFO depending and returns the number of copied bytes.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+unsigned int kfifo_from_user(struct kfifo *fifo,
+	const void __user *from, unsigned int len)
+{
+	unsigned int off;
+	unsigned int l;
+	int ret;
+
+	len = min(len, fifo->size - fifo->in + fifo->out);
+
 	/*
-	 * Ensure that we remove the bytes from the kfifo -before-
-	 * we update the fifo->out index.
+	 * Ensure that we sample the fifo->out index -before- we
+	 * start putting bytes into the kfifo.
 	 */
 
 	smp_mb();
 
-	fifo->out += len;
+	off = __kfifo_off(fifo, fifo->in);
+
+	/* first put the data starting from fifo->in to buffer end */
+	l = min(len, fifo->size - off);
+	ret = copy_from_user(fifo->buffer + off, from, l);
+
+	if (unlikely(ret))
+		return l - ret;
+
+	/* then put the rest (if any) at the beginning of the buffer */
+	ret = copy_from_user(fifo->buffer, from + l, len - l);
+
+	if (unlikely(ret))
+		return len - ret;
+
+	__kfifo_add_in(fifo, len);
 
 	return len;
 }
-EXPORT_SYMBOL(kfifo_out);
+EXPORT_SYMBOL(kfifo_from_user);
+
+/**
+ * kfifo_to_user - gets data from the FIFO and write it to user space
+ * @fifo: the fifo to be used.
+ * @to: where the data must be copied.
+ * @len: the size of the destination buffer.
+ *
+ * This function copies at most @len bytes from the FIFO into the
+ * @to buffer and returns the number of copied bytes.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+unsigned int kfifo_to_user(struct kfifo *fifo,
+	void __user *to, unsigned int len)
+{
+	unsigned int off;
+	unsigned int l;
+	int ret;
+
+	len = min(len, fifo->in - fifo->out);
+
+	/*
+	 * Ensure that we sample the fifo->in index -before- we
+	 * start removing bytes from the kfifo.
+	 */
+
+	smp_rmb();
+
+	off = __kfifo_off(fifo, fifo->out);
+
+	/* first get the data from fifo->out until the end of the buffer */
+	l = min(len, fifo->size - off);
+	ret = copy_to_user(to, fifo->buffer + off, l);
+
+	if (unlikely(ret))
+		return l - ret;
+
+	/* then get the rest (if any) from the beginning of the buffer */
+	ret = copy_to_user(to + l, fifo->buffer, len - l);
+
+	if (unlikely(ret))
+		return len - ret;
+
+	__kfifo_add_out(fifo, len);
+
+	return len;
+}
+EXPORT_SYMBOL(kfifo_to_user);
+


