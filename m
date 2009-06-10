Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbZFJDlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbZFJDlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZFJDfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:35:23 -0400
Received: from kroah.org ([198.145.64.141]:57054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbZFJDfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:22 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:47 2009
Message-Id: <20090610002346.847147311@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:59 -0700
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
       alan@lxorguk.ukuu.org.uk, Warren Free <wfree@ipmn.com>,
       Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 31/60] USB: isp1760: urb_dequeue doesnt always find the urbs
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=usb-isp1760-urb_dequeue-doesn-t-always-find-the-urbs.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Warren Free <wfree@ipmn.com>

commit 0afb20e00b5053170c85298fed842b32d20b4ea9 upstream.

The option driver (and presumably others) allocates several URBs when it
opens and tries to free them when it closes. The isp1760_urb_dequeue
function gets called, but the packet being dequeued is not necessarily at
the
front of one of the 32 queues. If not, the isp1760_urb_done function doesn't
get called for the URB and the process trying to free it hangs forever on a
wait_queue. This patch does two things. If the URB being dequeued has others
queued behind it, it re-queues them. And it searches the queues looking for
the URB being dequeued rather than just looking at the one at the front of
the queue.

[bigeasy@linutronix] whitespace fixes, reformating

Signed-off-by: Warren Free <wfree@ipmn.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/isp1760-hcd.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -1645,6 +1645,7 @@ static int isp1760_urb_dequeue(struct us
 	u32 reg_base, or_reg, skip_reg;
 	unsigned long flags;
 	struct ptd ptd;
+	packet_enqueue *pe;
 
 	switch (usb_pipetype(urb->pipe)) {
 	case PIPE_ISOCHRONOUS:
@@ -1656,6 +1657,7 @@ static int isp1760_urb_dequeue(struct us
 		reg_base = INT_REGS_OFFSET;
 		or_reg = HC_INT_IRQ_MASK_OR_REG;
 		skip_reg = HC_INT_PTD_SKIPMAP_REG;
+		pe = enqueue_an_INT_packet;
 		break;
 
 	default:
@@ -1663,6 +1665,7 @@ static int isp1760_urb_dequeue(struct us
 		reg_base = ATL_REGS_OFFSET;
 		or_reg = HC_ATL_IRQ_MASK_OR_REG;
 		skip_reg = HC_ATL_PTD_SKIPMAP_REG;
+		pe =  enqueue_an_ATL_packet;
 		break;
 	}
 
@@ -1674,6 +1677,7 @@ static int isp1760_urb_dequeue(struct us
 			u32 skip_map;
 			u32 or_map;
 			struct isp1760_qtd *qtd;
+			struct isp1760_qh *qh = ints->qh;
 
 			skip_map = isp1760_readl(hcd->regs + skip_reg);
 			skip_map |= 1 << i;
@@ -1686,8 +1690,7 @@ static int isp1760_urb_dequeue(struct us
 			priv_write_copy(priv, (u32 *)&ptd, hcd->regs + reg_base
 					+ i * sizeof(ptd), sizeof(ptd));
 			qtd = ints->qtd;
-
-			clean_up_qtdlist(qtd);
+			qtd = clean_up_qtdlist(qtd);
 
 			free_mem(priv, ints->payload);
 
@@ -1698,7 +1701,24 @@ static int isp1760_urb_dequeue(struct us
 			ints->payload = 0;
 
 			isp1760_urb_done(priv, urb, status);
+			if (qtd)
+				pe(hcd, qh, qtd);
 			break;
+
+		} else if (ints->qtd) {
+			struct isp1760_qtd *qtd, *prev_qtd = ints->qtd;
+
+			for (qtd = ints->qtd->hw_next; qtd; qtd = qtd->hw_next) {
+				if (qtd->urb == urb) {
+					prev_qtd->hw_next = clean_up_qtdlist(qtd);
+					isp1760_urb_done(priv, urb, status);
+					break;
+				}
+				prev_qtd = qtd;
+			}
+			/* we found the urb before the end of the list */
+			if (qtd)
+				break;
 		}
 		ints++;
 	}


