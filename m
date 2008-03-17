Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYCRFZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYCRFZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYCRFYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:12 -0400
Received: from gw.goop.org ([64.81.55.164]:37844 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYCRFYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 28 of 31] xen: make sure retriggered events are set pending
X-Mercurial-Node: d955a2f70089907f4ba406b4d6a3ccf88859a89e
Message-Id: <d955a2f70089907f4ba4.1205797039@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

retrigger_dynirq() was incomplete, and didn't properly set the event
to be pending again.  It doesn't seem to actually get used.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/events.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/events.c b/arch/x86/xen/events.c
--- a/arch/x86/xen/events.c
+++ b/arch/x86/xen/events.c
@@ -601,10 +601,16 @@
 static int retrigger_dynirq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
+	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
 	if (VALID_EVTCHN(evtchn)) {
-		set_evtchn(evtchn);
+		int masked;
+
+		masked = sync_test_and_set_bit(evtchn, sh->evtchn_mask);
+		sync_set_bit(evtchn, sh->evtchn_pending);
+		if (!masked)
+			unmask_evtchn(evtchn);
 		ret = 1;
 	}
 


