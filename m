Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbYFNAYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbYFNAYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbYFNAPC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:02 -0400
Received: from mail.suse.de ([195.135.220.2]:34544 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762213AbYFNAPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:00 -0400
Date: Fri, 13 Jun 2008 17:11:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ayaz Abdulla <aabdulla@nvidia.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 37/47] forcedeth: msi interrupts
Message-ID: <20080614001159.GK24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="forcedeth-msi-interrupts.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ayaz Abdulla <aabdulla@nvidia.com>

commit 4db0ee176e256444695ee2d7b004552e82fec987 upstream

Add a workaround for lost MSI interrupts.  There is a race condition in
the HW in which future interrupts could be missed.  The workaround is to
toggle the MSI irq mask.

Added cleanup based on comments from Andrew Morton.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -3111,6 +3111,20 @@ static void nv_link_irq(struct net_devic
 	dprintk(KERN_DEBUG "%s: link change notification done.\n", dev->name);
 }
 
+static void nv_msi_workaround(struct fe_priv *np)
+{
+
+	/* Need to toggle the msi irq mask within the ethernet device,
+	 * otherwise, future interrupts will not be detected.
+	 */
+	if (np->msi_flags & NV_MSI_ENABLED) {
+		u8 __iomem *base = np->base;
+
+		writel(0, base + NvRegMSIIrqMask);
+		writel(NVREG_MSI_VECTOR_0_ENABLED, base + NvRegMSIIrqMask);
+	}
+}
+
 static irqreturn_t nv_nic_irq(int foo, void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
@@ -3133,6 +3147,8 @@ static irqreturn_t nv_nic_irq(int foo, v
 		if (!(events & np->irqmask))
 			break;
 
+		nv_msi_workaround(np);
+
 		spin_lock(&np->lock);
 		nv_tx_done(dev);
 		spin_unlock(&np->lock);
@@ -3248,6 +3264,8 @@ static irqreturn_t nv_nic_irq_optimized(
 		if (!(events & np->irqmask))
 			break;
 
+		nv_msi_workaround(np);
+
 		spin_lock(&np->lock);
 		nv_tx_done_optimized(dev, TX_WORK_PER_LOOP);
 		spin_unlock(&np->lock);
@@ -3588,6 +3606,8 @@ static irqreturn_t nv_nic_irq_test(int f
 	if (!(events & NVREG_IRQ_TIMER))
 		return IRQ_RETVAL(0);
 
+	nv_msi_workaround(np);
+
 	spin_lock(&np->lock);
 	np->intr_test = 1;
 	spin_unlock(&np->lock);

-- 
