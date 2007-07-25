Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbXGYJTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbXGYJTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbXGYJTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:19:03 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:49233 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbXGYJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:19:01 -0400
Subject: [PATCH RFC] e1000: clear ICR before requesting an IRQ line
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: e1000-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, auke-jan.h.kok@intel.com
In-Reply-To: <1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070718154659.c8b5ffea.akpm@linux-foundation.org>
	 <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>
	 <1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 25 Jul 2007 18:18:57 +0900
Message-Id: <1185355137.15252.82.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I made an interesting finding while testing the two patches below.

http://lkml.org/lkml/2007/7/19/685
http://lkml.org/lkml/2007/7/19/687

These patches modify the traditional CONFIG_DEBUG_KERNEL in such a way
that the request_irq prints a warning if after calling the handler it
returned IRQ_HANDLED .

The code looks like this:

int request_irq(unsigned int irq, irq_handler_t handler,
                unsigned long irqflags, const char *devname, void *dev_id)
.....
        if (irqflags & IRQF_DISABLED) {
                unsigned long flags;

                local_irq_save(flags);
                retval = handler(irq, dev_id);
                local_irq_restore(flags);
        } else
                retval = handler(irq, dev_id);
        if (retval == IRQ_HANDLED) {
                printk(KERN_WARNING
                       "%s (IRQ %d) handled a spurious interrupt\n",
                       devname, irq);
        }
.....

I discovered that the e1000 driver handles the "fake" interrupt, which,
in principle, is not correct because it obviously isn't a real interrupt
and it could have been an interrupt coming from another device that is
sharing the IRQ line.

The problem is that the interrupt handler assumes that if ICR!=0 it was
its device who generated the interrupt and, consequently, it should be
handled. But, unfortunately, that is not always the case. If the network
link is active when we open the device (e1000_open) the ICR will have
the E1000_ICR_LSC bit set (by the way, is this the expected behavior?).
This means that _any_ interrupt coming in after allocating our interrupt
(e1000_request_irq) will be handled, no matter where it came from.

The solution I came up with is clearing the ICR before calling
request_irq. I have to admit that I am not familiar enough with this
driver, so it is quite likely that this is not the right fix. I would
appreciate your comments on this.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.22-orig/drivers/net/e1000/e1000_main.c linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c
--- linux-2.6.22-orig/drivers/net/e1000/e1000_main.c	2007-07-19 18:18:53.000000000 +0900
+++ linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c	2007-07-25 17:22:54.000000000 +0900
@@ -1378,6 +1378,17 @@ e1000_alloc_queues(struct e1000_adapter 
 }
 
 /**
+ * e1000_clear_interrupts
+ * @adapter: address of board private structure
+ *
+ * Mask interrupts
+ **/
+static void
+e1000_clear_interrupts(struct e1000_adapter *adapter) {
+	E1000_READ_REG(&adapter->hw, ICR);
+}
+
+/**
  * e1000_open - Called when a network interface is made active
  * @netdev: network interface device structure
  *
@@ -1431,6 +1442,9 @@ e1000_open(struct net_device *netdev)
 	 * so we have to setup our clean_rx handler before we do so.  */
 	e1000_configure(adapter);
 
+	/* Discard any possible pending interrupts. */
+	e1000_clear_interrupts(adapter);
+
 	err = e1000_request_irq(adapter);
 	if (err)
 		goto err_req_irq;


