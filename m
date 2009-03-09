Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbZCID0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbZCID0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 23:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZCID0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 23:26:08 -0400
Received: from ozlabs.org ([203.10.76.45]:47082 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZCID0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 23:26:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] lguest fixes
Date: Mon, 9 Mar 2009 13:55:58 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903091355.59089.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7a203f3b089be4410fe065dd9927027eade94557:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../drzeus/mmc

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (2):
      lguest: fix crash 'unhandled trap 13 at <native_read_msr_safe>'
      lguest: fix for CONFIG_SPARSE_IRQ=y

 arch/x86/lguest/boot.c         |   21 ++++++++++++++-------
 drivers/lguest/lguest_device.c |    6 ++++++
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 92f1c6f..960a8d9 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -343,6 +343,11 @@ static void lguest_cpuid(unsigned int *ax, unsigned int *bx,
 		 * flush_tlb_user() for both user and kernel mappings unless
 		 * the Page Global Enable (PGE) feature bit is set. */
 		*dx |= 0x00002000;
+		/* We also lie, and say we're family id 5.  6 or greater
+		 * leads to a rdmsr in early_init_intel which we can't handle.
+		 * Family ID is returned as bits 8-12 in ax. */
+		*ax &= 0xFFFFF0FF;
+		*ax |= 0x00000500;
 		break;
 	case 0x80000000:
 		/* Futureproof this a little: if they ask how much extended
@@ -589,19 +594,21 @@ static void __init lguest_init_IRQ(void)
 		/* Some systems map "vectors" to interrupts weirdly.  Lguest has
 		 * a straightforward 1 to 1 mapping, so force that here. */
 		__get_cpu_var(vector_irq)[vector] = i;
-		if (vector != SYSCALL_VECTOR) {
-			set_intr_gate(vector,
-				      interrupt[vector-FIRST_EXTERNAL_VECTOR]);
-			set_irq_chip_and_handler_name(i, &lguest_irq_controller,
-						      handle_level_irq,
-						      "level");
-		}
+		if (vector != SYSCALL_VECTOR)
+			set_intr_gate(vector, interrupt[i]);
 	}
 	/* This call is required to set up for 4k stacks, where we have
 	 * separate stacks for hard and soft interrupts. */
 	irq_ctx_init(smp_processor_id());
 }
 
+void lguest_setup_irq(unsigned int irq)
+{
+	irq_to_desc_alloc_cpu(irq, 0);
+	set_irq_chip_and_handler_name(irq, &lguest_irq_controller,
+				      handle_level_irq, "level");
+}
+
 /*
  * Time.
  *
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index b4d44e5..8132533 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -212,6 +212,9 @@ static void lg_notify(struct virtqueue *vq)
 	hcall(LHCALL_NOTIFY, lvq->config.pfn << PAGE_SHIFT, 0, 0);
 }
 
+/* An extern declaration inside a C file is bad form.  Don't do it. */
+extern void lguest_setup_irq(unsigned int irq);
+
 /* This routine finds the first virtqueue described in the configuration of
  * this device and sets it up.
  *
@@ -266,6 +269,9 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 		goto unmap;
 	}
 
+	/* Make sure the interrupt is allocated. */
+	lguest_setup_irq(lvq->config.irq);
+
 	/* Tell the interrupt for this virtqueue to go to the virtio_ring
 	 * interrupt handler. */
 	/* FIXME: We used to have a flag for the Host to tell us we could use
