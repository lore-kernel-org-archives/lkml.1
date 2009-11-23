Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbZKWKl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbZKWKl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZKWKlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:41:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbZKWKk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:40:57 -0500
Message-Id: <20091123103819.917652413@chello.nl>
References: <20091123103722.140831906@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Nov 2009 11:37:28 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/8] perf: optimize __perf_sw_event()
Content-Disposition: inline; filename=perf-foo-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Ingo noticed that the C99 initialisation of the structure resulted in
a memset() and an assignment. Use explicit assignments to avoid the
memset.

perf_prepare_sample() initializes all data entries, except:
  addr, period and raw.

period is set in perf_swevent_overflow, addr is set here, leaving only
raw to be dealt with, so clear that explicitly as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3945,9 +3945,10 @@ out:
 void __perf_sw_event(u32 event_id, u64 nr, int nmi,
 			    struct pt_regs *regs, u64 addr)
 {
-	struct perf_sample_data data = {
-		.addr = addr,
-	};
+	struct perf_sample_data data;
+
+	data.addr = addr;
+	data.raw  = NULL;
 
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, nmi,
 				&data, regs);

-- 

