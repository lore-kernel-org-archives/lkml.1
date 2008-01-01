Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYAAPn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYAAPn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYAAPgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:33794 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 27/54] KVM: Portability: Move IO device definitions to its own header file
Date: Tue,  1 Jan 2008 17:35:53 +0200
Message-Id: <1199201780-14001-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/iodev.h    |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/irq.h      |    1 +
 drivers/kvm/kvm.h      |   42 --------------------------------
 drivers/kvm/kvm_main.c |    1 +
 4 files changed, 65 insertions(+), 42 deletions(-)
 create mode 100644 drivers/kvm/iodev.h

diff --git a/drivers/kvm/iodev.h b/drivers/kvm/iodev.h
new file mode 100644
index 0000000..eb9e8a7
--- /dev/null
+++ b/drivers/kvm/iodev.h
@@ -0,0 +1,63 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __KVM_IODEV_H__
+#define __KVM_IODEV_H__
+
+#include "types.h"
+
+struct kvm_io_device {
+	void (*read)(struct kvm_io_device *this,
+		     gpa_t addr,
+		     int len,
+		     void *val);
+	void (*write)(struct kvm_io_device *this,
+		      gpa_t addr,
+		      int len,
+		      const void *val);
+	int (*in_range)(struct kvm_io_device *this, gpa_t addr);
+	void (*destructor)(struct kvm_io_device *this);
+
+	void             *private;
+};
+
+static inline void kvm_iodevice_read(struct kvm_io_device *dev,
+				     gpa_t addr,
+				     int len,
+				     void *val)
+{
+	dev->read(dev, addr, len, val);
+}
+
+static inline void kvm_iodevice_write(struct kvm_io_device *dev,
+				      gpa_t addr,
+				      int len,
+				      const void *val)
+{
+	dev->write(dev, addr, len, val);
+}
+
+static inline int kvm_iodevice_inrange(struct kvm_io_device *dev, gpa_t addr)
+{
+	return dev->in_range(dev, addr);
+}
+
+static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
+{
+	if (dev->destructor)
+		dev->destructor(dev);
+}
+
+#endif /* __KVM_IODEV_H__ */
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 75f5f18..803b9c7 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -23,6 +23,7 @@
 #define __IRQ_H
 
 #include "kvm.h"
+#include "iodev.h"
 
 typedef void irq_request_func(void *opaque, int level);
 
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 3b0ba5a..a1b7d1c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -168,48 +168,6 @@ struct kvm_vcpu_stat {
 	u32 insn_emulation_fail;
 };
 
-struct kvm_io_device {
-	void (*read)(struct kvm_io_device *this,
-		     gpa_t addr,
-		     int len,
-		     void *val);
-	void (*write)(struct kvm_io_device *this,
-		      gpa_t addr,
-		      int len,
-		      const void *val);
-	int (*in_range)(struct kvm_io_device *this, gpa_t addr);
-	void (*destructor)(struct kvm_io_device *this);
-
-	void             *private;
-};
-
-static inline void kvm_iodevice_read(struct kvm_io_device *dev,
-				     gpa_t addr,
-				     int len,
-				     void *val)
-{
-	dev->read(dev, addr, len, val);
-}
-
-static inline void kvm_iodevice_write(struct kvm_io_device *dev,
-				      gpa_t addr,
-				      int len,
-				      const void *val)
-{
-	dev->write(dev, addr, len, val);
-}
-
-static inline int kvm_iodevice_inrange(struct kvm_io_device *dev, gpa_t addr)
-{
-	return dev->in_range(dev, addr);
-}
-
-static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
-{
-	if (dev->destructor)
-		dev->destructor(dev);
-}
-
 /*
  * It would be nice to use something smarter than a linear search, TBD...
  * Thankfully we dont expect many devices to register (famous last words :),
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index b56ee34..8d4a06d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -18,6 +18,7 @@
 #include "kvm.h"
 #include "x86.h"
 #include "irq.h"
+#include "iodev.h"
 
 #include <linux/kvm.h>
 #include <linux/module.h>
-- 
1.5.3.7

