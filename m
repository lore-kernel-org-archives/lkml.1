Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYJ1Kzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYJ1Kzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYJ1KzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:55:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52893 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYJ1KzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:55:22 -0400
Date: Tue, 28 Oct 2008 11:55:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] core / iommu / xen fixes
Message-ID: <20081028105510.GA26679@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

[ the commits look x86-ish, but got filed here because the iommu fixes 
  affect lib/swiotlb.c, and the Xen fixes affect drivers/xen/ ]

 Thanks,

	Ingo

------------------>
FUJITA Tomonori (3):
      swiotlb: remove panic for alloc_coherent failure
      x86: use GFP_DMA for 24bit coherent_dma_mask
      x86: restore the old swiotlb alloc_coherent behavior

Heiko Carstens (1):
      lockdep: fix irqs on/off ip tracing

Isaku Yamahata (2):
      xen: portability clean up and some minor clean up for xencomm.c
      xen: compilation fix of drivers/xen/events.c on IA64

Jeremy Fitzhardinge (1):
      xen: don't reload cr3 on suspend

Paul Mundt (1):
      kernel/resource: fix reserve_region_with_split() section mismatch

qinghuang feng (1):
      lockdep: minor fix for debug_show_all_locks()

roel kluin (1):
      printk: remove unused code from kernel/printk.c


 arch/x86/include/asm/dma-mapping.h |    4 ++-
 arch/x86/kernel/pci-swiotlb_64.c   |   14 ++++++++++++-
 drivers/xen/events.c               |    2 +-
 drivers/xen/manage.c               |    2 -
 drivers/xen/xencomm.c              |   23 +++-----------------
 kernel/lockdep.c                   |   17 +++++++--------
 kernel/printk.c                    |   39 ------------------------------------
 kernel/resource.c                  |    2 +-
 lib/swiotlb.c                      |    6 +++-
 9 files changed, 34 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 4a5397b..7f225a4 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -255,9 +255,11 @@ static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
 
 static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
 {
-#ifdef CONFIG_X86_64
 	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
 
+	if (dma_mask <= DMA_24BIT_MASK)
+		gfp |= GFP_DMA;
+#ifdef CONFIG_X86_64
 	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index c4ce033..3c539d1 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,9 +18,21 @@ swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
+static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flags)
+{
+	void *vaddr;
+
+	vaddr = dma_generic_alloc_coherent(hwdev, size, dma_handle, flags);
+	if (vaddr)
+		return vaddr;
+
+	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
+}
+
 struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
-	.alloc_coherent = swiotlb_alloc_coherent,
+	.alloc_coherent = x86_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
 	.map_single = swiotlb_map_single_phys,
 	.unmap_single = swiotlb_unmap_single,
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 9ce1ab6..1e3b934 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -774,7 +774,7 @@ void xen_poll_irq(int irq)
 
 		poll.nr_ports = 1;
 		poll.timeout = 0;
-		poll.ports = &evtchn;
+		set_xen_guest_handle(poll.ports, &evtchn);
 
 		if (HYPERVISOR_sched_op(SCHEDOP_poll, &poll) != 0)
 			BUG();
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index d0e87cb..9b91617 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -39,8 +39,6 @@ static int xen_suspend(void *data)
 
 	BUG_ON(!irqs_disabled());
 
-	load_cr3(swapper_pg_dir);
-
 	err = device_power_down(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "xen_suspend: device_power_down failed: %d\n",
diff --git a/drivers/xen/xencomm.c b/drivers/xen/xencomm.c
index 797cb4e..a240b2c 100644
--- a/drivers/xen/xencomm.c
+++ b/drivers/xen/xencomm.c
@@ -23,13 +23,7 @@
 #include <asm/page.h>
 #include <xen/xencomm.h>
 #include <xen/interface/xen.h>
-#ifdef __ia64__
-#include <asm/xen/xencomm.h>	/* for is_kern_addr() */
-#endif
-
-#ifdef HAVE_XEN_PLATFORM_COMPAT_H
-#include <xen/platform-compat.h>
-#endif
+#include <asm/xen/xencomm.h>	/* for xencomm_is_phys_contiguous() */
 
 static int xencomm_init(struct xencomm_desc *desc,
 			void *buffer, unsigned long bytes)
@@ -157,20 +151,11 @@ static int xencomm_create(void *buffer, unsigned long bytes,
 	return 0;
 }
 
-/* check if memory address is within VMALLOC region  */
-static int is_phys_contiguous(unsigned long addr)
-{
-	if (!is_kernel_addr(addr))
-		return 0;
-
-	return (addr < VMALLOC_START) || (addr >= VMALLOC_END);
-}
-
 static struct xencomm_handle *xencomm_create_inline(void *ptr)
 {
 	unsigned long paddr;
 
-	BUG_ON(!is_phys_contiguous((unsigned long)ptr));
+	BUG_ON(!xencomm_is_phys_contiguous((unsigned long)ptr));
 
 	paddr = (unsigned long)xencomm_pa(ptr);
 	BUG_ON(paddr & XENCOMM_INLINE_FLAG);
@@ -202,7 +187,7 @@ struct xencomm_handle *xencomm_map(void *ptr, unsigned long bytes)
 	int rc;
 	struct xencomm_desc *desc;
 
-	if (is_phys_contiguous((unsigned long)ptr))
+	if (xencomm_is_phys_contiguous((unsigned long)ptr))
 		return xencomm_create_inline(ptr);
 
 	rc = xencomm_create(ptr, bytes, &desc, GFP_KERNEL);
@@ -219,7 +204,7 @@ struct xencomm_handle *__xencomm_map_no_alloc(void *ptr, unsigned long bytes,
 	int rc;
 	struct xencomm_desc *desc = NULL;
 
-	if (is_phys_contiguous((unsigned long)ptr))
+	if (xencomm_is_phys_contiguous((unsigned long)ptr))
 		return xencomm_create_inline(ptr);
 
 	rc = xencomm_create_mini(ptr, bytes, xc_desc,
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index dbda475..06e1571 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2169,12 +2169,11 @@ void early_boot_irqs_on(void)
 /*
  * Hardirqs will be enabled:
  */
-void trace_hardirqs_on_caller(unsigned long a0)
+void trace_hardirqs_on_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
-	unsigned long ip;
 
-	time_hardirqs_on(CALLER_ADDR0, a0);
+	time_hardirqs_on(CALLER_ADDR0, ip);
 
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
@@ -2188,7 +2187,6 @@ void trace_hardirqs_on_caller(unsigned long a0)
 	}
 	/* we'll do an OFF -> ON transition: */
 	curr->hardirqs_enabled = 1;
-	ip = (unsigned long) __builtin_return_address(0);
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
@@ -2224,11 +2222,11 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off_caller(unsigned long a0)
+void trace_hardirqs_off_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	time_hardirqs_off(CALLER_ADDR0, a0);
+	time_hardirqs_off(CALLER_ADDR0, ip);
 
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
@@ -2241,7 +2239,7 @@ void trace_hardirqs_off_caller(unsigned long a0)
 		 * We have done an ON -> OFF transition:
 		 */
 		curr->hardirqs_enabled = 0;
-		curr->hardirq_disable_ip = _RET_IP_;
+		curr->hardirq_disable_ip = ip;
 		curr->hardirq_disable_event = ++curr->irq_events;
 		debug_atomic_inc(&hardirqs_off_events);
 	} else
@@ -3417,9 +3415,10 @@ retry:
 		}
 		printk(" ignoring it.\n");
 		unlock = 0;
+	} else {
+		if (count != 10)
+			printk(KERN_CONT " locked it.\n");
 	}
-	if (count != 10)
-		printk(" locked it.\n");
 
 	do_each_thread(g, p) {
 		/*
diff --git a/kernel/printk.c b/kernel/printk.c
index 6341af7..f492f15 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -233,45 +233,6 @@ static inline void boot_delay_msec(void)
 #endif
 
 /*
- * Return the number of unread characters in the log buffer.
- */
-static int log_buf_get_len(void)
-{
-	return logged_chars;
-}
-
-/*
- * Copy a range of characters from the log buffer.
- */
-int log_buf_copy(char *dest, int idx, int len)
-{
-	int ret, max;
-	bool took_lock = false;
-
-	if (!oops_in_progress) {
-		spin_lock_irq(&logbuf_lock);
-		took_lock = true;
-	}
-
-	max = log_buf_get_len();
-	if (idx < 0 || idx >= max) {
-		ret = -1;
-	} else {
-		if (len > max)
-			len = max;
-		ret = len;
-		idx += (log_end - max);
-		while (len-- > 0)
-			dest[len] = LOG_BUF(idx + len);
-	}
-
-	if (took_lock)
-		spin_unlock_irq(&logbuf_lock);
-
-	return ret;
-}
-
-/*
  * Commands to do_syslog:
  *
  * 	0 -- Close the log.  Currently a NOP.
diff --git a/kernel/resource.c b/kernel/resource.c
index 4089d12..7fec0e4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -571,7 +571,7 @@ static void __init __reserve_region_with_split(struct resource *root,
 
 }
 
-void reserve_region_with_split(struct resource *root,
+void __init reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
 		const char *name)
 {
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index f8eebd4..78330c3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -497,8 +497,10 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)*hwdev->dma_mask,
 		       (unsigned long long)dev_addr);
-		panic("swiotlb_alloc_coherent: allocated memory is out of "
-		      "range for device");
+
+		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
+		unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
+		return NULL;
 	}
 	*dma_handle = dev_addr;
 	return ret;
