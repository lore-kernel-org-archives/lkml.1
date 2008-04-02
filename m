Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbYDBSly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbYDBSly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYDBSfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:51 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38418 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757408AbYDBSfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 24] Re: [PATCH 08/12] xen: add resend_irq_on_evtchn()
	definition into events.c
X-Mercurial-Node: ebc72e5a71941280fe996a619e51f9f06fcd3e7c
Message-Id: <ebc72e5a71941280fe99.1207158837@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

Define resend_irq_on_evtchn() which ia64/xen uses.
Although it isn't used by current x86/xen code, it's arch generic
so that put it into common code.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   16 ++++++++++++++++
 include/xen/events.h |    3 +--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -586,6 +586,22 @@
 	rebind_irq_to_cpu(irq, tcpu);
 }
 
+int resend_irq_on_evtchn(unsigned int irq)
+{
+	int masked, evtchn = evtchn_from_irq(irq);
+	struct shared_info *s = HYPERVISOR_shared_info;
+
+	if (!VALID_EVTCHN(evtchn))
+		return 1;
+
+	masked = sync_test_and_set_bit(evtchn, s->evtchn_mask);
+	sync_set_bit(evtchn, s->evtchn_pending);
+	if (!masked)
+		unmask_evtchn(evtchn);
+
+	return 1;
+}
+
 static void enable_dynirq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
diff --git a/include/xen/events.h b/include/xen/events.h
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -31,6 +31,7 @@
 void unbind_from_irqhandler(unsigned int irq, void *dev_id);
 
 void xen_send_IPI_one(unsigned int cpu, enum ipi_vector vector);
+int resend_irq_on_evtchn(unsigned int irq);
 
 static inline void notify_remote_via_evtchn(int port)
 {


