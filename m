Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZJBUTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZJBUTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbZJBUTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:19:41 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59887 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022AbZJBUTf (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 2 Oct 2009 16:19:35 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 3/4] KVM: add io services to xinterface
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Fri, 02 Oct 2009 16:19:32 -0400
Message-ID: <20091002201932.4014.91402.stgit@dev.haskins.net>
In-Reply-To: <20091002201159.4014.33268.stgit@dev.haskins.net>
References: <20091002201159.4014.33268.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to add a more efficient way to get PIO signals out of the guest,
so we add an "xioevent" interface.  This allows a client to register
for notifications when a specific MMIO/PIO address is touched by
the guest.  This is an alternative interface to ioeventfd, which is
performance limited by io-bus scaling and eventfd wait-queue based
notification mechanism.  This also has the advantage of retaining
the full PIO data payload and passing it to the recipient.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/kvm_xinterface.h |   47 ++++++++++++++++++
 virt/kvm/xinterface.c          |  106 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 153 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_xinterface.h b/include/linux/kvm_xinterface.h
index 01f092b..684b6f8 100644
--- a/include/linux/kvm_xinterface.h
+++ b/include/linux/kvm_xinterface.h
@@ -12,6 +12,16 @@
 
 struct kvm_xinterface;
 struct kvm_xvmap;
+struct kvm_xioevent;
+
+enum {
+	kvm_xioevent_flag_nr_pio,
+	kvm_xioevent_flag_nr_max,
+};
+
+#define KVM_XIOEVENT_FLAG_PIO       (1 << kvm_xioevent_flag_nr_pio)
+
+#define KVM_XIOEVENT_VALID_FLAG_MASK  ((1 << kvm_xioevent_flag_nr_max) - 1)
 
 struct kvm_xinterface_ops {
 	unsigned long (*copy_to)(struct kvm_xinterface *intf,
@@ -22,6 +32,10 @@ struct kvm_xinterface_ops {
 	struct kvm_xvmap* (*vmap)(struct kvm_xinterface *intf,
 				  unsigned long gpa,
 				  unsigned long len);
+	struct kvm_xioevent* (*ioevent)(struct kvm_xinterface *intf,
+					u64 addr,
+					unsigned long len,
+					unsigned long flags);
 	void (*release)(struct kvm_xinterface *);
 };
 
@@ -109,6 +123,39 @@ kvm_xvmap_put(struct kvm_xvmap *vmap)
 	kref_put(&vmap->kref, _kvm_xvmap_release);
 }
 
+struct kvm_xioevent_ops {
+	void (*deassign)(struct kvm_xioevent *ioevent);
+};
+
+struct kvm_xioevent {
+	const struct kvm_xioevent_ops *ops;
+	struct kvm_xinterface         *intf;
+	void (*signal)(struct kvm_xioevent *ioevent, const void *val);
+	void                          *priv;
+};
+
+static inline void
+kvm_xioevent_init(struct kvm_xioevent *ioevent,
+		  const struct kvm_xioevent_ops *ops,
+		  struct kvm_xinterface *intf)
+{
+	memset(ioevent, 0, sizeof(vmap));
+	ioevent->ops = ops;
+	ioevent->intf = intf;
+
+	kvm_xinterface_get(intf);
+}
+
+static inline void
+kvm_xioevent_deassign(struct kvm_xioevent *ioevent)
+{
+	struct kvm_xinterface *intf = ioevent->intf;
+	rmb();
+
+	ioevent->ops->deassign(ioevent);
+	kvm_xinterface_put(intf);
+}
+
 struct kvm_xinterface *kvm_xinterface_bind(int fd);
 
 #endif /* __KVM_XINTERFACE_H */
diff --git a/virt/kvm/xinterface.c b/virt/kvm/xinterface.c
index 3b586c5..c356835 100644
--- a/virt/kvm/xinterface.c
+++ b/virt/kvm/xinterface.c
@@ -28,6 +28,8 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm_xinterface.h>
 
+#include "iodev.h"
+
 struct _xinterface {
 	struct kvm             *kvm;
 	struct task_struct     *task;
@@ -42,6 +44,14 @@ struct _xvmap {
 	struct kvm_xvmap           vmap;
 };
 
+struct _ioevent {
+	u64                   addr;
+	int                   length;
+	struct kvm_io_bus    *bus;
+	struct kvm_io_device  dev;
+	struct kvm_xioevent   ioevent;
+};
+
 static struct _xinterface *
 to_intf(struct kvm_xinterface *intf)
 {
@@ -362,6 +372,101 @@ fail:
 	return ERR_PTR(ret);
 }
 
+/* MMIO/PIO writes trigger an event if the addr/val match */
+static int
+ioevent_write(struct kvm_io_device *dev, gpa_t addr, int len, const void *val)
+{
+	struct _ioevent *p = container_of(dev, struct _ioevent, dev);
+	struct kvm_xioevent *ioevent = &p->ioevent;
+
+	if (!(addr == p->addr && len == p->length))
+		return -EOPNOTSUPP;
+
+	if (!ioevent->signal)
+		return 0;
+
+	ioevent->signal(ioevent, val);
+	return 0;
+}
+
+static const struct kvm_io_device_ops ioevent_device_ops = {
+	.write = ioevent_write,
+};
+
+static void
+ioevent_deassign(struct kvm_xioevent *ioevent)
+{
+	struct _ioevent    *p = container_of(ioevent, struct _ioevent, ioevent);
+	struct _xinterface *_intf = to_intf(ioevent->intf);
+	struct kvm         *kvm = _intf->kvm;
+
+	kvm_io_bus_unregister_dev(kvm, p->bus, &p->dev);
+	kfree(p);
+}
+
+static const struct kvm_xioevent_ops ioevent_intf_ops = {
+	.deassign = ioevent_deassign,
+};
+
+static struct kvm_xioevent*
+xinterface_ioevent(struct kvm_xinterface *intf,
+		   u64 addr,
+		   unsigned long len,
+		   unsigned long flags)
+{
+	struct _xinterface         *_intf = to_intf(intf);
+	struct kvm                 *kvm = _intf->kvm;
+	int                         pio = flags & KVM_XIOEVENT_FLAG_PIO;
+	struct kvm_io_bus          *bus = pio ? &kvm->pio_bus : &kvm->mmio_bus;
+	struct _ioevent            *p;
+	int                         ret;
+
+	/* must be natural-word sized */
+	switch (len) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* check for range overflow */
+	if (addr + len < addr)
+		return ERR_PTR(-EINVAL);
+
+	/* check for extra flags that we don't understand */
+	if (flags & ~KVM_XIOEVENT_VALID_FLAG_MASK)
+		return ERR_PTR(-EINVAL);
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	p->addr    = addr;
+	p->length  = len;
+	p->bus     = bus;
+
+	kvm_iodevice_init(&p->dev, &ioevent_device_ops);
+
+	ret = kvm_io_bus_register_dev(kvm, bus, &p->dev);
+	if (ret < 0)
+		goto fail;
+
+	kvm_xioevent_init(&p->ioevent, &ioevent_intf_ops, intf);
+
+	return &p->ioevent;
+
+fail:
+	kfree(p);
+
+	return ERR_PTR(ret);
+
+}
+
 static void
 xinterface_release(struct kvm_xinterface *intf)
 {
@@ -377,6 +482,7 @@ struct kvm_xinterface_ops _xinterface_ops = {
 	.copy_to     = xinterface_copy_to,
 	.copy_from   = xinterface_copy_from,
 	.vmap        = xinterface_vmap,
+	.ioevent     = xinterface_ioevent,
 	.release     = xinterface_release,
 };
 

