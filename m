Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbYGaAQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbYGaAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYGaAP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:15:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:38910 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760060AbYGaAPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:15:24 -0400
Date: Wed, 30 Jul 2008 16:58:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 31/62] sparc64: Fix lockdep issues in LDC protocol layer.
Message-ID: <20080730235857.GE12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-lockdep-issues-in-ldc-protocol-layer.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit b7c2a75725dee9b5643a0aae3a4cb47f52e00a49 ]

We're calling request_irq() with a IRQs disabled.

No straightforward fix exists because we want to
enable these IRQs and setup state atomically before
getting into the IRQ handler the first time.

What happens now is that we mark the VIRQ to not be
automatically enabled by request_irq().  Then we
make explicit enable_irq() calls when we grab the
LDC channel.

This way we don't need to call request_irq() illegally
under the LDC channel lock any more.

Bump LDC version and release date.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/irq.c |   10 +++++++++-
 arch/sparc64/kernel/ldc.c |   38 +++++++++++++++++++-------------------
 2 files changed, 28 insertions(+), 20 deletions(-)

--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -621,8 +621,9 @@ unsigned int sun4v_build_irq(u32 devhand
 unsigned int sun4v_build_virq(u32 devhandle, unsigned int devino)
 {
 	struct irq_handler_data *data;
-	struct ino_bucket *bucket;
 	unsigned long hv_err, cookie;
+	struct ino_bucket *bucket;
+	struct irq_desc *desc;
 	unsigned int virt_irq;
 
 	bucket = kzalloc(sizeof(struct ino_bucket), GFP_ATOMIC);
@@ -643,6 +644,13 @@ unsigned int sun4v_build_virq(u32 devhan
 	if (unlikely(!data))
 		return 0;
 
+	/* In order to make the LDC channel startup sequence easier,
+	 * especially wrt. locking, we do not let request_irq() enable
+	 * the interrupt.
+	 */
+	desc = irq_desc + virt_irq;
+	desc->status |= IRQ_NOAUTOEN;
+
 	set_irq_chip_data(virt_irq, data);
 
 	/* Catch accidental accesses to these things.  IMAP/ICLR handling
--- a/arch/sparc64/kernel/ldc.c
+++ b/arch/sparc64/kernel/ldc.c
@@ -1,6 +1,6 @@
 /* ldc.c: Logical Domain Channel link-layer protocol driver.
  *
- * Copyright (C) 2007 David S. Miller <davem@davemloft.net>
+ * Copyright (C) 2007, 2008 David S. Miller <davem@davemloft.net>
  */
 
 #include <linux/kernel.h>
@@ -23,8 +23,8 @@
 
 #define DRV_MODULE_NAME		"ldc"
 #define PFX DRV_MODULE_NAME	": "
-#define DRV_MODULE_VERSION	"1.0"
-#define DRV_MODULE_RELDATE	"June 25, 2007"
+#define DRV_MODULE_VERSION	"1.1"
+#define DRV_MODULE_RELDATE	"July 22, 2008"
 
 static char version[] __devinitdata =
 	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
@@ -1235,13 +1235,9 @@ int ldc_bind(struct ldc_channel *lp, con
 	unsigned long hv_err, flags;
 	int err = -EINVAL;
 
-	spin_lock_irqsave(&lp->lock, flags);
-
-	if (!name)
-		goto out_err;
-
-	if (lp->state != LDC_STATE_INIT)
-		goto out_err;
+	if (!name ||
+	    (lp->state != LDC_STATE_INIT))
+		return -EINVAL;
 
 	snprintf(lp->rx_irq_name, LDC_IRQ_NAME_MAX, "%s RX", name);
 	snprintf(lp->tx_irq_name, LDC_IRQ_NAME_MAX, "%s TX", name);
@@ -1250,25 +1246,32 @@ int ldc_bind(struct ldc_channel *lp, con
 			  IRQF_SAMPLE_RANDOM | IRQF_SHARED,
 			  lp->rx_irq_name, lp);
 	if (err)
-		goto out_err;
+		return err;
 
 	err = request_irq(lp->cfg.tx_irq, ldc_tx,
 			  IRQF_SAMPLE_RANDOM | IRQF_SHARED,
 			  lp->tx_irq_name, lp);
-	if (err)
-		goto out_free_rx_irq;
+	if (err) {
+		free_irq(lp->cfg.rx_irq, lp);
+		return err;
+	}
+
 
+	spin_lock_irqsave(&lp->lock, flags);
+
+	enable_irq(lp->cfg.rx_irq);
+	enable_irq(lp->cfg.tx_irq);
 
 	lp->flags |= LDC_FLAG_REGISTERED_IRQS;
 
 	err = -ENODEV;
 	hv_err = sun4v_ldc_tx_qconf(lp->id, 0, 0);
 	if (hv_err)
-		goto out_free_tx_irq;
+		goto out_free_irqs;
 
 	hv_err = sun4v_ldc_tx_qconf(lp->id, lp->tx_ra, lp->tx_num_entries);
 	if (hv_err)
-		goto out_free_tx_irq;
+		goto out_free_irqs;
 
 	hv_err = sun4v_ldc_rx_qconf(lp->id, 0, 0);
 	if (hv_err)
@@ -1304,14 +1307,11 @@ out_unmap_rx:
 out_unmap_tx:
 	sun4v_ldc_tx_qconf(lp->id, 0, 0);
 
-out_free_tx_irq:
+out_free_irqs:
 	lp->flags &= ~LDC_FLAG_REGISTERED_IRQS;
 	free_irq(lp->cfg.tx_irq, lp);
-
-out_free_rx_irq:
 	free_irq(lp->cfg.rx_irq, lp);
 
-out_err:
 	spin_unlock_irqrestore(&lp->lock, flags);
 
 	return err;

-- 
