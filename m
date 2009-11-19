Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbZKSPTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbZKSPTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZKSPTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:19:33 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37188 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZKSPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:19:32 -0500
Subject: virtio: Add memory statistics reporting to the balloon driver (V3)
From: Adam Litke <agl@us.ibm.com>
To: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: qemu-devel@nongnu.org, Avi Kivity <avi@redhat.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1258643169.3464.3.camel@aglitke>
References: <1258643169.3464.3.camel@aglitke>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Thu, 19 Nov 2009 09:19:05 -0600
Message-ID: <1258643945.3464.5.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty and Anthony,
If I've addressed all outstanding issues, please consider this patch for
inclusion.  Thanks.

Changes since V2:
 - Increase stat field size to 64 bits
 - Report all sizes in kb (not pages)
 - Drop anon_pages stat and fix endianness conversion

Changes since V1:
 - Use a virtqueue instead of the device config space

When using ballooning to manage overcommitted memory on a host, a system for
guests to communicate their memory usage to the host can provide information
that will minimize the impact of ballooning on the guests.  The current method
employs a daemon running in each guest that communicates memory statistics to a
host daemon at a specified time interval.  The host daemon aggregates this
information and inflates and/or deflates balloons according to the level of
host memory pressure.  This approach is effective but overly complex since a
daemon must be installed inside each guest and coordinated to communicate with
the host.  A simpler approach is to collect memory statistics in the virtio
balloon driver and communicate them directly to the hypervisor.

This patch enables the guest-side support by adding stats collection and
reporting to the virtio balloon driver.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <anthony@codemonkey.ws>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 200c22f..ebc9d39 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -29,7 +29,7 @@
 struct virtio_balloon
 {
 	struct virtio_device *vdev;
-	struct virtqueue *inflate_vq, *deflate_vq;
+	struct virtqueue *inflate_vq, *deflate_vq, *stats_vq;
 
 	/* Where the ballooning thread waits for config to change. */
 	wait_queue_head_t config_change;
@@ -50,6 +50,9 @@ struct virtio_balloon
 	/* The array of pfns we tell the Host about. */
 	unsigned int num_pfns;
 	u32 pfns[256];
+
+	/* Memory statistics */
+	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
 };
 
 static struct virtio_device_id id_table[] = {
@@ -155,6 +158,57 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
 	}
 }
 
+static inline void update_stat(struct virtio_balloon *vb, int idx,
+				__le16 tag, __le64 val)
+{
+	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
+	vb->stats[idx].tag = cpu_to_le16(tag);
+	vb->stats[idx].val = cpu_to_le64(val);
+}
+
+#define K(x) ((x) << (PAGE_SHIFT - 10))
+static void update_balloon_stats(struct virtio_balloon *vb)
+{
+	unsigned long events[NR_VM_EVENT_ITEMS];
+	struct sysinfo i;
+	int idx = 0;
+
+	all_vm_events(events);
+	si_meminfo(&i);
+
+	update_stat(vb, idx++, VIRTIO_BALLOON_S_SWAP_IN, K(events[PSWPIN]));
+	update_stat(vb, idx++, VIRTIO_BALLOON_S_SWAP_OUT, K(events[PSWPOUT]));
+	update_stat(vb, idx++, VIRTIO_BALLOON_S_MAJFLT, events[PGMAJFAULT]);
+	update_stat(vb, idx++, VIRTIO_BALLOON_S_MINFLT, events[PGFAULT]);
+	update_stat(vb, idx++, VIRTIO_BALLOON_S_MEMFREE, K(i.freeram));
+	update_stat(vb, idx++, VIRTIO_BALLOON_S_MEMTOT, K(i.totalram));
+}
+
+/*
+ * While most virtqueues communicate guest-initiated requests to the hypervisor,
+ * the stats queue operates in reverse.  The driver initializes the virtqueue
+ * with a single buffer.  From that point forward, all conversations consist of
+ * a hypervisor request (a call to this function) which directs us to refill
+ * the virtqueue with a fresh stats buffer.
+ */
+static void stats_ack(struct virtqueue *vq)
+{
+	struct virtio_balloon *vb;
+	unsigned int len;
+	struct scatterlist sg;
+
+	vb = vq->vq_ops->get_buf(vq, &len);
+	if (!vb)
+		return;
+
+	update_balloon_stats(vb);
+
+	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
+	if (vq->vq_ops->add_buf(vq, &sg, 1, 0, vb) < 0)
+		BUG();
+	vq->vq_ops->kick(vq);
+}
+
 static void virtballoon_changed(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb = vdev->priv;
@@ -205,10 +259,10 @@ static int balloon(void *_vballoon)
 static int virtballoon_probe(struct virtio_device *vdev)
 {
 	struct virtio_balloon *vb;
-	struct virtqueue *vqs[2];
-	vq_callback_t *callbacks[] = { balloon_ack, balloon_ack };
-	const char *names[] = { "inflate", "deflate" };
-	int err;
+	struct virtqueue *vqs[3];
+	vq_callback_t *callbacks[] = { balloon_ack, balloon_ack, stats_ack };
+	const char *names[] = { "inflate", "deflate", "stats" };
+	int err, nvqs;
 
 	vdev->priv = vb = kmalloc(sizeof(*vb), GFP_KERNEL);
 	if (!vb) {
@@ -221,13 +275,28 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	init_waitqueue_head(&vb->config_change);
 	vb->vdev = vdev;
 
-	/* We expect two virtqueues. */
-	err = vdev->config->find_vqs(vdev, 2, vqs, callbacks, names);
+	/* We expect two virtqueues: inflate and deflate,
+	 * and optionally stat. */
+	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
+	err = vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names);
 	if (err)
 		goto out_free_vb;
 
 	vb->inflate_vq = vqs[0];
 	vb->deflate_vq = vqs[1];
+	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
+		struct scatterlist sg;
+		vb->stats_vq = vqs[2];
+
+		/*
+		 * Prime this virtqueue with one buffer so the hypervisor can
+		 * use it to signal us later.
+		 */
+		sg_init_one(&sg, vb->stats, sizeof(vb->stats));
+		if (vb->stats_vq->vq_ops->add_buf(vb->stats_vq, &sg, 1, 0, vb) < 0)
+			BUG();
+		vb->stats_vq->vq_ops->kick(vb->stats_vq);
+	}
 
 	vb->thread = kthread_run(balloon, vb, "vballoon");
 	if (IS_ERR(vb->thread)) {
@@ -265,7 +334,9 @@ static void virtballoon_remove(struct virtio_device *vdev)
 	kfree(vb);
 }
 
-static unsigned int features[] = { VIRTIO_BALLOON_F_MUST_TELL_HOST };
+static unsigned int features[] = {
+	VIRTIO_BALLOON_F_MUST_TELL_HOST, VIRTIO_BALLOON_F_STATS_VQ,
+};
 
 static struct virtio_driver virtio_balloon = {
 	.feature_table = features,
diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
index 09d7300..a5c09e6 100644
--- a/include/linux/virtio_balloon.h
+++ b/include/linux/virtio_balloon.h
@@ -6,6 +6,7 @@
 
 /* The feature bitmap for virtio balloon */
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
+#define VIRTIO_BALLOON_F_STATS_VQ 1 /* Memory Stats virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
@@ -17,4 +18,19 @@ struct virtio_balloon_config
 	/* Number of pages we've actually got in balloon. */
 	__le32 actual;
 };
+
+#define VIRTIO_BALLOON_S_SWAP_IN  0   /* Amount of memory swapped in */
+#define VIRTIO_BALLOON_S_SWAP_OUT 1   /* Amount of memory swapped out */
+#define VIRTIO_BALLOON_S_MAJFLT   2   /* Number of major faults */
+#define VIRTIO_BALLOON_S_MINFLT   3   /* Number of minor faults */
+#define VIRTIO_BALLOON_S_MEMFREE  4   /* Total amount of free memory */
+#define VIRTIO_BALLOON_S_MEMTOT   5   /* Total amount of memory */
+#define VIRTIO_BALLOON_S_NR       6
+
+struct virtio_balloon_stat
+{
+	__le16 tag;
+	__le64 val;
+};
+
 #endif /* _LINUX_VIRTIO_BALLOON_H */


-- 
Thanks,
Adam

