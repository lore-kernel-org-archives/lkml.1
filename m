Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432Ab0AUEYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab0AUEYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256Ab0AUEXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:23:09 -0500
Received: from kroah.org ([198.145.64.141]:60189 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab0AUEXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041835.733941166@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [25/30] sparc64: Fix Niagara2 perf event handling.
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit e04ed38d4e0cd32141f723560efcc8252b0241e2 ]

For chips like Niagara2 that have true overflow indications
in the %pcr (which we don't actually need and don't use)
the interrupt signal persists until the overflow bits are
cleared by an explicit %pcr write.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/perf_event.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -986,6 +986,17 @@ static int __kprobes perf_event_nmi_hand
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
+
+	/* If the PMU has the TOE IRQ enable bits, we need to do a
+	 * dummy write to the %pcr to clear the overflow bits and thus
+	 * the interrupt.
+	 *
+	 * Do this before we peek at the counters to determine
+	 * overflow so we don't lose any events.
+	 */
+	if (sparc_pmu->irq_bit)
+		pcr_ops->write(cpuc->pcr);
+
 	for (idx = 0; idx < MAX_HWEVENTS; idx++) {
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;


