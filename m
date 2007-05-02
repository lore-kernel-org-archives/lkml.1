Return-Path: <linux-kernel-owner+w=401wt.eu-S1766745AbXEBWhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766745AbXEBWhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766752AbXEBWhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:37:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:32907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766745AbXEBWhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,482,1170662400"; 
   d="scan'208";a="82898830"
Subject: [GIT PULL] I/OAT updates for 2.6.22
From: Chris Leech <christopher.leech@intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 02 May 2007 15:37:40 -0700
Message-Id: <1178145460.16258.3.camel@cleech-lnx>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 02 May 2007 22:37:35.0534 (UTC) FILETIME=[7AF3DCE0:01C78D0A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dc87c3985e9b442c60994308a96f887579addc39:
  Linus Torvalds (1):
        libata: honour host controllers that want just one host

are found in the git repository at:

  git://lost.foo-projects.org/~cleech/linux-2.6

Andrew Morton (1):
      I/OAT: warning fix

Chris Leech (6):
      ioatdma: Push pending transactions to hardware more frequently
      ioatdma: Remove the wrappers around read(bwl)/write(bwl) in ioatdma
      ioatdma: Remove the use of writeq from the ioatdma driver
      I/OAT: Add documentation for the tcp_dma_copybreak sysctl
      I/OAT: Add entries to MAINTAINERS for the DMA memcpy subsystem and ioatdma
      I/OAT: Only offload copies for TCP when there will be a context switch

Dan Aloni (1):
      I/OAT: fix I/OAT for kexec

Jeff Garzik (1):
      drivers/dma: handle sysfs errors

 Documentation/networking/ip-sysctl.txt |    6 ++
 MAINTAINERS                            |   12 +++
 drivers/dma/dmaengine.c                |   22 ++++++-
 drivers/dma/ioatdma.c                  |   81 ++++++++++++----------
 drivers/dma/ioatdma_io.h               |  118 --------------------------------
 net/ipv4/tcp.c                         |   26 +++++--
 6 files changed, 100 insertions(+), 165 deletions(-)
 delete mode 100644 drivers/dma/ioatdma_io.h

commit 3d89ce83ead8eed2d638f5563af7f88c1ebd9acf
Author: Dan Aloni <da\-x@monatomic.org>
Date:   Wed May 2 15:25:13 2007 -0700

    I/OAT: fix I/OAT for kexec
    
    Under kexec, I/OAT initialization breaks over busy resources because the
    previous kernel did not release them.
    
    I'm not sure this fix can be considered a complete one but it works for me.
     I guess something similar to the *_remove method should occur there..
    
    Signed-off-by: Dan Aloni <da-x@monatomic.org>
    Signed-off-by: Chris Leech <christopher.leech@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index cbf93ca..1d259e5 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -41,6 +41,7 @@
 
 /* internal functions */
 static int __devinit ioat_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void ioat_shutdown(struct pci_dev *pdev);
 static void __devexit ioat_remove(struct pci_dev *pdev);
 
 static int enumerate_dma_channels(struct ioat_device *device)
@@ -557,6 +558,7 @@ static struct pci_driver ioat_pci_drv = {
 	.name 	= "ioatdma",
 	.id_table = ioat_pci_tbl,
 	.probe	= ioat_probe,
+	.shutdown = ioat_shutdown,
 	.remove	= __devexit_p(ioat_remove),
 };
 
@@ -781,9 +783,20 @@ err_request_regions:
 err_set_dma_mask:
 	pci_disable_device(pdev);
 err_enable_device:
+
+	printk(KERN_ERR "Intel(R) I/OAT DMA Engine initialization failed\n");
+
 	return err;
 }
 
+static void ioat_shutdown(struct pci_dev *pdev)
+{
+	struct ioat_device *device;
+	device = pci_get_drvdata(pdev);
+
+	dma_async_device_unregister(&device->common);
+}
+
 static void __devexit ioat_remove(struct pci_dev *pdev)
 {
 	struct ioat_device *device;

commit 65e6d03f6c1bec1607febe9dfdc8a99b572b882f
Author: Andrew Morton <akpm@osdl.org>
Date:   Wed May 2 15:25:12 2007 -0700

    I/OAT: warning fix
    net/ipv4/tcp.c: In function 'tcp_recvmsg':
    net/ipv4/tcp.c:1111: warning: unused variable 'available'
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e97b45a..9dfa2b6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1113,7 +1113,6 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	long timeo;
 	struct task_struct *user_recv = NULL;
 	int copied_early = 0;
-	int available = 0;
 	struct sk_buff *skb;
 
 	lock_sock(sk);
@@ -1142,15 +1141,22 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	tp->ucopy.dma_chan = NULL;
 	preempt_disable();
 	skb = skb_peek_tail(&sk->sk_receive_queue);
-	if (skb)
-		available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
-	if ((available < target) &&
-	    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
-	    !sysctl_tcp_low_latency && __get_cpu_var(softnet_data).net_dma) {
-		preempt_enable_no_resched();
-		tp->ucopy.pinned_list = dma_pin_iovec_pages(msg->msg_iov, len);
-	} else
-		preempt_enable_no_resched();
+	{
+		int available = 0;
+
+		if (skb)
+			available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
+		if ((available < target) &&
+		    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
+		    !sysctl_tcp_low_latency &&
+		    __get_cpu_var(softnet_data).net_dma) {
+			preempt_enable_no_resched();
+			tp->ucopy.pinned_list =
+					dma_pin_iovec_pages(msg->msg_iov, len);
+		} else {
+			preempt_enable_no_resched();
+		}
+	}
 #endif
 
 	do {

commit a199d97c5171b50b7568c1250d803b60700ff1f5
Author: Chris Leech <christopher.leech@intel.com>
Date:   Wed May 2 15:25:12 2007 -0700

    I/OAT: Only offload copies for TCP when there will be a context switch
    The performance wins come with having the DMA copy engine doing the copies
    in parallel with the context switch.  If there is enough data ready on the
    socket at recv time just use a regular copy.
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d6e4886..e97b45a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1113,6 +1113,8 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	long timeo;
 	struct task_struct *user_recv = NULL;
 	int copied_early = 0;
+	int available = 0;
+	struct sk_buff *skb;
 
 	lock_sock(sk);
 
@@ -1139,7 +1141,11 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 #ifdef CONFIG_NET_DMA
 	tp->ucopy.dma_chan = NULL;
 	preempt_disable();
-	if ((len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
+	skb = skb_peek_tail(&sk->sk_receive_queue);
+	if (skb)
+		available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
+	if ((available < target) &&
+	    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
 	    !sysctl_tcp_low_latency && __get_cpu_var(softnet_data).net_dma) {
 		preempt_enable_no_resched();
 		tp->ucopy.pinned_list = dma_pin_iovec_pages(msg->msg_iov, len);
@@ -1148,7 +1154,6 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 #endif
 
 	do {
-		struct sk_buff *skb;
 		u32 offset;
 
 		/* Are we at urgent data? Stop if we have read anything or have SIGURG pending. */
@@ -1436,7 +1441,6 @@ skip_copy:
 
 #ifdef CONFIG_NET_DMA
 	if (tp->ucopy.dma_chan) {
-		struct sk_buff *skb;
 		dma_cookie_t done, used;
 
 		dma_async_memcpy_issue_pending(tp->ucopy.dma_chan);

commit 67819adf8c0277b9bb6fc5e134e27d5a4337f1c4
Author: Chris Leech <christopher.leech@intel.com>
Date:   Wed May 2 15:25:12 2007 -0700

    I/OAT: Add entries to MAINTAINERS for the DMA memcpy subsystem and ioatdma
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index af1c792..0bc6ab8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1186,6 +1186,12 @@ M:	tori@unhappy.mine.nu
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+DMA GENERIC MEMCPY SUBSYSTEM
+P:	Chris Leech
+M:	christopher.leech@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
@@ -1791,6 +1797,12 @@ P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
 
+INTEL I/OAT DMA DRIVER
+P:	Chris Leech
+M:	christopher.leech@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net

commit b083c113825d8a8c90bd91a8ac5fb6e1c5164434
Author: Chris Leech <christopher.leech@intel.com>
Date:   Wed May 2 15:25:12 2007 -0700

    I/OAT: Add documentation for the tcp_dma_copybreak sysctl
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index af6a63a..8f6067e 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -433,6 +433,12 @@ tcp_workaround_signed_windows - BOOLEAN
 	not receive a window scaling option from them.
 	Default: 0
 
+tcp_dma_copybreak - INTEGER
+	Lower limit, in bytes, of the size of socket reads that will be
+	offloaded to a DMA copy engine, if one is present in the system
+	and CONFIG_NET_DMA is enabled.
+	Default: 4096
+
 CIPSOv4 Variables:
 
 cipso_cache_enable - BOOLEAN

commit 8fcb5f5d7b7babe0085495133cb1f32a2e720e9d
Author: Chris Leech <christopher.leech@intel.com>
Date:   Wed May 2 15:25:11 2007 -0700

    ioatdma: Remove the use of writeq from the ioatdma driver
    There's only one now anyway, and it's not in a performance path,
    so make it behave the same on 32-bit and 64-bit CPUs.
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index ec11131..cbf93ca 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -608,13 +608,11 @@ static void ioat_start_null_desc(struct ioat_dma_chan *ioat_chan)
 	list_add_tail(&desc->node, &ioat_chan->used_desc);
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
-#if (BITS_PER_LONG == 64)
-	writeq(desc->phys, ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET);
-#else
-	writel((u32) desc->phys,
+	writel(((u64) desc->phys) & 0x00000000FFFFFFFF,
 	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_LOW);
-	writel(0, ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_HIGH);
-#endif
+	writel(((u64) desc->phys) >> 32,
+	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_HIGH);
+
 	writeb(IOAT_CHANCMD_START, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 }
 

commit 2f380fbb2757ef96eab0a508e373fe3ed34c7595
Author: Chris Leech <christopher.leech@intel.com>
Date:   Wed May 2 15:25:11 2007 -0700

    ioatdma: Remove the wrappers around read(bwl)/write(bwl) in ioatdma
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 0f77a9d..ec11131 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include "ioatdma.h"
-#include "ioatdma_io.h"
 #include "ioatdma_registers.h"
 #include "ioatdma_hw.h"
 
@@ -51,8 +50,8 @@ static int enumerate_dma_channels(struct ioat_device *device)
 	int i;
 	struct ioat_dma_chan *ioat_chan;
 
-	device->common.chancnt = ioatdma_read8(device, IOAT_CHANCNT_OFFSET);
-	xfercap_scale = ioatdma_read8(device, IOAT_XFERCAP_OFFSET);
+	device->common.chancnt = readb(device->reg_base + IOAT_CHANCNT_OFFSET);
+	xfercap_scale = readb(device->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
 
 	for (i = 0; i < device->common.chancnt; i++) {
@@ -123,7 +122,7 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 	 * In-use bit automatically set by reading chanctrl
 	 * If 0, we got it, if 1, someone else did
 	 */
-	chanctrl = ioatdma_chan_read16(ioat_chan, IOAT_CHANCTRL_OFFSET);
+	chanctrl = readw(ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 	if (chanctrl & IOAT_CHANCTRL_CHANNEL_IN_USE)
 		return -EBUSY;
 
@@ -132,12 +131,12 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 		IOAT_CHANCTRL_ERR_INT_EN |
 		IOAT_CHANCTRL_ANY_ERR_ABORT_EN |
 		IOAT_CHANCTRL_ERR_COMPLETION_EN;
-        ioatdma_chan_write16(ioat_chan, IOAT_CHANCTRL_OFFSET, chanctrl);
+        writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 
-	chanerr = ioatdma_chan_read32(ioat_chan, IOAT_CHANERR_OFFSET);
+	chanerr = readl(ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	if (chanerr) {
 		printk("IOAT: CHANERR = %x, clearing\n", chanerr);
-		ioatdma_chan_write32(ioat_chan, IOAT_CHANERR_OFFSET, chanerr);
+		writel(chanerr, ioat_chan->reg_base + IOAT_CHANERR_OFFSET);
 	}
 
 	/* Allocate descriptors */
@@ -161,10 +160,10 @@ static int ioat_dma_alloc_chan_resources(struct dma_chan *chan)
 		               &ioat_chan->completion_addr);
 	memset(ioat_chan->completion_virt, 0,
 	       sizeof(*ioat_chan->completion_virt));
-	ioatdma_chan_write32(ioat_chan, IOAT_CHANCMP_OFFSET_LOW,
-	               ((u64) ioat_chan->completion_addr) & 0x00000000FFFFFFFF);
-	ioatdma_chan_write32(ioat_chan, IOAT_CHANCMP_OFFSET_HIGH,
-	               ((u64) ioat_chan->completion_addr) >> 32);
+	writel(((u64) ioat_chan->completion_addr) & 0x00000000FFFFFFFF,
+	       ioat_chan->reg_base + IOAT_CHANCMP_OFFSET_LOW);
+	writel(((u64) ioat_chan->completion_addr) >> 32,
+	       ioat_chan->reg_base + IOAT_CHANCMP_OFFSET_HIGH);
 
 	ioat_start_null_desc(ioat_chan);
 	return i;
@@ -182,7 +181,7 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 
 	ioat_dma_memcpy_cleanup(ioat_chan);
 
-	ioatdma_chan_write8(ioat_chan, IOAT_CHANCMD_OFFSET, IOAT_CHANCMD_RESET);
+	writeb(IOAT_CHANCMD_RESET, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 
 	spin_lock_bh(&ioat_chan->desc_lock);
 	list_for_each_entry_safe(desc, _desc, &ioat_chan->used_desc, node) {
@@ -210,9 +209,9 @@ static void ioat_dma_free_chan_resources(struct dma_chan *chan)
 	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
 
 	/* Tell hw the chan is free */
-	chanctrl = ioatdma_chan_read16(ioat_chan, IOAT_CHANCTRL_OFFSET);
+	chanctrl = readw(ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 	chanctrl &= ~IOAT_CHANCTRL_CHANNEL_IN_USE;
-	ioatdma_chan_write16(ioat_chan, IOAT_CHANCTRL_OFFSET, chanctrl);
+	writew(chanctrl, ioat_chan->reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
 /**
@@ -318,9 +317,8 @@ static dma_cookie_t do_ioat_dma_memcpy(struct ioat_dma_chan *ioat_chan,
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
 	if (append)
-		ioatdma_chan_write8(ioat_chan,
-		                    IOAT_CHANCMD_OFFSET,
-		                    IOAT_CHANCMD_APPEND);
+		writeb(IOAT_CHANCMD_APPEND,
+		       ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 	return cookie;
 }
 
@@ -417,9 +415,8 @@ static void ioat_dma_memcpy_issue_pending(struct dma_chan *chan)
 
 	if (ioat_chan->pending != 0) {
 		ioat_chan->pending = 0;
-		ioatdma_chan_write8(ioat_chan,
-		                    IOAT_CHANCMD_OFFSET,
-		                    IOAT_CHANCMD_APPEND);
+		writeb(IOAT_CHANCMD_APPEND,
+		       ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 	}
 }
 
@@ -449,7 +446,7 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *chan)
 	if ((chan->completion_virt->full & IOAT_CHANSTS_DMA_TRANSFER_STATUS) ==
 		IOAT_CHANSTS_DMA_TRANSFER_STATUS_HALTED) {
 		printk("IOAT: Channel halted, chanerr = %x\n",
-			ioatdma_chan_read32(chan, IOAT_CHANERR_OFFSET));
+			readl(chan->reg_base + IOAT_CHANERR_OFFSET));
 
 		/* TODO do something to salvage the situation */
 	}
@@ -569,21 +566,21 @@ static irqreturn_t ioat_do_interrupt(int irq, void *data)
 	unsigned long attnstatus;
 	u8 intrctrl;
 
-	intrctrl = ioatdma_read8(instance, IOAT_INTRCTRL_OFFSET);
+	intrctrl = readb(instance->reg_base + IOAT_INTRCTRL_OFFSET);
 
 	if (!(intrctrl & IOAT_INTRCTRL_MASTER_INT_EN))
 		return IRQ_NONE;
 
 	if (!(intrctrl & IOAT_INTRCTRL_INT_STATUS)) {
-		ioatdma_write8(instance, IOAT_INTRCTRL_OFFSET, intrctrl);
+		writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
 		return IRQ_NONE;
 	}
 
-	attnstatus = ioatdma_read32(instance, IOAT_ATTNSTATUS_OFFSET);
+	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
 
 	printk(KERN_ERR "ioatdma error: interrupt! status %lx\n", attnstatus);
 
-	ioatdma_write8(instance, IOAT_INTRCTRL_OFFSET, intrctrl);
+	writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
 	return IRQ_HANDLED;
 }
 
@@ -612,14 +609,13 @@ static void ioat_start_null_desc(struct ioat_dma_chan *ioat_chan)
 	spin_unlock_bh(&ioat_chan->desc_lock);
 
 #if (BITS_PER_LONG == 64)
-	ioatdma_chan_write64(ioat_chan, IOAT_CHAINADDR_OFFSET, desc->phys);
+	writeq(desc->phys, ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET);
 #else
-	ioatdma_chan_write32(ioat_chan,
-	                     IOAT_CHAINADDR_OFFSET_LOW,
-	                     (u32) desc->phys);
-	ioatdma_chan_write32(ioat_chan, IOAT_CHAINADDR_OFFSET_HIGH, 0);
+	writel((u32) desc->phys,
+	       ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_LOW);
+	writel(0, ioat_chan->reg_base + IOAT_CHAINADDR_OFFSET_HIGH);
 #endif
-	ioatdma_chan_write8(ioat_chan, IOAT_CHANCMD_OFFSET, IOAT_CHANCMD_START);
+	writeb(IOAT_CHANCMD_START, ioat_chan->reg_base + IOAT_CHANCMD_OFFSET);
 }
 
 /*
@@ -748,7 +744,7 @@ static int __devinit ioat_probe(struct pci_dev *pdev,
 
 	device->reg_base = reg_base;
 
-	ioatdma_write8(device, IOAT_INTRCTRL_OFFSET, IOAT_INTRCTRL_MASTER_INT_EN);
+	writeb(IOAT_INTRCTRL_MASTER_INT_EN, device->reg_base + IOAT_INTRCTRL_OFFSET);
 	pci_set_master(pdev);
 
 	INIT_LIST_HEAD(&device->common.channels);
diff --git a/drivers/dma/ioatdma_io.h b/drivers/dma/ioatdma_io.h
deleted file mode 100644
index c0b4bf6..0000000
--- a/drivers/dma/ioatdma_io.h
+++ /dev/null
@@ -1,118 +0,0 @@
-/*
- * Copyright(c) 2004 - 2006 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- * The full GNU General Public License is included in this distribution in the
- * file called COPYING.
- */
-#ifndef IOATDMA_IO_H
-#define IOATDMA_IO_H
-
-#include <asm/io.h>
-
-/*
- * device and per-channel MMIO register read and write functions
- * this is a lot of anoying inline functions, but it's typesafe
- */
-
-static inline u8 ioatdma_read8(struct ioat_device *device,
-                               unsigned int offset)
-{
-	return readb(device->reg_base + offset);
-}
-
-static inline u16 ioatdma_read16(struct ioat_device *device,
-                                 unsigned int offset)
-{
-	return readw(device->reg_base + offset);
-}
-
-static inline u32 ioatdma_read32(struct ioat_device *device,
-                                 unsigned int offset)
-{
-	return readl(device->reg_base + offset);
-}
-
-static inline void ioatdma_write8(struct ioat_device *device,
-                                  unsigned int offset, u8 value)
-{
-	writeb(value, device->reg_base + offset);
-}
-
-static inline void ioatdma_write16(struct ioat_device *device,
-                                   unsigned int offset, u16 value)
-{
-	writew(value, device->reg_base + offset);
-}
-
-static inline void ioatdma_write32(struct ioat_device *device,
-                                   unsigned int offset, u32 value)
-{
-	writel(value, device->reg_base + offset);
-}
-
-static inline u8 ioatdma_chan_read8(struct ioat_dma_chan *chan,
-                                    unsigned int offset)
-{
-	return readb(chan->reg_base + offset);
-}
-
-static inline u16 ioatdma_chan_read16(struct ioat_dma_chan *chan,
-                                      unsigned int offset)
-{
-	return readw(chan->reg_base + offset);
-}
-
-static inline u32 ioatdma_chan_read32(struct ioat_dma_chan *chan,
-                                      unsigned int offset)
-{
-	return readl(chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write8(struct ioat_dma_chan *chan,
-                                       unsigned int offset, u8 value)
-{
-	writeb(value, chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write16(struct ioat_dma_chan *chan,
-                                        unsigned int offset, u16 value)
-{
-	writew(value, chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write32(struct ioat_dma_chan *chan,
-                                        unsigned int offset, u32 value)
-{
-	writel(value, chan->reg_base + offset);
-}
-
-#if (BITS_PER_LONG == 64)
-static inline u64 ioatdma_chan_read64(struct ioat_dma_chan *chan,
-                                      unsigned int offset)
-{
-	return readq(chan->reg_base + offset);
-}
-
-static inline void ioatdma_chan_write64(struct ioat_dma_chan *chan,
-                                        unsigned int offset, u64 value)
-{
-	writeq(value, chan->reg_base + offset);
-}
-#endif
-
-#endif /* IOATDMA_IO_H */
-

commit 4baad80867cd378a6211388eb588bc12b504fb5c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed May 2 15:25:11 2007 -0700

    drivers/dma: handle sysfs errors
    
    From: Jeff Garzik <jeff@garzik.org>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 322ee29..828310d 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -316,7 +316,7 @@ EXPORT_SYMBOL(dma_async_client_chan_request);
 int dma_async_device_register(struct dma_device *device)
 {
 	static int id;
-	int chancnt = 0;
+	int chancnt = 0, rc;
 	struct dma_chan* chan;
 
 	if (!device)
@@ -338,8 +338,15 @@ int dma_async_device_register(struct dma_device *device)
 		snprintf(chan->class_dev.class_id, BUS_ID_SIZE, "dma%dchan%d",
 		         device->dev_id, chan->chan_id);
 
+		rc = class_device_register(&chan->class_dev);
+		if (rc) {
+			chancnt--;
+			free_percpu(chan->local);
+			chan->local = NULL;
+			goto err_out;
+		}
+
 		kref_get(&device->refcount);
-		class_device_register(&chan->class_dev);
 	}
 
 	mutex_lock(&dma_list_mutex);
@@ -349,6 +356,17 @@ int dma_async_device_register(struct dma_device *device)
 	dma_chans_rebalance();
 
 	return 0;
+
+err_out:
+	list_for_each_entry(chan, &device->channels, device_node) {
+		if (chan->local == NULL)
+			continue;
+		kref_put(&device->refcount, dma_async_device_cleanup);
+		class_device_unregister(&chan->class_dev);
+		chancnt--;
+		free_percpu(chan->local);
+	}
+	return rc;
 }
 EXPORT_SYMBOL(dma_async_device_register);
 

commit 7e690b9c312f5eb3b058584db59d1621068bcf7c
Author: Chris Leech <christopher.leech@intel.com>
Date:   Wed May 2 15:24:45 2007 -0700

    ioatdma: Push pending transactions to hardware more frequently
    Every 20 descriptors turns out to be to few append commands with
    newer/faster CPUs.  Pushing every 4 still cuts down on MMIO writes to an
    acceptable level without letting the DMA engine run out of work.
    
    Signed-off-by: Chris Leech <christopher.leech@intel.com>

diff --git a/drivers/dma/ioatdma.c b/drivers/dma/ioatdma.c
index 8e87261..0f77a9d 100644
--- a/drivers/dma/ioatdma.c
+++ b/drivers/dma/ioatdma.c
@@ -310,7 +310,7 @@ static dma_cookie_t do_ioat_dma_memcpy(struct ioat_dma_chan *ioat_chan,
 	list_splice_init(&new_chain, ioat_chan->used_desc.prev);
 
 	ioat_chan->pending += desc_count;
-	if (ioat_chan->pending >= 20) {
+	if (ioat_chan->pending >= 4) {
 		append = 1;
 		ioat_chan->pending = 0;
 	}
@@ -818,7 +818,7 @@ static void __devexit ioat_remove(struct pci_dev *pdev)
 }
 
 /* MODULE API */
-MODULE_VERSION("1.7");
+MODULE_VERSION("1.9");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Intel Corporation");
 
