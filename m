Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZLTRTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZLTRTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZLTRTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:19:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZLTRTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:19:16 -0500
Date: Sun, 20 Dec 2009 19:16:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/3] vhost: add access_ok checks
Message-ID: <20091220171625.GC31713@redhat.com>
References: <cover.1261329297.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1261329297.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On biarch kernels, it is not safe to do copy from/to user, even with use_mm,
unless we checked the address range with access_ok previously.  Implement these
checks to enforce safe memory accesses.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c   |   17 ++++++-
 drivers/vhost/vhost.c |  111 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h |    2 +
 3 files changed, 127 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 1b509a0..1aacd8c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -493,6 +493,12 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	}
 	vq = n->vqs + index;
 	mutex_lock(&vq->mutex);
+
+	/* Verify that ring has been setup correctly. */
+	if (!vhost_vq_access_ok(vq)) {
+		r = -EFAULT;
+		goto err;
+	}
 	sock = get_socket(fd);
 	if (IS_ERR(sock)) {
 		r = PTR_ERR(sock);
@@ -539,12 +545,17 @@ done:
 	return err;
 }
 
-static void vhost_net_set_features(struct vhost_net *n, u64 features)
+static int vhost_net_set_features(struct vhost_net *n, u64 features)
 {
 	size_t hdr_size = features & (1 << VHOST_NET_F_VIRTIO_NET_HDR) ?
 		sizeof(struct virtio_net_hdr) : 0;
 	int i;
 	mutex_lock(&n->dev.mutex);
+	if ((features & (1 << VHOST_F_LOG_ALL)) &&
+	    !vhost_log_access_ok(&n->dev)) {
+		mutex_unlock(&n->dev.mutex);
+		return -EFAULT;
+	}
 	n->dev.acked_features = features;
 	smp_wmb();
 	for (i = 0; i < VHOST_NET_VQ_MAX; ++i) {
@@ -554,6 +565,7 @@ static void vhost_net_set_features(struct vhost_net *n, u64 features)
 	}
 	vhost_net_flush(n);
 	mutex_unlock(&n->dev.mutex);
+	return 0;
 }
 
 static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
@@ -580,8 +592,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return r;
 		if (features & ~VHOST_FEATURES)
 			return -EOPNOTSUPP;
-		vhost_net_set_features(n, features);
-		return 0;
+		return vhost_net_set_features(n, features);
 	case VHOST_RESET_OWNER:
 		return vhost_net_reset_owner(n);
 	default:
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 29f1675..33e06bf 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -224,6 +224,91 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	dev->mm = NULL;
 }
 
+static int log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
+{
+	u64 a = addr / VHOST_PAGE_SIZE / 8;
+	/* Make sure 64 bit math will not overflow. */
+	if (a > ULONG_MAX - (unsigned long)log_base ||
+	    a + (unsigned long)log_base > ULONG_MAX)
+		return -EFAULT;
+
+	return access_ok(VERIFY_WRITE, log_base + a,
+			 (sz + VHOST_PAGE_SIZE * 8 - 1) / VHOST_PAGE_SIZE / 8);
+}
+
+/* Caller should have vq mutex and device mutex. */
+static int vq_memory_access_ok(struct vhost_virtqueue *vq, struct vhost_memory *mem,
+			       int log_all)
+{
+	int i;
+	for (i = 0; i < mem->nregions; ++i) {
+		struct vhost_memory_region *m = mem->regions + i;
+		unsigned long a = m->userspace_addr;
+		if (m->memory_size > ULONG_MAX)
+			return 0;
+		else if (!access_ok(VERIFY_WRITE, (void __user *)a,
+				    m->memory_size))
+			return 0;
+		else if (log_all && !log_access_ok(vq->log_base,
+						   m->guest_phys_addr,
+						   m->memory_size))
+			return 0;
+	}
+	return 1;
+}
+
+/* Can we switch to this memory table? */
+/* Caller should have device mutex but not vq mutex */
+static int memory_access_ok(struct vhost_dev *d, struct vhost_memory *mem,
+			    int log_all)
+{
+	int i;
+	for (i = 0; i < d->nvqs; ++i) {
+		int ok;
+		mutex_lock(&d->vqs[i].mutex);
+		/* If ring is not running, will check when it's enabled. */
+		if (&d->vqs[i].private_data)
+			ok = vq_memory_access_ok(&d->vqs[i], mem, log_all);
+		else
+			ok = 1;
+		mutex_unlock(&d->vqs[i].mutex);
+		if (!ok)
+			return 0;
+	}
+	return 1;
+}
+
+static int vq_access_ok(unsigned int num,
+			struct vring_desc __user *desc,
+			struct vring_avail __user *avail,
+			struct vring_used __user *used)
+{
+	return access_ok(VERIFY_READ, desc, num * sizeof *desc) &&
+	       access_ok(VERIFY_READ, avail,
+			 sizeof *avail + num * sizeof *avail->ring) &&
+	       access_ok(VERIFY_WRITE, used,
+			sizeof *used + num * sizeof *used->ring);
+}
+
+/* Can we log writes? */
+/* Caller should have device mutex but not vq mutex */
+int vhost_log_access_ok(struct vhost_dev *dev)
+{
+	return memory_access_ok(dev, dev->memory, 1);
+}
+
+/* Can we start vq? */
+/* Caller should have vq mutex and device mutex */
+int vhost_vq_access_ok(struct vhost_virtqueue *vq)
+{
+	return vq_access_ok(vq->num, vq->desc, vq->avail, vq->used) &&
+		vq_memory_access_ok(vq, vq->dev->memory,
+			    vhost_has_feature(vq->dev, VHOST_F_LOG_ALL)) &&
+		(!vq->log_used || log_access_ok(vq->log_base, vq->log_addr,
+					sizeof *vq->used +
+					vq->num * sizeof *vq->used->ring));
+}
+
 static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 {
 	struct vhost_memory mem, *newmem, *oldmem;
@@ -247,6 +332,9 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		kfree(newmem);
 		return r;
 	}
+
+	if (!memory_access_ok(d, newmem, vhost_has_feature(d, VHOST_F_LOG_ALL)))
+		return -EFAULT;
 	oldmem = d->memory;
 	rcu_assign_pointer(d->memory, newmem);
 	synchronize_rcu();
@@ -348,6 +436,29 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
 			r = -EINVAL;
 			break;
 		}
+
+		/* We only verify access here if backend is configured.
+		 * If it is not, we don't as size might not have been setup.
+		 * We will verify when backend is configured. */
+		if (vq->private_data) {
+			if (!vq_access_ok(vq->num,
+				(void __user *)(unsigned long)a.desc_user_addr,
+				(void __user *)(unsigned long)a.avail_user_addr,
+				(void __user *)(unsigned long)a.used_user_addr)) {
+				r = -EINVAL;
+				break;
+			}
+
+			/* Also validate log access for used ring if enabled. */
+			if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
+			    !log_access_ok(vq->log_base, a.log_guest_addr,
+					   sizeof *vq->used +
+					   vq->num * sizeof *vq->used->ring)) {
+				r = -EINVAL;
+				break;
+			}
+		}
+
 		r = init_used(vq, (struct vring_used __user *)(unsigned long)
 			      a.used_user_addr);
 		if (r)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d1f0453..44591ba 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -117,6 +117,8 @@ long vhost_dev_check_owner(struct vhost_dev *);
 long vhost_dev_reset_owner(struct vhost_dev *);
 void vhost_dev_cleanup(struct vhost_dev *);
 long vhost_dev_ioctl(struct vhost_dev *, unsigned int ioctl, unsigned long arg);
+int vhost_vq_access_ok(struct vhost_virtqueue *vq);
+int vhost_log_access_ok(struct vhost_dev *);
 
 unsigned vhost_get_vq_desc(struct vhost_dev *, struct vhost_virtqueue *,
 			   struct iovec iov[], unsigned int iov_count,
-- 
1.6.6.rc1.43.gf55cc

