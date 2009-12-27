Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZL0VEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZL0VEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZL0VDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:03:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43501 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZL0VDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:03:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912271003.631128760@firstfloor.org>
In-Reply-To: <200912271003.631128760@firstfloor.org>
To: stefani@seibold.net, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [1/6] kfifo: Use void * pointers for user buffers
Message-Id: <20091227210311.A3629B17C5@basil.firstfloor.org>
Date: Sun, 27 Dec 2009 22:03:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The pointers to user buffers are currently unsigned char *, which requires
a lot of casting in the caller for any non-char typed buffers. Use 
void * instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kfifo.h |   10 +++++-----
 kernel/kfifo.c        |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: linux/include/linux/kfifo.h
===================================================================
--- linux.orig/include/linux/kfifo.h
+++ linux/include/linux/kfifo.h
@@ -105,15 +105,15 @@ union { \
 
 #undef __kfifo_initializer
 
-extern void kfifo_init(struct kfifo *fifo, unsigned char *buffer,
+extern void kfifo_init(struct kfifo *fifo, void *buffer,
 			unsigned int size);
 extern __must_check int kfifo_alloc(struct kfifo *fifo, unsigned int size,
 			gfp_t gfp_mask);
 extern void kfifo_free(struct kfifo *fifo);
 extern unsigned int kfifo_in(struct kfifo *fifo,
-				const unsigned char *from, unsigned int len);
+				const void *from, unsigned int len);
 extern __must_check unsigned int kfifo_out(struct kfifo *fifo,
-				unsigned char *to, unsigned int len);
+				void *to, unsigned int len);
 
 /**
  * kfifo_reset - removes the entire FIFO contents
@@ -195,7 +195,7 @@ static inline __must_check unsigned int
  * bytes copied.
  */
 static inline unsigned int kfifo_in_locked(struct kfifo *fifo,
-		const unsigned char *from, unsigned int n, spinlock_t *lock)
+		const void *from, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
@@ -220,7 +220,7 @@ static inline unsigned int kfifo_in_lock
  * @to buffer and returns the number of copied bytes.
  */
 static inline __must_check unsigned int kfifo_out_locked(struct kfifo *fifo,
-	unsigned char *to, unsigned int n, spinlock_t *lock)
+	void *to, unsigned int n, spinlock_t *lock)
 {
 	unsigned long flags;
 	unsigned int ret;
Index: linux/kernel/kfifo.c
===================================================================
--- linux.orig/kernel/kfifo.c
+++ linux/kernel/kfifo.c
@@ -28,7 +28,7 @@
 #include <linux/log2.h>
 #include <linux/uaccess.h>
 
-static void _kfifo_init(struct kfifo *fifo, unsigned char *buffer,
+static void _kfifo_init(struct kfifo *fifo, void *buffer,
 		unsigned int size)
 {
 	fifo->buffer = buffer;
@@ -44,7 +44,7 @@ static void _kfifo_init(struct kfifo *fi
  * @size: the size of the internal buffer, this have to be a power of 2.
  *
  */
-void kfifo_init(struct kfifo *fifo, unsigned char *buffer, unsigned int size)
+void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size)
 {
 	/* size must be a power of 2 */
 	BUG_ON(!is_power_of_2(size));
@@ -235,7 +235,7 @@ EXPORT_SYMBOL(__kfifo_in_n);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_in(struct kfifo *fifo, const unsigned char *from,
+unsigned int kfifo_in(struct kfifo *fifo, const void *from,
 				unsigned int len)
 {
 	len = min(kfifo_avail(fifo), len);
@@ -277,7 +277,7 @@ EXPORT_SYMBOL(__kfifo_out_n);
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
  */
-unsigned int kfifo_out(struct kfifo *fifo, unsigned char *to, unsigned int len)
+unsigned int kfifo_out(struct kfifo *fifo, void *to, unsigned int len)
 {
 	len = min(kfifo_len(fifo), len);
 
