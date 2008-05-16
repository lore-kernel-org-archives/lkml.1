Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYEPFcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYEPFcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYEPFcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:32:04 -0400
Received: from ozlabs.org ([203.10.76.45]:46983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYEPFcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:32:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: [PATCH 1/2] virtio: hardware random device
Date: Fri, 16 May 2008 15:31:44 +1000
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Anvin" <hpa@zytor.com>
References: <482C8595.5030509@garzik.org> <200805160943.08788.rusty@rustcorp.com.au>
In-Reply-To: <200805160943.08788.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161531.44725.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008 09:43:08 Rusty Russell wrote:
> Anyway, since there's interest, I'll drag virtio_rng from the bottom of the
> queue, apply Christian's fix (which I somehow missed before, sorry
> Christian), and re-post.

Actually, I didn't miss it.  But I've polished the driver a little more,
here are the patches.

===
virtio: An entropy device, as suggested by hpa.

Note that by itself, having a "hardware" random generator does very
little: you should probably run "rngd" in your guest to feed this into
the kernel entropy pool.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/Kconfig      |   10 ++
 drivers/char/hw_random/Makefile     |    1 
 drivers/char/hw_random/virtio-rng.c |  143 ++++++++++++++++++++++++++++++++++++
 include/linux/virtio_rng.h          |    8 ++
 4 files changed, 162 insertions(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -112,3 +112,13 @@ config HW_RANDOM_PASEMI
 
 	  If unsure, say Y.
 
+config HW_RANDOM_VIRTIO
+	tristate "VirtIO Random Number Generator support"
+	depends on HW_RANDOM && VIRTIO
+	---help---
+	  This driver provides kernel-side support for the virtual Random Number
+	  Generator hardware.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called virtio-rng.  If unsure, say N.
+
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4xx
 obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_OMAP) += omap-rng.o
 obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
+obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
new file mode 100644
--- /dev/null
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -0,0 +1,143 @@
+/*
+ * Randomness driver for virtio
+ *  Copyright (C) 2007, 2008 Rusty Russell IBM Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock.h>
+#include <linux/virtio.h>
+#include <linux/virtio_rng.h>
+
+/* The host will fill any buffer we give it with sweet, sweet randomness.  We
+ * give it 64 bytes at a time, and the hwrng framework takes it 4 bytes at a
+ * time. */
+static struct virtqueue *vq;
+static u32 random_data[16];
+static unsigned int data_left;
+static DECLARE_COMPLETION(have_data);
+
+static void random_recv_done(struct virtqueue *vq)
+{
+	int len;
+
+	/* We never get spurious callbacks. */
+	if (!vq->vq_ops->get_buf(vq, &len))
+		BUG();
+
+	data_left = len / sizeof(random_data[0]);
+	complete(&have_data);
+}
+
+static void register_buffer(void)
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, &random_data, sizeof(random_data));
+	/* There should always be room for one buffer. */
+	if (vq->vq_ops->add_buf(vq, &sg, 0, 1, &random_data) != 0)
+		BUG();
+	vq->vq_ops->kick(vq);
+}
+
+/* At least we don't udelay() in a loop like some other drivers. */
+static int virtio_data_present(struct hwrng *rng, int wait)
+{
+	if (data_left)
+		return 1;
+
+	if (!wait)
+		return 0;
+
+	wait_for_completion(&have_data);
+	return 1;
+}
+
+/* virtio_data_present() must have succeeded before this is called. */
+static int virtio_data_read(struct hwrng *rng, u32 *data)
+{
+	BUG_ON(!data_left);
+
+	*data = random_data[--data_left];
+
+	if (!data_left) {
+		init_completion(&have_data);
+		register_buffer();
+	}
+	return sizeof(*data);
+}
+
+static struct hwrng virtio_hwrng = {
+	.name = "virtio",
+	.data_present = virtio_data_present,
+	.data_read = virtio_data_read,
+};
+
+static int virtrng_probe(struct virtio_device *vdev)
+{
+	int err;
+
+	/* We expect a single virtqueue. */
+	vq = vdev->config->find_vq(vdev, 0, random_recv_done);
+	if (IS_ERR(vq))
+		return PTR_ERR(vq);
+
+	err = hwrng_register(&virtio_hwrng);
+	if (err) {
+		vdev->config->del_vq(vq);
+		return err;
+	}
+
+	register_buffer();
+	return 0;
+}
+
+static void virtrng_remove(struct virtio_device *vdev)
+{
+	vdev->config->reset(vdev);
+	hwrng_unregister(&virtio_hwrng);
+	vdev->config->del_vq(vq);
+}
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_RNG, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct virtio_driver virtio_rng = {
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.id_table =	id_table,
+	.probe =	virtrng_probe,
+	.remove =	__devexit_p(virtrng_remove),
+};
+
+static int __init init(void)
+{
+	return register_virtio_driver(&virtio_rng);
+}
+
+static void __exit fini(void)
+{
+	unregister_virtio_driver(&virtio_rng);
+}
+module_init(init);
+module_exit(fini);
+
+MODULE_DEVICE_TABLE(virtio, id_table);
+MODULE_DESCRIPTION("Virtio random number driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio_rng.h b/include/linux/virtio_rng.h
new file mode 100644
--- /dev/null
+++ b/include/linux/virtio_rng.h
@@ -0,0 +1,8 @@
+#ifndef _LINUX_VIRTIO_RNG_H
+#define _LINUX_VIRTIO_RNG_H
+#include <linux/virtio_config.h>
+
+/* The ID for virtio_rng */
+#define VIRTIO_ID_RNG	4
+
+#endif /* _LINUX_VIRTIO_RNG_H */
