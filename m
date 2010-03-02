Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0CBNdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:33:33 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:37681 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab0CBNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:33:32 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8D1427.1060001@cam.ac.uk>
Date: Tue, 02 Mar 2010 13:35:35 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: linux-iio@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: [PATCH] Staging: IIO: Fix uses of spinlocks prior to init in ring
 implementations
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---

 Some confusion was caused by the ___iio_init_ring_buffer and equivalent
 in ring_sw handling both init of spin locks etc and allocation and
 of the actual buffer.  This resulted in ring->use_lock being held
 before it was initialized and actually during the initialization.

 Some of the recent cleanups in the spin lock code seem to have triggered
 the bug actually causing traceable crashes.

 The following patch should fix this but hasn't been extensively tested
 as of yet and there may well be some side effects I haven't thought of.
 Just wanted to get this out there before anyone else runs into it!

 drivers/staging/iio/industrialio-ring.c |    2 ++
 drivers/staging/iio/ring_generic.h      |    8 +++-----
 drivers/staging/iio/ring_sw.c           |   18 +++++++++++-------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index ebe5ccc..d1f16ef 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -265,6 +265,8 @@ void iio_ring_buffer_init(struct iio_ring_buffer *ring,
 	ring->indio_dev = dev_info;
 	ring->ev_int.private = ring;
 	ring->access_handler.private = ring;
+	ring->shared_ev_pointer.ev_p = 0;
+	spin_lock_init(&ring->shared_ev_pointer.lock);
 }
 EXPORT_SYMBOL(iio_ring_buffer_init);
 
diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index 09044ad..75e0fc0 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -134,19 +134,17 @@ void iio_ring_buffer_init(struct iio_ring_buffer *ring,
 			  struct iio_dev *dev_info);
 
 /**
- * __iio_init_ring_buffer() - initialize common elements of ring buffers
+ * __iio_update_ring_buffer() - update common elements of ring buffers
  * @ring:		ring buffer that is the event source
  * @bytes_per_datum:	size of individual datum including timestamp
  * @length:		number of datums in ring
  **/
-static inline void __iio_init_ring_buffer(struct iio_ring_buffer *ring,
-				 int bytes_per_datum, int length)
+static inline void __iio_update_ring_buffer(struct iio_ring_buffer *ring,
+					    int bytes_per_datum, int length)
 {
 	ring->bpd = bytes_per_datum;
 	ring->length = length;
 	ring->loopcount = 0;
-	ring->shared_ev_pointer.ev_p = 0;
-	spin_lock_init(&ring->shared_ev_pointer.lock);
 }
 
 /**
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index a81c2b2..3d08fbe 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -14,14 +14,12 @@
 #include <linux/workqueue.h>
 #include "ring_sw.h"
 
-static inline int __iio_init_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
-					    int bytes_per_datum, int length)
+static inline int __iio_allocate_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
+						int bytes_per_datum, int length)
 {
 	if ((length == 0) || (bytes_per_datum == 0))
 		return -EINVAL;
-
-	__iio_init_ring_buffer(&ring->buf, bytes_per_datum, length);
-	spin_lock_init(&ring->use_lock);
+	__iio_update_ring_buffer(&ring->buf, bytes_per_datum, length);
 	ring->data = kmalloc(length*ring->buf.bpd, GFP_KERNEL);
 	ring->read_p = 0;
 	ring->write_p = 0;
@@ -30,6 +28,11 @@ static inline int __iio_init_sw_ring_buffer(struct iio_sw_ring_buffer *ring,
 	return ring->data ? 0 : -ENOMEM;
 }
 
+static inline void __iio_init_sw_ring_buffer(struct iio_sw_ring_buffer *ring)
+{
+	spin_lock_init(&ring->use_lock);
+}
+
 static inline void __iio_free_sw_ring_buffer(struct iio_sw_ring_buffer *ring)
 {
 	kfree(ring->data);
@@ -320,7 +323,8 @@ int iio_request_update_sw_rb(struct iio_ring_buffer *r)
 		goto error_ret;
 	}
 	__iio_free_sw_ring_buffer(ring);
-	ret = __iio_init_sw_ring_buffer(ring, ring->buf.bpd, ring->buf.length);
+	ret = __iio_allocate_sw_ring_buffer(ring, ring->buf.bpd,
+					    ring->buf.length);
 error_ret:
 	spin_unlock(&ring->use_lock);
 	return ret;
@@ -411,8 +415,8 @@ struct iio_ring_buffer *iio_sw_rb_allocate(struct iio_dev *indio_dev)
 	if (!ring)
 		return 0;
 	buf = &ring->buf;
-
 	iio_ring_buffer_init(buf, indio_dev);
+	__iio_init_sw_ring_buffer(ring);
 	buf->dev.type = &iio_sw_ring_type;
 	device_initialize(&buf->dev);
 	buf->dev.parent = &indio_dev->dev;
-- 
1.6.4.4

