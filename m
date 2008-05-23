Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYEWNrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYEWNrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYEWNoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:24 -0400
Received: from gw.goop.org ([64.81.55.164]:53250 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYEWNoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 12] xen: fix unbind_from_irq()
X-Mercurial-Node: 7c75b9637a2a44e4295b8094f49c5ee6e120069c
Message-Id: <7c75b9637a2a44e4295b.1211550074@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:14 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange the tests in unbind_from_irq() so that we can still unbind
an irq even if the underlying event channel is bad.  This allows a
device driver to shuffle its irqs on save/restore before the
underlying event channels have been fixed up.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -355,7 +355,7 @@
 
 	spin_lock(&irq_mapping_update_lock);
 
-	if (VALID_EVTCHN(evtchn) && (--irq_bindcount[irq] == 0)) {
+	if ((--irq_bindcount[irq] == 0) && VALID_EVTCHN(evtchn)) {
 		close.port = evtchn;
 		if (HYPERVISOR_event_channel_op(EVTCHNOP_close, &close) != 0)
 			BUG();
@@ -375,7 +375,7 @@
 		evtchn_to_irq[evtchn] = -1;
 		irq_info[irq] = IRQ_UNBOUND;
 
-		dynamic_irq_init(irq);
+		dynamic_irq_cleanup(irq);
 	}
 
 	spin_unlock(&irq_mapping_update_lock);


