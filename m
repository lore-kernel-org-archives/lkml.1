Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZLKNgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZLKNgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZLKNgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:36:49 -0500
Received: from www84.your-server.de ([213.133.104.84]:53680 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZLKNgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:36:48 -0500
Subject: [PATCH] kfifo: add DMA capabilities
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 11 Dec 2009 14:36:29 +0100
Message-ID: <1260538589.3925.11.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested by Shargorodsky Atal:

This patch adds functions for DMA handling to the new kfifo API. 

To prepare a DMA one of the kfifo_dma_..._prepare() Funktions must be
called. This results in a scatterlist structure which can passed to the
kernel DMA functions.

After the DMA transfer was finished, the corresponding
kfifo_dma_..._finsh() function must be called to remove the transfered
data from the fifo.

These are the function which added new to the kfifo API:

kfifo_dma_in_prepare()
kfifo_dma_in_finish()
 Prepare and finish an incoming DMA.

kfifo_dma_in_prepare_rec
kfifo_dma_in_finish_rec
 Ditto for record fifo's

kfifo_dma_out_prepare
kfifo_dma_out_finish
 Prepare and finish for an outcoming DMA.

kfifo_dma_out_prepare_rec
kfifo_dma_out_finish_rec
 Ditto for record fifo's

The patch-set is against current mm tree from 11-Dec-2009

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 include/linux/kfifo.h |   21 ++++
 kernel/kfifo.c        |  251 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 272 insertions(+)

diff -u -N -r -p kfifo8/include/linux/kfifo.h kfifo9/include/linux/kfifo.h
--- kfifo8/include/linux/kfifo.h	2009-11-26 16:46:48.826439335 +0100
+++ kfifo9/include/linux/kfifo.h	2009-12-11 14:25:00.354439818 +0100
@@ -43,6 +43,7 @@
 
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
+#include <linux/scatterlist.h>
 
 struct kfifo {
 	unsigned char *buffer;	/* the buffer holding the data */
@@ -608,4 +609,24 @@ static inline __must_check unsigned int 
 	return (l > recsize) ? l - recsize : 0;
 }
 
+extern unsigned int kfifo_dma_in_prepare(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents);
+extern void kfifo_dma_in_finish(struct kfifo *fifo, unsigned int len);
+
+extern __must_check unsigned int kfifo_dma_out_prepare(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len);
+extern void kfifo_dma_out_finish(struct kfifo *fifo, unsigned int len);
+
+extern unsigned int kfifo_dma_in_prepare_rec(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int recsize);
+extern void kfifo_dma_in_finish_rec(struct kfifo *fifo, unsigned int len,
+	unsigned int recsize);
+
+extern __must_check  unsigned int kfifo_dma_out_prepare_rec(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len,
+	unsigned int recsize);
+extern void kfifo_dma_out_finish_rec(struct kfifo *fifo, unsigned int len,
+	unsigned int recsize);
+
 #endif
+
diff -u -N -r -p kfifo8/kernel/kfifo.c kfifo9/kernel/kfifo.c
--- kfifo8/kernel/kfifo.c	2009-10-19 21:41:44.508999764 +0200
+++ kfifo9/kernel/kfifo.c	2009-12-11 14:24:58.283459728 +0100
@@ -398,3 +398,254 @@ void __kfifo_skip_generic(struct kfifo *
 }
 EXPORT_SYMBOL(__kfifo_skip_generic);
 
+/**
+ * kfifo_dma_in_prepare - setup a scatterlist for DMA input
+ * @fifo: the fifo to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ *
+ * This function fills a scatterlist for DMA input.
+ * If parameter len is equal 0 the max. size of available data will be used.
+ * It returns the number of bytes which are available for the transfer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+unsigned int kfifo_dma_in_prepare(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents)
+{
+	return kfifo_dma_in_prepare_rec(fifo, sgl, nents, 0);
+}
+EXPORT_SYMBOL(kfifo_dma_in_prepare);
+
+/**
+ * kfifo_dma_in_finish - finish a DMA IN operation
+ * @fifo: the fifo to be used.
+ * @len: number number of bytes to received.
+ *
+ * This function finish a DMA IN operation. The in counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+void kfifo_dma_in_finish(struct kfifo *fifo, unsigned int len)
+{
+	__kfifo_add_in(fifo, len);
+}
+EXPORT_SYMBOL(kfifo_dma_in_finish);
+
+/**
+ * kfifo_dma_out_prepare - setup a scatterlist for DMA output
+ * @fifo: the fifo to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ * @len: number number of bytes to transfer.
+ *
+ * This function fills a scatterlist for DMA output which at most @n bytes to
+ * transfer.
+ * It returns the number of bytes which are available for the transfer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+unsigned int kfifo_dma_out_prepare(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len)
+{
+	return kfifo_dma_out_prepare_rec(fifo, sgl, nents, len, 0);
+}
+EXPORT_SYMBOL(kfifo_dma_out_prepare);
+
+/**
+ * kfifo_dma_out_finish - finish a DMA OUT operation
+ * @fifo: the fifo to be used.
+ * @len: number number of bytes transferd.
+ *
+ * This function finish a DMA OUT operation. The in counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+void kfifo_dma_out_finish(struct kfifo *fifo, unsigned int len)
+{
+	__kfifo_add_out(fifo, len);
+}
+EXPORT_SYMBOL(kfifo_dma_out_finish);
+
+/**
+ * kfifo_dma_in_prepare_rec - setup a scatterlist for DMA input
+ * @fifo: the fifo to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ * @recsize: size of record field
+ *
+ * This function fills a scatterlist for DMA input.
+ * It returns the number of bytes which are available for the transfer.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+unsigned int kfifo_dma_in_prepare_rec(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int recsize)
+{
+	unsigned int	len;
+	unsigned int	n;
+	unsigned int	avail;
+	unsigned int	off;
+
+	if (!nents)
+		BUG();
+
+	avail = kfifo_avail_rec(fifo, recsize);
+
+	if (!avail)
+		return 0;
+
+	switch(recsize) {
+	case 0:
+		len = kfifo_size(fifo);
+		break;
+	case 1:
+		len = 255;
+		break;
+	default:
+		len = 65535;
+		break;
+	}
+
+	if (len > avail)
+		len = avail;
+
+	n = fifo->size - __kfifo_off(fifo, fifo->in);
+	
+	if (n > recsize) {
+		n -= recsize;
+		if (n > len)
+			n = len;
+		off = __kfifo_off(fifo, fifo->in + recsize);
+		if ((n != len) && (nents > 1)) {
+			sg_set_buf(sgl, fifo->buffer + off, n);
+			sgl++;
+
+			off = 0;
+			n = len - n;
+		}
+		else
+			len = n;
+	}
+	else {
+		off = recsize - n;
+		n = len;
+	}
+	sg_set_buf(sgl, fifo->buffer + off, n);
+	sg_mark_end(sgl);
+
+	return len;
+}
+EXPORT_SYMBOL(kfifo_dma_in_prepare_rec);
+
+/**
+ * kfifo_dma_in_finish_rec - finish a DMA IN operation
+ * @fifo: the fifo to be used.
+ * @len: number number of bytes received.
+ * @recsize: size of record field
+ *
+ * This function finish a DMA IN operation. The in counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+void kfifo_dma_in_finish_rec(struct kfifo *fifo, unsigned int len,
+	unsigned int recsize)
+{
+	if (!recsize)
+		__kfifo_poke_n(fifo, recsize, len);
+	__kfifo_add_in(fifo, len + recsize);
+}
+EXPORT_SYMBOL(kfifo_dma_in_finish_rec);
+
+/**
+ * kfifo_dma_out_rec - setup a scatterlist for DMA output
+ * @fifo: the fifo to be used.
+ * @sgl: pointer to the scatterlist array.
+ * @nents: number of entries in the scatterlist array (should be 1 or 2).
+ * @len: number number of bytes to transfer.
+ * @recsize: size of record field
+ *
+ * This function fills a scatterlist for DMA output which at most @n bytes to
+ * transfer.
+ * If parameter len is equal 0 the max. size of available data will be used.
+ * It returns the number of bytes which are available for the transfer.
+ *
+ * After the DMA transfer the fifo entry must be removed with
+ * kfifo_dma_out_finish_rec().
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+unsigned int kfifo_dma_out_prepare_rec(struct kfifo *fifo,
+	struct scatterlist *sgl, int nents, unsigned int len,
+	unsigned int recsize)
+{
+	unsigned int	n;
+	unsigned int	size;
+	unsigned int	off;
+
+	if (!nents)
+		BUG();
+
+	size = __kfifo_peek_generic(fifo, recsize);
+
+	if (!len || len > size)
+		len = size;
+
+	n = fifo->size - __kfifo_off(fifo, fifo->out);
+	
+	if (n > recsize) {
+		n -= recsize;
+		if (n > len)
+			n = len;
+		off = __kfifo_off(fifo, fifo->out + recsize);
+		if ((n != len) && (nents > 1)) {
+			sg_set_buf(sgl, fifo->buffer + off, n);
+			sgl++;
+
+			off = 0;
+			n = len - n;
+		}
+		else
+			len = n;
+	}
+	else {
+		off = recsize - n;
+		n = len;
+	}
+	sg_set_buf(sgl, fifo->buffer + off, n);
+	sg_mark_end(sgl);
+
+	return len;
+}
+EXPORT_SYMBOL(kfifo_dma_out_prepare_rec);
+
+/**
+ * kfifo_dma_out_finish_rec - finish a DMA OUT operation
+ * @fifo: the fifo to be used.
+ * @len: number number of bytes transferd.
+ * @recsize: size of record field
+ *
+ * This function finish a DMA OUT operation. The in counter will be updated by
+ * the len parameter. No error checking will be done.
+ *
+ * Note that with only one concurrent reader and one concurrent
+ * writer, you don't need extra locking to use these functions.
+ */
+void kfifo_dma_out_finish_rec(struct kfifo *fifo, unsigned int len,
+	unsigned int recsize)
+{
+	if (!recsize)
+		len = __kfifo_peek_n(fifo, recsize);
+	__kfifo_add_out(fifo, len + recsize);
+}
+EXPORT_SYMBOL(kfifo_dma_out_finish_rec);
+


