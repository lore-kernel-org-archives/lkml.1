Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbZEUN1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbZEUN1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZEUN1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:27:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43548 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZEUN1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:27:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2--refid=<20090521172122.bb12027c.sfr@canb.auug.org.au>] kvm:
	fix irqfd build failure discovered in linux-next
To: avi@redhat.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, kvm@vger.kernel.org
Date: Thu, 21 May 2009 09:27:24 -0400
Message-ID: <20090521132723.8177.20321.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell noted a build failure in arch != x86 in last nights
linux-next tree, as noted here:

http://lkml.org/lkml/2009/5/21/32

This patch corrects the build issue by requiring explicit support for
IRQFD to be defined, and only defining it on x86 (the only arch fully
supported).  The code itself isnt architecture dependent, but we need
to add a new file to each makefile, advertise the capability, and
of course, test that it works for each supported arch.  We will submit
patches against each relevant arch at a later time to enable support
there as well.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/Kconfig     |    4 ++++
 include/linux/kvm_host.h |   17 +++++++++++++++++
 virt/kvm/eventfd.c       |    6 ++++++
 virt/kvm/kvm_main.c      |    2 +-
 4 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8600a09..6460091 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -8,6 +8,10 @@ config HAVE_KVM_IRQCHIP
        bool
        default y
 
+config HAVE_KVM_EVENTFD
+       bool
+       default y
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	depends on HAVE_KVM || X86
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b6caf5..28bd112 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -134,7 +134,9 @@ struct kvm {
 	struct list_head vm_list;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
+#ifdef CONFIG_HAVE_KVM_EVENTFD
 	struct list_head irqfds;
+#endif
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
 	atomic_t users_count;
@@ -529,7 +531,22 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 
 #endif
 
+#ifdef CONFIG_HAVE_KVM_EVENTFD
+
+void kvm_irqfd_init(struct kvm *kvm);
 int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
 void kvm_irqfd_release(struct kvm *kvm);
 
+#else
+
+static inline void kvm_irqfd_init(struct kvm *kvm) {}
+static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+{
+	return -EINVAL;
+}
+
+static inline void kvm_irqfd_release(struct kvm *kvm) {}
+
+#endif /* CONFIG_HAVE_KVM_EVENTFD */
+
 #endif
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 72a282e..c63ff6a 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -206,6 +206,12 @@ kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
 	return count ? count : -ENOENT;
 }
 
+void
+kvm_irqfd_init(struct kvm *kvm)
+{
+	INIT_LIST_HEAD(&kvm->irqfds);
+}
+
 int
 kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b58837d..de042cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -983,7 +983,7 @@ static struct kvm *kvm_create_vm(void)
 	atomic_inc(&kvm->mm->mm_count);
 	spin_lock_init(&kvm->mmu_lock);
 	kvm_io_bus_init(&kvm->pio_bus);
-	INIT_LIST_HEAD(&kvm->irqfds);
+	kvm_irqfd_init(kvm);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	init_rwsem(&kvm->slots_lock);

