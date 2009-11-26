Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbZKZA0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbZKZA0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 19:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760025AbZKZA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 19:26:33 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:41575 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662AbZKZA0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 19:26:13 -0500
From: Ian Molton <ian.molton@collabora.co.uk>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, mpm@selenic.com,
       Ian Molton <ian.molton@collabora.co.uk>
Subject: [PATCH 2/2] virtio: Convert virtio-rng to the new API
Date: Thu, 26 Nov 2009 00:25:27 +0000
Message-Id: <1259195127-20086-3-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>
References: <1259177252.2858.17.camel@calx>
 <1259195127-20086-1-git-send-email-ian.molton@collabora.co.uk>
 <1259195127-20086-2-git-send-email-ian.molton@collabora.co.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch converts virtio-rng to the new hw_rng API.

In the process it fixes a previously untriggered buffering bug where the
buffer is not drained correctly if it has a non-multiple-of-4 length.

Performance has improved under qemu-kvm testing also.

Signed-off-by: Ian Molton <ian.molton@collabora.co.uk>
---
 drivers/char/hw_random/virtio-rng.c |   79 ++++++++++++----------------------
 1 files changed, 28 insertions(+), 51 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 915157f..76d00c4 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -16,6 +16,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
  */
+
 #include <linux/err.h>
 #include <linux/hw_random.h>
 #include <linux/scatterlist.h>
@@ -23,78 +24,65 @@
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
 
-/* The host will fill any buffer we give it with sweet, sweet randomness.  We
- * give it 64 bytes at a time, and the hwrng framework takes it 4 bytes at a
- * time. */
-#define RANDOM_DATA_SIZE 64
-
 static struct virtqueue *vq;
-static u32 *random_data;
-static unsigned int data_left;
+static unsigned int data_avail;
 static DECLARE_COMPLETION(have_data);
+static int busy;
+
+/* The host will fill any buffer we give it with sweet, sweet randomness. */
 
 static void random_recv_done(struct virtqueue *vq)
 {
-	unsigned int len;
-
 	/* We can get spurious callbacks, e.g. shared IRQs + virtio_pci. */
-	if (!vq->vq_ops->get_buf(vq, &len))
+	if (!vq->vq_ops->get_buf(vq, &data_avail))
 		return;
 
-	data_left += len;
 	complete(&have_data);
 }
 
-static void register_buffer(void)
+static void register_buffer(u8 *buf, size_t size)
 {
 	struct scatterlist sg;
 
-	sg_init_one(&sg, random_data+data_left, RANDOM_DATA_SIZE-data_left);
+	sg_init_one(&sg, buf, size);
+
 	/* There should always be room for one buffer. */
-	if (vq->vq_ops->add_buf(vq, &sg, 0, 1, random_data) < 0)
+	if (vq->vq_ops->add_buf(vq, &sg, 0, 1, buf) < 0)
 		BUG();
+
 	vq->vq_ops->kick(vq);
 }
 
-/* At least we don't udelay() in a loop like some other drivers. */
-static int virtio_data_present(struct hwrng *rng, int wait)
+static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 {
-	if (data_left >= sizeof(u32))
-		return 1;
 
-again:
+	if (!busy) {
+		busy = 1;
+		init_completion(&have_data);
+		register_buffer(buf, size);
+	}
+
 	if (!wait)
 		return 0;
 
 	wait_for_completion(&have_data);
 
-	/* Not enough?  Re-register. */
-	if (unlikely(data_left < sizeof(u32))) {
-		register_buffer();
-		goto again;
-	}
+	busy = 0;
 
-	return 1;
+	return data_avail;
 }
 
-/* virtio_data_present() must have succeeded before this is called. */
-static int virtio_data_read(struct hwrng *rng, u32 *data)
+static void virtio_cleanup(struct hwrng *rng)
 {
-	BUG_ON(data_left < sizeof(u32));
-	data_left -= sizeof(u32);
-	*data = random_data[data_left / 4];
-
-	if (data_left < sizeof(u32)) {
-		init_completion(&have_data);
-		register_buffer();
-	}
-	return sizeof(*data);
+	if (busy)
+		wait_for_completion(&have_data);
 }
 
+
 static struct hwrng virtio_hwrng = {
-	.name = "virtio",
-	.data_present = virtio_data_present,
-	.data_read = virtio_data_read,
+	.name		= "virtio",
+	.cleanup	= virtio_cleanup,
+	.read		= virtio_read,
 };
 
 static int virtrng_probe(struct virtio_device *vdev)
@@ -112,7 +100,6 @@ static int virtrng_probe(struct virtio_device *vdev)
 		return err;
 	}
 
-	register_buffer();
 	return 0;
 }
 
@@ -138,21 +125,11 @@ static struct virtio_driver virtio_rng = {
 
 static int __init init(void)
 {
-	int err;
-
-	random_data = kmalloc(RANDOM_DATA_SIZE, GFP_KERNEL);
-	if (!random_data)
-		return -ENOMEM;
-
-	err = register_virtio_driver(&virtio_rng);
-	if (err)
-		kfree(random_data);
-	return err;
+	return register_virtio_driver(&virtio_rng);
 }
 
 static void __exit fini(void)
 {
-	kfree(random_data);
 	unregister_virtio_driver(&virtio_rng);
 }
 module_init(init);
-- 
1.6.5

