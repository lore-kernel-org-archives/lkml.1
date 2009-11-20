Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZKTVay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZKTVay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZKTV2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:48329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbZKTV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:27 -0500
Message-Id: <20091120212509.344964101@chello.nl>
References: <20091120211942.676891948@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 20 Nov 2009 22:19:57 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH 15/15] perf_events: fix default watermark calculation
Content-Disposition: inline; filename=stephane_perf_events-fix_default_watermark_calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Stephane Eranian <eranian@gmail.com>

This patch fixes the default watermark value for the sampling buffer.
With the existing calculation (watermark = max(PAGE_SIZE, max_size /
2)), no notification was ever received when the buffer was exactly 1
page. This was because you would never cross the threshold (there is
no partial samples).

In certain configuration, there was no possibilty detecting the
problem because there was not enough space left to store the LOST
record.In fact, there may be a more generic problem here. The kernel
should ensure that there is alaways enough space to store one LOST
record.

This patch sets the default watermark to half the buffer size. With
such limit, we are guaranteed to get a notification even with a single
page buffer assuming no sample is bigger than a page.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1256302576-6169-1-git-send-email-eranian@gmail.com>
---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2340,7 +2340,7 @@ perf_mmap_data_init(struct perf_event *e
 	}
 
 	if (!data->watermark)
-		data->watermark = max_t(long, PAGE_SIZE, max_size / 2);
+		data->watermark = max_size / 2;
 
 
 	rcu_assign_pointer(event->data, data);

-- 

