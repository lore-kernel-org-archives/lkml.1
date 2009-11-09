Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZKIQcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZKIQcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZKIQcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:32:14 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45314 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZKIQcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:32:13 -0500
Subject: virtio: Add memory statistics reporting to the balloon driver
From: Adam Litke <agl@us.ibm.com>
To: qemu-devel@nongnu.org
Cc: "virtualization@lists.linux-foundation.orgAnthony Liguori" 
	<aliguori@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1257782838.2835.5.camel@aglitke>
References: <1257782838.2835.5.camel@aglitke>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 09 Nov 2009 10:32:06 -0600
Message-ID: <1257784326.2835.16.camel@aglitke>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using ballooning to manage overcommitted memory on a host, a system for
guests to communicate their memory usage to the host can provide information
that will minimize the impact of ballooning on the guests.  The current method
employs a daemon running in each guest that communicates memory statistics to a
host daemon at a specified time interval.  The host daemon aggregates this
information and inflates and/or deflates balloons according to the level of
host memory pressure.  This approach is effective but overly complex since a
daemon must be installed inside each guest and coordinated to communicate with
the host.  A simpler approach is to collect memory statistics in the virtio
balloon driver and communicate them to the host via the device config space.

This patch enables the guest-side support by adding stats collection and
reporting to the virtio balloon driver.

Comments?

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 200c22f..0c9a9a1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -180,6 +180,41 @@ static void update_balloon_size(struct virtio_balloon *vb)
 			      &actual, sizeof(actual));
 }
 
+static inline void update_stat(struct virtio_device *vdev, int feature,
+				unsigned long value, unsigned offset)
+{
+	__le32 __v = cpu_to_le32(value);
+	if (virtio_has_feature(vdev, feature))
+		vdev->config->set(vdev, offset, &__v, sizeof(__v));
+}
+
+#define K(x) ((x) << (PAGE_SHIFT - 10))
+static void update_balloon_stats(struct virtio_balloon *vb)
+{
+	unsigned long events[NR_VM_EVENT_ITEMS];
+	struct sysinfo i;
+	unsigned off = offsetof(struct virtio_balloon_config, stats);
+
+	all_vm_events(events);
+
+	update_stat(vb->vdev, VIRTIO_BALLOON_F_RPT_SWAP_IN, events[PSWPIN],
+		    off + offsetof(struct virtio_balloon_stats, pswapin));
+	update_stat(vb->vdev, VIRTIO_BALLOON_F_RPT_SWAP_OUT, events[PSWPOUT],
+		    off + offsetof(struct virtio_balloon_stats, pswapout));
+	update_stat(vb->vdev, VIRTIO_BALLOON_F_RPT_MAJFLT, events[PGMAJFAULT],
+		    off + offsetof(struct virtio_balloon_stats, pgmajfault));
+	update_stat(vb->vdev, VIRTIO_BALLOON_F_RPT_MINFLT, events[PGFAULT],
+		    off + offsetof(struct virtio_balloon_stats, pgminfault));
+	update_stat(vb->vdev, VIRTIO_BALLOON_F_RPT_ANON,
+		    K(global_page_state(NR_ANON_PAGES)),
+		    off + offsetof(struct virtio_balloon_stats, panon));
+	si_meminfo(&i);
+	update_stat(vb->vdev, VIRTIO_BALLOON_F_RPT_MEMFREE, K(i.freeram),
+		    off + offsetof(struct virtio_balloon_stats, memfree));
+	update_stat(vb->vdev, VIRTIO_BALLOON_F_RPT_MEMTOT, K(i.totalram),
+		    off + offsetof(struct virtio_balloon_stats, memtot));
+}
+
 static int balloon(void *_vballoon)
 {
 	struct virtio_balloon *vb = _vballoon;
@@ -189,15 +224,17 @@ static int balloon(void *_vballoon)
 		s64 diff;
 
 		try_to_freeze();
-		wait_event_interruptible(vb->config_change,
+		wait_event_interruptible_timeout(vb->config_change,
 					 (diff = towards_target(vb)) != 0
 					 || kthread_should_stop()
-					 || freezing(current));
+					 || freezing(current),
+					 VIRTIO_BALLOON_TIMEOUT);
 		if (diff > 0)
 			fill_balloon(vb, diff);
 		else if (diff < 0)
 			leak_balloon(vb, -diff);
 		update_balloon_size(vb);
+		update_balloon_stats(vb);
 	}
 	return 0;
 }
@@ -265,7 +302,12 @@ static void virtballoon_remove(struct virtio_device *vdev)
 	kfree(vb);
 }
 
-static unsigned int features[] = { VIRTIO_BALLOON_F_MUST_TELL_HOST };
+static unsigned int features[] = {
+	VIRTIO_BALLOON_F_MUST_TELL_HOST, VIRTIO_BALLOON_F_RPT_SWAP_IN,
+	VIRTIO_BALLOON_F_RPT_SWAP_OUT, VIRTIO_BALLOON_F_RPT_ANON,
+	VIRTIO_BALLOON_F_RPT_MAJFLT, VIRTIO_BALLOON_F_RPT_MINFLT,
+	VIRTIO_BALLOON_F_RPT_MEMFREE, VIRTIO_BALLOON_F_RPT_MEMTOT,
+};
 
 static struct virtio_driver virtio_balloon = {
 	.feature_table = features,
diff --git a/include/linux/virtio_balloon.h b/include/linux/virtio_balloon.h
index 09d7300..0bff4b8 100644
--- a/include/linux/virtio_balloon.h
+++ b/include/linux/virtio_balloon.h
@@ -6,15 +6,39 @@
 
 /* The feature bitmap for virtio balloon */
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
+                                          /* Guest memory statistic reporting */
+#define VIRTIO_BALLOON_F_RPT_SWAP_IN  1   /* Number of pages swapped in */
+#define VIRTIO_BALLOON_F_RPT_SWAP_OUT 2   /* Number of pages swapped out */
+#define VIRTIO_BALLOON_F_RPT_ANON     3   /* Number of anonymous pages in use */
+#define VIRTIO_BALLOON_F_RPT_MAJFLT   4   /* Number of major faults */
+#define VIRTIO_BALLOON_F_RPT_MINFLT   5   /* Number of minor faults */
+#define VIRTIO_BALLOON_F_RPT_MEMFREE  6   /* Total amount of free memory */
+#define VIRTIO_BALLOON_F_RPT_MEMTOT   7   /* Total amount of memory */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12
 
+struct virtio_balloon_stats
+{
+	__le32 pswapin;      /* pages swapped in */
+	__le32 pswapout;     /* pages swapped out */
+	__le32 panon;        /* anonymous pages in use (in kb) */
+	__le32 pgmajfault;   /* Major page faults */
+	__le32 pgminfault;   /* Minor page faults */
+	__le32 memfree;      /* Total amount of free memory (in kb) */
+	__le32 memtot;       /* Total amount of memory (in kb) */
+};
+
 struct virtio_balloon_config
 {
 	/* Number of pages host wants Guest to give up. */
 	__le32 num_pages;
 	/* Number of pages we've actually got in balloon. */
 	__le32 actual;
+	/* Memory statistics */
+	struct virtio_balloon_stats stats;
 };
+
+#define VIRTIO_BALLOON_TIMEOUT (30 * HZ)
+
 #endif /* _LINUX_VIRTIO_BALLOON_H */

-- 
Thanks,
Adam

