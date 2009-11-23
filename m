Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZKWKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZKWKkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZKWKky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:40:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:53244 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930AbZKWKky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:40:54 -0500
Message-Id: <20091123103820.070649058@chello.nl>
References: <20091123103722.140831906@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 23 Nov 2009 11:37:30 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 8/8][RFC] perf: be paranoid about child times?
Content-Disposition: inline; filename=perf-foo-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally we flatten the inherited hierarchy by attaching all childs to
the top parent, therefore a child's child_total_time_* should never
get incremented, add it anyway?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1780,8 +1780,10 @@ u64 perf_event_read_value(struct perf_ev
 
 	list_for_each_entry(child, &event->child_list, child_list) {
 		total += perf_event_read(child);
-		*enabled += child->total_time_enabled;
-		*running += child->total_time_running;
+		*enabled += child->total_time_enabled +
+			atomic64_read(&child->child_total_time_enabled);
+		*running += child->total_time_running +
+			atomic64_read(&child->child_total_time_running);
 	}
 	mutex_unlock(&event->child_mutex);
 

-- 

