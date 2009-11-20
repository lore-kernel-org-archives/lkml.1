Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZKTIdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZKTIdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZKTIdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:33:21 -0500
Received: from www84.your-server.de ([213.133.104.84]:58548 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZKTIdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:33:20 -0500
Subject: Re: [PATCH 7/7] kfifo: add record handling functions
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
Date: Fri, 20 Nov 2009 09:33:08 +0100
Message-ID: <1258705988.4426.22.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Add kfifo_in_rec() - puts some record data into the FIFO
 Add kfifo_out_rec() - gets some record data from the FIFO
 Add kfifo_from_user_rec() - puts some data from user space into the FIFO
 Add kfifo_to_user_rec() - gets data from the FIFO and write it to user space
 Add kfifo_peek_rec() - gets the size of the next FIFO record field
 Add kfifo_skip_rec() - skip the next fifo out record
 Add kfifo_avail_rec() - determinate the number of bytes available in a record FIFO

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/kfifo.h |  328 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/kfifo.c        |  286 +++++++++++++++++++++++++++++--------------
 2 files changed, 521 insertions(+), 93 deletions(-)

diff -u -N -r -p kfifo6/include/linux/kfifo.h kfifo7/include/linux/kfifo.h
--- kfifo6/include/linux/kfifo.h	2009-11-19 20:54:56.275420767 +0100
+++ kfifo7/include/linux/kfifo.h	2009-11-19 20:55:16.596339811 +0100
@@ -275,4 +275,332 @@ static inline unsigned int __kfifo_off(s
 	return off & (fifo->size - 1);
 }
 
+/**
+ * __kfifo_peek_n internal helper function for determinate the length of
+ * the next record in the fifo
+ */
+static inline unsigned int __kfifo_peek_n(struct kfifo *fifo,
+				unsigned int recsize)
+{
+#define __KFIFO_GET(fifo, off, shift) \
+	((fifo)->buffer[__kfifo_off((fifo), (fifo)->out+(off))] << (shift))
+
+	unsigned int l;
+
+	l = __KFIFO_GET(fifo, 0, 0);
+
+	if (--recsize)
+		l |= __KFIFO_GET(fifo, 1, 8);
+
+	return l;
+}
+
+/**
+ * __kfifo_poke_n internal helper function for storing the length of
+ * the next record into the fifo
+ */
+static inline void __kfifo_poke_n(struct kfifo *fifo,
+			unsigned int recsize, unsigned int n)
+{
+#define __KFIFO_PUT(fifo, off, val, shift) \
+		( \
+		(fifo)->buffer[__kfifo_off((fifo), (fifo)->in+(off))] = \
+		(unsigned char)((val) >> (shift)) \
+		)
+
+	__KFIFO_PUT(fifo, 0, n, 0);
+
+	if (--recsize)
+		__KFIFO_PUT(fifo, 1, n, 8);
+}
+
+/**
+ * __kfifo_in_... internal functions for put date into the fifo
+ * do not call it directly, use kfifo_in_rec() instead
+ */
+extern unsigned int __kfifo_in_n(struct kfifo *fifo,
+	const void *from, unsigned int n, unsigned int recsize);
+
+extern unsigned int __kfifo_in_generic(struct kfifo *fifo,
+	const void *from, unsigned int n, unsigned int recsize);
+
+static inline unsigned int __kfifo_in_rec(struct kfifo *fifo,
+	const void *from, unsigned int n, unsigned int recsize)
+{
+	unsigned int ret;
+
+	ret = __kfifo_in_n(fifo, from, n, recsize);
+
+	if (likely(ret == 0)) {
+		if (recsize)
+			__kfifo_poke_n(fifo, recsize, n);
+		__kfifo_add_in(fifo, n + recsize);
+	}
+	return ret;
+}
+
+/**
+ * kfifo_in_rec - puts some record data into the FIFO
+ * @fifo: the fifo to be used.
+ * @from: the data to be added.
+ * @n: the length of the data to be added.
+ * @recsize: size of record field
+ *
+ * This function copies @n bytes from the @from into the FIFO and returns
+ * the number of bytes which cannot be copied.
+ * A returned value greater than the @n value means that the record doesn't
+ * fit into the buffer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+static inline __must_check unsigned int kfifo_in_rec(struct kfifo *fifo,
+	void *from, unsigned int n, unsigned int recsize)
+{
+	if (!__builtin_constant_p(recsize))
+		return __kfifo_in_generic(fifo, from, n, recsize);
+	return __kfifo_in_rec(fifo, from, n, recsize);
+}
+
+/**
+ * __kfifo_out_... internal functions for get date from the fifo
+ * do not call it directly, use kfifo_out_rec() instead
+ */
+extern unsigned int __kfifo_out_n(struct kfifo *fifo,
+	void *to, unsigned int reclen, unsigned int recsize);
+
+extern unsigned int __kfifo_out_generic(struct kfifo *fifo,
+	void *to, unsigned int n,
+	unsigned int recsize, unsigned int *total);
+
+static inline unsigned int __kfifo_out_rec(struct kfifo *fifo,
+	void *to, unsigned int n, unsigned int recsize,
+	unsigned int *total)
+{
+	unsigned int l;
+
+	if (!recsize) {
+		l = n;
+		if (total)
+			*total = l;
+	} else {
+		l = __kfifo_peek_n(fifo, recsize);
+		if (total)
+			*total = l;
+		if (n < l)
+			return l;
+	}
+
+	return __kfifo_out_n(fifo, to, l, recsize);
+}
+
+/**
+ * kfifo_out_rec - gets some record data from the FIFO
+ * @fifo: the fifo to be used.
+ * @to: where the data must be copied.
+ * @n: the size of the destination buffer.
+ * @recsize: size of record field
+ * @total: pointer where the total number of to copied bytes should stored
+ *
+ * This function copies at most @n bytes from the FIFO to @to and returns the
+ * number of bytes which cannot be copied.
+ * A returned value greater than the @n value means that the record doesn't
+ * fit into the @to buffer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+static inline __must_check unsigned int kfifo_out_rec(struct kfifo *fifo,
+	void *to, unsigned int n, unsigned int recsize,
+	unsigned int *total)
+
+{
+	if (!__builtin_constant_p(recsize))
+		return __kfifo_out_generic(fifo, to, n, recsize, total);
+	return __kfifo_out_rec(fifo, to, n, recsize, total);
+}
+
+/**
+ * __kfifo_from_user_... internal functions for transfer from user space into
+ * the fifo. do not call it directly, use kfifo_from_user_rec() instead
+ */
+extern unsigned int __kfifo_from_user_n(struct kfifo *fifo,
+	const void __user *from, unsigned int n, unsigned int recsize);
+
+extern unsigned int __kfifo_from_user_generic(struct kfifo *fifo,
+	const void __user *from, unsigned int n, unsigned int recsize);
+
+static inline unsigned int __kfifo_from_user_rec(struct kfifo *fifo,
+	const void __user *from, unsigned int n, unsigned int recsize)
+{
+	unsigned int ret;
+
+	ret = __kfifo_from_user_n(fifo, from, n, recsize);
+
+	if (likely(ret == 0)) {
+		if (recsize)
+			__kfifo_poke_n(fifo, recsize, n);
+		__kfifo_add_in(fifo, n + recsize);
+	}
+	return ret;
+}
+
+/**
+ * kfifo_from_user_rec - puts some data from user space into the FIFO
+ * @fifo: the fifo to be used.
+ * @from: pointer to the data to be added.
+ * @n: the length of the data to be added.
+ * @recsize: size of record field
+ *
+ * This function copies @n bytes from the @from into the
+ * FIFO and returns the number of bytes which cannot be copied.
+ *
+ * If the returned value is equal or less the @n value, the copy_from_user()
+ * functions has failed. Otherwise the record doesn't fit into the buffer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+static inline __must_check unsigned int kfifo_from_user_rec(struct kfifo *fifo,
+	const void __user *from, unsigned int n, unsigned int recsize)
+{
+	if (!__builtin_constant_p(recsize))
+		return __kfifo_from_user_generic(fifo, from, n, recsize);
+	return __kfifo_from_user_rec(fifo, from, n, recsize);
+}
+
+/**
+ * __kfifo_to_user_... internal functions for transfer fifo data into user space
+ * do not call it directly, use kfifo_to_user_rec() instead
+ */
+extern unsigned int __kfifo_to_user_n(struct kfifo *fifo,
+	void __user *to, unsigned int n, unsigned int reclen,
+	unsigned int recsize);
+
+extern unsigned int __kfifo_to_user_generic(struct kfifo *fifo,
+	void __user *to, unsigned int n, unsigned int recsize,
+	unsigned int *total);
+
+static inline unsigned int __kfifo_to_user_rec(struct kfifo *fifo,
+	void __user *to, unsigned int n,
+	unsigned int recsize, unsigned int *total)
+{
+	unsigned int l;
+
+	if (!recsize) {
+		l = n;
+		if (total)
+			*total = l;
+	} else {
+		l = __kfifo_peek_n(fifo, recsize);
+		if (total)
+			*total = l;
+		if (n < l)
+			return l;
+	}
+
+	return __kfifo_to_user_n(fifo, to, n, l, recsize);
+}
+
+/**
+ * kfifo_to_user_rec - gets data from the FIFO and write it to user space
+ * @fifo: the fifo to be used.
+ * @to: where the data must be copied.
+ * @n: the size of the destination buffer.
+ * @recsize: size of record field
+ * @total: pointer where the total number of to copied bytes should stored
+ *
+ * This function copies at most @n bytes from the FIFO to the @to.
+ * In case of an error, the function returns the number of bytes which cannot
+ * be copied.
+ * If the returned value is equal or less the @n value, the copy_to_user()
+ * functions has failed. Otherwise the record doesn't fit into the @to buffer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+static inline __must_check unsigned int kfifo_to_user_rec(struct kfifo *fifo,
+		void __user *to, unsigned int n, unsigned int recsize,
+		unsigned int *total)
+{
+	if (!__builtin_constant_p(recsize))
+		return __kfifo_to_user_generic(fifo, to, n, recsize, total);
+	return __kfifo_to_user_rec(fifo, to, n, recsize, total);
+}
+
+/**
+ * __kfifo_peek_... internal functions for peek into the next fifo record
+ * do not call it directly, use kfifo_peek_rec() instead
+ */
+extern unsigned int __kfifo_peek_generic(struct kfifo *fifo,
+				unsigned int recsize);
+
+/**
+ * kfifo_peek_rec - gets the size of the next FIFO record data
+ * @fifo: the fifo to be used.
+ * @recsize: size of record field
+ *
+ * This function returns the size of the next FIFO record in number of bytes
+ */
+static inline __must_check unsigned int kfifo_peek_rec(struct kfifo *fifo,
+	unsigned int recsize)
+{
+	if (!__builtin_constant_p(recsize))
+		return __kfifo_peek_generic(fifo, recsize);
+	if (!recsize)
+		return kfifo_len(fifo);
+	return __kfifo_peek_n(fifo, recsize);
+}
+
+/**
+ * __kfifo_skip_... internal functions for skip the next fifo record
+ * do not call it directly, use kfifo_skip_rec() instead
+ */
+extern void __kfifo_skip_generic(struct kfifo *fifo, unsigned int recsize);
+
+static inline void __kfifo_skip_rec(struct kfifo *fifo,
+	unsigned int recsize)
+{
+	unsigned int l;
+
+	if (recsize) {
+		l = __kfifo_peek_n(fifo, recsize);
+
+		if (l + recsize <= kfifo_len(fifo)) {
+			__kfifo_add_out(fifo, l + recsize);
+			return;
+		}
+	}
+	kfifo_reset_out(fifo);
+}
+
+/**
+ * kfifo_skip_rec - skip the next fifo out record
+ * @fifo: the fifo to be used.
+ * @recsize: size of record field
+ *
+ * This function skips the next FIFO record
+ */
+static inline void kfifo_skip_rec(struct kfifo *fifo,
+	unsigned int recsize)
+{
+	if (!__builtin_constant_p(recsize))
+		__kfifo_skip_generic(fifo, recsize);
+	else
+		__kfifo_skip_rec(fifo, recsize);
+}
+
+/**
+ * kfifo_avail_rec - returns the number of bytes available in a record FIFO
+ * @fifo: the fifo to be used.
+ * @recsize: size of record field
+ */
+static inline __must_check unsigned int kfifo_avail_rec(struct kfifo *fifo,
+	unsigned int recsize)
+{
+	unsigned int l = kfifo_size(fifo) - kfifo_len(fifo);
+
+	return (l > recsize) ? l - recsize : 0;
+}
+
 #endif
diff -u -N -r -p kfifo6/kernel/kfifo.c kfifo7/kernel/kfifo.c
--- kfifo6/kernel/kfifo.c	2009-10-19 21:29:14.000000000 +0200
+++ kfifo7/kernel/kfifo.c	2009-10-19 21:41:44.508999764 +0200
@@ -115,27 +115,11 @@ void kfifo_skip(struct kfifo *fifo, unsi
 }
 EXPORT_SYMBOL(kfifo_skip);
 
-/**
- * kfifo_in - puts some data into the FIFO
- * @fifo: the fifo to be used.
- * @from: the data to be added.
- * @len: the length of the data to be added.
- *
- * This function copies at most @len bytes from the @from buffer into
- * the FIFO depending on the free space, and returns the number of
- * bytes copied.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-unsigned int kfifo_in(struct kfifo *fifo,
-			const unsigned char *from, unsigned int len)
+static inline void __kfifo_in_data(struct kfifo *fifo,
+		const void *from, unsigned int len, unsigned int off)
 {
-	unsigned int off;
 	unsigned int l;
 
-	len = min(len, fifo->size - fifo->in + fifo->out);
-
 	/*
 	 * Ensure that we sample the fifo->out index -before- we
 	 * start putting bytes into the kfifo.
@@ -143,7 +127,7 @@ unsigned int kfifo_in(struct kfifo *fifo
 
 	smp_mb();
 
-	off = __kfifo_off(fifo, fifo->in);
+	off = __kfifo_off(fifo, fifo->in + off);
 
 	/* first put the data starting from fifo->in to buffer end */
 	l = min(len, fifo->size - off);
@@ -151,33 +135,13 @@ unsigned int kfifo_in(struct kfifo *fifo
 
 	/* then put the rest (if any) at the beginning of the buffer */
 	memcpy(fifo->buffer, from + l, len - l);
-
-	__kfifo_add_in(fifo, len);
-
-	return len;
 }
-EXPORT_SYMBOL(kfifo_in);
 
-/**
- * kfifo_out - gets some data from the FIFO
- * @fifo: the fifo to be used.
- * @to: where the data must be copied.
- * @len: the size of the destination buffer.
- *
- * This function copies at most @len bytes from the FIFO into the
- * @to buffer and returns the number of copied bytes.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-unsigned int kfifo_out(struct kfifo *fifo,
-			 unsigned char *to, unsigned int len)
+static inline void __kfifo_out_data(struct kfifo *fifo,
+		void *to, unsigned int len, unsigned int off)
 {
-	unsigned int off;
 	unsigned int l;
 
-	len = min(len, fifo->in - fifo->out);
-
 	/*
 	 * Ensure that we sample the fifo->in index -before- we
 	 * start removing bytes from the kfifo.
@@ -185,7 +149,7 @@ unsigned int kfifo_out(struct kfifo *fif
 
 	smp_rmb();
 
-	off = __kfifo_off(fifo, fifo->out);
+	off = __kfifo_off(fifo, fifo->out + off);
 
 	/* first get the data from fifo->out until the end of the buffer */
 	l = min(len, fifo->size - off);
@@ -193,34 +157,14 @@ unsigned int kfifo_out(struct kfifo *fif
 
 	/* then get the rest (if any) from the beginning of the buffer */
 	memcpy(to + l, fifo->buffer, len - l);
-
-	__kfifo_add_out(fifo, len);
-
-	return len;
 }
-EXPORT_SYMBOL(kfifo_out);
 
-/**
- * kfifo_from_user - puts some data from user space into the FIFO
- * @fifo: the fifo to be used.
- * @from: pointer to the data to be added.
- * @len: the length of the data to be added.
- *
- * This function copies at most @len bytes from the @from into the
- * FIFO depending and returns the number of copied bytes.
- *
- * Note that with only one concurrent reader and one concurrent
- * writer, you don't need extra locking to use these functions.
- */
-unsigned int kfifo_from_user(struct kfifo *fifo,
-	const void __user *from, unsigned int len)
+static inline unsigned int __kfifo_from_user_data(struct kfifo *fifo,
+	 const void __user *from, unsigned int len, unsigned int off)
 {
-	unsigned int off;
 	unsigned int l;
 	int ret;
 
-	len = min(len, fifo->size - fifo->in + fifo->out);
-
 	/*
 	 * Ensure that we sample the fifo->out index -before- we
 	 * start putting bytes into the kfifo.
@@ -228,29 +172,101 @@ unsigned int kfifo_from_user(struct kfif
 
 	smp_mb();
 
-	off = __kfifo_off(fifo, fifo->in);
+	off = __kfifo_off(fifo, fifo->in + off);
 
 	/* first put the data starting from fifo->in to buffer end */
 	l = min(len, fifo->size - off);
 	ret = copy_from_user(fifo->buffer + off, from, l);
 
 	if (unlikely(ret))
-		return l - ret;
+		return ret + len - l;
 
 	/* then put the rest (if any) at the beginning of the buffer */
-	ret = copy_from_user(fifo->buffer, from + l, len - l);
+	return copy_from_user(fifo->buffer, from + l, len - l);
+}
+
+static inline unsigned int __kfifo_to_user_data(struct kfifo *fifo,
+		void __user *to, unsigned int len, unsigned int off)
+{
+	unsigned int l;
+	int ret;
+
+	/*
+	 * Ensure that we sample the fifo->in index -before- we
+	 * start removing bytes from the kfifo.
+	 */
+
+	smp_rmb();
+
+	off = __kfifo_off(fifo, fifo->out + off);
+
+	/* first get the data from fifo->out until the end of the buffer */
+	l = min(len, fifo->size - off);
+	ret = copy_to_user(to, fifo->buffer + off, l);
 
 	if (unlikely(ret))
-		return len - ret;
+		return ret + len - l;
 
-	__kfifo_add_in(fifo, len);
+	/* then get the rest (if any) from the beginning of the buffer */
+	return copy_to_user(to + l, fifo->buffer, len - l);
+}
+
+unsigned int __kfifo_in_n(struct kfifo *fifo,
+	const void *from, unsigned int len, unsigned int recsize)
+{
+	if (kfifo_avail(fifo) < len + recsize)
+		return len + 1;
 
+	__kfifo_in_data(fifo, from, len, recsize);
+	return 0;
+}
+EXPORT_SYMBOL(__kfifo_in_n);
+
+/**
+ * kfifo_in - puts some data into the FIFO
+ * @fifo: the fifo to be used.
+ * @from: the data to be added.
+ * @len: the length of the data to be added.
+ *
+ * This function copies at most @len bytes from the @from buffer into
+ * the FIFO depending on the free space, and returns the number of
+ * bytes copied.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+unsigned int kfifo_in(struct kfifo *fifo, const unsigned char *from,
+				unsigned int len)
+{
+	len = min(kfifo_avail(fifo), len);
+
+	__kfifo_in_data(fifo, from, len, 0);
+	__kfifo_add_in(fifo, len);
 	return len;
 }
-EXPORT_SYMBOL(kfifo_from_user);
+EXPORT_SYMBOL(kfifo_in);
+
+unsigned int __kfifo_in_generic(struct kfifo *fifo,
+	const void *from, unsigned int len, unsigned int recsize)
+{
+	return __kfifo_in_rec(fifo, from, len, recsize);
+}
+EXPORT_SYMBOL(__kfifo_in_generic);
+
+unsigned int __kfifo_out_n(struct kfifo *fifo,
+	void *to, unsigned int len, unsigned int recsize)
+{
+	if (kfifo_len(fifo) < len + recsize)
+		return len;
+
+	__kfifo_out_data(fifo, to, len, recsize);
+	__kfifo_add_out(fifo, len + recsize);
+	return 0;
+}
+EXPORT_SYMBOL(__kfifo_out_n);
 
 /**
- * kfifo_to_user - gets data from the FIFO and write it to user space
+ * kfifo_out - gets some data from the FIFO
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @len: the size of the destination buffer.
@@ -261,40 +277,124 @@ EXPORT_SYMBOL(kfifo_from_user);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_to_user(struct kfifo *fifo,
-	void __user *to, unsigned int len)
+unsigned int kfifo_out(struct kfifo *fifo, unsigned char *to, unsigned int len)
 {
-	unsigned int off;
-	unsigned int l;
-	int ret;
+	len = min(kfifo_len(fifo), len);
 
-	len = min(len, fifo->in - fifo->out);
+	__kfifo_out_data(fifo, to, len, 0);
+	__kfifo_add_out(fifo, len);
 
-	/*
-	 * Ensure that we sample the fifo->in index -before- we
-	 * start removing bytes from the kfifo.
-	 */
+	return len;
+}
+EXPORT_SYMBOL(kfifo_out);
 
-	smp_rmb();
+unsigned int __kfifo_out_generic(struct kfifo *fifo,
+	void *to, unsigned int len, unsigned int recsize,
+	unsigned int *total)
+{
+	return __kfifo_out_rec(fifo, to, len, recsize, total);
+}
+EXPORT_SYMBOL(__kfifo_out_generic);
 
-	off = __kfifo_off(fifo, fifo->out);
+unsigned int __kfifo_from_user_n(struct kfifo *fifo,
+	const void __user *from, unsigned int len, unsigned int recsize)
+{
+	if (kfifo_avail(fifo) < len + recsize)
+		return len + 1;
 
-	/* first get the data from fifo->out until the end of the buffer */
-	l = min(len, fifo->size - off);
-	ret = copy_to_user(to, fifo->buffer + off, l);
+	return __kfifo_from_user_data(fifo, from, len, recsize);
+}
+EXPORT_SYMBOL(__kfifo_from_user_n);
 
-	if (unlikely(ret))
-		return l - ret;
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
+	len = min(kfifo_avail(fifo), len);
+	len -= __kfifo_from_user_data(fifo, from, len, 0);
+	__kfifo_add_in(fifo, len);
+	return len;
+}
+EXPORT_SYMBOL(kfifo_from_user);
 
-	/* then get the rest (if any) from the beginning of the buffer */
-	ret = copy_to_user(to + l, fifo->buffer, len - l);
+unsigned int __kfifo_from_user_generic(struct kfifo *fifo,
+	const void __user *from, unsigned int len, unsigned int recsize)
+{
+	return __kfifo_from_user_rec(fifo, from, len, recsize);
+}
+EXPORT_SYMBOL(__kfifo_from_user_generic);
 
-	if (unlikely(ret))
-		return len - ret;
+unsigned int __kfifo_to_user_n(struct kfifo *fifo,
+	void __user *to, unsigned int len, unsigned int reclen,
+	unsigned int recsize)
+{
+	unsigned int ret;
 
-	__kfifo_add_out(fifo, len);
+	if (kfifo_len(fifo) < reclen + recsize)
+		return len;
 
+	ret = __kfifo_to_user_data(fifo, to, reclen, recsize);
+
+	if (likely(ret == 0))
+		__kfifo_add_out(fifo, reclen + recsize);
+
+	return ret;
+}
+EXPORT_SYMBOL(__kfifo_to_user_n);
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
+	len = min(kfifo_len(fifo), len);
+	len -= __kfifo_to_user_data(fifo, to, len, 0);
+	__kfifo_add_out(fifo, len);
 	return len;
 }
 EXPORT_SYMBOL(kfifo_to_user);
 
+unsigned int __kfifo_to_user_generic(struct kfifo *fifo,
+	void __user *to, unsigned int len, unsigned int recsize,
+	unsigned int *total)
+{
+	return __kfifo_to_user_rec(fifo, to, len, recsize, total);
+}
+EXPORT_SYMBOL(__kfifo_to_user_generic);
+
+unsigned int __kfifo_peek_generic(struct kfifo *fifo, unsigned int recsize)
+{
+	if (recsize == 0)
+		return kfifo_avail(fifo);
+
+	return __kfifo_peek_n(fifo, recsize);
+}
+EXPORT_SYMBOL(__kfifo_peek_generic);
+
+void __kfifo_skip_generic(struct kfifo *fifo, unsigned int recsize)
+{
+	__kfifo_skip_rec(fifo, recsize);
+}
+EXPORT_SYMBOL(__kfifo_skip_generic);
+


